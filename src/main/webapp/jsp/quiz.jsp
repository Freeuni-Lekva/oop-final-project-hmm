<%--
  Created by IntelliJ IDEA.
  User: nika
  Date: 7/7/2025
  Time: 6:36 PM//
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Quiz" %>
<%
    Quiz quiz = (Quiz) request.getAttribute("quiz");
%>
<html>
<head>
    <title>Quiz Details</title>
</head>
<body>
<h2>${quiz.title}</h2>
<p>${quiz.description}</p>

<!-- Quiz Summary/Rankings Button -->
<a href="${pageContext.request.contextPath}/quiz-summery?quizId=${quiz.quizId}">View Quiz Rankings & Summary</a>
<br/><br/>

<form action="${pageContext.request.contextPath}/takeQuiz" method="get">
    <input type="hidden" name="id" value="${quiz.quizId}" />
    <label><input type="checkbox" name="practiceMode" value="true"> Practice Mode</label><br/>
    <button type="submit">Start Quiz</button>
</form>
<a href="${pageContext.request.contextPath}/index">Back to Home</a>
</body>
</html>
