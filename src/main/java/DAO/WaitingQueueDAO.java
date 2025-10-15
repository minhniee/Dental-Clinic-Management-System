package DAO;

import context.DBContext;
import model.WaitingQueue;
import model.Appointment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class WaitingQueueDAO {

    private static final Logger logger = Logger.getLogger(WaitingQueueDAO.class.getName());

    /**
     * Add appointment to waiting queue (check in patient)
     */
    public int addToQueue(int appointmentId) {
        // First check if already in queue
        if (isInQueue(appointmentId)) {
            return -1; // Already in queue
        }

        String sql = "INSERT INTO WaitingQueue (appointment_id, position_in_queue, status) VALUES (?, ?, 'WAITING')";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // Get next position in queue
            int nextPosition = getNextQueuePosition();
            
            statement.setInt(1, appointmentId);
            statement.setInt(2, nextPosition);
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error adding appointment to queue: " + appointmentId, e);
        }
        
        return -1;
    }

    /**
     * Update queue status
     */
    public boolean updateQueueStatus(int appointmentId, String status) {
        String sql = "UPDATE WaitingQueue SET status = ? WHERE appointment_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, status);
            statement.setInt(2, appointmentId);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating queue status for appointment: " + appointmentId, e);
            return false;
        }
    }

    /**
     * Update queue position and status
     */
    public boolean updateQueuePositionAndStatus(int appointmentId, Integer position, String status) {
        String sql = "UPDATE WaitingQueue SET position_in_queue = ?, status = ? WHERE appointment_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setObject(1, position, Types.INTEGER);
            statement.setString(2, status);
            statement.setInt(3, appointmentId);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating queue position and status for appointment: " + appointmentId, e);
            return false;
        }
    }

    /**
     * Remove from queue
     */
    public boolean removeFromQueue(int appointmentId) {
        String sql = "UPDATE WaitingQueue SET status = 'COMPLETED' WHERE appointment_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, appointmentId);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error removing appointment from queue: " + appointmentId, e);
            return false;
        }
    }

    /**
     * Check if appointment is already in queue
     */
    public boolean isInQueue(int appointmentId) {
        String sql = "SELECT COUNT(*) FROM WaitingQueue WHERE appointment_id = ? AND status IN ('WAITING', 'CHECKED_IN', 'CALLED', 'IN_TREATMENT')";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, appointmentId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking if appointment is in queue: " + appointmentId, e);
        }
        
        return false;
    }

    /**
     * Get current queue for today with appointment details
     */
    public List<WaitingQueue> getCurrentQueue() {
        String sql = "SELECT w.*, a.appointment_date, a.status as appointment_status, " +
                     "p.full_name as patient_name, p.phone as patient_phone, " +
                     "u.full_name as dentist_name, s.name as service_name " +
                     "FROM WaitingQueue w " +
                     "INNER JOIN Appointments a ON w.appointment_id = a.appointment_id " +
                     "LEFT JOIN Patients p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN Users u ON a.dentist_id = u.user_id " +
                     "LEFT JOIN Services s ON a.service_id = s.service_id " +
                     "WHERE CAST(a.appointment_date AS DATE) = CAST(GETDATE() AS DATE) " +
                     "AND w.status IN ('WAITING', 'CHECKED_IN', 'CALLED', 'IN_TREATMENT') " +
                     "ORDER BY w.position_in_queue ASC, w.queue_id ASC";
        
        List<WaitingQueue> queue = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            
            while (rs.next()) {
                WaitingQueue waitingQueue = mapResultSetToWaitingQueue(rs);
                queue.add(waitingQueue);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting current queue", e);
        }
        
        return queue;
    }

    /**
     * Get queue statistics for today
     */
    public QueueStatistics getQueueStatistics() {
        String sql = "SELECT " +
                     "COUNT(CASE WHEN w.status = 'WAITING' THEN 1 END) as waiting_count, " +
                     "COUNT(CASE WHEN w.status = 'CHECKED_IN' THEN 1 END) as checked_in_count, " +
                     "COUNT(CASE WHEN w.status = 'CALLED' THEN 1 END) as called_count, " +
                     "COUNT(CASE WHEN w.status = 'IN_TREATMENT' THEN 1 END) as in_treatment_count, " +
                     "COUNT(CASE WHEN w.status = 'COMPLETED' THEN 1 END) as completed_count, " +
                     "COUNT(CASE WHEN w.status = 'NO_SHOW' THEN 1 END) as no_show_count " +
                     "FROM WaitingQueue w " +
                     "INNER JOIN Appointments a ON w.appointment_id = a.appointment_id " +
                     "WHERE CAST(a.appointment_date AS DATE) = CAST(GETDATE() AS DATE)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            
            if (rs.next()) {
                return new QueueStatistics(
                    rs.getInt("waiting_count"),
                    rs.getInt("checked_in_count"),
                    rs.getInt("called_count"),
                    rs.getInt("in_treatment_count"),
                    rs.getInt("completed_count"),
                    rs.getInt("no_show_count")
                );
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting queue statistics", e);
        }
        
        return new QueueStatistics(0, 0, 0, 0, 0, 0);
    }

    /**
     * Get next position in queue
     */
    private int getNextQueuePosition() {
        String sql = "SELECT ISNULL(MAX(position_in_queue), 0) + 1 FROM WaitingQueue w " +
                     "INNER JOIN Appointments a ON w.appointment_id = a.appointment_id " +
                     "WHERE CAST(a.appointment_date AS DATE) = CAST(GETDATE() AS DATE)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting next queue position", e);
        }
        
        return 1; // Default to position 1 if error
    }

    /**
     * Get waiting queue entry by appointment ID
     */
    public WaitingQueue getQueueEntryByAppointmentId(int appointmentId) {
        String sql = "SELECT w.*, a.appointment_date, a.status as appointment_status, " +
                     "p.full_name as patient_name, p.phone as patient_phone, " +
                     "u.full_name as dentist_name, s.name as service_name " +
                     "FROM WaitingQueue w " +
                     "INNER JOIN Appointments a ON w.appointment_id = a.appointment_id " +
                     "LEFT JOIN Patients p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN Users u ON a.dentist_id = u.user_id " +
                     "LEFT JOIN Services s ON a.service_id = s.service_id " +
                     "WHERE w.appointment_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, appointmentId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToWaitingQueue(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting queue entry by appointment ID: " + appointmentId, e);
        }
        
        return null;
    }

    /**
     * Map ResultSet to WaitingQueue object
     */
    private WaitingQueue mapResultSetToWaitingQueue(ResultSet rs) throws SQLException {
        WaitingQueue waitingQueue = new WaitingQueue();
        waitingQueue.setQueueId(rs.getInt("queue_id"));
        waitingQueue.setAppointmentId(rs.getInt("appointment_id"));
        waitingQueue.setStatus(rs.getString("status"));
        
        int position = rs.getInt("position_in_queue");
        if (!rs.wasNull()) {
            waitingQueue.setPositionInQueue(position);
        }
        
        // Set appointment details
        Appointment appointment = new Appointment();
        appointment.setAppointmentId(waitingQueue.getAppointmentId());
        
        Timestamp appointmentDate = rs.getTimestamp("appointment_date");
        if (appointmentDate != null) {
            appointment.setAppointmentDate(appointmentDate.toLocalDateTime());
        }
        
        appointment.setStatus(rs.getString("appointment_status"));
        
        // Set patient details
        model.Patient patient = new model.Patient();
        patient.setFullName(rs.getString("patient_name"));
        patient.setPhone(rs.getString("patient_phone"));
        appointment.setPatient(patient);
        
        // Set dentist details
        model.User dentist = new model.User();
        dentist.setFullName(rs.getString("dentist_name"));
        appointment.setDentist(dentist);
        
        // Set service details
        model.Service service = new model.Service();
        service.setName(rs.getString("service_name"));
        appointment.setService(service);
        
        waitingQueue.setAppointment(appointment);
        
        return waitingQueue;
    }

    /**
     * Inner class for queue statistics
     */
    public static class QueueStatistics {
        private final int waitingCount;
        private final int checkedInCount;
        private final int calledCount;
        private final int inTreatmentCount;
        private final int completedCount;
        private final int noShowCount;

        public QueueStatistics(int waitingCount, int checkedInCount, int calledCount, 
                              int inTreatmentCount, int completedCount, int noShowCount) {
            this.waitingCount = waitingCount;
            this.checkedInCount = checkedInCount;
            this.calledCount = calledCount;
            this.inTreatmentCount = inTreatmentCount;
            this.completedCount = completedCount;
            this.noShowCount = noShowCount;
        }

        public int getWaitingCount() { return waitingCount; }
        public int getCheckedInCount() { return checkedInCount; }
        public int getCalledCount() { return calledCount; }
        public int getInTreatmentCount() { return inTreatmentCount; }
        public int getCompletedCount() { return completedCount; }
        public int getNoShowCount() { return noShowCount; }
        public int getTotalToday() { return completedCount + noShowCount; }
    }
}
