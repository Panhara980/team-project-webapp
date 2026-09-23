package com.notes.model;

import java.sql.Timestamp;

public class Note {

    private int noteId;
    private String title;
    private String subject;
    private String content;
    private int userId;       // FK to users.user_id
    private String authorName; // filled in by NoteDAO via a JOIN, not a DB column
    private Timestamp createdAt;

    public Note() {
    }

    public Note(int noteId, String title, String subject, String content,
                int userId, String authorName, Timestamp createdAt) {
        this.noteId = noteId;
        this.title = title;
        this.subject = subject;
        this.content = content;
        this.userId = userId;
        this.authorName = authorName;
        this.createdAt = createdAt;
    }

    public int getNoteId() {
        return noteId;
    }

    public void setNoteId(int noteId) {
        this.noteId = noteId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}