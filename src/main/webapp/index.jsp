<%@ page import="model.Quiz" %>
<%@ page import="model.QuizAttempt" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Object user = session.getAttribute("user");
    List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");
    List<Quiz> popularQuizzes = (List<Quiz>) request.getAttribute("popularQuizzes");
    List<Quiz> recentQuizzes = (List<Quiz>) request.getAttribute("recentQuizzes");
    List<QuizAttempt> recentAttempts = (List<QuizAttempt>) request.getAttribute("recentAttempts");
    List<Quiz> userCreatedQuizzes = (List<Quiz>) request.getAttribute("userCreatedQuizzes");

    // If quizzes is null (direct JSP access), fetch them from DAO
    if (quizzes == null) {
        // This block is no longer needed as quizzes are fetched by HomeController
        // QuizDAO quizDAO = (QuizDAO) application.getAttribute("quizDAO");
        // if (quizDAO != null) {
        //     try {
        //         quizzes = quizDAO.getAllQuizzes();
        //     } catch (Exception e) {
        //         // Handle error silently or set empty list
        //         quizzes = new java.util.ArrayList<>();
        //     }
        // } else {//
        //     quizzes = new java.util.ArrayList<>();
        // }
    }
%>
<html>
<head>
    <title>Quiz Website - Home</title>
    <style>
        /* Remove .leaderboard-btn CSS */
    </style>
</head>
<body>
<h1>Welcome to the Quiz Website!</h1>

<h2>Popular Quizzes</h2>
<ul>
    <% if (popularQuizzes != null && !popularQuizzes.isEmpty()) {
        for (Quiz quiz : popularQuizzes) { %>
    <li><a href="quiz?id=<%= quiz.getQuizId() %>"><%= quiz.getTitle() %></a></li>
    <%   }
    } else { %>
    <li>No popular quizzes available.</li>
    <% } %>
</ul>

<h2>Recently Created Quizzes</h2>
<ul>
    <% if (recentQuizzes != null && !recentQuizzes.isEmpty()) {
        for (Quiz quiz : recentQuizzes) { %>
    <li><a href="quiz?id=<%= quiz.getQuizId() %>"><%= quiz.getTitle() %></a></li>
    <%   }
    } else { %>
    <li>No recently created quizzes available.</li>
    <% } %>
</ul>

<% if (user != null && recentAttempts != null && !recentAttempts.isEmpty()) { %>
<h2>Your Recent Quiz Attempts</h2>
<ul>
    <% java.util.Set<Integer> shownQuizIds = new java.util.HashSet<>();
       java.util.Map<Integer, String> quizIdToTitle = new java.util.HashMap<>();
       if (quizzes != null) {
           for (Quiz quiz : quizzes) {
               quizIdToTitle.put(quiz.getQuizId(), quiz.getTitle());
           }
       }
       for (QuizAttempt attempt : recentAttempts) {
           int quizId = attempt.getQuizId();
           if (!shownQuizIds.contains(quizId)) {
               shownQuizIds.add(quizId);
               String quizTitle = quizIdToTitle.getOrDefault(quizId, "Quiz #" + quizId);
    %>
    <li><a href="quiz?id=<%= quizId %>"><%= quizTitle %></a></li>
    <%     }
       }
    %>
</ul>
<% } %>

<% if (user != null && userCreatedQuizzes != null && !userCreatedQuizzes.isEmpty()) { %>
<h2>Your Created Quizzes</h2>
<ul>
    <% for (Quiz quiz : userCreatedQuizzes) { %>
    <li><a href="quiz?id=<%= quiz.getQuizId() %>"><%= quiz.getTitle() %></a></li>
    <% } %>
</ul>
<% } %>

<hr/>
<% if (user == null) { %>
<a href="login">Login</a> | <a href="register">Register</a>
<% } else { %>
<p>You are logged in.</p>
<a href="${pageContext.request.contextPath}/profile">My Profile</a><br/>
<a href="${pageContext.request.contextPath}/quiz/create">Create Quiz</a><br/>
<a href="${pageContext.request.contextPath}/friends">Manage Friends</a><br/>
<a href="${pageContext.request.contextPath}/messages">View Messages</a><br/>
<form action="logout" method="get">
    <input type="submit" value="Logout" />
</form>
<% } %>
</body>
</html>