package com.alphaomen.servlet;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

import com.alphaomen.dao.UserDAO;
import com.alphaomen.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UserAccServlet")
public class UserAccServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String userIdStr = request.getParameter("id");

        try {
            if (action != null && userIdStr != null) {
                int userId = Integer.parseInt(userIdStr);
                switch(action) {
                    case "delete":
                        userDAO.deleteUser(userId);
                        break;
                }
            }

            // always show user list
            List<User> users = userDAO.getAllUsersForAdmin();
            request.setAttribute("users", users);
            request.getRequestDispatcher("admin.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            String username = request.getParameter("username");
            String email = request.getParameter("email");

            // Optional: update plan if admin sends these
            String planIdStr = request.getParameter("planId");

            if (planIdStr != null) {
                int planId = Integer.parseInt(planIdStr);
                userDAO.updateUserPlan(userId, planId);
            }

            // Update username/email
            userDAO.updateUser(userId, username, email);

            response.sendRedirect("UserAccServlet"); // back to list

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error: " + e.getMessage());
        }
    }
}
