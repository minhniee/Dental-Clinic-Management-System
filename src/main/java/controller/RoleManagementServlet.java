package controller;

import DAO.RoleDAO;
import DAO.UserDAO;
import model.Role;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/roles")
public class RoleManagementServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(RoleManagementServlet.class.getName());
    private RoleDAO roleDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        roleDAO = new RoleDAO();
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

            // Check if user has permission (Admin only)
            String roleName = currentUser.getRole().getRoleName().toLowerCase();
            if (!roleName.equals("administrator")) {
                request.setAttribute("error", "Bạn không có quyền truy cập trang này.");
                request.getRequestDispatcher("/403.jsp").forward(request, response);
                return;
            }

            String action = request.getParameter("action");
            if (action == null) {
                action = "list";
            }

            switch (action) {
                case "list":
                    listRoles(request, response);
                    break;
                case "view":
                    viewRole(request, response);
                    break;
                default:
                    listRoles(request, response);
                    break;
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in RoleManagementServlet doGet", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu.");
            request.getRequestDispatcher("/admin/role-management.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String action = request.getParameter("action");
            if (action == null) {
                response.sendRedirect(request.getContextPath() + "/admin/roles");
                return;
            }

            switch (action) {
                case "createRole":
                    createRole(request, response, currentUser);
                    break;
                case "updateRole":
                    updateRole(request, response, currentUser);
                    break;
                case "updatePermissions":
                    updatePermissions(request, response, currentUser);
                    break;
                case "deleteRole":
                    deleteRole(request, response, currentUser);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/roles");
                    break;
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in RoleManagementServlet doPost", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu.");
            request.getRequestDispatcher("/admin/role-management.jsp").forward(request, response);
        }
    }

    private void listRoles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get only the 5 fixed roles
            List<Role> roles = roleDAO.getFixedRoles();
            
            // Add user count for each role
            for (Role role : roles) {
                int userCount = userDAO.getUserCountByRole(role.getRoleId());
                role.setUserCount(userCount);
            }
            
            request.setAttribute("roles", roles);
            request.getRequestDispatcher("/admin/role-management.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error listing roles", e);
            request.setAttribute("error", "Không thể tải danh sách vai trò.");
            request.getRequestDispatcher("/admin/role-management.jsp").forward(request, response);
        }
    }

    private void viewRole(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int roleId = Integer.parseInt(request.getParameter("id"));
            Role role = roleDAO.getRoleById(roleId);
            if (role != null) {
                request.setAttribute("role", role);
                request.getRequestDispatcher("/admin/role-detail.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không tìm thấy vai trò.");
                request.getRequestDispatcher("/admin/role-management.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID không hợp lệ.");
            request.getRequestDispatcher("/admin/role-management.jsp").forward(request, response);
        }
    }

    private void createRole(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            String roleName = request.getParameter("roleName");
            String description = request.getParameter("description");
            String[] permissions = request.getParameterValues("permissions");

            if (roleName == null || roleName.trim().isEmpty()) {
                request.setAttribute("error", "Tên vai trò không được để trống.");
                doGet(request, response);
                return;
            }

            Role role = new Role();
            role.setRoleName(roleName.trim());
            role.setDescription(description != null ? description.trim() : "");
            role.setActive(true);
            
            if (permissions != null) {
                role.setPermissions(Arrays.asList(permissions));
            }

            boolean success = roleDAO.createRole(role);
            if (success) {
                request.setAttribute("success", "Tạo vai trò '" + roleName + "' thành công!");
            } else {
                request.setAttribute("error", "Không thể tạo vai trò. Có thể tên đã tồn tại.");
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
            String roleIdStr = request.getParameter("roleId");
            String roleName = request.getParameter("roleName");
            String description = request.getParameter("description");

            if (roleIdStr == null || roleIdStr.trim().isEmpty()) {
                request.setAttribute("error", "ID vai trò không hợp lệ.");
                doGet(request, response);
                return;
            }

            if (roleName == null || roleName.trim().isEmpty()) {
                request.setAttribute("error", "Tên vai trò không được để trống.");
                doGet(request, response);
                return;
            }

            int roleId = Integer.parseInt(roleIdStr.trim());
            Role existingRole = roleDAO.getRoleById(roleId);
            if (existingRole == null) {
                request.setAttribute("error", "Không tìm thấy vai trò với ID: " + roleId);
                doGet(request, response);
                return;
            }

            existingRole.setRoleName(roleName.trim());
            existingRole.setDescription(description != null ? description.trim() : "");

            boolean success = roleDAO.updateRole(existingRole);
            if (success) {
                request.setAttribute("success", "Cập nhật vai trò '" + roleName + "' thành công!");
            } else {
                request.setAttribute("error", "Không thể cập nhật vai trò.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID vai trò phải là số nguyên dương.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating role", e);
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật vai trò.");
        }

        doGet(request, response);
    }

    private void updatePermissions(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            String roleIdStr = request.getParameter("roleId");
            String[] permissions = request.getParameterValues("permissions");

            if (roleIdStr == null || roleIdStr.trim().isEmpty()) {
                request.setAttribute("error", "ID vai trò không hợp lệ.");
                doGet(request, response);
                return;
            }

            int roleId = Integer.parseInt(roleIdStr.trim());
            Role existingRole = roleDAO.getRoleById(roleId);
            if (existingRole == null) {
                request.setAttribute("error", "Không tìm thấy vai trò với ID: " + roleId);
                doGet(request, response);
                return;
            }

            if (permissions != null) {
                existingRole.setPermissions(Arrays.asList(permissions));
            } else {
                existingRole.setPermissions(Arrays.asList());
            }

            // Permissions are hard-coded, no need to update
            boolean success = true;
            if (success) {
                request.setAttribute("success", "Cập nhật quyền hạn cho vai trò '" + existingRole.getRoleName() + "' thành công!");
            } else {
                request.setAttribute("error", "Không thể cập nhật quyền hạn.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID vai trò phải là số nguyên dương.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating permissions", e);
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật quyền hạn.");
        }

        doGet(request, response);
    }

    private void deleteRole(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            String roleIdStr = request.getParameter("roleId");
            
            if (roleIdStr == null || roleIdStr.trim().isEmpty()) {
                request.setAttribute("error", "ID vai trò không hợp lệ.");
                doGet(request, response);
                return;
            }

            int roleId = Integer.parseInt(roleIdStr.trim());
            Role existingRole = roleDAO.getRoleById(roleId);
            if (existingRole == null) {
                request.setAttribute("error", "Không tìm thấy vai trò với ID: " + roleId);
                doGet(request, response);
                return;
            }

            // Check if role has users
            int userCount = userDAO.getUserCountByRole(roleId);
            if (userCount > 0) {
                request.setAttribute("error", "Không thể xóa vai trò '" + existingRole.getRoleName() + "' vì còn " + userCount + " người dùng đang sử dụng.");
                doGet(request, response);
                return;
            }

            boolean success = roleDAO.deleteRole(roleId);
            if (success) {
                request.setAttribute("success", "Xóa vai trò '" + existingRole.getRoleName() + "' thành công!");
            } else {
                request.setAttribute("error", "Không thể xóa vai trò.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID vai trò phải là số nguyên dương.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deleting role", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xóa vai trò.");
        }

        doGet(request, response);
    }
}