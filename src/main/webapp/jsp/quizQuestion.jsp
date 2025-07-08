<%--
  Created by IntelliJ IDEA.
  User: nika
  Date: 7/8/2025
  Time: 6:12 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Question" %>
<%
    Question question = (Question) request.getAttribute("question");
    int questionNumber = (request.getAttribute("questionNumber") != null) ? (Integer) request.getAttribute("questionNumber") : 1;
    int totalQuestions = (request.getAttribute("totalQuestions") != null) ? (Integer) request.getAttribute("totalQuestions") : 1;
    Boolean practiceMode = (Boolean) request.getAttribute("practiceMode");
%>
<html>
<head>
    <title>Quiz Question</title>
</head>
<body>
<% if (practiceMode != null && practiceMode) { %>
    <div style="color: #007bff; font-weight: bold;">You are taking this quiz in Practice Mode. Your score will not appear on the leaderboard.</div>
<% } %>
<h2>Question <%= questionNumber %> of <%= totalQuestions %></h2>
<p><%= question.getQuestionText() %></p>
<% if ("picture-response".equals(question.getQuestionType()) && question.getImageUrl() != null && !question.getImageUrl().isEmpty()) { %>
    <img src="<%= question.getImageUrl() %>" alt="Question Image" style="max-width:400px; max-height:300px;"/>
<% } %>
<form action="${pageContext.request.contextPath}/takeQuiz" method="post">
    <input type="text" name="answer" required />
    <button type="submit"><%= (questionNumber == totalQuestions) ? "Finish Quiz" : "Next" %></button>
</form>
</body>
</html>
