package controller;

import DAO.AppointmentDAO;
import DAO.WaitingQueueDAO;
import DAO.PatientDAO;
import model.Appointment;
import model.WaitingQueue;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@WebServlet("/receptionist/check-in")
public class CheckInServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private WaitingQueueDAO waitingQueueDAO;
    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        appointmentDAO = new AppointmentDAO();
        waitingQueueDAO = new WaitingQueueDAO();
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
        if (!"receptionist".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "list") {
                case "list":
                    handleListCheckIns(request, response);
                    break;
                case "search":
                    handleSearchPatient(request, response);
                    break;
                default:
                    handleListCheckIns(request, response);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/check-in.jsp").forward(request, response);
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
            switch (action != null ? action : "check_in") {
                case "check_in":
                    handleCheckIn(request, response);
                    break;
                case "update_queue_status":
                    handleUpdateQueueStatus(request, response);
                    break;
                default:
                    request.setAttribute("errorMessage", "Invalid action");
                    handleListCheckIns(request, response);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/check-in.jsp").forward(request, response);
        }
    }

    private void handleListCheckIns(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get today's appointments
            LocalDate today = LocalDate.now();
            Date todaySqlDate = Date.valueOf(today);
            
            List<Appointment> todayAppointments = appointmentDAO.getAppointmentsByDate(todaySqlDate);
            
            // Get current queue
            List<WaitingQueue> currentQueue = waitingQueueDAO.getCurrentQueue();
            
            request.setAttribute("appointments", todayAppointments);
            request.setAttribute("currentQueue", currentQueue);
            request.setAttribute("today", todaySqlDate);
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error loading check-in data: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/receptionist/check-in.jsp").forward(request, response);
    }

    private void handleSearchPatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String searchTerm = request.getParameter("search");
        
        try {
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                List<model.Patient> patients = patientDAO.searchPatients(searchTerm);
                request.setAttribute("searchResults", patients);
                request.setAttribute("searchTerm", searchTerm);
            }
            
            // Also get today's appointments and queue
            LocalDate today = LocalDate.now();
            Date todaySqlDate = Date.valueOf(today);
            
            List<Appointment> todayAppointments = appointmentDAO.getAppointmentsByDate(todaySqlDate);
            List<WaitingQueue> currentQueue = waitingQueueDAO.getCurrentQueue();
            
            request.setAttribute("appointments", todayAppointments);
            request.setAttribute("currentQueue", currentQueue);
            request.setAttribute("today", todaySqlDate);
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error searching patients: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/receptionist/check-in.jsp").forward(request, response);
    }

    private void handleCheckIn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            
            // Get the appointment
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            if (appointment == null) {
                request.setAttribute("errorMessage", "Appointment not found");
                handleListCheckIns(request, response);
                return;
            }
            
            // Check if already in queue
            if (waitingQueueDAO.isInQueue(appointmentId)) {
                request.setAttribute("errorMessage", "Patient is already checked in");
                handleListCheckIns(request, response);
                return;
            }
            
            // Add to queue
            int queueId = waitingQueueDAO.addToQueue(appointmentId);
            
            if (queueId > 0) {
                request.setAttribute("successMessage", "Patient checked in successfully. Queue ID: #" + queueId);
            } else {
                request.setAttribute("errorMessage", "Failed to check in patient");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid appointment ID");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error during check-in: " + e.getMessage());
        }
        
        handleListCheckIns(request, response);
    }

    private void handleUpdateQueueStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String newStatus = request.getParameter("status");
            
            boolean success = waitingQueueDAO.updateQueueStatus(appointmentId, newStatus);
            
            if (success) {
                request.setAttribute("successMessage", "Queue status updated successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to update queue status");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid appointment ID");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error updating queue status: " + e.getMessage());
        }
        
        handleListCheckIns(request, response);
    }
}
