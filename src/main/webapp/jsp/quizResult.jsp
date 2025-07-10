<%--
  Created by IntelliJ IDEA.
  User: nika
  Date: 7/8/2025
  Time: 6:12 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Double score = (Double) request.getAttribute("score");
    Integer correct = (Integer) request.getAttribute("correct");
    Integer totalQuestions = (Integer) request.getAttribute("totalQuestions");
    Long timeTaken = (Long) request.getAttribute("timeTaken");
    Boolean practiceMode = (Boolean) request.getAttribute("practiceMode");
%>
<html>
<head>
    <title>Quiz Result</title>
</head>
<body>
<h2>Quiz Complete!</h2>
<% if (practiceMode != null && practiceMode) { %>
    <div style="color: #007bff; font-weight: bold;">You took this quiz in Practice Mode. Your score will not appear on the leaderboard.</div>
<% } %>
<p>Your Score: <%= String.format("%.2f", score) %>%</p>
<p>Correct Answers: <%= correct %> / <%= totalQuestions %></p>
<p>Time Taken: <%= timeTaken %> seconds</p>
<a href="${pageContext.request.contextPath}/"><button>Back to Home</button></a>
</body>
</html>
