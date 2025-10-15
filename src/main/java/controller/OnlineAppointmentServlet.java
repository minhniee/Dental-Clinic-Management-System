package controller;

import DAO.AppointmentRequestDAO;
import DAO.DentistDAO;
import DAO.ServiceDAO;
import model.AppointmentRequest;
import model.User;
import model.Service;

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

    @Override
    public void init() throws ServletException {
        super.init();
        appointmentRequestDAO = new AppointmentRequestDAO();
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
        if (currentUser == null || currentUser.getRole() == null || 
            !"receptionist".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "list") {
                case "list":
                    handleListAppointmentRequests(request, response);
                    break;
                case "view":
                    handleViewAppointmentRequest(request, response);
                    break;
                default:
                    handleListAppointmentRequests(request, response);
                    break;
            }
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

    private void handleViewAppointmentRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String requestIdStr = request.getParameter("id");
            if (requestIdStr == null || requestIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Invalid request ID");
                handleListAppointmentRequests(request, response);
                return;
            }
            
            int requestId = Integer.parseInt(requestIdStr);
            AppointmentRequest appointmentRequest = appointmentRequestDAO.getAppointmentRequestById(requestId);
            
            if (appointmentRequest == null) {
                request.setAttribute("errorMessage", "Appointment request not found");
                handleListAppointmentRequests(request, response);
                return;
            }
            
            // Get related services and dentists
            List<Service> services = serviceDAO.getAllActiveServices();
            List<User> dentists = dentistDAO.getAllActiveDentists();
            
            request.setAttribute("appointmentRequest", appointmentRequest);
            request.setAttribute("services", services);
            request.setAttribute("dentists", dentists);
            
            request.getRequestDispatcher("/receptionist/view-appointment-request.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid request ID format");
            handleListAppointmentRequests(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error viewing appointment request: " + e.getMessage());
            handleListAppointmentRequests(request, response);
        }
    }

    private void handleUpdateRequestStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String requestIdStr = request.getParameter("requestId");
            String newStatus = request.getParameter("status");
            
            if (requestIdStr == null || newStatus == null) {
                request.setAttribute("errorMessage", "Missing required parameters");
                handleListAppointmentRequests(request, response);
                return;
            }
            
            int requestId = Integer.parseInt(requestIdStr);
            boolean success = appointmentRequestDAO.updateRequestStatus(requestId, newStatus);
            
            if (success) {
                request.setAttribute("successMessage", "Status updated successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to update status");
            }
            
            // Redirect back to list with filter
            String statusFilter = request.getParameter("statusFilter");
            response.sendRedirect(request.getContextPath() + "/receptionist/online-appointments?status=" + 
                (statusFilter != null ? statusFilter : ""));
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid request ID format");
            handleListAppointmentRequests(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error updating status: " + e.getMessage());
            handleListAppointmentRequests(request, response);
        }
    }
}
