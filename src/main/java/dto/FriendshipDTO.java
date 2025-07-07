package dto;

import java.util.Date;

/**
 * Data Transfer Object for Friendship entity
 * Contains friendship information for display on the website
 * Includes both users as UserDTOs and friendship status
 */
public class FriendshipDTO {
    private int friendshipId;
    private UserDTO requester;
    private UserDTO receiver;
    private String status;
    private Date dateRequested;
    private Date dateAccepted;
    
    // Friendship status constants
    public static final String STATUS_PENDING = "pending";
    public static final String STATUS_ACCEPTED = "accepted";
    public static final String STATUS_DECLINED = "declined";
    public static final String STATUS_BLOCKED = "blocked";
    
    // Default constructor
    public FriendshipDTO() {
    }
    
    // Constructor with all fields
    public FriendshipDTO(int friendshipId, UserDTO requester, UserDTO receiver, 
                        String status, Date dateRequested, Date dateAccepted) {
        this.friendshipId = friendshipId;
        this.requester = requester;
        this.receiver = receiver;
        this.status = status;
        this.dateRequested = dateRequested;
        this.dateAccepted = dateAccepted;
    }
    
    // Helper methods for status checking
    public boolean isPending() {
        return STATUS_PENDING.equals(status);
    }
    
    public boolean isAccepted() {
        return STATUS_ACCEPTED.equals(status);
    }
    
    public boolean isDeclined() {
        return STATUS_DECLINED.equals(status);
    }
    
    public boolean isBlocked() {
        return STATUS_BLOCKED.equals(status);
    }
    
    // Helper method to get the other user in the friendship
    public UserDTO getOtherUser(int currentUserId) {
        if (requester != null && requester.getUserId() == currentUserId) {
            return receiver;
        } else if (receiver != null && receiver.getUserId() == currentUserId) {
            return requester;
        }
        return null;
    }
    
    // Helper method to check if a user is the requester
    public boolean isRequester(int userId) {
        return requester != null && requester.getUserId() == userId;
    }
    
    // Helper method to check if a user is the receiver
    public boolean isReceiver(int userId) {
        return receiver != null && receiver.getUserId() == userId;
    }
    
    // Getters and Setters
    public int getFriendshipId() {
        return friendshipId;
    }
    
    public void setFriendshipId(int friendshipId) {
        this.friendshipId = friendshipId;
    }
    
    public UserDTO getRequester() {
        return requester;
    }
    
    public void setRequester(UserDTO requester) {
        this.requester = requester;
    }
    
    public UserDTO getReceiver() {
        return receiver;
    }
    
    public void setReceiver(UserDTO receiver) {
        this.receiver = receiver;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Date getDateRequested() {
        return dateRequested;
    }
    
    public void setDateRequested(Date dateRequested) {
        this.dateRequested = dateRequested;
    }
    
    public Date getDateAccepted() {
        return dateAccepted;
    }
    
    public void setDateAccepted(Date dateAccepted) {
        this.dateAccepted = dateAccepted;
    }
    
    @Override
    public String toString() {
        return "FriendshipDTO{" +
                "friendshipId=" + friendshipId +
                ", requester=" + requester +
                ", receiver=" + receiver +
                ", status='" + status + '\'' +
                ", dateRequested=" + dateRequested +
                ", dateAccepted=" + dateAccepted +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        FriendshipDTO that = (FriendshipDTO) obj;
        return friendshipId == that.friendshipId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(friendshipId);
    }
} 