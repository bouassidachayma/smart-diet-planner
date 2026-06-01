package com.dietplanner.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/chatbot")
public class ChatbotServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("text/plain; charset=UTF-8");
        PrintWriter out = resp.getWriter();
        out.print("🤖 Chatbot is active! Send POST requests with 'message' parameter to talk to me.");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String message = req.getParameter("message");
        String reply = getBotReply(message);

        resp.setContentType("text/plain; charset=UTF-8");
        PrintWriter out = resp.getWriter();
        out.print(reply);
    }

    private String getBotReply(String msg) {
        if (msg == null || msg.trim().isEmpty()) {
            return "I didn't catch that. Can you repeat?";
        }
        String lower = msg.toLowerCase();

        // Diet plan feedback
        if (lower.contains("my diet") || lower.contains("meal plan")) {
            return "Your meal plan is personalized based on your BMI, goal, and health conditions. Each day's calories are shown with a progress bar. If you need adjustments, you can regenerate the plan!";
        }
        if (lower.contains("calorie") || lower.contains("kcal")) {
            return "Calories are units of energy. Your daily goal is calculated based on your BMI and activity level. Check the progress bar on each day card!";
        }
        if (lower.contains("protein")) {
            return "Protein helps build and repair muscles. Aim for about 0.8g per kg of body weight, or more if you're active.";
        }
        if (lower.contains("bmi")) {
            return "BMI (Body Mass Index) is a measure of body fat based on height and weight. A normal range is 18.5–24.9.";
        }
        if (lower.contains("vegetarian") || lower.contains("vegan")) {
            return "We offer vegetarian and vegan meal plans! Just select your diet type in the form.";
        }
        if (lower.contains("diabetes")) {
            return "For diabetes, we suggest low‑sugar meals with high fiber. Oatmeal, lentils, and leafy greens are great options.";
        }
        if (lower.contains("cholesterol")) {
            return "To lower cholesterol, focus on soluble fiber (oats, beans) and healthy fats (avocado, nuts).";
        }
        if (lower.contains("iron") || lower.contains("anemia")) {
            return "Iron‑rich foods include spinach, lentils, and red meat. Pair them with vitamin C for better absorption.";
        }
        if (lower.contains("weight loss") || lower.contains("lose weight")) {
            return "To lose weight, we subtract 500 kcal from your maintenance calories. Combine with regular exercise!";
        }
        if (lower.contains("gain weight") || lower.contains("muscle")) {
            return "To gain weight healthily, we add 500 kcal to your maintenance. Include protein‑rich meals.";
        }
        if (lower.contains("hello") || lower.contains("hi") || lower.contains("hey")) {
            return "Hello! I'm your diet assistant. Ask me about calories, protein, BMI, or health conditions.";
        }
        if (lower.contains("thank")) {
            return "You're welcome! 😊";
        }

        return "I'm not sure about that. Try asking about calories, protein, BMI, or specific health conditions.";
    }
}