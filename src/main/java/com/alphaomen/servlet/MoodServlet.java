package com.alphaomen.servlet;

import com.alphaomen.dao.MoodDAO;
import com.alphaomen.model.User;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/MoodServlet")
public class MoodServlet extends HttpServlet {
	private MoodDAO moodDAO = new MoodDAO();
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("addMood".equals(action)) {
            String mood = request.getParameter("mood");
            String dateStr = request.getParameter("date"); // new
            LocalDate date = (dateStr != null) ? LocalDate.parse(dateStr) : LocalDate.now();

            try {
                moodDAO.addOrUpdateMood(user.getId(), date, mood);
            } catch (Exception e) {
                throw new ServletException("Error adding/updating mood", e);
            }
        }

        doGet(request, response);
    }
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    HttpSession session = request.getSession(false);
	    User user = (session != null) ? (User) session.getAttribute("user") : null;
	    if (user == null) {
	        response.sendRedirect("login.jsp");
	        return;
	    }

	    String action = request.getParameter("action"); // 👈 check if user requested insights

	    try {
	        if ("history".equals(action)) {
	            // list of maps instead of MoodEntry
	            List<Map<String, Object>> history = moodDAO.getMoodHistory(user.getId());
	            request.setAttribute("history", history);
	            request.getRequestDispatcher("history.jsp").forward(request, response);

	        } else if ("streaks".equals(action)) {
	            Map<String, Integer> streaks = moodDAO.getLongestStreaks(user.getId());
	            request.setAttribute("streaks", streaks);
	            request.getRequestDispatcher("streaks.jsp").forward(request, response);

	        } else if ("monthlyStats".equals(action)) {
	            LocalDate now = LocalDate.now();
	            Map<String, Double> thisMonth = moodDAO.getMonthlyStats(user.getId(), now.getYear(), now.getMonthValue());
	            Map<String, Double> lastMonth = moodDAO.getMonthlyStats(user.getId(),
	                    now.minusMonths(1).getYear(), now.minusMonths(1).getMonthValue());

	            request.setAttribute("thisMonth", thisMonth);
	            request.setAttribute("lastMonth", lastMonth);
	            request.getRequestDispatcher("monthlyStats.jsp").forward(request, response);

	        } else {
	        	// --- Handle month navigation ---
	            String monthParam = request.getParameter("month");
	            YearMonth selectedMonth = (monthParam != null) ? YearMonth.parse(monthParam) : YearMonth.now();
	            request.setAttribute("selectedMonth", selectedMonth.toString());

	            // --- Load mood history for selected month ---
	            Map<String, String> moodHistory = moodDAO.getMoodHistory(user.getId(), selectedMonth);
	            
	            // Chart data
	            List<String> labels = new ArrayList<>();
	            List<Integer> values = new ArrayList<>();
	            List<String> colors = new ArrayList<>();
	            YearMonth currentMonth = YearMonth.now();

	            for (int day = 1; day <= selectedMonth.lengthOfMonth(); day++) {
	                LocalDate date = selectedMonth.atDay(day);
	                String mood = moodHistory.get(date.toString());

	                labels.add(String.valueOf(day));

	                if (mood == null) {
	                    values.add(0);
	                    colors.add("gray");
	                } else {
	                    switch (mood) {
	                        case "Happy": values.add(3); colors.add("yellow"); break;
	                        case "Sad": values.add(2); colors.add("lightblue"); break;
	                        case "Angry": values.add(1); colors.add("tomato"); break;
	                        case "Anxious": values.add(2); colors.add("orange"); break;
	                    }
	                }
	            }

	            // Daily motivational quote
	            LocalDate today = LocalDate.now();
	            String todayMood = moodHistory.get(today.toString());
	            String quote = "";
	            if ("Happy".equals(todayMood)) quote = "Keep smiling! Happiness looks good on you 😊";
	            else if ("Sad".equals(todayMood)) quote = "Every cloud has a silver lining. Stay strong 💪";
	            else if ("Angry".equals(todayMood)) quote = "Take a deep breath. Calm mind, clear path 🌿";
	            else if ("Anxious".equals(todayMood)) quote = "Embrace today as it comes. Balance is key ⚖️";
	            else quote = "Select your mood today to get a motivational quote! ✨";

	            // JSON for chart
	            String moodChartData = new Gson().toJson(Map.of("labels", labels, "values", values, "colors", colors));
	            
	            // Load insights
	            List<Map<String, Object>> history = moodDAO.getMoodHistory(user.getId());
	            Map<String, Integer> streaks = moodDAO.getLongestStreaks(user.getId());

	            Map<String, Double> thisMonth = moodDAO.getMonthlyStats(user.getId(),
	                    selectedMonth.getYear(), selectedMonth.getMonthValue());
	            YearMonth prev = selectedMonth.minusMonths(1);
	            Map<String, Double> lastMonth = moodDAO.getMonthlyStats(user.getId(),
	                    prev.getYear(), prev.getMonthValue());
	            
	            request.setAttribute("moodHistory", moodHistory);
	            request.setAttribute("moodChartData", moodChartData);
	            request.setAttribute("motivationQuote", quote);
	            request.setAttribute("history", history);
	            request.setAttribute("streaks", streaks);
	            request.setAttribute("thisMonth", thisMonth);
	            request.setAttribute("lastMonth", lastMonth);
	            request.getRequestDispatcher("moodTracker.jsp").forward(request, response);
	        }
	    } catch (Exception e) {
	        throw new ServletException(e);
	    }
	}
}
