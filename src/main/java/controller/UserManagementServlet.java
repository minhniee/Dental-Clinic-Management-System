package controller;

import DAO.UserDAO;
import DAO.RoleDAO;
import model.User;
import model.Role;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/users")
public class UserManagementServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(UserManagementServlet.class.getName());
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
            // Get all users and roles
            List<User> users = userDAO.getAllUsers();
            List<Role> roles = roleDAO.getAllRoles();
            
            request.setAttribute("users", users);
            request.setAttribute("roles", roles);
            
            request.getRequestDispatcher("/admin/user-management.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading user management page", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải trang quản lý người dùng.");
            request.getRequestDispatcher("/admin/user-management.jsp").forward(request, response);
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
                case "updateRole":
                    updateUserRole(request, response, currentUser);
                    break;
                case "updateStatus":
                    updateUserStatus(request, response, currentUser);
                    break;
                case "createUser":
                    createUser(request, response, currentUser);
                    break;
                case "updateUser":
                    updateUser(request, response, currentUser);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing user management action: " + action, e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu.");
            doGet(request, response);
        }
    }

    private void updateUserRole(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            
            User targetUser = userDAO.getUserById(userId);
            if (targetUser == null) {
                request.setAttribute("error", "MSG20: User not found");
                doGet(request, response);
                return;
            }
            
            Role newRole = roleDAO.getRoleById(roleId);
            if (newRole == null) {
                request.setAttribute("error", "MSG21: Invalid role selection");
                doGet(request, response);
                return;
            }
            
            boolean success = userDAO.updateUserRole(userId, roleId);
            if (success) {
                request.setAttribute("success", "Cập nhật vai trò thành công.");
            } else {
                request.setAttribute("error", "MSG22: Failed to update role, please try again later.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
        }
        
        doGet(request, response);
    }

    private void updateUserStatus(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            boolean isActive = "true".equals(request.getParameter("isActive"));
            
            User targetUser = userDAO.getUserById(userId);
            if (targetUser == null) {
                request.setAttribute("error", "MSG20: User not found");
                doGet(request, response);
                return;
            }
            
            boolean success = userDAO.updateUserStatus(userId, isActive);
            if (success) {
                request.setAttribute("success", "Cập nhật trạng thái thành công.");
            } else {
                request.setAttribute("error", "MSG22: Failed to update status, please try again later.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
        }
        
        doGet(request, response);
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        
        try {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            
            // Validate input
            if (username == null || username.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc.");
                doGet(request, response);
                return;
            }
            
            // Check if username or email already exists
            if (userDAO.usernameExists(username)) {
                request.setAttribute("error", "Tên đăng nhập đã tồn tại.");
                doGet(request, response);
                return;
            }
            
            if (userDAO.emailExists(email)) {
                request.setAttribute("error", "Email đã tồn tại.");
                doGet(request, response);
                return;
            }
            
            // Create new user
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setEmail(email);
            newUser.setPasswordHash(password); // In production, hash the password
            newUser.setFullName(fullName);
            newUser.setPhone(phone);
            newUser.setRoleId(roleId);
            newUser.setActive(true);
            
            boolean success = userDAO.createUser(newUser);
            if (success) {
                request.setAttribute("success", "Tạo người dùng mới thành công.");
            } else {
                request.setAttribute("error", "MSG22: Failed to create user, please try again later.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
        }
        
        doGet(request, response);
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            
            // Validate input
            if (username == null || username.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc.");
                doGet(request, response);
                return;
            }
            
            User targetUser = userDAO.getUserById(userId);
            if (targetUser == null) {
                request.setAttribute("error", "MSG20: User not found");
                doGet(request, response);
                return;
            }
            
            // Check if username already exists for another user
            if (!targetUser.getUsername().equals(username) && userDAO.usernameExists(username)) {
                request.setAttribute("error", "Tên đăng nhập đã tồn tại.");
                doGet(request, response);
                return;
            }
            
            // Check if email already exists for another user
            if (!targetUser.getEmail().equals(email) && userDAO.emailExists(email)) {
                request.setAttribute("error", "Email đã tồn tại.");
                doGet(request, response);
                return;
            }
            
            // Update user information
            targetUser.setUsername(username);
            targetUser.setEmail(email);
            targetUser.setFullName(fullName);
            targetUser.setPhone(phone);
            
            boolean success = userDAO.updateUser(targetUser);
            if (success) {
                request.setAttribute("success", "Cập nhật thông tin người dùng thành công.");
            } else {
                request.setAttribute("error", "MSG22: Failed to update user, please try again later.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
        }
        
        doGet(request, response);
    }

    private String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }
}
