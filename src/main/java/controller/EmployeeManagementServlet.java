package controller;

import DAO.EmployeeDAO;
import DAO.UserDAO;
import DAO.RoleDAO;
import model.Employee;
import model.User;
import model.Role;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/employees")
public class EmployeeManagementServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(EmployeeManagementServlet.class.getName());
    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();

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
            // Get all users with employee roles (Dentist, Receptionist, Nurse, etc.)
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
            
            request.getRequestDispatcher("/admin/employee-management.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading employee management page", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải trang quản lý nhân viên.");
            request.getRequestDispatcher("/admin/employee-management.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is logged in and is administrator
        if (currentUser == null || !"Administrator".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "createEmployee":
                    createEmployee(request, response, currentUser);
                    break;
                case "updateEmployee":
                    updateEmployee(request, response, currentUser);
                    break;
                case "updateStatus":
                    updateEmployeeStatus(request, response, currentUser);
                    break;
                case "viewSchedule":
                    viewEmployeeSchedule(request, response, currentUser);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/employees");
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing employee management action: " + action, e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu.");
            doGet(request, response);
        }
    }

    private void createEmployee(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String position = request.getParameter("position");
            String hireDateStr = request.getParameter("hireDate");
            
            // Validate input
            if (userId <= 0 || position == null || position.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc.");
                doGet(request, response);
                return;
            }
            
            // Check if user already has an employee record
            if (employeeDAO.getEmployeeByUserId(userId) != null) {
                request.setAttribute("error", "Người dùng này đã có hồ sơ nhân viên.");
                doGet(request, response);
                return;
            }
            
            // Create new employee
            Employee newEmployee = new Employee();
            newEmployee.setUserId(userId);
            newEmployee.setPosition(position);
            
            if (hireDateStr != null && !hireDateStr.trim().isEmpty()) {
                newEmployee.setHireDate(LocalDate.parse(hireDateStr));
            } else {
                newEmployee.setHireDate(LocalDate.now());
            }
            
            boolean success = employeeDAO.createEmployee(newEmployee);
            if (success) {
                request.setAttribute("success", "Tạo hồ sơ nhân viên thành công.");
            } else {
                request.setAttribute("error", "Không thể tạo hồ sơ nhân viên, vui lòng thử lại.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error creating employee", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tạo hồ sơ nhân viên.");
        }
        
        doGet(request, response);
    }

    private void updateEmployee(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        
        try {
            int employeeId = Integer.parseInt(request.getParameter("employeeId"));
            String position = request.getParameter("position");
            String hireDateStr = request.getParameter("hireDate");
            
            Employee existingEmployee = employeeDAO.getEmployeeById(employeeId);
            if (existingEmployee == null) {
                request.setAttribute("error", "Không tìm thấy nhân viên.");
                doGet(request, response);
                return;
            }
            
            // Update employee information
            existingEmployee.setPosition(position);
            
            if (hireDateStr != null && !hireDateStr.trim().isEmpty()) {
                existingEmployee.setHireDate(LocalDate.parse(hireDateStr));
            }
            
            boolean success = employeeDAO.updateEmployee(existingEmployee);
            if (success) {
                request.setAttribute("success", "Cập nhật thông tin nhân viên thành công.");
            } else {
                request.setAttribute("error", "Không thể cập nhật thông tin nhân viên.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating employee", e);
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật nhân viên.");
        }
        
        doGet(request, response);
    }

    private void updateEmployeeStatus(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        
        try {
            int employeeId = Integer.parseInt(request.getParameter("employeeId"));
            boolean isActive = "true".equals(request.getParameter("isActive"));
            
            Employee employee = employeeDAO.getEmployeeById(employeeId);
            if (employee == null) {
                request.setAttribute("error", "Không tìm thấy nhân viên.");
                doGet(request, response);
                return;
            }
            
            boolean success = employeeDAO.updateEmployeeStatus(employeeId, isActive);
            if (success) {
                request.setAttribute("success", "Cập nhật trạng thái nhân viên thành công.");
            } else {
                request.setAttribute("error", "Không thể cập nhật trạng thái nhân viên.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating employee status", e);
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật trạng thái nhân viên.");
        }
        
        doGet(request, response);
    }

    private void viewEmployeeSchedule(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        
        try {
            int employeeId = Integer.parseInt(request.getParameter("employeeId"));
            
            // Redirect to schedule management page
            response.sendRedirect(request.getContextPath() + "/admin/schedules?employeeId=" + employeeId);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
            doGet(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error viewing employee schedule", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xem lịch làm việc.");
            doGet(request, response);
        }
    }
}