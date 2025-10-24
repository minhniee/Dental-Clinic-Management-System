package DAO;

import context.DBContext;
import model.Prescription;
import model.PrescriptionItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PrescriptionDAO {
    
    private static final Logger logger = Logger.getLogger(PrescriptionDAO.class.getName());
    
    /**
     * Get prescriptions by patient ID
     */
    public List<Prescription> getPrescriptionsByPatientId(int patientId) {
        String sql = "SELECT p.*, u.full_name as dentist_name " +
                    "FROM Prescriptions p " +
                    "LEFT JOIN Users u ON p.dentist_id = u.user_id " +
                    "WHERE p.patient_id = ? ORDER BY p.created_at DESC";
        List<Prescription> prescriptions = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, patientId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                prescriptions.add(mapResultSetToPrescription(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting prescriptions by patient ID: " + patientId, e);
        }
        return prescriptions;
    }
    
    /**
     * Get prescription by ID
     */
    public Prescription getPrescriptionById(int prescriptionId) {
        String sql = "SELECT p.*, u.full_name as dentist_name " +
                    "FROM Prescriptions p " +
                    "LEFT JOIN Users u ON p.dentist_id = u.user_id " +
                    "WHERE p.prescription_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, prescriptionId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPrescription(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting prescription by ID: " + prescriptionId, e);
        }
        return null;
    }
    
    /**
     * Create new prescription
     */
    public boolean createPrescription(Prescription prescription) {
        String sql = "INSERT INTO Prescriptions (patient_id, dentist_id, notes) VALUES (?, ?, ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setInt(1, prescription.getPatientId());
            statement.setObject(2, prescription.getDentistId());
            statement.setString(3, prescription.getNotes());
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    prescription.setPrescriptionId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating prescription", e);
        }
        return false;
    }
    
    /**
     * Update prescription
     */
    public boolean updatePrescription(Prescription prescription) {
        String sql = "UPDATE Prescriptions SET notes = ?, dentist_id = ? WHERE prescription_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, prescription.getNotes());
            statement.setObject(2, prescription.getDentistId());
            statement.setInt(3, prescription.getPrescriptionId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating prescription: " + prescription.getPrescriptionId(), e);
            return false;
        }
    }
    
    /**
     * Delete prescription
     */
    public boolean deletePrescription(int prescriptionId) {
        String sql = "DELETE FROM Prescriptions WHERE prescription_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, prescriptionId);
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting prescription: " + prescriptionId, e);
            return false;
        }
    }
    
    /**
     * Map ResultSet to Prescription object
     */
    private Prescription mapResultSetToPrescription(ResultSet rs) throws SQLException {
        Prescription prescription = new Prescription();
        prescription.setPrescriptionId(rs.getInt("prescription_id"));
        prescription.setPatientId(rs.getInt("patient_id"));
        
        int dentistId = rs.getInt("dentist_id");
        prescription.setDentistId(rs.wasNull() ? null : dentistId);
        
        prescription.setNotes(rs.getString("notes"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        prescription.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
        
        // Set dentist information if available
        String dentistName = rs.getString("dentist_name");
        if (dentistName != null && prescription.getDentistId() != null) {
            model.User dentist = new model.User();
            dentist.setUserId(prescription.getDentistId());
            dentist.setFullName(dentistName);
            prescription.setDentist(dentist);
        }
        
        return prescription;
    }
    
    /**
     * Create prescription item
     */
    public boolean createPrescriptionItem(PrescriptionItem item) {
        String sql = "INSERT INTO PrescriptionItems (prescription_id, medication_name, dosage, duration, instructions) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, item.getPrescriptionId());
            statement.setString(2, item.getMedicationName());
            statement.setString(3, item.getDosage());
            statement.setString(4, item.getDuration());
            statement.setString(5, item.getInstructions());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating prescription item", e);
            return false;
        }
    }
    
    /**
     * Get prescriptions by record ID (through patient_id)
     */
    public List<Prescription> getPrescriptionsByRecordId(int recordId) {
        // First get patient_id from the record
        String patientSql = "SELECT patient_id FROM MedicalRecords WHERE record_id = ?";
        int patientId = 0;
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement patientStmt = connection.prepareStatement(patientSql)) {
            
            patientStmt.setInt(1, recordId);
            ResultSet patientRs = patientStmt.executeQuery();
            
            if (patientRs.next()) {
                patientId = patientRs.getInt("patient_id");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting patient_id for record: " + recordId, e);
            return new ArrayList<>();
        }
        
        // Then get prescriptions by patient_id with dentist info
        String sql = "SELECT p.*, u.full_name as dentist_name FROM Prescriptions p " +
                    "LEFT JOIN Users u ON p.dentist_id = u.user_id " +
                    "WHERE p.patient_id = ? ORDER BY p.created_at ASC";
        List<Prescription> prescriptions = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, patientId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                prescriptions.add(mapResultSetToPrescription(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting prescriptions by patient ID: " + patientId, e);
        }
        return prescriptions;
    }
}