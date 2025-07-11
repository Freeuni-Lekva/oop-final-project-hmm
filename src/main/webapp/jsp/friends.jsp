<%--
  Friends management page for Quiz Website
  Handles viewing friends, pending requests, and sending friend requests
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Friends - Quiz Website</title>
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
        
        /* =========================== NAVIGATION =========================== */
        .nav-home {
            position: absolute;
            top: 20px;
            left: 20px;
            padding: 12px 24px;
            text-decoration: none;
            color: white;
            font-weight: 600;
            background: rgba(255, 255, 255, 0.15);
            border: 2px solid rgba(255, 255, 255, 0.2);
            border-radius: 30px;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
            font-size: 14px;
        }
        
        .nav-home:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            text-decoration: none;
            color: white;
        }
        
        /* =========================== MAIN CONTAINER =========================== */
        .main-container {
            max-width: 900px;
            margin: 80px auto 40px;
            padding: 0 40px;
            position: relative;
            z-index: 3;
        }
        
        .page-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: white;
            margin-bottom: 10px;
            text-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        }
        
        .page-subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1.1rem;
        }
        
        /* =========================== STATISTICS CARDS =========================== */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 8px;
        }
        
        .stat-label {
            color: #7f8c8d;
            font-size: 0.9rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        /* =========================== SEND REQUEST SECTION =========================== */
        .send-request-section {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            margin-bottom: 40px;
            position: relative;
        }
        
        .send-request-section::before {
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
        
        .send-request-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 30px 40px;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .send-request-icon {
            font-size: 2rem;
        }
        
        .send-request-title {
            font-size: 1.5rem;
            font-weight: 600;
        }
        
        .send-request-body {
            padding: 40px;
        }
        
        .request-form {
            display: flex;
            gap: 15px;
            align-items: end;
        }
        
        .form-group {
            flex: 1;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #34495e;
            font-weight: 600;
            font-size: 14px;
        }
        
        .form-input {
            width: 100%;
            padding: 16px;
            border: 2px solid #e8ecf0;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #f8f9fa;
            color: #2c3e50;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        
        .form-input::placeholder {
            color: #95a5a6;
        }
        
        .primary-btn {
            padding: 16px 32px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            white-space: nowrap;
        }
        
        .primary-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 35px rgba(102, 126, 234, 0.4);
        }
        
        .primary-btn:active {
            transform: translateY(0);
        }
        
        /* =========================== FRIENDS SECTIONS =========================== */
        .friends-section {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            margin-bottom: 40px;
            position: relative;
        }
        
        .friends-section::before {
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
        
        .friends-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 30px 40px;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .friends-icon {
            font-size: 2rem;
        }
        
        .friends-title {
            font-size: 1.5rem;
            font-weight: 600;
        }
        
        .friends-body {
            padding: 40px;
        }
        
        /* =========================== FRIEND ITEMS =========================== */
        .friend-item, .request-item {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            border-left: 4px solid #e9ecef;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .friend-item:hover, .request-item:hover {
            transform: translateX(5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }
        
        .friend-item {
            border-left-color: #28a745;
        }
        
        .request-item {
            border-left-color: #fd7e14;
        }
        
        .friend-content, .request-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }
        
        .friend-info, .request-info {
            flex: 1;
        }
        
        .friend-name, .request-name {
            font-weight: 600;
            color: #2c3e50;
            font-size: 1.1rem;
            margin-bottom: 5px;
        }
        
        .friend-date, .request-date {
            color: #7f8c8d;
            font-size: 0.9rem;
        }
        
        .friend-actions, .request-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .action-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .btn-accept {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }
        
        .btn-accept:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }
        
        .btn-decline {
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
        }
        
        .btn-decline:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
        }
        
        .btn-send {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }
        
        .btn-send:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        .btn-remove {
            background: linear-gradient(135deg, #6c757d, #495057);
            color: white;
        }
        
        .btn-remove:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
        }
        
        /* =========================== ALERT STYLES =========================== */
        .alert {
            padding: 16px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-weight: 500;
            text-align: center;
        }
        
        .alert-success {
            background: linear-gradient(135deg, #00b894, #00a085);
            color: white;
            box-shadow: 0 6px 20px rgba(0, 184, 148, 0.3);
        }
        
        .alert-error {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            box-shadow: 0 6px 20px rgba(255, 107, 107, 0.3);
        }
        
        /* =========================== EMPTY STATE =========================== */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }
        
        .empty-state-icon {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        .empty-state-text {
            font-size: 1.2rem;
            font-style: italic;
        }
        
        /* =========================== QUICK LINKS =========================== */
        .quick-links-section {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            position: relative;
        }
        
        .quick-links-section::before {
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
        
        .quick-links-header {
            background: linear-gradient(135deg, #00b894, #00a085);
            color: white;
            padding: 30px 40px;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .quick-links-icon {
            font-size: 2rem;
        }
        
        .quick-links-title {
            font-size: 1.5rem;
            font-weight: 600;
        }
        
        .quick-links-body {
            padding: 40px;
        }
        
        .quick-links-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .quick-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px 20px;
            background: #f8f9fa;
            border-radius: 12px;
            text-decoration: none;
            color: #2c3e50;
            font-weight: 500;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        
        .quick-link:hover {
            background: #e9ecef;
            border-color: #667eea;
            color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            text-decoration: none;
        }
        
        .quick-link-icon {
            font-size: 1.2rem;
        }
        
        /* =========================== RESPONSIVE DESIGN =========================== */
        @media (max-width: 768px) {
            .main-container {
                margin: 60px auto 20px;
                padding: 0 20px;
            }
            
            .nav-home {
                position: relative;
                top: auto;
                left: auto;
                margin-bottom: 20px;
                display: inline-block;
            }
            
            .page-title {
                font-size: 2rem;
            }
            
            .request-form {
                flex-direction: column;
                gap: 20px;
            }
            
            .friend-content, .request-content {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .friend-actions, .request-actions {
                width: 100%;
                justify-content: center;
            }
            
            .quick-links-grid {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 480px) {
            .main-container {
                margin: 40px auto 20px;
                padding: 0 15px;
            }
            
            .page-title {
                font-size: 1.5rem;
            }
            
            .stats-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <a href="${pageContext.request.contextPath}/" class="nav-home">← Home</a>
    
    <div class="main-container">
        <div class="page-header">
            <h1 class="page-title">Friends</h1>
            <p class="page-subtitle">Connect with other quiz enthusiasts</p>
        </div>
        
        <!-- Success/Error Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        
        <!-- Friend Statistics -->
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-number">${friends.size()}</div>
                <div class="stat-label">Friends</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${pendingRequests.size()}</div>
                <div class="stat-label">Pending Requests</div>
            </div>
        </div>
        
        <!-- Send Friend Request Section -->
        <div class="send-request-section">
            <div class="send-request-header">
                <div class="send-request-icon">👥</div>
                <div class="send-request-title">Send Friend Request</div>
            </div>
            
            <div class="send-request-body">
                <form action="${pageContext.request.contextPath}/friends/request" method="post" class="request-form">
                    <div class="form-group">
                        <label for="friendUsername" class="form-label">Username</label>
                        <input type="text" id="friendUsername" name="friendUsername" class="form-input" 
                               placeholder="Enter username" required />
                    </div>
                    <button type="submit" class="primary-btn">Send Request</button>
                </form>
            </div>
        </div>
        
        <!-- Pending Friend Requests Section -->
        <div class="friends-section">
            <div class="friends-header">
                <div class="friends-icon">⏳</div>
                <div class="friends-title">Pending Friend Requests</div>
            </div>
            
            <div class="friends-body">
                <c:choose>
                    <c:when test="${empty pendingRequests}">
                        <div class="empty-state">
                            <div class="empty-state-icon">📭</div>
                            <div class="empty-state-text">No pending friend requests</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="request" items="${pendingRequests}">
                            <div class="request-item">
                                <div class="request-content">
                                    <div class="request-info">
                                        <div class="request-name">Request from: ${usernames[request.requesterId]}</div>
                                        <div class="request-date">
                                            <fmt:formatDate value="${request.dateRequested}" pattern="MMM dd, yyyy HH:mm" />
                                        </div>
                                    </div>
                                    <div class="request-actions">
                                        <form action="${pageContext.request.contextPath}/friends/accept" method="post" style="display: inline;">
                                            <input type="hidden" name="friendshipId" value="${request.friendshipId}" />
                                            <button type="submit" class="action-btn btn-accept">Accept</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/friends/decline" method="post" style="display: inline;">
                                            <input type="hidden" name="friendshipId" value="${request.friendshipId}" />
                                            <button type="submit" class="action-btn btn-decline">Decline</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- Friends List Section -->
        <div class="friends-section">
            <div class="friends-header">
                <div class="friends-icon">👥</div>
                <div class="friends-title">My Friends</div>
            </div>
            
            <div class="friends-body">
                <c:choose>
                    <c:when test="${empty friends}">
                        <div class="empty-state">
                            <div class="empty-state-icon">👥</div>
                            <div class="empty-state-text">No friends yet. Send some friend requests to get started!</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="friend" items="${friends}">
                            <div class="friend-item">
                                <div class="friend-content">
                                    <div class="friend-info">
                                        <div class="friend-name">
                                            <c:choose>
                                                <c:when test="${friend.requesterId == sessionScope.user.userId}">
                                                    ${usernames[friend.receiverId]}
                                                </c:when>
                                                <c:otherwise>
                                                    ${usernames[friend.requesterId]}
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="friend-date">
                                            Friends since: <fmt:formatDate value="${friend.dateAccepted}" pattern="MMM dd, yyyy" />
                                        </div>
                                    </div>
                                    <div class="friend-actions">
                                        <c:set var="friendId" value="${friend.requesterId == sessionScope.user.userId ? friend.receiverId : friend.requesterId}" />
                                        <a href="${pageContext.request.contextPath}/messages?friendUsername=${usernames[friendId]}" class="action-btn btn-send">Send Message</a>
                                        <form action="${pageContext.request.contextPath}/friends/remove" method="post" style="display: inline;">
                                            <input type="hidden" name="friendId" value="${friendId}" />
                                            <button type="submit" class="action-btn btn-remove" 
                                                    onclick="return confirm('Are you sure you want to remove this friend?');">Remove Friend</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- Quick Links Section -->
        <div class="quick-links-section">
            <div class="quick-links-header">
                <div class="quick-links-icon">🔗</div>
                <div class="quick-links-title">Quick Links</div>
            </div>
            
            <div class="quick-links-body">
                <div class="quick-links-grid">
                    <a href="${pageContext.request.contextPath}/messages" class="quick-link">
                        <span class="quick-link-icon">💬</span>
                        <span>View Messages</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/quiz/create" class="quick-link">
                        <span class="quick-link-icon">📝</span>
                        <span>Create Quiz</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/" class="quick-link">
                        <span class="quick-link-icon">🏠</span>
                        <span>Home</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html> 