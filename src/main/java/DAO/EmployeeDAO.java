package DAO;

import context.DBContext;
import model.Employee;
import model.User;
import model.Role;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmployeeDAO {

    private static final Logger logger = Logger.getLogger(EmployeeDAO.class.getName());

    public List<Employee> getAllEmployeesWithUsers() {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT e.*, u.username, u.email as user_email, u.full_name as user_full_name, " +
                   "r.role_name " +
                   "FROM Employees e " +
                   "LEFT JOIN Users u ON e.user_id = u.user_id " +
                   "LEFT JOIN Roles r ON u.role_id = r.role_id " +
                   "ORDER BY e.employee_id DESC";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                employees.add(mapResultSetToEmployeeWithUser(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting all employees with users", e);
        }
        return employees;
    }

    public Employee getEmployeeById(int employeeId) {
        String sql = "SELECT e.*, u.username, u.email as user_email, u.full_name as user_full_name, " +
                    "r.role_name " +
                    "FROM Employees e " +
                    "LEFT JOIN Users u ON e.user_id = u.user_id " +
                    "LEFT JOIN Roles r ON u.role_id = r.role_id " +
                    "WHERE e.employee_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, employeeId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToEmployeeWithUser(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting employee by ID: " + employeeId, e);
        }
        return null;
    }

    public boolean createEmployee(Employee employee) {
        String sql = "INSERT INTO Employees (user_id, position, hire_date) " +
                    "VALUES (?, ?, ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, employee.getUserId());
            statement.setString(2, employee.getPosition());
            statement.setDate(3, java.sql.Date.valueOf(employee.getHireDate()));
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating employee", e);
            return false;
        }
    }

    public boolean updateEmployee(Employee employee) {
        String sql = "UPDATE Employees SET position = ?, hire_date = ? WHERE employee_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, employee.getPosition());
            statement.setDate(2, java.sql.Date.valueOf(employee.getHireDate()));
            statement.setInt(3, employee.getEmployeeId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating employee: " + employee.getEmployeeId(), e);
            return false;
        }
    }

    public boolean updateEmployeeStatus(int employeeId, boolean isActive) {
        // Since the current schema doesn't have is_active in Employees table,
        // we'll update the user's status instead
        String sql = "UPDATE Users SET is_active = ? WHERE user_id = (SELECT user_id FROM Employees WHERE employee_id = ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setBoolean(1, isActive);
            statement.setInt(2, employeeId);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating employee status: " + employeeId, e);
            return false;
        }
    }

    public boolean employeeIdExists(String employeeId) {
        // Since we're using auto-increment ID, we don't need to check for string employee ID
        return false;
    }

    public List<Employee> getEmployeesByDepartment(String department) {
        // Since the current schema doesn't have department field,
        // we'll return all employees
        return getAllEmployeesWithUsers();
    }

    public List<Employee> getActiveEmployees() {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT e.*, u.username, u.email as user_email, u.full_name as user_full_name, " +
                    "r.role_name " +
                    "FROM Employees e " +
                    "LEFT JOIN Users u ON e.user_id = u.user_id " +
                    "LEFT JOIN Roles r ON u.role_id = r.role_id " +
                    "WHERE u.is_active = 1 " +
                    "ORDER BY e.employee_id";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                employees.add(mapResultSetToEmployeeWithUser(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting active employees", e);
        }
        return employees;
    }

    public Employee getEmployeeByUserId(int userId) {
        String sql = "SELECT e.*, u.username, u.email as user_email, u.full_name as user_full_name, " +
                    "r.role_name " +
                    "FROM Employees e " +
                    "LEFT JOIN Users u ON e.user_id = u.user_id " +
                    "LEFT JOIN Roles r ON u.role_id = r.role_id " +
                    "WHERE e.user_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, userId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToEmployeeWithUser(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting employee by user ID: " + userId, e);
        }
        return null;
    }

    private Employee mapResultSetToEmployeeWithUser(ResultSet rs) throws SQLException {
        Employee employee = new Employee();
        employee.setEmployeeId(rs.getInt("employee_id"));
        employee.setUserId(rs.getInt("user_id"));
        employee.setPosition(rs.getString("position"));
        
        if (rs.getDate("hire_date") != null) {
            employee.setHireDate(rs.getDate("hire_date").toLocalDate());
        }
        
        // Set user information if available
        if (rs.getString("username") != null) {
            User user = new User();
            user.setUserId(rs.getInt("user_id"));
            user.setUsername(rs.getString("username"));
            user.setEmail(rs.getString("user_email"));
            user.setFullName(rs.getString("user_full_name"));
            user.setPhone(rs.getString("phone"));
            user.setActive(rs.getBoolean("is_active"));
            
            // Set role information
            if (rs.getString("role_name") != null) {
                Role role = new Role();
                role.setRoleName(rs.getString("role_name"));
                user.setRole(role);
            }
            
            employee.setUser(user);
        }
        
        return employee;
    }
}