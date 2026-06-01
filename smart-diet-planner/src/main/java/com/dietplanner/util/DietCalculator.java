package com.dietplanner.util;

import com.dietplanner.model.Meal;
import java.sql.*;
import java.util.*;

public class DietCalculator {

    public static double calculateBMI(double weight, double heightCm) {
        double heightM = heightCm / 100.0;
        return weight / (heightM * heightM);
    }

    public static String getBMICategory(double bmi) {
        if (bmi < 18.5) return "Underweight";
        else if (bmi < 25) return "Normal";
        else if (bmi < 30) return "Overweight";
        else return "Obese";
    }

    public static int calculateCalories(double weight, double heightCm, int age,
                                        String gender, String goal) {
        double bmr;
        if ("male".equalsIgnoreCase(gender)) {
            bmr = 10 * weight + 6.25 * heightCm - 5 * age + 5;
        } else {
            bmr = 10 * weight + 6.25 * heightCm - 5 * age - 161;
        }
        if ("lose".equalsIgnoreCase(goal)) bmr -= 500;
        else if ("gain".equalsIgnoreCase(goal)) bmr += 500;
        return (int) Math.round(bmr * 1.2);
    }

    private static List<Meal> getFilteredMeals(String mealType, String dietType,
                                               Set<String> conditions, Set<String> allergies) {
        List<Meal> meals = new ArrayList<>();
        String sql = "SELECT id, name, calories, protein, reason FROM meals WHERE meal_type = ? AND diet_type = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, mealType);
            stmt.setString(2, dietType);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                int calories = rs.getInt("calories");
                int protein = rs.getInt("protein");
                String reason = rs.getString("reason");

                // Allergy filtering
                boolean allergySafe = true;
                if (!allergies.contains("none")) {
                    String nameLower = name.toLowerCase();
                    if (allergies.contains("gluten") &&
                        (nameLower.contains("bread") || nameLower.contains("pasta") ||
                         nameLower.contains("wrap") || nameLower.contains("pancakes") ||
                         nameLower.contains("toast") || nameLower.contains("sandwich"))) {
                        allergySafe = false;
                    }
                    if (allergies.contains("dairy") || allergies.contains("lactose")) {
                        if (nameLower.contains("yogurt") || nameLower.contains("cheese") ||
                            nameLower.contains("feta") || nameLower.contains("ricotta") ||
                            nameLower.contains("mozzarella") || nameLower.contains("milk") ||
                            nameLower.contains("cream") || nameLower.contains("cottage")) {
                            allergySafe = false;
                        }
                    }
                    if (allergies.contains("nuts") &&
                        (nameLower.contains("nut") || nameLower.contains("peanut") || 
                         nameLower.contains("almond"))) {
                        allergySafe = false;
                    }
                    if (allergies.contains("seafood") &&
                        (nameLower.contains("fish") || nameLower.contains("salmon") || 
                         nameLower.contains("tuna") || nameLower.contains("shrimp"))) {
                        allergySafe = false;
                    }
                    if (allergies.contains("soy") && nameLower.contains("tofu")) {
                        allergySafe = false;
                    }
                    if (allergies.contains("eggs") &&
                        (nameLower.contains("egg") || nameLower.contains("omelette"))) {
                        allergySafe = false;
                    }
                }
                if (!allergySafe) continue;

                // Enhance reason with health conditions
                StringBuilder enhancedReason = new StringBuilder(reason);
                if (conditions.contains("diabetes")) {
                    enhancedReason.append(" Low glycemic index helps control blood sugar.");
                }
                if (conditions.contains("low_iron") && name.toLowerCase().contains("spinach")) {
                    enhancedReason.append(" Rich in iron to fight anemia.");
                }
                if (conditions.contains("high_cholesterol") &&
                    (name.toLowerCase().contains("oatmeal") || name.toLowerCase().contains("lentil"))) {
                    enhancedReason.append(" Soluble fiber lowers cholesterol.");
                }
                if (conditions.contains("hypertension")) {
                    enhancedReason.append(" Naturally low in sodium.");
                }

                meals.add(new Meal(id, name, calories, protein, enhancedReason.toString()));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return meals;
    }

    public static Map<String, Map<String, Meal>> generateWeeklyPlan(String dietType,
                                                                    Set<String> conditions,
                                                                    Set<String> allergies) {
        Map<String, Map<String, Meal>> weekPlan = new LinkedHashMap<>();
        String[] days = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
        Random rand = new Random();

        for (String day : days) {
            Map<String, Meal> dailyMeals = new LinkedHashMap<>();

            List<Meal> breakfasts = getFilteredMeals("breakfast", dietType, conditions, allergies);
            List<Meal> lunches = getFilteredMeals("lunch", dietType, conditions, allergies);
            List<Meal> dinners = getFilteredMeals("dinner", dietType, conditions, allergies);

            dailyMeals.put("Breakfast", breakfasts.isEmpty() ?
                    new Meal("No suitable breakfast", 0, 0, "") :
                    breakfasts.get(rand.nextInt(breakfasts.size())));
            dailyMeals.put("Lunch", lunches.isEmpty() ?
                    new Meal("No suitable lunch", 0, 0, "") :
                    lunches.get(rand.nextInt(lunches.size())));
            dailyMeals.put("Dinner", dinners.isEmpty() ?
                    new Meal("No suitable dinner", 0, 0, "") :
                    dinners.get(rand.nextInt(dinners.size())));

            weekPlan.put(day, dailyMeals);
        }
        return weekPlan;
    }
}