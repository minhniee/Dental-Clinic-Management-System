package DAO;

import context.DBContext;
import model.PatientFile;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PatientFileDAO {

    private static final Logger logger = Logger.getLogger(PatientFileDAO.class.getName());

    /**
     * Get files by patient ID
     */
    public List<PatientFile> getFilesByPatientId(int patientId) {
        String sql = "SELECT * FROM PatientFiles WHERE patient_id = ? ORDER BY uploaded_at DESC";
        List<PatientFile> files = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, patientId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                files.add(mapResultSetToPatientFile(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting files by patient ID: " + patientId, e);
        }
        return files;
    }

    /**
     * Get file by ID
     */
    public PatientFile getFileById(int fileId) {
        String sql = "SELECT * FROM PatientFiles WHERE file_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, fileId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPatientFile(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting file by ID: " + fileId, e);
        }
        return null;
    }

    /**
     * Create new patient file
     */
    public boolean createPatientFile(PatientFile patientFile) {
        String sql = "INSERT INTO PatientFiles (patient_id, content) VALUES (?, ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setInt(1, patientFile.getPatientId());
            statement.setString(2, patientFile.getContent());
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    patientFile.setFileId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating patient file", e);
        }
        return false;
    }

    /**
     * Update patient file
     */
    public boolean updatePatientFile(PatientFile patientFile) {
        String sql = "UPDATE PatientFiles SET content = ? WHERE file_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, patientFile.getContent());
            statement.setInt(2, patientFile.getFileId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating patient file: " + patientFile.getFileId(), e);
            return false;
        }
    }

    /**
     * Delete patient file
     */
    public boolean deletePatientFile(int fileId) {
        String sql = "DELETE FROM PatientFiles WHERE file_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, fileId);
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting patient file: " + fileId, e);
            return false;
        }
    }

    /**
     * Map ResultSet to PatientFile object
     */
    private PatientFile mapResultSetToPatientFile(ResultSet rs) throws SQLException {
        PatientFile patientFile = new PatientFile();
        patientFile.setFileId(rs.getInt("file_id"));
        patientFile.setPatientId(rs.getInt("patient_id"));
        patientFile.setContent(rs.getString("content"));
        
        Timestamp uploadedAt = rs.getTimestamp("uploaded_at");
        patientFile.setUploadedAt(uploadedAt != null ? uploadedAt.toLocalDateTime() : null);
        
        return patientFile;
    }
}
