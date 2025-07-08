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
    model.Quiz quiz = (model.Quiz) session.getAttribute("currentQuiz");
    Boolean immediateCorrection = (quiz != null) ? quiz.isImmediateCorrection() : false;
    String feedback = (String) request.getAttribute("feedback");
    String correctAnswer = (String) request.getAttribute("correctAnswer");
    String submittedAnswer = (String) request.getAttribute("submittedAnswer");
    boolean showNext = (immediateCorrection != null && immediateCorrection && feedback != null);
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
    <input type="hidden" name="questionNumber" value="<%= questionNumber %>" />
    <input type="hidden" name="feedbackState" value="<%= (showNext ? "shown" : "none") %>" />
<% if ("multiple-choice".equals(question.getQuestionType()) && question.getChoices() != null) { %>
    <% for (String choice : question.getChoices()) { %>
        <label>
            <input type="radio" name="answer" value="<%= choice %>" <%= showNext ? "disabled" : "" %> <%= (submittedAnswer != null && submittedAnswer.equals(choice)) ? "checked" : "" %> required>
            <%= choice %>
        </label><br/>
    <% } %>
<% } else { %>
    <input type="text" name="answer" value="<%= submittedAnswer != null ? submittedAnswer : "" %>" <%= showNext ? "disabled" : "" %> required />
<% } %>
    <% if (!showNext) { %>
        <button type="submit" name="action" value="submit">Submit</button>
    <% } else { %>
        <button type="submit" name="action" value="next">Next</button>
    <% } %>
</form>
<% if (immediateCorrection != null && immediateCorrection && feedback != null) { 
     String feedbackColor = ("Correct".equals(feedback)) ? "green" : "red"; %>
    <div style="margin-top:1em; color:<%= feedbackColor %>; font-weight:bold;">
        <%= feedback %>
        <% if ("Incorrect".equals(feedback) && correctAnswer != null) { %>
            <br/>Correct answer: <%= correctAnswer %>
        <% } %>
    </div>
<% } %>
</body>
</html>
