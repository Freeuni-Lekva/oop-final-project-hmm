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

@WebServlet(urlPatterns = {"/admin", "/admin/login", "/admin/dashboard", "/admin/logout"})
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
} 