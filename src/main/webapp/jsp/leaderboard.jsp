<%--
  Created by IntelliJ IDEA.
  User: nika
  Date: 7/8/2025
  Time: 6:38 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.LeaderboardEntry" %>
<%
    List<LeaderboardEntry> leaderboard = (List<LeaderboardEntry>) request.getAttribute("leaderboard");
%>
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
    <% if (leaderboard != null && !leaderboard.isEmpty()) {
           for (LeaderboardEntry entry : leaderboard) { %>
    <tr>
        <td><%= entry.getQuizTitle() %></td>
        <td><%= entry.getUsername() %></td>
        <td><%= String.format("%.2f", entry.getBestScore()) %></td>
    </tr>
    <%     }
         } else { %>
    <tr><td colspan="3">No leaderboard data available.</td></tr>
    <% } %>
</table>
<br/>
<a href="${pageContext.request.contextPath}/index.jsp"><button>Back to Home</button></a>
</body>
</html>
