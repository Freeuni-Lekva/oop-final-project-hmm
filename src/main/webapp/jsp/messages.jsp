<%--
  Messages page for Quiz Website
  Handles viewing and sending messages (notes, friend requests, challenges)
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.Message" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <title>Messages - Quiz Website</title>
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
            max-width: 1000px;
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
        
        /* =========================== MESSAGE SEND SECTION =========================== */
        .message-send-section {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            margin-bottom: 40px;
            position: relative;
        }
        
        .message-send-section::before {
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
        
        .message-send-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 30px 40px;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .message-send-icon {
            font-size: 2rem;
        }
        
        .message-send-title {
            font-size: 1.5rem;
            font-weight: 600;
        }
        
        .message-send-body {
            padding: 40px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #34495e;
            font-weight: 600;
            font-size: 14px;
        }
        
        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 16px;
            border: 2px solid #e8ecf0;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #f8f9fa;
            color: #2c3e50;
        }
        
        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        
        .form-input::placeholder, .form-textarea::placeholder {
            color: #95a5a6;
        }
        
        .form-textarea {
            height: 100px;
            resize: vertical;
        }
        
        .form-note {
            font-size: 0.9rem;
            color: #7f8c8d;
            margin-top: 5px;
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
        }
        
        .primary-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 35px rgba(102, 126, 234, 0.4);
        }
        
        .primary-btn:active {
            transform: translateY(0);
        }
        
        /* =========================== MESSAGES LIST SECTION =========================== */
        .messages-section {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            position: relative;
        }
        
        .messages-section::before {
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
        
        .messages-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 30px 40px;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .messages-icon {
            font-size: 2rem;
        }
        
        .messages-title {
            font-size: 1.5rem;
            font-weight: 600;
        }
        
        .messages-body {
            padding: 40px;
        }
        
        /* =========================== FILTER BUTTONS =========================== */
        .filter-container {
            margin-bottom: 30px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .filter-btn {
            padding: 12px 20px;
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 25px;
            color: #6c757d;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 14px;
        }
        
        .filter-btn:hover {
            background: #e9ecef;
            border-color: #667eea;
            color: #667eea;
        }
        
        .filter-btn.active {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-color: #667eea;
            color: white;
        }
        
        /* =========================== MESSAGE ITEMS =========================== */
        .message-item {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            border-left: 4px solid #e9ecef;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .message-item:hover {
            transform: translateX(5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }
        
        .message-item.unread {
            border-left-color: #667eea;
            background: linear-gradient(135deg, #f0f4ff, #e8f0ff);
        }
        
        .message-item.friend_request {
            border-left-color: #28a745;
        }
        
        .message-item.challenge {
            border-left-color: #fd7e14;
        }
        
        .message-item.note {
            border-left-color: #6c757d;
        }
        
        .message-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        
        .message-type {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            font-size: 0.9rem;
            padding: 6px 12px;
            border-radius: 20px;
            color: white;
        }
        
        .message-type.friend_request {
            background: linear-gradient(135deg, #28a745, #20c997);
        }
        
        .message-type.challenge {
            background: linear-gradient(135deg, #fd7e14, #ff8c42);
        }
        
        .message-type.note {
            background: linear-gradient(135deg, #6c757d, #495057);
        }
        
        .message-date {
            color: #7f8c8d;
            font-size: 0.85rem;
        }
        
        .message-sender {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
            font-size: 1.1rem;
        }
        
        .message-content {
            color: #34495e;
            line-height: 1.6;
            margin-bottom: 15px;
        }
        
        .message-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .action-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 0.85rem;
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
        
        .btn-view {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }
        
        .btn-view:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        .challenge-info {
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            border: 1px solid #ffeaa7;
            padding: 12px;
            border-radius: 8px;
            margin-top: 10px;
            font-size: 0.9rem;
            color: #856404;
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
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .filter-container {
                justify-content: center;
            }
            
            .message-header {
                flex-direction: column;
                gap: 10px;
            }
            
            .message-actions {
                justify-content: center;
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
    <script>
        function showMessageForm(type) {
            document.getElementById('messageType').value = type;
            const quizField = document.getElementById('quizIdField');
            const submitBtn = document.getElementById('submitBtn');
            
            if (type === 'challenge') {
                quizField.style.display = 'block';
                submitBtn.textContent = 'Send Challenge';
            } else {
                quizField.style.display = 'none';
                submitBtn.textContent = type === 'friend_request' ? 'Send Friend Request' : 'Send Note';
            }
        }
        
        function filterMessages(type) {
            const messages = document.querySelectorAll('.message-item');
            const buttons = document.querySelectorAll('.filter-btn');
            
            buttons.forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            
            messages.forEach(msg => {
                if (type === 'all' || msg.dataset.type === type) {
                    msg.style.display = 'block';
                } else {
                    msg.style.display = 'none';
                }
            });
        }
    </script>
</head>
<body>
    <a href="${pageContext.request.contextPath}/" class="nav-home">← Home</a>
    
    <div class="main-container">
        <div class="page-header">
            <h1 class="page-title">Messages</h1>
            <p class="page-subtitle">Connect with friends and manage your communications</p>
        </div>
        
        <!-- Success/Error Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        
        <!-- Message Statistics -->
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-number">${messages.size()}</div>
                <div class="stat-label">Total Messages</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <c:set var="unreadCount" value="0" />
                    <c:forEach var="message" items="${messages}">
                        <c:if test="${!message.read}">
                            <c:set var="unreadCount" value="${unreadCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${unreadCount}
                </div>
                <div class="stat-label">Unread</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <c:set var="challengeCount" value="0" />
                    <c:forEach var="message" items="${messages}">
                        <c:if test="${message.messageType == 'challenge'}">
                            <c:set var="challengeCount" value="${challengeCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${challengeCount}
                </div>
                <div class="stat-label">Challenges</div>
            </div>
        </div>
        
        <!-- Send Message Section -->
        <div class="message-send-section">
            <div class="message-send-header">
                <div class="message-send-icon">📤</div>
                <div class="message-send-title">Send Message</div>
            </div>
            
            <div class="message-send-body">
                <form action="${pageContext.request.contextPath}/messages/send" method="post">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="recipient" class="form-label">Recipient Username</label>
                            <input type="text" id="recipient" name="recipient" class="form-input" required 
                                   placeholder="Enter username" value="${param.friendUsername}" />
                        </div>
                        <div class="form-group">
                            <label for="messageTypeSelect" class="form-label">Message Type</label>
                            <select id="messageTypeSelect" class="form-select" onchange="showMessageForm(this.value)" required>
                                <option value="note">📝 Note</option>
                                <option value="friend_request">👥 Friend Request</option>
                                <option value="challenge">🎯 Quiz Challenge</option>
                            </select>
                            <input type="hidden" id="messageType" name="messageType" value="note" />
                            <div class="form-note">* You can only send quiz challenges to your friends.</div>
                        </div>
                    </div>
                    
                    <div class="form-group" id="quizIdField" style="display: none;">
                        <label for="quizName" class="form-label">Quiz Name (for challenges)</label>
                        <input type="text" id="quizName" name="quizName" class="form-input" placeholder="Enter quiz name" />
                    </div>
                    
                    <div class="form-group">
                        <label for="content" class="form-label">Message Content</label>
                        <textarea id="content" name="content" class="form-textarea" required 
                                  placeholder="Enter your message here..."></textarea>
                    </div>
                    
                    <button type="submit" id="submitBtn" class="primary-btn">Send Note</button>
                </form>
            </div>
        </div>
        
        <!-- Messages List Section -->
        <div class="messages-section">
            <div class="messages-header">
                <div class="messages-icon">📬</div>
                <div class="messages-title">Your Messages</div>
            </div>
            
            <div class="messages-body">
                <!-- Message Filter -->
                <div class="filter-container">
                    <button class="filter-btn active" onclick="filterMessages('all')">All Messages</button>
                    <button class="filter-btn" onclick="filterMessages('note')">📝 Notes</button>
                    <button class="filter-btn" onclick="filterMessages('friend_request')">👥 Friend Requests</button>
                    <button class="filter-btn" onclick="filterMessages('challenge')">🎯 Challenges</button>
                </div>
                
                <c:choose>
                    <c:when test="${empty messages}">
                        <div class="empty-state">
                            <div class="empty-state-icon">📭</div>
                            <div class="empty-state-text">No messages yet. Connect with friends to start messaging!</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="message" items="${messages}">
                            <div class="message-item ${!message.read ? 'unread' : ''} ${message.messageType}" data-type="${message.messageType}">
                                <div class="message-header">
                                    <span class="message-type ${message.messageType}">
                                        <c:choose>
                                            <c:when test="${message.messageType == 'note'}">📝 Note</c:when>
                                            <c:when test="${message.messageType == 'friend_request'}">👥 Friend Request</c:when>
                                            <c:when test="${message.messageType == 'challenge'}">🎯 Quiz Challenge</c:when>
                                        </c:choose>
                                    </span>
                                    <span class="message-date">
                                        <fmt:formatDate value="${message.dateSent}" pattern="MMM dd, yyyy HH:mm" />
                                    </span>
                                </div>
                                
                                <div class="message-sender">From: ${message.senderUsername}</div>
                                <div class="message-content">${message.content}</div>
                                
                                <c:if test="${message.messageType == 'challenge' && message.quizId != null}">
                                    <div class="challenge-info">
                                        🎯 Challenge includes a quiz! Click "View Quiz" to take it.
                                    </div>
                                </c:if>
                                
                                <div class="message-actions">
                                    <c:choose>
                                        <c:when test="${message.messageType == 'friend_request'}">
                                            <form action="${pageContext.request.contextPath}/friends/accept" method="post" style="display: inline;">
                                                <input type="hidden" name="friendshipId" value="${message.id}" />
                                                <button type="submit" class="action-btn btn-accept">Accept</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/friends/decline" method="post" style="display: inline;">
                                                <input type="hidden" name="friendshipId" value="${message.id}" />
                                                <button type="submit" class="action-btn btn-decline">Decline</button>
                                            </form>
                                        </c:when>
                                        <c:when test="${message.messageType == 'challenge' && message.quizId != null}">
                                            <a href="${pageContext.request.contextPath}/takeQuiz?quizId=${message.quizId}" class="action-btn btn-view">View Quiz</a>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html> 