package com.dietplanner.servlet;

import com.dietplanner.util.DatabaseConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        if (fullName == null || username == null || password == null ||
            fullName.trim().isEmpty() || username.trim().isEmpty() || password.trim().isEmpty()) {
            req.setAttribute("erreur", "Tous les champs sont obligatoires.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("erreur", "Les mots de passe ne correspondent pas.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Check if username exists
            try (PreparedStatement checkStmt = conn.prepareStatement(
                    "SELECT id FROM users WHERE username = ?")) {
                checkStmt.setString(1, username);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    req.setAttribute("erreur", "Ce nom d'utilisateur existe déjà.");
                    req.getRequestDispatcher("/register.jsp").forward(req, resp);
                    return;
                }
            }

            // Insert new user and get the generated ID
            try (PreparedStatement insertStmt = conn.prepareStatement(
                    "INSERT INTO users (username, password, full_name) VALUES (?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS)) {
                insertStmt.setString(1, username);
                insertStmt.setString(2, password);
                insertStmt.setString(3, fullName);
                insertStmt.executeUpdate();

                ResultSet generatedKeys = insertStmt.getGeneratedKeys();
                int userId = -1;
                if (generatedKeys.next()) {
                    userId = generatedKeys.getInt(1);
                }

                // Auto-login
                HttpSession session = req.getSession();
                session.setAttribute("user", username);
                session.setAttribute("fullName", fullName);
                session.setAttribute("userId", userId);
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("erreur", "Erreur lors de l'inscription.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}