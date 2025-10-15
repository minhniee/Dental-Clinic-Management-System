package controller;

import DAO.DoctorScheduleDAO;
import DAO.UserDAO;
import model.DoctorSchedule;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.WeekFields;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/weekly-schedule")
public class WeeklyScheduleServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(WeeklyScheduleServlet.class.getName());
    private final DoctorScheduleDAO doctorScheduleDAO = new DoctorScheduleDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is logged in and is administrator
        if (currentUser == null || !"Administrator".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get week parameter or default to current week
            String weekParam = request.getParameter("week");
            LocalDate selectedWeek;
            
            if (weekParam != null && !weekParam.isEmpty()) {
                selectedWeek = LocalDate.parse(weekParam);
            } else {
                selectedWeek = LocalDate.now();
            }
            
            // Calculate week start (Monday) and end (Sunday)
            LocalDate weekStart = selectedWeek.with(WeekFields.ISO.dayOfWeek(), 1);
            LocalDate weekEnd = weekStart.plusDays(6);
            
            // Get all employees (doctors and receptionists)
            List<User> allUsers = userDAO.getAllUsers();
            List<User> employees = new ArrayList<>();
            
            for (User user : allUsers) {
                String roleName = user.getRole().getRoleName().toLowerCase();
                if (roleName.equals("dentist") || roleName.equals("receptionist") || 
                    roleName.equals("nurse") || roleName.equals("clinicmanager")) {
                    employees.add(user);
                }
            }
            
            // Get schedules for the week
            List<DoctorSchedule> schedules = doctorScheduleDAO.getSchedulesByDateRange(weekStart, weekEnd);
            
            // Debug logging
            logger.info("Week: " + weekStart + " to " + weekEnd);
            logger.info("Found " + employees.size() + " employees");
            logger.info("Found " + schedules.size() + " schedules");
            
            // Log employee details
            for (User emp : employees) {
                logger.info("Employee: " + emp.getUserId() + " - " + emp.getFullName() + " (" + emp.getRole().getRoleName() + ")");
            }
            
            // Log schedule details
            for (DoctorSchedule sched : schedules) {
                logger.info("Schedule: " + sched.getDoctorId() + " on " + sched.getWorkDate() + " - " + sched.getShift());
            }
            
            // Create schedule matrix
            Map<String, Map<String, List<DoctorSchedule>>> scheduleMatrix = createScheduleMatrix(employees, weekStart, schedules);
            
            // Create employee roles map
            Map<String, String> employeeRoles = new LinkedHashMap<>();
            for (User employee : employees) {
                employeeRoles.put(employee.getUserId() + "_" + employee.getFullName(), employee.getRole().getRoleName());
            }
            
            // Get week navigation data
            LocalDate previousWeek = weekStart.minusWeeks(1);
            LocalDate nextWeek = weekStart.plusWeeks(1);
            
            request.setAttribute("weekStart", weekStart);
            request.setAttribute("weekEnd", weekEnd);
            request.setAttribute("employees", employees);
            request.setAttribute("scheduleMatrix", scheduleMatrix);
            request.setAttribute("employeeRoles", employeeRoles);
            request.setAttribute("previousWeek", previousWeek);
            request.setAttribute("nextWeek", nextWeek);
            request.setAttribute("currentWeek", weekStart);
            
            // Debug: Log matrix details
            logger.info("Matrix size: " + scheduleMatrix.size());
            for (Map.Entry<String, Map<String, List<DoctorSchedule>>> entry : scheduleMatrix.entrySet()) {
                logger.info("Employee: " + entry.getKey() + " has " + entry.getValue().size() + " days");
                for (Map.Entry<String, List<DoctorSchedule>> dayEntry : entry.getValue().entrySet()) {
                    if (!dayEntry.getValue().isEmpty()) {
                        logger.info("  Day " + dayEntry.getKey() + ": " + dayEntry.getValue().size() + " schedules");
                    }
                }
            }
            
            request.getRequestDispatcher("/admin/weekly-schedule.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading weekly schedule", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải lịch làm việc tuần.");
            request.getRequestDispatcher("/admin/weekly-schedule.jsp").forward(request, response);
        }
    }

    private Map<String, Map<String, List<DoctorSchedule>>> createScheduleMatrix(
            List<User> employees, LocalDate weekStart, List<DoctorSchedule> schedules) {
        
        Map<String, Map<String, List<DoctorSchedule>>> matrix = new LinkedHashMap<>();
        
        // Initialize matrix with employees and days
        for (User employee : employees) {
            Map<String, List<DoctorSchedule>> employeeSchedule = new LinkedHashMap<>();
            
            // Add all days of the week
            for (int i = 0; i < 7; i++) {
                LocalDate day = weekStart.plusDays(i);
                String dayKey = day.toString();
                employeeSchedule.put(dayKey, new ArrayList<DoctorSchedule>());
            }
            
            matrix.put(employee.getUserId() + "_" + employee.getFullName(), employeeSchedule);
        }
        
        // Fill in the schedules
        for (DoctorSchedule schedule : schedules) {
            // Find the correct employee key
            for (User employee : employees) {
                if (employee.getUserId() == schedule.getDoctorId()) {
                    String employeeKey = employee.getUserId() + "_" + employee.getFullName();
                    String dayKey = schedule.getWorkDate().toString();
                    
                    logger.info("Trying to add schedule for employee: " + employeeKey + " on day: " + dayKey);
                    
                    if (matrix.containsKey(employeeKey)) {
                        Map<String, List<DoctorSchedule>> employeeSchedule = matrix.get(employeeKey);
                        if (employeeSchedule.containsKey(dayKey)) {
                            employeeSchedule.get(dayKey).add(schedule);
                            logger.info("Successfully added schedule to matrix");
                        } else {
                            logger.warning("Day key not found in employee schedule: " + dayKey);
                        }
                    } else {
                        logger.warning("Employee key not found in matrix: " + employeeKey);
                    }
                    break;
                }
            }
        }
        
        return matrix;
    }
    
    private String getEmployeeName(int doctorId) {
        try {
            User user = userDAO.getUserById(doctorId);
            return user != null ? user.getFullName() : "Unknown";
        } catch (Exception e) {
            return "Unknown";
        }
    }
}
