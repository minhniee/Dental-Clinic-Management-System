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
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/employee-schedule")
public class EmployeeScheduleServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(EmployeeScheduleServlet.class.getName());
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
            // Get employee ID from request parameter
            String employeeIdParam = request.getParameter("employeeId");
            if (employeeIdParam == null || employeeIdParam.isEmpty()) {
                request.setAttribute("error", "Không tìm thấy thông tin nhân viên.");
                request.getRequestDispatcher("/admin/employee-schedule.jsp").forward(request, response);
                return;
            }

            int employeeId = Integer.parseInt(employeeIdParam);
            
            // Get employee information
            User employee = userDAO.getUserById(employeeId);
            if (employee == null) {
                request.setAttribute("error", "Không tìm thấy nhân viên với ID: " + employeeId);
                request.getRequestDispatcher("/admin/employee-schedule.jsp").forward(request, response);
                return;
            }

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
            
            // Get schedules for the employee for the week
            List<DoctorSchedule> schedules = doctorScheduleDAO.getSchedulesByDateRange(weekStart, weekEnd);
            
            // Filter schedules for this specific employee
            List<DoctorSchedule> employeeSchedules = new ArrayList<>();
            for (DoctorSchedule schedule : schedules) {
                if (schedule.getDoctorId() == employeeId) {
                    employeeSchedules.add(schedule);
                }
            }
            
            // Create schedule matrix for this employee
            List<List<DoctorSchedule>> scheduleMatrix = createScheduleMatrix(employeeSchedules, weekStart);
            
            // Get week navigation data
            LocalDate previousWeek = weekStart.minusWeeks(1);
            LocalDate nextWeek = weekStart.plusWeeks(1);
            
            // Debug logging
            logger.info("Employee: " + employee.getFullName() + " (ID: " + employeeId + ")");
            logger.info("Week: " + weekStart + " to " + weekEnd);
            logger.info("Found " + employeeSchedules.size() + " schedules for this employee");
            
            request.setAttribute("employee", employee);
            request.setAttribute("weekStart", weekStart);
            request.setAttribute("weekEnd", weekEnd);
            request.setAttribute("scheduleMatrix", scheduleMatrix);
            request.setAttribute("employeeSchedules", employeeSchedules);
            request.setAttribute("previousWeek", previousWeek);
            request.setAttribute("nextWeek", nextWeek);
            request.setAttribute("currentWeek", weekStart);
            
            request.getRequestDispatcher("/admin/employee-schedule.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading employee schedule", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải lịch làm việc của nhân viên.");
            request.getRequestDispatcher("/admin/employee-schedule.jsp").forward(request, response);
        }
    }

    private List<List<DoctorSchedule>> createScheduleMatrix(List<DoctorSchedule> schedules, LocalDate weekStart) {
        List<List<DoctorSchedule>> matrix = new ArrayList<>();
        
        // Initialize matrix with 7 days (Monday to Sunday)
        for (int i = 0; i < 7; i++) {
            matrix.add(new ArrayList<>());
        }
        
        // Fill in the schedules
        for (DoctorSchedule schedule : schedules) {
            LocalDate scheduleDate = schedule.getWorkDate();
            int dayOfWeek = scheduleDate.getDayOfWeek().getValue() - 1; // Convert to 0-based index (Monday = 0)
            matrix.get(dayOfWeek).add(schedule);
        }
        
        return matrix;
    }
}
