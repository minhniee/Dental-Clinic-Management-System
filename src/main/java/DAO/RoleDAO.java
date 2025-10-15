package DAO;

import context.DBContext;
import model.Role;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RoleDAO {

    private static final Logger logger = Logger.getLogger(RoleDAO.class.getName());

    /**
     * Get all roles
     */
    public List<Role> getAllRoles() {
        String sql = "SELECT * FROM Roles ORDER BY role_name";
        List<Role> roles = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                roles.add(role);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting all roles", e);
        }
        return roles;
    }

    /**
     * Get role by ID
     */
    public Role getRoleById(int roleId) {
        String sql = "SELECT * FROM Roles WHERE role_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, roleId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                return role;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting role by ID: " + roleId, e);
        }
        return null;
    }

    /**
     * Get role by name
     */
    public Role getRoleByName(String roleName) {
        String sql = "SELECT * FROM Roles WHERE role_name = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, roleName);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                return role;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting role by name: " + roleName, e);
        }
        return null;
    }

    /**
     * Create new role
     */
    public boolean createRole(Role role) {
        String sql = "INSERT INTO Roles (role_name) VALUES (?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, role.getRoleName());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating role: " + role.getRoleName(), e);
            return false;
        }
    }

    /**
     * Update role
     */
    public boolean updateRole(Role role) {
        String sql = "UPDATE Roles SET role_name = ? WHERE role_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, role.getRoleName());
            statement.setInt(2, role.getRoleId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating role: " + role.getRoleName(), e);
            return false;
        }
    }

    /**
     * Delete role
     */
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

    /**
     * Check if role name exists
     */
    public boolean roleNameExists(String roleName) {
        String sql = "SELECT 1 FROM Roles WHERE role_name = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, roleName);
            ResultSet rs = statement.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking if role name exists: " + roleName, e);
            return false;
        }
    }

    /**
     * Check if role is being used by any user
     */
    public boolean isRoleInUse(int roleId) {
        String sql = "SELECT 1 FROM Users WHERE role_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, roleId);
            ResultSet rs = statement.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking if role is in use: " + roleId, e);
            return false;
        }
    }
}
