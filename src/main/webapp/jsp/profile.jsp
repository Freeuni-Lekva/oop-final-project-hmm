<%--
  Created by IntelliJ IDEA.
  User: nika
  Date: 7/9/2025
  Time: 9:38 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Achievement, java.util.List" %>
<html>
<head>
    <title>My Profile</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .profile-section { margin-bottom: 30px; }
        .achievements-list { list-style: none; padding: 0; }
        .achievements-list li { margin-bottom: 8px; }
        .profile-label { font-weight: bold; }
    </style>
</head>
<body>
<c:choose>
    <c:when test="${isOwnProfile}">
        <a href="${pageContext.request.contextPath}/"><button>Return to Home</button></a>
    </c:when>
    <c:when test="${not isOwnProfile and not empty quizId}">
        <a href="${pageContext.request.contextPath}/quizSummary.jsp?quizId=${quizId}"><button>Back to Rankings</button></a>
    </c:when>
</c:choose>
<h1>My Profile</h1>

<div class="profile-section">
    <span class="profile-label">Username:</span>
    <span>${userInfo.username}</span><br/>
    <span class="profile-label">Email:</span>
    <span>${userInfo.email}</span><br/>
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
