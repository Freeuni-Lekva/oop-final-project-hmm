<%--
  Created by IntelliJ IDEA.
  User: nika
  Date: 7/6/2025
  Time: 9:50 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <style>
        .nav-home { margin: 10px; text-decoration: none; color: #007bff; font-weight: bold; }
        .nav-home:hover { color: #0056b3; }
    </style>
</head>
<body>
    <a href="${pageContext.request.contextPath}/" class="nav-home">← Home</a>
    <h1>Login</h1>
    <form method="post" action="login">
        Username: <input type="text" name="username" required /><br/>
        Password: <input type="password" name="password" required /><br/>
        <input type="submit" value="Login" />
    </form>
    <% if (request.getAttribute("error") != null) { %>
        <p style="color:red;"><%= request.getAttribute("error") %></p>
    <% } %>
    <p>Don't have an account? <a href="register">Register here</a></p>
</body>
</html>
