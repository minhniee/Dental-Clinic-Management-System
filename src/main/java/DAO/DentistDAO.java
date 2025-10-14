package DAO;

import context.DBContext;
import model.User;
import model.Employee;
import model.DoctorSchedule;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DentistDAO {

    private static final Logger logger = Logger.getLogger(DentistDAO.class.getName());

    /**
     * Get all active dentists with their employee information
     */
    public List<User> getAllActiveDentists() {
        String sql = "SELECT u.*, r.role_name, e.position, e.hire_date " +
                    "FROM Users u " +
                    "INNER JOIN Roles r ON u.role_id = r.role_id " +
                    "LEFT JOIN Employees e ON u.user_id = e.user_id " +
                    "WHERE r.role_name = 'Dentist' AND u.is_active = 1 " +
                    "ORDER BY e.hire_date DESC, u.full_name ASC";
        
        List<User> dentists = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            
            while (rs.next()) {
                User dentist = mapResultSetToUser(rs);
                dentists.add(dentist);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting all active dentists", e);
        }
        
        return dentists;
    }

    /**
     * Get dentist schedules for a specific doctor
     */
    public List<DoctorSchedule> getDentistSchedules(int doctorId) {
        String sql = "SELECT * FROM DoctorSchedules " +
                    "WHERE doctor_id = ? AND status = 'ACTIVE' " +
                    "ORDER BY work_date ASC, start_time ASC";
        
        List<DoctorSchedule> schedules = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, doctorId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                DoctorSchedule schedule = mapResultSetToDoctorSchedule(rs);
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting dentist schedules for doctor: " + doctorId, e);
        }
        
        return schedules;
    }

    /**
     * Get dentist by ID with employee information
     */
    public User getDentistById(int dentistId) {
        String sql = "SELECT u.*, r.role_name, e.position, e.hire_date " +
                    "FROM Users u " +
                    "INNER JOIN Roles r ON u.role_id = r.role_id " +
                    "LEFT JOIN Employees e ON u.user_id = e.user_id " +
                    "WHERE u.user_id = ? AND r.role_name = 'Dentist' AND u.is_active = 1";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, dentistId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting dentist by ID: " + dentistId, e);
        }
        
        return null;
    }

    /**
     * Map ResultSet to User object with Employee information
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setFullName(rs.getString("full_name"));
        user.setPhone(rs.getString("phone"));
        user.setRoleId(rs.getInt("role_id"));
        user.setActive(rs.getBoolean("is_active"));
        user.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        
        // Set role information
        model.Role role = new model.Role();
        role.setRoleId(rs.getInt("role_id"));
        role.setRoleName(rs.getString("role_name"));
        user.setRole(role);
        
        // Set employee information if available
        if (rs.getString("position") != null) {
            Employee employee = new Employee();
            employee.setUserId(user.getUserId());
            employee.setPosition(rs.getString("position"));
            employee.setHireDate(rs.getDate("hire_date").toLocalDate());
            user.setEmployee(employee);
        }
        
        return user;
    }

    /**
     * Map ResultSet to DoctorSchedule object
     */
    private DoctorSchedule mapResultSetToDoctorSchedule(ResultSet rs) throws SQLException {
        DoctorSchedule schedule = new DoctorSchedule();
        schedule.setScheduleId(rs.getInt("schedule_id"));
        schedule.setDoctorId(rs.getInt("doctor_id"));
        schedule.setWorkDate(rs.getDate("work_date").toLocalDate());
        schedule.setShift(rs.getString("shift"));
        schedule.setStartTime(rs.getTime("start_time").toLocalTime());
        schedule.setEndTime(rs.getTime("end_time").toLocalTime());
        schedule.setRoomNo(rs.getString("room_no"));
        schedule.setStatus(rs.getString("status"));
        schedule.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        
        return schedule;
    }
}
