package com.alphaomen.model;

import java.util.Date;
import java.sql.Timestamp;

public class Note {

    private int noteId;         
    private int userId;         
    private String title;        
    private String content;    
    private Timestamp createdAt;    
    private Timestamp updatedAt;      
    private boolean isPinned;    
    private String color;        
    private Date dueDate;        
    private Integer tagId;    
    private String tagName;
    private String voiceNotePath;

    // ===== Getters and Setters =====

    public int getNoteId() { return noteId; }
    public void setNoteId(int noteId) { this.noteId = noteId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public boolean isPinned() { return isPinned; }
    public void setPinned(boolean pinned) { isPinned = pinned; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }

    public Integer getTagId() { return tagId; }
    public void setTagId(Integer tagId) { this.tagId = tagId; }
    
    public String getTagName() { return tagName; }
    public void setTagName(String tagName) { this.tagName = tagName; }
    
    public String getVoiceNotePath() { return voiceNotePath; }
    public void setVoiceNotePath(String voiceNotePath) { this.voiceNotePath = voiceNotePath; }
}