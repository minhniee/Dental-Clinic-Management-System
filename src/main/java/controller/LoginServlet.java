package controller;

import DAO.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            String path = getRedirectUrl(user.getRole().getRoleName());
            response.sendRedirect(request.getContextPath() + path);
            return;
        }
        
        // Forward to login page
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Validate input
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email and password are required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Authenticate user
            User user = userDAO.getUserByEmailAndPassword(email.trim(), password);
            
            if (user != null) {
                // Create session and store user
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes

                System.out.println(user.getRole());
                // Redirect based on role
                String redirectUrl = getRedirectUrl(user.getRole().getRoleName());
                response.sendRedirect(request.getContextPath() + redirectUrl);
            } else {
                request.setAttribute("errorMessage", "Invalid email or password.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    /**
     * Get redirect URL based on user role
     */
    private String getRedirectUrl(String roleName) {
        String normalized = roleName == null ? "" : roleName.toLowerCase().replaceAll("\\s+", "");
        switch (normalized) {
            case "administrator":
                System.out.println("done admin");
                return "/admin/dashboard";
            case "clinicmanager":
                return "/manager/dashboard";
            case "dentist":
                return "/dentist/dashboard";
            case "receptionist":
                return "/receptionist/dashboard";
            case "patient":
                return "/patient/dashboard.jsp";
            default:
                return "login.jsp";
        }
    }
}
