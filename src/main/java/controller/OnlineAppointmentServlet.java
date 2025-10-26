package controller;

import DAO.AppointmentRequestDAO;
import DAO.DentistDAO;
import DAO.ServiceDAO;
import DAO.AppointmentDAO;
import DAO.PatientDAO;
import model.AppointmentRequest;
import model.User;
import model.Service;
import model.Appointment;
import model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/receptionist/online-appointments")
public class OnlineAppointmentServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(OnlineAppointmentServlet.class.getName());
    
    private AppointmentRequestDAO appointmentRequestDAO;
    private DentistDAO dentistDAO;
    private ServiceDAO serviceDAO;
    private AppointmentDAO appointmentDAO;
    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        appointmentRequestDAO = new AppointmentRequestDAO();
        dentistDAO = new DentistDAO();
        serviceDAO = new ServiceDAO();
        appointmentDAO = new AppointmentDAO();
        patientDAO = new PatientDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check authentication and authorization
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRole() == null || 
            !"receptionist".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            handleListAppointmentRequests(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            handleListAppointmentRequests(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check authentication and authorization
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRole() == null || 
            !"receptionist".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "update_status") {
                case "update_status":
                    handleUpdateRequestStatus(request, response);
                    break;
                default:
                    request.setAttribute("errorMessage", "Invalid action");
                    handleListAppointmentRequests(request, response);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            handleListAppointmentRequests(request, response);
        }
    }

    private void handleListAppointmentRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get filter parameters
            String statusFilter = request.getParameter("status");
            
            // Handle success/error messages from redirect
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            
            if ("confirmed".equals(success)) {
                request.setAttribute("successMessage", "Appointment request confirmed and actual appointment created successfully");
            } else if ("confirmed_with_error".equals(success)) {
                request.setAttribute("successMessage", "Appointment request confirmed, but failed to create actual appointment: " + 
                    (error != null ? error : "Unknown error"));
            } else if ("updated".equals(success)) {
                request.setAttribute("successMessage", "Status updated successfully");
            } else if ("update_failed".equals(error)) {
                request.setAttribute("errorMessage", "Failed to update status");
            }
            
            List<AppointmentRequest> appointmentRequests;
            
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equals(statusFilter)) {
                appointmentRequests = appointmentRequestDAO.getAppointmentRequestsByStatus(statusFilter);
            } else {
                appointmentRequests = appointmentRequestDAO.getAllAppointmentRequests();
            }
            
            // Get available services and dentists for filtering
            List<Service> services = null;
            List<User> dentists = null;
            
            try {
                services = serviceDAO.getAllActiveServices();
            } catch (Exception e) {
                logger.log(Level.WARNING, "Error getting services", e);
                services = new ArrayList<>();
            }
            
            try {
                dentists = dentistDAO.getAllActiveDentists();
            } catch (Exception e) {
                logger.log(Level.WARNING, "Error getting dentists", e);
                dentists = new ArrayList<>();
            }
            
            if (appointmentRequests == null) {
                appointmentRequests = new ArrayList<>();
            }
            
            request.setAttribute("appointmentRequests", appointmentRequests);
            request.setAttribute("services", services);
            request.setAttribute("dentists", dentists);
            request.setAttribute("statusFilter", statusFilter);
            
            request.getRequestDispatcher("/receptionist/online-appointments.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace(); // Log the full stack trace for debugging
            request.setAttribute("errorMessage", "Error loading appointment requests: " + e.getMessage());
            try {
                request.getRequestDispatcher("/receptionist/online-appointments.jsp").forward(request, response);
            } catch (Exception ex) {
                response.getWriter().println("Error occurred: " + e.getMessage());
            }
        }
    }

    private void handleUpdateRequestStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String requestIdStr = request.getParameter("requestId");
            String newStatus = request.getParameter("status");
            
            logger.info("Update request status - requestId: " + requestIdStr + ", status: " + newStatus);
            
            if (requestIdStr == null || newStatus == null) {
                logger.warning("Missing required parameters - requestId: " + requestIdStr + ", status: " + newStatus);
                request.setAttribute("errorMessage", "Missing required parameters");
                handleListAppointmentRequests(request, response);
                return;
            }
            
            int requestId = Integer.parseInt(requestIdStr);
            
            // Get the appointment request details
            AppointmentRequest appointmentRequest = appointmentRequestDAO.getAppointmentRequestById(requestId);
            if (appointmentRequest == null) {
                logger.warning("Appointment request not found for ID: " + requestId);
                request.setAttribute("errorMessage", "Appointment request not found");
                handleListAppointmentRequests(request, response);
                return;
            }
            
            // Update the request status
            logger.info("Attempting to update request ID: " + requestId + " to status: " + newStatus);
            boolean success = appointmentRequestDAO.updateRequestStatus(requestId, newStatus);
            logger.info("Update result: " + (success ? "success" : "failed"));
            
            // Redirect back to list with filter
            String statusFilter = request.getParameter("statusFilter");
            String redirectUrl = request.getContextPath() + "/receptionist/online-appointments";
            
            // Add status parameter if filter is set
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equals("ALL")) {
                redirectUrl += "?status=" + statusFilter;
            }
            
            if (success) {
                // If confirming, create actual appointment
                if ("CONFIRMED".equals(newStatus)) {
                    try {
                        createAppointmentFromRequest(appointmentRequest, request);
                        redirectUrl += (redirectUrl.contains("?") ? "&" : "?") + "success=confirmed";
                    } catch (Exception e) {
                        logger.log(Level.WARNING, "Error creating appointment from request", e);
                        redirectUrl += (redirectUrl.contains("?") ? "&" : "?") + "success=confirmed_with_error&error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8");
                    }
                } else {
                    redirectUrl += (redirectUrl.contains("?") ? "&" : "?") + "success=updated";
                }
            } else {
                redirectUrl += (redirectUrl.contains("?") ? "&" : "?") + "error=update_failed";
            }
            
            response.sendRedirect(redirectUrl);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid request ID format");
            handleListAppointmentRequests(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error updating status: " + e.getMessage());
            handleListAppointmentRequests(request, response);
        }
    }
    
    private void createAppointmentFromRequest(AppointmentRequest request, HttpServletRequest httpRequest) throws Exception {
        // First, ensure patient exists
        Patient patient = null;
        if (request.getPatientId() != null) {
            patient = patientDAO.getPatientById(request.getPatientId());
        }
        
        // If no patient ID or patient not found, create new patient
        if (patient == null) {
            patient = new Patient();
            patient.setFullName(request.getFullName());
            patient.setPhone(request.getPhone());
            patient.setEmail(request.getEmail());
            patient.setCreatedAt(java.time.LocalDateTime.now());
            
            boolean patientCreated = patientDAO.createPatient(patient);
            if (!patientCreated) {
                throw new Exception("Failed to create patient");
            }
            // Get the created patient ID - we need to find it by phone/email
            Patient createdPatient = patientDAO.getPatientByPhone(request.getPhone());
            if (createdPatient == null) {
                throw new Exception("Failed to retrieve created patient");
            }
            patient.setPatientId(createdPatient.getPatientId());
        }
        
        // Create appointment
        Appointment appointment = new Appointment();
        appointment.setPatientId(patient.getPatientId());
        appointment.setDentistId(request.getPreferredDoctorId());
        appointment.setServiceId(request.getServiceId());
        
        // Set appointment date - use preferred date with default time
        if (request.getPreferredDate() != null) {
            // Default to 9:00 AM if no specific time mentioned
            java.time.LocalDateTime appointmentDateTime = request.getPreferredDate().atTime(9, 0);
            appointment.setAppointmentDate(appointmentDateTime);
        } else {
            // Default to tomorrow at 9:00 AM if no date specified
            appointment.setAppointmentDate(java.time.LocalDate.now().plusDays(1).atTime(9, 0));
        }
        
        appointment.setStatus("SCHEDULED");
        appointment.setNotes(request.getNotes());
        appointment.setSource("ONLINE");
        appointment.setBookingChannel("WEB");
        appointment.setCreatedByPatientId(patient.getPatientId());
        
        // Set created by user if available
        HttpSession session = httpRequest.getSession(false);
        if (session != null) {
            User currentUser = (User) session.getAttribute("user");
            if (currentUser != null) {
                appointment.setCreatedByUserId(currentUser.getUserId());
            }
        }
        
        // Create appointment in database
        int appointmentId = appointmentDAO.createAppointment(appointment);
        if (appointmentId <= 0) {
            throw new Exception("Failed to create appointment");
        }
        
        logger.info("Created appointment ID: " + appointmentId + " from request ID: " + request.getRequestId());
    }
}
