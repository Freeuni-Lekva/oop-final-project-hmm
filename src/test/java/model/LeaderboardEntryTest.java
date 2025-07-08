package model;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class LeaderboardEntryTest {
    @Test void testConstructorAndGetters() {
        int quizId = 1;
        String quizTitle = "Sample Quiz";
        int userId = 2;
        String username = "testuser";
        double bestScore = 98.5;
        LeaderboardEntry entry = new LeaderboardEntry(quizId, quizTitle, userId, username, bestScore);
        assertEquals(quizId, entry.getQuizId());
        assertEquals(quizTitle, entry.getQuizTitle());
        assertEquals(userId, entry.getUserId());
        assertEquals(username, entry.getUsername());
        assertEquals(bestScore, entry.getBestScore(), 0.001);
    }
    @Test void testEqualsAndHashCode() {
        LeaderboardEntry entry1 = new LeaderboardEntry(1, "Quiz", 2, "user", 99.0);
        LeaderboardEntry entry2 = new LeaderboardEntry(1, "Quiz", 2, "user", 99.0);
        LeaderboardEntry entry3 = new LeaderboardEntry(2, "Quiz2", 3, "user2", 88.0);
        assertEquals(entry1, entry1);
        assertNotEquals(entry1, entry2);
        assertNotEquals(entry1, entry3);
    }
    @Test void testToString() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 2, "user", 99.0);
        String str = entry.toString();
        assertNotNull(str);
        assertTrue(str.contains("Quiz") || str.contains("user") || str.contains("99.0"));
    }
    @Test void testNegativeAndZeroScores() {
        LeaderboardEntry entryZero = new LeaderboardEntry(1, "Quiz", 2, "user", 0.0);
        LeaderboardEntry entryNegative = new LeaderboardEntry(1, "Quiz", 2, "user", -10.0);
        assertEquals(0.0, entryZero.getBestScore(), 0.001);
        assertEquals(-10.0, entryNegative.getBestScore(), 0.001);
    }
    @Test void testNullAndEmptyStrings() {
        LeaderboardEntry entry = new LeaderboardEntry(1, null, 2, "", 50.0);
        assertNull(entry.getQuizTitle());
        assertEquals("", entry.getUsername());
    }
    @Test void testMultipleEntriesIndependence() {
        LeaderboardEntry entry1 = new LeaderboardEntry(1, "Quiz1", 2, "user1", 80.0);
        LeaderboardEntry entry2 = new LeaderboardEntry(2, "Quiz2", 3, "user2", 90.0);
        assertNotEquals(entry1.getQuizId(), entry2.getQuizId());
        assertNotEquals(entry1.getUserId(), entry2.getUserId());
        assertNotEquals(entry1.getQuizTitle(), entry2.getQuizTitle());
        assertNotEquals(entry1.getUsername(), entry2.getUsername());
        assertNotEquals(entry1.getBestScore(), entry2.getBestScore());
    }
    // Systematic variations and edge cases
    @Test void testLongQuizTitle() {
        String longTitle = "Q".repeat(1000);
        LeaderboardEntry entry = new LeaderboardEntry(1, longTitle, 2, "user", 100.0);
        assertEquals(longTitle, entry.getQuizTitle());
    }
    @Test void testLongUsername() {
        String longUser = "U".repeat(1000);
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 2, longUser, 100.0);
        assertEquals(longUser, entry.getUsername());
    }
    @Test void testMinIntQuizId() {
        LeaderboardEntry entry = new LeaderboardEntry(Integer.MIN_VALUE, "Quiz", 2, "user", 100.0);
        assertEquals(Integer.MIN_VALUE, entry.getQuizId());
    }
    @Test void testMaxIntQuizId() {
        LeaderboardEntry entry = new LeaderboardEntry(Integer.MAX_VALUE, "Quiz", 2, "user", 100.0);
        assertEquals(Integer.MAX_VALUE, entry.getQuizId());
    }
    @Test void testMinIntUserId() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", Integer.MIN_VALUE, "user", 100.0);
        assertEquals(Integer.MIN_VALUE, entry.getUserId());
    }
    @Test void testMaxIntUserId() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", Integer.MAX_VALUE, "user", 100.0);
        assertEquals(Integer.MAX_VALUE, entry.getUserId());
    }
    @Test void testNegativeQuizId() {
        LeaderboardEntry entry = new LeaderboardEntry(-1, "Quiz", 2, "user", 100.0);
        assertEquals(-1, entry.getQuizId());
    }
    @Test void testNegativeUserId() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", -2, "user", 100.0);
        assertEquals(-2, entry.getUserId());
    }
    @Test void testDoubleBestScore() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 2, "user", 99.999);
        assertEquals(99.999, entry.getBestScore(), 0.0001);
    }
    @Test void testBestScoreInfinity() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 2, "user", Double.POSITIVE_INFINITY);
        assertEquals(Double.POSITIVE_INFINITY, entry.getBestScore(), 0.001);
    }
    @Test void testBestScoreNaN() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 2, "user", Double.NaN);
        assertTrue(Double.isNaN(entry.getBestScore()));
    }
    @Test void testQuizTitleSpecialChars() {
        String special = "!@#$%^&*()_+|";
        LeaderboardEntry entry = new LeaderboardEntry(1, special, 2, "user", 100.0);
        assertEquals(special, entry.getQuizTitle());
    }
    @Test void testUsernameSpecialChars() {
        String special = "!@#$%^&*()_+|";
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 2, special, 100.0);
        assertEquals(special, entry.getUsername());
    }
    @Test void testQuizTitleUnicode() {
        String unicode = "クイズ";
        LeaderboardEntry entry = new LeaderboardEntry(1, unicode, 2, "user", 100.0);
        assertEquals(unicode, entry.getQuizTitle());
    }
    @Test void testUsernameUnicode() {
        String unicode = "ユーザー";
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 2, unicode, 100.0);
        assertEquals(unicode, entry.getUsername());
    }
    @Test void testQuizTitleEmpty() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "", 2, "user", 100.0);
        assertEquals("", entry.getQuizTitle());
    }
    @Test void testUsernameEmpty() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 2, "", 100.0);
        assertEquals("", entry.getUsername());
    }
    @Test void testQuizTitleNull() {
        LeaderboardEntry entry = new LeaderboardEntry(1, null, 2, "user", 100.0);
        assertNull(entry.getQuizTitle());
    }
    @Test void testUsernameNull() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 2, null, 100.0);
        assertNull(entry.getUsername());
    }
    @Test void testBestScoreNegativeInfinity() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 2, "user", Double.NEGATIVE_INFINITY);
        assertEquals(Double.NEGATIVE_INFINITY, entry.getBestScore(), 0.001);
    }
    @Test void testBestScoreMaxValue() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 2, "user", Double.MAX_VALUE);
        assertEquals(Double.MAX_VALUE, entry.getBestScore(), 0.001);
    }
    @Test void testBestScoreMinValue() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 2, "user", Double.MIN_VALUE);
        assertEquals(Double.MIN_VALUE, entry.getBestScore(), 0.001);
    }
    @Test void testQuizIdZero() {
        LeaderboardEntry entry = new LeaderboardEntry(0, "Quiz", 2, "user", 100.0);
        assertEquals(0, entry.getQuizId());
    }
    @Test void testUserIdZero() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 0, "user", 100.0);
        assertEquals(0, entry.getUserId());
    }
    @Test void testQuizIdAndUserIdBothZero() {
        LeaderboardEntry entry = new LeaderboardEntry(0, "Quiz", 0, "user", 100.0);
        assertEquals(0, entry.getQuizId());
        assertEquals(0, entry.getUserId());
    }
    @Test void testQuizIdAndUserIdBothNegative() {
        LeaderboardEntry entry = new LeaderboardEntry(-1, "Quiz", -2, "user", 100.0);
        assertEquals(-1, entry.getQuizId());
        assertEquals(-2, entry.getUserId());
    }
    @Test void testQuizIdAndUserIdBothMax() {
        LeaderboardEntry entry = new LeaderboardEntry(Integer.MAX_VALUE, "Quiz", Integer.MAX_VALUE, "user", 100.0);
        assertEquals(Integer.MAX_VALUE, entry.getQuizId());
        assertEquals(Integer.MAX_VALUE, entry.getUserId());
    }
    @Test void testQuizIdAndUserIdBothMin() {
        LeaderboardEntry entry = new LeaderboardEntry(Integer.MIN_VALUE, "Quiz", Integer.MIN_VALUE, "user", 100.0);
        assertEquals(Integer.MIN_VALUE, entry.getQuizId());
        assertEquals(Integer.MIN_VALUE, entry.getUserId());
    }
    @Test void testQuizTitleWhitespace() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "   ", 2, "user", 100.0);
        assertEquals("   ", entry.getQuizTitle());
    }
    @Test void testUsernameWhitespace() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 2, "   ", 100.0);
        assertEquals("   ", entry.getUsername());
    }
    @Test void testQuizTitleTabNewline() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "\t\n", 2, "user", 100.0);
        assertEquals("\t\n", entry.getQuizTitle());
    }
    @Test void testUsernameTabNewline() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 2, "\t\n", 100.0);
        assertEquals("\t\n", entry.getUsername());
    }
    @Test void testQuizTitleVeryLong() {
        String veryLong = "A".repeat(10000);
        LeaderboardEntry entry = new LeaderboardEntry(1, veryLong, 2, "user", 100.0);
        assertEquals(veryLong, entry.getQuizTitle());
    }
    @Test void testUsernameVeryLong() {
        String veryLong = "B".repeat(10000);
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 2, veryLong, 100.0);
        assertEquals(veryLong, entry.getUsername());
    }
    @Test void testBestScoreZero() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 2, "user", 0.0);
        assertEquals(0.0, entry.getBestScore(), 0.001);
    }
    @Test void testBestScoreSmallPositive() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 2, "user", 0.0001);
        assertEquals(0.0001, entry.getBestScore(), 0.00001);
    }
    @Test void testBestScoreSmallNegative() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "Quiz", 2, "user", -0.0001);
        assertEquals(-0.0001, entry.getBestScore(), 0.00001);
    }
    @Test void testQuizTitleNullUsernameNull() {
        LeaderboardEntry entry = new LeaderboardEntry(1, null, 2, null, 100.0);
        assertNull(entry.getQuizTitle());
        assertNull(entry.getUsername());
    }
    @Test void testQuizTitleEmptyUsernameEmpty() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "", 2, "", 100.0);
        assertEquals("", entry.getQuizTitle());
        assertEquals("", entry.getUsername());
    }
    @Test void testQuizTitleWhitespaceUsernameWhitespace() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "   ", 2, "   ", 100.0);
        assertEquals("   ", entry.getQuizTitle());
        assertEquals("   ", entry.getUsername());
    }
    @Test void testQuizTitleTabNewlineUsernameTabNewline() {
        LeaderboardEntry entry = new LeaderboardEntry(1, "\t\n", 2, "\t\n", 100.0);
        assertEquals("\t\n", entry.getQuizTitle());
        assertEquals("\t\n", entry.getUsername());
    }
} 