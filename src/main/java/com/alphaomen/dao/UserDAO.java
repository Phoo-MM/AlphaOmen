package com.alphaomen.dao;

import com.alphaomen.db.DB;
import com.alphaomen.model.User;
import com.alphaomen.util.OTPUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
	public List<User> getAllUsersForAdmin() throws SQLException {
		String sql = "SELECT u.user_id, u.username, u.email, u.plan_id, "
		           + "       s.start_date AS premium_start, s.end_date AS premium_end, "
		           + "       COUNT(n.note_id) AS note_count, "
		           + "       p.name AS plan_name "
		           + "FROM users u "
		           + "LEFT JOIN subscription s ON u.user_id = s.user_id AND s.is_active = 1 "
		           + "LEFT JOIN plan p ON u.plan_id = p.plan_id "
		           + "LEFT JOIN note n ON n.user_id = u.user_id "
		           + "GROUP BY u.user_id "
		           + "ORDER BY u.user_id ASC;";


	    List<User> users = new ArrayList<>();
	    try (Connection conn = DB.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql);
	         ResultSet rs = stmt.executeQuery()) {

	        while (rs.next()) {
	            User user = new User();
	            user.setId(rs.getInt("user_id"));
	            user.setUsername(rs.getString("username"));
	            user.setEmail(rs.getString("email"));
	            user.setPlanId(rs.getInt("plan_id"));

	            user.setNoteCount(rs.getInt("note_count"));
	            
	            String planName = rs.getString("plan_name");
	            user.setPremiumPlan(planName != null ? planName : "Free");
	            
	            // Set subscription dates
                Date startDate = rs.getDate("premium_start");
                Date endDate = rs.getDate("premium_end");
                user.setPremiumStart(startDate);
                user.setPremiumExpiry(endDate);

             // --- CHECK IF PLAN EXPIRED ---
                java.util.Date now = new java.util.Date();
                if (endDate != null && endDate.before(now)) {
                    user.setPremiumPlan("Free");
                    
                    // OPTIONAL: Update database to downgrade plan
                    String downgradeSql = "UPDATE users u "
                                        + "LEFT JOIN subscription s ON u.user_id = s.user_id AND s.is_active = 1 "
                                        + "SET u.plan_id = NULL, s.is_active = 0 "
                                        + "WHERE u.user_id = ?";
                    try (PreparedStatement downgradeStmt = conn.prepareStatement(downgradeSql)) {
                        downgradeStmt.setInt(1, user.getId());
                        downgradeStmt.executeUpdate();
                    }
                }

                users.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

	public String getPasswordByUserId(int userId) throws SQLException {
	    String sql = "SELECT password FROM users WHERE user_id = ?";
	    try (Connection conn = DB.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql)) {
	        stmt.setInt(1, userId);
	        try (ResultSet rs = stmt.executeQuery()) {
	            if (rs.next()) {
	                return rs.getString("password"); // hashed password from DB
	            }
	        }
	    }
	    return null;
	}

	
	public User getUserWithSubscriptionDates(int userId) {
	    String sql = "SELECT u.user_id, u.username, u.email, u.plan_id, " +
	                 "       s.start_date AS premium_start, s.end_date AS premium_end, " +
	                 "       p.name AS plan_name " +
	                 "FROM users u " +
	                 "LEFT JOIN subscription s ON u.user_id = s.user_id AND s.is_active = 1 " +
	                 "LEFT JOIN plan p ON u.plan_id = p.plan_id " +
	                 "WHERE u.user_id = ? " +
	                 "LIMIT 1";

	    User user = null;
	    try (Connection conn = DB.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql)) {
	         
	        stmt.setInt(1, userId);
	        ResultSet rs = stmt.executeQuery();
	        if (rs.next()) {
	            user = new User();
	            user.setId(rs.getInt("user_id"));
	            user.setUsername(rs.getString("username"));
	            user.setEmail(rs.getString("email"));
	            user.setPlanId(rs.getInt("plan_id"));

	            String planName = rs.getString("plan_name");
	            user.setPremiumPlan(planName != null ? planName : "Free");

	            // subscription dates
	            Date startDate = rs.getDate("premium_start");
	            Date endDate = rs.getDate("premium_end");
	            user.setPremiumStart(startDate);
	            user.setPremiumExpiry(endDate);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return user;
	}

	
	
	public User getUserById(int userId) throws SQLException {
	    String sql = "SELECT * FROM users WHERE user_id = ?";
	    try (Connection conn = DB.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, userId);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            User user = new User();
	            user.setId(rs.getInt("user_id"));
	            user.setUsername(rs.getString("username"));
	            user.setEmail(rs.getString("email"));
	            user.setPassword(rs.getString("password"));
	            user.setPlanId(rs.getInt("plan_id"));
	            user.setVerified(rs.getBoolean("is_verified"));
	            return user;
	        }
	    }
	    return null;
	}

	
	// Delete user
	public void deleteUser(int userId) throws SQLException {
	    String sql = "DELETE FROM users WHERE user_id = ?";
	    try (Connection conn = DB.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, userId);
	        ps.executeUpdate();
	    }
	}

	// Update username/email
	public void updateUser(int userId, String username, String email) throws SQLException {
	    String sql = "UPDATE users SET username = ?, email = ? WHERE user_id = ?";
	    try (Connection conn = DB.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, username);
	        ps.setString(2, email);
	        ps.setInt(3, userId);
	        ps.executeUpdate();
	    }
	}
	
	// Update user's plan (for admin)
	public void updateUserPlan(int userId, int planId) throws SQLException {
	    String sql = "UPDATE users u "
	               + "LEFT JOIN subscription s ON u.user_id = s.user_id AND s.is_active = 1 "
	               + "SET u.plan_id = ?, s.end_date = ? "
	               + "WHERE u.user_id = ?";
	    try (Connection conn = DB.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, planId);
	        ps.setInt(2, userId);
	        ps.executeUpdate();
	    }
	}
	
	
	public void updateUsername(int userId, String newUsername) throws Exception {
	    String sql = "UPDATE users SET username=? WHERE user_id=?";
	    try (Connection conn = DB.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, newUsername);
	        ps.setInt(2, userId);
	        ps.executeUpdate();
	    }
	}

	public void updatePassword(int userId, String newPassword) throws Exception {
	    String sql = "UPDATE users SET password=? WHERE user_id=?";
	    try (Connection conn = DB.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, newPassword);
	        ps.setInt(2, userId);
	        ps.executeUpdate();
	    }
	}

	
    public boolean isAdmin(int userId) throws SQLException {
        String sql = "SELECT * FROM admin WHERE user_id = ?";
        try (Connection conn = DB.getConnection();
        	 PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // true if record exists in admin table
        }
    }
    
    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DB.getConnection();
        	 PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setPlanId(rs.getInt("plan_id"));
                user.setVerified(rs.getBoolean("is_verified"));
                user.setAdmin(isAdmin(user.getId()));
                return user;
            }
        }
        return null;
    }
    
    public User getUserByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = DB.getConnection();
        	 PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setPlanId(rs.getInt("plan_id"));
                user.setVerified(rs.getBoolean("is_verified"));
                return user;
            }
        }
        return null;
    }
    
    public boolean createUser(User user) throws SQLException {
        String sql = "INSERT INTO users (username, email, password, plan_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = DB.getConnection();
        	 PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setInt(4, user.getPlanId()); 
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean updateUserVerification(int userId, boolean verified) throws SQLException {
        String sql = "UPDATE users SET is_verified = ? WHERE user_id = ?";
        try (Connection conn = DB.getConnection();
        	 PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, verified);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }
    public int createUserReturnId(User user) throws SQLException {
        String sql = "INSERT INTO users (username, email, password, plan_id, is_verified) VALUES (?, ?, ?, ?, false)";
        try (Connection conn = DB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setInt(4, user.getPlanId());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) throw new SQLException("Creating user failed, no rows affected.");
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Creating user failed, no ID obtained.");
                }
            }
        }
    }

    public boolean verifySignupOTPAndActivate(int userId, String otpCode) throws SQLException {
        String sql = "SELECT * FROM otp_codes WHERE user_id = ? AND otp_code = ? AND is_used = FALSE AND expiry_time > NOW()";
        try (Connection conn = DB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, otpCode);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int otpId = rs.getInt("otp_id");

                // Mark OTP as used
                String updateOtpSql = "UPDATE otp_codes SET is_used = TRUE WHERE otp_id = ?";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateOtpSql)) {
                    updateStmt.setInt(1, otpId);
                    updateStmt.executeUpdate();
                }

                // Set user as verified
                String updateUserSql = "UPDATE users SET is_verified = TRUE WHERE user_id = ?";
                try (PreparedStatement updateUserStmt = conn.prepareStatement(updateUserSql)) {
                    updateUserStmt.setInt(1, userId);
                    updateUserStmt.executeUpdate();
                }

                return true;
            }
        }
        return false;
    }
  
    public boolean saveOTP(int userId, String otpCode) throws SQLException {
        String sql = "INSERT INTO otp_codes (user_id, otp_code, expiry_time) VALUES (?, ?, ?)";
        try (Connection conn = DB.getConnection();
        	 PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, otpCode);
            stmt.setTimestamp(3, Timestamp.valueOf(OTPUtil.getExpiryTime()));
            return stmt.executeUpdate() > 0;
        }
    }
    
    public String getOTPByUserId(int userId) throws SQLException {
        String sql = "SELECT otp_code FROM otp_codes WHERE user_id = ? AND is_used = FALSE ORDER BY created_at DESC LIMIT 1";
        try (Connection conn = DB.getConnection();
        	 PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("otp_code");
            }
        }
        return null;
    }
    
    public boolean verifyOTP(int userId, String otpCode) throws SQLException {
        String sql = "SELECT * FROM otp_codes WHERE user_id = ? AND otp_code = ? AND is_used = FALSE AND expiry_time > NOW()";
        try (Connection conn = DB.getConnection();
        	 PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, otpCode);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                // Mark OTP as used
                String updateSql = "UPDATE otp_codes SET is_used = TRUE WHERE otp_id = ?";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    updateStmt.setInt(1, rs.getInt("otp_id"));
                    updateStmt.executeUpdate();
                }
                return true;
            }
        }
        return false;
    }
    
    public void clearExpiredOTPs() throws SQLException {
        String sql = "DELETE FROM otp_codes WHERE expiry_time < NOW()";
        try (Connection conn = DB.getConnection();
        	 Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(sql);
        }
    }
}