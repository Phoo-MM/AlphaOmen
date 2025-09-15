package com.alphaomen.servlet;

import com.alphaomen.dao.UserDAO;
import com.alphaomen.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@WebServlet("/account")
public class AccountServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("updateInfo".equals(action)) {
                String newUsername = request.getParameter("username");

                // update in DB
                userDAO.updateUsername(user.getId(), newUsername);

                // update session user object
                user.setUsername(newUsername);
                session.setAttribute("user", user);

                session.setAttribute("message", "Account info updated successfully!");
                session.setAttribute("messageType", "success");

            } else if ("changePassword".equals(action)) {
                String currentPassword = request.getParameter("currentPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");

                if (!newPassword.equals(confirmPassword)) {
                    session.setAttribute("message", "New passwords do not match!");
                    session.setAttribute("messageType", "error");
                    response.sendRedirect("accinfo.jsp");
                    return;
                }

                String storedPassword = userDAO.getPasswordByUserId(user.getId());
                
                if (verifyPassword(currentPassword, storedPassword)) {
                    String hashedNewPassword = hashPassword(newPassword);
                    userDAO.updatePassword(user.getId(), hashedNewPassword);

                    user.setPassword(hashedNewPassword);
                    session.setAttribute("user", user);

                    session.setAttribute("message", "Password updated successfully!");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Current password is incorrect!");
                    session.setAttribute("messageType", "success");
                }
            }

            response.sendRedirect("accinfo.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "An error occurred while updating account!");
            session.setAttribute("messageType", "error");
            response.sendRedirect("accinfo.jsp");
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
