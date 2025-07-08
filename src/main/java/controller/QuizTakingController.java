package controller;

import dao.QuestionDAO;
import dao.QuizDAO;
import dao.QuizAttemptDAO;
import model.Question;
import model.Quiz;
import model.QuizAttempt;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet(urlPatterns = {"/takeQuiz"})
public class QuizTakingController extends HttpServlet {
    private QuizDAO quizDAO;
    private QuestionDAO questionDAO;
    private QuizAttemptDAO quizAttemptDAO;

    @Override
    public void init() throws ServletException {
        try {
            Connection connection = (Connection) getServletContext().getAttribute("DBConnection");
            quizDAO = (QuizDAO) getServletContext().getAttribute("quizDAO");
            questionDAO = (QuestionDAO) getServletContext().getAttribute("questionDAO");
            quizAttemptDAO = (QuizAttemptDAO) getServletContext().getAttribute("quizAttemptDAO");
        } catch (Exception e) {
            throw new ServletException("DB connection error", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Start quiz attempt: load quiz, questions, set session state, show first question
        HttpSession session = req.getSession();
        String quizIdStr = req.getParameter("id");
        boolean practiceMode = "true".equals(req.getParameter("practiceMode"));
        if (quizIdStr == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quiz ID required");
            return;
        }
        int quizId = Integer.parseInt(quizIdStr);
        try {
            Quiz quiz = quizDAO.findById(quizId);
            List<Question> questions = questionDAO.getQuestionsByQuizId(quizId);
            if (quiz == null || questions.isEmpty()) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Quiz not found");
                return;
            }
            if (quiz.isRandomOrder()) {
                java.util.Collections.shuffle(questions);
            }
            session.setAttribute("currentQuiz", quiz);
            session.setAttribute("quizQuestions", questions);
            session.setAttribute("currentQuestionIndex", 0);
            session.setAttribute("userAnswers", new ArrayList<String>());
            session.setAttribute("quizStartTime", System.currentTimeMillis());
            session.setAttribute("practiceMode", practiceMode);
            req.setAttribute("question", questions.get(0));
            req.setAttribute("questionNumber", 1);
            req.setAttribute("totalQuestions", questions.size());
            req.setAttribute("practiceMode", practiceMode);
            req.getRequestDispatcher("/jsp/quizQuestion.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Quiz quiz = (Quiz) session.getAttribute("currentQuiz");
        List<Question> questions = (List<Question>) session.getAttribute("quizQuestions");
        Integer currentIndex = (Integer) session.getAttribute("currentQuestionIndex");
        ArrayList<String> userAnswers = (ArrayList<String>) session.getAttribute("userAnswers");
        Boolean practiceMode = (Boolean) session.getAttribute("practiceMode");
        if (quiz == null || questions == null || currentIndex == null || userAnswers == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }
        // Get submitted answer
        String answer = req.getParameter("answer");
        userAnswers.add(answer != null ? answer : "");
        currentIndex++;
        if (currentIndex < questions.size()) {
            // Next question
            session.setAttribute("currentQuestionIndex", currentIndex);
            session.setAttribute("userAnswers", userAnswers);
            req.setAttribute("question", questions.get(currentIndex));
            req.setAttribute("questionNumber", currentIndex + 1);
            req.setAttribute("totalQuestions", questions.size());
            req.setAttribute("practiceMode", practiceMode);
            req.getRequestDispatcher("/jsp/quizQuestion.jsp").forward(req, resp);
        } else {
            // Quiz finished: grade and show result
            int correct = 0;
            for (int i = 0; i < questions.size(); i++) {
                if (questions.get(i).getCorrectAnswer().trim().equalsIgnoreCase(userAnswers.get(i).trim())) {
                    correct++;
                }
            }
            double score = (double) correct / questions.size() * 100.0;
            long startTime = (long) session.getAttribute("quizStartTime");
            long timeTaken = (System.currentTimeMillis() - startTime) / 1000;
            // Save attempt if user is logged in
            User user = (User) session.getAttribute("user");
            if (user != null) {
                try {
                    if (practiceMode != null && practiceMode) {
                        quizAttemptDAO.createPracticeAttempt(user.getUserId(), quiz.getQuizId(), score, questions.size(), timeTaken);
                    } else {
                        quizAttemptDAO.createSimpleAttempt(user.getUserId(), quiz.getQuizId(), score, questions.size(), timeTaken);
                    }
                } catch (SQLException e) {
                    throw new ServletException(e);
                }
            }
            req.setAttribute("score", score);
            req.setAttribute("correct", correct);
            req.setAttribute("totalQuestions", questions.size());
            req.setAttribute("timeTaken", timeTaken);
            req.setAttribute("practiceMode", practiceMode);
            // Clean up session
            session.removeAttribute("currentQuiz");
            session.removeAttribute("quizQuestions");
            session.removeAttribute("currentQuestionIndex");
            session.removeAttribute("userAnswers");
            session.removeAttribute("quizStartTime");
            session.removeAttribute("practiceMode");
            req.getRequestDispatcher("/jsp/quizResult.jsp").forward(req, resp);
        }
    }
}
