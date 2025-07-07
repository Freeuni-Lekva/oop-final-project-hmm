<%--
  Created by IntelliJ IDEA.
  User: nika
  Date: 7/6/2025
  Time: 9:50 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Register</title>
</head>
<body>
    <h1>Register</h1>
    <form method="post" action="register">
        Username: <input type="text" name="username" required /><br/>
        Email: <input type="email" name="email" required /><br/>
        Password: <input type="password" name="password" required /><br/>
        <input type="submit" value="Register" />
    </form>
    <% if (request.getAttribute("error") != null) { %>
        <p style="color:red;"><%= request.getAttribute("error") %></p>
    <% } %>
    <p>Already have an account? <a href="login">Login here</a></p>
</body>
</html>
