package controller;

import dao.FriendshipDAO;
import dao.UserDAO;
import model.Friendship;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(urlPatterns = {"/friends", "/friends/request", "/friends/accept", "/friends/decline"})
public class FriendshipController extends HttpServlet {
    
    private FriendshipDAO friendshipDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        try {
            friendshipDAO = (FriendshipDAO) getServletContext().getAttribute("friendshipDAO");
            userDAO = (UserDAO) getServletContext().getAttribute("userDAO");
        } catch (Exception e) {
            throw new ServletException("Database connection error", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User currentUser = getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        String path = req.getServletPath();
        
        try {
            if ("/friends".equals(path)) {
                handleViewFriends(req, resp, currentUser);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User currentUser = getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        String path = req.getServletPath();
        
        try {
            switch (path) {
                case "/friends/request":
                    handleSendFriendRequest(req, resp, currentUser);
                    break;
                case "/friends/accept":
                    handleAcceptFriendRequest(req, resp, currentUser);
                    break;
                case "/friends/decline":
                    handleDeclineFriendRequest(req, resp, currentUser);
                    break;
                default:
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    private void handleViewFriends(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws SQLException, ServletException, IOException {
        
        List<Friendship> friends = friendshipDAO.getFriends(user.getUserId());
        List<Friendship> pendingRequests = friendshipDAO.getPendingFriendRequests(user.getUserId());
        
        // Create maps for usernames to display in JSP
        java.util.Map<Integer, String> usernames = new java.util.HashMap<>();
        
        // Collect all user IDs we need usernames for
        java.util.Set<Integer> userIds = new java.util.HashSet<>();
        for (Friendship friendship : friends) {
            userIds.add(friendship.getRequesterId());
            userIds.add(friendship.getReceiverId());
        }
        for (Friendship friendship : pendingRequests) {
            userIds.add(friendship.getRequesterId());
            userIds.add(friendship.getReceiverId());
        }
        
        // Fetch usernames for all collected user IDs
        for (Integer userId : userIds) {
            if (userId != user.getUserId()) { // Don't need current user's username
                User friendUser = userDAO.findById(userId);
                if (friendUser != null) {
                    usernames.put(userId, friendUser.getUsername());
                }
            }
        }
        
        req.setAttribute("friends", friends);
        req.setAttribute("pendingRequests", pendingRequests);
        req.setAttribute("usernames", usernames);
        req.getRequestDispatcher("/jsp/friends.jsp").forward(req, resp);
    }
    
    private void handleSendFriendRequest(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws SQLException, ServletException, IOException {
        
        String friendUsername = req.getParameter("friendUsername");
        
        if (friendUsername == null || friendUsername.trim().isEmpty()) {
            req.setAttribute("error", "Please enter a username");
            handleViewFriends(req, resp, user);
            return;
        }
        
        User friend = userDAO.findByUsername(friendUsername);
        if (friend == null) {
            req.setAttribute("error", "User not found");
            handleViewFriends(req, resp, user);
            return;
        }
        
        if (friend.getUserId() == user.getUserId()) {
            req.setAttribute("error", "Cannot send friend request to yourself");
            handleViewFriends(req, resp, user);
            return;
        }
        
        try {
            Friendship friendship = friendshipDAO.sendFriendRequest(user.getUserId(), friend.getUserId());
            if (friendship != null) {
                req.setAttribute("success", "Friend request sent successfully");
            } else {
                req.setAttribute("error", "Failed to send friend request");
            }
        } catch (SQLException e) {
            // Handle specific business logic errors from DAO
            String errorMessage = e.getMessage();
            if (errorMessage.contains("already friends")) {
                req.setAttribute("error", "You are already friends with " + friend.getUsername());
            } else if (errorMessage.contains("already sent")) {
                req.setAttribute("error", "You have already sent a friend request to " + friend.getUsername() + ". Please wait for their response.");
            } else if (errorMessage.contains("already received")) {
                req.setAttribute("error", friend.getUsername() + " has already sent you a friend request. Please check your pending requests above to respond.");
            } else {
                req.setAttribute("error", "Failed to send friend request: " + errorMessage);
            }
        }
        
        handleViewFriends(req, resp, user);
    }
    
    private void handleAcceptFriendRequest(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws SQLException, ServletException, IOException {
        
        String friendshipIdParam = req.getParameter("friendshipId");
        if (friendshipIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/friends");
            return;
        }
        
        try {
            int friendshipId = Integer.parseInt(friendshipIdParam);
            Friendship friendship = friendshipDAO.findById(friendshipId);
            
            if (friendship == null || friendship.getReceiverId() != user.getUserId()) {
                req.setAttribute("error", "Invalid friend request");
                handleViewFriends(req, resp, user);
                return;
            }
            
            if (friendshipDAO.acceptFriendRequest(friendshipId)) {
                req.setAttribute("success", "Friend request accepted");
            } else {
                req.setAttribute("error", "Failed to accept friend request");
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid friend request");
        }
        
        handleViewFriends(req, resp, user);
    }
    
    private void handleDeclineFriendRequest(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws SQLException, ServletException, IOException {
        
        String friendshipIdParam = req.getParameter("friendshipId");
        if (friendshipIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/friends");
            return;
        }
        
        try {
            int friendshipId = Integer.parseInt(friendshipIdParam);
            Friendship friendship = friendshipDAO.findById(friendshipId);
            
            if (friendship == null || friendship.getReceiverId() != user.getUserId()) {
                req.setAttribute("error", "Invalid friend request");
                handleViewFriends(req, resp, user);
                return;
            }
            
            if (friendshipDAO.declineFriendRequest(friendshipId)) {
                req.setAttribute("success", "Friend request declined");
            } else {
                req.setAttribute("error", "Failed to decline friend request");
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid friend request");
        }
        
        handleViewFriends(req, resp, user);
    }
    
    private User getCurrentUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null) {
            return (User) session.getAttribute("user");
        }
        return null;
    }
}
