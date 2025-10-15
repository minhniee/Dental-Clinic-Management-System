package DAO;

import context.DBContext;
import model.MedicalRecord;
import model.Patient;
import model.User;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class MedicalRecordDAO {

    private static final Logger logger = Logger.getLogger(MedicalRecordDAO.class.getName());

    /**
     * Get medical records by patient ID
     */
    public List<MedicalRecord> getRecordsByPatientId(int patientId) {
        String sql = "SELECT mr.*, p.full_name as patient_name, u.full_name as dentist_name " +
                    "FROM MedicalRecords mr " +
                    "LEFT JOIN Patients p ON mr.patient_id = p.patient_id " +
                    "LEFT JOIN Users u ON mr.dentist_id = u.user_id " +
                    "WHERE mr.patient_id = ? " +
                    "ORDER BY mr.created_at DESC";
        List<MedicalRecord> records = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, patientId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                records.add(mapResultSetToMedicalRecord(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting records by patient ID: " + patientId, e);
        }
        return records;
    }

    /**
     * Get medical record by ID
     */
    public MedicalRecord getRecordById(int recordId) {
        String sql = "SELECT mr.*, p.full_name as patient_name, u.full_name as dentist_name " +
                    "FROM MedicalRecords mr " +
                    "LEFT JOIN Patients p ON mr.patient_id = p.patient_id " +
                    "LEFT JOIN Users u ON mr.dentist_id = u.user_id " +
                    "WHERE mr.record_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, recordId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToMedicalRecord(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting record by ID: " + recordId, e);
        }
        return null;
    }

    /**
     * Get all medical records
     */
    public List<MedicalRecord> getAllRecords() {
        String sql = "SELECT mr.*, p.full_name as patient_name, u.full_name as dentist_name " +
                    "FROM MedicalRecords mr " +
                    "LEFT JOIN Patients p ON mr.patient_id = p.patient_id " +
                    "LEFT JOIN Users u ON mr.dentist_id = u.user_id " +
                    "ORDER BY mr.created_at DESC";
        List<MedicalRecord> records = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            
            while (rs.next()) {
                records.add(mapResultSetToMedicalRecord(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting all records", e);
        }
        return records;
    }

    /**
     * Create new medical record
     */
    public boolean createMedicalRecord(MedicalRecord medicalRecord) {
        String sql = "INSERT INTO MedicalRecords (patient_id, dentist_id, summary) VALUES (?, ?, ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setInt(1, medicalRecord.getPatientId());
            statement.setObject(2, medicalRecord.getDentistId());
            statement.setString(3, medicalRecord.getSummary());
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    medicalRecord.setRecordId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating medical record", e);
        }
        return false;
    }

    /**
     * Update medical record
     */
    public boolean updateMedicalRecord(MedicalRecord medicalRecord) {
        String sql = "UPDATE MedicalRecords SET summary = ?, dentist_id = ? WHERE record_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, medicalRecord.getSummary());
            statement.setObject(2, medicalRecord.getDentistId());
            statement.setInt(3, medicalRecord.getRecordId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating medical record: " + medicalRecord.getRecordId(), e);
            return false;
        }
    }

    /**
     * Delete medical record
     */
    public boolean deleteMedicalRecord(int recordId) {
        String sql = "DELETE FROM MedicalRecords WHERE record_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, recordId);
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting medical record: " + recordId, e);
            return false;
        }
    }

    /**
     * Check if patient has been examined today
     */
    public boolean hasPatientBeenExaminedToday(int patientId) {
        String sql = "SELECT 1 FROM MedicalRecords WHERE patient_id = ? AND CAST(created_at AS DATE) = CAST(GETDATE() AS DATE)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, patientId);
            ResultSet rs = statement.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking if patient examined today: " + patientId, e);
            return false;
        }
    }

    /**
     * Map ResultSet to MedicalRecord object
     */
    private MedicalRecord mapResultSetToMedicalRecord(ResultSet rs) throws SQLException {
        MedicalRecord record = new MedicalRecord();
        record.setRecordId(rs.getInt("record_id"));
        record.setPatientId(rs.getInt("patient_id"));
        
        int dentistId = rs.getInt("dentist_id");
        record.setDentistId(rs.wasNull() ? null : dentistId);
        
        record.setSummary(rs.getString("summary"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        record.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
        
        // Set patient information if available
        String patientName = rs.getString("patient_name");
        if (patientName != null) {
            Patient patient = new Patient();
            patient.setPatientId(record.getPatientId());
            patient.setFullName(patientName);
            record.setPatient(patient);
        }
        
        // Set dentist information if available
        String dentistName = rs.getString("dentist_name");
        if (dentistName != null && record.getDentistId() != null) {
            User dentist = new User();
            dentist.setUserId(record.getDentistId());
            dentist.setFullName(dentistName);
            record.setDentist(dentist);
        }
        
        return record;
    }
}
