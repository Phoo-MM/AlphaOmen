package com.alphaomen.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.alphaomen.db.DB;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/PlanServlet")
public class PlanServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        int planId = Integer.parseInt(request.getParameter("planId"));

        try (Connection conn = DB.getConnection()) {
            if ("toggle".equals(action)) {
                // flip ads_enabled
                String sql = "UPDATE plan SET ads_enabled = NOT ads_enabled WHERE plan_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, planId);
                    ps.executeUpdate();
                }
            } else if ("edit".equals(action)) {
                double price = Double.parseDouble(request.getParameter("price"));
                int duration = Integer.parseInt(request.getParameter("duration"));
                String sql = "UPDATE plan SET price = ?, duration_months = ? WHERE plan_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setDouble(1, price);
                    ps.setInt(2, duration);
                    ps.setInt(3, planId);
                    ps.executeUpdate();
                }
            }
        } catch (Exception e) {
            throw new ServletException("Error in PlanServlet", e);
        }

        response.sendRedirect("admin.jsp#business");
    }
}
