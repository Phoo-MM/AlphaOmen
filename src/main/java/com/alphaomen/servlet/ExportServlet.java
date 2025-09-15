package com.alphaomen.servlet;

import com.alphaomen.db.DB;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/ExportServlet")
public class ExportServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String noteId = request.getParameter("noteId");

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT title, content FROM note WHERE note_id=?")) {

            ps.setString(1, noteId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
            	String title = rs.getString("title");
                String content = rs.getString("content");

                String safeTitle = title.replaceAll("[^a-zA-Z0-9-_\\.]", "_");
                response.setContentType("text/plain");
                response.setHeader("Content-Disposition", "attachment;filename=note_" + safeTitle + ".txt");

                try (PrintWriter out = response.getWriter()) {
                    out.write(content); 
                }
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
