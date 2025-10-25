package DAO;

import context.DBContext;
import model.Appointment;
import model.User;
import model.Patient;
import model.Service;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AppointmentDAO {

    private static final Logger logger = Logger.getLogger(AppointmentDAO.class.getName());

    /**
     * Create a new appointment
     */
    public int createAppointment(Appointment appointment) {
        String sql = "INSERT INTO Appointments (patient_id, dentist_id, service_id, appointment_date, " +
                     "status, notes, created_at, source, booking_channel, created_by_patient_id, " +
                     "created_by_user_id, confirmation_code, confirmed_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setInt(1, appointment.getPatientId());
            statement.setInt(2, appointment.getDentistId());
            statement.setInt(3, appointment.getServiceId());
            statement.setTimestamp(4, Timestamp.valueOf(appointment.getAppointmentDate()));
            statement.setString(5, appointment.getStatus() != null ? appointment.getStatus() : "SCHEDULED");
            statement.setString(6, appointment.getNotes());
            statement.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            statement.setString(8, appointment.getSource() != null ? appointment.getSource() : "INTERNAL");
            statement.setObject(9, appointment.getBookingChannel(), Types.VARCHAR);
            statement.setObject(10, appointment.getCreatedByPatientId(), Types.INTEGER);
            statement.setObject(11, appointment.getCreatedByUserId(), Types.INTEGER);
            statement.setString(12, appointment.getConfirmationCode());
            statement.setObject(13, appointment.getConfirmedAt() != null ? Timestamp.valueOf(appointment.getConfirmedAt()) : null, Types.TIMESTAMP);
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating appointment", e);
        }
        
        return -1;
    }

    /**
     * Get appointment by ID with related data
     */
    public Appointment getAppointmentById(int appointmentId) {
        String sql = "SELECT a.*, p.full_name as patient_name, p.phone as patient_phone, " +
                     "u.full_name as dentist_name, s.name as service_name, s.price as service_price, " +
                     "s.duration_minutes as service_duration " +
                     "FROM Appointments a " +
                     "LEFT JOIN Patients p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN Users u ON a.dentist_id = u.user_id " +
                     "LEFT JOIN Services s ON a.service_id = s.service_id " +
                     "WHERE a.appointment_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, appointmentId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToAppointment(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting appointment by ID: " + appointmentId, e);
        }
        
        return null;
    }

    /**
     * Update appointment status
     */
    public boolean updateAppointmentStatus(int appointmentId, String status) {
        String sql = "UPDATE Appointments SET status = ? WHERE appointment_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, status);
            statement.setInt(2, appointmentId);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating appointment status: " + appointmentId, e);
            return false;
        }
    }

    /**
     * Get appointments by status
     */
    public List<Appointment> getAppointmentsByStatus(String status) {
        String sql = "SELECT a.*, p.full_name as patient_name, p.phone as patient_phone, " +
                     "u.full_name as dentist_name, s.name as service_name, s.price as service_price, " +
                     "s.duration_minutes as service_duration " +
                     "FROM Appointments a " +
                     "LEFT JOIN Patients p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN Users u ON a.dentist_id = u.user_id " +
                     "LEFT JOIN Services s ON a.service_id = s.service_id " +
                     "WHERE a.status = ? " +
                     "ORDER BY a.appointment_date DESC";
        
        List<Appointment> appointments = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, status);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = mapResultSetToAppointment(rs);
                appointments.add(appointment);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting appointments by status: " + status, e);
        }
        
        return appointments;
    }

    /**
     * Get appointments by patient ID
     */
    public List<Appointment> getAppointmentsByPatientId(int patientId) {
        String sql = "SELECT a.*, p.full_name as patient_name, p.phone as patient_phone, " +
                    "u.full_name as dentist_name, s.name as service_name, s.price as service_price, " +
                    "s.duration_minutes as service_duration " +
                    "FROM Appointments a " +
                    "LEFT JOIN Patients p ON a.patient_id = p.patient_id " +
                    "LEFT JOIN Users u ON a.dentist_id = u.user_id " +
                    "LEFT JOIN Services s ON a.service_id = s.service_id " +
                    "WHERE a.patient_id = ? " +
                    "ORDER BY a.appointment_date DESC";
        List<Appointment> appointments = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, patientId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting appointments by patient ID: " + patientId, e);
        }
        return appointments;
    }

    /**
     * Update appointment confirmation details
     */
    public boolean updateAppointmentConfirmation(int appointmentId, LocalDateTime confirmedAt) {
        String sql = "UPDATE Appointments SET status = 'CONFIRMED', confirmed_at = ? WHERE appointment_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setTimestamp(1, Timestamp.valueOf(confirmedAt));
            statement.setInt(2, appointmentId);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating appointment confirmation: " + appointmentId, e);
            return false;
        }
    }

    /**
     * Update appointment
     */
    public boolean updateAppointment(Appointment appointment) {
        String sql = "UPDATE Appointments SET patient_id = ?, dentist_id = ?, service_id = ?, " +
                     "appointment_date = ?, status = ?, notes = ? WHERE appointment_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, appointment.getPatientId());
            statement.setInt(2, appointment.getDentistId());
            statement.setInt(3, appointment.getServiceId());
            statement.setTimestamp(4, Timestamp.valueOf(appointment.getAppointmentDate()));
            statement.setString(5, appointment.getStatus());
            statement.setString(6, appointment.getNotes());
            statement.setInt(7, appointment.getAppointmentId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating appointment: " + appointment.getAppointmentId(), e);
            return false;
        }
    }

    /**
     * Get appointments for a specific date and dentist
     */
    public List<Appointment> getAppointmentsByDateAndDentist(java.sql.Date date, int dentistId) {
        String sql = "SELECT a.*, p.full_name as patient_name, p.phone as patient_phone, " +
                     "u.full_name as dentist_name, s.name as service_name, s.price as service_price, " +
                     "s.duration_minutes as service_duration " +
                     "FROM Appointments a " +
                     "LEFT JOIN Patients p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN Users u ON a.dentist_id = u.user_id " +
                     "LEFT JOIN Services s ON a.service_id = s.service_id " +
                     "WHERE CAST(a.appointment_date AS DATE) = ? AND a.dentist_id = ? " +
                     "ORDER BY a.appointment_date ASC";
        
        List<Appointment> appointments = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setDate(1, date);
            statement.setInt(2, dentistId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = mapResultSetToAppointment(rs);
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting appointments by date and dentist", e);
        }
        
        return appointments;
    }

    /**
     * Get appointments for a specific date (all dentists)
     */
    public List<Appointment> getAppointmentsByDate(java.sql.Date date) {
        String sql = "SELECT a.*, p.full_name as patient_name, p.phone as patient_phone, " +
                     "u.full_name as dentist_name, s.name as service_name, s.price as service_price, " +
                     "s.duration_minutes as service_duration " +
                     "FROM Appointments a " +
                     "LEFT JOIN Patients p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN Users u ON a.dentist_id = u.user_id " +
                     "LEFT JOIN Services s ON a.service_id = s.service_id " +
                     "WHERE CAST(a.appointment_date AS DATE) = ? " +
                     "ORDER BY a.appointment_date ASC, u.full_name ASC";
        
        List<Appointment> appointments = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setDate(1, date);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = mapResultSetToAppointment(rs);
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting appointments by date", e);
        }
        
        return appointments;
    }

    /**
     * Get appointments for a specific patient
     */
    public List<Appointment> getAppointmentsByPatient(int patientId) {
        String sql = "SELECT a.*, p.full_name as patient_name, p.phone as patient_phone, " +
                     "u.full_name as dentist_name, s.name as service_name, s.price as service_price, " +
                     "s.duration_minutes as service_duration " +
                     "FROM Appointments a " +
                     "LEFT JOIN Patients p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN Users u ON a.dentist_id = u.user_id " +
                     "LEFT JOIN Services s ON a.service_id = s.service_id " +
                     "WHERE a.patient_id = ? " +
                     "ORDER BY a.appointment_date DESC";
        
        List<Appointment> appointments = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, patientId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = mapResultSetToAppointment(rs);
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting appointments by patient: " + patientId, e);
        }
        
        return appointments;
    }

    /**
     * Check if dentist has conflicting appointment
     */
    public boolean hasConflictingAppointment(int dentistId, LocalDateTime startTime, LocalDateTime endTime, Integer excludeAppointmentId) {
        String sql = "SELECT COUNT(*) FROM Appointments a " +
                     "LEFT JOIN Services s ON a.service_id = s.service_id " +
                     "WHERE a.dentist_id = ? AND a.status IN ('SCHEDULED', 'CONFIRMED') " +
                     "AND a.appointment_id != COALESCE(?, -1) " +
                     "AND (a.appointment_date < ? AND DATEADD(MINUTE, ISNULL(s.duration_minutes, 30), a.appointment_date) > ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, dentistId);
            statement.setObject(2, excludeAppointmentId, Types.INTEGER);
            statement.setTimestamp(3, Timestamp.valueOf(endTime));
            statement.setTimestamp(4, Timestamp.valueOf(startTime));
            
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking conflicting appointment", e);
        }
        
        return false;
    }

    /**
     * Map ResultSet to Appointment object with related data
     */
    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        Appointment appointment = new Appointment();
        appointment.setAppointmentId(rs.getInt("appointment_id"));
        appointment.setPatientId(rs.getInt("patient_id"));
        appointment.setDentistId(rs.getInt("dentist_id"));
        appointment.setServiceId(rs.getInt("service_id"));
        
        Timestamp appointmentDate = rs.getTimestamp("appointment_date");
        if (appointmentDate != null) {
            appointment.setAppointmentDate(appointmentDate.toLocalDateTime());
        }
        
        appointment.setStatus(rs.getString("status"));
        appointment.setNotes(rs.getString("notes"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            appointment.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        appointment.setSource(rs.getString("source"));
        appointment.setBookingChannel(rs.getString("booking_channel"));
        
        int createdByPatientId = rs.getInt("created_by_patient_id");
        if (!rs.wasNull()) {
            appointment.setCreatedByPatientId(createdByPatientId);
        }
        
        int createdByUserId = rs.getInt("created_by_user_id");
        if (!rs.wasNull()) {
            appointment.setCreatedByUserId(createdByUserId);
        }
        
        appointment.setConfirmationCode(rs.getString("confirmation_code"));
        
        Timestamp confirmedAt = rs.getTimestamp("confirmed_at");
        if (confirmedAt != null) {
            appointment.setConfirmedAt(confirmedAt.toLocalDateTime());
        }
        
        // Set related objects
        // Only set patient if patient_id is not null
        int patientId = rs.getInt("patient_id");
        if (!rs.wasNull()) {
            Patient patient = new Patient();
            patient.setPatientId(patientId);
            patient.setFullName(rs.getString("patient_name"));
            patient.setPhone(rs.getString("patient_phone"));
            appointment.setPatient(patient);
        } else {
            appointment.setPatient(null);
        }
        
        // Only set dentist if dentist_id is not null
        int dentistId = rs.getInt("dentist_id");
        if (!rs.wasNull()) {
            User dentist = new User();
            dentist.setUserId(dentistId);
            dentist.setFullName(rs.getString("dentist_name"));
            appointment.setDentist(dentist);
        } else {
            appointment.setDentist(null);
        }
        
        // Only set service if service_id is not null
        int serviceId = rs.getInt("service_id");
        if (!rs.wasNull()) {
            Service service = new Service();
            service.setServiceId(serviceId);
            service.setName(rs.getString("service_name"));
            service.setPrice(rs.getBigDecimal("service_price"));
            
            int durationMinutes = rs.getInt("service_duration");
            if (rs.wasNull()) {
                service.setDurationMinutes(null);
            } else {
                service.setDurationMinutes(durationMinutes);
            }
            appointment.setService(service);
        } else {
            appointment.setService(null);
        }
        
        return appointment;
    }

    /**
     * Get appointment count for a dentist today
     */
    public int getAppointmentCountForDentistToday(int dentistId) {
        String sql = "SELECT COUNT(*) as appointment_count FROM Appointments " +
                     "WHERE dentist_id = ? AND CAST(appointment_date AS DATE) = CAST(GETDATE() AS DATE) " +
                     "AND status IN ('SCHEDULED', 'CONFIRMED', 'COMPLETED')";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, dentistId);
            
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("appointment_count");
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting appointment count for dentist today", e);
        }
        return 0;
    }

    /**
     * Get count of examined patients for a dentist today
     */
    public int getExaminedPatientsCountForDentistToday(int dentistId) {
        String sql = "SELECT COUNT(DISTINCT a.patient_id) as examined_count " +
                     "FROM Appointments a " +
                     "INNER JOIN WaitingQueue wq ON a.appointment_id = wq.appointment_id " +
                     "WHERE a.dentist_id = ? AND CAST(a.appointment_date AS DATE) = CAST(GETDATE() AS DATE) " +
                     "AND wq.status = 'COMPLETED'";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, dentistId);
            
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("examined_count");
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting examined patients count for dentist today", e);
        }
        return 0;
    }

    /**
     * Get count of waiting patients for a dentist today
     */
    public int getWaitingPatientsCountForDentistToday(int dentistId) {
        String sql = "SELECT COUNT(DISTINCT a.patient_id) as waiting_count " +
                     "FROM Appointments a " +
                     "LEFT JOIN WaitingQueue wq ON a.appointment_id = wq.appointment_id " +
                     "WHERE a.dentist_id = ? AND CAST(a.appointment_date AS DATE) = CAST(GETDATE() AS DATE) " +
                     "AND a.status IN ('SCHEDULED', 'CONFIRMED') " +
                     "AND (wq.appointment_id IS NULL OR wq.status IN ('WAITING', 'CHECKED_IN', 'CALLED'))";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, dentistId);
            
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("waiting_count");
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting waiting patients count for dentist today", e);
        }
        return 0;
    }
}
