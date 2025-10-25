package DAO;

import context.DBContext;
import model.Role;

import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RoleDAO {
    private static final Logger logger = Logger.getLogger(RoleDAO.class.getName());

    public List<Role> getAllRoles() {
        String sql = "SELECT * FROM Roles ORDER BY role_name";
        List<Role> roles = new ArrayList<>();

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                roles.add(mapResultSetToRole(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting all roles", e);
        }

        return roles;
    }

    public List<Role> getFixedRoles() {
        String sql = "SELECT * FROM Roles WHERE role_name IN ('Administrator', 'ClinicManager', 'Receptionist', 'Dentist', 'Patient') ORDER BY role_name";
        List<Role> roles = new ArrayList<>();

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                roles.add(mapResultSetToRole(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting fixed roles", e);
        }

        return roles;
    }

    public Role getRoleById(int roleId) {
        String sql = "SELECT * FROM Roles WHERE role_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, roleId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToRole(rs);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting role by ID: " + roleId, e);
        }

        return null;
    }

    public Role getRoleByName(String roleName) {
        String sql = "SELECT * FROM Roles WHERE role_name = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, roleName);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToRole(rs);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting role by name: " + roleName, e);
        }

        return null;
    }

    public boolean createRole(Role role) {
        String sql = "INSERT INTO Roles (role_name, description, is_active) VALUES (?, ?, ?)";

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            statement.setString(1, role.getRoleName());
            statement.setString(2, role.getDescription());
            statement.setBoolean(3, role.isActive());

            int rowsAffected = statement.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        role.setRoleId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            if (e.getMessage().contains("UNIQUE KEY constraint") || e.getMessage().contains("duplicate key")) {
                logger.log(Level.WARNING, "Duplicate role name: " + role.getRoleName());
                return false;
            }
            logger.log(Level.SEVERE, "Error creating role", e);
        }

        return false;
    }

    public boolean updateRole(Role role) {
        String sql = "UPDATE Roles SET role_name = ?, description = ? WHERE role_id = ?";

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, role.getRoleName());
            statement.setString(2, role.getDescription());
            statement.setInt(3, role.getRoleId());

            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating role", e);
            return false;
        }
    }

    // Permissions are hard-coded, no need to update them

    public boolean deleteRole(int roleId) {
        String sql = "DELETE FROM Roles WHERE role_id = ?";

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, roleId);
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting role: " + roleId, e);
            return false;
        }
    }

    public List<String> getRolePermissions(int roleId) {
        // Get role name first
        String roleName = getRoleNameById(roleId);
        if (roleName == null) {
            return new ArrayList<>();
        }
        
        // Return hard-coded permissions based on role name
        return getHardCodedPermissions(roleName);
    }
    
    private String getRoleNameById(int roleId) {
        String sql = "SELECT role_name FROM Roles WHERE role_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, roleId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("role_name");
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting role name for role: " + roleId, e);
        }
        
        return null;
    }
    
    private List<String> getHardCodedPermissions(String roleName) {
        List<String> permissions = new ArrayList<>();
        
        switch (roleName) {
            case "Administrator":
                // Quản trị viên có toàn quyền
                permissions.addAll(Arrays.asList(
                    "user_management", "role_management", "employee_management", 
                    "schedule_management", "inventory_management", "appointment_management", 
                    "patient_management", "report_view", "system_config", "financial_management"
                ));
                break;
            case "ClinicManager":
                // Quản lý phòng khám - quản lý vận hành
                permissions.addAll(Arrays.asList(
                    "employee_management", "schedule_management", "inventory_management", 
                    "appointment_management", "patient_management", "report_view",
                    "financial_reports", "operational_reports"
                ));
                break;
            case "Receptionist":
                // Lễ tân - quản lý lịch hẹn và bệnh nhân
                permissions.addAll(Arrays.asList(
                    "appointment_management", "patient_management", "appointment_view",
                    "patient_registration", "schedule_view"
                ));
                break;
            case "Dentist":
                // Bác sĩ - điều trị và quản lý bệnh nhân
                permissions.addAll(Arrays.asList(
                    "appointment_management", "patient_management", "appointment_view",
                    "patient_treatment", "medical_records", "schedule_view"
                ));
                break;
            case "Patient":
                // Bệnh nhân - chỉ xem và đặt lịch
                permissions.addAll(Arrays.asList(
                    "appointment_view", "appointment_booking", "patient_profile"
                ));
                break;
        }
        
        return permissions;
    }

    private Role mapResultSetToRole(ResultSet rs) throws SQLException {
        Role role = new Role();
        role.setRoleId(rs.getInt("role_id"));
        role.setRoleName(rs.getString("role_name"));
        
        // Handle optional columns that might not exist
        try {
            role.setDescription(rs.getString("description"));
        } catch (SQLException e) {
            role.setDescription("");
        }
        
        try {
            role.setActive(rs.getBoolean("is_active"));
        } catch (SQLException e) {
            role.setActive(true);
        }
        
        try {
            if (rs.getTimestamp("created_at") != null) {
                role.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            }
        } catch (SQLException e) {
            // Column doesn't exist, skip
        }
        
        try {
            if (rs.getTimestamp("updated_at") != null) {
                role.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
            }
        } catch (SQLException e) {
            // Column doesn't exist, skip
        }

        // Load permissions
        List<String> permissions = getRolePermissions(role.getRoleId());
        role.setPermissions(permissions);

        return role;
    }
}