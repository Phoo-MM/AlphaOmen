package com.alphaomen.servlet;

import com.alphaomen.db.DB;
import com.alphaomen.model.User;
import java.io.*;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/ImportServlet")
@MultipartConfig
public class ImportServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part filePart = request.getPart("file");
        String fileName = filePart.getSubmittedFileName();
        
        String title = fileName != null ? fileName.replaceFirst("[.][^.]+$", "") : "Imported_Note";
        
        String content = new String(filePart.getInputStream().readAllBytes(), "UTF-8");
        
        User user = (User) request.getSession().getAttribute("user");
        try (Connection conn = DB.getConnection()) {
        	//Base Title
        	String baseTitle = title;
        	
        	PreparedStatement checkPs = conn.prepareStatement("SELECT COUNT(*) FROM note WHERE user_id = ? AND title = ?");
        	checkPs.setInt(1, user.getId());
        	
        	int counter = 0;
        	while (true) {
        		checkPs.setString(2, title);
        		ResultSet rs = checkPs.executeQuery();
        		rs.next();
        		int count = rs.getInt(1);
        		rs.close();
        		if (count == 0) break; // no conflict
        		counter++;
        		title = baseTitle + "(" + counter + ")";
        	}
        	
        	// Insert note
            PreparedStatement ps = conn.prepareStatement("INSERT INTO note (user_id, title, content, created_at) VALUES (?, ?, ?, NOW())");
            
        	ps.setInt(1, user.getId());
        	ps.setString(2, title);
            ps.setString(3, content);
            ps.executeUpdate();

            response.sendRedirect("notes.jsp");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

