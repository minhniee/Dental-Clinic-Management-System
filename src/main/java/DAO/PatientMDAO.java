package DAO;

import context.DBContext;
import model.Patient;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PatientMDAO {

    private static final Logger logger = Logger.getLogger(PatientMDAO.class.getName());


    public int createPatient(Patient patient) {
        // Check for duplicate phone or email before inserting
        if (patient.getPhone() != null && !patient.getPhone().trim().isEmpty()) {
            Patient existingByPhone = getPatientByPhone(patient.getPhone().trim());
            if (existingByPhone != null) {
                logger.log(Level.WARNING, "Attempted to create patient with existing phone: " + patient.getPhone());
                return -1; // Return -1 to indicate failure
            }
        }
        
        if (patient.getEmail() != null && !patient.getEmail().trim().isEmpty()) {
            Patient existingByEmail = getPatientByEmail(patient.getEmail().trim());
            if (existingByEmail != null) {
                logger.log(Level.WARNING, "Attempted to create patient with existing email: " + patient.getEmail());
                return -1; // Return -1 to indicate failure
            }
        }
        
        // Use conditional SQL based on whether user_id is provided
        String sql;

            sql = "INSERT INTO Patients (full_name, birth_date, gender, phone, email, address, created_at) " +
                  "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setString(1, patient.getFullName());
            statement.setObject(2, patient.getBirthDate());
            statement.setString(3, patient.getGender() != null ? String.valueOf(patient.getGender()) : null);
            statement.setString(4, patient.getPhone());
            statement.setString(5, patient.getEmail());
            statement.setString(6, patient.getAddress());
            statement.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            
            // Only set user_id parameter if it's not null

            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1); // Return the generated patient ID
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating patient", e);
        }
        
        return -1;
    }

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
     * Update patient information
     */
    public boolean updatePatient(Patient patient) {
        String sql = "UPDATE Patients SET full_name = ?, birth_date = ?, gender = ?, " +
                     "phone = ?, email = ?, address = ? WHERE patient_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, patient.getFullName());
            statement.setObject(2, patient.getBirthDate());
            statement.setString(3, patient.getGender() != null ? String.valueOf(patient.getGender()) : null);
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
     * Get all patients with pagination
     */
    public List<Patient> getAllPatients(int offset, int limit) {
        String sql = "SELECT * FROM Patients ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        List<Patient> patients = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, offset);
            statement.setInt(2, limit);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Patient patient = mapResultSetToPatient(rs);
                patients.add(patient);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting all patients", e);
        }
        
        return patients;
    }

    /**
     * Search patients by name, phone, or email
     */
    public List<Patient> searchPatients(String searchTerm) {
        String sql = "SELECT * FROM Patients WHERE " +
                     "full_name LIKE ? OR phone LIKE ? OR email LIKE ? " +
                     "ORDER BY created_at DESC";
        
        List<Patient> patients = new ArrayList<>();
        String searchPattern = "%" + searchTerm + "%";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, searchPattern);
            statement.setString(2, searchPattern);
            statement.setString(3, searchPattern);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Patient patient = mapResultSetToPatient(rs);
                patients.add(patient);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error searching patients: " + searchTerm, e);
        }
        
        return patients;
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
     * Get patient by email
     */
    public Patient getPatientByEmail(String email) {
        String sql = "SELECT * FROM Patients WHERE email = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, email);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPatient(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting patient by email: " + email, e);
        }
        
        return null;
    }

    /**
     * Get total count of patients
     */
    public int getTotalPatientCount() {
        String sql = "SELECT COUNT(*) FROM Patients";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting total patient count", e);
        }
        
        return 0;
    }

    /**
     * Map ResultSet to Patient object
     */
    private Patient mapResultSetToPatient(ResultSet rs) throws SQLException {
        Patient patient = new Patient();
        patient.setPatientId(rs.getInt("patient_id"));
        patient.setFullName(rs.getString("full_name"));
        
        Date birthDate = rs.getDate("birth_date");
        if (birthDate != null) {
            patient.setBirthDate(birthDate.toLocalDate());
        }
        
        String genderStr = rs.getString("gender");
        if (genderStr != null && !genderStr.isEmpty()) {
            patient.setGender(genderStr);
        }
        
        patient.setPhone(rs.getString("phone"));
        patient.setEmail(rs.getString("email"));
        patient.setAddress(rs.getString("address"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            patient.setCreatedAt(createdAt.toLocalDateTime());
        }
        

        
        return patient;
    }
}
