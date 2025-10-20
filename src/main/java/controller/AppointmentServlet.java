package controller;

import DAO.AppointmentDAO;
import DAO.PatientMDAO;
import DAO.DentistDAO;
import DAO.ServiceDAO;
import model.Appointment;
import model.Patient;
import model.User;
import model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/receptionist/appointments")
public class AppointmentServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private PatientMDAO PatientMDAO;
    private DentistDAO dentistDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        appointmentDAO = new AppointmentDAO();
        PatientMDAO = new PatientMDAO();
        dentistDAO = new DentistDAO();
        serviceDAO = new ServiceDAO();
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
        if (!"receptionist".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "list") {
                case "list":
                    handleListAppointments(request, response);
                    break;
                case "view":
                    handleViewAppointment(request, response);
                    break;
                case "edit":
                    handleEditAppointment(request, response);
                    break;
                case "new":
                    handleNewAppointment(request, response);
                    break;
                case "calendar":
                    handleCalendarView(request, response);
                    break;
                default:
                    handleListAppointments(request, response);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            handleListAppointments(request, response);
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
        if (!"receptionist".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "create") {
                case "create":
                    handleCreateAppointment(request, response);
                    break;
                case "update":
                    handleUpdateAppointment(request, response);
                    break;
                case "update_status":
                    handleUpdateStatus(request, response);
                    break;
                case "confirm":
                    handleConfirmAppointment(request, response);
                    break;
                case "cancel":
                    handleCancelAppointment(request, response);
                    break;
                default:
                    request.setAttribute("errorMessage", "Invalid action");
                    handleListAppointments(request, response);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/appointments.jsp").forward(request, response);
        }
    }

    private void handleListAppointments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String dateParam = request.getParameter("date");
        String dentistIdParam = request.getParameter("dentistId");
        
        LocalDate date = LocalDate.now();
        if (dateParam != null && !dateParam.trim().isEmpty()) {
            try {
                date = LocalDate.parse(dateParam);
            } catch (DateTimeParseException e) {
                // Use current date if parsing fails
                date = LocalDate.now();
            }
        }
        
        List<Appointment> appointments;
        if (dentistIdParam != null && !dentistIdParam.trim().isEmpty()) {
            try {
                int dentistId = Integer.parseInt(dentistIdParam);
                appointments = appointmentDAO.getAppointmentsByDateAndDentist(java.sql.Date.valueOf(date), dentistId);
            } catch (NumberFormatException e) {
                appointments = appointmentDAO.getAppointmentsByDate(java.sql.Date.valueOf(date));
            }
        } else {
            appointments = appointmentDAO.getAppointmentsByDate(java.sql.Date.valueOf(date));
        }
        
        // Load data for dropdowns
        List<User> dentists = dentistDAO.getAllActiveDentists();
        List<Service> services = serviceDAO.getAllActiveServices();
        
        request.setAttribute("appointments", appointments);
        request.setAttribute("dentists", dentists);
        request.setAttribute("services", services);
        request.setAttribute("selectedDate", date);
        request.setAttribute("selectedDentistId", dentistIdParam);
        
        request.getRequestDispatcher("/receptionist/appointments.jsp").forward(request, response);
    }

    private void handleViewAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String appointmentIdParam = request.getParameter("id");
        if (appointmentIdParam == null || appointmentIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "Appointment ID is required");
            handleListAppointments(request, response);
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(appointmentIdParam);
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            
            if (appointment == null) {
                request.setAttribute("errorMessage", "Appointment not found");
                handleListAppointments(request, response);
                return;
            }
            
            request.setAttribute("appointment", appointment);
            request.getRequestDispatcher("/receptionist/appointment-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid appointment ID");
            handleListAppointments(request, response);
        }
    }

    private void handleEditAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String appointmentIdParam = request.getParameter("id");
        if (appointmentIdParam == null || appointmentIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "Appointment ID is required");
            handleListAppointments(request, response);
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(appointmentIdParam);
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            
            if (appointment == null) {
                request.setAttribute("errorMessage", "Appointment not found");
                handleListAppointments(request, response);
                return;
            }
            
            // Load required data for the form
            List<Patient> patients = PatientMDAO.getAllPatients(0, 1000); // Get all patients for dropdown
            List<User> dentists = dentistDAO.getAllActiveDentists();
            List<Service> services = serviceDAO.getAllActiveServices();
            
            request.setAttribute("appointment", appointment);
            request.setAttribute("patients", patients);
            request.setAttribute("dentists", dentists);
            request.setAttribute("services", services);
            request.setAttribute("action", "update");
            request.getRequestDispatcher("/receptionist/create-appointment.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid appointment ID");
            handleListAppointments(request, response);
        }
    }

    private void handleNewAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Load required data for the form
        List<Patient> patients = PatientMDAO.getAllPatients(0, 1000); // Get all patients for dropdown
        List<User> dentists = dentistDAO.getAllActiveDentists();
        List<Service> services = serviceDAO.getAllActiveServices();
        
        // Check if patientId parameter is provided (for quick appointment creation)
        String patientIdParam = request.getParameter("patientId");
        if (patientIdParam != null && !patientIdParam.trim().isEmpty()) {
            try {
                int patientId = Integer.parseInt(patientIdParam);
                Patient selectedPatient = PatientMDAO.getPatientById(patientId);
                request.setAttribute("selectedPatient", selectedPatient);
            } catch (NumberFormatException e) {
                // Ignore invalid patient ID
            }
        }
        
        request.setAttribute("patients", patients);
        request.setAttribute("dentists", dentists);
        request.setAttribute("services", services);
        request.setAttribute("action", "create");
        request.getRequestDispatcher("/receptionist/create-appointment.jsp").forward(request, response);
    }

    private void handleCalendarView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        handleListAppointments(request, response);
    }

    private void handleCreateAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get form parameters
        String patientIdParam = request.getParameter("patientId");
        String dentistIdParam = request.getParameter("dentistId");
        String serviceIdParam = request.getParameter("serviceId");
        String appointmentDateTimeStr = request.getParameter("appointmentDateTime");
        String notes = request.getParameter("notes");
        
        // Validate required fields
        if (patientIdParam == null || patientIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Patient is required");
            handleNewAppointment(request, response);
            return;
        }
        
        if (dentistIdParam == null || dentistIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Dentist is required");
            handleNewAppointment(request, response);
            return;
        }
        
        if (serviceIdParam == null || serviceIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Service is required");
            handleNewAppointment(request, response);
            return;
        }
        
        if (appointmentDateTimeStr == null || appointmentDateTimeStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Appointment date and time is required");
            handleNewAppointment(request, response);
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdParam);
            int dentistId = Integer.parseInt(dentistIdParam);
            int serviceId = Integer.parseInt(serviceIdParam);
            
            // Handle datetime-local input format (YYYY-MM-DDTHH:MM)
            LocalDateTime appointmentDateTime;
            try {
                // First try to parse as datetime-local format
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                appointmentDateTime = LocalDateTime.parse(appointmentDateTimeStr, formatter);
            } catch (DateTimeParseException e) {
                try {
                    // Fallback to standard format with space instead of T
                    appointmentDateTime = LocalDateTime.parse(appointmentDateTimeStr.replace("T", " "));
                } catch (DateTimeParseException e2) {
                    // Last fallback to ISO format
                    appointmentDateTime = LocalDateTime.parse(appointmentDateTimeStr);
                }
            }
            
            // Get service information to calculate end time
            Service service = serviceDAO.getServiceById(serviceId);
            LocalDateTime endTime = appointmentDateTime.plusMinutes(service != null && service.getDurationMinutes() != null ? 
                service.getDurationMinutes() : 30);
            
            // Check for conflicts
            if (appointmentDAO.hasConflictingAppointment(dentistId, appointmentDateTime, endTime, null)) {
                request.setAttribute("errorMessage", "The selected time conflicts with another appointment for this dentist.");
                handleNewAppointment(request, response);
                return;
            }
            
            // Create appointment object
            Appointment appointment = new Appointment();
            appointment.setPatientId(patientId);
            appointment.setDentistId(dentistId);
            appointment.setServiceId(serviceId);
            appointment.setAppointmentDate(appointmentDateTime);
            appointment.setStatus("SCHEDULED");
            appointment.setNotes(notes != null && !notes.trim().isEmpty() ? notes.trim() : null);
            appointment.setSource("INTERNAL");
            appointment.setBookingChannel(null); // Internal appointments don't have a booking channel
            
            HttpSession session = request.getSession(false);
            if (session != null) {
                User currentUser = (User) session.getAttribute("user");
                if (currentUser != null) {
                    appointment.setCreatedByUserId(currentUser.getUserId());
                }
            }
            
            // Create appointment in database
            int appointmentId = appointmentDAO.createAppointment(appointment);
            
            if (appointmentId > 0) {
                request.setAttribute("successMessage", "Appointment created successfully with ID: " + appointmentId);
                response.sendRedirect(request.getContextPath() + "/receptionist/appointments?action=list");
            } else {
                request.setAttribute("errorMessage", "Failed to create appointment. Please try again.");
                handleNewAppointment(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid patient, dentist, or service ID");
            handleNewAppointment(request, response);
        } catch (DateTimeParseException e) {
            request.setAttribute("errorMessage", "Invalid date and time format");
            handleNewAppointment(request, response);
        }
    }

    private void handleUpdateAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String appointmentIdParam = request.getParameter("appointmentId");
        if (appointmentIdParam == null || appointmentIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Appointment ID is required");
            handleListAppointments(request, response);
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(appointmentIdParam);
            
            // Check if appointment exists
            Appointment existingAppointment = appointmentDAO.getAppointmentById(appointmentId);
            if (existingAppointment == null) {
                request.setAttribute("errorMessage", "Appointment not found");
                handleListAppointments(request, response);
                return;
            }
            
            // Get form parameters
            String patientIdParam = request.getParameter("patientId");
            String dentistIdParam = request.getParameter("dentistId");
            String serviceIdParam = request.getParameter("serviceId");
            String appointmentDateTimeStr = request.getParameter("appointmentDateTime");
            String notes = request.getParameter("notes");
            
            // Validate required fields
            if (patientIdParam == null || patientIdParam.trim().isEmpty() ||
                dentistIdParam == null || dentistIdParam.trim().isEmpty() ||
                serviceIdParam == null || serviceIdParam.trim().isEmpty() ||
                appointmentDateTimeStr == null || appointmentDateTimeStr.trim().isEmpty()) {
                
                request.setAttribute("errorMessage", "All required fields must be filled");
                
                // Load required data for the form
                List<Patient> patients = PatientMDAO.getAllPatients(0, 1000);
                List<User> dentists = dentistDAO.getAllActiveDentists();
                List<Service> services = serviceDAO.getAllActiveServices();
                
                request.setAttribute("appointment", existingAppointment);
                request.setAttribute("patients", patients);
                request.setAttribute("dentists", dentists);
                request.setAttribute("services", services);
                request.setAttribute("action", "update");
                request.getRequestDispatcher("/receptionist/create-appointment.jsp").forward(request, response);
                return;
            }
            
            int patientId = Integer.parseInt(patientIdParam);
            int dentistId = Integer.parseInt(dentistIdParam);
            int serviceId = Integer.parseInt(serviceIdParam);
            
            // Handle datetime-local input format (YYYY-MM-DDTHH:MM)
            LocalDateTime appointmentDateTime;
            try {
                // First try to parse as datetime-local format
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                appointmentDateTime = LocalDateTime.parse(appointmentDateTimeStr, formatter);
            } catch (DateTimeParseException e) {
                try {
                    // Fallback to standard format with space instead of T
                    appointmentDateTime = LocalDateTime.parse(appointmentDateTimeStr.replace("T", " "));
                } catch (DateTimeParseException e2) {
                    // Last fallback to ISO format
                    appointmentDateTime = LocalDateTime.parse(appointmentDateTimeStr);
                }
            }
            
            // Get service information to calculate end time
            Service service = serviceDAO.getServiceById(serviceId);
            LocalDateTime endTime = appointmentDateTime.plusMinutes(service != null && service.getDurationMinutes() != null ? 
                service.getDurationMinutes() : 30);
            
            // Check for conflicts (excluding current appointment)
            if (appointmentDAO.hasConflictingAppointment(dentistId, appointmentDateTime, endTime, appointmentId)) {
                request.setAttribute("errorMessage", "The selected time conflicts with another appointment for this dentist.");
                
                // Load required data for the form
                List<Patient> patients = PatientMDAO.getAllPatients(0, 1000);
                List<User> dentists = dentistDAO.getAllActiveDentists();
                List<Service> services = serviceDAO.getAllActiveServices();
                
                request.setAttribute("appointment", existingAppointment);
                request.setAttribute("patients", patients);
                request.setAttribute("dentists", dentists);
                request.setAttribute("services", services);
                request.setAttribute("action", "update");
                request.getRequestDispatcher("/receptionist/create-appointment.jsp").forward(request, response);
                return;
            }
            
            // Update appointment object
            existingAppointment.setPatientId(patientId);
            existingAppointment.setDentistId(dentistId);
            existingAppointment.setServiceId(serviceId);
            existingAppointment.setAppointmentDate(appointmentDateTime);
            existingAppointment.setNotes(notes != null && !notes.trim().isEmpty() ? notes.trim() : null);
            
            // Update appointment in database
            boolean success = appointmentDAO.updateAppointment(existingAppointment);
            
            if (success) {
                request.setAttribute("successMessage", "Appointment updated successfully");
                response.sendRedirect(request.getContextPath() + "/receptionist/appointments?action=view&id=" + appointmentId);
            } else {
                request.setAttribute("errorMessage", "Failed to update appointment. Please try again.");
                
                // Load required data for the form
                List<Patient> patients = PatientMDAO.getAllPatients(0, 1000);
                List<User> dentists = dentistDAO.getAllActiveDentists();
                List<Service> services = serviceDAO.getAllActiveServices();
                
                request.setAttribute("appointment", existingAppointment);
                request.setAttribute("patients", patients);
                request.setAttribute("dentists", dentists);
                request.setAttribute("services", services);
                request.setAttribute("action", "update");
                request.getRequestDispatcher("/receptionist/create-appointment.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid appointment ID or form data");
            handleListAppointments(request, response);
        } catch (DateTimeParseException e) {
            request.setAttribute("errorMessage", "Invalid date and time format");
            
            // Load required data for the form
            Appointment existingAppointment = appointmentDAO.getAppointmentById(Integer.parseInt(appointmentIdParam));
            List<Patient> patients = PatientMDAO.getAllPatients(0, 1000);
            List<User> dentists = dentistDAO.getAllActiveDentists();
            List<Service> services = serviceDAO.getAllActiveServices();
            
            request.setAttribute("appointment", existingAppointment);
            request.setAttribute("patients", patients);
            request.setAttribute("dentists", dentists);
            request.setAttribute("services", services);
            request.setAttribute("action", "update");
            request.getRequestDispatcher("/receptionist/create-appointment.jsp").forward(request, response);
        }
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String appointmentIdParam = request.getParameter("appointmentId");
        String status = request.getParameter("status");
        
        if (appointmentIdParam == null || appointmentIdParam.trim().isEmpty() ||
            status == null || status.trim().isEmpty()) {
            
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing appointment ID or status");
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(appointmentIdParam);
            boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, status);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/receptionist/appointments?action=list");
            } else {
                request.setAttribute("errorMessage", "Failed to update appointment status");
                handleListAppointments(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid appointment ID");
        }
    }

    private void handleConfirmAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String appointmentIdParam = request.getParameter("appointmentId");
        
        if (appointmentIdParam == null || appointmentIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing appointment ID");
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(appointmentIdParam);
            
            // Generate confirmation code
            String confirmationCode = appointmentDAO.generateConfirmationCode();
            
            // Confirm appointment
            boolean success = appointmentDAO.confirmAppointment(appointmentId, confirmationCode);
            
            if (success) {
                request.setAttribute("successMessage", "Appointment confirmed successfully with code: " + confirmationCode);
            } else {
                request.setAttribute("errorMessage", "Failed to confirm appointment");
            }
            
            response.sendRedirect(request.getContextPath() + "/receptionist/appointments?action=list");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid appointment ID");
        }
    }

    private void handleCancelAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String appointmentIdParam = request.getParameter("appointmentId");
        String reason = request.getParameter("reason");
        
        if (appointmentIdParam == null || appointmentIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing appointment ID");
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(appointmentIdParam);
            
            // Cancel appointment
            boolean success = appointmentDAO.cancelAppointment(appointmentId, reason);
            
            if (success) {
                request.setAttribute("successMessage", "Appointment cancelled successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to cancel appointment");
            }
            
            response.sendRedirect(request.getContextPath() + "/receptionist/appointments?action=list");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid appointment ID");
        }
    }
}
