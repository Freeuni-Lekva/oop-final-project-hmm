package controller;

import dao.UserDAO;
import model.User;
import util.PasswordHasher;
import util.DbUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/login", "/register", "/logout"})
public class UserController extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {

        try
        {
            Connection connection = (Connection) getServletContext().getAttribute("DBConnection");
            userDAO = (UserDAO) getServletContext().getAttribute("userDAO");
        }
        catch (Exception e)
        {
            throw new ServletException("DB connection error", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        switch (path) {
            case "/login":
                req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
                break;
            case "/register":
                req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
                break;
            case "/logout":
                HttpSession session = req.getSession(false);
                if (session != null) session.invalidate();
                resp.sendRedirect("login");
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        switch (path) {
            case "/login":
                handleLogin(req, resp);
                break;
            case "/register":
                handleRegister(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        try {
            User user = userDAO.authenticateUser(username, password);
            if (user != null) {
                HttpSession session = req.getSession();
                session.setAttribute("user", user);
                resp.sendRedirect("index.jsp");
            } else {
                req.setAttribute("error", "Invalid username or password");
                req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        try {
            if (userDAO.findByUsername(username) != null) {
                req.setAttribute("error", "Username already exists");
                req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
                return;
            }
            String hash = PasswordHasher.hashPassword(password);
            User user = new User();
            user.setUsername(username);
            user.setPasswordHash(hash);
            user.setEmail(email);
            userDAO.createUser(user);
            resp.sendRedirect("login");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
} 