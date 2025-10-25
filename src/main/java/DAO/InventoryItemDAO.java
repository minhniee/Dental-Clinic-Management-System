package DAO;

import context.DBContext;
import model.InventoryItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class InventoryItemDAO {
    private static final Logger logger = Logger.getLogger(InventoryItemDAO.class.getName());

    public List<InventoryItem> getAllInventoryItems() {
        String sql = "SELECT * FROM InventoryItems ORDER BY name";
        List<InventoryItem> items = new ArrayList<>();

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                items.add(mapResultSetToInventoryItem(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting all inventory items", e);
        }

        return items;
    }

    public InventoryItem getInventoryItemById(int itemId) {
        String sql = "SELECT * FROM InventoryItems WHERE item_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, itemId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToInventoryItem(rs);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting inventory item by ID: " + itemId, e);
        }

        return null;
    }

    public InventoryItem getItemByName(String name) {
        String sql = "SELECT * FROM InventoryItems WHERE name = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, name);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToInventoryItem(rs);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting inventory item by name: " + name, e);
        }

        return null;
    }

    public boolean addInventoryItem(InventoryItem item) {
        String sql = "INSERT INTO InventoryItems (name, unit, quantity, min_stock) VALUES (?, ?, ?, ?)";

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, item.getName());
            statement.setString(2, item.getUnit());
            statement.setInt(3, item.getQuantity());
            statement.setInt(4, item.getMinStock());

            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            if (e.getMessage().contains("UNIQUE KEY constraint") || e.getMessage().contains("duplicate key")) {
                logger.log(Level.WARNING, "Duplicate inventory item name: " + item.getName());
                return false; // Return false instead of throwing exception
            }
            logger.log(Level.SEVERE, "Error adding inventory item", e);
            return false;
        }
    }

    public boolean updateInventoryItem(InventoryItem item) {
        String sql = "UPDATE InventoryItems SET name = ?, unit = ?, min_stock = ? WHERE item_id = ?";

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, item.getName());
            statement.setString(2, item.getUnit());
            statement.setInt(3, item.getMinStock());
            statement.setInt(4, item.getItemId());

            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating inventory item", e);
            return false;
        }
    }

    public boolean updateQuantity(int itemId, int quantityChange) {
        String sql = "UPDATE InventoryItems SET quantity = quantity + ? WHERE item_id = ?";

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, quantityChange);
            statement.setInt(2, itemId);

            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating quantity for item: " + itemId, e);
            return false;
        }
    }

    public boolean deleteInventoryItem(int itemId) {
        String sql = "DELETE FROM InventoryItems WHERE item_id = ?";

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, itemId);

            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting inventory item: " + itemId, e);
            return false;
        }
    }

    public List<InventoryItem> getLowStockItems() {
        String sql = "SELECT * FROM InventoryItems WHERE quantity <= min_stock ORDER BY (quantity - min_stock)";
        List<InventoryItem> items = new ArrayList<>();

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                items.add(mapResultSetToInventoryItem(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting low stock items", e);
        }

        return items;
    }

    private InventoryItem mapResultSetToInventoryItem(ResultSet rs) throws SQLException {
        InventoryItem item = new InventoryItem();
        item.setItemId(rs.getInt("item_id"));
        item.setName(rs.getString("name"));
        item.setUnit(rs.getString("unit"));
        item.setQuantity(rs.getInt("quantity"));
        item.setMinStock(rs.getInt("min_stock"));
        
        if (rs.getTimestamp("created_at") != null) {
            item.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }

        return item;
    }
}
