package controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import DAO.AppointmentDAO;
import DAO.ServiceDAO;
import model.Appointment;
import model.User;
import model.Service;

@WebServlet("/dentist/schedule")
public class DentistScheduleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(DentistScheduleServlet.class.getName());
    
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is logged in and is dentist
        if (currentUser == null || !"Dentist".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String action = request.getParameter("action");
            if (action == null || action.isEmpty()) {
                action = "daily";
            }
            
            switch (action) {
                case "daily":
                    handleDailySchedule(request, response, currentUser);
                    break;
                case "weekly":
                    handleWeeklySchedule(request, response, currentUser);
                    break;
                default:
                    handleDailySchedule(request, response, currentUser);
                    break;
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in DentistScheduleServlet", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải lịch trình: " + e.getMessage());
            request.getRequestDispatcher("/dentist/schedule-daily.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is logged in and is dentist
        if (currentUser == null || !"Dentist".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String action = request.getParameter("action");
            
            if ("update_status".equals(action)) {
                handleUpdateStatus(request, response, currentUser);
            } else {
                response.sendRedirect(request.getContextPath() + "/dentist/schedule");
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in DentistScheduleServlet POST", e);
            response.sendRedirect(request.getContextPath() + "/dentist/schedule?error=update_failed");
        }
    }

    private void handleDailySchedule(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String dateParam = request.getParameter("date");
        LocalDate selectedDate = LocalDate.now();
        
        if (dateParam != null && !dateParam.trim().isEmpty()) {
            try {
                selectedDate = LocalDate.parse(dateParam);
            } catch (DateTimeParseException e) {
                selectedDate = LocalDate.now();
            }
        }
        
        // Get appointments for the current dentist on selected date
        List<Appointment> appointments = appointmentDAO.getAppointmentsByDateAndDentist(
            java.sql.Date.valueOf(selectedDate), 
            currentUser.getUserId()
        );
        
        // Get all services for reference
        List<Service> services = serviceDAO.getAllActiveServices();
        
        request.setAttribute("appointments", appointments);
        request.setAttribute("services", services);
        request.setAttribute("selectedDate", selectedDate.toString());
        request.setAttribute("currentUser", currentUser);
        
        request.getRequestDispatcher("/dentist/schedule-daily.jsp").forward(request, response);
    }

    private void handleWeeklySchedule(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String weekParam = request.getParameter("week");
        LocalDate weekStart = LocalDate.now().with(java.time.DayOfWeek.MONDAY);
        
        if (weekParam != null && !weekParam.trim().isEmpty()) {
            try {
                // Parse week format: YYYY-WXX
                if (weekParam.contains("-W")) {
                    String[] parts = weekParam.split("-W");
                    int year = Integer.parseInt(parts[0]);
                    int week = Integer.parseInt(parts[1]);
                    
                    // Get the first Monday of the year
                    LocalDate firstMonday = LocalDate.of(year, 1, 1)
                        .with(java.time.DayOfWeek.MONDAY);
                    
                    // Calculate the week start date
                    weekStart = firstMonday.plusWeeks(week - 1);
                } else {
                    // Fallback: try to parse as date
                    weekStart = LocalDate.parse(weekParam).with(java.time.DayOfWeek.MONDAY);
                }
            } catch (Exception e) {
                // Use current week if parsing fails
                weekStart = LocalDate.now().with(java.time.DayOfWeek.MONDAY);
            }
        }
        
        // Calculate week end (Sunday)
        LocalDate weekEnd = weekStart.plusDays(6);
        
        // Generate calendar days for the week
        List<CalendarDay> calendarDays = new ArrayList<>();
        LocalDate today = LocalDate.now();
        
        for (int i = 0; i < 7; i++) {
            LocalDate day = weekStart.plusDays(i);
            CalendarDay calendarDay = new CalendarDay();
            calendarDay.setDate(day);
            calendarDay.setDayOfMonth(day.getDayOfMonth());
            calendarDay.setIsOtherMonth(!day.getMonth().equals(weekStart.getMonth()));
            calendarDay.setIsToday(day.equals(today));
            
            // Get appointments for this day for current dentist
            List<Appointment> dayAppointments = appointmentDAO.getAppointmentsByDateAndDentist(
                java.sql.Date.valueOf(day), 
                currentUser.getUserId()
            );
            calendarDay.setAppointments(dayAppointments);
            calendarDays.add(calendarDay);
        }
        
        // Get all services for reference
        List<Service> services = serviceDAO.getAllActiveServices();
        
        request.setAttribute("calendarDays", calendarDays);
        request.setAttribute("services", services);
        request.setAttribute("weekStart", weekStart.toString());
        request.setAttribute("weekEnd", weekEnd.toString());
        request.setAttribute("selectedWeek", weekParam != null ? weekParam : "");
        request.setAttribute("currentUser", currentUser);
        
        request.getRequestDispatcher("/dentist/schedule-weekly.jsp").forward(request, response);
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String status = request.getParameter("status");
            
            // Verify the appointment belongs to the current dentist
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            if (appointment == null || appointment.getDentistId() != currentUser.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/dentist/schedule?error=unauthorized");
                return;
            }
            
            // Update the appointment status
            boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, status);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/dentist/schedule?success=status_updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/dentist/schedule?error=update_failed");
            }
            
        } catch (NumberFormatException e) {
            logger.log(Level.SEVERE, "Invalid appointment ID", e);
            response.sendRedirect(request.getContextPath() + "/dentist/schedule?error=invalid_id");
        }
    }
    
    // Helper class for calendar day
    public static class CalendarDay {
        private LocalDate date;
        private int dayOfMonth;
        private boolean isOtherMonth;
        private boolean isToday;
        private List<Appointment> appointments;
        
        // Getters and setters
        public LocalDate getDate() { return date; }
        public void setDate(LocalDate date) { this.date = date; }
        
        public int getDayOfMonth() { return dayOfMonth; }
        public void setDayOfMonth(int dayOfMonth) { this.dayOfMonth = dayOfMonth; }
        
        public boolean isOtherMonth() { return isOtherMonth; }
        public void setIsOtherMonth(boolean isOtherMonth) { this.isOtherMonth = isOtherMonth; }
        
        public boolean isToday() { return isToday; }
        public void setIsToday(boolean isToday) { this.isToday = isToday; }
        
        public List<Appointment> getAppointments() { return appointments; }
        public void setAppointments(List<Appointment> appointments) { this.appointments = appointments; }
    }
}
