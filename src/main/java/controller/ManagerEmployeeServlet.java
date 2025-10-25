package controller;

import DAO.UserDAO;
import model.User;

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

@WebServlet("/manager/employees")
public class ManagerEmployeeServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ManagerEmployeeServlet.class.getName());
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Check if user has permission (Only ClinicManager)
            String roleName = currentUser.getRole().getRoleName().toLowerCase();
            if (!roleName.equals("clinicmanager")) {
                request.setAttribute("error", "Bạn không có quyền truy cập trang này. Chỉ Clinic Manager mới có thể quản lý nhân viên.");
                request.getRequestDispatcher("/403.jsp").forward(request, response);
                return;
            }

            String action = request.getParameter("action");
            if (action == null) {
                action = "list";
            }

            switch (action) {
                case "list":
                    listEmployees(request, response);
                    break;
                case "view":
                    viewEmployee(request, response);
                    break;
                case "dentists":
                    listDentists(request, response);
                    break;
                case "receptionists":
                    listReceptionists(request, response);
                    break;
                case "nurses":
                    listNurses(request, response);
                    break;
                default:
                    listEmployees(request, response);
                    break;
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading employee management page", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu.");
            request.getRequestDispatcher("/manager/employee-management.jsp").forward(request, response);
        }
    }

    private void listEmployees(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<User> allUsers = userDAO.getAllUsers();
            List<User> employees = new ArrayList<>();
            
            // Filter only employees (not patients or administrators)
            for (User user : allUsers) {
                String roleName = user.getRole().getRoleName().toLowerCase();
                if (roleName.equals("dentist") || roleName.equals("receptionist") || 
                    roleName.equals("nurse") || roleName.equals("clinicmanager")) {
                    employees.add(user);
                }
            }
            
            request.setAttribute("employees", employees);
            request.setAttribute("totalEmployees", employees.size());
            request.setAttribute("activeEmployees", employees.stream().mapToInt(user -> user.isActive() ? 1 : 0).sum());
            request.getRequestDispatcher("/manager/employee-management.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error listing employees", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách nhân viên.");
            request.getRequestDispatcher("/manager/employee-management.jsp").forward(request, response);
        }
    }

    private void viewEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int employeeId = Integer.parseInt(request.getParameter("id"));
            User employee = userDAO.getUserById(employeeId);
            
            if (employee != null) {
                // Check if this is an employee (not patient or admin)
                String roleName = employee.getRole().getRoleName().toLowerCase();
                if (roleName.equals("dentist") || roleName.equals("receptionist") || 
                    roleName.equals("nurse") || roleName.equals("clinicmanager")) {
                    request.setAttribute("employee", employee);
                    request.getRequestDispatcher("/manager/employee-detail.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Không tìm thấy nhân viên.");
                    listEmployees(request, response);
                }
            } else {
                request.setAttribute("error", "Không tìm thấy nhân viên.");
                listEmployees(request, response);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error viewing employee", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xem chi tiết nhân viên.");
            listEmployees(request, response);
        }
    }

    private void listDentists(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<User> allUsers = userDAO.getAllUsers();
            List<User> dentists = new ArrayList<>();
            
            for (User user : allUsers) {
                if ("dentist".equalsIgnoreCase(user.getRole().getRoleName())) {
                    dentists.add(user);
                }
            }
            
            request.setAttribute("employees", dentists);
            request.setAttribute("filterRole", "dentist");
            request.setAttribute("roleName", "Bác Sĩ");
            request.getRequestDispatcher("/manager/employee-management.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error listing dentists", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách bác sĩ.");
            listEmployees(request, response);
        }
    }

    private void listReceptionists(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<User> allUsers = userDAO.getAllUsers();
            List<User> receptionists = new ArrayList<>();
            
            for (User user : allUsers) {
                if ("receptionist".equalsIgnoreCase(user.getRole().getRoleName())) {
                    receptionists.add(user);
                }
            }
            
            request.setAttribute("employees", receptionists);
            request.setAttribute("filterRole", "receptionist");
            request.setAttribute("roleName", "Lễ Tân");
            request.getRequestDispatcher("/manager/employee-management.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error listing receptionists", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách lễ tân.");
            listEmployees(request, response);
        }
    }

    private void listNurses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<User> allUsers = userDAO.getAllUsers();
            List<User> nurses = new ArrayList<>();
            
            for (User user : allUsers) {
                if ("nurse".equalsIgnoreCase(user.getRole().getRoleName())) {
                    nurses.add(user);
                }
            }
            
            request.setAttribute("employees", nurses);
            request.setAttribute("filterRole", "nurse");
            request.setAttribute("roleName", "Y Tá");
            request.getRequestDispatcher("/manager/employee-management.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error listing nurses", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách y tá.");
            listEmployees(request, response);
        }
    }
}
