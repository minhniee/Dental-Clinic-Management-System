package controller;

import DAO.AppointmentDAO;
import DAO.PatientDAO;
import DAO.ServiceDAO;
import DAO.UserDAO;
import model.Appointment;
import model.Patient;
import model.Service;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/receptionist/appointment-management")
public class AppointmentManagementServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private PatientDAO patientDAO;
    private ServiceDAO serviceDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        appointmentDAO = new AppointmentDAO();
        patientDAO = new PatientDAO();
        serviceDAO = new ServiceDAO();
        userDAO = new UserDAO();
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

        try {
            // Get all services
            List<Service> services = serviceDAO.getAllServices();
            
            // Get all dentists
            List<User> dentists = userDAO.getUsersByRole("dentist");
            
            // Set attributes for JSP
            request.setAttribute("services", services);
            request.setAttribute("dentists", dentists);
            
            // Forward to appointment management JSP
            request.getRequestDispatcher("/receptionist/appointment-management.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error loading appointment management: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/appointment-management.jsp").forward(request, response);
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
            switch (action) {
                case "searchPatient":
                    searchPatient(request, response);
                    break;
                case "createAppointment":
                    createAppointment(request, response);
                    break;
                case "confirmAppointment":
                    confirmAppointment(request, response);
                    break;
                case "cancelAppointment":
                    cancelAppointment(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/receptionist/appointment-management");
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/appointment-management.jsp").forward(request, response);
        }
    }

    private void searchPatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        
        Patient patient = null;
        
        if (phone != null && !phone.trim().isEmpty()) {
            patient = patientDAO.getPatientByPhone(phone.trim());
        } else if (email != null && !email.trim().isEmpty()) {
            patient = patientDAO.getPatientByEmail(email.trim());
        }
        
        if (patient != null) {
            // Patient found - return patient data as JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"found\": true,");
            json.append("\"patientId\": ").append(patient.getPatientId()).append(",");
            json.append("\"fullName\": \"").append(patient.getFullName() != null ? patient.getFullName() : "").append("\",");
            json.append("\"phone\": \"").append(patient.getPhone() != null ? patient.getPhone() : "").append("\",");
            json.append("\"email\": \"").append(patient.getEmail() != null ? patient.getEmail() : "").append("\",");
            json.append("\"address\": \"").append(patient.getAddress() != null ? patient.getAddress() : "").append("\",");
            json.append("\"gender\": \"").append(patient.getGender() != null ? patient.getGender() : "").append("\",");
            json.append("\"birthDate\": \"").append(patient.getBirthDate() != null ? patient.getBirthDate().toString() : "").append("\"");
            json.append("}");
            
            response.getWriter().write(json.toString());
        } else {
            // Patient not found
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"found\": false}");
        }
    }

    private void createAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get form parameters
            String patientIdStr = request.getParameter("patientId");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String gender = request.getParameter("gender");
            String birthDateStr = request.getParameter("birthDate");
            String dentistIdStr = request.getParameter("dentistId");
            String serviceIdStr = request.getParameter("serviceId");
            String appointmentDateStr = request.getParameter("appointmentDate");
            String notes = request.getParameter("notes");
            
            // Validate required fields
            if (dentistIdStr == null || serviceIdStr == null || appointmentDateStr == null) {
                request.setAttribute("errorMessage", "Missing required fields");
                doGet(request, response);
                return;
            }
            
            int dentistId = Integer.parseInt(dentistIdStr);
            int serviceId = Integer.parseInt(serviceIdStr);
            LocalDateTime appointmentDate = LocalDateTime.parse(appointmentDateStr);
            
            // Handle patient - create new or use existing
            Patient patient;
            if (patientIdStr != null && !patientIdStr.isEmpty()) {
                // Use existing patient
                patient = patientDAO.getPatientById(Integer.parseInt(patientIdStr));
                if (patient == null) {
                    request.setAttribute("errorMessage", "Patient not found");
                    doGet(request, response);
                    return;
                }
            } else {
                // Create new patient
                patient = new Patient();
                patient.setFullName(fullName);
                patient.setPhone(phone);
                patient.setEmail(email);
                patient.setAddress(address);
                patient.setGender(gender);
                if (birthDateStr != null && !birthDateStr.isEmpty()) {
                    patient.setBirthDate(LocalDateTime.parse(birthDateStr + "T00:00:00").toLocalDate());
                }
                patient.setCreatedAt(LocalDateTime.now());
                
                if (!patientDAO.createPatient(patient)) {
                    request.setAttribute("errorMessage", "Failed to create patient");
                    doGet(request, response);
                    return;
                }
            }
            
            // Check for conflicting appointments
            Service service = serviceDAO.getServiceById(serviceId);
            int durationMinutes = service != null && service.getDurationMinutes() != null ? 
                service.getDurationMinutes() : 30;
            LocalDateTime endTime = appointmentDate.plusMinutes(durationMinutes);
            
            if (appointmentDAO.hasConflictingAppointment(dentistId, appointmentDate, endTime, null)) {
                request.setAttribute("errorMessage", "Dentist has a conflicting appointment at this time");
                doGet(request, response);
                return;
            }
            
            // Create appointment
            Appointment appointment = new Appointment();
            appointment.setPatientId(patient.getPatientId());
            appointment.setDentistId(dentistId);
            appointment.setServiceId(serviceId);
            appointment.setAppointmentDate(appointmentDate);
            appointment.setStatus("SCHEDULED");
            appointment.setNotes(notes);
            appointment.setCreatedAt(LocalDateTime.now());
            appointment.setSource("OFFLINE");
            appointment.setBookingChannel("RECEPTION");
            appointment.setCreatedByUserId(((User) request.getSession().getAttribute("user")).getUserId());
            
            int appointmentId = appointmentDAO.createAppointment(appointment);
            
            if (appointmentId > 0) {
                request.setAttribute("successMessage", "Appointment created successfully with ID: " + appointmentId);
            } else {
                request.setAttribute("errorMessage", "Failed to create appointment");
            }
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error creating appointment: " + e.getMessage());
        }
        
        doGet(request, response);
    }

    private void confirmAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String appointmentIdStr = request.getParameter("appointmentId");
        
        if (appointmentIdStr != null && !appointmentIdStr.isEmpty()) {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            if (appointmentDAO.updateAppointmentStatus(appointmentId, "CONFIRMED")) {
                request.setAttribute("successMessage", "Appointment confirmed successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to confirm appointment");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid appointment ID");
        }
        
        doGet(request, response);
    }

    private void cancelAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String appointmentIdStr = request.getParameter("appointmentId");
        
        if (appointmentIdStr != null && !appointmentIdStr.isEmpty()) {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            if (appointmentDAO.updateAppointmentStatus(appointmentId, "CANCELLED")) {
                request.setAttribute("successMessage", "Appointment cancelled successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to cancel appointment");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid appointment ID");
        }
        
        doGet(request, response);
    }
}
