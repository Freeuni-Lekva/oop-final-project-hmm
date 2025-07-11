<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Question - Quiz Website</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        /* =========================== GLOBAL STYLES =========================== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            line-height: 1.6;
            color: #2c3e50;
        }
        
        /* =========================== NAVIGATION =========================== */
        .nav-home {
            position: absolute;
            top: 20px;
            left: 20px;
            padding: 12px 24px;
            text-decoration: none;
            color: white;
            font-weight: 600;
            background: rgba(255, 255, 255, 0.15);
            border: 2px solid rgba(255, 255, 255, 0.2);
            border-radius: 30px;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
            font-size: 14px;
        }
        
        .nav-home:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            text-decoration: none;
            color: white;
        }
        
        /* =========================== MAIN CONTAINER =========================== */
        .main-container {
            max-width: 800px;
            margin: 80px auto 40px;
            padding: 0 40px;
            position: relative;
            z-index: 3;
        }
        
        /* =========================== ADD QUESTION CARD =========================== */
        .add-question-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            position: relative;
        }
        
        /* Decorative corner for add question card */
        .add-question-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, transparent 50%, rgba(102, 126, 234, 0.1) 50%);
            border-radius: 0 20px 0 100px;
            pointer-events: none;
        }
        
        .add-question-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .add-question-icon {
            font-size: 3rem;
            margin-bottom: 20px;
        }
        
        .add-question-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .add-question-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        
        .add-question-body {
            padding: 40px;
        }
        
        /* =========================== FORM STYLES =========================== */
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #34495e;
            font-weight: 600;
            font-size: 14px;
        }
        
        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 16px;
            border: 2px solid #e8ecf0;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #f8f9fa;
            color: #2c3e50;
        }
        
        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        
        .form-input::placeholder, .form-textarea::placeholder {
            color: #95a5a6;
        }
        
        .form-textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        /* =========================== CHOICES SECTION =========================== */
        .choices-section {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }
        
        .choices-section:hover {
            border-color: #667eea;
            background: #f0f4ff;
        }
        
        .choices-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .choices-icon {
            font-size: 1.5rem;
        }
        
        .choices-title {
            font-weight: 600;
            color: #2c3e50;
            font-size: 1.1rem;
        }
        
        .choices-group {
            margin-bottom: 20px;
        }
        
        .choice-input {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 15px;
            padding: 15px 20px;
            background: white;
            border-radius: 12px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }
        
        .choice-input:hover {
            border-color: #667eea;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.1);
        }
        
        .choice-input input {
            flex: 1;
            padding: 12px;
            border: 2px solid #e8ecf0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }
        
        .choice-input input:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .choice-input input::placeholder {
            color: #95a5a6;
        }
        
        .remove-choice-btn {
            padding: 8px 12px;
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .remove-choice-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
        }
        
        .add-choice-btn {
            padding: 12px 20px;
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .add-choice-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }
        
        /* =========================== IMAGE SECTION =========================== */
        .image-section {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }
        
        .image-section:hover {
            border-color: #667eea;
            background: #f0f4ff;
        }
        
        .image-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
        }
        
        .image-icon {
            font-size: 1.5rem;
        }
        
        .image-title {
            font-weight: 600;
            color: #2c3e50;
            font-size: 1.1rem;
        }
        
        /* =========================== BUTTON STYLES =========================== */
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .primary-btn {
            flex: 1;
            padding: 18px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .primary-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 35px rgba(102, 126, 234, 0.4);
        }
        
        .primary-btn:active {
            transform: translateY(0);
        }
        
        .secondary-btn {
            flex: 1;
            padding: 18px;
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .secondary-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 35px rgba(40, 167, 69, 0.4);
        }
        
        .secondary-btn:active {
            transform: translateY(0);
        }
        
        /* =========================== ALERT STYLES =========================== */
        .alert {
            padding: 16px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-weight: 500;
            text-align: center;
        }
        
        .alert-error {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            box-shadow: 0 6px 20px rgba(255, 107, 107, 0.3);
        }
        
        /* =========================== REQUIRED FIELD STYLES =========================== */
        .required-field {
            color: #e74c3c;
            font-weight: 600;
        }
        
        .form-note {
            font-size: 0.9rem;
            color: #7f8c8d;
            margin-top: 5px;
        }
        
        /* =========================== RESPONSIVE DESIGN =========================== */
        @media (max-width: 768px) {
            .main-container {
                margin: 60px auto 20px;
                padding: 0 20px;
            }
            
            .nav-home {
                position: relative;
                top: auto;
                left: auto;
                margin-bottom: 20px;
                display: inline-block;
            }
            
            .add-question-header {
                padding: 30px 20px;
            }
            
            .add-question-title {
                font-size: 1.5rem;
            }
            
            .add-question-body {
                padding: 30px 20px;
            }
            
            .button-group {
                flex-direction: column;
            }
        }
        
        @media (max-width: 480px) {
            .main-container {
                margin: 40px auto 20px;
                padding: 0 15px;
            }
            
            .add-question-header {
                padding: 25px 15px;
            }
            
            .add-question-body {
                padding: 25px 15px;
            }
        }
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
            var requiredAttr = (type === 'multiple-choice') ? 'required' : '';
            div.innerHTML = '<input type="text" name="choices" placeholder="Choice" ' + requiredAttr + '> <button type="button" class="remove-choice-btn" onclick="this.parentNode.remove()">Remove</button>';
            group.appendChild(div);
        }
        window.onload = function() {
            showFields();
        };
    </script>
</head>
<body>
    <a href="${pageContext.request.contextPath}/" class="nav-home">← Back to Home</a>
    
    <div class="main-container">
        <div class="add-question-card">
            <div class="add-question-header">
                <div class="add-question-icon">❓</div>
                <h1 class="add-question-title">Add a Question</h1>
                <p class="add-question-subtitle">Create engaging questions for your quiz</p>
            </div>
            
            <div class="add-question-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-error">${error}</div>
                </c:if>
                
                <form action="${pageContext.request.contextPath}/quiz/addQuestion" method="post">
                    <div class="form-group">
                        <label for="questionType" class="form-label">Question Type</label>
                        <select id="questionType" name="questionType" class="form-select" onchange="showFields()" required>
                            <option value="multiple-choice" <%= "multiple-choice".equals(request.getAttribute("questionType")) ? "selected" : "" %>>📝 Multiple Choice</option>
                            <option value="fill-in-blank" <%= "fill-in-blank".equals(request.getAttribute("questionType")) ? "selected" : "" %>>📝 Fill in the Blank</option>
                            <option value="picture-response" <%= "picture-response".equals(request.getAttribute("questionType")) ? "selected" : "" %>>🖼️ Picture Response</option>
                            <option value="question-response" <%= "question-response".equals(request.getAttribute("questionType")) ? "selected" : "" %>>❓ Question Response</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="questionText" class="form-label">Question Text <span class="required-field">*</span></label>
                        <textarea id="questionText" name="questionText" class="form-textarea" rows="3" required 
                                  placeholder="Enter your question here..."><%= request.getAttribute("questionText") != null ? request.getAttribute("questionText") : "" %></textarea>
                    </div>
                    
                    <div id="choicesSection" class="choices-section" style="display:none;">
                        <div class="choices-header">
                            <div class="choices-icon">📋</div>
                            <div class="choices-title">Multiple Choice Options</div>
                        </div>
                        <div id="choicesGroup" class="choices-group">
                            <% 
                            java.util.List choices = (java.util.List) request.getAttribute("choices");
                            if (choices != null && !choices.isEmpty()) {
                                for (Object c : choices) { %>
                                    <div class="choice-input">
                                        <input type="text" name="choices" placeholder="Choice" value="<%= c %>" required>
                                        <button type="button" class="remove-choice-btn" onclick="this.parentNode.remove()">Remove</button>
                                    </div>
                            <%  }
                            } else { %>
                                <div class="choice-input">
                                    <input type="text" name="choices" placeholder="Choice" required>
                                    <button type="button" class="remove-choice-btn" onclick="this.parentNode.remove()">Remove</button>
                                </div>
                                <div class="choice-input">
                                    <input type="text" name="choices" placeholder="Choice" required>
                                    <button type="button" class="remove-choice-btn" onclick="this.parentNode.remove()">Remove</button>
                                </div>
                            <% } %>
                        </div>
                        <button type="button" class="add-choice-btn" onclick="addChoiceField()">➕ Add Choice</button>
                    </div>
                    
                    <div id="imageSection" class="image-section" style="display: none;">
                        <div class="image-header">
                            <div class="image-icon">🖼️</div>
                            <div class="image-title">Image URL</div>
                        </div>
                        <div class="form-group">
                            <label for="imageUrl" class="form-label">Image URL</label>
                            <input type="text" id="imageUrl" name="imageUrl" class="form-input" placeholder="http://..." />
                            <div class="form-note">Enter a valid image URL for picture response questions</div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="correctAnswer" class="form-label">Correct Answer(s) <span class="required-field">*</span></label>
                        <input type="text" id="correctAnswer" name="correctAnswer" class="form-input" required 
                               value="<%= request.getAttribute("correctAnswer") != null ? request.getAttribute("correctAnswer") : "" %>" 
                               placeholder="Enter correct answer(s)" />
                        <div class="form-note">For multiple correct answers, separate them with a comma (e.g., "George Washington, Washington")</div>
                    </div>
                    
                    <div class="button-group">
                        <button type="submit" name="addAnother" class="secondary-btn">➕ Add Another Question</button>
                        <button type="submit" class="primary-btn">✅ Finish Quiz</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html> 