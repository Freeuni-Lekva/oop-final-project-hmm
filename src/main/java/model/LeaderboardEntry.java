package model;

public class LeaderboardEntry {
    private int quizId;
    private String quizTitle;
    private int userId;
    private String username;
    private double bestScore;

    public LeaderboardEntry(int quizId, String quizTitle, int userId, String username, double bestScore) {
        this.quizId = quizId;
        this.quizTitle = quizTitle;
        this.userId = userId;
        this.username = username;
        this.bestScore = bestScore;
    }

    public int getQuizId() { return quizId; }
    public String getQuizTitle() { return quizTitle; }
    public int getUserId() { return userId; }
    public String getUsername() { return username; }
    public double getBestScore() { return bestScore; }

    @Override
    public String toString() {
        return "LeaderboardEntry{" +
                "quizId=" + quizId +
                ", quizTitle='" + quizTitle + '\'' +
                ", userId=" + userId +
                ", username='" + username + '\'' +
                ", bestScore=" + bestScore +
                '}';
    }
} 