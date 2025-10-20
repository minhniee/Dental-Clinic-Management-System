package controller;

import DAO.PatientMDAO;
import DAO.UserDAO;
import DAO.InvoiceDAO;
import model.Patient;
import model.User;
import model.Invoice;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet("/receptionist/patients")
public class PatientServlet extends HttpServlet {

    private PatientMDAO PatientMDAO;
    private UserDAO userDAO;
    private InvoiceDAO invoiceDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        PatientMDAO = new PatientMDAO();
        userDAO = new UserDAO();
        invoiceDAO = new InvoiceDAO();
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
                    handleListPatients(request, response);
                    break;
                case "view":
                    handleViewPatient(request, response);
                    break;
                case "edit":
                    handleEditPatient(request, response);
                    break;
                case "new":
                    handleNewPatient(request, response);
                    break;
                case "search":
                    handleSearchPatients(request, response);
                    break;
                case "quick_appointment":
                    handleQuickAppointment(request, response);
                    break;
                default:
                    handleListPatients(request, response);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            handleListPatients(request, response);
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
                    handleCreatePatient(request, response);
                    break;
                case "update":
                    handleUpdatePatient(request, response);
                    break;
                default:
                    request.setAttribute("errorMessage", "Invalid action");
                    handleListPatients(request, response);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/patients.jsp").forward(request, response);
        }
    }

    private void handleListPatients(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get pagination parameters
        String pageParam = request.getParameter("page");
        String searchParam = request.getParameter("search");
        
        int page = 1;
        int pageSize = 10;
        
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        int offset = (page - 1) * pageSize;
        
        List<Patient> patients;
        int totalCount;
        
        if (searchParam != null && !searchParam.trim().isEmpty()) {
            patients = PatientMDAO.searchPatients(searchParam.trim());
            totalCount = patients.size();
        } else {
            patients = PatientMDAO.getAllPatients(offset, pageSize);
            totalCount = PatientMDAO.getTotalPatientCount();
        }
        
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        
        request.setAttribute("patients", patients);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("searchTerm", searchParam);
        
        request.getRequestDispatcher("/receptionist/patients.jsp").forward(request, response);
    }

    private void handleViewPatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String patientIdParam = request.getParameter("id");
        if (patientIdParam == null || patientIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "Patient ID is required");
            handleListPatients(request, response);
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdParam);
            Patient patient = PatientMDAO.getPatientById(patientId);
            
            if (patient == null) {
                request.setAttribute("errorMessage", "Patient not found");
                handleListPatients(request, response);
                return;
            }
            
            // Load patient's invoice history
            List<Invoice> patientInvoices = invoiceDAO.getInvoicesByPatient(patientId);
            
            request.setAttribute("patient", patient);
            request.setAttribute("patientInvoices", patientInvoices);
            request.getRequestDispatcher("/receptionist/patient-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid patient ID");
            handleListPatients(request, response);
        }
    }

    private void handleEditPatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String patientIdParam = request.getParameter("id");
        if (patientIdParam == null || patientIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "Patient ID is required");
            handleListPatients(request, response);
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdParam);
            Patient patient = PatientMDAO.getPatientById(patientId);
            
            if (patient == null) {
                request.setAttribute("errorMessage", "Patient not found");
                handleListPatients(request, response);
                return;
            }
            
            request.setAttribute("patient", patient);
            request.setAttribute("action", "update");
            request.getRequestDispatcher("/receptionist/register-patient.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid patient ID");
            handleListPatients(request, response);
        }
    }

    private void handleNewPatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if we're searching for existing patient
        String phone = request.getParameter("phone");
        String searchAction = request.getParameter("searchAction");
        
        if ("search".equals(searchAction) && phone != null && !phone.trim().isEmpty()) {
            // Search for existing patient by phone
            Patient existingPatient = PatientMDAO.getPatientByPhone(phone.trim());
            if (existingPatient != null) {
                request.setAttribute("existingPatient", existingPatient);
                request.setAttribute("searchPhone", phone.trim());
                request.setAttribute("showExistingPatient", true);
            } else {
                request.setAttribute("noPatientFound", true);
                request.setAttribute("searchPhone", phone.trim());
            }
        }
        
        request.setAttribute("action", "create");
        request.getRequestDispatcher("/receptionist/register-patient.jsp").forward(request, response);
    }

    private void handleSearchPatients(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        handleListPatients(request, response);
    }

    private void handleQuickAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String patientIdParam = request.getParameter("patientId");
        if (patientIdParam == null || patientIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "Patient ID is required");
            handleNewPatient(request, response);
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdParam);
            Patient patient = PatientMDAO.getPatientById(patientId);
            
            if (patient == null) {
                request.setAttribute("errorMessage", "Patient not found");
                handleNewPatient(request, response);
                return;
            }
            
            // Redirect to appointment creation with pre-selected patient
            response.sendRedirect(request.getContextPath() + "/receptionist/appointments?action=new&patientId=" + patientId);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid patient ID");
            handleNewPatient(request, response);
        }
    }

    private void handleCreatePatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get form parameters
        String fullName = request.getParameter("fullName");
        String birthDateStr = request.getParameter("birthDate");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        
        // Validate required fields
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Full name is required");
            handleNewPatient(request, response);
            return;
        }
        
        if (phone == null || phone.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Phone number is required");
            handleNewPatient(request, response);
            return;
        }
        
        // Check if phone already exists
        Patient existingPatient = PatientMDAO.getPatientByPhone(phone.trim());
        if (existingPatient != null) {
            request.setAttribute("errorMessage", "A patient with this phone number already exists");
            handleNewPatient(request, response);
            return;
        }
        
        // Parse birth date
        LocalDate birthDate = null;
        if (birthDateStr != null && !birthDateStr.trim().isEmpty()) {
            try {
                birthDate = LocalDate.parse(birthDateStr);
            } catch (DateTimeParseException e) {
                request.setAttribute("errorMessage", "Invalid birth date format");
                handleNewPatient(request, response);
                return;
            }
        }
        
        // Create patient object
        Patient patient = new Patient();
        patient.setFullName(fullName.trim());
        patient.setBirthDate(birthDate);
        patient.setGender(gender != null && !gender.isEmpty() ? gender : null);
        patient.setPhone(phone.trim());
        patient.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);
        patient.setAddress(address != null && !address.trim().isEmpty() ? address.trim() : null);
        
        // Create patient in database
        int patientId = PatientMDAO.createPatient(patient);
        
        if (patientId > 0) {
            request.setAttribute("successMessage", "Patient registered successfully with ID: " + patientId);
            // Redirect to patient list
            response.sendRedirect(request.getContextPath() + "/receptionist/patients?action=list");
        } else {
            // Check for specific duplicate issues
            if (phone != null && !phone.trim().isEmpty()) {
                Patient existingByPhone = PatientMDAO.getPatientByPhone(phone.trim());
                if (existingByPhone != null) {
                    request.setAttribute("errorMessage", "A patient with phone number '" + phone + "' already exists.");
                    handleNewPatient(request, response);
                    return;
                }
            }
            
            if (email != null && !email.trim().isEmpty()) {
                Patient existingByEmail = PatientMDAO.getPatientByEmail(email.trim());
                if (existingByEmail != null) {
                    request.setAttribute("errorMessage", "A patient with email '" + email + "' already exists.");
                    handleNewPatient(request, response);
                    return;
                }
            }
            
            request.setAttribute("errorMessage", "Failed to create patient. Please check all fields and try again.");
            handleNewPatient(request, response);
        }
    }

    private void handleUpdatePatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String patientIdParam = request.getParameter("patientId");
        if (patientIdParam == null || patientIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "Patient ID is required");
            handleListPatients(request, response);
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdParam);
            
            // Check if patient exists
            Patient existingPatient = PatientMDAO.getPatientById(patientId);
            if (existingPatient == null) {
                request.setAttribute("errorMessage", "Patient not found");
                handleListPatients(request, response);
                return;
            }
            
            // Get form parameters
            String fullName = request.getParameter("fullName");
            String birthDateStr = request.getParameter("birthDate");
            String gender = request.getParameter("gender");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            
            // Validate required fields
            if (fullName == null || fullName.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Full name is required");
                request.setAttribute("patient", existingPatient);
                request.setAttribute("action", "update");
                request.getRequestDispatcher("/receptionist/register-patient.jsp").forward(request, response);
                return;
            }
            
            if (phone == null || phone.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Phone number is required");
                request.setAttribute("patient", existingPatient);
                request.setAttribute("action", "update");
                request.getRequestDispatcher("/receptionist/register-patient.jsp").forward(request, response);
                return;
            }
            
            // Check if phone already exists for another patient
            Patient patientWithSamePhone = PatientMDAO.getPatientByPhone(phone.trim());
            if (patientWithSamePhone != null && patientWithSamePhone.getPatientId() != patientId) {
                request.setAttribute("errorMessage", "Another patient with this phone number already exists");
                request.setAttribute("patient", existingPatient);
                request.setAttribute("action", "update");
                request.getRequestDispatcher("/receptionist/register-patient.jsp").forward(request, response);
                return;
            }
            
            // Parse birth date
            LocalDate birthDate = null;
            if (birthDateStr != null && !birthDateStr.trim().isEmpty()) {
                try {
                    birthDate = LocalDate.parse(birthDateStr);
                } catch (DateTimeParseException e) {
                    request.setAttribute("errorMessage", "Invalid birth date format");
                    request.setAttribute("patient", existingPatient);
                    request.setAttribute("action", "update");
                    request.getRequestDispatcher("/receptionist/register-patient.jsp").forward(request, response);
                    return;
                }
            }
            
            // Update patient object
            existingPatient.setFullName(fullName.trim());
            existingPatient.setBirthDate(birthDate);
            existingPatient.setGender(gender != null && !gender.isEmpty() ? gender : null);
            existingPatient.setPhone(phone.trim());
            existingPatient.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);
            existingPatient.setAddress(address != null && !address.trim().isEmpty() ? address.trim() : null);
            
            // Update patient in database
            boolean success = PatientMDAO.updatePatient(existingPatient);
            
            if (success) {
                request.setAttribute("successMessage", "Patient updated successfully");
                response.sendRedirect(request.getContextPath() + "/receptionist/patients?action=view&id=" + patientId);
            } else {
                request.setAttribute("errorMessage", "Failed to update patient. Please try again.");
                request.setAttribute("patient", existingPatient);
                request.setAttribute("action", "update");
                request.getRequestDispatcher("/receptionist/register-patient.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid patient ID");
            handleListPatients(request, response);
        }
    }
}
