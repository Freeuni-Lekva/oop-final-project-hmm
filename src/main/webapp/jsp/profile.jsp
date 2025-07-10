<%--
  Created by IntelliJ IDEA.
  User: nika
  Date: 7/9/2025
  Time: 9:38 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Achievement, java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

<%
    String[] allAchievements = {
        "amateur_author",
        "prolific_author",
        "prodigious_author",
        "practice_makes_perfect",
        "i_am_the_greatest",
        "quiz_machine"
    };
    String[] achievementNames = {
        "Amateur Author",
        "Prolific Author",
        "Prodigious Author",
        "Practice Makes Perfect",
        "I am the Greatest",
        "Quiz Machine"
    };
    String[] achievementDescs = {
        "Created your first quiz!",
        "Created 5 quizzes!",
        "Created 10 quizzes!",
        "Took a quiz in practice mode!",
        "Achieved the highest score on a quiz!",
        "Took 10 quizzes!"
    };
    pageContext.setAttribute("allAchievements", allAchievements);
    pageContext.setAttribute("achievementNames", achievementNames);
    pageContext.setAttribute("achievementDescs", achievementDescs);
%>
<div class="profile-section">
    <span class="profile-label">Achievements:</span>
    <c:set var="unlocked" value="${fn:length(achievements)}" />
    <span style="margin-left:10px; color:#555;">${unlocked}/6 unlocked</span>
    <div style="margin: 16px 0 0 0;">
        <c:forEach var="achType" items="${allAchievements}" varStatus="status">
            <c:set var="hasIt" value="false" />
            <c:forEach var="ach" items="${achievements}">
                <c:if test="${ach.achievementType == achType}">
                    <c:set var="hasIt" value="true" />
                </c:if>
            </c:forEach>
            <div style="display: flex; align-items: center; margin-bottom: 10px;">
                <span style="font-size: 1.5em; margin-right: 10px;">
                    <c:choose>
                        <c:when test="${hasIt}">&#x2705;</c:when>
                        <c:otherwise>&#x2B1C;</c:otherwise>
                    </c:choose>
                </span>
                <span style="font-weight: bold; min-width: 160px;">${achievementNames[status.index]}</span>
                <span style="margin-left: 10px; color: #444;">&#8594; ${achievementDescs[status.index]}</span>
            </div>
        </c:forEach>
    </div>
</div>

<h2>Change Password</h2>
<form method="post" action="${pageContext.request.contextPath}/profile">
    <label for="currentPassword">Current Password:</label><br/>
    <input type="password" id="currentPassword" name="currentPassword" required /><br/>
    <label for="newPassword">New Password:</label><br/>
    <input type="password" id="newPassword" name="newPassword" required /><br/>
    <label for="confirmNewPassword">Confirm New Password:</label><br/>
    <input type="password" id="confirmNewPassword" name="confirmNewPassword" required /><br/>
    <input type="submit" value="Change Password" />
</form>
<c:if test="${not empty passwordError}">
    <div style="color: red; margin-top: 10px;">${passwordError}</div>
</c:if>
<c:if test="${not empty passwordSuccess}">
    <div style="color: green; margin-top: 10px;">${passwordSuccess}</div>
</c:if>

</body>
</html>
