package controller;

import DAO.AppointmentDAO;
import DAO.DentistDAO;
import model.Appointment;
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
import java.time.temporal.WeekFields;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;

@WebServlet("/receptionist/appointment-calendar")
public class AppointmentCalendarServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private DentistDAO dentistDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        appointmentDAO = new AppointmentDAO();
        dentistDAO = new DentistDAO();
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
            switch (action != null ? action : "weekly") {
                case "weekly":
                    handleWeeklyCalendar(request, response);
                    break;
                case "daily":
                    handleDailyCalendar(request, response);
                    break;
                default:
                    handleWeeklyCalendar(request, response);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/appointment-calendar.jsp").forward(request, response);
        }
    }

    private void handleWeeklyCalendar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get week parameter or default to current week
            String weekParam = request.getParameter("week");
            String yearParam = request.getParameter("year");
            String dentistIdParam = request.getParameter("dentistId");
            
            LocalDate targetDate;
            if (weekParam != null && !weekParam.isEmpty()) {
                try {
                    // Parse week parameter (format: YYYY-WXX)
                    String[] parts = weekParam.split("-W");
                    int year = Integer.parseInt(parts[0]);
                    int week = Integer.parseInt(parts[1]);
                    targetDate = getDateFromWeekYear(week, year);
                } catch (Exception e) {
                    targetDate = LocalDate.now();
                }
            } else {
                targetDate = LocalDate.now();
            }
            
            // Calculate week start and end dates
            LocalDate weekStart = targetDate.with(WeekFields.of(Locale.getDefault()).dayOfWeek(), 1);
            LocalDate weekEnd = weekStart.plusDays(6);
            
            // Get appointments for the week
            Date weekStartSql = Date.valueOf(weekStart);
            Date weekEndSql = Date.valueOf(weekEnd);
            
            System.out.println("Week Start: " + weekStart + " (" + weekStartSql + ")");
            System.out.println("Week End: " + weekEnd + " (" + weekEndSql + ")");
            System.out.println("Dentist ID Filter: " + dentistIdParam);
            
            // Get appointments, filtered by dentist if specified
            List<Appointment> weekAppointments;
            if (dentistIdParam != null && !dentistIdParam.trim().isEmpty()) {
                try {
                    int dentistId = Integer.parseInt(dentistIdParam);
                    weekAppointments = appointmentDAO.getAppointmentsByDateRangeAndDentist(weekStartSql, weekEndSql, dentistId);
                    System.out.println("Found " + weekAppointments.size() + " appointments for dentist ID: " + dentistId);
                } catch (NumberFormatException e) {
                    weekAppointments = appointmentDAO.getAppointmentsByDateRange(weekStartSql, weekEndSql);
                    System.out.println("Found " + weekAppointments.size() + " appointments for this week (all dentists)");
                }
            } else {
                weekAppointments = appointmentDAO.getAppointmentsByDateRange(weekStartSql, weekEndSql);
                System.out.println("Found " + weekAppointments.size() + " appointments for this week (all dentists)");
            }
            
            // Organize appointments by day of week
            Map<Integer, List<Appointment>> appointmentsByDay = new HashMap<>();
            for (int i = 1; i <= 7; i++) {
                appointmentsByDay.put(i, new ArrayList<>());
            }
            
            for (Appointment appointment : weekAppointments) {
                if (appointment.getAppointmentDateAsDate() != null) {
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    cal.setTime(appointment.getAppointmentDateAsDate());
                    int dayOfWeek = cal.get(java.util.Calendar.DAY_OF_WEEK);
                    
                    // Debug: Print day of week mapping
                    System.out.println("Appointment: " + appointment.getAppointmentId() + 
                                     ", Date: " + appointment.getAppointmentDateAsDate() + 
                                     ", Day of Week: " + dayOfWeek);
                    
                    // Convert Sunday=1 to Monday=1 format
                    int adjustedDayOfWeek = (dayOfWeek == 1) ? 7 : dayOfWeek - 1;
                    appointmentsByDay.get(adjustedDayOfWeek).add(appointment);
                    
                    System.out.println("Adjusted Day of Week: " + adjustedDayOfWeek + 
                                     ", Added to appointmentsByDay[" + adjustedDayOfWeek + "]");
                }
            }
            
            // Debug: Print appointments by day
            for (Map.Entry<Integer, List<Appointment>> entry : appointmentsByDay.entrySet()) {
                System.out.println("Day " + entry.getKey() + ": " + entry.getValue().size() + " appointments");
            }
            
            // Get all dentists for filtering
            List<User> dentists = dentistDAO.getAllActiveDentists();
            
            request.setAttribute("appointments", weekAppointments);
            request.setAttribute("appointmentsByDay", appointmentsByDay);
            request.setAttribute("dentists", dentists);
            request.setAttribute("weekStart", weekStart);
            request.setAttribute("weekEnd", weekEnd);
            request.setAttribute("currentWeek", getWeekNumber(targetDate));
            request.setAttribute("currentYear", targetDate.getYear());
            request.setAttribute("selectedWeek", weekParam != null ? weekParam : getWeekString(LocalDate.now()));
            request.setAttribute("selectedDentistId", dentistIdParam);
            
            // Add test data if no appointments found
            if (weekAppointments.isEmpty()) {
                System.out.println("No appointments found, adding test data for debugging");
                // We'll just log that no appointments were found
            }
            
            // Add week days for easier display
            List<LocalDate> weekDays = new ArrayList<>();
            for (int i = 0; i < 7; i++) {
                weekDays.add(weekStart.plusDays(i));
            }
            request.setAttribute("weekDays", weekDays);
            
            // Create simple arrays for each day of week
            List<List<Appointment>> appointmentsByDayArray = new ArrayList<>();
            for (int i = 0; i < 7; i++) {
                appointmentsByDayArray.add(new ArrayList<>());
            }
            
            // Populate the array
            for (Map.Entry<Integer, List<Appointment>> entry : appointmentsByDay.entrySet()) {
                int dayIndex = entry.getKey() - 1; // Convert 1-7 to 0-6
                if (dayIndex >= 0 && dayIndex < 7) {
                    appointmentsByDayArray.set(dayIndex, entry.getValue());
                }
            }
            
            request.setAttribute("appointmentsByDayArray", appointmentsByDayArray);
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error loading weekly calendar: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/receptionist/appointment-calendar.jsp").forward(request, response);
    }

    private void handleDailyCalendar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get date parameter or default to today
            String dateParam = request.getParameter("date");
            
            LocalDate targetDate;
            if (dateParam != null) {
                try {
                    targetDate = LocalDate.parse(dateParam);
                } catch (Exception e) {
                    targetDate = LocalDate.now();
                }
            } else {
                targetDate = LocalDate.now();
            }
            
            // Get appointments for the day
            Date targetSqlDate = Date.valueOf(targetDate);
            List<Appointment> dayAppointments = appointmentDAO.getAppointmentsByDate(targetSqlDate);
            
            // Get all dentists for filtering
            List<User> dentists = dentistDAO.getAllActiveDentists();
            
            request.setAttribute("appointments", dayAppointments);
            request.setAttribute("dentists", dentists);
            request.setAttribute("targetDate", targetDate);
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error loading daily calendar: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/receptionist/appointment-calendar.jsp").forward(request, response);
    }

    private int getWeekNumber(LocalDate date) {
        WeekFields weekFields = WeekFields.of(Locale.getDefault());
        return date.get(weekFields.weekOfYear());
    }

    private LocalDate getDateFromWeekYear(int week, int year) {
        WeekFields weekFields = WeekFields.of(Locale.getDefault());
        return LocalDate.now()
                .withYear(year)
                .with(weekFields.weekOfYear(), week)
                .with(weekFields.dayOfWeek(), 1);
    }
    
    private String getWeekString(LocalDate date) {
        int year = date.getYear();
        int week = getWeekNumber(date);
        return String.format("%d-W%02d", year, week);
    }
}
