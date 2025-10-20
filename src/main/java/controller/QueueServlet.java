package controller;

import DAO.WaitingQueueDAO;
import DAO.AppointmentDAO;
import DAO.InvoiceDAO;
import model.WaitingQueue;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/receptionist/queue")
public class QueueServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(QueueServlet.class.getName());
    private WaitingQueueDAO waitingQueueDAO;
    private AppointmentDAO appointmentDAO;
    private InvoiceDAO invoiceDAO;
    private InvoiceDAO invoiceDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        waitingQueueDAO = new WaitingQueueDAO();
        appointmentDAO = new AppointmentDAO();
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

        model.User currentUser = (model.User) session.getAttribute("user");
        if (!"receptionist".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "list") {
                case "list":
                    handleQueueList(request, response);
                    break;
                case "checkin":
                    handleCheckInView(request, response);
                    break;
                default:
                    handleQueueList(request, response);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            handleQueueList(request, response);
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

        model.User currentUser = (model.User) session.getAttribute("user");
        if (!"receptionist".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "checkin") {
                case "checkin":
                    handleCheckIn(request, response);
                    break;
                case "update_status":
                    handleUpdateStatus(request, response);
                    break;
                case "remove_from_queue":
                    handleRemoveFromQueue(request, response);
                    break;
                default:
                    request.setAttribute("errorMessage", "Invalid action");
                    handleQueueList(request, response);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            handleQueueList(request, response);
        }
    }

    private void handleQueueList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get current queue
            List<WaitingQueue> currentQueue = waitingQueueDAO.getCurrentQueue();
            
            // Get queue statistics
            WaitingQueueDAO.QueueStatistics queueStats = waitingQueueDAO.getQueueStatistics();
            
            request.setAttribute("currentQueue", currentQueue);
            request.setAttribute("queueStats", queueStats);
            
            request.getRequestDispatcher("/receptionist/queue.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error loading queue: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/queue.jsp").forward(request, response);
        }
    }

    private void handleCheckInView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get today's appointments that are not yet in queue
            List<model.Appointment> todayAppointments = appointmentDAO.getAppointmentsByDate(new java.sql.Date(System.currentTimeMillis()));
            
            request.setAttribute("todayAppointments", todayAppointments);
            request.getRequestDispatcher("/receptionist/check-in.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error loading check-in page: " + e.getMessage());
            handleQueueList(request, response);
        }
    }

    private void handleCheckIn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String appointmentIdParam = request.getParameter("appointmentId");
        
        if (appointmentIdParam == null || appointmentIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Appointment ID is required");
            handleCheckInView(request, response);
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(appointmentIdParam);
            
            // Check if already in queue
            if (waitingQueueDAO.isInQueue(appointmentId)) {
                request.setAttribute("errorMessage", "This appointment is already in the queue");
                handleCheckInView(request, response);
                return;
            }
            
            // Add to queue
            int queueId = waitingQueueDAO.addToQueue(appointmentId);
            
            if (queueId > 0) {
                request.setAttribute("successMessage", "Patient checked in successfully to queue position " + waitingQueueDAO.getQueueEntryByAppointmentId(appointmentId).getPositionInQueue());
            } else {
                request.setAttribute("errorMessage", "Failed to check in patient. Please try again.");
            }
            
            // Redirect back to queue list
            response.sendRedirect(request.getContextPath() + "/receptionist/queue?action=list");
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid appointment ID");
            handleCheckInView(request, response);
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
            
            boolean success = waitingQueueDAO.updateQueueStatus(appointmentId, status);
            
            if (success) {
                // Update appointment status based on queue status
                updateAppointmentStatusFromQueue(appointmentId, status);
                request.setAttribute("successMessage", "Queue status updated successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to update queue status");
            }
            
            response.sendRedirect(request.getContextPath() + "/receptionist/queue?action=list");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid appointment ID");
        }
    }

    private void updateAppointmentStatusFromQueue(int appointmentId, String queueStatus) {
        String appointmentStatus = null;
        
        switch (queueStatus) {
            case "CHECKED_IN":
                appointmentStatus = "CONFIRMED";
                break;
            case "CALLED":
                appointmentStatus = "CONFIRMED";
                break;
            case "IN_TREATMENT":
                appointmentStatus = "IN_PROGRESS";
                break;
            case "COMPLETED":
                appointmentStatus = "COMPLETED";
                break;
            case "NO_SHOW":
                appointmentStatus = "NO_SHOW";
                break;
        }
        
        if (appointmentStatus != null) {
            appointmentDAO.updateAppointmentStatus(appointmentId, appointmentStatus);
            
            // Auto-generate invoice when appointment is completed
            if ("COMPLETED".equals(appointmentStatus)) {
                int invoiceId = invoiceDAO.autoGenerateInvoiceForAppointment(appointmentId);
                if (invoiceId > 0) {
                    logger.info("Auto-generated invoice " + invoiceId + " for completed appointment " + appointmentId);
                }
            }
        }
    }

    private void handleRemoveFromQueue(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String appointmentIdParam = request.getParameter("appointmentId");
        
        if (appointmentIdParam == null || appointmentIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing appointment ID");
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(appointmentIdParam);
            
            boolean success = waitingQueueDAO.removeFromQueue(appointmentId);
            
            if (success) {
                request.setAttribute("successMessage", "Patient removed from queue successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to remove patient from queue");
            }
            
            response.sendRedirect(request.getContextPath() + "/receptionist/queue?action=list");
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid appointment ID");
        }
    }
}
