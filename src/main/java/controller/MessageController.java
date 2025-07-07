package controller;

import dao.MessageDAO;
import dao.UserDAO;
import model.Message;
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

@WebServlet(urlPatterns = {"/messages", "/messages/send"})
public class MessageController extends HttpServlet {
    
    private MessageDAO messageDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        try {
            messageDAO = (MessageDAO) getServletContext().getAttribute("messageDAO");
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
            if ("/messages".equals(path)) {
                handleViewMessages(req, resp, currentUser);
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
            if ("/messages/send".equals(path)) {
                handleSendMessage(req, resp, currentUser);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    private void handleViewMessages(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws SQLException, ServletException, IOException {
        
        List<Message> messages = messageDAO.getReceivedMessages(user.getUserId());
        req.setAttribute("messages", messages);
        req.getRequestDispatcher("/jsp/messages.jsp").forward(req, resp);
    }
    
    private void handleSendMessage(HttpServletRequest req, HttpServletResponse resp, User user) 
            throws SQLException, ServletException, IOException {
        
        String recipientUsername = req.getParameter("recipient");
        String messageType = req.getParameter("messageType");
        String content = req.getParameter("content");
        String quizIdParam = req.getParameter("quizId");
        
        if (recipientUsername == null || messageType == null || content == null) {
            req.setAttribute("error", "Missing required fields");
            handleViewMessages(req, resp, user);
            return;
        }
        
        User recipient = userDAO.findByUsername(recipientUsername);
        if (recipient == null) {
            req.setAttribute("error", "Recipient not found");
            handleViewMessages(req, resp, user);
            return;
        }
        
        Message message = null;
        
        switch (messageType) {
            case Message.TYPE_NOTE:
                message = messageDAO.sendNote(user.getUserId(), recipient.getUserId(), content);
                break;
            case Message.TYPE_FRIEND_REQUEST:
                message = messageDAO.sendFriendRequest(user.getUserId(), recipient.getUserId(), content);
                break;
            case Message.TYPE_CHALLENGE:
                if (quizIdParam != null) {
                    int quizId = Integer.parseInt(quizIdParam);
                    message = messageDAO.sendChallenge(user.getUserId(), recipient.getUserId(), content, quizId);
                }
                break;
        }
        
        if (message != null) {
            req.setAttribute("success", "Message sent successfully");
        } else {
            req.setAttribute("error", "Failed to send message");
        }
        
        handleViewMessages(req, resp, user);
    }
    
    private User getCurrentUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null) {
            return (User) session.getAttribute("user");
        }
        return null;
    }
}
