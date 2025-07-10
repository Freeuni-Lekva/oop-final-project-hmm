<%--
  Created by IntelliJ IDEA.
  User: nika
  Date: 7/7/2025
  Time: 6:36 PM//
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Quiz" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<c:if test="${not empty sessionScope.user}">
    &nbsp;|&nbsp;
    <a href="${pageContext.request.contextPath}/quizHistory?quizId=${quiz.quizId}">History</a>
</c:if>
<br/><br/>

<form action="${pageContext.request.contextPath}/takeQuiz" method="get">
    <input type="hidden" name="id" value="${quiz.quizId}" />
    <label><input type="checkbox" name="practiceMode" value="true"> Practice Mode</label><br/>
    <button type="submit">Start Quiz</button>
</form>
<a href="${pageContext.request.contextPath}/">Back to Home</a>
</body>
</html>
