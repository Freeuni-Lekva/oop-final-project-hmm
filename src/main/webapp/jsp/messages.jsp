<%--
  Messages page for Quiz Website
  Handles viewing and sending messages (notes, friend requests, challenges)
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.Message" %>
<!DOCTYPE html>
<html>
<head>
    <title>Messages - Quiz Website</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 2em; background-color: #f8f9fa; }
        .nav-home { margin-bottom: 20px; display: inline-block; text-decoration: none; color: #007bff; font-weight: bold; }
        .nav-home:hover { color: #0056b3; }
        .container { max-width: 900px; margin: auto; }
        .section { margin-bottom: 2em; padding: 1.5em; border: 1px solid #ddd; border-radius: 8px; background: white; }
        .section h3 { margin-top: 0; color: #333; border-bottom: 2px solid #007bff; padding-bottom: 0.5em; }
        .message-item { padding: 1em; margin: 0.5em 0; border: 1px solid #eee; border-radius: 5px; background: #fafafa; }
        .message-item.unread { border-left: 4px solid #007bff; background: #f0f8ff; }
        .message-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.5em; }
        .message-type { font-weight: bold; color: #007bff; font-size: 0.9em; }
        .message-type.friend_request { color: #28a745; }
        .message-type.challenge { color: #fd7e14; }
        .message-type.note { color: #6c757d; }
        .message-date { color: #666; font-size: 0.8em; }
        .message-sender { font-weight: bold; color: #333; margin-bottom: 0.3em; }
        .message-content { color: #555; line-height: 1.4; }
        .message-actions { margin-top: 0.5em; display: flex; gap: 0.5em; }
        .btn { padding: 0.4em 0.8em; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; font-size: 0.85em; }
        .btn-small { padding: 0.3em 0.6em; font-size: 0.8em; }
        .btn-primary { background: #007bff; color: white; }
        .btn-primary:hover { background: #0056b3; }
        .btn-success { background: #28a745; color: white; }
        .btn-success:hover { background: #218838; }
        .btn-warning { background: #ffc107; color: #212529; }
        .btn-warning:hover { background: #e0a800; }
        .form-container { padding: 1.5em; border: 1px solid #ddd; border-radius: 8px; background: white; }
        .form-group { margin-bottom: 1em; }
        .form-group label { display: block; margin-bottom: 0.3em; font-weight: bold; color: #333; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 0.5em; border: 1px solid #aaa; border-radius: 4px; font-size: 0.9em; }
        .form-group textarea { height: 80px; resize: vertical; }
        .form-row { display: flex; gap: 1em; }
        .form-row .form-group { flex: 1; }
        .alert { padding: 1em; margin: 1em 0; border-radius: 5px; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-danger { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .empty-state { text-align: center; color: #666; font-style: italic; padding: 2em; }
        .message-filter { margin-bottom: 1em; }
        .filter-btn { background: #e9ecef; color: #495057; border: 1px solid #adb5bd; margin-right: 0.5em; }
        .filter-btn.active { background: #007bff; color: white; border-color: #007bff; }
        .stats { display: flex; gap: 1em; margin-bottom: 1em; }
        .stat-item { background: #e9ecef; padding: 0.8em; border-radius: 5px; text-align: center; flex: 1; }
        .stat-number { font-size: 1.2em; font-weight: bold; color: #007bff; }
        .stat-label { color: #666; font-size: 0.8em; }
        .challenge-info { background: #fff3cd; padding: 0.5em; border-radius: 3px; margin-top: 0.5em; font-size: 0.9em; }
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
    
    <div class="container">
        <h1>Messages</h1>
        
        <!-- Success/Error Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <!-- Message Statistics -->
        <div class="stats">
            <div class="stat-item">
                <div class="stat-number">${messages.size()}</div>
                <div class="stat-label">Total Messages</div>
            </div>
            <div class="stat-item">
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
            <div class="stat-item">
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
        <div class="section">
            <h3>Send Message</h3>
            <form action="${pageContext.request.contextPath}/messages/send" method="post">
                <div class="form-row">
                    <div class="form-group">
                        <label for="recipient">Recipient Username:</label>
                        <input type="text" id="recipient" name="recipient" required placeholder="Enter username" 
                               value="${param.friendUsername}" />
                    </div>
                    <div class="form-group">
                        <label for="messageTypeSelect">Message Type:</label>
                        <select id="messageTypeSelect" onchange="showMessageForm(this.value)" required>
                            <option value="note">Note</option>
                            <option value="friend_request">Friend Request</option>
                            <option value="challenge">Quiz Challenge</option>
                        </select>
                        <input type="hidden" id="messageType" name="messageType" value="note" />
                    </div>
                </div>
                
                <div class="form-group" id="quizIdField" style="display: none;">
                    <label for="quizId">Quiz ID (for challenges):</label>
                    <input type="number" id="quizId" name="quizId" placeholder="Enter quiz ID" />
                </div>
                
                <div class="form-group">
                    <label for="content">Message Content:</label>
                    <textarea id="content" name="content" required placeholder="Enter your message here..."></textarea>
                </div>
                
                <button type="submit" id="submitBtn" class="btn btn-primary">Send Note</button>
            </form>
        </div>
        
        <!-- Messages List Section -->
        <div class="section">
            <h3>Your Messages</h3>
            
            <!-- Message Filter -->
            <div class="message-filter">
                <button class="btn filter-btn active" onclick="filterMessages('all')">All</button>
                <button class="btn filter-btn" onclick="filterMessages('note')">Notes</button>
                <button class="btn filter-btn" onclick="filterMessages('friend_request')">Friend Requests</button>
                <button class="btn filter-btn" onclick="filterMessages('challenge')">Challenges</button>
            </div>
            
            <c:choose>
                <c:when test="${empty messages}">
                    <div class="empty-state">No messages yet. Connect with friends to start messaging!</div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="message" items="${messages}">
                        <div class="message-item ${!message.read ? 'unread' : ''}" data-type="${message.messageType}">
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
                                    🎯 Quiz Challenge: Quiz ID ${message.quizId}
                                    <a href="${pageContext.request.contextPath}/quiz?id=${message.quizId}" class="btn btn-small btn-warning">Take Challenge</a>
                                </div>
                            </c:if>
                            
                            <c:if test="${message.messageType == 'friend_request'}">
                                <div class="message-actions">
                                    <a href="${pageContext.request.contextPath}/friends" class="btn btn-small btn-success">Manage Friends</a>
                                </div>
                            </c:if>
                            
                            <div class="message-actions">
                                <a href="${pageContext.request.contextPath}/messages?friendUsername=${message.senderUsername}" class="btn btn-small btn-primary">Reply</a>
                                <c:if test="${!message.read}">
                                    <form action="${pageContext.request.contextPath}/messages/markRead" method="post" style="display:inline;">
                                        <input type="hidden" name="messageId" value="${message.messageId}" />
                                        <button type="submit" class="btn btn-small btn-success">Mark as Read</button>
                                    </form>
                                    <span class="btn btn-small" style="background: #17a2b8; color: white;">New</span>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Quick Links -->
        <div class="section">
            <h3>Quick Links</h3>
            <p>
                <a href="${pageContext.request.contextPath}/friends">Manage Friends</a> |
                <a href="${pageContext.request.contextPath}/quiz/create">Create Quiz</a> |
                <a href="${pageContext.request.contextPath}/Index.jsp">Home</a> |
            </p>
        </div>
    </div>
    
    <script>
        // Initialize form with default message type
        showMessageForm('note');
    </script>
</body>
</html> 