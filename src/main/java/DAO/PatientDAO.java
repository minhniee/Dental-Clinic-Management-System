package DAO;

import context.DBContext;
import model.Patient;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PatientDAO {

    private static final Logger logger = Logger.getLogger(PatientDAO.class.getName());

    /**
     * Get patient by ID
     */
    public Patient getPatientById(int patientId) {
        String sql = "SELECT * FROM Patients WHERE patient_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, patientId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPatient(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting patient by ID: " + patientId, e);
        }
        return null;
    }


    /**
     * Get patient by phone number
     */
    public Patient getPatientByPhone(String phone) {
        String sql = "SELECT * FROM Patients WHERE phone = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, phone);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPatient(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting patient by phone: " + phone, e);
        }
        return null;
    }

    /**
     * Get all patients who have appointments today (both examined and not examined)
     */
    public List<Patient> getAllPatients() {
        String sql = "SELECT DISTINCT p.*, a.appointment_date, wq.position_in_queue, wq.status as queue_status, " +
                    "COALESCE(wq.position_in_queue, 999) as sort_position FROM Patients p " +
                    "INNER JOIN Appointments a ON p.patient_id = a.patient_id " +
                    "LEFT JOIN WaitingQueue wq ON a.appointment_id = wq.appointment_id " +
                    "WHERE CAST(a.appointment_date AS DATE) = CAST(GETDATE() AS DATE) " +
                    "AND a.status IN ('SCHEDULED', 'CONFIRMED', 'COMPLETED') " +
                    "ORDER BY sort_position, a.appointment_date ASC, p.full_name";
        
        List<Patient> patients = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            
            while (rs.next()) {
                patients.add(mapResultSetToPatient(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting all patients", e);
        }
        return patients;
    }

    /**
     * Get patients who have appointments today but haven't been examined yet
     */
    public List<Patient> getPatientsNotExaminedToday() {
        String sql = "SELECT DISTINCT p.*, a.appointment_date, wq.position_in_queue, wq.status as queue_status, " +
                    "COALESCE(wq.position_in_queue, 999) as sort_position FROM Patients p " +
                    "INNER JOIN Appointments a ON p.patient_id = a.patient_id " +
                    "LEFT JOIN WaitingQueue wq ON a.appointment_id = wq.appointment_id " +
                    "WHERE CAST(a.appointment_date AS DATE) = CAST(GETDATE() AS DATE) " +
                    "AND a.status IN ('SCHEDULED', 'CONFIRMED') " +
                    "AND (wq.appointment_id IS NULL OR wq.status IN ('WAITING', 'CHECKED_IN', 'CALLED')) " +
                    "ORDER BY sort_position, a.appointment_date ASC, p.full_name";
        
        List<Patient> patients = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            
            while (rs.next()) {
                patients.add(mapResultSetToPatient(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting patients not examined today", e);
        }
        return patients;
    }
    
    /**
     * Get all patients with their medical history summary
     */
    public List<Patient> getAllPatientsWithMedicalHistory() {
        String sql = "SELECT DISTINCT p.*, " +
                    "COUNT(mr.record_id) as medical_record_count, " +
                    "MAX(mr.created_at) as last_visit_date " +
                    "FROM Patients p " +
                    "LEFT JOIN MedicalRecords mr ON p.patient_id = mr.patient_id " +
                    "GROUP BY p.patient_id, p.full_name, p.birth_date, p.gender, p.phone, p.email, p.address, p.avatar, p.created_at " +
                    "ORDER BY p.full_name";
        
        List<Patient> patients = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            
            while (rs.next()) {
                Patient patient = mapResultSetToPatient(rs);
                
                // Add medical history summary
                int recordCount = rs.getInt("medical_record_count");
                patient.setMedicalRecordCount(recordCount);
                
                Timestamp lastVisit = rs.getTimestamp("last_visit_date");
                if (lastVisit != null) {
                    patient.setLastVisitDate(lastVisit.toLocalDateTime());
                }
                
                patients.add(patient);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting patients with medical history", e);
        }
        return patients;
    }

    /**
     * Create new patient
     */
    public boolean createPatient(Patient patient) {
        String sql = "INSERT INTO Patients (full_name, birth_date, gender, phone, email, address) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setString(1, patient.getFullName());
            statement.setDate(2, patient.getBirthDate() != null ? Date.valueOf(patient.getBirthDate()) : null);
            statement.setString(3, patient.getGender() != null ? patient.getGender().toString() : null);
            statement.setString(4, patient.getPhone());
            statement.setString(5, patient.getEmail());
            statement.setString(6, patient.getAddress());
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    patient.setPatientId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating patient", e);
        }
        return false;
    }

    /**
     * Update patient
     */
    public boolean updatePatient(Patient patient) {
        String sql = "UPDATE Patients SET full_name = ?, birth_date = ?, gender = ?, " +
                    "phone = ?, email = ?, address = ? WHERE patient_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, patient.getFullName());
            statement.setDate(2, patient.getBirthDate() != null ? Date.valueOf(patient.getBirthDate()) : null);
            statement.setString(3, patient.getGender() != null ? patient.getGender().toString() : null);
            statement.setString(4, patient.getPhone());
            statement.setString(5, patient.getEmail());
            statement.setString(6, patient.getAddress());
            statement.setInt(7, patient.getPatientId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating patient: " + patient.getPatientId(), e);
            return false;
        }
    }

    /**
     * Update patient avatar
     */
    public boolean updatePatientAvatar(int patientId, String avatarUrl) {
        String sql = "UPDATE Patients SET avatar = ? WHERE patient_id = ?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            
            statement.setString(1, avatarUrl);
            statement.setInt(2, patientId);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating patient avatar: " + patientId, e);
            return false;
        }
    }

    /**
     * Map ResultSet to Patient object
     */
    private Patient mapResultSetToPatient(ResultSet rs) throws SQLException {
        Patient patient = new Patient();
        patient.setPatientId(rs.getInt("patient_id"));
        patient.setFullName(rs.getString("full_name"));
        
        Date birthDate = rs.getDate("birth_date");
        patient.setBirthDate(birthDate != null ? birthDate.toLocalDate() : null);
        
        String gender = rs.getString("gender");
        patient.setGender(gender != null ? gender : null);
        
        patient.setPhone(rs.getString("phone"));
        patient.setEmail(rs.getString("email"));
        patient.setAddress(rs.getString("address"));
        patient.setAvatar(rs.getString("avatar"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        patient.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
        
        // Map queue-related fields if they exist
        try {
            int positionInQueue = rs.getInt("position_in_queue");
            if (!rs.wasNull()) {
                patient.setPositionInQueue(positionInQueue);
            }
        } catch (SQLException e) {
            // Column doesn't exist, ignore
        }
        
        try {
            String queueStatus = rs.getString("queue_status");
            patient.setQueueStatus(queueStatus);
        } catch (SQLException e) {
            // Column doesn't exist, ignore
        }
        
        return patient;
    }
    
    /**
     * Mark a patient as examined today by updating WaitingQueue status
     */
    public boolean markPatientExaminedToday(int patientId, int dentistId) {
        // First, get the appointment_id for today's appointment
        String getAppointmentSql = "SELECT a.appointment_id FROM Appointments a " +
                                 "WHERE a.patient_id = ? AND CAST(a.appointment_date AS DATE) = CAST(GETDATE() AS DATE) " +
                                 "AND a.status IN ('SCHEDULED', 'CONFIRMED')";
        
        try (Connection connection = new DBContext().getConnection()) {
            int appointmentId = -1;
            
            // Get appointment ID
            try (PreparedStatement getAppointmentStmt = connection.prepareStatement(getAppointmentSql)) {
                getAppointmentStmt.setInt(1, patientId);
                try (ResultSet rs = getAppointmentStmt.executeQuery()) {
                    if (rs.next()) {
                        appointmentId = rs.getInt("appointment_id");
                    }
                }
            }
            
            if (appointmentId == -1) {
                logger.log(Level.WARNING, "No appointment found for patient " + patientId + " today");
                return false;
            }
            
            // Check if WaitingQueue record exists
            String checkQueueSql = "SELECT queue_id FROM WaitingQueue WHERE appointment_id = ?";
            boolean queueExists = false;
            
            try (PreparedStatement checkStmt = connection.prepareStatement(checkQueueSql)) {
                checkStmt.setInt(1, appointmentId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    queueExists = rs.next();
                }
            }
            
            if (queueExists) {
                // Update existing WaitingQueue record
                String updateSql = "UPDATE WaitingQueue SET status = 'COMPLETED' WHERE appointment_id = ?";
                try (PreparedStatement updateStmt = connection.prepareStatement(updateSql)) {
                    updateStmt.setInt(1, appointmentId);
                    int rowsAffected = updateStmt.executeUpdate();
                    return rowsAffected > 0;
                }
            } else {
                // Create new WaitingQueue record
                String insertSql = "INSERT INTO WaitingQueue (appointment_id, position_in_queue, status) VALUES (?, ?, ?)";
                try (PreparedStatement insertStmt = connection.prepareStatement(insertSql)) {
                    insertStmt.setInt(1, appointmentId);
                    insertStmt.setInt(2, 0); // Position doesn't matter for completed
                    insertStmt.setString(3, "COMPLETED");
                    int rowsAffected = insertStmt.executeUpdate();
                    return rowsAffected > 0;
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error marking patient as examined today: " + patientId, e);
            return false;
        }
    }
}
