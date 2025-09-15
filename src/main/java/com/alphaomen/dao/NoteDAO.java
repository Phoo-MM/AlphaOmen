package com.alphaomen.dao;

import com.alphaomen.model.Note;
import com.alphaomen.model.Tag;
import com.alphaomen.db.DB;

import jakarta.servlet.ServletContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NoteDAO {

    // ===== Get note count per user =====
    public int getNoteCountByUser(int userId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM note WHERE user_id=?";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // ===== Get tag count per user (distinct tags in user's notes) =====
    public int getTagCountByUser(int userId) {
        int count = 0;
        String sql = "SELECT COUNT(*) AS tag_count FROM tag WHERE user_id=?";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("tag_count");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
    
	// ===== Index Page Get Note =====
	public List<Note> getImportantNotesByUser(int userId) throws SQLException {
	    String sql = "SELECT * FROM note WHERE user_id=? AND (is_pinned=1 OR due_date<=CURDATE()) ORDER BY is_pinned DESC, due_date ASC";
	    Connection conn = DB.getConnection();
	    PreparedStatement pst = conn.prepareStatement(sql);
	    pst.setInt(1, userId);
	    ResultSet rs = pst.executeQuery();
	    List<Note> notes = new ArrayList<>();
	    while(rs.next()) {
	        Note n = new Note();
	        n.setNoteId(rs.getInt("note_id"));
	        n.setTitle(rs.getString("title"));
	        n.setContent(rs.getString("content"));
	        n.setPinned(rs.getBoolean("is_pinned"));
	        n.setDueDate(rs.getDate("due_date"));
	        notes.add(n);
	    }
	    return notes;
	}

    // ===== Create a new note =====
    public void createNote(Note note) throws Exception {
        String sql = "INSERT INTO note (user_id, title, content, is_pinned, color, due_date, tag_id, voice_note_path) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, note.getUserId());
            ps.setString(2, note.getTitle());
            ps.setString(3, note.getContent());
            ps.setBoolean(4, note.isPinned());
            ps.setString(5, note.getColor());

            if (note.getDueDate() != null) {
                ps.setDate(6, new java.sql.Date(note.getDueDate().getTime()));
            } else {
                ps.setNull(6, Types.DATE);
            }

            if (note.getTagId() != null) {
                ps.setInt(7, note.getTagId());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            ps.setString(8, note.getVoiceNotePath());

            ps.executeUpdate();
        }
    }
    
    // ===== Update an existing note =====
    public void updateNote(Note note) throws Exception {
        String sql = "UPDATE note SET title=?, content=?, is_pinned=?, color=?, due_date=?, tag_id=?, voice_note_path=?, updated_at=NOW() "
                   + "WHERE note_id=?";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, note.getTitle());
            ps.setString(2, note.getContent());
            ps.setBoolean(3, note.isPinned());
            ps.setString(4, note.getColor());

            if (note.getDueDate() != null) {
                ps.setDate(5, new java.sql.Date(note.getDueDate().getTime()));
            } else {
                ps.setNull(5, Types.DATE);
            }

            if (note.getTagId() != null) {
                ps.setInt(6, note.getTagId());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            ps.setString(7,  note.getVoiceNotePath());
            ps.setInt(8, note.getNoteId());

            ps.executeUpdate();
        }
    }

    // ===== Delete a note =====
    public void deleteNote(int noteId) throws Exception {
        String sql = "DELETE FROM note WHERE note_id=?";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, noteId);
            ps.executeUpdate();
        }
    }

    // ===== Get all notes for a user =====
    public List<Note> getNotesByUser(int userId) throws Exception {
        List<Note> notes = new ArrayList<>();
        String sql = "SELECT n.*, t.tag_name FROM note n LEFT JOIN tag t ON n.tag_id = t.tag_id WHERE n.user_id=?";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Note n = new Note();
                n.setNoteId(rs.getInt("note_id"));
                n.setUserId(rs.getInt("user_id"));
                n.setTitle(rs.getString("title"));
                n.setContent(rs.getString("content"));
                n.setPinned(rs.getBoolean("is_pinned"));
                n.setColor(rs.getString("color"));
                n.setDueDate(rs.getDate("due_date"));
                n.setTagId(rs.getInt("tag_id") != 0 ? rs.getInt("tag_id") : null);
                n.setTagName(rs.getString("tag_name"));
                n.setCreatedAt(rs.getTimestamp("created_at"));
                n.setUpdatedAt(rs.getTimestamp("updated_at"));
                n.setVoiceNotePath(rs.getString("voice_note_path"));

                notes.add(n);
            }
        }
        return notes;
    }

    // ===== Get a single note by ID =====
    public Note getNoteById(int noteId) throws Exception {
        String sql = "SELECT * FROM note WHERE note_id=?";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, noteId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Note n = new Note();
                n.setNoteId(rs.getInt("note_id"));
                n.setUserId(rs.getInt("user_id"));
                n.setTitle(rs.getString("title"));
                n.setContent(rs.getString("content"));
                n.setPinned(rs.getBoolean("is_pinned"));
                n.setColor(rs.getString("color"));
                n.setDueDate(rs.getDate("due_date"));
                n.setTagId(rs.getInt("tag_id") != 0 ? rs.getInt("tag_id") : null);
                n.setCreatedAt(rs.getTimestamp("created_at"));
                n.setUpdatedAt(rs.getTimestamp("updated_at"));
                n.setVoiceNotePath(rs.getString("voice_note_path"));

                return n;
            }
        }
        return null;
    }
    
    // ===== Get Notes by Filter =====
    public List<Note> getNotesByUserFiltered(int userId, String searchText, String category, String pinned, String sortBy) throws Exception {
        List<Note> notes = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("SELECT n.*, t.tag_name FROM note n LEFT JOIN tag t ON n.tag_id = t.tag_id WHERE n.user_id = ?");
        
        // Dynamic filters
        if (searchText != null && !searchText.isEmpty()) {
            sql.append(" AND (n.title LIKE ? OR n.content LIKE ?)");
        }
        if (category != null && !category.isEmpty()) {
            sql.append(" AND t.tag_name = ?");
        }
        if (pinned != null && !pinned.isEmpty()) {
            sql.append(" AND n.is_pinned = ?");
        }
        
        // Sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            if (sortBy.equals("title")) sql.append(" ORDER BY n.is_pinned DESC, n.title ASC");
            else if (sortBy.equals("duedate")) sql.append(" ORDER BY n.is_pinned DESC, CASE WHEN n.due_date IS NULL THEN 1 ELSE 0 END, n.due_date ASC");
            else if (sortBy.equals("category")) sql.append(" ORDER BY n.is_pinned DESC, t.tag_name ASC");
        } else {
            sql.append(" ORDER BY n.is_pinned DESC, n.created_at DESC");
        }
        
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int index = 1;
            ps.setInt(index++, userId);
            
            if (searchText != null && !searchText.isEmpty()) {
                ps.setString(index++, "%" + searchText + "%");
                ps.setString(index++, "%" + searchText + "%");
            }
            if (category != null && !category.isEmpty()) {
                ps.setString(index++, category);
            }
            if (pinned != null && !pinned.isEmpty()) {
                ps.setBoolean(index++, "1".equals(pinned));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Note n = new Note();
                n.setNoteId(rs.getInt("note_id"));
                n.setTitle(rs.getString("title"));
                n.setContent(rs.getString("content"));
                n.setPinned(rs.getBoolean("is_pinned"));
                n.setColor(rs.getString("color"));
                n.setDueDate(rs.getDate("due_date"));
                n.setTagName(rs.getString("tag_name"));
                n.setVoiceNotePath(rs.getString("voice_note_path"));

                notes.add(n);
            }
        }
        
        return notes;
    }

    
    public int createTagIfNotExists(int userId, String tagName) throws Exception {
    	int tagId = -1;
    	
    	try (Connection conn = DB.getConnection()) {

    		// Check if the tag already exists for this user
            String checkTagSql = "SELECT tag_id FROM tag WHERE tag_name = ? AND user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkTagSql)) {
                ps.setString(1, tagName);
                ps.setInt(2, userId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    tagId = rs.getInt("tag_id");
                }
            }

            // If not exists, insert new tag for this user
            if (tagId == -1) {
                String insertTagSql = "INSERT INTO tag(tag_name, user_id) VALUES (?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertTagSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, tagName);
                    ps.setInt(2, userId);
                    ps.executeUpdate();
                    ResultSet rs = ps.getGeneratedKeys();
                    if (rs.next()) tagId = rs.getInt(1);
                }
            }
        }
        return tagId;
    }

    
 // ===== Get all tags for a user =====
    public List<Tag> getTagsByUser(int userId) throws Exception {
        List<Tag> tags = new ArrayList<>();
        String sql = "SELECT tag_id, tag_name FROM tag WHERE user_id=? ORDER BY tag_id";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Tag tag = new Tag();
                tag.setId(rs.getInt("tag_id"));
                tag.setName(rs.getString("tag_name"));
                tags.add(tag);
            }
        }
        return tags;
    }

    // ===== Update tag =====
    public void updateTag(int tagId, String tagName) throws Exception {
        String sql = "UPDATE tag SET tag_name=? WHERE tag_id=?";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tagName);
            ps.setInt(2, tagId);
            ps.executeUpdate();
        }
    }

    // ===== Delete tag safely =====
    public void deleteTag(int tagId, int userId) throws Exception {
        try (Connection conn = DB.getConnection()) {
            conn.setAutoCommit(false); // start transaction

         // Unlink from notes
            String unlinkSql = "UPDATE note SET tag_id = NULL WHERE tag_id = ? AND user_id = ?";
            try (PreparedStatement ps1 = conn.prepareStatement(unlinkSql)) {
                ps1.setInt(1, tagId);
                ps1.setInt(2, userId);
                ps1.executeUpdate();
            }

            // Delete the tag
            String deleteSql = "DELETE FROM tag WHERE tag_id = ? AND user_id = ?";
            try (PreparedStatement ps2 = conn.prepareStatement(deleteSql)) {
                ps2.setInt(1, tagId);
                ps2.setInt(2, userId);
                ps2.executeUpdate();
            }

            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    

}