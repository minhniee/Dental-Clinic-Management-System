package DAO;

import context.DBContext;
import model.PatientImage;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PatientImageDAO {
    
    private static final Logger logger = Logger.getLogger(PatientImageDAO.class.getName());
    
    /**
     * Get images by patient ID
     */
    public List<PatientImage> getImagesByPatientId(int patientId) {
        String sql = "SELECT pi.*, u.full_name as uploaded_by_name " +
                    "FROM PatientImages pi " +
                    "LEFT JOIN Users u ON pi.uploaded_by = u.user_id " +
                    "WHERE pi.patient_id = ? ORDER BY pi.uploaded_at DESC";
        List<PatientImage> images = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, patientId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                images.add(mapResultSetToPatientImage(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting images by patient ID: " + patientId, e);
        }
        return images;
    }
    
    /**
     * Get images by record ID
     */
    public List<PatientImage> getImagesByRecordId(int recordId) {
        String sql = "SELECT pi.*, u.full_name as uploaded_by_name " +
                    "FROM PatientImages pi " +
                    "LEFT JOIN Users u ON pi.uploaded_by = u.user_id " +
                    "WHERE pi.record_id = ? ORDER BY pi.uploaded_at DESC";
        List<PatientImage> images = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, recordId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                images.add(mapResultSetToPatientImage(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting images by record ID: " + recordId, e);
        }
        return images;
    }
    
    /**
     * Get image by ID
     */
    public PatientImage getImageById(int imageId) {
        String sql = "SELECT pi.*, u.full_name as uploaded_by_name " +
                    "FROM PatientImages pi " +
                    "LEFT JOIN Users u ON pi.uploaded_by = u.user_id " +
                    "WHERE pi.image_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, imageId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPatientImage(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting image by ID: " + imageId, e);
        }
        return null;
    }
    
    /**
     * Create new patient image
     */
    public boolean createPatientImage(PatientImage image) {
        String sql = "INSERT INTO PatientImages (patient_id, record_id, file_path, image_type, uploaded_by) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setInt(1, image.getPatientId());
            statement.setObject(2, image.getRecordId());
            statement.setString(3, image.getFilePath());
            statement.setString(4, image.getImageType());
            statement.setObject(5, image.getUploadedBy());
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    image.setImageId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating patient image", e);
        }
        return false;
    }
    
    /**
     * Update patient image
     */
    public boolean updatePatientImage(PatientImage image) {
        String sql = "UPDATE PatientImages SET file_path = ?, image_type = ? WHERE image_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, image.getFilePath());
            statement.setString(2, image.getImageType());
            statement.setInt(3, image.getImageId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating patient image: " + image.getImageId(), e);
            return false;
        }
    }
    
    /**
     * Delete patient image
     */
    public boolean deletePatientImage(int imageId) {
        String sql = "DELETE FROM PatientImages WHERE image_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, imageId);
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting patient image: " + imageId, e);
            return false;
        }
    }
    
    /**
     * Map ResultSet to PatientImage object
     */
    private PatientImage mapResultSetToPatientImage(ResultSet rs) throws SQLException {
        PatientImage image = new PatientImage();
        image.setImageId(rs.getInt("image_id"));
        image.setPatientId(rs.getInt("patient_id"));
        
        int recordId = rs.getInt("record_id");
        image.setRecordId(rs.wasNull() ? null : recordId);
        
        image.setFilePath(rs.getString("file_path"));
        image.setImageType(rs.getString("image_type"));
        
        int uploadedBy = rs.getInt("uploaded_by");
        image.setUploadedBy(rs.wasNull() ? null : uploadedBy);
        
        Timestamp uploadedAt = rs.getTimestamp("uploaded_at");
        image.setUploadedAt(uploadedAt != null ? uploadedAt.toLocalDateTime() : null);
        
        // Set uploaded by name if available
        String uploadedByName = rs.getString("uploaded_by_name");
        if (uploadedByName != null && image.getUploadedBy() != null) {
            model.User uploader = new model.User();
            uploader.setUserId(image.getUploadedBy());
            uploader.setFullName(uploadedByName);
            image.setUploader(uploader);
        }
        
        return image;
    }
}
