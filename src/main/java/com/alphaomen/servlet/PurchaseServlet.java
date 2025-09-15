package com.alphaomen.servlet;

import com.alphaomen.dao.PlanDAO;
import com.alphaomen.db.DB;
import com.alphaomen.model.Plan;
import com.alphaomen.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;


@WebServlet("/PurchaseServlet")
public class PurchaseServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int planId = Integer.parseInt(request.getParameter("planId"));
        String userReference = request.getParameter("userReference");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp"); // redirect guest to login
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getId(); // safe now

        PlanDAO planDAO = new PlanDAO();
        Plan plan = planDAO.getPlanById(planId);
        
        if(userReference == null || !userReference.matches("\\d{20}")) {
            response.sendRedirect("purchasePlan.jsp?error=invalid_reference");
            return;
        }
        try (Connection conn = DB.getConnection()) {
        	
        	// Check if user already has a pending request
            String checkSql = "SELECT * FROM transactions WHERE user_id=? AND status='PENDING'";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, userId);
            ResultSet rs = checkPs.executeQuery();

            if(rs.next()) {
                // Pending request exists
                response.sendRedirect("purchasePlan.jsp?status=pending");
                return;
            }

            //  Insert new transaction
            String sql = "INSERT INTO transactions(user_id, plan_id, amount, payment_method, user_reference, status) VALUES (?, ?, ?, ?, ?, 'PENDING')";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, planId);
            ps.setDouble(3, plan.getPrice());
            ps.setString(4, "KBZPay");
            ps.setString(5, userReference);
            ps.executeUpdate();

            response.sendRedirect("purchasePlan.jsp?success=1");
        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("purchasePlan.jsp?error=1");
        }
    }
}
