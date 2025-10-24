package DAO;

import context.DBContext;
import model.TreatmentPlan;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TreatmentPlanDAO {
    
    private static final Logger logger = Logger.getLogger(TreatmentPlanDAO.class.getName());
    
    /**
     * Get treatment plans by record ID
     */
    public List<TreatmentPlan> getTreatmentPlansByRecordId(int recordId) {
        String sql = "SELECT * FROM TreatmentPlans WHERE record_id = ? ORDER BY created_at DESC";
        List<TreatmentPlan> plans = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, recordId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                plans.add(mapResultSetToTreatmentPlan(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting treatment plans by record ID: " + recordId, e);
        }
        return plans;
    }
    
    /**
     * Get treatment plan by ID
     */
    public TreatmentPlan getTreatmentPlanById(int planId) {
        String sql = "SELECT * FROM TreatmentPlans WHERE plan_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, planId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToTreatmentPlan(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting treatment plan by ID: " + planId, e);
        }
        return null;
    }
    
    /**
     * Create new treatment plan
     */
    public boolean createTreatmentPlan(TreatmentPlan plan) {
        String sql = "INSERT INTO TreatmentPlans (record_id, plan_summary, notes, estimated_cost) VALUES (?, ?, ?, ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setInt(1, plan.getRecordId());
            statement.setString(2, plan.getPlanSummary());
            statement.setString(3, plan.getNotes());
            statement.setBigDecimal(4, plan.getEstimatedCost());
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    plan.setPlanId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating treatment plan", e);
        }
        return false;
    }
    
    /**
     * Update treatment plan
     */
    public boolean updateTreatmentPlan(TreatmentPlan plan) {
        String sql = "UPDATE TreatmentPlans SET plan_summary = ?, notes = ?, estimated_cost = ? WHERE plan_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, plan.getPlanSummary());
            statement.setString(2, plan.getNotes());
            statement.setBigDecimal(3, plan.getEstimatedCost());
            statement.setInt(4, plan.getPlanId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating treatment plan: " + plan.getPlanId(), e);
            return false;
        }
    }
    
    /**
     * Delete treatment plan
     */
    public boolean deleteTreatmentPlan(int planId) {
        String sql = "DELETE FROM TreatmentPlans WHERE plan_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, planId);
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting treatment plan: " + planId, e);
            return false;
        }
    }
    
    /**
     * Map ResultSet to TreatmentPlan object
     */
    private TreatmentPlan mapResultSetToTreatmentPlan(ResultSet rs) throws SQLException {
        TreatmentPlan plan = new TreatmentPlan();
        plan.setPlanId(rs.getInt("plan_id"));
        plan.setRecordId(rs.getInt("record_id"));
        plan.setPlanSummary(rs.getString("plan_summary"));
        plan.setNotes(rs.getString("notes"));
        
        BigDecimal estimatedCost = rs.getBigDecimal("estimated_cost");
        plan.setEstimatedCost(estimatedCost);
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        plan.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
        
        return plan;
    }
}