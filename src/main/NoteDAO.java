package com.notes.dao;

import com.notes.model.Note;
import com.notes.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class NoteDAO {

    /** Returns all notes, newest first, joined with the author's full name. */
    public List<Note> getAllNotes() throws SQLException {
        String sql = "SELECT n.note_id, n.title, n.subject, n.content, " +
                     "       n.user_id, n.created_at, u.full_name " +
                     "FROM notes n " +
                     "JOIN users u ON n.user_id = u.user_id " +
                     "ORDER BY n.created_at DESC";

        List<Note> notes = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                notes.add(mapRow(rs));
            }
        }
        return notes;
    }

    /** Returns only the notes posted by a specific user (e.g. "My Posts"). */
    public List<Note> getNotesByUser(int userId) throws SQLException {
        String sql = "SELECT n.note_id, n.title, n.subject, n.content, " +
                     "       n.user_id, n.created_at, u.full_name " +
                     "FROM notes n " +
                     "JOIN users u ON n.user_id = u.user_id " +
                     "WHERE n.user_id = ? " +
                     "ORDER BY n.created_at DESC";

        List<Note> notes = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notes.add(mapRow(rs));
                }
            }
        }
        return notes;
    }

    /** Inserts a new note/announcement. */
    public void createNote(String title, String subject, String content, int userId) throws SQLException {
        String sql = "INSERT INTO notes (title, subject, content, user_id) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, title);
            stmt.setString(2, subject);
            stmt.setString(3, content);
            stmt.setInt(4, userId);

            stmt.executeUpdate();
        }
    }

    /** Deletes a note by id. Returns true if a row was actually deleted. */
    public boolean deleteNote(int noteId) throws SQLException {
        String sql = "DELETE FROM notes WHERE note_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, noteId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        }
    }

    private Note mapRow(ResultSet rs) throws SQLException {
        Note note = new Note();
        note.setNoteId(rs.getInt("note_id"));
        note.setTitle(rs.getString("title"));
        note.setSubject(rs.getString("subject"));
        note.setContent(rs.getString("content"));
        note.setUserId(rs.getInt("user_id"));
        note.setAuthorName(rs.getString("full_name"));
        note.setCreatedAt(rs.getTimestamp("created_at"));
        return note;
    }
}