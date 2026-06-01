package com.dietplanner.servlet;

import com.dietplanner.model.Meal;
import com.dietplanner.util.DatabaseConnection;
import com.dietplanner.util.DietCalculator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/plan")
public class DietPlannerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        double weight = Double.parseDouble(request.getParameter("weight"));
        double height = Double.parseDouble(request.getParameter("height"));
        int age = Integer.parseInt(request.getParameter("age"));
        String gender = request.getParameter("gender");
        String dietType = request.getParameter("dietType");
        String goal = request.getParameter("goal");

        String conditionsParam = request.getParameter("conditions");
        String allergiesParam = request.getParameter("allergies");

        Set<String> conditions = new HashSet<>();
        if (conditionsParam != null && !conditionsParam.isEmpty()) {
            conditions.addAll(Arrays.asList(conditionsParam.split(",")));
        }
        Set<String> allergies = new HashSet<>();
        if (allergiesParam != null && !allergiesParam.isEmpty()) {
            allergies.addAll(Arrays.asList(allergiesParam.split(",")));
        }

        double bmi = DietCalculator.calculateBMI(weight, height);
        String bmiCategory = DietCalculator.getBMICategory(bmi);
        int calories = DietCalculator.calculateCalories(weight, height, age, gender, goal);
        Map<String, Map<String, Meal>> weekPlan = DietCalculator.generateWeeklyPlan(dietType, conditions, allergies);

        // Save the plan to the database if user is logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            int userId = (Integer) session.getAttribute("userId");
            java.sql.Date planDate = new java.sql.Date(System.currentTimeMillis());

            String insertSQL = "INSERT INTO user_plans (user_id, plan_date, meal_type, meal_id) VALUES (?, ?, ?, ?)";
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(insertSQL)) {

                for (Map.Entry<String, Map<String, Meal>> dayEntry : weekPlan.entrySet()) {
                    for (Map.Entry<String, Meal> mealEntry : dayEntry.getValue().entrySet()) {
                        String mealType = mealEntry.getKey();
                        Meal meal = mealEntry.getValue();
                        // Only save if it's a real meal (id > 0) – skip fallback meals with id -1
                        if (meal.getId() > 0) {
                            ps.setInt(1, userId);
                            ps.setDate(2, planDate);
                            ps.setString(3, mealType);
                            ps.setInt(4, meal.getId());
                            ps.executeUpdate();
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                // Even if saving fails, the plan is still shown
            }
        }

        // Forward to result page
        request.setAttribute("name", name);
        request.setAttribute("bmi", String.format("%.1f", bmi));
        request.setAttribute("bmiCategory", bmiCategory);
        request.setAttribute("calories", calories);
        request.setAttribute("weekPlan", weekPlan);
        request.getRequestDispatcher("/WEB-INF/views/result.jsp").forward(request, response);
    }
}