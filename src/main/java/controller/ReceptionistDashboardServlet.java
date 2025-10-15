package controller;

import DAO.AppointmentDAO;
import DAO.PatientDAO;
import DAO.UserDAO;
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
    private PatientDAO patientDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        appointmentDAO = new AppointmentDAO();
        waitingQueueDAO = new WaitingQueueDAO();
        patientDAO = new PatientDAO();
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
            // Get today's date
            LocalDate today = LocalDate.now();
            Date todaySqlDate = Date.valueOf(today);

            // Get dashboard statistics
            DashboardStatistics stats = getDashboardStatistics(todaySqlDate);
            
            // Get today's appointments
            List<model.Appointment> todayAppointments = appointmentDAO.getAppointmentsByDate(todaySqlDate);
            
            // Get current queue
            List<model.WaitingQueue> currentQueue = waitingQueueDAO.getCurrentQueue();

            // Set attributes for JSP
            request.setAttribute("stats", stats);
            request.setAttribute("todayAppointments", todayAppointments);
            request.setAttribute("currentQueue", currentQueue);
            request.setAttribute("today", today);

            // Forward to dashboard JSP
            request.getRequestDispatcher("/receptionist/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/dashboard.jsp").forward(request, response);
        }
    }

    private DashboardStatistics getDashboardStatistics(Date today) {
        try {
            // Queue statistics
            WaitingQueueDAO.QueueStatistics queueStats = waitingQueueDAO.getQueueStatistics();
            
            // Today's appointments
            List<model.Appointment> todayAppointments = appointmentDAO.getAppointmentsByDate(today);
            
            // Count appointments by status
            int scheduledToday = 0;
            int completedToday = 0;
            int cancelledToday = 0;
            
            for (model.Appointment appointment : todayAppointments) {
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

            return new DashboardStatistics(
                queueStats.getWaitingCount(),
                scheduledToday,
                completedToday,
                cancelledToday,
                queueStats.getTotalToday() + completedToday, // Total completed today
                todayAppointments.size()
            );
            
        } catch (Exception e) {
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
