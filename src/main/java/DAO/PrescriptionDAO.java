package DAO;

import context.DBContext;
import model.Prescription;
import model.Patient;
import model.User;

import java.sql.*;
import java.time.LocalDateTime;
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
        String sql = "SELECT p.*, pt.full_name as patient_name, u.full_name as dentist_name " +
                    "FROM Prescriptions p " +
                    "LEFT JOIN Patients pt ON p.patient_id = pt.patient_id " +
                    "LEFT JOIN Users u ON p.dentist_id = u.user_id " +
                    "WHERE p.patient_id = ? " +
                    "ORDER BY p.created_at DESC";
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
        String sql = "SELECT p.*, pt.full_name as patient_name, u.full_name as dentist_name " +
                    "FROM Prescriptions p " +
                    "LEFT JOIN Patients pt ON p.patient_id = pt.patient_id " +
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
     * Get all prescriptions
     */
    public List<Prescription> getAllPrescriptions() {
        String sql = "SELECT p.*, pt.full_name as patient_name, u.full_name as dentist_name " +
                    "FROM Prescriptions p " +
                    "LEFT JOIN Patients pt ON p.patient_id = pt.patient_id " +
                    "LEFT JOIN Users u ON p.dentist_id = u.user_id " +
                    "ORDER BY p.created_at DESC";
        List<Prescription> prescriptions = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            
            while (rs.next()) {
                prescriptions.add(mapResultSetToPrescription(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting all prescriptions", e);
        }
        return prescriptions;
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
        
        // Set patient information if available
        String patientName = rs.getString("patient_name");
        if (patientName != null) {
            Patient patient = new Patient();
            patient.setPatientId(prescription.getPatientId());
            patient.setFullName(patientName);
            prescription.setPatient(patient);
        }
        
        // Set dentist information if available
        String dentistName = rs.getString("dentist_name");
        if (dentistName != null && prescription.getDentistId() != null) {
            User dentist = new User();
            dentist.setUserId(prescription.getDentistId());
            dentist.setFullName(dentistName);
            prescription.setDentist(dentist);
        }
        
        return prescription;
    }
}
