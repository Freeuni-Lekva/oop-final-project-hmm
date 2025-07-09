<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Achievement, java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
    <title>User Profile</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .profile-section { margin-bottom: 30px; }
        .achievements-list { list-style: none; padding: 0; }
        .achievements-list li { margin-bottom: 8px; }
        .profile-label { font-weight: bold; }
    </style>
</head>
<body>
<c:if test="${not empty quizId}">
    <a href="${pageContext.request.contextPath}/quiz-summery?quizId=${quizId}" style="display:inline-block;margin-bottom:20px;"><button>Back to Rankings</button></a>
</c:if>
<h1>User Profile</h1>
<c:if test="${not isOwnProfile}">
    <c:if test="${not empty success}">
        <div class="message">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="message">${error}</div>
    </c:if>
    <form action="${pageContext.request.contextPath}/friends/request" method="post" style="margin-bottom:20px;">
        <input type="hidden" name="friendUsername" value="${friendUsername != null ? friendUsername : userInfo.username}" />
        <input type="hidden" name="returnToProfile" value="true" />
        <c:if test="${not empty quizId}">
            <input type="hidden" name="quizId" value="${quizId}" />
        </c:if>
        <button type="submit">Send Friend Request</button>
    </form>
</c:if>
<div class="profile-section">
    <span class="profile-label">Username:</span>
    <span>${userInfo.username}</span><br/>
    <span class="profile-label">Registered on:</span>
    <span>${userInfo.createdDate}</span><br/>
</div>
<div class="profile-section">
    <span class="profile-label">Quizzes Taken:</span>
    <span>${quizCount}</span><br/>
    <span class="profile-label">Average Score:</span>
    <span>${avgScore}</span><br/>
</div>
<div class="profile-section">
    <span class="profile-label">Achievements:</span>
    <ul class="achievements-list">
        <c:choose>
            <c:when test="${not empty achievements}">
                <c:forEach var="ach" items="${achievements}">
                    <li>
                        <span>${ach.achievementType}</span>
                        <c:if test="${not empty ach.description}">
                            - <span>${ach.description}</span>
                        </c:if>
                        <span style="color: #888; font-size: 0.9em;">(${ach.dateEarned})</span>
                    </li>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <li>No achievements yet.</li>
            </c:otherwise>
        </c:choose>
    </ul>
</div>
</body>
</html> 