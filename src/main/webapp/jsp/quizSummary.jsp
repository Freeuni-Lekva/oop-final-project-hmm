<%--
  Created by IntelliJ IDEA.
  User: nika
  Date: 7/8/2025
  Time: 9:50 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<html>
<head>
    <title>Quiz Summary</title>
</head>
<body>
<h1>Quiz Summary</h1>

<%
    Map<Integer, String> userIdToUsername = (Map<Integer, String>)request.getAttribute("userIdToUsername");
    String quizId = request.getParameter("quizId");
%>

<h2>All-Time Top Performers</h2>
<table border="1">
    <tr><th>Username</th><th>Score</th><th>Total Questions</th><th>Time Taken (s)</th><th>Date Taken</th></tr>
    <% for (model.QuizAttempt a : (java.util.List<model.QuizAttempt>)request.getAttribute("allTimeTop")) { %>
        <tr>
            <td><a href="${pageContext.request.contextPath}/user?username=<%= userIdToUsername.get(a.getUserId()) %>&quizId=<%= quizId %>"><%= userIdToUsername.get(a.getUserId()) %></a></td>
            <td><%= a.getScore() %></td>
            <td><%= a.getTotalQuestions() %></td>
            <td><%= a.getTimeTaken() %></td>
            <td><%= a.getDateTaken() %></td>
        </tr>
    <% } %>
</table>

<h2>Top Performers in the Last Day</h2>
<table border="1">
    <tr><th>Username</th><th>Score</th><th>Total Questions</th><th>Time Taken (s)</th><th>Date Taken</th></tr>
    <% for (model.QuizAttempt a : (java.util.List<model.QuizAttempt>)request.getAttribute("lastDayTop")) { %>
        <tr>
            <td><a href="${pageContext.request.contextPath}/user?username=<%= userIdToUsername.get(a.getUserId()) %>&quizId=<%= quizId %>"><%= userIdToUsername.get(a.getUserId()) %></a></td>
            <td><%= a.getScore() %></td>
            <td><%= a.getTotalQuestions() %></td>
            <td><%= a.getTimeTaken() %></td>
            <td><%= a.getDateTaken() %></td>
        </tr>
    <% } %>
</table>

<h2>Recent Test Takers</h2>
<table border="1">
    <tr><th>Username</th><th>Score</th><th>Total Questions</th><th>Time Taken (s)</th><th>Date Taken</th></tr>
    <% for (model.QuizAttempt a : (java.util.List<model.QuizAttempt>)request.getAttribute("recentAttempts")) { %>
        <tr>
            <td><a href="${pageContext.request.contextPath}/user?username=<%= userIdToUsername.get(a.getUserId()) %>&quizId=<%= quizId %>"><%= userIdToUsername.get(a.getUserId()) %></a></td>
            <td><%= a.getScore() %></td>
            <td><%= a.getTotalQuestions() %></td>
            <td><%= a.getTimeTaken() %></td>
            <td><%= a.getDateTaken() %></td>
        </tr>
    <% } %>
</table>

<a href="quiz?id=<%= quizId %>">Back to Quiz</a>
</body>
</html>
