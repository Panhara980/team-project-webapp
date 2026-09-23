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

@WebServlet("/delete-note")
public class DeleteNoteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final NoteDAO noteDAO = new NoteDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isProfessor(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            int noteId = Integer.parseInt(request.getParameter("id"));
            noteDAO.deleteNote(noteId);
        } catch (NumberFormatException e) {
            // ignore malformed id, just fall through to redirect
        } catch (SQLException e) {
            throw new ServletException("Database error deleting note", e);
        }

        response.sendRedirect(request.getContextPath() + "/dashboard");
    }

    @SuppressWarnings("unchecked")
    private boolean isProfessor(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        Map<String, String> user = (Map<String, String>) session.getAttribute("user");
        return user != null && "professor".equalsIgnoreCase(user.get("role"));
    }
}