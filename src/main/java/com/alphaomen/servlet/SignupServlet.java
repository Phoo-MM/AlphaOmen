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

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/signup.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String otp = request.getParameter("otp");
        String action = request.getParameter("action");
        
        HttpSession session = request.getSession();
        
        try {
            // STEP 1: Handle signup (create user + send OTP)
            if ("signup".equals(action)) {
                if (!password.equals(confirmPassword)) {
                    session.setAttribute("message", "Passwords do not match!");
                    session.setAttribute("messageType", "error");
                    response.sendRedirect("signup.jsp");
                    return;
                }

                if (userDAO.getUserByEmail(email) != null || userDAO.getUserByUsername(username) != null) {
                    session.setAttribute("message", "Username or email already exists!");
                    session.setAttribute("messageType", "error");
                    response.sendRedirect("signup.jsp");
                    return;
                }

                // Create user with is_verified = false
                int defaultPlanId = 1; // Free plan
                User newUser = new User(username, email, hashPassword(password), defaultPlanId);
                int userId = userDAO.createUserReturnId(newUser);

                // Send OTP
                String generatedOTP = OTPUtil.generateOTP();
                userDAO.saveOTP(userId, generatedOTP);
                EmailService.sendOTPEmail(email, generatedOTP);

                session.setAttribute("otpSent", true);
                session.setAttribute("signupUserId", userId);
                session.setAttribute("message", "OTP sent to your email! Please verify.");
                session.setAttribute("messageType", "info");

                response.sendRedirect("signup.jsp");
                return;
            }

            // STEP 2: Handle OTP verification
            if ("verifyOtp".equals(action)) {
                Integer userId = (Integer) session.getAttribute("signupUserId");
                if (userId != null && otp != null) {
                    if (userDAO.verifySignupOTPAndActivate(userId, otp)) {
                        session.removeAttribute("signupUserId");
                        session.removeAttribute("otpSent");

                        session.setAttribute("message", "Account verified successfully! Please login.");
                        session.setAttribute("messageType", "success");
                        response.sendRedirect("login.jsp");
                        return;
                    } else {
                        session.setAttribute("message", "Invalid or expired OTP!");
                        session.setAttribute("messageType", "error");
                        response.sendRedirect("signup.jsp");
                        return;
                    }
                } else {
                    session.setAttribute("message", "Session expired or invalid data!");
                    session.setAttribute("messageType", "error");
                    response.sendRedirect("signup.jsp");
                    return;
                }
            }

            // STEP 3: Fallback (invalid action)
            session.setAttribute("message", "Invalid signup action!");
            session.setAttribute("messageType", "error");
            response.sendRedirect("signup.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("message", "Database error occurred during signup!");
            session.setAttribute("messageType", "error");
            response.sendRedirect("signup.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "An unexpected error occurred during signup!");
            session.setAttribute("messageType", "error");
            response.sendRedirect("signup.jsp");
        }
    }
    
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}