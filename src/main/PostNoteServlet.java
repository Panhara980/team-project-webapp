package com.notes.controller;

import com.notes.dao.NoteDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

@WebServlet("/post-note")
public class PostNoteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final NoteDAO noteDAO = new NoteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isProfessor(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        request.getRequestDispatcher("/post-note.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isProfessor(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String title = request.getParameter("title");
        String subject = request.getParameter("subject");
        String content = request.getParameter("content");

        boolean hasError = false;
        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("titleError", "Title is required.");
            hasError = true;
        }
        if (subject == null || subject.trim().isEmpty()) {
            request.setAttribute("subjectError", "Please select a subject.");
            hasError = true;
        }
        if (content == null || content.trim().length() < 20) {
            request.setAttribute("contentError", "Content must be at least 20 characters.");
            hasError = true;
        }

        if (hasError) {
            request.setAttribute("errorMessage", "Please fix the errors below.");
            request.getRequestDispatcher("/post-note.jsp").forward(request, response);
            return;
        }

        try {
            HttpSession session = request.getSession();
            int userId = Integer.parseInt((String) session.getAttribute("userId"));

            noteDAO.createNote(title.trim(), subject.trim(), content.trim(), userId);

            response.sendRedirect(request.getContextPath() + "/dashboard");
        } catch (SQLException e) {
            throw new ServletException("Database error creating note", e);
        }
    }

    @SuppressWarnings("unchecked")
    private boolean isProfessor(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        Map<String, String> user = (Map<String, String>) session.getAttribute("user");
        return user != null && "professor".equalsIgnoreCase(user.get("role"));
    }
}