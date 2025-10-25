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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/manager/schedules")
public class ManagerScheduleManagementServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(ManagerScheduleManagementServlet.class.getName());
    private final DoctorScheduleDAO doctorScheduleDAO = new DoctorScheduleDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is logged in and is clinic manager
        if (currentUser == null || !"ClinicManager".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            // Get all employees (doctors, receptionists, nurses)
            List<User> allUsers = userDAO.getAllUsers();
            List<User> employeeUsers = new ArrayList<>();
            
            for (User user : allUsers) {
                String roleName = user.getRole().getRoleName().toLowerCase();
                if (roleName.equals("dentist") || roleName.equals("receptionist") || 
                    roleName.equals("nurse") || roleName.equals("clinicmanager")) {
                    employeeUsers.add(user);
                }
            }
            
            request.setAttribute("employees", employeeUsers);
            request.getRequestDispatcher("/manager/schedule-management.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading schedule management page", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải trang quản lý lịch làm việc.");
            request.getRequestDispatcher("/manager/schedule-management.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is logged in and is clinic manager
        if (currentUser == null || !"ClinicManager".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "preview":
                    handlePreview(request, response);
                    break;
                case "commit":
                    handleCommit(request, response);
                    break;
                case "assignWeeklySchedule":
                    handleAssignWeeklySchedule(request, response);
                    break;
                case "assignMultipleWeeklySchedule":
                    handleAssignMultipleWeeklySchedule(request, response);
                    break;
                default:
                    doGet(request, response);
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing schedule action: " + action, e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu.");
            doGet(request, response);
        }
    }

    private void handlePreview(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String weekStart = request.getParameter("weekStart");
            String weekEnd = request.getParameter("weekEnd");
            String[] selectedEmployees = request.getParameterValues("selectedEmployees");
            String[] workDays = request.getParameterValues("workDays");
            String shift = request.getParameter("shift");
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            String roomNo = request.getParameter("roomNo");
            String notes = request.getParameter("notes");
            
            // Validate input
            if (weekStart == null || weekEnd == null || selectedEmployees == null || 
                workDays == null || shift == null) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc.");
                doGet(request, response);
                return;
            }
            
            // Generate preview data
            Map<String, Object> previewData = generatePreviewData(
                weekStart, weekEnd, selectedEmployees, workDays, 
                shift, startTime, endTime, roomNo, notes
            );
            
            request.setAttribute("previewData", previewData);
            request.getRequestDispatcher("/manager/schedule-preview.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error generating preview", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tạo preview.");
            doGet(request, response);
        }
    }

    private void handleCommit(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String mode = request.getParameter("mode"); // ONLYNEW or UPSERT
            String weekStart = request.getParameter("weekStart");
            String weekEnd = request.getParameter("weekEnd");
            String[] selectedEmployees = request.getParameterValues("selectedEmployees");
            String[] workDays = request.getParameterValues("workDays");
            String shift = request.getParameter("shift");
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            String roomNo = request.getParameter("roomNo");
            String notes = request.getParameter("notes");
            
            // Commit schedule
            Map<String, Object> result = commitSchedule(
                mode, weekStart, weekEnd, selectedEmployees, workDays,
                shift, startTime, endTime, roomNo, notes
            );
            
            request.setAttribute("result", result);
            request.getRequestDispatcher("/manager/schedule-result.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error committing schedule", e);
            request.setAttribute("error", "Có lỗi xảy ra khi lưu lịch làm việc.");
            doGet(request, response);
        }
    }

    private void handleAssignWeeklySchedule(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String employeeId = request.getParameter("employeeId");
            String weekStart = request.getParameter("weekStart");
            String weekEnd = request.getParameter("weekEnd");
            String[] workDays = request.getParameterValues("workDays");
            String shift = request.getParameter("shift");
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            String roomNo = request.getParameter("roomNo");
            String notes = request.getParameter("notes");
            
            // Single employee assignment
            String[] selectedEmployees = {employeeId};
            
            Map<String, Object> result = commitSchedule(
                "ONLYNEW", weekStart, weekEnd, selectedEmployees, workDays,
                shift, startTime, endTime, roomNo, notes
            );
            
            request.setAttribute("result", result);
            request.getRequestDispatcher("/manager/schedule-result.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error assigning weekly schedule", e);
            request.setAttribute("error", "Có lỗi xảy ra khi phân công lịch làm việc.");
            doGet(request, response);
        }
    }

    private void handleAssignMultipleWeeklySchedule(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String[] selectedEmployees = request.getParameterValues("selectedEmployees");
            String weekStart = request.getParameter("weekStart");
            String weekEnd = request.getParameter("weekEnd");
            String[] workDays = request.getParameterValues("workDays");
            String shift = request.getParameter("shift");
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            String roomNo = request.getParameter("roomNo");
            String notes = request.getParameter("notes");
            
            Map<String, Object> result = commitSchedule(
                "ONLYNEW", weekStart, weekEnd, selectedEmployees, workDays,
                shift, startTime, endTime, roomNo, notes
            );
            
            request.setAttribute("result", result);
            request.getRequestDispatcher("/manager/schedule-result.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error assigning multiple weekly schedule", e);
            request.setAttribute("error", "Có lỗi xảy ra khi phân công lịch làm việc cho nhiều nhân viên.");
            doGet(request, response);
        }
    }

    private Map<String, Object> generatePreviewData(String weekStart, String weekEnd, 
            String[] selectedEmployees, String[] workDays, String shift, 
            String startTime, String endTime, String roomNo, String notes) {
        
        Map<String, Object> previewData = new HashMap<>();
        
        try {
            // Parse dates
            LocalDate startDate = LocalDate.parse(weekStart);
            LocalDate endDate = LocalDate.parse(weekEnd);
            
            // Generate list of work dates
            List<LocalDate> workDates = new ArrayList<>();
            for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
                String dayOfWeek = getDayOfWeek(date);
                if (contains(workDays, dayOfWeek)) {
                    workDates.add(date);
                }
            }
            
            // Get employee information
            List<User> employees = new ArrayList<>();
            for (String employeeId : selectedEmployees) {
                User user = userDAO.getUserById(Integer.parseInt(employeeId));
                if (user != null) {
                    employees.add(user);
                }
            }
            
            // Check existing schedules
            Map<String, String> scheduleStatus = new HashMap<>();
            for (User employee : employees) {
                for (LocalDate workDate : workDates) {
                    String key = employee.getUserId() + "_" + workDate.toString();
                    
                    // Check if schedule exists
                    DoctorSchedule existingSchedule = doctorScheduleDAO.getScheduleByDoctorAndDate(
                        employee.getUserId(), workDate, shift
                    );
                    
                    if (existingSchedule != null) {
                        if ("LOCKED".equals(existingSchedule.getStatus())) {
                            scheduleStatus.put(key, "LOCKED");
                        } else {
                            scheduleStatus.put(key, "EXISTS");
                        }
                    } else {
                        scheduleStatus.put(key, "NEW");
                    }
                }
            }
            
            // Convert String dates to LocalDate for proper formatting
            LocalDate startDateParsed = LocalDate.parse(weekStart);
            LocalDate endDateParsed = LocalDate.parse(weekEnd);
            previewData.put("weekStart", startDateParsed);
            previewData.put("weekEnd", endDateParsed);
            previewData.put("employees", employees);
            previewData.put("workDates", workDates);
            previewData.put("scheduleStatus", scheduleStatus);
            previewData.put("shift", shift);
            previewData.put("startTime", startTime);
            previewData.put("endTime", endTime);
            previewData.put("roomNo", roomNo);
            previewData.put("notes", notes);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error generating preview data", e);
            previewData.put("error", "Có lỗi xảy ra khi tạo dữ liệu preview.");
        }
        
        return previewData;
    }

    private Map<String, Object> commitSchedule(String mode, String weekStart, String weekEnd,
            String[] selectedEmployees, String[] workDays, String shift,
            String startTime, String endTime, String roomNo, String notes) {
        
        Map<String, Object> result = new HashMap<>();
        int insertedCount = 0;
        int skippedLocked = 0;
        int skippedExists = 0;
        
        try {
            // Parse dates
            LocalDate startDate = LocalDate.parse(weekStart);
            LocalDate endDate = LocalDate.parse(weekEnd);
            
            // Generate list of work dates
            List<LocalDate> workDates = new ArrayList<>();
            for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
                String dayOfWeek = getDayOfWeek(date);
                if (contains(workDays, dayOfWeek)) {
                    workDates.add(date);
                }
            }
            
            // Process each employee and date
            for (String employeeId : selectedEmployees) {
                for (LocalDate workDate : workDates) {
                    try {
                        // Check existing schedule
                        DoctorSchedule existingSchedule = doctorScheduleDAO.getScheduleByDoctorAndDate(
                            Integer.parseInt(employeeId), workDate, shift
                        );
                        
                        if (existingSchedule != null) {
                            if ("LOCKED".equals(existingSchedule.getStatus())) {
                                skippedLocked++;
                                continue;
                            } else if ("ONLYNEW".equals(mode)) {
                                skippedExists++;
                                continue;
                            } else if ("UPSERT".equals(mode)) {
                                // Delete existing schedule
                                doctorScheduleDAO.deleteSchedule(existingSchedule.getScheduleId());
                            }
                        }
                        
                        // Create new schedule
                        DoctorSchedule newSchedule = new DoctorSchedule();
                        newSchedule.setDoctorId(Integer.parseInt(employeeId));
                        newSchedule.setWorkDate(workDate);
                        newSchedule.setShift(shift);
                        newSchedule.setStartTime(startTime);
                        newSchedule.setEndTime(endTime);
                        newSchedule.setRoomNo(roomNo);
                        newSchedule.setNotes(notes);
                        newSchedule.setStatus("ACTIVE");
                        
                        boolean success = doctorScheduleDAO.createSchedule(newSchedule);
                        if (success) {
                            insertedCount++;
                        }
                        
                    } catch (Exception e) {
                        logger.log(Level.WARNING, "Error creating schedule for employee " + employeeId + " on " + workDate, e);
                    }
                }
            }
            
            result.put("success", true);
            result.put("insertedCount", insertedCount);
            result.put("skippedLocked", skippedLocked);
            result.put("skippedExists", skippedExists);
            result.put("message", "Phân công lịch làm việc thành công!");
            result.put("completedAt", new java.util.Date());
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error committing schedule", e);
            result.put("success", false);
            result.put("error", "Có lỗi xảy ra khi lưu lịch làm việc.");
        }
        
        return result;
    }

    private String getDayOfWeek(LocalDate date) {
        // Map Java DayOfWeek to our database format
        switch (date.getDayOfWeek()) {
            case MONDAY: return "monday";
            case TUESDAY: return "tuesday";
            case WEDNESDAY: return "wednesday";
            case THURSDAY: return "thursday";
            case FRIDAY: return "friday";
            case SATURDAY: return "saturday";
            case SUNDAY: return "sunday";
            default: return "monday";
        }
    }

    private boolean contains(String[] array, String value) {
        if (array == null) return false;
        for (String item : array) {
            if (value.equals(item)) {
                return true;
            }
        }
        return false;
    }
}
