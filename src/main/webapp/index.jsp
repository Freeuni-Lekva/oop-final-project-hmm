<%@ page import="model.Quiz" %>
<%@ page import="java.util.List" %>
<%@ page import="dao.QuizDAO" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Object user = session.getAttribute("user");
    List<Quiz> quizzes = (List<model.Quiz>) request.getAttribute("quizzes");

    // If quizzes is null (direct JSP access), fetch them from DAO
    if (quizzes == null) {
        QuizDAO quizDAO = (QuizDAO) application.getAttribute("quizDAO");
        if (quizDAO != null) {
            try {
                quizzes = quizDAO.getAllQuizzes();
            } catch (Exception e) {
                // Handle error silently or set empty list
                quizzes = new java.util.ArrayList<>();
            }
        } else {//
            quizzes = new java.util.ArrayList<>();
        }
    }
%>
<html>
<head>
    <title>Quiz Website - Home</title>
    <style>
        .leaderboard-btn {
            float: right;
            margin-top: -40px;
            margin-right: 20px;
        }
    </style>
</head>
<body>
<h1>Welcome to the Quiz Website!</h1>
<a href="${pageContext.request.contextPath}/leaderboard" class="leaderboard-btn">
    <button>Leaderboard</button>
</a>
<h2>All Quizzes</h2>
<ul>
    <% if (quizzes != null && !quizzes.isEmpty()) {
        for (model.Quiz quiz : quizzes) { %>
    <li><a href="quiz?id=<%= quiz.getQuizId() %>"><%= quiz.getTitle() %></a></li>
    <%   }
    } else { %>
    <li>No quizzes available.</li>
    <% } %>
</ul>
<hr/>
<% if (user == null) { %>
<a href="login">Login</a> | <a href="register">Register</a>
<% } else { %>
<p>You are logged in.</p>
<a href="${pageContext.request.contextPath}/quiz/create">Create Quiz</a><br/>
<a href="${pageContext.request.contextPath}/friends">Manage Friends</a><br/>
<a href="${pageContext.request.contextPath}/messages">View Messages</a><br/>
<form action="logout" method="get">
    <input type="submit" value="Logout" />
</form>
<% } %>
</body>
</html>