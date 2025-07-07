package dto;

import java.util.Date;

/**
 * Data Transfer Object for Message entity
 * Contains message information for display on the website
 * Includes sender and receiver as UserDTOs and quiz information for challenge messages
 */
public class MessageDTO {
    private int messageId;
    private UserDTO sender;
    private UserDTO receiver;
    private String messageType;
    private String content;
    private QuizDTO quiz; // Only for challenge messages
    private Date dateSent;
    private boolean isRead;
    
    // Message type constants
    public static final String TYPE_FRIEND_REQUEST = "friend_request";
    public static final String TYPE_CHALLENGE = "challenge";
    public static final String TYPE_NOTE = "note";
    
    // Default constructor
    public MessageDTO() {
    }
    
    // Constructor with all fields
    public MessageDTO(int messageId, UserDTO sender, UserDTO receiver, String messageType, 
                     String content, QuizDTO quiz, Date dateSent, boolean isRead) {
        this.messageId = messageId;
        this.sender = sender;
        this.receiver = receiver;
        this.messageType = messageType;
        this.content = content;
        this.quiz = quiz;
        this.dateSent = dateSent;
        this.isRead = isRead;
    }
    
    // Helper methods for message type checking
    public boolean isFriendRequest() {
        return TYPE_FRIEND_REQUEST.equals(messageType);
    }
    
    public boolean isChallenge() {
        return TYPE_CHALLENGE.equals(messageType);
    }
    
    public boolean isNote() {
        return TYPE_NOTE.equals(messageType);
    }
    
    // Helper method to get a short preview of the content
    public String getContentPreview(int maxLength) {
        if (content == null) return "";
        if (content.length() <= maxLength) return content;
        return content.substring(0, maxLength) + "...";
    }
    
    // Helper method to format date sent
    public String getFormattedDateSent() {
        if (dateSent == null) return "";
        
        long now = System.currentTimeMillis();
        long messageTime = dateSent.getTime();
        long diffInSeconds = (now - messageTime) / 1000;
        
        if (diffInSeconds < 60) {
            return "Just now";
        } else if (diffInSeconds < 3600) {
            long minutes = diffInSeconds / 60;
            return minutes + " minute" + (minutes > 1 ? "s" : "") + " ago";
        } else if (diffInSeconds < 86400) {
            long hours = diffInSeconds / 3600;
            return hours + " hour" + (hours > 1 ? "s" : "") + " ago";
        } else {
            long days = diffInSeconds / 86400;
            return days + " day" + (days > 1 ? "s" : "") + " ago";
        }
    }
    
    // Getters and Setters
    public int getMessageId() {
        return messageId;
    }
    
    public void setMessageId(int messageId) {
        this.messageId = messageId;
    }
    
    public UserDTO getSender() {
        return sender;
    }
    
    public void setSender(UserDTO sender) {
        this.sender = sender;
    }
    
    public UserDTO getReceiver() {
        return receiver;
    }
    
    public void setReceiver(UserDTO receiver) {
        this.receiver = receiver;
    }
    
    public String getMessageType() {
        return messageType;
    }
    
    public void setMessageType(String messageType) {
        this.messageType = messageType;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public QuizDTO getQuiz() {
        return quiz;
    }
    
    public void setQuiz(QuizDTO quiz) {
        this.quiz = quiz;
    }
    
    public Date getDateSent() {
        return dateSent;
    }
    
    public void setDateSent(Date dateSent) {
        this.dateSent = dateSent;
    }
    
    public boolean isRead() {
        return isRead;
    }
    
    public void setRead(boolean read) {
        isRead = read;
    }
    
    @Override
    public String toString() {
        return "MessageDTO{" +
                "messageId=" + messageId +
                ", sender=" + sender +
                ", receiver=" + receiver +
                ", messageType='" + messageType + '\'' +
                ", content='" + content + '\'' +
                ", quiz=" + quiz +
                ", dateSent=" + dateSent +
                ", isRead=" + isRead +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        MessageDTO that = (MessageDTO) obj;
        return messageId == that.messageId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(messageId);
    }
} 