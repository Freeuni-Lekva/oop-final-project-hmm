package dto;

import java.util.Date;

/**
 * Data Transfer Object for Achievement entity
 * Contains achievement information for display on the website
 * Includes user who earned it and achievement details
 */
public class AchievementDTO {
    private int achievementId;
    private UserDTO user;
    private String achievementType;
    private Date dateEarned;
    private String description;
    
    // Achievement type constants
    public static final String TYPE_AMATEUR_AUTHOR = "amateur_author";
    public static final String TYPE_PROLIFIC_AUTHOR = "prolific_author";
    public static final String TYPE_PRODIGIOUS_AUTHOR = "prodigious_author";
    public static final String TYPE_QUIZ_MACHINE = "quiz_machine";
    public static final String TYPE_I_AM_THE_GREATEST = "i_am_the_greatest";
    public static final String TYPE_PRACTICE_MAKES_PERFECT = "practice_makes_perfect";
    
    // Default constructor
    public AchievementDTO() {
    }
    
    // Constructor with all fields
    public AchievementDTO(int achievementId, UserDTO user, String achievementType, 
                         Date dateEarned, String description) {
        this.achievementId = achievementId;
        this.user = user;
        this.achievementType = achievementType;
        this.dateEarned = dateEarned;
        this.description = description;
    }
    
    // Helper methods for achievement type checking
    public boolean isAmateurAuthor() {
        return TYPE_AMATEUR_AUTHOR.equals(achievementType);
    }
    
    public boolean isProlificAuthor() {
        return TYPE_PROLIFIC_AUTHOR.equals(achievementType);
    }
    
    public boolean isProdigiousAuthor() {
        return TYPE_PRODIGIOUS_AUTHOR.equals(achievementType);
    }
    
    public boolean isQuizMachine() {
        return TYPE_QUIZ_MACHINE.equals(achievementType);
    }
    
    public boolean isIAmTheGreatest() {
        return TYPE_I_AM_THE_GREATEST.equals(achievementType);
    }
    
    public boolean isPracticeMakesPerfect() {
        return TYPE_PRACTICE_MAKES_PERFECT.equals(achievementType);
    }
    
    // Helper method to get achievement display name
    public String getDisplayName() {
        switch (achievementType) {
            case TYPE_AMATEUR_AUTHOR:
                return "Amateur Author";
            case TYPE_PROLIFIC_AUTHOR:
                return "Prolific Author";
            case TYPE_PRODIGIOUS_AUTHOR:
                return "Prodigious Author";
            case TYPE_QUIZ_MACHINE:
                return "Quiz Machine";
            case TYPE_I_AM_THE_GREATEST:
                return "I am the Greatest";
            case TYPE_PRACTICE_MAKES_PERFECT:
                return "Practice Makes Perfect";
            default:
                return "Unknown Achievement";
        }
    }
    
    // Helper method to get achievement icon (you can customize this)
    public String getIconClass() {
        switch (achievementType) {
            case TYPE_AMATEUR_AUTHOR:
                return "achievement-icon amateur-author";
            case TYPE_PROLIFIC_AUTHOR:
                return "achievement-icon prolific-author";
            case TYPE_PRODIGIOUS_AUTHOR:
                return "achievement-icon prodigious-author";
            case TYPE_QUIZ_MACHINE:
                return "achievement-icon quiz-machine";
            case TYPE_I_AM_THE_GREATEST:
                return "achievement-icon greatest";
            case TYPE_PRACTICE_MAKES_PERFECT:
                return "achievement-icon practice";
            default:
                return "achievement-icon default";
        }
    }
    
    // Helper method to format date earned
    public String getFormattedDateEarned() {
        if (dateEarned == null) return "";
        
        long now = System.currentTimeMillis();
        long earnedTime = dateEarned.getTime();
        long diffInSeconds = (now - earnedTime) / 1000;
        
        if (diffInSeconds < 60) {
            return "Just earned";
        } else if (diffInSeconds < 3600) {
            long minutes = diffInSeconds / 60;
            return "Earned " + minutes + " minute" + (minutes > 1 ? "s" : "") + " ago";
        } else if (diffInSeconds < 86400) {
            long hours = diffInSeconds / 3600;
            return "Earned " + hours + " hour" + (hours > 1 ? "s" : "") + " ago";
        } else {
            long days = diffInSeconds / 86400;
            return "Earned " + days + " day" + (days > 1 ? "s" : "") + " ago";
        }
    }
    
    // Getters and Setters
    public int getAchievementId() {
        return achievementId;
    }
    
    public void setAchievementId(int achievementId) {
        this.achievementId = achievementId;
    }
    
    public UserDTO getUser() {
        return user;
    }
    
    public void setUser(UserDTO user) {
        this.user = user;
    }
    
    public String getAchievementType() {
        return achievementType;
    }
    
    public void setAchievementType(String achievementType) {
        this.achievementType = achievementType;
    }
    
    public Date getDateEarned() {
        return dateEarned;
    }
    
    public void setDateEarned(Date dateEarned) {
        this.dateEarned = dateEarned;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    @Override
    public String toString() {
        return "AchievementDTO{" +
                "achievementId=" + achievementId +
                ", user=" + user +
                ", achievementType='" + achievementType + '\'' +
                ", dateEarned=" + dateEarned +
                ", description='" + description + '\'' +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        AchievementDTO that = (AchievementDTO) obj;
        return achievementId == that.achievementId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(achievementId);
    }
} 