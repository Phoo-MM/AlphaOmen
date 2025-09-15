package com.alphaomen.servlet;

import com.alphaomen.db.DB;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AdServlet")
public class AdServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String redirectUrl = "admin.jsp"; // default redirect
        try (Connection conn = DB.getConnection()) {
            if (action == null) {
                response.sendRedirect(redirectUrl);
                return;
            }

            switch (action) {
                case "toggle":
                    int adIdToggle = Integer.parseInt(request.getParameter("adId"));
                    toggleAd(conn, adIdToggle);
                    break;

                case "delete":
                    int adIdDelete = Integer.parseInt(request.getParameter("adId"));
                    deleteAd(conn, adIdDelete);
                    break;

                case "add":
                    addAd(conn, request);
                    break;
                    
                case "edit":
                    editAd(conn, request);
                    break;

                default:
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl);
    }

    private void toggleAd(Connection conn, int adId) throws SQLException {
        String sql = "UPDATE ads SET is_active = NOT is_active WHERE ad_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, adId);
            ps.executeUpdate();
        }
    }

    private void deleteAd(Connection conn, int adId) throws SQLException {
        String sql = "DELETE FROM ads WHERE ad_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, adId);
            ps.executeUpdate();
        }
    }

    private void addAd(Connection conn, HttpServletRequest request) throws SQLException {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String imageUrl = request.getParameter("imageUrl");
        String linkUrl = request.getParameter("linkUrl");
        String displayType = request.getParameter("displayType");

        String sql = "INSERT INTO ads (title, content, image_url, link_url, display_type) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setString(3, imageUrl);
            ps.setString(4, linkUrl);
            ps.setString(5, displayType);
            ps.executeUpdate();
        }
    }

    private void editAd(Connection conn, HttpServletRequest request) throws SQLException {
        int adId = Integer.parseInt(request.getParameter("adId"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String imageUrl = request.getParameter("imageUrl");
        String linkUrl = request.getParameter("linkUrl");
        String displayType = request.getParameter("displayType");
        boolean isActive = "on".equals(request.getParameter("isActive"));

        String sql = "UPDATE ads SET title=?, content=?, image_url=?, link_url=?, display_type=?, is_active=? WHERE ad_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setString(3, imageUrl);
            ps.setString(4, linkUrl);
            ps.setString(5, displayType);
            ps.setBoolean(6, isActive);
            ps.setInt(7, adId);
            ps.executeUpdate();
        }
    }
}
