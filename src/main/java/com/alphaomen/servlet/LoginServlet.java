package com.alphaomen.servlet;

import com.alphaomen.dao.UserDAO;
import com.alphaomen.model.User;
import com.alphaomen.service.EmailService;
import com.alphaomen.util.OTPUtil;

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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String otp = request.getParameter("otp");
        String action = request.getParameter("action");
        
        HttpSession session = request.getSession();
        
        try {
            if ("sendOtp".equals(action)) {
                // Send OTP
                User user = userDAO.getUserByEmail(email);
                if (user != null) {
                    String generatedOTP = OTPUtil.generateOTP();
                    EmailService.sendOTPEmail(email, generatedOTP);
                    
                    // Save OTP to database
                    userDAO.saveOTP(user.getId(), generatedOTP);
                    
                    session.setAttribute("otpSent", true);
                    session.setAttribute("userEmail", email);
                    session.setAttribute("message", "OTP sent to your email!");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "User not found!");
                    session.setAttribute("messageType", "error");
                }
                
                response.sendRedirect("login.jsp");
                return;
            }
            
            if ("verifyOtp".equals(action)) {
                // Verify OTP
                String userEmail = (String) session.getAttribute("userEmail");
                if (userEmail != null && otp != null) {
                    User user = userDAO.getUserByEmail(userEmail);
                    if (user != null && userDAO.verifyOTP(user.getId(), otp)) {
                        // OTP verified successfully
                        session.setAttribute("user", user);
                        session.setAttribute("message", "Login successful!");
                        session.setAttribute("messageType", "success");
                        response.sendRedirect("index.jsp");
                        return;
                    } else {
                        session.setAttribute("message", "Invalid OTP!");
                        session.setAttribute("messageType", "error");
                    }
                } else {
                    session.setAttribute("message", "Session expired or invalid data!");
                    session.setAttribute("messageType", "error");
                }
                
                response.sendRedirect("login.jsp");
                return;
            }
            
            // Regular login with password
            User user = userDAO.getUserByEmail(email);
            if (user != null && verifyPassword(password, user.getPassword())) {
                if (user.isVerified()) {
                    session.setAttribute("user", user);
                    session.setAttribute("username", user.getUsername());
                    session.setAttribute("isAdmin", user.isAdmin());
                    response.sendRedirect("index.jsp");
                } else {
                    // Send OTP for verification
                    String generatedOTP = OTPUtil.generateOTP();
                    EmailService.sendOTPEmail(email, generatedOTP);
                    userDAO.saveOTP(user.getId(), generatedOTP);
                    
                    session.setAttribute("otpSent", true);
                    session.setAttribute("userEmail", email);
                    session.setAttribute("message", "Please enter OTP sent to your email!");
                    session.setAttribute("messageType", "info");
                    response.sendRedirect("login.jsp");
                }
            } else {
                session.setAttribute("message", "Invalid email or password!");
                session.setAttribute("messageType", "error");
                response.sendRedirect("login.jsp");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("message", "Database error occurred during login!");
            session.setAttribute("messageType", "error");
            response.sendRedirect("login.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "An unexpected error occurred during login!");
            session.setAttribute("messageType", "error");
            response.sendRedirect("login.jsp");
        }
    }
    
    private boolean verifyPassword(String inputPassword, String storedPassword) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(inputPassword.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString().equals(storedPassword);
        } catch (NoSuchAlgorithmException e) {
            return false;
        }
    }
}
