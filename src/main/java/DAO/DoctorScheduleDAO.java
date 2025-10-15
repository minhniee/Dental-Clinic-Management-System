package DAO;

import context.DBContext;
import model.DoctorSchedule;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DoctorScheduleDAO {

    private static final Logger logger = Logger.getLogger(DoctorScheduleDAO.class.getName());

    public boolean createSchedule(DoctorSchedule schedule) {
        String sql = "INSERT INTO DoctorSchedules (doctor_id, work_date, shift, start_time, end_time, room_no, status, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, schedule.getDoctorId());
            statement.setDate(2, java.sql.Date.valueOf(schedule.getWorkDate()));
            statement.setString(3, schedule.getShift());
            statement.setString(4, schedule.getStartTime());
            statement.setString(5, schedule.getEndTime());
            statement.setString(6, schedule.getRoomNo());
            statement.setString(7, schedule.getStatus());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating schedule", e);
            return false;
        }
    }

    public DoctorSchedule getScheduleByDoctorAndDate(int doctorId, LocalDate workDate, String shift) {
        String sql = "SELECT * FROM DoctorSchedules WHERE doctor_id = ? AND work_date = ? AND shift = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, doctorId);
            statement.setDate(2, java.sql.Date.valueOf(workDate));
            statement.setString(3, shift);
            
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToDoctorSchedule(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting schedule by doctor and date", e);
        }
        return null;
    }

    public List<DoctorSchedule> getSchedulesByDoctor(int doctorId) {
        List<DoctorSchedule> schedules = new ArrayList<>();
        String sql = "SELECT * FROM DoctorSchedules WHERE doctor_id = ? ORDER BY work_date, start_time";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, doctorId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                schedules.add(mapResultSetToDoctorSchedule(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting schedules by doctor", e);
        }
        return schedules;
    }

    public List<DoctorSchedule> getSchedulesByDateRange(LocalDate startDate, LocalDate endDate) {
        List<DoctorSchedule> schedules = new ArrayList<>();
        String sql = "SELECT * FROM DoctorSchedules WHERE work_date BETWEEN ? AND ? ORDER BY work_date, start_time";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setDate(1, java.sql.Date.valueOf(startDate));
            statement.setDate(2, java.sql.Date.valueOf(endDate));
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                schedules.add(mapResultSetToDoctorSchedule(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting schedules by date range", e);
        }
        return schedules;
    }

    public boolean updateSchedule(DoctorSchedule schedule) {
        String sql = "UPDATE DoctorSchedules SET work_date = ?, shift = ?, start_time = ?, end_time = ?, " +
                    "room_no = ?, notes = ?, status = ? WHERE schedule_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setDate(1, java.sql.Date.valueOf(schedule.getWorkDate()));
            statement.setString(2, schedule.getShift());
            statement.setString(3, schedule.getStartTime());
            statement.setString(4, schedule.getEndTime());
            statement.setString(5, schedule.getRoomNo());
            statement.setString(6, schedule.getNotes());
            statement.setString(7, schedule.getStatus());
            statement.setInt(8, schedule.getScheduleId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating schedule", e);
            return false;
        }
    }

    public boolean deleteSchedule(int scheduleId) {
        String sql = "DELETE FROM DoctorSchedules WHERE schedule_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, scheduleId);
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting schedule", e);
            return false;
        }
    }

    public boolean lockWeek(int doctorId, LocalDate weekStart, LocalDate weekEnd) {
        String sql = "UPDATE DoctorSchedules SET status = 'LOCKED' WHERE doctor_id = ? AND work_date BETWEEN ? AND ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, doctorId);
            statement.setDate(2, java.sql.Date.valueOf(weekStart));
            statement.setDate(3, java.sql.Date.valueOf(weekEnd));
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error locking week", e);
            return false;
        }
    }

    public boolean cancelSchedule(int scheduleId) {
        String sql = "UPDATE DoctorSchedules SET status = 'CANCELLED' WHERE schedule_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, scheduleId);
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error cancelling schedule", e);
            return false;
        }
    }

    private DoctorSchedule mapResultSetToDoctorSchedule(ResultSet rs) throws SQLException {
        DoctorSchedule schedule = new DoctorSchedule();
        schedule.setScheduleId(rs.getInt("schedule_id"));
        schedule.setDoctorId(rs.getInt("doctor_id"));
        schedule.setWorkDate(rs.getDate("work_date").toLocalDate());
        schedule.setShift(rs.getString("shift"));
        schedule.setStartTime(rs.getString("start_time"));
        schedule.setEndTime(rs.getString("end_time"));
        schedule.setRoomNo(rs.getString("room_no"));
        schedule.setNotes(""); // No notes column in current database
        schedule.setStatus(rs.getString("status"));
        return schedule;
    }
}
