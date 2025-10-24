package DAO;

import context.DBContext;
import model.TreatmentSession;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TreatmentSessionDAO {
    
    private static final Logger logger = Logger.getLogger(TreatmentSessionDAO.class.getName());
    
    /**
     * Get treatment sessions by plan ID
     */
    public List<TreatmentSession> getSessionsByPlanId(int planId) {
        String sql = "SELECT * FROM TreatmentSessions WHERE plan_id = ? ORDER BY session_date ASC";
        List<TreatmentSession> sessions = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, planId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                sessions.add(mapResultSetToTreatmentSession(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting treatment sessions by plan ID: " + planId, e);
        }
        return sessions;
    }
    
    /**
     * Get treatment session by ID
     */
    public TreatmentSession getSessionById(int sessionId) {
        String sql = "SELECT * FROM TreatmentSessions WHERE session_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, sessionId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToTreatmentSession(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting treatment session by ID: " + sessionId, e);
        }
        return null;
    }
    
    /**
     * Create new treatment session
     */
    public boolean createTreatmentSession(TreatmentSession session) {
        String sql = "INSERT INTO TreatmentSessions (plan_id, session_date, procedure_done, session_cost) VALUES (?, ?, ?, ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setInt(1, session.getPlanId());
            statement.setTimestamp(2, Timestamp.valueOf(session.getSessionDate().atStartOfDay()));
            statement.setString(3, session.getProcedureDone());
            statement.setBigDecimal(4, session.getSessionCost());
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    session.setSessionId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating treatment session", e);
        }
        return false;
    }
    
    /**
     * Update treatment session
     */
    public boolean updateTreatmentSession(TreatmentSession session) {
        String sql = "UPDATE TreatmentSessions SET session_date = ?, procedure_done = ?, session_cost = ? WHERE session_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setTimestamp(1, Timestamp.valueOf(session.getSessionDate().atStartOfDay()));
            statement.setString(2, session.getProcedureDone());
            statement.setBigDecimal(3, session.getSessionCost());
            statement.setInt(4, session.getSessionId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating treatment session: " + session.getSessionId(), e);
            return false;
        }
    }
    
    /**
     * Delete treatment session
     */
    public boolean deleteTreatmentSession(int sessionId) {
        String sql = "DELETE FROM TreatmentSessions WHERE session_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, sessionId);
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting treatment session: " + sessionId, e);
            return false;
        }
    }
    
    /**
     * Map ResultSet to TreatmentSession object
     */
    private TreatmentSession mapResultSetToTreatmentSession(ResultSet rs) throws SQLException {
        TreatmentSession session = new TreatmentSession();
        session.setSessionId(rs.getInt("session_id"));
        session.setPlanId(rs.getInt("plan_id"));
        session.setProcedureDone(rs.getString("procedure_done"));
        // session.setNotes(rs.getString("notes")); // Commented out until notes column is added to DB
        
        BigDecimal sessionCost = rs.getBigDecimal("session_cost");
        session.setSessionCost(sessionCost);
        
        Timestamp sessionDate = rs.getTimestamp("session_date");
        session.setSessionDate(sessionDate != null ? sessionDate.toLocalDateTime().toLocalDate() : null);
        
        return session;
    }
    
    /**
     * Get treatment sessions by record ID
     */
    public List<TreatmentSession> getTreatmentSessionsByRecordId(int recordId) {
        String sql = "SELECT ts.* FROM TreatmentSessions ts " +
                    "INNER JOIN TreatmentPlans tp ON ts.plan_id = tp.plan_id " +
                    "WHERE tp.record_id = ? ORDER BY ts.session_date ASC";
        List<TreatmentSession> sessions = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, recordId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                sessions.add(mapResultSetToTreatmentSession(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting treatment sessions by record ID: " + recordId, e);
        }
        return sessions;
    }
}