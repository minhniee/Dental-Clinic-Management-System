package controller;

import DAO.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Forward to forgot password page
        request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        
        // Validate input
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email is required.");
            request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
            return;
        }
        
        try {
            // Check if email exists
            if (!userDAO.emailExists(email.trim())) {
                request.setAttribute("errorMessage", "Email not found in our system.");
                request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
                return;
            }
            
            // Generate new temporary password
            String newPassword = generateTemporaryPassword();
            
            // Update password in database
            boolean success = userDAO.updatePasswordByEmail(email.trim(), newPassword);
            
            if (success) {
                request.setAttribute("successMessage", 
                    "Password has been reset successfully. Your new temporary password is: " + newPassword + 
                    "<br>Please change it after logging in.");
                request.setAttribute("email", email.trim());
            } else {
                request.setAttribute("errorMessage", "Failed to reset password. Please try again.");
            }
            
            request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
        }
    }
    
    /**
     * Generate a temporary password
     */
    private String generateTemporaryPassword() {
        // Generate a simple temporary password
        String uuid = UUID.randomUUID().toString().replace("-", "");
        return "temp" + uuid.substring(0, 8);
    }
}
