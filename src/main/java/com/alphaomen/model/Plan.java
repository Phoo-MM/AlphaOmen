package com.alphaomen.model;

public class Plan {
    private int planId;
    private String name;
    private boolean adsEnabled;
    private double price;
    private int durationMonths;

    // Getters and Setters
    public int getPlanId() { return planId; }
    public void setPlanId(int planId) { this.planId = planId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public boolean isAdsEnabled() { return adsEnabled; }
    public void setAdsEnabled(boolean adsEnabled) { this.adsEnabled = adsEnabled; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getDurationMonths() { return durationMonths; }
    public void setDurationMonths(int durationMonths) { this.durationMonths = durationMonths; }
}
