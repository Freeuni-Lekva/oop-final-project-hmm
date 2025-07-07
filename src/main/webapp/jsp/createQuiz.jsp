<%--
  Created by IntelliJ IDEA.
  User: nika
  Date: 7/7/2025
  Time: 6:36 PM //
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Quiz</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 2em; }
        .nav-home { margin-bottom: 20px; display: inline-block; text-decoration: none; color: #007bff; font-weight: bold; }
        .nav-home:hover { color: #0056b3; }
        .form-container { max-width: 500px; margin: auto; padding: 2em; border: 1px solid #ccc; border-radius: 8px; background: #fafafa; }
        label { display: block; margin-top: 1em; }
        input[type="text"], textarea { width: 100%; padding: 0.5em; margin-top: 0.5em; border: 1px solid #aaa; border-radius: 4px; }
        button { margin-top: 1.5em; padding: 0.7em 2em; border: none; background: #007bff; color: #fff; border-radius: 4px; cursor: pointer; }
        button:hover { background: #0056b3; }
        .error { color: red; margin-top: 1em; }
    </style>
</head>
<body>
<a href="${pageContext.request.contextPath}/" class="nav-home">← Home</a>
<div class="form-container">
    <h2>Create a New Quiz</h2>
    <form action="${pageContext.request.contextPath}/quiz/create" method="post">
        <label for="title">Quiz Title<span style="color:red;">*</span>:</label>
        <input type="text" id="title" name="title" required maxlength="100" placeholder="Enter quiz title">

        <label for="description">Description:</label>
        <textarea id="description" name="description" rows="4" maxlength="500" placeholder="Enter a short description (optional)"></textarea>

        <button type="submit">Create Quiz</button>
    </form>
    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>
</div>
</body>
</html>
