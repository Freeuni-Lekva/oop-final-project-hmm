<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Question" %>
<%
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    Boolean practiceMode = (Boolean) request.getAttribute("practiceMode");
    model.Quiz quiz = (model.Quiz) session.getAttribute("currentQuiz");
    Boolean immediateCorrection = (quiz != null) ? quiz.isImmediateCorrection() : false;
    String[] feedbacks = (String[]) request.getAttribute("feedbacks"); // Optional: feedback per question
    String[] correctAnswers = (String[]) request.getAttribute("correctAnswers"); // Optional: correct answers per question
%>
<html>
<head>
    <title>Quiz - All Questions</title>
</head>
<body>
<% if (practiceMode != null && practiceMode) { %>
    <div style="color: #007bff; font-weight: bold;">You are taking this quiz in Practice Mode. Your score will not appear on the leaderboard.</div>
<% } %>
<h2>Quiz</h2>
<form action="${pageContext.request.contextPath}/takeQuiz" method="post">
    <input type="hidden" name="allAtOnce" value="true" />
    <ol>
    <% for (int i = 0; i < questions.size(); i++) {
        Question q = questions.get(i);
    %>
        <li>
            <p><%= q.getQuestionText() %></p>
            <% if ("picture-response".equals(q.getQuestionType()) && q.getImageUrl() != null && !q.getImageUrl().isEmpty()) { %>
                <img src="<%= q.getImageUrl() %>" alt="Question Image" style="max-width:400px; max-height:300px;"/>
            <% } %>
            <% if ("multiple-choice".equals(q.getQuestionType()) && q.getChoices() != null) { %>
                <% for (String choice : q.getChoices()) { %>
                    <label>
                        <input type="radio" name="answer<%=i%>" value="<%= choice %>" required>
                        <%= choice %>
                    </label><br/>
                <% } %>
            <% } else { %>
                <input type="text" name="answer<%=i%>" required />
            <% } %>
            <% if (immediateCorrection != null && immediateCorrection && feedbacks != null && feedbacks.length > i && feedbacks[i] != null) {
                String feedbackColor = ("Correct".equals(feedbacks[i])) ? "green" : "red"; %>
                <div style="margin-top:1em; color:<%= feedbackColor %>; font-weight:bold;">
                    <%= feedbacks[i] %>
                    <% if ("Incorrect".equals(feedbacks[i]) && correctAnswers != null && correctAnswers.length > i && correctAnswers[i] != null) { %>
                        <br/>Correct answer: <%= correctAnswers[i] %>
                    <% } %>
                </div>
            <% } %>
        </li>
    <% } %>
    </ol>
    <button type="submit">Finish Quiz</button>
</form>
</body>
</html> 