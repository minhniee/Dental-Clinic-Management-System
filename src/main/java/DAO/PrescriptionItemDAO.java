package DAO;

import context.DBContext;
import model.PrescriptionItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PrescriptionItemDAO {

    private static final Logger logger = Logger.getLogger(PrescriptionItemDAO.class.getName());

    /**
     * Get prescription items by prescription ID
     */
    public List<PrescriptionItem> getItemsByPrescriptionId(int prescriptionId) {
        String sql = "SELECT * FROM PrescriptionItems WHERE prescription_id = ? ORDER BY item_id";
        List<PrescriptionItem> items = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, prescriptionId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                items.add(mapResultSetToPrescriptionItem(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting prescription items by prescription ID: " + prescriptionId, e);
        }
        return items;
    }

    /**
     * Get prescription item by ID
     */
    public PrescriptionItem getItemById(int itemId) {
        String sql = "SELECT * FROM PrescriptionItems WHERE item_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, itemId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPrescriptionItem(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting prescription item by ID: " + itemId, e);
        }
        return null;
    }

    /**
     * Create new prescription item
     */
    public boolean createPrescriptionItem(PrescriptionItem prescriptionItem) {
        String sql = "INSERT INTO PrescriptionItems (prescription_id, medication_name, dosage, duration, instructions) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setInt(1, prescriptionItem.getPrescriptionId());
            statement.setString(2, prescriptionItem.getMedicationName());
            statement.setString(3, prescriptionItem.getDosage());
            statement.setString(4, prescriptionItem.getDuration());
            statement.setString(5, prescriptionItem.getInstructions());
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    prescriptionItem.setItemId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating prescription item", e);
        }
        return false;
    }

    /**
     * Create multiple prescription items for a prescription
     */
    public boolean addItemsToPrescription(int prescriptionId, List<PrescriptionItem> items) {
        String sql = "INSERT INTO PrescriptionItems (prescription_id, medication_name, dosage, duration, instructions) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            for (PrescriptionItem item : items) {
                statement.setInt(1, prescriptionId);
                statement.setString(2, item.getMedicationName());
                statement.setString(3, item.getDosage());
                statement.setString(4, item.getDuration());
                statement.setString(5, item.getInstructions());
                statement.addBatch();
            }
            
            int[] results = statement.executeBatch();
            return results.length == items.size();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error adding items to prescription: " + prescriptionId, e);
            return false;
        }
    }

    /**
     * Update prescription item
     */
    public boolean updatePrescriptionItem(PrescriptionItem prescriptionItem) {
        String sql = "UPDATE PrescriptionItems SET medication_name = ?, dosage = ?, duration = ?, instructions = ? WHERE item_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, prescriptionItem.getMedicationName());
            statement.setString(2, prescriptionItem.getDosage());
            statement.setString(3, prescriptionItem.getDuration());
            statement.setString(4, prescriptionItem.getInstructions());
            statement.setInt(5, prescriptionItem.getItemId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating prescription item: " + prescriptionItem.getItemId(), e);
            return false;
        }
    }

    /**
     * Delete prescription item
     */
    public boolean deletePrescriptionItem(int itemId) {
        String sql = "DELETE FROM PrescriptionItems WHERE item_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, itemId);
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting prescription item: " + itemId, e);
            return false;
        }
    }

    /**
     * Delete all items for a prescription
     */
    public boolean deleteItemsByPrescriptionId(int prescriptionId) {
        String sql = "DELETE FROM PrescriptionItems WHERE prescription_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, prescriptionId);
            int rowsAffected = statement.executeUpdate();
            return rowsAffected >= 0; // 0 is also valid if no items exist
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting items by prescription ID: " + prescriptionId, e);
            return false;
        }
    }

    /**
     * Map ResultSet to PrescriptionItem object
     */
    private PrescriptionItem mapResultSetToPrescriptionItem(ResultSet rs) throws SQLException {
        PrescriptionItem item = new PrescriptionItem();
        item.setItemId(rs.getInt("item_id"));
        item.setPrescriptionId(rs.getInt("prescription_id"));
        item.setMedicationName(rs.getString("medication_name"));
        item.setDosage(rs.getString("dosage"));
        item.setDuration(rs.getString("duration"));
        item.setInstructions(rs.getString("instructions"));
        
        return item;
    }
}
