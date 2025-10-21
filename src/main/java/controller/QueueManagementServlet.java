package controller;

import DAO.AppointmentDAO;
import DAO.WaitingQueueDAO;
import model.Appointment;
import model.WaitingQueue;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/receptionist/queue-management")
public class QueueManagementServlet extends HttpServlet {

    private WaitingQueueDAO waitingQueueDAO;
    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        waitingQueueDAO = new WaitingQueueDAO();
        appointmentDAO = new AppointmentDAO();
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
            // Get today's queue
            List<WaitingQueue> todayQueue = waitingQueueDAO.getTodayQueue();
            
            // Get queue statistics
            WaitingQueueDAO.QueueStatistics stats = waitingQueueDAO.getQueueStatistics();
            
            // Set attributes for JSP
            request.setAttribute("todayQueue", todayQueue);
            request.setAttribute("queueStats", stats);
            
            // Forward to queue management JSP
            request.getRequestDispatcher("/receptionist/queue-management.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error loading queue management: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/queue-management.jsp").forward(request, response);
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
                case "addToQueue":
                    addToQueue(request, response);
                    break;
                case "updateStatus":
                    updateQueueStatus(request, response);
                    break;
                case "removeFromQueue":
                    removeFromQueue(request, response);
                    break;
                case "reorderQueue":
                    reorderQueue(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/receptionist/queue-management");
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/queue-management.jsp").forward(request, response);
        }
    }

    private void addToQueue(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String appointmentIdStr = request.getParameter("appointmentId");
            
            if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
                request.setAttribute("errorMessage", "Appointment ID is required");
                doGet(request, response);
                return;
            }
            
            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            // Check if appointment exists and is scheduled for today
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            if (appointment == null) {
                request.setAttribute("errorMessage", "Appointment not found");
                doGet(request, response);
                return;
            }
            
            // Check if appointment is already in queue
            WaitingQueue existingQueue = waitingQueueDAO.getQueueByAppointmentId(appointmentId);
            if (existingQueue != null) {
                request.setAttribute("errorMessage", "Appointment is already in queue");
                doGet(request, response);
                return;
            }
            
            // Add to queue
            WaitingQueue queue = new WaitingQueue();
            queue.setAppointmentId(appointmentId);
            queue.setStatus("WAITING");
            
            // Get next position in queue
            int nextPosition = waitingQueueDAO.getNextQueuePosition();
            queue.setPositionInQueue(nextPosition);
            
            if (waitingQueueDAO.createQueueEntry(queue)) {
                request.setAttribute("successMessage", "Patient added to queue successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to add patient to queue");
            }
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error adding to queue: " + e.getMessage());
        }
        
        doGet(request, response);
    }

    private void updateQueueStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String queueIdStr = request.getParameter("queueId");
            String status = request.getParameter("status");
            
            if (queueIdStr == null || status == null) {
                request.setAttribute("errorMessage", "Queue ID and status are required");
                doGet(request, response);
                return;
            }
            
            int queueId = Integer.parseInt(queueIdStr);
            
            if (waitingQueueDAO.updateQueueStatus(queueId, status)) {
                // If status is COMPLETED, also update appointment status
                if ("COMPLETED".equals(status)) {
                    WaitingQueue queue = waitingQueueDAO.getQueueById(queueId);
                    if (queue != null) {
                        appointmentDAO.updateAppointmentStatus(queue.getAppointmentId(), "COMPLETED");
                    }
                }
                
                request.setAttribute("successMessage", "Queue status updated successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to update queue status");
            }
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error updating queue status: " + e.getMessage());
        }
        
        doGet(request, response);
    }

    private void removeFromQueue(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String queueIdStr = request.getParameter("queueId");
            
            if (queueIdStr == null || queueIdStr.isEmpty()) {
                request.setAttribute("errorMessage", "Queue ID is required");
                doGet(request, response);
                return;
            }
            
            int queueId = Integer.parseInt(queueIdStr);
            
            if (waitingQueueDAO.removeFromQueue(queueId)) {
                request.setAttribute("successMessage", "Patient removed from queue successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to remove patient from queue");
            }
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error removing from queue: " + e.getMessage());
        }
        
        doGet(request, response);
    }

    private void reorderQueue(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String queueIdStr = request.getParameter("queueId");
            String newPositionStr = request.getParameter("newPosition");
            
            if (queueIdStr == null || newPositionStr == null) {
                request.setAttribute("errorMessage", "Queue ID and new position are required");
                doGet(request, response);
                return;
            }
            
            int queueId = Integer.parseInt(queueIdStr);
            int newPosition = Integer.parseInt(newPositionStr);
            
            if (waitingQueueDAO.reorderQueue(queueId, newPosition)) {
                request.setAttribute("successMessage", "Queue reordered successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to reorder queue");
            }
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error reordering queue: " + e.getMessage());
        }
        
        doGet(request, response);
    }
}
