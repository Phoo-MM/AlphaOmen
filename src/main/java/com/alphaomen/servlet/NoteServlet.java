package com.alphaomen.servlet;

import com.alphaomen.dao.*;
import com.alphaomen.model.*;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.alphaomen.db.DB;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.sql.*;


@WebServlet("/note")
@MultipartConfig
public class NoteServlet extends HttpServlet {

    private NoteDAO noteDAO = new NoteDAO();
    // ===== Fixed upload directory =====
    private static final String UPLOAD_DIR = "C:/VoiceUploads/";
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    createNote(request, response);
                    break;
                case "update":
                    updateNote(request, response);
                    break;
                case "delete":
                    deleteNote(request, response);
                    break;
                case "createTag":
                    createTag(request, response);
                    break;
                case "updateTag":
                    updateTag(request, response);
                    break;
                case "deleteTag":
                    deleteTag(request, response);
                    break;
                default:
                    response.sendRedirect("notes.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("notes.jsp");
        }
    }
    

    // ===== File Upload Helper =====
    private String handleVoiceUpload(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("audioFile"); // <input name="audioFile">
        if (filePart == null || filePart.getSize() == 0) return null;

        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String fileName = "voice_" + System.currentTimeMillis() + ".webm";
        File file = new File(uploadDir, fileName);

        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        return fileName;
    }
    
    private Map<String, Object> autoCorrectWithSuggestions(String text) {
        Map<String, Object> result = new HashMap<>();
        try {
            URL url = new URL("http://localhost:5000/autocorrect");
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json; utf-8");
            con.setRequestProperty("Accept", "application/json");
            con.setDoOutput(true);

            String jsonInput = "{\"text\":\"" + text + "\"}";
            try (OutputStream os = con.getOutputStream()) {
                os.write(jsonInput.getBytes("utf-8"));
            }

            StringBuilder responseStr = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"))) {
                String line;
                while ((line = br.readLine()) != null) responseStr.append(line.trim());
            }

            JsonObject jsonObj = JsonParser.parseString(responseStr.toString()).getAsJsonObject();

            result.put("original", jsonObj.get("original").getAsString());
            result.put("corrected", jsonObj.get("corrected").getAsString());

            List<Map<String, Object>> corrections = new ArrayList<>();
            if (jsonObj.has("corrections")) {
                JsonArray corrArray = jsonObj.getAsJsonArray("corrections");
                for (JsonElement el : corrArray) {
                    JsonObject obj = el.getAsJsonObject();
                    Map<String, Object> corrMap = new HashMap<>();
                    corrMap.put("word", obj.get("word").getAsString());

                    List<String> suggestions = new ArrayList<>();
                    JsonArray suggArray = obj.getAsJsonArray("suggestions");
                    for (JsonElement s : suggArray) {
                        suggestions.add(s.getAsString());
                    }
                    corrMap.put("suggestions", suggestions);
                    corrections.add(corrMap);
                }
            }
            result.put("corrections", corrections);

        } catch (Exception e) {
            e.printStackTrace();
            result.put("original", text);
            result.put("corrected", text);
            result.put("corrections", new ArrayList<>());
        }
        return result;
    }

    
    // ===== Create a note =====
    private void createNote(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	// Get user from session
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
    	Note note = new Note();
        note.setUserId(user.getId());
        note.setTitle(request.getParameter("title"));
        note.setContent(request.getParameter("content"));
        note.setPinned("on".equals(request.getParameter("is_pinned")));
        note.setColor(request.getParameter("color"));
        
        // Voice Note Upload
        String uploadedPath = handleVoiceUpload(request);
        if (uploadedPath != null) {
            note.setVoiceNotePath(uploadedPath);
        }

        // Due date
        String dueDateStr = request.getParameter("due_date");
        if (dueDateStr != null && !dueDateStr.isEmpty()) {
            Date dueDate = new SimpleDateFormat("yyyy-MM-dd").parse(dueDateStr);
            note.setDueDate(dueDate);
        }

        
        // ===== Tag handling =====
        String tagIdStr = request.getParameter("tag_id");
        if ("new".equals(tagIdStr)) {
        	String newTagName = request.getParameter("new_tag_name");
        	if (newTagName != null && !newTagName.trim().isEmpty()) {
        		// Create tag using DAO method with userId & planId
                int newTagId = noteDAO.createTagIfNotExists(user.getId(), newTagName.trim()); // O as placeholder
                note.setTagId(newTagId);
            }
        } else {
        	note.setTagId(tagIdStr != null && !tagIdStr.isEmpty() ? Integer.parseInt(tagIdStr) : null);
        }
        
        // Save note
        noteDAO.createNote(note);
        response.sendRedirect("notes.jsp");
    }

    // ===== Update a note =====
    private void updateNote(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Note note = new Note();
        note.setNoteId(Integer.parseInt(request.getParameter("note_id")));
        note.setUserId(Integer.parseInt(request.getParameter("user_id")));
        
        // ===== Ensure title is never null =====
        String title = request.getParameter("title");
        if (title == null || title.trim().isEmpty()) {
        	title = "Untitled";
        }
        note.setTitle(title);
        note.setContent(request.getParameter("content"));
        note.setPinned("on".equals(request.getParameter("is_pinned")));
        note.setColor(request.getParameter("color"));

        // Handle voice note removal or upload
        String removeVoiceNote = request.getParameter("remove_voice_note");
        if ("true".equals(removeVoiceNote)) {
            String existingPath = request.getParameter("existing_voice_note");
            if (existingPath != null && !existingPath.isEmpty()) {
                File file = new File(UPLOAD_DIR, existingPath);
                if (file.exists()) file.delete();
            }
            note.setVoiceNotePath(null);
         // update DB to remove path
            Connection conn = DB.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE note SET voice_note_path = NULL WHERE note_id = ?"
            );
            ps.setInt(1, note.getNoteId());
            ps.executeUpdate();
        } else {
            String uploadedPath = handleVoiceUpload(request);
            if (uploadedPath != null) {
                note.setVoiceNotePath(uploadedPath);
                Connection conn = DB.getConnection();
                PreparedStatement ps = conn.prepareStatement(
                        "UPDATE note SET voice_note_path = ? WHERE note_id = ?"
                    );
                    ps.setString(1, uploadedPath);
                    ps.setInt(2, note.getNoteId());
                    ps.executeUpdate();
            } else {
                note.setVoiceNotePath(request.getParameter("existing_voice_note"));
            }
        }

        
        String dueDateStr = request.getParameter("due_date");
        if (dueDateStr != null && !dueDateStr.isEmpty()) {
            Date dueDate = new SimpleDateFormat("yyyy-MM-dd").parse(dueDateStr);
            note.setDueDate(dueDate);
        }

        String tagIdStr = request.getParameter("tag_id");
        if ("new".equals(tagIdStr)) {
            String newTagName = request.getParameter("new_tag_name");
            if (newTagName != null && !newTagName.trim().isEmpty()) {
                int newTagId = noteDAO.createTagIfNotExists(
                        ((User) request.getSession().getAttribute("user")).getId(), newTagName.trim());
                note.setTagId(newTagId);
            }
        } else {
            note.setTagId(tagIdStr != null && !tagIdStr.isEmpty() ? Integer.parseInt(tagIdStr) : null);
        }
        
        noteDAO.updateNote(note);
        response.sendRedirect("notes.jsp");
    }

    // ===== Delete a note =====
    private void deleteNote(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int noteId = Integer.parseInt(request.getParameter("note_id"));
        noteDAO.deleteNote(noteId);
        response.sendRedirect("notes.jsp");
    }
    
 // ===== Create a tag =====
    private void createTag(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String tagName = request.getParameter("tag_name");
        if (tagName != null && !tagName.trim().isEmpty()) {
            int userTagCount = noteDAO.getTagCountByUser(user.getId());
            int tagLimit = 5;
            boolean isFreeUser = user.getPlanId() != 2;
            
            if (isFreeUser && userTagCount >= tagLimit) {
            	// Redirect back with limitReached=true to show modal
            	response.sendRedirect("manageTags.jsp?limitReached=true");
            	return;
            }
        	noteDAO.createTagIfNotExists(user.getId(), tagName.trim());
        }
        response.sendRedirect("manageTags.jsp");
    }

    // ===== Update a tag =====
    private void updateTag(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int tagId = Integer.parseInt(request.getParameter("tag_id"));
        String tagName = request.getParameter("tag_name");
        if (tagName != null && !tagName.trim().isEmpty()) {
            noteDAO.updateTag(tagId, tagName.trim());
        }
        response.sendRedirect("manageTags.jsp");
    }

 // ===== Delete a tag =====
    private void deleteTag(HttpServletRequest request, HttpServletResponse response) throws Exception {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int tagId = Integer.parseInt(request.getParameter("tag_id"));
        noteDAO.deleteTag(tagId, user.getId());   // ✅ use DAO method, scoped to user

        response.sendRedirect("manageTags.jsp");
    }


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Optional: can handle view note if needed
        response.sendRedirect("notes.jsp");
    }
}
