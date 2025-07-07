package dto;

import java.util.Date;

/**
 * Data Transfer Object for User entity
 * Contains only safe, public information that can be displayed on the website
 * Excludes sensitive data like password hash
 */
public class UserDTO {
    private int userId;
    private String username;
    private String email;
    private Date createdDate;
    private boolean isAdmin;
    
    // Default constructor
    public UserDTO() {
    }
    
    // Constructor from User model
    public UserDTO(int userId, String username, String email, Date createdDate, boolean isAdmin) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.createdDate = createdDate;
        this.isAdmin = isAdmin;
    }
    
    // Getters and Setters
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public Date getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
    
    public boolean isAdmin() {
        return isAdmin;
    }
    
    public void setAdmin(boolean admin) {
        isAdmin = admin;
    }
    
    @Override
    public String toString() {
        return "UserDTO{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", createdDate=" + createdDate +
                ", isAdmin=" + isAdmin +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        UserDTO userDTO = (UserDTO) obj;
        return userId == userDTO.userId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(userId);
    }
} 