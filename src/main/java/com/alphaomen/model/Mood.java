package com.alphaomen.model;

import java.util.Date;

public class Mood {

    private int moodId;         
    private int userId;         
    private String moodValue;  
    private Date moodDate;    

    // ===== Getters and Setters =====

    public int getMoodId() { return moodId; }
    public void setMoodId(int moodId) { this.moodId = moodId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getMoodValue() { return moodValue; }
    public void setMoodValue(String moodValue) { this.moodValue = moodValue; }

    public Date getMoodDate() { return moodDate; }
    public void setMoodDate(Date moodDate) { this.moodDate = moodDate; }

}