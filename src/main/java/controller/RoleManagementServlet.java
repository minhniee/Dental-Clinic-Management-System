package controller;

import DAO.RoleDAO;
import model.Role;
import model.User;

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

@WebServlet("/admin/roles")
public class RoleManagementServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(RoleManagementServlet.class.getName());
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
            // Get all roles
            List<Role> roles = roleDAO.getAllRoles();
            request.setAttribute("roles", roles);
            
            request.getRequestDispatcher("/admin/role-management.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading role management page", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải trang quản lý vai trò.");
            request.getRequestDispatcher("/admin/role-management.jsp").forward(request, response);
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
                case "createRole":
                    createRole(request, response, currentUser);
                    break;
                case "updateRole":
                    updateRole(request, response, currentUser);
                    break;
                case "deleteRole":
                    deleteRole(request, response, currentUser);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/roles");
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing role management action: " + action, e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu.");
            doGet(request, response);
        }
    }

    private void createRole(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        
        try {
            String roleName = request.getParameter("roleName");
            
            if (roleName == null || roleName.trim().isEmpty()) {
                request.setAttribute("error", "Tên vai trò không được để trống.");
                doGet(request, response);
                return;
            }
            
            // Check if role name already exists
            if (roleDAO.roleNameExists(roleName)) {
                request.setAttribute("error", "Tên vai trò đã tồn tại.");
                doGet(request, response);
                return;
            }
            
            Role newRole = new Role(roleName);
            boolean success = roleDAO.createRole(newRole);
            
            if (success) {
                request.setAttribute("success", "Tạo vai trò mới thành công.");
            } else {
                request.setAttribute("error", "MSG22: Failed to create role, please try again later.");
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error creating role", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tạo vai trò.");
        }
        
        doGet(request, response);
    }

    private void updateRole(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        
        try {
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            String roleName = request.getParameter("roleName");
            
            if (roleName == null || roleName.trim().isEmpty()) {
                request.setAttribute("error", "Tên vai trò không được để trống.");
                doGet(request, response);
                return;
            }
            
            Role existingRole = roleDAO.getRoleById(roleId);
            if (existingRole == null) {
                request.setAttribute("error", "MSG20: Role not found");
                doGet(request, response);
                return;
            }
            
            // Check if role name already exists (excluding current role)
            Role roleWithSameName = roleDAO.getRoleByName(roleName);
            if (roleWithSameName != null && roleWithSameName.getRoleId() != roleId) {
                request.setAttribute("error", "Tên vai trò đã tồn tại.");
                doGet(request, response);
                return;
            }
            
            Role updatedRole = new Role(roleId, roleName);
            boolean success = roleDAO.updateRole(updatedRole);
            
            if (success) {
                request.setAttribute("success", "Cập nhật vai trò thành công.");
            } else {
                request.setAttribute("error", "MSG22: Failed to update role, please try again later.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating role", e);
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật vai trò.");
        }
        
        doGet(request, response);
    }

    private void deleteRole(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        
        try {
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            
            Role role = roleDAO.getRoleById(roleId);
            if (role == null) {
                request.setAttribute("error", "MSG20: Role not found");
                doGet(request, response);
                return;
            }
            
            // Check if role is being used by any user
            if (roleDAO.isRoleInUse(roleId)) {
                request.setAttribute("error", "Không thể xóa vai trò đang được sử dụng bởi người dùng.");
                doGet(request, response);
                return;
            }
            
            boolean success = roleDAO.deleteRole(roleId);
            
            if (success) {
                request.setAttribute("success", "Xóa vai trò thành công.");
            } else {
                request.setAttribute("error", "MSG22: Failed to delete role, please try again later.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deleting role", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xóa vai trò.");
        }
        
        doGet(request, response);
    }

    private String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }
}
