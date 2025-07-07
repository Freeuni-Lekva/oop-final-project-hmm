package dto;

import java.util.Date;

/**
 * Data Transfer Object for QuizAttempt entity
 * Contains quiz attempt information for display on the website
 * Includes user and quiz information as DTOs instead of just IDs
 */
public class QuizAttemptDTO {
    private int attemptId;
    private UserDTO user;
    private QuizDTO quiz;
    private double score;
    private int totalQuestions;
    private long timeTaken; // Time in seconds
    private Date dateTaken;
    private boolean isPractice;
    
    // Default constructor
    public QuizAttemptDTO() {
    }
    
    // Constructor with all fields
    public QuizAttemptDTO(int attemptId, UserDTO user, QuizDTO quiz, double score, 
                         int totalQuestions, long timeTaken, Date dateTaken, boolean isPractice) {
        this.attemptId = attemptId;
        this.user = user;
        this.quiz = quiz;
        this.score = score;
        this.totalQuestions = totalQuestions;
        this.timeTaken = timeTaken;
        this.dateTaken = dateTaken;
        this.isPractice = isPractice;
    }
    
    // Helper method to calculate percentage score
    public double getPercentageScore() {
        if (totalQuestions == 0) return 0.0;
        return (score / totalQuestions) * 100.0;
    }
    
    // Helper method to format time taken
    public String getFormattedTimeTaken() {
        long hours = timeTaken / 3600;
        long minutes = (timeTaken % 3600) / 60;
        long seconds = timeTaken % 60;
        
        if (hours > 0) {
            return String.format("%dh %dm %ds", hours, minutes, seconds);
        } else if (minutes > 0) {
            return String.format("%dm %ds", minutes, seconds);
        } else {
            return String.format("%ds", seconds);
        }
    }
    
    // Getters and Setters
    public int getAttemptId() {
        return attemptId;
    }
    
    public void setAttemptId(int attemptId) {
        this.attemptId = attemptId;
    }
    
    public UserDTO getUser() {
        return user;
    }
    
    public void setUser(UserDTO user) {
        this.user = user;
    }
    
    public QuizDTO getQuiz() {
        return quiz;
    }
    
    public void setQuiz(QuizDTO quiz) {
        this.quiz = quiz;
    }
    
    public double getScore() {
        return score;
    }
    
    public void setScore(double score) {
        this.score = score;
    }
    
    public int getTotalQuestions() {
        return totalQuestions;
    }
    
    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }
    
    public long getTimeTaken() {
        return timeTaken;
    }
    
    public void setTimeTaken(long timeTaken) {
        this.timeTaken = timeTaken;
    }
    
    public Date getDateTaken() {
        return dateTaken;
    }
    
    public void setDateTaken(Date dateTaken) {
        this.dateTaken = dateTaken;
    }
    
    public boolean isPractice() {
        return isPractice;
    }
    
    public void setPractice(boolean practice) {
        isPractice = practice;
    }
    
    @Override
    public String toString() {
        return "QuizAttemptDTO{" +
                "attemptId=" + attemptId +
                ", user=" + user +
                ", quiz=" + quiz +
                ", score=" + score +
                ", totalQuestions=" + totalQuestions +
                ", timeTaken=" + timeTaken +
                ", dateTaken=" + dateTaken +
                ", isPractice=" + isPractice +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        QuizAttemptDTO that = (QuizAttemptDTO) obj;
        return attemptId == that.attemptId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(attemptId);
    }
} 