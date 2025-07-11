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
    <title>Create Quiz - Quiz Website</title>
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
            max-width: 700px;
            margin: 80px auto 40px;
            padding: 0 40px;
            position: relative;
            z-index: 3;
        }
        
        /* =========================== CREATE QUIZ CARD =========================== */
        .create-quiz-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            position: relative;
        }
        
        /* Decorative corner for create quiz card */
        .create-quiz-card::before {
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
        
        .create-quiz-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .create-quiz-icon {
            font-size: 3rem;
            margin-bottom: 20px;
        }
        
        .create-quiz-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .create-quiz-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        
        .create-quiz-body {
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
        
        .form-input, .form-textarea {
            width: 100%;
            padding: 16px;
            border: 2px solid #e8ecf0;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #f8f9fa;
            color: #2c3e50;
        }
        
        .form-input:focus, .form-textarea:focus {
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
        
        /* =========================== CHECKBOX STYLES =========================== */
        .checkbox-group {
            margin-bottom: 25px;
        }
        
        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 15px;
            padding: 15px 20px;
            background: #f8f9fa;
            border-radius: 12px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .checkbox-item:hover {
            border-color: #667eea;
            background: #f0f4ff;
        }
        
        .checkbox-item input[type="checkbox"] {
            width: 20px;
            height: 20px;
            accent-color: #667eea;
            cursor: pointer;
        }
        
        .checkbox-item label {
            font-weight: 500;
            color: #2c3e50;
            cursor: pointer;
            flex: 1;
        }
        
        .checkbox-description {
            font-size: 0.9rem;
            color: #7f8c8d;
            margin-top: 5px;
        }
        
        /* =========================== BUTTON STYLES =========================== */
        .primary-btn {
            width: 100%;
            padding: 18px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 20px;
        }
        
        .primary-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 35px rgba(102, 126, 234, 0.4);
        }
        
        .primary-btn:active {
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
            
            .create-quiz-header {
                padding: 30px 20px;
            }
            
            .create-quiz-title {
                font-size: 1.5rem;
            }
            
            .create-quiz-body {
                padding: 30px 20px;
            }
        }
        
        @media (max-width: 480px) {
            .main-container {
                margin: 40px auto 20px;
                padding: 0 15px;
            }
            
            .create-quiz-header {
                padding: 25px 15px;
            }
            
            .create-quiz-body {
                padding: 25px 15px;
            }
        }
    </style>
    <script>
        function updateMutualExclusion() {
            var onePage = document.getElementById('onePage');
            var immediate = document.getElementById('immediateCorrection');
            if (onePage.checked) {
                immediate.checked = false;
                immediate.disabled = true;
                onePage.disabled = false;
            } else if (immediate.checked) {
                onePage.checked = false;
                onePage.disabled = true;
                immediate.disabled = false;
            } else {
                onePage.disabled = false;
                immediate.disabled = false;
            }
        }
        window.onload = function() {
            document.getElementById('onePage').addEventListener('change', updateMutualExclusion);
            document.getElementById('immediateCorrection').addEventListener('change', updateMutualExclusion);
            updateMutualExclusion();
        };
    </script>
</head>
<body>
    <a href="${pageContext.request.contextPath}/" class="nav-home">← Back to Home</a>
    
    <div class="main-container">
        <div class="create-quiz-card">
            <div class="create-quiz-header">
                <div class="create-quiz-icon">📝</div>
                <h1 class="create-quiz-title">Create a New Quiz</h1>
                <p class="create-quiz-subtitle">Design your own quiz and share it with others</p>
            </div>
            
            <div class="create-quiz-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-error">${error}</div>
                </c:if>
                
                <form action="${pageContext.request.contextPath}/quiz/create" method="post">
                    <div class="form-group">
                        <label for="title" class="form-label">
                            Quiz Title <span class="required-field">*</span>
                        </label>
                        <input type="text" id="title" name="title" class="form-input" required 
                               maxlength="100" placeholder="Enter quiz title" />
                    </div>
                    
                    <div class="form-group">
                        <label for="description" class="form-label">Description</label>
                        <textarea id="description" name="description" class="form-textarea" rows="4" 
                                  maxlength="500" placeholder="Enter a short description (optional)"></textarea>
                    </div>
                    
                    <div class="checkbox-group">
                        <div class="checkbox-item">
                            <input type="checkbox" id="randomOrder" name="randomOrder" value="true" />
                            <label for="randomOrder">
                                Randomize question order
                                <div class="checkbox-description">Questions will appear in random order for each attempt</div>
                            </label>
                        </div>
                        
                        <div class="checkbox-item">
                            <input type="checkbox" id="onePage" name="onePage" value="true" checked />
                            <label for="onePage">
                                Show all questions on one page
                                <div class="checkbox-description">Display all questions at once for easier navigation</div>
                            </label>
                        </div>
                        
                        <div class="checkbox-item">
                            <input type="checkbox" id="immediateCorrection" name="immediateCorrection" value="true" />
                            <label for="immediateCorrection">
                                Show correct answers immediately after each question
                                <div class="checkbox-description">Provide instant feedback during the quiz</div>
                            </label>
                        </div>
                    </div>
                    
                    <button type="submit" class="primary-btn">Create Quiz</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
