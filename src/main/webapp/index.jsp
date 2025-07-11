<%@ page import="model.Quiz" %>
<%@ page import="model.QuizAttempt" %>
<%@ page import="model.Announcement" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    User user = (User) session.getAttribute("user");
    List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");
    List<Quiz> popularQuizzes = (List<Quiz>) request.getAttribute("popularQuizzes");
    List<Quiz> recentQuizzes = (List<Quiz>) request.getAttribute("recentQuizzes");
    List<QuizAttempt> recentAttempts = (List<QuizAttempt>) request.getAttribute("recentAttempts");
    List<Quiz> userCreatedQuizzes = (List<Quiz>) request.getAttribute("userCreatedQuizzes");
    List<Announcement> activeAnnouncements = (List<Announcement>) request.getAttribute("activeAnnouncements");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz Website - Home</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        /* =========================== GLOBAL STYLES =========================== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            line-height: 1.6;
            color: #2c3e50;
        }
        
        /* =========================== HEADER SECTION =========================== */
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 60px 40px 80px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
        }
        
        /* Decorative corner elements */
        .hero-section::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                radial-gradient(circle at 10% 20%, rgba(255,255,255,0.1) 0%, transparent 50%),
                radial-gradient(circle at 90% 10%, rgba(255,255,255,0.08) 0%, transparent 50%),
                radial-gradient(circle at 20% 80%, rgba(255,255,255,0.06) 0%, transparent 50%),
                radial-gradient(circle at 80% 90%, rgba(255,255,255,0.08) 0%, transparent 50%);
            pointer-events: none;
        }
        
        .hero-content {
            position: relative;
            z-index: 2;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .hero-title {
            font-size: 3.2rem;
            font-weight: 700;
            margin-bottom: 25px;
            text-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        }
        
        .hero-subtitle {
            font-size: 1.3rem;
            margin-bottom: 50px;
            opacity: 0.9;
            font-weight: 400;
        }
        
        .hero-stats {
            display: flex;
            justify-content: center;
            gap: 80px;
            margin-top: 50px;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            display: block;
        }
        
        .stat-label {
            font-size: 1rem;
            opacity: 0.8;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        /* =========================== MAIN CONTAINER =========================== */
        .main-container {
            max-width: 1600px;
            margin: -60px auto 0;
            padding: 0 40px 80px;
            position: relative;
            z-index: 3;
        }
        
        /* =========================== ANNOUNCEMENT SECTION =========================== */
        .announcements-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            margin-bottom: 50px;
            overflow: hidden;
            border-top: 4px solid #ff6b6b;
            position: relative;
        }
        
        /* Decorative corner for announcements */
        .announcements-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, transparent 50%, rgba(255, 107, 107, 0.1) 50%);
            border-radius: 0 20px 0 100px;
            pointer-events: none;
        }
        
        .announcements-header {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            padding: 30px 40px;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .announcements-icon {
            font-size: 2rem;
        }
        
        .announcements-title {
            font-size: 1.6rem;
            font-weight: 600;
        }
        
        .announcements-content {
            padding: 40px;
        }
        
        .announcement-item {
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 20px;
            border-left: 4px solid;
            transition: all 0.3s ease;
        }
        
        .announcement-item:hover {
            transform: translateX(5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }
        
        .announcement-item.high {
            border-left-color: #dc3545;
            background: linear-gradient(135deg, #fff5f5, #ffeaea);
        }
        
        .announcement-item.medium {
            border-left-color: #ffc107;
            background: linear-gradient(135deg, #fffbf0, #fff8e1);
        }
        
        .announcement-item.low {
            border-left-color: #28a745;
            background: linear-gradient(135deg, #f0fff4, #e8f5e8);
        }
        
        .announcement-item-title {
            font-weight: 600;
            font-size: 1.2rem;
            margin-bottom: 10px;
            color: #2c3e50;
        }
        
        .announcement-item-content {
            color: #34495e;
            margin-bottom: 12px;
            font-size: 1rem;
        }
        
        .announcement-item-meta {
            font-size: 0.9rem;
            color: #7f8c8d;
            display: flex;
            gap: 20px;
        }
        
        /* =========================== CONTENT GRID =========================== */
        .content-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 40px;
            margin-bottom: 50px;
        }
        
        .content-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            transition: all 0.3s ease;
            position: relative;
        }
        
        /* Decorative corner for content cards */
        .content-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, transparent 50%, rgba(102, 126, 234, 0.1) 50%);
            border-radius: 0 20px 0 80px;
            pointer-events: none;
        }
        
        .content-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 35px 100px rgba(0, 0, 0, 0.2);
        }
        
        .content-card-header {
            padding: 30px 40px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .content-card-icon {
            font-size: 2rem;
        }
        
        .content-card-title {
            font-size: 1.5rem;
            font-weight: 600;
        }
        
        .content-card-body {
            padding: 40px;
        }
        
        .quiz-list {
            list-style: none;
        }
        
        .quiz-item {
            padding: 18px 25px;
            margin-bottom: 15px;
            background: #f8f9fa;
            border-radius: 12px;
            border-left: 4px solid #667eea;
            transition: all 0.3s ease;
        }
        
        .quiz-item:hover {
            background: #e9ecef;
            transform: translateX(5px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        .quiz-item:last-child {
            margin-bottom: 0;
        }
        
        .quiz-link {
            color: #2c3e50;
            text-decoration: none;
            font-weight: 500;
            font-size: 1.1rem;
        }
        
        .quiz-link:hover {
            color: #667eea;
        }
        
        .empty-state {
            text-align: center;
            color: #7f8c8d;
            font-style: italic;
            padding: 50px 30px;
            font-size: 1.1rem;
        }
        
        /* =========================== USER SECTION =========================== */
        .user-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            margin-bottom: 50px;
            position: relative;
        }
        
        /* Decorative corner for user card */
        .user-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 90px;
            height: 90px;
            background: linear-gradient(135deg, transparent 50%, rgba(0, 184, 148, 0.1) 50%);
            border-radius: 0 20px 0 90px;
            pointer-events: none;
        }
        
        .user-card-header {
            background: linear-gradient(135deg, #00b894, #00a085);
            color: white;
            padding: 30px 40px;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .user-card-body {
            padding: 40px;
        }
        
        .user-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 35px;
        }
        
        .user-action-btn {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 18px 25px;
            background: #f8f9fa;
            color: #2c3e50;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: 2px solid #e9ecef;
            font-size: 1rem;
        }
        
        .user-action-btn:hover {
            background: #e9ecef;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            color: #667eea;
            border-color: #667eea;
        }
        
        .user-action-icon {
            font-size: 1.3rem;
        }
        
        .message-badge {
            background: #dc3545;
            color: white;
            border-radius: 50%;
            width: 22px;
            height: 22px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 600;
            margin-left: 8px;
        }
        
        /* =========================== AUTH SECTION =========================== */
        .auth-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            padding: 50px;
            text-align: center;
            margin-bottom: 50px;
            position: relative;
        }
        
        /* Decorative corner for auth card */
        .auth-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, transparent 50%, rgba(102, 126, 234, 0.08) 50%);
            border-radius: 0 20px 0 100px;
            pointer-events: none;
        }
        
        .auth-title {
            font-size: 2.2rem;
            font-weight: 600;
            margin-bottom: 20px;
            color: #2c3e50;
        }
        
        .auth-subtitle {
            color: #7f8c8d;
            margin-bottom: 40px;
            font-size: 1.2rem;
        }
        
        .auth-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
        }
        
        .auth-btn {
            padding: 18px 35px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        
        .auth-btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }
        
        .auth-btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 35px rgba(102, 126, 234, 0.4);
        }
        
        .auth-btn-secondary {
            background: transparent;
            color: #667eea;
            border-color: #667eea;
        }
        
        .auth-btn-secondary:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }
        
        /* =========================== LOGOUT BUTTON =========================== */
        .logout-btn {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 1rem;
        }
        
        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.4);
        }
        
        /* =========================== RESPONSIVE DESIGN =========================== */
        @media (max-width: 1400px) {
            .main-container {
                max-width: 1400px;
                padding: 0 30px 60px;
            }
            
            .content-grid {
                grid-template-columns: repeat(auto-fit, minmax(450px, 1fr));
                gap: 30px;
            }
        }
        
        @media (max-width: 1200px) {
            .main-container {
                max-width: 1200px;
                padding: 0 30px 60px;
            }
            
            .content-grid {
                grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
                gap: 30px;
            }
        }
        
        @media (max-width: 768px) {
            .hero-section {
                padding: 60px 20px;
            }
            
            .hero-title {
                font-size: 2.5rem;
            }
            
            .hero-subtitle {
                font-size: 1.1rem;
            }
            
            .hero-stats {
                flex-direction: column;
                gap: 20px;
            }
            
            .content-grid {
                grid-template-columns: 1fr;
                gap: 25px;
            }
            
            .main-container {
                padding: 0 20px 40px;
            }
            
            .auth-buttons {
                flex-direction: column;
                gap: 15px;
            }
            
            .user-actions {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 480px) {
            .hero-section {
                padding: 40px 15px;
            }
            
            .hero-title {
                font-size: 2rem;
            }
            
            .content-card-header,
            .announcements-header,
            .user-card-header {
                padding: 20px;
            }
            
            .content-card-body,
            .announcements-content,
            .user-card-body {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Hero Section -->
    <div class="hero-section">
        <div class="hero-content">
            <h1 class="hero-title">Quiz Website</h1>
            <p class="hero-subtitle">Challenge yourself, learn something new, and compete with friends!</p>
            
            <div class="hero-stats">
                <div class="stat-item">
                    <span class="stat-number"><%= quizzes != null ? quizzes.size() : 0 %></span>
                    <span class="stat-label">Active Quizzes</span>
                </div>
                <% if (user == null) { %>
                <div class="stat-item">
                    <span class="stat-number">Join Now</span>
                    <span class="stat-label">Get Started</span>
                </div>
                <% } %>
                <div class="stat-item">
                    <span class="stat-number"><%= activeAnnouncements != null ? activeAnnouncements.size() : 0 %></span>
                    <span class="stat-label">Announcements</span>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Main Container -->
    <div class="main-container">
        <!-- Announcements Section -->
        <% if (activeAnnouncements != null && !activeAnnouncements.isEmpty()) { %>
        <div class="announcements-card">
            <div class="announcements-header">
                <div class="announcements-icon">📢</div>
                <div class="announcements-title">Latest Announcements</div>
            </div>
            <div class="announcements-content">
                <% for (Announcement announcement : activeAnnouncements) { %>
                <div class="announcement-item <%= announcement.getPriority().toString().toLowerCase() %>">
                    <div class="announcement-item-title"><%= announcement.getTitle() %></div>
                    <div class="announcement-item-content"><%= announcement.getContent() %></div>
                    <div class="announcement-item-meta">
                        <span>Priority: <%= announcement.getPriority().toString() %></span>
                        <span>Date: <%= announcement.getCreatedDate() %></span>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
        <% } %>
        
        <!-- Content Grid -->
        <div class="content-grid">
            <!-- Popular Quizzes -->
            <div class="content-card">
                <div class="content-card-header">
                    <div class="content-card-icon">🔥</div>
                    <div class="content-card-title">Popular Quizzes</div>
                </div>
                <div class="content-card-body">
                    <% if (popularQuizzes != null && !popularQuizzes.isEmpty()) { %>
                    <ul class="quiz-list">
                        <% for (Quiz quiz : popularQuizzes) { %>
                        <li class="quiz-item">
                            <a href="quiz?id=<%= quiz.getQuizId() %>" class="quiz-link"><%= quiz.getTitle() %></a>
                        </li>
                        <% } %>
                    </ul>
                    <% } else { %>
                    <div class="empty-state">No popular quizzes available yet.</div>
                    <% } %>
                </div>
            </div>
            
            <!-- Recent Quizzes -->
            <div class="content-card">
                <div class="content-card-header">
                    <div class="content-card-icon">✨</div>
                    <div class="content-card-title">Recently Created</div>
                </div>
                <div class="content-card-body">
                    <% if (recentQuizzes != null && !recentQuizzes.isEmpty()) { %>
                    <ul class="quiz-list">
                        <% for (Quiz quiz : recentQuizzes) { %>
                        <li class="quiz-item">
                            <a href="quiz?id=<%= quiz.getQuizId() %>" class="quiz-link"><%= quiz.getTitle() %></a>
                        </li>
                        <% } %>
                    </ul>
                    <% } else { %>
                    <div class="empty-state">No recent quizzes available.</div>
                    <% } %>
                </div>
            </div>
        </div>
        
        <!-- User Section (Logged In) -->
        <% if (user != null) { %>
        <div class="user-card">
            <div class="user-card-header">
                <div class="content-card-icon">👤</div>
                <div class="content-card-title">Welcome back, <%= user.getUsername() %>!</div>
            </div>
            <div class="user-card-body">
                <div class="user-actions">
                    <a href="${pageContext.request.contextPath}/profile" class="user-action-btn">
                        <span class="user-action-icon">👤</span>
                        <span>My Profile</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/quiz/create" class="user-action-btn">
                        <span class="user-action-icon">➕</span>
                        <span>Create Quiz</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/friends" class="user-action-btn">
                        <span class="user-action-icon">👥</span>
                        <span>Manage Friends</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/messages" class="user-action-btn">
                        <span class="user-action-icon">💬</span>
                        <span>View Messages</span>
                        <% Integer unreadCount = (Integer) request.getAttribute("unreadMessageCount"); %>
                        <% String recentTypeEmoji = (String) request.getAttribute("recentUnreadTypeEmoji"); %>
                        <% if (unreadCount != null && unreadCount > 0) { %>
                        <span class="message-badge"><%= unreadCount %></span>
                        <% if (recentTypeEmoji != null) { %>
                        <span style="font-size: 1.1em; margin-left: 5px;"><%= recentTypeEmoji %></span>
                        <% } %>
                        <% } %>
                    </a>
                </div>
                
                <!-- User's Recent Attempts -->
                <% if (recentAttempts != null && !recentAttempts.isEmpty()) { %>
                <div style="margin-bottom: 25px;">
                    <h3 style="margin-bottom: 15px; color: #2c3e50;">Your Recent Quiz Attempts</h3>
                    <ul class="quiz-list">
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
                        <li class="quiz-item">
                            <a href="quiz?id=<%= quizId %>" class="quiz-link"><%= quizTitle %></a>
                        </li>
                        <%     }
                           }
                        %>
                    </ul>
                </div>
                <% } %>
                
                <!-- User's Created Quizzes -->
                <% if (userCreatedQuizzes != null && !userCreatedQuizzes.isEmpty()) { %>
                <div style="margin-bottom: 25px;">
                    <h3 style="margin-bottom: 15px; color: #2c3e50;">Your Created Quizzes</h3>
                    <ul class="quiz-list">
                        <% for (Quiz quiz : userCreatedQuizzes) { %>
                        <li class="quiz-item">
                            <a href="quiz?id=<%= quiz.getQuizId() %>" class="quiz-link"><%= quiz.getTitle() %></a>
                        </li>
                        <% } %>
                    </ul>
                </div>
                <% } %>
                
                <form action="logout" method="get">
                    <button type="submit" class="logout-btn">Logout</button>
                </form>
            </div>
        </div>
        <% } else { %>
        
        <!-- Auth Section (Not Logged In) -->
        <div class="auth-card">
            <h2 class="auth-title">Ready to Get Started?</h2>
            <p class="auth-subtitle">Join thousands of users testing their knowledge and creating amazing quizzes!</p>
            <div class="auth-buttons">
                <a href="login" class="auth-btn auth-btn-primary">🔐 Login</a>
                <a href="register" class="auth-btn auth-btn-secondary">✨ Sign Up</a>
            </div>
        </div>
        <% } %>
    </div>
</body>
</html>