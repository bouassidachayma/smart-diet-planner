package com.dietplanner.model;

public class Meal {
    private int id;
    private String name;
    private int calories;
    private int protein;
    private String reason;

    public Meal(int id, String name, int calories, int protein, String reason) {
        this.id = id;
        this.name = name;
        this.calories = calories;
        this.protein = protein;
        this.reason = reason;
    }

    // Constructor without id (for fallback or "no meal")
    public Meal(String name, int calories, int protein, String reason) {
        this(-1, name, calories, protein, reason);
    }

    // Getters
    public int getId() { return id; }
    public String getName() { return name; }
    public int getCalories() { return calories; }
    public int getProtein() { return protein; }
    public String getReason() { return reason; }
}