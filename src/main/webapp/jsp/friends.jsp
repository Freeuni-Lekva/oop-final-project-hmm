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
    <style>
        body { font-family: Arial, sans-serif; margin: 2em; background-color: #f8f9fa; }
        .nav-home { margin-bottom: 20px; display: inline-block; text-decoration: none; color: #007bff; font-weight: bold; }
        .nav-home:hover { color: #0056b3; }
        .container { max-width: 800px; margin: auto; }
        .section { margin-bottom: 2em; padding: 1.5em; border: 1px solid #ddd; border-radius: 8px; background: white; }
        .section h3 { margin-top: 0; color: #333; border-bottom: 2px solid #007bff; padding-bottom: 0.5em; }
        .friend-item, .request-item { padding: 1em; margin: 0.5em 0; border: 1px solid #eee; border-radius: 5px; background: #fafafa; }
        .friend-item { display: flex; justify-content: space-between; align-items: center; }
        .request-item { display: flex; justify-content: space-between; align-items: center; }
        .friend-info { flex-grow: 1; }
        .friend-name { font-weight: bold; color: #333; }
        .friend-date { color: #666; font-size: 0.9em; margin-top: 0.3em; }
        .action-buttons { display: flex; gap: 0.5em; }
        .btn { padding: 0.5em 1em; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; font-size: 0.9em; }
        .btn-accept { background: #28a745; color: white; }
        .btn-accept:hover { background: #218838; }
        .btn-decline { background: #dc3545; color: white; }
        .btn-decline:hover { background: #c82333; }
        .btn-send { background: #007bff; color: white; }
        .btn-send:hover { background: #0056b3; }
        .form-container { padding: 1.5em; border: 1px solid #ddd; border-radius: 8px; background: white; }
        input[type="text"] { width: 200px; padding: 0.5em; margin-right: 0.5em; border: 1px solid #aaa; border-radius: 4px; }
        .message { padding: 1em; margin: 1em 0; border-radius: 5px; }
        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .empty-state { text-align: center; color: #666; font-style: italic; padding: 2em; }
        .stats { display: flex; gap: 2em; margin-bottom: 1em; }
        .stat-item { background: #e9ecef; padding: 1em; border-radius: 5px; text-align: center; flex: 1; }
        .stat-number { font-size: 1.5em; font-weight: bold; color: #007bff; }
        .stat-label { color: #666; font-size: 0.9em; }
    </style>
</head>
<body>
    <a href="${pageContext.request.contextPath}/" class="nav-home">← Home</a>
    
    <div class="container">
        <h1>Friends</h1>
        
        <!-- Success/Error Messages -->
        <c:if test="${not empty success}">
            <div class="message success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="message error">${error}</div>
        </c:if>
        
        <!-- Friend Statistics -->
        <div class="stats">
            <div class="stat-item">
                <div class="stat-number">${friends.size()}</div>
                <div class="stat-label">Friends</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">${pendingRequests.size()}</div>
                <div class="stat-label">Pending Requests</div>
            </div>
        </div>
        
        <!-- Send Friend Request Section -->
        <div class="section">
            <h3>Send Friend Request</h3>
            <form action="${pageContext.request.contextPath}/friends/request" method="post">
                <input type="text" name="friendUsername" placeholder="Enter username" required />
                <button type="submit" class="btn btn-send">Send Request</button>
            </form>
        </div>
        
        <!-- Pending Friend Requests Section -->
        <div class="section">
            <h3>Pending Friend Requests</h3>
            <c:choose>
                <c:when test="${empty pendingRequests}">
                    <div class="empty-state">No pending friend requests</div>
                </c:when>
                <c:otherwise>
                                         <c:forEach var="request" items="${pendingRequests}">
                         <div class="request-item">
                             <div class="friend-info">
                                 <div class="friend-name">Request from: ${usernames[request.requesterId]}</div>
                                 <div class="friend-date">
                                     <fmt:formatDate value="${request.dateRequested}" pattern="MMM dd, yyyy HH:mm" />
                                 </div>
                             </div>
                            <div class="action-buttons">
                                <form action="${pageContext.request.contextPath}/friends/accept" method="post" style="display: inline;">
                                    <input type="hidden" name="friendshipId" value="${request.friendshipId}" />
                                    <button type="submit" class="btn btn-accept">Accept</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/friends/decline" method="post" style="display: inline;">
                                    <input type="hidden" name="friendshipId" value="${request.friendshipId}" />
                                    <button type="submit" class="btn btn-decline">Decline</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Friends List Section -->
        <div class="section">
            <h3>My Friends</h3>
            <c:choose>
                <c:when test="${empty friends}">
                    <div class="empty-state">No friends yet. Send some friend requests to get started!</div>
                </c:when>
                <c:otherwise>
                                         <c:forEach var="friend" items="${friends}">
                         <div class="friend-item">
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
                                                         <div class="action-buttons">
                                 <c:set var="friendId" value="${friend.requesterId == sessionScope.user.userId ? friend.receiverId : friend.requesterId}" />
                                 <a href="${pageContext.request.contextPath}/messages?friendUsername=${usernames[friendId]}" class="btn btn-send">Send Message</a>
                                 <form action="${pageContext.request.contextPath}/friends/remove" method="post" style="display:inline; margin-left:8px;">
                                     <input type="hidden" name="friendId" value="${friendId}" />
                                     <button type="submit" class="btn btn-decline" onclick="return confirm('Are you sure you want to remove this friend?');">Remove Friend</button>
                                 </form>
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
                <a href="${pageContext.request.contextPath}/messages">View Messages</a> |
                <a href="${pageContext.request.contextPath}/quiz/create">Create Quiz</a> |
                <a href="${pageContext.request.contextPath}/index">Home</a>
            </p>
        </div>
    </div>
</body>
</html> 