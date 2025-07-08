<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Leaderboard</title>
</head>
<body>
<h1>Leaderboard</h1>
<table border="1">
    <tr>
        <th>Quiz Title</th>
        <th>Username</th>
        <th>Best Score</th>
    </tr>
    <% 
        java.util.List<model.LeaderboardEntry> leaderboard = 
            (java.util.List<model.LeaderboardEntry>) request.getAttribute("leaderboard");
        if (leaderboard != null) {
            for (model.LeaderboardEntry entry : leaderboard) {
    %>
    <tr>
        <td><%= entry.getQuizTitle() %></td>
        <td><%= entry.getUsername() %></td>
        <td><%= entry.getBestScore() %></td>
    </tr>
    <% 
            }
        }
    %>
</table>
<a href="${pageContext.request.contextPath}/index">Back to Home</a>
</body>
</html> 