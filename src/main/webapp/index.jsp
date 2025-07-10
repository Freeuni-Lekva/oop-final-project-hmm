<%@ page import="model.Quiz" %>
<%@ page import="model.QuizAttempt" %>
<%@ page import="model.Announcement" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Object user = session.getAttribute("user");
    List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");
    List<Quiz> popularQuizzes = (List<Quiz>) request.getAttribute("popularQuizzes");
    List<Quiz> recentQuizzes = (List<Quiz>) request.getAttribute("recentQuizzes");
    List<QuizAttempt> recentAttempts = (List<QuizAttempt>) request.getAttribute("recentAttempts");
    List<Quiz> userCreatedQuizzes = (List<Quiz>) request.getAttribute("userCreatedQuizzes");
    List<Announcement> activeAnnouncements = (List<Announcement>) request.getAttribute("activeAnnouncements");

    // If quizzes is null (direct JSP access), fetch them from DAO
    if (quizzes == null) {
        // This block is no longer needed as quizzes are fetched by HomeController
        // QuizDAO quizDAO = (QuizDAO) application.getAttribute("quizDAO");
        // if (quizDAO != null) {
        //     try {
        //         quizzes = quizDAO.getAllQuizzes();
        //     } catch (Exception e) {
        //         // Handle error silently or set empty list
        //         quizzes = new java.util.ArrayList<>();
        //     }
        // } else {//
        //     quizzes = new java.util.ArrayList<>();
        // }
    }
%>
<html>
<head>
    <title>Quiz Website - Home</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
            line-height: 1.6;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 3px solid #007bff;
            padding-bottom: 10px;
        }
        
        h2 {
            color: #495057;
            border-left: 4px solid #007bff;
            padding-left: 15px;
            margin-top: 30px;
        }
        
        .announcements-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }
        
        .announcements-section h2 {
            color: white;
            border-left: 4px solid white;
            margin-top: 0;
        }
        
        .announcement {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            padding: 15px;
            margin: 10px 0;
            border-left: 4px solid #ffc107;
        }
        
        .announcement.high {
            border-left-color: #dc3545;
            background: rgba(220, 53, 69, 0.1);
        }
        
        .announcement.medium {
            border-left-color: #ffc107;
            background: rgba(255, 193, 7, 0.1);
        }
        
        .announcement.low {
            border-left-color: #28a745;
            background: rgba(40, 167, 69, 0.1);
        }
        
        .announcement-title {
            font-weight: bold;
            font-size: 1.1em;
            margin-bottom: 5px;
        }
        
        .announcement-content {
            margin-bottom: 5px;
        }
        
        .announcement-meta {
            font-size: 0.9em;
            opacity: 0.8;
        }
        
        ul {
            list-style-type: none;
            padding: 0;
        }
        
        li {
            background: white;
            margin: 10px 0;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #007bff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        
        li:hover {
            transform: translateX(5px);
        }
        
        a {
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
        }
        
        a:hover {
            color: #0056b3;
            text-decoration: underline;
        }
        
        .user-section {
            background-color: #e9ecef;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }
        
        .auth-links {
            text-align: center;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            margin-top: 30px;
        }
        
        .auth-links a {
            margin: 0 10px;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border-radius: 5px;
            text-decoration: none;
        }
        
        .auth-links a:hover {
            background-color: #0056b3;
        }
        
        input[type="submit"] {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
        }
        
        input[type="submit"]:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to the Quiz Website!</h1>

        <!-- Announcements Section -->
        <% if (activeAnnouncements != null && !activeAnnouncements.isEmpty()) { %>
        <div class="announcements-section">
            <h2>📢 Announcements</h2>
            <% for (Announcement announcement : activeAnnouncements) { %>
            <div class="announcement <%= announcement.getPriority().toString().toLowerCase() %>">
                <div class="announcement-title"><%= announcement.getTitle() %></div>
                <div class="announcement-content"><%= announcement.getContent() %></div>
                <div class="announcement-meta">
                    Priority: <%= announcement.getPriority().toString() %> | 
                    Date: <%= announcement.getCreatedDate() %>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>

        <h2>Popular Quizzes</h2>
        <ul>
            <% if (popularQuizzes != null && !popularQuizzes.isEmpty()) {
                for (Quiz quiz : popularQuizzes) { %>
            <li><a href="quiz?id=<%= quiz.getQuizId() %>"><%= quiz.getTitle() %></a></li>
            <%   }
            } else { %>
            <li>No popular quizzes available.</li>
            <% } %>
        </ul>

        <h2>Recently Created Quizzes</h2>
        <ul>
            <% if (recentQuizzes != null && !recentQuizzes.isEmpty()) {
                for (Quiz quiz : recentQuizzes) { %>
            <li><a href="quiz?id=<%= quiz.getQuizId() %>"><%= quiz.getTitle() %></a></li>
            <%   }
            } else { %>
            <li>No recently created quizzes available.</li>
            <% } %>
        </ul>

        <% if (user != null && recentAttempts != null && !recentAttempts.isEmpty()) { %>
        <div class="user-section">
            <h2>Your Recent Quiz Attempts</h2>
            <ul>
                <% java.util.Set<Integer> shownQuizIds = new java.util.HashSet<>();
                   java.util.Map<Integer, String> quizIdToTitle = new java.util.HashMap<>();
                   if (quizzes != null) {
                       for (Quiz quiz : quizzes) {
                           quizIdToTitle.put(quiz.getQuizId(), quiz.getTitle());
                       }
                   }
                   for (QuizAttempt attempt : recentAttempts) {
                       int quizId = attempt.getQuizId();
                       if (!shownQuizIds.contains(quizId)) {
                           shownQuizIds.add(quizId);
                           String quizTitle = quizIdToTitle.getOrDefault(quizId, "Quiz #" + quizId);
                %>
                <li><a href="quiz?id=<%= quizId %>"><%= quizTitle %></a></li>
                <%     }
                   }
                %>
            </ul>
        </div>
        <% } %>

        <% if (user != null && userCreatedQuizzes != null && !userCreatedQuizzes.isEmpty()) { %>
        <div class="user-section">
            <h2>Your Created Quizzes</h2>
            <ul>
                <% for (Quiz quiz : userCreatedQuizzes) { %>
                <li><a href="quiz?id=<%= quiz.getQuizId() %>"><%= quiz.getTitle() %></a></li>
                <% } %>
            </ul>
        </div>
        <% } %>

        <% if (user == null) { %>
        <div class="auth-links">
            <a href="login">Login</a>
            <a href="register">Register</a>
        </div>
        <% } else { %>
        <div class="user-section">
            <p><strong>You are logged in.</strong></p>
            <a href="${pageContext.request.contextPath}/profile">My Profile</a><br/>
            <a href="${pageContext.request.contextPath}/quiz/create">Create Quiz</a><br/>
            <a href="${pageContext.request.contextPath}/friends">Manage Friends</a><br/>
            <a href="${pageContext.request.contextPath}/messages" style="position:relative; display:inline-block;">
                View Messages
                <% Integer unreadCount = (Integer) request.getAttribute("unreadMessageCount"); %>
                <% String recentTypeEmoji = (String) request.getAttribute("recentUnreadTypeEmoji"); %>
                <% if (unreadCount != null && unreadCount > 0) { %>
                    <span style="background:#dc3545;color:white;border-radius:50%;width:14px;height:14px;display:inline-flex;align-items:center;justify-content:center;font-size:0.65em;position:relative;top:-8px;left:4px;vertical-align:middle;line-height:1;text-align:center;"> <%= unreadCount %> </span>
                    <% if (recentTypeEmoji != null) { %>
                        <span style="font-size:1.1em;vertical-align:middle;"> <%= recentTypeEmoji %> </span>
                    <% } %>
                <% } %>
            </a><br/>
            <form action="logout" method="get" style="margin-top: 15px;">
                <input type="submit" value="Logout" />
            </form>
        </div>
        <% } %>
    </div>
</body>
</html>