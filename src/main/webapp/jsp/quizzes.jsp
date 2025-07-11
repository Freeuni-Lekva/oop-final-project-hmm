<%--
  Quizzes listing page for Quiz Website
  Displays all available quizzes with search and filter functionality
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quizzes - Quiz Website</title>
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
            max-width: 1200px;
            margin: 80px auto 40px;
            padding: 0 40px;
            position: relative;
            z-index: 3;
        }
        
        .page-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .page-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: white;
            margin-bottom: 10px;
            text-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        }
        
        .page-subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1.1rem;
        }
        
        /* =========================== SEARCH SECTION =========================== */
        .search-section {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            margin-bottom: 40px;
            position: relative;
        }
        
        .search-section::before {
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
        
        .search-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 30px 40px;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .search-icon {
            font-size: 2rem;
        }
        
        .search-title {
            font-size: 1.5rem;
            font-weight: 600;
        }
        
        .search-body {
            padding: 40px;
        }
        
        .search-form {
            display: flex;
            gap: 15px;
            align-items: end;
        }
        
        .form-group {
            flex: 1;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #34495e;
            font-weight: 600;
            font-size: 14px;
        }
        
        .form-input, .form-select {
            width: 100%;
            padding: 16px;
            border: 2px solid #e8ecf0;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #f8f9fa;
            color: #2c3e50;
        }
        
        .form-input:focus, .form-select:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        
        .form-input::placeholder {
            color: #95a5a6;
        }
        
        .primary-btn {
            padding: 16px 32px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            white-space: nowrap;
        }
        
        .primary-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 35px rgba(102, 126, 234, 0.4);
        }
        
        /* =========================== QUIZZES GRID =========================== */
        .quizzes-section {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            position: relative;
        }
        
        .quizzes-section::before {
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
        
        .quizzes-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 30px 40px;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .quizzes-icon {
            font-size: 2rem;
        }
        
        .quizzes-title {
            font-size: 1.5rem;
            font-weight: 600;
        }
        
        .quizzes-body {
            padding: 40px;
        }
        
        .quizzes-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
        }
        
        .quiz-card {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            border-left: 4px solid #667eea;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .quiz-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, transparent 50%, rgba(102, 126, 234, 0.1) 50%);
            border-radius: 0 15px 0 60px;
            pointer-events: none;
        }
        
        .quiz-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.1);
            border-left-color: #764ba2;
        }
        
        .quiz-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .quiz-description {
            color: #7f8c8d;
            margin-bottom: 15px;
            line-height: 1.5;
        }
        
        .quiz-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .quiz-creator {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .quiz-date {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .quiz-actions {
            display: flex;
            gap: 10px;
        }
        
        .action-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .btn-take {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }
        
        .btn-take:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }
        
        .btn-view {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }
        
        .btn-view:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        /* =========================== EMPTY STATE =========================== */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }
        
        .empty-state-icon {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        .empty-state-text {
            font-size: 1.2rem;
            font-style: italic;
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
            
            .page-title {
                font-size: 2rem;
            }
            
            .search-form {
                flex-direction: column;
                gap: 20px;
            }
            
            .quizzes-grid {
                grid-template-columns: 1fr;
            }
            
            .quiz-actions {
                flex-direction: column;
            }
        }
        
        @media (max-width: 480px) {
            .main-container {
                margin: 40px auto 20px;
                padding: 0 15px;
            }
            
            .page-title {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <a href="${pageContext.request.contextPath}/" class="nav-home">← Back to Home</a>
    
    <div class="main-container">
        <div class="page-header">
            <h1 class="page-title">Available Quizzes</h1>
            <p class="page-subtitle">Discover and take quizzes created by the community</p>
        </div>
        
        <!-- Search Section -->
        <div class="search-section">
            <div class="search-header">
                <div class="search-icon">🔍</div>
                <div class="search-title">Search Quizzes</div>
            </div>
            
            <div class="search-body">
                <form class="search-form" method="get" action="${pageContext.request.contextPath}/quizzes">
                    <div class="form-group">
                        <label for="search" class="form-label">Search by title</label>
                        <input type="text" id="search" name="search" class="form-input" 
                               placeholder="Enter quiz title..." value="${param.search}" />
                    </div>
                    <div class="form-group">
                        <label for="sort" class="form-label">Sort by</label>
                        <select id="sort" name="sort" class="form-select">
                            <option value="recent" ${param.sort == 'recent' ? 'selected' : ''}>Most Recent</option>
                            <option value="popular" ${param.sort == 'popular' ? 'selected' : ''}>Most Popular</option>
                            <option value="title" ${param.sort == 'title' ? 'selected' : ''}>Title A-Z</option>
                        </select>
                    </div>
                    <button type="submit" class="primary-btn">🔍 Search</button>
                </form>
            </div>
        </div>
        
        <!-- Quizzes Section -->
        <div class="quizzes-section">
            <div class="quizzes-header">
                <div class="quizzes-icon">📚</div>
                <div class="quizzes-title">All Quizzes</div>
            </div>
            
            <div class="quizzes-body">
                <c:choose>
                    <c:when test="${empty quizzes}">
                        <div class="empty-state">
                            <div class="empty-state-icon">📚</div>
                            <div class="empty-state-text">No quizzes found. Be the first to create one!</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="quizzes-grid">
                            <c:forEach var="quiz" items="${quizzes}">
                                <div class="quiz-card">
                                    <div class="quiz-title">${quiz.title}</div>
                                    <div class="quiz-description">
                                        ${quiz.description != null ? quiz.description : 'No description available'}
                                    </div>
                                    <div class="quiz-meta">
                                        <div class="quiz-creator">
                                            <span>👤</span>
                                            <span>${quiz.creatorName}</span>
                                        </div>
                                        <div class="quiz-date">
                                            <span>📅</span>
                                            <span><fmt:formatDate value="${quiz.createdDate}" pattern="MMM dd, yyyy" /></span>
                                        </div>
                                    </div>
                                    <div class="quiz-actions">
                                        <a href="${pageContext.request.contextPath}/takeQuiz?quizId=${quiz.quizId}" 
                                           class="action-btn btn-take">🎯 Take Quiz</a>
                                        <a href="${pageContext.request.contextPath}/quiz-summary?quizId=${quiz.quizId}" 
                                           class="action-btn btn-view">📊 View Results</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html>
