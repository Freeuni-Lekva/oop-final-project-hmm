package dto;

import java.util.Date;

/**
 * Data Transfer Object for Quiz entity
 * Contains quiz information for display on the website
 * Includes creator information as UserDTO instead of just creator ID
 */
public class QuizDTO {
    private int quizId;
    private String title;
    private String description;
    private UserDTO creator;
    private boolean randomOrder;
    private boolean onePage;
    private boolean immediateCorrection;
    private boolean practiceMode;
    private Date createdDate;
    
    // Default constructor
    public QuizDTO() {
    }
    
    // Constructor with basic quiz information
    public QuizDTO(int quizId, String title, String description, UserDTO creator, 
                   boolean randomOrder, boolean onePage, boolean immediateCorrection, 
                   boolean practiceMode, Date createdDate) {
        this.quizId = quizId;
        this.title = title;
        this.description = description;
        this.creator = creator;
        this.randomOrder = randomOrder;
        this.onePage = onePage;
        this.immediateCorrection = immediateCorrection;
        this.practiceMode = practiceMode;
        this.createdDate = createdDate;
    }
    
    // Getters and Setters
    public int getQuizId() {
        return quizId;
    }
    
    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public UserDTO getCreator() {
        return creator;
    }
    
    public void setCreator(UserDTO creator) {
        this.creator = creator;
    }
    
    public boolean isRandomOrder() {
        return randomOrder;
    }
    
    public void setRandomOrder(boolean randomOrder) {
        this.randomOrder = randomOrder;
    }
    
    public boolean isOnePage() {
        return onePage;
    }
    
    public void setOnePage(boolean onePage) {
        this.onePage = onePage;
    }
    
    public boolean isImmediateCorrection() {
        return immediateCorrection;
    }
    
    public void setImmediateCorrection(boolean immediateCorrection) {
        this.immediateCorrection = immediateCorrection;
    }
    
    public boolean isPracticeMode() {
        return practiceMode;
    }
    
    public void setPracticeMode(boolean practiceMode) {
        this.practiceMode = practiceMode;
    }
    
    public Date getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
    
    @Override
    public String toString() {
        return "QuizDTO{" +
                "quizId=" + quizId +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", creator=" + creator +
                ", randomOrder=" + randomOrder +
                ", onePage=" + onePage +
                ", immediateCorrection=" + immediateCorrection +
                ", practiceMode=" + practiceMode +
                ", createdDate=" + createdDate +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        QuizDTO quizDTO = (QuizDTO) obj;
        return quizId == quizDTO.quizId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(quizId);
    }
} 