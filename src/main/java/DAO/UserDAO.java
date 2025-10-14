package DAO;

import context.DBContext;
import model.User;
import model.Role;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO {

    private static final Logger logger = Logger.getLogger(UserDAO.class.getName());

    /**
     * Get user by email address
     */
    public User getUserByEmail(String email) {
        String sql = "SELECT u.*, r.role_name " +
                    "FROM Users u " +
                    "INNER JOIN Roles r ON u.role_id = r.role_id " +
                    "WHERE u.email = ? AND u.is_active = 1";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, email);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting user by email: " + email, e);
        }
        return null;
    }

    /**
     * Authenticate user by email and password
     */
    public User getUserByEmailAndPassword(String email, String password) {
        String sql = "SELECT u.*, r.role_name " +
                    "FROM Users u " +
                    "INNER JOIN Roles r ON u.role_id = r.role_id " +
                    "WHERE u.email = ? AND u.password_hash = ? AND u.is_active = 1";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, email);
            statement.setString(2, password); // Plain text password as per requirement
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error authenticating user: " + email, e);
        }
        return null;
    }

    /**
     * Update user password
     */
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE Users SET password_hash = ? WHERE user_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, newPassword);
            statement.setInt(2, userId);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating password for user: " + userId, e);
            return false;
        }
    }

    /**
     * Update password by email (for forgot password feature)
     */
    public boolean updatePasswordByEmail(String email, String newPassword) {
        String sql = "UPDATE Users SET password_hash = ? WHERE email = ? AND is_active = 1";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, newPassword);
            statement.setString(2, email);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating password for email: " + email, e);
            return false;
        }
    }

    /**
     * Check if email exists in database
     */
    public boolean emailExists(String email) {
        String sql = "SELECT 1 FROM Users WHERE email = ? AND is_active = 1";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, email);
            ResultSet rs = statement.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking if email exists: " + email, e);
            return false;
        }
    }

    /**
     * Map ResultSet to User object
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setFullName(rs.getString("full_name"));
        user.setPhone(rs.getString("phone"));
        user.setRoleId(rs.getInt("role_id"));
        user.setActive(rs.getBoolean("is_active"));
        user.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        
        // Set role information
        Role role = new Role();
        role.setRoleId(rs.getInt("role_id"));
        role.setRoleName(rs.getString("role_name"));
        user.setRole(role);
        
        return user;
    }
}
