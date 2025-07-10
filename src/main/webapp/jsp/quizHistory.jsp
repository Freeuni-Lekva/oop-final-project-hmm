<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.QuizAttempt, java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Quiz History</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 30px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        th { background: #f0f0f0; }
        .back-btn { margin-bottom: 20px; }
        .filter-form { margin-bottom: 20px; }
        .avg-score { margin-bottom: 20px; font-weight: bold; }
    </style>
</head>
<body>
<a href="quiz?id=${quizId}" class="back-btn"><button>Back to Quiz</button></a>
<h1>History for This Quiz</h1>
<form class="filter-form" method="get" action="quizHistory">
    <input type="hidden" name="quizId" value="${quizId}" />
    <label>Show:
        <select name="mode" onchange="this.form.submit()">
            <option value="all" ${mode == 'all' ? 'selected' : ''}>All Attempts</option>
            <option value="practice" ${mode == 'practice' ? 'selected' : ''}>Practice Mode Only</option>
            <option value="nonpractice" ${mode == 'nonpractice' ? 'selected' : ''}>Non-Practice Only</option>
        </select>
    </label>
</form>
<div class="avg-score">
    <c:if test="${averageScore >= 0}">
        Average Score: <fmt:formatNumber value="${averageScore}" maxFractionDigits="2" />
    </c:if>
</div>
<table>
    <tr>
        <th>Date</th>
        <th>Score</th>
        <th>Total Questions</th>
        <th>Time Taken</th>
        <th>Practice Mode</th>
    </tr>
    <c:forEach var="attempt" items="${attempts}">
        <tr>
            <td>${attempt.dateTaken}</td>
            <td>${attempt.score}</td>
            <td>${attempt.totalQuestions}</td>
            <td>${attempt.timeTaken} seconds</td>
            <td><c:choose><c:when test="${attempt.practice}">Yes</c:when><c:otherwise>No</c:otherwise></c:choose></td>
        </tr>
    </c:forEach>
    <c:if test="${empty attempts}">
        <tr><td colspan="5">No attempts yet.</td></tr>
    </c:if>
</table>
</body>
</html> 