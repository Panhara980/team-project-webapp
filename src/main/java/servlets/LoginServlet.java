package servlets;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Someone navigating to /login directly just sees the form.
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        boolean passwordProvided = password != null && !password.isEmpty();

        // Demo-only check, matching the hint already on the login page.
        // This is the one block to replace once MySQL is wired up.
        String displayName = null;
        String role = null;
        if (username != null) {
            if (username.trim().equalsIgnoreCase("prof.smith")) {
                displayName = "Prof. Smith";
                role = "professor";
            } else if (username.trim().equalsIgnoreCase("j.chen")) {
                displayName = "J. Chen";
                role = "student";
            }
        }

        if (displayName != null && passwordProvided) {
            // Success — store the user the same way dashboard.jsp's own
            // fallback already does: displayName and role on a session map.
            Map<String, String> user = new LinkedHashMap<>();
            user.put("displayName", displayName);
            user.put("role", role);

            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // dashboard.jsp renders fine standalone thanks to its own demo
            // fallback, so this works even before a DashboardServlet exists.
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");

        } else {
            // Failure — set the same attributes login.jsp already checks for.
            if (username == null || username.trim().isEmpty()) {
                request.setAttribute("usernameError", "Please enter a username.");
                request.setAttribute("errorMessage", "Please fill in all fields.");
            } else if (!passwordProvided) {
                request.setAttribute("errorMessage", "Please enter a password.");
            } else {
                request.setAttribute("usernameError", "No account found with that username.");
                request.setAttribute("errorMessage", "Invalid username or password. Please try again.");
            }

            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}