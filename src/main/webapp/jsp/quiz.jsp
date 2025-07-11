<%--
  Quiz Details page for Quiz Website
  Displays quiz information and provides options to take the quiz
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Quiz" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    Quiz quiz = (Quiz) request.getAttribute("quiz");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz Details - Quiz Website</title>
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
        
        /* =========================== QUIZ DETAILS CARD =========================== */
        .quiz-details-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            position: relative;
        }
        
        /* Decorative corner for quiz details card */
        .quiz-details-card::before {
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
        
        .quiz-details-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .quiz-details-icon {
            font-size: 3rem;
            margin-bottom: 20px;
        }
        
        .quiz-details-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .quiz-details-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        
        .quiz-details-body {
            padding: 40px;
        }
        
        /* =========================== QUIZ INFO SECTION =========================== */
        .quiz-info-section {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            border-left: 4px solid #667eea;
            transition: all 0.3s ease;
        }
        
        .quiz-info-section:hover {
            transform: translateX(5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }
        
        .quiz-info-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .quiz-info-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .quiz-info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            background: white;
            border-radius: 10px;
            border: 1px solid #e9ecef;
            transition: all 0.3s ease;
        }
        
        .quiz-info-item:hover {
            border-color: #667eea;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.1);
        }
        
        .quiz-info-label {
            font-weight: 600;
            color: #34495e;
        }
        
        .quiz-info-value {
            color: #2c3e50;
            font-weight: 500;
        }
        
        .quiz-description {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            border: 1px solid #e9ecef;
            line-height: 1.6;
            color: #34495e;
        }
        
        /* =========================== QUIZ OPTIONS SECTION =========================== */
        .quiz-options-section {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            margin-bottom: 30px;
            position: relative;
        }
        
        .quiz-options-section::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, transparent 50%, rgba(102, 126, 234, 0.1) 50%);
            border-radius: 0 20px 0 80px;
            pointer-events: none;
        }
        
        .quiz-options-header {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 30px 40px;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .quiz-options-icon {
            font-size: 2rem;
        }
        
        .quiz-options-title {
            font-size: 1.5rem;
            font-weight: 600;
        }
        
        .quiz-options-body {
            padding: 40px;
        }
        
        /* =========================== CHECKBOX STYLES =========================== */
        .checkbox-group {
            margin-bottom: 30px;
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
            border-color: #28a745;
            background: #f0fff4;
        }
        
        .checkbox-item input[type="checkbox"] {
            width: 20px;
            height: 20px;
            accent-color: #28a745;
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
        .button-group {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .primary-btn {
            flex: 1;
            padding: 18px;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
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
            box-shadow: 0 12px 35px rgba(40, 167, 69, 0.4);
        }
        
        .primary-btn:active {
            transform: translateY(0);
        }
        
        /* =========================== ACTION LINKS SECTION =========================== */
        .action-links-section {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            position: relative;
        }
        
        .action-links-section::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, transparent 50%, rgba(102, 126, 234, 0.1) 50%);
            border-radius: 0 20px 0 80px;
            pointer-events: none;
        }
        
        .action-links-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 30px 40px;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .action-links-icon {
            font-size: 2rem;
        }
        
        .action-links-title {
            font-size: 1.5rem;
            font-weight: 600;
        }
        
        .action-links-body {
            padding: 40px;
        }
        
        .action-links-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .action-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px 20px;
            background: #f8f9fa;
            border-radius: 12px;
            text-decoration: none;
            color: #2c3e50;
            font-weight: 500;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        
        .action-link:hover {
            background: #e9ecef;
            border-color: #667eea;
            color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            text-decoration: none;
        }
        
        .action-link-icon {
            font-size: 1.2rem;
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
            
            .quiz-details-header {
                padding: 30px 20px;
            }
            
            .quiz-details-title {
                font-size: 1.5rem;
            }
            
            .quiz-details-body {
                padding: 30px 20px;
            }
            
            .quiz-info-content {
                grid-template-columns: 1fr;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .action-links-grid {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 480px) {
            .main-container {
                margin: 40px auto 20px;
                padding: 0 15px;
            }
            
            .quiz-details-header {
                padding: 25px 15px;
            }
            
            .quiz-details-body {
                padding: 25px 15px;
            }
        }
    </style>
</head>
<body>
    <a href="${pageContext.request.contextPath}/" class="nav-home">← Back to Home</a>
    
    <div class="main-container">
        <div class="quiz-details-card">
            <div class="quiz-details-header">
                <div class="quiz-details-icon">📝</div>
                <h1 class="quiz-details-title">${quiz.title}</h1>
                <p class="quiz-details-subtitle">Quiz Details & Options</p>
            </div>
            
            <div class="quiz-details-body">
                <!-- Quiz Information -->
                <div class="quiz-info-section">
                    <div class="quiz-info-title">
                        <span>📋</span>
                        Quiz Information
                    </div>
                    <div class="quiz-info-content">
                        <div class="quiz-info-item">
                            <span class="quiz-info-label">Creator:</span>
                            <span class="quiz-info-value">${quiz.creatorName}</span>
                        </div>
                        <div class="quiz-info-item">
                            <span class="quiz-info-label">Created:</span>
                            <span class="quiz-info-value">${quiz.createdDate}</span>
                        </div>
                        <div class="quiz-info-item">
                            <span class="quiz-info-label">Questions:</span>
                            <span class="quiz-info-value">${quiz.questionCount}</span>
                        </div>
                        <div class="quiz-info-item">
                            <span class="quiz-info-label">Attempts:</span>
                            <span class="quiz-info-value">${quiz.attemptCount}</span>
                        </div>
                    </div>
                </div>
                
                <!-- Quiz Description -->
                <c:if test="${not empty quiz.description}">
                    <div class="quiz-description">
                        <strong>Description:</strong><br/>
                        ${quiz.description}
                    </div>
                </c:if>
                
                <!-- Quiz Options -->
                <div class="quiz-options-section">
                    <div class="quiz-options-header">
                        <div class="quiz-options-icon">🎯</div>
                        <div class="quiz-options-title">Take Quiz</div>
                    </div>
                    
                    <div class="quiz-options-body">
                        <form action="${pageContext.request.contextPath}/takeQuiz" method="get">
                            <input type="hidden" name="id" value="${quiz.quizId}" />
                            
                            <div class="checkbox-group">
                                <div class="checkbox-item">
                                    <input type="checkbox" id="practiceMode" name="practiceMode" value="true" />
                                    <label for="practiceMode">
                                        Practice Mode
                                        <div class="checkbox-description">Take the quiz without affecting your score or rankings</div>
                                    </label>
                                </div>
                            </div>
                            
                            <div class="button-group">
                                <button type="submit" class="primary-btn">🎯 Start Quiz</button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Action Links -->
                <div class="action-links-section">
                    <div class="action-links-header">
                        <div class="action-links-icon">🔗</div>
                        <div class="action-links-title">Quick Actions</div>
                    </div>
                    
                    <div class="action-links-body">
                        <div class="action-links-grid">
                            <a href="${pageContext.request.contextPath}/quiz-summery?quizId=${quiz.quizId}" class="action-link">
                                <span class="action-link-icon">📊</span>
                                <span>View Rankings & Summary</span>
                            </a>
                            
                            <c:if test="${not empty sessionScope.user}">
                                <a href="${pageContext.request.contextPath}/quizHistory?quizId=${quiz.quizId}" class="action-link">
                                    <span class="action-link-icon">📈</span>
                                    <span>View History</span>
                                </a>
                            </c:if>
                            
                            <a href="${pageContext.request.contextPath}/quizzes" class="action-link">
                                <span class="action-link-icon">📚</span>
                                <span>Browse All Quizzes</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
