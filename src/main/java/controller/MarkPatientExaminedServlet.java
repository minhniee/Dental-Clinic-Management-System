package controller;

import DAO.PatientDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/patient/mark-examined")
public class MarkPatientExaminedServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(MarkPatientExaminedServlet.class.getName());
    
    private PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in and is a dentist
        if (session.getAttribute("user") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        if (!"Dentist".equals(currentUser.getRole().getRoleName())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only dentists can mark patients as examined");
            return;
        }
        
        String patientIdStr = request.getParameter("patientId");
        if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Patient ID is required");
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdStr);
            
            // Check if patient exists
            if (patientDAO.getPatientById(patientId) == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Patient not found");
                return;
            }
            
            // Mark patient as examined for today
            boolean success = patientDAO.markPatientExaminedToday(patientId, currentUser.getUserId());
            
            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Patient marked as examined successfully");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to mark patient as examined");
            }
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid patient_id format: " + patientIdStr, e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid patient ID format");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error marking patient as examined", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }
}
