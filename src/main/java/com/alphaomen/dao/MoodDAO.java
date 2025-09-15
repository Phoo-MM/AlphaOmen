package com.alphaomen.dao;

import com.alphaomen.model.Mood;
import com.alphaomen.db.DB;

import java.sql.*;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MoodDAO {
	
	// Insert or update mood
	public void addOrUpdateMood(int userId, LocalDate date, String mood) {
		String sql = "INSERT INTO moodtracker (user_id, mood_date, mood_value) VALUES (?, ?, ?) " +
				"ON DUPLICATE KEY UPDATE mood_value=?";
		try (Connection conn = DB.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ps.setDate(2, java.sql.Date.valueOf(date));
			ps.setString(3, mood);
			ps.setString(4, mood);
			ps.executeUpdate();
		} catch (SQLException e) { 
			e.printStackTrace(); 
		}
	}
	
	// Get today's mood for a specific user
	public String getTodayMood(int userId) {
		String mood = null;
	    String sql = "SELECT mood_value FROM moodtracker WHERE user_id=? AND mood_date=?";
	    try (Connection conn = DB.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, userId);
	        ps.setDate(2, java.sql.Date.valueOf(LocalDate.now()));
	        
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            mood = rs.getString("mood_value");
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return mood;
	}

	// Get mood history for a user
	public List<Map<String, Object>> getMoodHistory(int userId) throws SQLException {
	    List<Map<String, Object>> history = new ArrayList<>();
	    String sql = "SELECT mood_value, mood_date FROM moodtracker WHERE user_id = ? ORDER BY mood_date DESC";
	    try (Connection conn = DB.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql)) {
	        stmt.setInt(1, userId);
	        ResultSet rs = stmt.executeQuery();
	        while (rs.next()) {
	            Map<String, Object> entry = new HashMap<>();
	            entry.put("mood", rs.getString("mood_value"));
	            entry.put("date", rs.getDate("mood_date"));
	            history.add(entry);
	        }
	    }
	    return history;
	}

	// Get longest streak for each mood
	public Map<String, Integer> getLongestStreaks(int userId) throws SQLException {
	    Map<String, Integer> streaks = new HashMap<>();
	    String sql = "SELECT mood_value, mood_date FROM moodtracker WHERE user_id = ? ORDER BY mood_date ASC";
	    try (Connection conn = DB.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql)) {
	        stmt.setInt(1, userId);
	        ResultSet rs = stmt.executeQuery();

	        String lastMood = null;
	        int currentStreak = 0;
	        Map<String, Integer> maxStreaks = new HashMap<>();

	        while (rs.next()) {
	            String mood = rs.getString("mood_value");
	            if (mood.equals(lastMood)) {
	                currentStreak++;
	            } else {
	                currentStreak = 1;
	            }
	            maxStreaks.put(mood, Math.max(maxStreaks.getOrDefault(mood, 0), currentStreak));
	            lastMood = mood;
	        }
	        streaks.putAll(maxStreaks);
	    }
	    return streaks;
	}

	// Get monthly mood distribution
	public Map<String, Double> getMonthlyStats(int userId, int year, int month) throws SQLException {
	    Map<String, Integer> counts = new HashMap<>();
	    int total = 0;
	    String sql = "SELECT mood_value, COUNT(*) as cnt FROM moodtracker " +
	                 "WHERE user_id = ? AND YEAR(mood_date) = ? AND MONTH(mood_date) = ? " +
	                 "GROUP BY mood_value";
	    try (Connection conn = DB.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql)) {
	        stmt.setInt(1, userId);
	        stmt.setInt(2, year);
	        stmt.setInt(3, month);
	        ResultSet rs = stmt.executeQuery();
	        while (rs.next()) {
	            String mood = rs.getString("mood_value");
	            int cnt = rs.getInt("cnt");
	            counts.put(mood, cnt);
	            total += cnt;
	        }
	    }
	    Map<String, Double> percentages = new HashMap<>();
	    for (Map.Entry<String, Integer> e : counts.entrySet()) {
	        percentages.put(e.getKey(), (e.getValue() * 100.0) / total);
	    }
	    return percentages;
	}

	
	// Get mood history for a given month
	public Map<String, String> getMoodHistory(int userId, YearMonth month) {
		Map<String, String> history = new HashMap<>();
		String sql = "SELECT mood_date, mood_value FROM moodtracker WHERE user_id=? AND MONTH(mood_date)=? AND YEAR(mood_date)=?";
		try (Connection conn = DB.getConnection(); 
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ps.setInt(2, month.getMonthValue());
			ps.setInt(3, month.getYear());
			
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				history.put(rs.getDate("mood_date").toString(), rs.getString("mood_value"));
			}
		} catch (SQLException e) { 
			e.printStackTrace(); 
		}
		return history;
	}
}