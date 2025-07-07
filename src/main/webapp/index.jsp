<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Object user = session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
%>
<html>
<head>
    <title>Home</title>
</head>
<body>
    <h1>Welcome to the Quiz Website!</h1>
    <p>You are logged in.</p>
    <form action="logout" method="get">
        <input type="submit" value="Logout" />
    </form>
</body>
</html>