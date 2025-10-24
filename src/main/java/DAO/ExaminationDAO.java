package DAO;

import context.DBContext;
import model.Examination;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ExaminationDAO {
    
    private static final Logger logger = Logger.getLogger(ExaminationDAO.class.getName());
    
    /**
     * Get examinations by record ID
     */
    public List<Examination> getExaminationsByRecordId(int recordId) {
        String sql = "SELECT * FROM Examinations WHERE record_id = ? ORDER BY created_at DESC";
        List<Examination> examinations = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, recordId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                examinations.add(mapResultSetToExamination(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting examinations by record ID: " + recordId, e);
        }
        return examinations;
    }
    
    /**
     * Get examination by ID
     */
    public Examination getExaminationById(int examId) {
        String sql = "SELECT * FROM Examinations WHERE exam_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, examId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToExamination(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting examination by ID: " + examId, e);
        }
        return null;
    }
    
    /**
     * Create new examination
     */
    public boolean createExamination(Examination examination) {
        String sql = "INSERT INTO Examinations (record_id, findings, diagnosis) VALUES (?, ?, ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setInt(1, examination.getRecordId());
            statement.setString(2, examination.getFindings());
            statement.setString(3, examination.getDiagnosis());
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    examination.setExamId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating examination", e);
        }
        return false;
    }
    
    /**
     * Update examination
     */
    public boolean updateExamination(Examination examination) {
        String sql = "UPDATE Examinations SET findings = ?, diagnosis = ? WHERE exam_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, examination.getFindings());
            statement.setString(2, examination.getDiagnosis());
            statement.setInt(3, examination.getExamId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating examination: " + examination.getExamId(), e);
            return false;
        }
    }
    
    /**
     * Delete examination
     */
    public boolean deleteExamination(int examId) {
        String sql = "DELETE FROM Examinations WHERE exam_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, examId);
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting examination: " + examId, e);
            return false;
        }
    }
    
    /**
     * Map ResultSet to Examination object
     */
    private Examination mapResultSetToExamination(ResultSet rs) throws SQLException {
        Examination examination = new Examination();
        examination.setExamId(rs.getInt("exam_id"));
        examination.setRecordId(rs.getInt("record_id"));
        examination.setFindings(rs.getString("findings"));
        examination.setDiagnosis(rs.getString("diagnosis"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        examination.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
        
        return examination;
    }
}