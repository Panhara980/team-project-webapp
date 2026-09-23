package com.notes.controller;

import com.notes.dao.UserDAO;
import com.notes.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("usernameError", "Please enter a username.");
            request.setAttribute("errorMessage", "Please fill in all fields.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        if (password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Please enter a password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            User user = userDAO.validateLogin(username.trim(), password);

            if (user != null) {
                // dashboard.jsp reads sessionScope.user.displayName / .role,
                // so we store a small view-friendly wrapper here.
                java.util.Map<String, String> sessionUser = new java.util.LinkedHashMap<>();
                sessionUser.put("displayName", user.getFullName());
                sessionUser.put("role", user.getRole().toLowerCase());

                HttpSession session = request.getSession();
                session.setAttribute("user", sessionUser);
                session.setAttribute("userId", String.valueOf(user.getUserId()));

                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                request.setAttribute("usernameError", "No account found with that username.");
                request.setAttribute("errorMessage", "Invalid username or password. Please try again.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error during login", e);
        }
    }
}