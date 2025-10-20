package controller;

import DAO.AppointmentDAO;
import DAO.WaitingQueueDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/receptionist/dashboard")
public class ReceptionistDashboardServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private WaitingQueueDAO waitingQueueDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        appointmentDAO = new AppointmentDAO();
        waitingQueueDAO = new WaitingQueueDAO();
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
            // Test database connection first
            try {
                appointmentDAO.getAppointmentsByDate(Date.valueOf(LocalDate.now()));
                System.out.println("Database connection successful");
            } catch (Exception e) {
                System.err.println("Database connection failed: " + e.getMessage());
                e.printStackTrace();
            }
            
            // Get today's date
            LocalDate today = LocalDate.now();
            Date todaySqlDate = Date.valueOf(today);

            // Get dashboard statistics with error handling
            DashboardStatistics stats;
            try {
                stats = getDashboardStatistics(todaySqlDate);
            } catch (Exception e) {
                System.err.println("Error getting dashboard statistics: " + e.getMessage());
                e.printStackTrace();
                stats = new DashboardStatistics(0, 0, 0, 0, 0, 0);
            }
            
            // Get today's appointments with error handling
            List<model.Appointment> todayAppointments;
            try {
                todayAppointments = appointmentDAO.getAppointmentsByDate(todaySqlDate);
            } catch (Exception e) {
                System.err.println("Error getting today's appointments: " + e.getMessage());
                e.printStackTrace();
                todayAppointments = new java.util.ArrayList<>();
            }
            
            // Get current queue with error handling
            List<model.WaitingQueue> currentQueue;
            try {
                currentQueue = waitingQueueDAO.getCurrentQueue();
            } catch (Exception e) {
                System.err.println("Error getting current queue: " + e.getMessage());
                e.printStackTrace();
                currentQueue = new java.util.ArrayList<>();
            }

            // Set attributes for JSP
            request.setAttribute("stats", stats);
            request.setAttribute("todayAppointments", todayAppointments);
            request.setAttribute("currentQueue", currentQueue);
            request.setAttribute("today", today);

            // Forward to dashboard JSP
            request.getRequestDispatcher("/receptionist/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Critical error in ReceptionistDashboardServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/dashboard.jsp").forward(request, response);
        }
    }

    private DashboardStatistics getDashboardStatistics(Date today) {
        try {
            // Queue statistics with error handling
            WaitingQueueDAO.QueueStatistics queueStats;
            try {
                queueStats = waitingQueueDAO.getQueueStatistics();
            } catch (Exception e) {
                System.err.println("Error getting queue statistics: " + e.getMessage());
                e.printStackTrace();
                queueStats = new WaitingQueueDAO.QueueStatistics(0, 0, 0, 0, 0, 0);
            }
            
            // Today's appointments with error handling
            List<model.Appointment> todayAppointments;
            try {
                todayAppointments = appointmentDAO.getAppointmentsByDate(today);
            } catch (Exception e) {
                System.err.println("Error getting today's appointments: " + e.getMessage());
                e.printStackTrace();
                todayAppointments = new java.util.ArrayList<>();
            }
            
            // Count appointments by status
            int scheduledToday = 0;
            int completedToday = 0;
            int cancelledToday = 0;
            
            if (todayAppointments != null) {
                for (model.Appointment appointment : todayAppointments) {
                    if (appointment != null && appointment.getStatus() != null) {
                        switch (appointment.getStatus()) {
                            case "SCHEDULED":
                            case "CONFIRMED":
                                scheduledToday++;
                                break;
                            case "COMPLETED":
                                completedToday++;
                                break;
                            case "CANCELLED":
                                cancelledToday++;
                                break;
                        }
                    }
                }
            }

            return new DashboardStatistics(
                queueStats != null ? queueStats.getWaitingCount() : 0,
                scheduledToday,
                completedToday,
                cancelledToday,
                (queueStats != null ? queueStats.getTotalToday() : 0) + completedToday,
                todayAppointments != null ? todayAppointments.size() : 0
            );
            
        } catch (Exception e) {
            System.err.println("Critical error in getDashboardStatistics: " + e.getMessage());
            e.printStackTrace();
            // Return default statistics if error occurs
            return new DashboardStatistics(0, 0, 0, 0, 0, 0);
        }
    }

    /**
     * Inner class for dashboard statistics
     */
    public static class DashboardStatistics {
        private final int waitingPatients;
        private final int scheduledAppointments;
        private final int completedAppointments;
        private final int cancelledAppointments;
        private final int totalCompleted;
        private final int totalAppointmentsToday;

        public DashboardStatistics(int waitingPatients, int scheduledAppointments, int completedAppointments,
                                  int cancelledAppointments, int totalCompleted, int totalAppointmentsToday) {
            this.waitingPatients = waitingPatients;
            this.scheduledAppointments = scheduledAppointments;
            this.completedAppointments = completedAppointments;
            this.cancelledAppointments = cancelledAppointments;
            this.totalCompleted = totalCompleted;
            this.totalAppointmentsToday = totalAppointmentsToday;
        }

        public int getWaitingPatients() { return waitingPatients; }
        public int getScheduledAppointments() { return scheduledAppointments; }
        public int getCompletedAppointments() { return completedAppointments; }
        public int getCancelledAppointments() { return cancelledAppointments; }
        public int getTotalCompleted() { return totalCompleted; }
        public int getTotalAppointmentsToday() { return totalAppointmentsToday; }
    }
}
