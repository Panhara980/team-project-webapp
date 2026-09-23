package com.notes.controller;

import com.notes.dao.NoteDAO;
import com.notes.model.Note;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/dashboard")
public class ViewNotesServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final NoteDAO noteDAO = new NoteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            List<Note> notes;

            if (request.getParameter("myPosts") != null) {
                int userId = Integer.parseInt((String) session.getAttribute("userId"));
                notes = noteDAO.getNotesByUser(userId);
            } else {
                notes = noteDAO.getAllNotes();
            }

            String category = request.getParameter("category");
            String query = request.getParameter("q");

            List<Note> filtered = new ArrayList<>();
            for (Note n : notes) {
                boolean matchesCategory = (category == null || category.equals("All")
                        || category.equalsIgnoreCase(n.getSubject()));
                boolean matchesQuery = (query == null || query.trim().isEmpty()
                        || n.getTitle().toLowerCase().contains(query.toLowerCase())
                        || n.getSubject().toLowerCase().contains(query.toLowerCase())
                        || n.getContent().toLowerCase().contains(query.toLowerCase()));
                if (matchesCategory && matchesQuery) {
                    filtered.add(n);
                }
            }

            // dashboard.jsp reads request-scoped "announcements" (for the
            // category counts) and "filteredAnnouncements" (for the cards).
            // Each item there is read as a Map, so we convert here to avoid
            // touching the JSP's EL expressions (ann.title, ann.subject, etc.
            // work the same way against a Map<String,String> as a bean).
            List<java.util.Map<String, String>> allAsMaps = toMaps(notes);
            List<java.util.Map<String, String>> filteredAsMaps = toMaps(filtered);

            request.setAttribute("announcements", allAsMaps);
            request.setAttribute("filteredAnnouncements", filteredAsMaps);

            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Database error loading notes", e);
        }
    }

    private List<java.util.Map<String, String>> toMaps(List<Note> notes) {
        List<java.util.Map<String, String>> list = new ArrayList<>();
        java.text.SimpleDateFormat fmt = new java.text.SimpleDateFormat("MMM d, yyyy");

        for (Note n : notes) {
            java.util.Map<String, String> m = new java.util.LinkedHashMap<>();
            m.put("id", String.valueOf(n.getNoteId()));
            m.put("title", n.getTitle());
            m.put("subject", n.getSubject());
            m.put("contentPreview", n.getContent());
            m.put("authorName", n.getAuthorName());
            m.put("formattedDate", fmt.format(n.getCreatedAt()));
            list.add(m);
        }
        return list;
    }
}