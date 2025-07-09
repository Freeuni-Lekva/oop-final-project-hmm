package dao;

import model.Announcement;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Data Access Object for Announcement entity
 * Provides full CRUD operations and announcement-specific functionality
 */
public class AnnouncementDAO {
    
    private Connection connection;
    
    // Constructor that takes a database connection
    public AnnouncementDAO(Connection connection) {
        this.connection = connection;
    }
    
    // ========================= CREATE OPERATIONS =========================
    
    /**
     * Create a new announcement
     * @param announcement Announcement object with title, content, and creator ID
     * @return The created announcement with generated ID, or null if creation failed
     * @throws SQLException If database error occurs
     */
    public Announcement createAnnouncement(Announcement announcement) throws SQLException {
        String sql = "INSERT INTO announcements (title, content, created_by, created_date, is_active, priority) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, announcement.getTitle());
            stmt.setString(2, announcement.getContent());
            stmt.setInt(3, announcement.getCreatedBy());
            stmt.setTimestamp(4, new Timestamp(announcement.getCreatedDate().getTime()));
            stmt.setBoolean(5, announcement.isActive());
            stmt.setString(6, announcement.getPriority().getValue());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                return null;
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    announcement.setId(generatedKeys.getInt(1));
                    return announcement;
                }
            }
        }
        return null;
    }
    
    /**
     * Create a new announcement with specified priority
     * @param title Announcement title
     * @param content Announcement content
     * @param createdBy ID of the user creating the announcement
     * @param priority Priority level
     * @return The created announcement, or null if creation failed
     * @throws SQLException If database error occurs
     */
    public Announcement createAnnouncement(String title, String content, int createdBy, Announcement.Priority priority) throws SQLException {
        Announcement announcement = new Announcement(title, content, createdBy, priority);
        return createAnnouncement(announcement);
    }
    
    /**
     * Create a new announcement with default priority (MEDIUM)
     * @param title Announcement title
     * @param content Announcement content
     * @param createdBy ID of the user creating the announcement
     * @return The created announcement, or null if creation failed
     * @throws SQLException If database error occurs
     */
    public Announcement createAnnouncement(String title, String content, int createdBy) throws SQLException {
        Announcement announcement = new Announcement(title, content, createdBy);
        return createAnnouncement(announcement);
    }
    
    // ========================= READ OPERATIONS =========================
    
    /**
     * Find announcement by ID
     * @param id The announcement ID
     * @return Announcement object or null if not found
     * @throws SQLException If database error occurs
     */
    public Announcement findById(int id) throws SQLException {
        String sql = "SELECT id, title, content, created_by, created_date, is_active, priority FROM announcements WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToAnnouncement(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * Get all active announcements ordered by priority (HIGH first) and creation date (newest first)
     * @return List of active announcements
     * @throws SQLException If database error occurs
     */
    public List<Announcement> getActiveAnnouncements() throws SQLException {
        String sql = "SELECT id, title, content, created_by, created_date, is_active, priority " +
                    "FROM announcements WHERE is_active = TRUE " +
                    "ORDER BY CASE priority WHEN 'high' THEN 1 WHEN 'medium' THEN 2 WHEN 'low' THEN 3 END, " +
                    "created_date DESC";
        List<Announcement> announcements = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    announcements.add(mapRowToAnnouncement(rs));
                }
            }
        }
        return announcements;
    }
    
    /**
     * Get all announcements (active and inactive) with pagination
     * @param offset Starting position (0-based)
     * @param limit Maximum number of announcements to return
     * @return List of announcements
     * @throws SQLException If database error occurs
     */
    public List<Announcement> getAllAnnouncements(int offset, int limit) throws SQLException {
        String sql = "SELECT id, title, content, created_by, created_date, is_active, priority " +
                    "FROM announcements " +
                    "ORDER BY created_date DESC LIMIT ? OFFSET ?";
        List<Announcement> announcements = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    announcements.add(mapRowToAnnouncement(rs));
                }
            }
        }
        return announcements;
    }
    
    /**
     * Get all announcements (use with caution for large datasets)
     * @return List of all announcements
     * @throws SQLException If database error occurs
     */
    public List<Announcement> getAllAnnouncements() throws SQLException {
        String sql = "SELECT id, title, content, created_by, created_date, is_active, priority " +
                    "FROM announcements ORDER BY created_date DESC";
        List<Announcement> announcements = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    announcements.add(mapRowToAnnouncement(rs));
                }
            }
        }
        return announcements;
    }
    
    /**
     * Get announcements by priority
     * @param priority Priority level to filter by
     * @param activeOnly Whether to include only active announcements
     * @return List of announcements with specified priority
     * @throws SQLException If database error occurs
     */
    public List<Announcement> getAnnouncementsByPriority(Announcement.Priority priority, boolean activeOnly) throws SQLException {
        String sql = "SELECT id, title, content, created_by, created_date, is_active, priority " +
                    "FROM announcements WHERE priority = ?";
        
        if (activeOnly) {
            sql += " AND is_active = TRUE";
        }
        
        sql += " ORDER BY created_date DESC";
        
        List<Announcement> announcements = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, priority.getValue());
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    announcements.add(mapRowToAnnouncement(rs));
                }
            }
        }
        return announcements;
    }
    
    /**
     * Get announcements created by a specific user
     * @param createdBy User ID of the creator
     * @return List of announcements created by the user
     * @throws SQLException If database error occurs
     */
    public List<Announcement> getAnnouncementsByCreator(int createdBy) throws SQLException {
        String sql = "SELECT id, title, content, created_by, created_date, is_active, priority " +
                    "FROM announcements WHERE created_by = ? ORDER BY created_date DESC";
        List<Announcement> announcements = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, createdBy);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    announcements.add(mapRowToAnnouncement(rs));
                }
            }
        }
        return announcements;
    }
    
    /**
     * Search announcements by title or content
     * @param searchTerm Search term to look for in title or content
     * @param activeOnly Whether to include only active announcements
     * @return List of matching announcements
     * @throws SQLException If database error occurs
     */
    public List<Announcement> searchAnnouncements(String searchTerm, boolean activeOnly) throws SQLException {
        String sql = "SELECT id, title, content, created_by, created_date, is_active, priority " +
                    "FROM announcements WHERE (title LIKE ? OR content LIKE ?)";
        
        if (activeOnly) {
            sql += " AND is_active = TRUE";
        }
        
        sql += " ORDER BY created_date DESC";
        
        List<Announcement> announcements = new ArrayList<>();
        String searchPattern = "%" + searchTerm + "%";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    announcements.add(mapRowToAnnouncement(rs));
                }
            }
        }
        return announcements;
    }
    
    // ========================= UPDATE OPERATIONS =========================
    
    /**
     * Update an existing announcement
     * @param announcement Announcement with updated information
     * @return true if update was successful, false otherwise
     * @throws SQLException If database error occurs
     */
    public boolean updateAnnouncement(Announcement announcement) throws SQLException {
        String sql = "UPDATE announcements SET title = ?, content = ?, is_active = ?, priority = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, announcement.getTitle());
            stmt.setString(2, announcement.getContent());
            stmt.setBoolean(3, announcement.isActive());
            stmt.setString(4, announcement.getPriority().getValue());
            stmt.setInt(5, announcement.getId());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Update announcement title and content
     * @param id Announcement ID
     * @param title New title
     * @param content New content
     * @return true if update was successful, false otherwise
     * @throws SQLException If database error occurs
     */
    public boolean updateAnnouncementContent(int id, String title, String content) throws SQLException {
        String sql = "UPDATE announcements SET title = ?, content = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, title);
            stmt.setString(2, content);
            stmt.setInt(3, id);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Update announcement priority
     * @param id Announcement ID
     * @param priority New priority
     * @return true if update was successful, false otherwise
     * @throws SQLException If database error occurs
     */
    public boolean updateAnnouncementPriority(int id, Announcement.Priority priority) throws SQLException {
        String sql = "UPDATE announcements SET priority = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, priority.getValue());
            stmt.setInt(2, id);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Activate or deactivate an announcement
     * @param id Announcement ID
     * @param isActive New active status
     * @return true if update was successful, false otherwise
     * @throws SQLException If database error occurs
     */
    public boolean setAnnouncementStatus(int id, boolean isActive) throws SQLException {
        String sql = "UPDATE announcements SET is_active = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBoolean(1, isActive);
            stmt.setInt(2, id);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    // ========================= DELETE OPERATIONS =========================
    
    /**
     * Delete an announcement permanently
     * @param id Announcement ID
     * @return true if deletion was successful, false otherwise
     * @throws SQLException If database error occurs
     */
    public boolean deleteAnnouncement(int id) throws SQLException {
        String sql = "DELETE FROM announcements WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Delete all inactive announcements older than specified days
     * @param daysOld Number of days - announcements older than this will be deleted
     * @return Number of announcements deleted
     * @throws SQLException If database error occurs
     */
    public int deleteOldInactiveAnnouncements(int daysOld) throws SQLException {
        String sql = "DELETE FROM announcements WHERE is_active = FALSE AND created_date < DATE_SUB(NOW(), INTERVAL ? DAY)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, daysOld);
            return stmt.executeUpdate();
        }
    }
    
    // ========================= VALIDATION AND STATISTICS =========================
    
    /**
     * Check if an announcement exists
     * @param id Announcement ID
     * @return true if announcement exists, false otherwise
     * @throws SQLException If database error occurs
     */
    public boolean announcementExists(int id) throws SQLException {
        String sql = "SELECT 1 FROM announcements WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }
    
    /**
     * Get total count of announcements
     * @param activeOnly Whether to count only active announcements
     * @return Total count of announcements
     * @throws SQLException If database error occurs
     */
    public int getTotalAnnouncementCount(boolean activeOnly) throws SQLException {
        String sql = "SELECT COUNT(*) FROM announcements";
        if (activeOnly) {
            sql += " WHERE is_active = TRUE";
        }
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Get count of announcements by priority
     * @param priority Priority level
     * @param activeOnly Whether to count only active announcements
     * @return Count of announcements with specified priority
     * @throws SQLException If database error occurs
     */
    public int getAnnouncementCountByPriority(Announcement.Priority priority, boolean activeOnly) throws SQLException {
        String sql = "SELECT COUNT(*) FROM announcements WHERE priority = ?";
        if (activeOnly) {
            sql += " AND is_active = TRUE";
        }
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, priority.getValue());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Get recent announcements count (within specified days)
     * @param days Number of days to look back
     * @param activeOnly Whether to count only active announcements
     * @return Count of recent announcements
     * @throws SQLException If database error occurs
     */
    public int getRecentAnnouncementCount(int days, boolean activeOnly) throws SQLException {
        String sql = "SELECT COUNT(*) FROM announcements WHERE created_date >= DATE_SUB(NOW(), INTERVAL ? DAY)";
        if (activeOnly) {
            sql += " AND is_active = TRUE";
        }
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, days);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    // ========================= HELPER METHODS =========================
    
    /**
     * Helper method to map database row to Announcement object
     * @param rs ResultSet containing announcement data
     * @return Announcement object
     * @throws SQLException If database error occurs
     */
    private Announcement mapRowToAnnouncement(ResultSet rs) throws SQLException {
        return new Announcement(
            rs.getInt("id"),
            rs.getString("title"),
            rs.getString("content"),
            rs.getInt("created_by"),
            new Date(rs.getTimestamp("created_date").getTime()),
            rs.getBoolean("is_active"),
            Announcement.Priority.fromString(rs.getString("priority"))
        );
    }
} 