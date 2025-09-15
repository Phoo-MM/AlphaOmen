package com.alphaomen.model;

import java.sql.Timestamp;
import java.util.Date;

public class User {
    private int userId;
    private String username;
    private String email;
    private String password;
    private int planId;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp lastLogin;
    private boolean isVerified;
    private boolean isAdmin;
    private int noteCount;
    private String premiumPlan;
    private Date premiumStart;
    private Date premiumExpiry;
    
    // Constructors
    public User() {}
    
    public User(String username, String email, String password, int planId) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.planId = planId;
    }
    
    // Getters and Setters
    public int getId() { return userId; }
    public void setId(int userId) { this.userId = userId; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public int getPlanId() { return planId; }
    public void setPlanId(int planId) { this.planId = planId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public Timestamp getLastLogin() { return lastLogin; }
    public void setLastLogin(Timestamp lastLogin) { this.lastLogin = lastLogin; }
    
    public boolean isVerified() { return isVerified; }
    public void setVerified(boolean verified) { isVerified = verified; }

    public boolean isAdmin() { return isAdmin; }
    public void setAdmin(boolean isAdmin) { this.isAdmin = isAdmin; }

    public int getNoteCount() { return noteCount; }
    public void setNoteCount(int noteCount) { this.noteCount = noteCount; }

    public String getPremiumPlan() { return premiumPlan; }
    public void setPremiumPlan(String premiumPlan) { this.premiumPlan = premiumPlan; }

    public Date getPremiumStart() { return premiumStart; }
    public void setPremiumStart(Date premiumStart) { this.premiumStart = premiumStart; }
    
    public Date getPremiumExpiry() { return premiumExpiry; }
    public void setPremiumExpiry(Date premiumExpiry) { this.premiumExpiry = premiumExpiry; }
}