package com.alphaomen.model;

public class Ad {
    private int adId;
    private String title;
    private String content;
    private String imageUrl;
    private String linkUrl;
    private int isActive;
    private String displayType;
    private String displayPosition;

    // Getters and Setters
    public int getAdId() { return adId; }
    public void setAdId(int adId) { this.adId = adId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getLinkUrl() { return linkUrl; }
    public void setLinkUrl(String linkUrl) { this.linkUrl = linkUrl; }
    
    public int getIsActive() { return isActive; }
    public void setIsActive(int isActive) { this.isActive = isActive; }
    
    public String getDisplayType() { return displayType; }
    public void setDisplayType(String displayType) { this.displayType = displayType; }
    
    public String getDisplayPosition() { return displayPosition; }
    public void setDisplayPosition(String displayPosition) { this.displayPosition = displayPosition; }
}