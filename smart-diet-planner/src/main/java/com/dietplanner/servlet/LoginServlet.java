package com.dietplanner.servlet;

import com.dietplanner.util.DatabaseConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String login = req.getParameter("login");
        String password = req.getParameter("password");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "SELECT id, username, full_name FROM users WHERE username = ? AND password = ?")) {

            stmt.setString(1, login);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                HttpSession session = req.getSession();
                session.setAttribute("user", rs.getString("username"));
                session.setAttribute("fullName", rs.getString("full_name"));
                session.setAttribute("userId", rs.getInt("id"));   // ← store user ID
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
            } else {
                req.setAttribute("erreur", "Login ou mot de passe incorrect");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("erreur", "Erreur de connexion à la base de données");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}