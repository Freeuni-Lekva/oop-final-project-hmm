package controller;

import dao.UserDAO;
import dao.QuizDAO;
import dao.QuizAttemptDAO;
import dao.AnnouncementDAO;
import model.User;
import model.Announcement;
import util.PasswordHasher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

@WebServlet(urlPatterns = {
    "/admin", "/admin/login", "/admin/dashboard", "/admin/logout",
    "/admin/announcements", "/admin/announcements/create", "/admin/announcements/delete",
    "/admin/users", "/admin/users/delete", "/admin/users/promote",
    "/admin/quizzes", "/admin/quizzes/delete",
    "/admin/cleanup"
})
public class AdminController extends HttpServlet {
    private UserDAO userDAO;
    private QuizDAO quizDAO;
    private QuizAttemptDAO quizAttemptDAO;
    private AnnouncementDAO announcementDAO;

    @Override
    public void init() throws ServletException {
        try {
            Connection connection = (Connection) getServletContext().getAttribute("DBConnection");
            userDAO = (UserDAO) getServletContext().getAttribute("userDAO");
            quizDAO = (QuizDAO) getServletContext().getAttribute("quizDAO");
            quizAttemptDAO = (QuizAttemptDAO) getServletContext().getAttribute("quizAttemptDAO");
            
            // Create AnnouncementDAO if not already in context
            announcementDAO = (AnnouncementDAO) getServletContext().getAttribute("announcementDAO");
            if (announcementDAO == null) {
                announcementDAO = new AnnouncementDAO(connection);
                getServletContext().setAttribute("announcementDAO", announcementDAO);
            }
        } catch (Exception e) {
            throw new ServletException("DB connection error", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        
        switch (path) {
            case "/admin":
            case "/admin/login":
                // Check if already logged in as admin
                if (isAdminLoggedIn(req)) {
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                } else {
                    req.getRequestDispatcher("/jsp/admin/adminLogin.jsp").forward(req, resp);
                }
                break;
            case "/admin/dashboard":
                if (isAdminLoggedIn(req)) {
                    handleAdminDashboard(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/login");
                }
                break;
            case "/admin/logout":
                handleAdminLogout(req, resp);
                break;
            case "/admin/announcements":
                if (isAdminLoggedIn(req)) {
                    handleAnnouncementsList(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/login");
                }
                break;
            case "/admin/announcements/create":
                if (isAdminLoggedIn(req)) {
                    req.getRequestDispatcher("/jsp/admin/createAnnouncement.jsp").forward(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/login");
                }
                break;
            case "/admin/announcements/delete":
                if (isAdminLoggedIn(req)) {
                    handleDeleteAnnouncement(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/login");
                }
                break;
            case "/admin/users":
                if (isAdminLoggedIn(req)) {
                    handleUsersList(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/login");
                }
                break;
            case "/admin/quizzes":
                if (isAdminLoggedIn(req)) {
                    handleQuizzesList(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/login");
                }
                break;
            case "/admin/cleanup":
                if (isAdminLoggedIn(req)) {
                    req.getRequestDispatcher("/jsp/admin/cleanup.jsp").forward(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/login");
                }
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        
        switch (path) {
            case "/admin/login":
                handleAdminLogin(req, resp);
                break;
            case "/admin/announcements/create":
                if (isAdminLoggedIn(req)) {
                    handleCreateAnnouncement(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/login");
                }
                break;
            case "/admin/announcements/delete":
                if (isAdminLoggedIn(req)) {
                    handleDeleteAnnouncement(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/login");
                }
                break;
            case "/admin/users/delete":
                if (isAdminLoggedIn(req)) {
                    handleDeleteUser(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/login");
                }
                break;
            case "/admin/users/promote":
                if (isAdminLoggedIn(req)) {
                    handlePromoteUser(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/login");
                }
                break;
            case "/admin/quizzes/delete":
                if (isAdminLoggedIn(req)) {
                    handleDeleteQuiz(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/login");
                }
                break;
            case "/admin/cleanup":
                if (isAdminLoggedIn(req)) {
                    handleCleanupData(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/login");
                }
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * Handle admin login authentication
     */
    private void handleAdminLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        
        try {
            User user = userDAO.authenticateUser(username, password);
            
            if (user != null && user.isAdmin()) {
                // Create admin session
                HttpSession session = req.getSession();
                session.setAttribute("admin", user);
                session.setAttribute("adminLoggedIn", true);
                
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                req.setAttribute("error", "Invalid admin credentials");
                req.getRequestDispatcher("/jsp/admin/adminLogin.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error during admin login", e);
        }
    }

    /**
     * Handle admin logout
     */
    private void handleAdminLogout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.removeAttribute("admin");
            session.removeAttribute("adminLoggedIn");
            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/admin/login");
    }

    /**
     * Handle admin dashboard - show site statistics and admin options
     */
    private void handleAdminDashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Get site statistics
            int totalUsers = userDAO.getTotalUserCount();
            int totalAdmins = userDAO.getAdminUserCount();
            int totalQuizzes = quizDAO.getTotalQuizCount();
            int totalQuizAttempts = quizAttemptDAO.getTotalAttemptCount();
            int recentUsers = userDAO.getRecentRegistrationCount(7); // Last 7 days
            int recentQuizAttempts = quizAttemptDAO.getRecentAttemptCount(7); // Last 7 days
            
            // Get announcement statistics
            int totalAnnouncements = announcementDAO.getTotalAnnouncementCount(false);
            int activeAnnouncements = announcementDAO.getTotalAnnouncementCount(true);
            
            // Set attributes for the dashboard
            req.setAttribute("totalUsers", totalUsers);
            req.setAttribute("totalAdmins", totalAdmins);
            req.setAttribute("totalQuizzes", totalQuizzes);
            req.setAttribute("totalQuizAttempts", totalQuizAttempts);
            req.setAttribute("recentUsers", recentUsers);
            req.setAttribute("recentQuizAttempts", recentQuizAttempts);
            req.setAttribute("totalAnnouncements", totalAnnouncements);
            req.setAttribute("activeAnnouncements", activeAnnouncements);
            
            // Get recent announcements for display
            List<Announcement> recentAnnouncements = announcementDAO.getAllAnnouncements(0, 5);
            req.setAttribute("recentAnnouncements", recentAnnouncements);
            
            req.getRequestDispatcher("/jsp/admin/adminDashboard.jsp").forward(req, resp);
            
        } catch (SQLException e) {
            throw new ServletException("Database error while loading admin dashboard", e);
        }
    }

    /**
     * Handle announcements list page
     */
    private void handleAnnouncementsList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<Announcement> announcements = announcementDAO.getAllAnnouncements(0, 10); // Fetch all announcements
            req.setAttribute("announcements", announcements);
            req.getRequestDispatcher("/jsp/admin/announcementsList.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Database error while loading announcements list", e);
        }
    }

    /**
     * Handle users list page
     */
    private void handleUsersList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<User> users = userDAO.getAllUsers();
            req.setAttribute("users", users);
            req.getRequestDispatcher("/jsp/admin/usersList.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Database error while loading users list", e);
        }
    }

    /**
     * Handle quizzes list page
     */
    private void handleQuizzesList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<model.Quiz> quizzes = quizDAO.getAllQuizzes();
            req.setAttribute("quizzes", quizzes);
            req.getRequestDispatcher("/jsp/admin/quizzesList.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Database error while loading quizzes list", e);
        }
    }

    /**
     * Check if admin is logged in
     */
    private boolean isAdminLoggedIn(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return false;
        }
        
        Boolean adminLoggedIn = (Boolean) session.getAttribute("adminLoggedIn");
        User admin = (User) session.getAttribute("admin");
        
        return adminLoggedIn != null && adminLoggedIn && admin != null && admin.isAdmin();
    }

    /**
     * Handle create announcement
     */
    private void handleCreateAnnouncement(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String priorityStr = req.getParameter("priority");
        
        try {
            HttpSession session = req.getSession();
            User admin = (User) session.getAttribute("admin");
            
            Announcement.Priority priority = Announcement.Priority.fromString(priorityStr != null ? priorityStr : "medium");
            Announcement announcement = new Announcement(title, content, admin.getUserId(), priority);
            
            announcementDAO.createAnnouncement(announcement);
            
            req.getSession().setAttribute("success", "Announcement created successfully!");
            resp.sendRedirect(req.getContextPath() + "/admin/announcements");
        } catch (SQLException e) {
            req.setAttribute("error", "Error creating announcement: " + e.getMessage());
            req.getRequestDispatcher("/jsp/admin/createAnnouncement.jsp").forward(req, resp);
        }
    }

    /**
     * Handle delete announcement
     */
    private void handleDeleteAnnouncement(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        
        try {
            int id = Integer.parseInt(idStr);
            boolean deleted = announcementDAO.deleteAnnouncement(id);
            
            if (deleted) {
                req.getSession().setAttribute("success", "Announcement deleted successfully!");
            } else {
                req.getSession().setAttribute("error", "Failed to delete announcement!");
            }
        } catch (SQLException e) {
            req.getSession().setAttribute("error", "Error deleting announcement: " + e.getMessage());
        }
        
        resp.sendRedirect(req.getContextPath() + "/admin/announcements");
    }

    /**
     * Handle delete user
     */
    private void handleDeleteUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        
        try {
            int userId = Integer.parseInt(idStr);
            HttpSession session = req.getSession();
            User admin = (User) session.getAttribute("admin");
            
            // Prevent admin from deleting themselves
            if (userId == admin.getUserId()) {
                req.getSession().setAttribute("error", "Cannot delete your own account!");
            } else {
                boolean deleted = userDAO.deleteUser(userId);
                
                if (deleted) {
                    req.getSession().setAttribute("success", "User deleted successfully!");
                } else {
                    req.getSession().setAttribute("error", "Failed to delete user!");
                }
            }
        } catch (SQLException e) {
            req.getSession().setAttribute("error", "Error deleting user: " + e.getMessage());
        }
        
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    /**
     * Handle promote user to admin
     */
    private void handlePromoteUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        
        try {
            int userId = Integer.parseInt(idStr);
            User user = userDAO.findById(userId);
            
            if (user != null) {
                user.setAdmin(true);
                boolean updated = userDAO.updateUser(user);
                
                if (updated) {
                    req.getSession().setAttribute("success", "User promoted to admin successfully!");
                } else {
                    req.getSession().setAttribute("error", "Failed to promote user!");
                }
            } else {
                req.getSession().setAttribute("error", "User not found!");
            }
        } catch (SQLException e) {
            req.getSession().setAttribute("error", "Error promoting user: " + e.getMessage());
        }
        
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    /**
     * Handle delete quiz
     */
    private void handleDeleteQuiz(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        
        try {
            int quizId = Integer.parseInt(idStr);
            boolean deleted = quizDAO.deleteQuiz(quizId);
            
            if (deleted) {
                req.getSession().setAttribute("success", "Quiz deleted successfully!");
            } else {
                req.getSession().setAttribute("error", "Failed to delete quiz!");
            }
        } catch (SQLException e) {
            req.getSession().setAttribute("error", "Error deleting quiz: " + e.getMessage());
        }
        
        resp.sendRedirect(req.getContextPath() + "/admin/quizzes");
    }

    /**
     * Handle cleanup data
     */
    private void handleCleanupData(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        try {
            switch (action) {
                case "clearHistory":
                    // Delete all quiz attempts
                    int deletedAttempts = quizAttemptDAO.deleteAllAttempts();
                    req.getSession().setAttribute("success", "Cleared " + deletedAttempts + " quiz attempts!");
                    break;
                case "clearInactiveAnnouncements":
                    // Delete inactive announcements
                    int deletedAnnouncements = announcementDAO.deleteInactiveAnnouncements();
                    req.getSession().setAttribute("success", "Cleared " + deletedAnnouncements + " inactive announcements!");
                    break;
                default:
                    req.getSession().setAttribute("error", "Invalid cleanup action!");
            }
        } catch (SQLException e) {
            req.getSession().setAttribute("error", "Error during cleanup: " + e.getMessage());
        }
        
        resp.sendRedirect(req.getContextPath() + "/admin/cleanup");
    }
} 