package controller;

import DAO.AppointmentRequestDAO;
import model.AppointmentRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet("/appointment-request")
public class AppointmentRequestServlet extends HttpServlet {

    private AppointmentRequestDAO appointmentRequestDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        appointmentRequestDAO = new AppointmentRequestDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get and validate form parameters
            String fullName = validateRequired(request.getParameter("fullName"), "Full name");
            String email = validateEmail(request.getParameter("email"));
            String phone = validateRequired(request.getParameter("phone"), "Phone number");
            String serviceIdStr = validateRequired(request.getParameter("serviceId"), "Service");
            String preferredDateStr = validateRequired(request.getParameter("preferredDate"), "Preferred date");
            String message = request.getParameter("message");
            String preferredDoctorIdStr = request.getParameter("preferredDoctorId");
            String preferredShift = request.getParameter("preferredShift");

            // Parse and validate service ID
            Integer serviceId;
            try {
                serviceId = Integer.parseInt(serviceIdStr);
            } catch (NumberFormatException e) {
                sendErrorResponse(request, response, "Invalid service selection.");
                return;
            }

            // Parse and validate preferred doctor ID (optional)
            Integer preferredDoctorId = null;
            if (preferredDoctorIdStr != null && !preferredDoctorIdStr.trim().isEmpty()) {
                try {
                    preferredDoctorId = Integer.parseInt(preferredDoctorIdStr);
                } catch (NumberFormatException e) {
                    sendErrorResponse(request, response, "Invalid doctor selection.");
                    return;
                }
            }

            // Parse and validate preferred date
            LocalDate preferredDate;
            try {
                preferredDate = LocalDate.parse(preferredDateStr);
                if (preferredDate.isBefore(LocalDate.now())) {
                    sendErrorResponse(request, response, "Preferred date cannot be in the past.");
                    return;
                }
            } catch (DateTimeParseException e) {
                sendErrorResponse(request, response, "Invalid date format.");
                return;
            }

            // Create appointment request object
            AppointmentRequest appointmentRequest = new AppointmentRequest();
            appointmentRequest.setFullName(fullName.trim());
            appointmentRequest.setEmail(email.trim());
            appointmentRequest.setPhone(phone.trim());
            appointmentRequest.setServiceId(serviceId);
            appointmentRequest.setPreferredDoctorId(preferredDoctorId);
            appointmentRequest.setPreferredDate(preferredDate);
            appointmentRequest.setPreferredShift(preferredShift);
            appointmentRequest.setNotes(message != null ? message.trim() : null);
            appointmentRequest.setStatus("PENDING");

            // Save to database
            boolean success = appointmentRequestDAO.createAppointmentRequest(appointmentRequest);

            if (success) {
                // Send success response
                sendSuccessResponse(request, response, 
                    "Your appointment request has been submitted successfully! " +
                    "We will contact you within 24 hours to confirm your appointment.");
            } else {
                sendErrorResponse(request, response, 
                    "Failed to submit your appointment request. Please try again.");
            }

        } catch (IllegalArgumentException e) {
            sendErrorResponse(request, response, e.getMessage());
        } catch (Exception e) {
            // Log the error
            getServletContext().log("Error processing appointment request", e);
            sendErrorResponse(request, response, 
                "An unexpected error occurred. Please try again later.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Redirect GET requests to home page
        response.sendRedirect(request.getContextPath() + "/home");
    }

    /**
     * Validate required fields
     */
    private String validateRequired(String value, String fieldName) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(fieldName + " is required.");
        }
        return value;
    }

    /**
     * Validate email format
     */
    private String validateEmail(String email) {
        email = validateRequired(email, "Email");
        if (!email.contains("@") || !email.contains(".")) {
            throw new IllegalArgumentException("Please enter a valid email address.");
        }
        return email;
    }

    /**
     * Send success response
     */
    private void sendSuccessResponse(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        
        request.setAttribute("successMessage", message);
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }

    /**
     * Send error response
     */
    private void sendErrorResponse(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        
        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}
