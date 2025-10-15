package DAO;

import context.DBContext;
import model.TreatmentSession;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
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
        String sql = "SELECT * FROM TreatmentSessions WHERE plan_id = ? ORDER BY session_date DESC";
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
    public boolean createTreatmentSession(TreatmentSession treatmentSession) {
        String sql = "INSERT INTO TreatmentSessions (plan_id, session_date, procedure_done, session_cost) VALUES (?, ?, ?, ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setInt(1, treatmentSession.getPlanId());
            statement.setTimestamp(2, Timestamp.valueOf(treatmentSession.getSessionDate()));
            statement.setString(3, treatmentSession.getProcedureDone());
            statement.setBigDecimal(4, treatmentSession.getSessionCost());
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    treatmentSession.setSessionId(generatedKeys.getInt(1));
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
    public boolean updateTreatmentSession(TreatmentSession treatmentSession) {
        String sql = "UPDATE TreatmentSessions SET session_date = ?, procedure_done = ?, session_cost = ? WHERE session_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setTimestamp(1, Timestamp.valueOf(treatmentSession.getSessionDate()));
            statement.setString(2, treatmentSession.getProcedureDone());
            statement.setBigDecimal(3, treatmentSession.getSessionCost());
            statement.setInt(4, treatmentSession.getSessionId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating treatment session: " + treatmentSession.getSessionId(), e);
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
        
        Timestamp sessionDate = rs.getTimestamp("session_date");
        session.setSessionDate(sessionDate != null ? sessionDate.toLocalDateTime() : null);
        
        session.setProcedureDone(rs.getString("procedure_done"));
        
        BigDecimal sessionCost = rs.getBigDecimal("session_cost");
        session.setSessionCost(sessionCost);
        
        return session;
    }
}
