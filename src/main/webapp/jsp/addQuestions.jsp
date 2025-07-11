<%--
  Add Questions page for Quiz Website
  Allows users to add multiple questions to their quiz
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Questions - Quiz Website</title>
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
            max-width: 900px;
            margin: 80px auto 40px;
            padding: 0 40px;
            position: relative;
            z-index: 3;
        }
        
        /* =========================== ADD QUESTIONS CARD =========================== */
        .add-questions-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            position: relative;
        }
        
        /* Decorative corner for add questions card */
        .add-questions-card::before {
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
        
        .add-questions-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .add-questions-icon {
            font-size: 3rem;
            margin-bottom: 20px;
        }
        
        .add-questions-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .add-questions-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        
        .add-questions-body {
            padding: 40px;
        }
        
        /* =========================== QUIZ INFO SECTION =========================== */
        .quiz-info-section {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            border-left: 4px solid #667eea;
        }
        
        .quiz-info-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .quiz-info-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .quiz-info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 16px;
            background: white;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }
        
        .quiz-info-label {
            font-weight: 600;
            color: #34495e;
        }
        
        .quiz-info-value {
            color: #2c3e50;
        }
        
        /* =========================== QUESTIONS LIST =========================== */
        .questions-section {
            margin-bottom: 30px;
        }
        
        .questions-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .questions-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #2c3e50;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .questions-count {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
        }
        
        .questions-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .question-item {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            border-left: 4px solid #28a745;
            transition: all 0.3s ease;
        }
        
        .question-item:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .question-number {
            font-weight: 600;
            color: #2c3e50;
            font-size: 1.1rem;
        }
        
        .question-type {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .question-text {
            color: #34495e;
            margin-bottom: 10px;
            line-height: 1.5;
        }
        
        .question-answer {
            color: #7f8c8d;
            font-size: 0.9rem;
            font-style: italic;
        }
        
        /* =========================== ADD QUESTION FORM =========================== */
        .add-question-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }
        
        .add-question-section:hover {
            border-color: #667eea;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.1);
        }
        
        .add-question-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* =========================== FORM STYLES =========================== */
        .form-group {
            margin-bottom: 20px;
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
            padding: 12px;
            border: 2px solid #e8ecf0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: #f8f9fa;
            color: #2c3e50;
        }
        
        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-input::placeholder, .form-textarea::placeholder {
            color: #95a5a6;
        }
        
        .form-textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        /* =========================== BUTTON STYLES =========================== */
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }
        
        .primary-btn {
            flex: 1;
            padding: 14px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .primary-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }
        
        .secondary-btn {
            flex: 1;
            padding: 14px 20px;
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .secondary-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.3);
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
        
        .alert-success {
            background: linear-gradient(135deg, #00b894, #00a085);
            color: white;
            box-shadow: 0 6px 20px rgba(0, 184, 148, 0.3);
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
            
            .add-questions-header {
                padding: 30px 20px;
            }
            
            .add-questions-title {
                font-size: 1.5rem;
            }
            
            .add-questions-body {
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
            
            .add-questions-header {
                padding: 25px 15px;
            }
            
            .add-questions-body {
                padding: 25px 15px;
            }
        }
    </style>
</head>
<body>
    <a href="${pageContext.request.contextPath}/" class="nav-home">← Back to Home</a>
    
    <div class="main-container">
        <div class="add-questions-card">
            <div class="add-questions-header">
                <div class="add-questions-icon">❓</div>
                <h1 class="add-questions-title">Add Questions</h1>
                <p class="add-questions-subtitle">Build your quiz with engaging questions</p>
            </div>
            
            <div class="add-questions-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-error">${error}</div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success">${success}</div>
                </c:if>
                
                <!-- Quiz Information -->
                <div class="quiz-info-section">
                    <div class="quiz-info-title">
                        <span>📝</span>
                        Quiz Information
                    </div>
                    <div class="quiz-info-content">
                        <div class="quiz-info-item">
                            <span class="quiz-info-label">Title:</span>
                            <span class="quiz-info-value">${quizTitle}</span>
                        </div>
                        <div class="quiz-info-item">
                            <span class="quiz-info-label">Questions Added:</span>
                            <span class="quiz-info-value">${questionCount}</span>
                        </div>
                        <div class="quiz-info-item">
                            <span class="quiz-info-label">Status:</span>
                            <span class="quiz-info-value">In Progress</span>
                        </div>
                    </div>
                </div>
                
                <!-- Questions List -->
                <div class="questions-section">
                    <div class="questions-header">
                        <div class="questions-title">
                            <span>📋</span>
                            Questions Added
                        </div>
                        <div class="questions-count">${questionCount} questions</div>
                    </div>
                    
                    <div class="questions-list">
                        <c:forEach var="question" items="${questions}" varStatus="status">
                            <div class="question-item">
                                <div class="question-header">
                                    <div class="question-number">Question ${status.index + 1}</div>
                                    <div class="question-type">${question.questionType}</div>
                                </div>
                                <div class="question-text">${question.questionText}</div>
                                <div class="question-answer">Answer: ${question.correctAnswer}</div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                
                <!-- Add Question Form -->
                <div class="add-question-section">
                    <div class="add-question-title">
                        <span>➕</span>
                        Add New Question
                    </div>
                    
                    <form action="${pageContext.request.contextPath}/quiz/addQuestion" method="post">
                        <div class="form-group">
                            <label for="questionType" class="form-label">Question Type</label>
                            <select id="questionType" name="questionType" class="form-select" required>
                                <option value="multiple-choice">📝 Multiple Choice</option>
                                <option value="fill-in-blank">📝 Fill in the Blank</option>
                                <option value="picture-response">🖼️ Picture Response</option>
                                <option value="question-response">❓ Question Response</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="questionText" class="form-label">Question Text</label>
                            <textarea id="questionText" name="questionText" class="form-textarea" 
                                      placeholder="Enter your question here..." required></textarea>
                        </div>
                        
                        <div class="form-group">
                            <label for="correctAnswer" class="form-label">Correct Answer</label>
                            <input type="text" id="correctAnswer" name="correctAnswer" class="form-input" 
                                   placeholder="Enter correct answer" required />
                        </div>
                        
                        <div class="button-group">
                            <button type="submit" name="addAnother" class="secondary-btn">➕ Add Another</button>
                            <button type="submit" class="primary-btn">✅ Finish Quiz</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
