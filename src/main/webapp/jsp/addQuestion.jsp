<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Question</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 2em; }
        .nav-home { margin-bottom: 20px; display: inline-block; text-decoration: none; color: #007bff; font-weight: bold; }
        .nav-home:hover { color: #0056b3; }
        .form-container { max-width: 600px; margin: auto; padding: 2em; border: 1px solid #ccc; border-radius: 8px; background: #fafafa; }
        label { display: block; margin-top: 1em; }
        input[type="text"], textarea { width: 100%; padding: 0.5em; margin-top: 0.5em; border: 1px solid #aaa; border-radius: 4px; }
        .choices-group { margin-top: 1em; }
        .choice-input { display: flex; margin-bottom: 0.5em; }
        .choice-input input { flex: 1; }
        .choice-input button { margin-left: 0.5em; }
        button { margin-top: 1.5em; padding: 0.7em 2em; border: none; background: #007bff; color: #fff; border-radius: 4px; cursor: pointer; }
        button:hover { background: #0056b3; }
    </style>
    <script>
        function showFields() {
            var type = document.getElementById('questionType').value;
            var choicesSection = document.getElementById('choicesSection');
            var imageSection = document.getElementById('imageSection');
            choicesSection.style.display = (type === 'multiple-choice') ? 'block' : 'none';
            imageSection.style.display = (type === 'picture-response') ? 'block' : 'none';
            // Toggle 'required' for choices inputs
            var choicesInputs = document.getElementsByName('choices');
            for (var i = 0; i < choicesInputs.length; i++) {
                choicesInputs[i].required = (type === 'multiple-choice');
            }
        }
        function addChoiceField() {
            var group = document.getElementById('choicesGroup');
            var div = document.createElement('div');
            div.className = 'choice-input';
            var type = document.getElementById('questionType').value;
            var requiredAttr = (type === 'multiple-choice') ? 'required' : '';//
            div.innerHTML = '<input type="text" name="choices" placeholder="Choice" ' + requiredAttr + '> <button type="button" onclick="this.parentNode.remove()">Remove</button>';
            group.appendChild(div);
        }
        window.onload = function() {
            showFields();
        };
    </script>
</head>
<body>
<a href="${pageContext.request.contextPath}/" class="nav-home">← Home</a>
<div class="form-container">
    <h2>Add a Question</h2>
    <form action="${pageContext.request.contextPath}/quiz/addQuestion" method="post">
        <label for="questionType">Question Type:</label>
        <select id="questionType" name="questionType" onchange="showFields()" required>
            <option value="multiple-choice">Multiple Choice</option>
            <option value="fill-in-blank">Fill in the Blank</option>
            <option value="picture-response">Picture Response</option>
        </select>

        <label for="questionText">Question Text:</label>
        <textarea id="questionText" name="questionText" rows="3" required></textarea>

        <div id="choicesSection" style="display:none;">
            <label>Choices:</label>
            <div id="choicesGroup" class="choices-group">
                <div class="choice-input">
                    <input type="text" name="choices" placeholder="Choice" required>
                    <button type="button" onclick="this.parentNode.remove()">Remove</button>
                </div>
                <div class="choice-input">
                    <input type="text" name="choices" placeholder="Choice" required>
                    <button type="button" onclick="this.parentNode.remove()">Remove</button>
                </div>
            </div>
            <button type="button" onclick="addChoiceField()">Add Choice</button>
        </div>

        <div id="imageSection" style="display:none;">
            <label for="imageUrl">Image URL:</label>
            <input type="text" id="imageUrl" name="imageUrl" placeholder="http://...">
        </div>

        <label for="correctAnswer">Correct Answer:</label>
        <input type="text" id="correctAnswer" name="correctAnswer" required>

        <button type="submit" name="addAnother">Add Another Question</button>
        <button type="submit">Finish Quiz</button>
    </form>
</div>
</body>
</html> 