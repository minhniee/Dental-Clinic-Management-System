package DAO;

import context.DBContext;
import model.Patient;
import model.User;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
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
     * Get patient by user ID
     */
    public Patient getPatientByUserId(int userId) {
        String sql = "SELECT * FROM Patients WHERE user_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, userId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPatient(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting patient by user ID: " + userId, e);
        }
        return null;
    }

    /**
     * Get all patients
     */
    public List<Patient> getAllPatients() {
        String sql = "SELECT * FROM Patients ORDER BY full_name";
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
     * Get patients who haven't been examined today
     */
    public List<Patient> getPatientsNotExaminedToday() {
        String sql = "SELECT DISTINCT p.* FROM Patients p " +
                    "LEFT JOIN MedicalRecords mr ON p.patient_id = mr.patient_id " +
                    "AND CAST(mr.created_at AS DATE) = CAST(GETDATE() AS DATE) " +
                    "WHERE mr.patient_id IS NULL " +
                    "ORDER BY p.full_name";
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
     * Create new patient
     */
    public boolean createPatient(Patient patient) {
        String sql = "INSERT INTO Patients (full_name, birth_date, gender, phone, email, address, user_id) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setString(1, patient.getFullName());
            statement.setDate(2, patient.getBirthDate() != null ? Date.valueOf(patient.getBirthDate()) : null);
            statement.setString(3, patient.getGender() != null ? patient.getGender().toString() : null);
            statement.setString(4, patient.getPhone());
            statement.setString(5, patient.getEmail());
            statement.setString(6, patient.getAddress());
            statement.setObject(7, patient.getUserId());
            
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
                    "phone = ?, email = ?, address = ?, user_id = ? WHERE patient_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, patient.getFullName());
            statement.setDate(2, patient.getBirthDate() != null ? Date.valueOf(patient.getBirthDate()) : null);
            statement.setString(3, patient.getGender() != null ? patient.getGender().toString() : null);
            statement.setString(4, patient.getPhone());
            statement.setString(5, patient.getEmail());
            statement.setString(6, patient.getAddress());
            statement.setObject(7, patient.getUserId());
            statement.setInt(8, patient.getPatientId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating patient: " + patient.getPatientId(), e);
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
        patient.setGender(gender != null ? gender.charAt(0) : null);
        
        patient.setPhone(rs.getString("phone"));
        patient.setEmail(rs.getString("email"));
        patient.setAddress(rs.getString("address"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        patient.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
        
        int userId = rs.getInt("user_id");
        patient.setUserId(rs.wasNull() ? null : userId);
        
        return patient;
    }
}
