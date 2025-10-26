package DAO;

import context.DBContext;
import model.StockTransaction;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class StockTransactionDAO {
    private static final Logger logger = Logger.getLogger(StockTransactionDAO.class.getName());

    public List<StockTransaction> getAllTransactions() {
        String sql = "SELECT st.*, ii.name as item_name, u.full_name as performed_by_name " +
                    "FROM StockTransactions st " +
                    "LEFT JOIN InventoryItems ii ON st.item_id = ii.item_id " +
                    "LEFT JOIN Users u ON st.performed_by = u.user_id " +
                    "ORDER BY st.performed_at DESC";
        List<StockTransaction> transactions = new ArrayList<>();

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                transactions.add(mapResultSetToStockTransaction(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting all transactions", e);
        }

        return transactions;
    }

    public List<StockTransaction> getFilteredTransactions(String itemFilter, String typeFilter, String dateFrom, String dateTo) {
        StringBuilder sql = new StringBuilder("SELECT st.*, ii.name as item_name, u.full_name as performed_by_name " +
                "FROM StockTransactions st " +
                "LEFT JOIN InventoryItems ii ON st.item_id = ii.item_id " +
                "LEFT JOIN Users u ON st.performed_by = u.user_id " +
                "WHERE 1=1");

        List<Object> parameters = new ArrayList<>();

        if (itemFilter != null && !itemFilter.trim().isEmpty()) {
            sql.append(" AND st.item_id = ?");
            parameters.add(Integer.parseInt(itemFilter));
        }

        if (typeFilter != null && !typeFilter.trim().isEmpty()) {
            sql.append(" AND st.transaction_type = ?");
            parameters.add(typeFilter);
        }

        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append(" AND CAST(st.performed_at AS DATE) >= ?");
            parameters.add(Date.valueOf(dateFrom));
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            // Add 1 day to dateTo to include the entire day (to 23:59:59)
            Date dateToValue = Date.valueOf(dateTo);
            long timeInMillis = dateToValue.getTime();
            timeInMillis += 86400000; // Add 1 day (24 hours in milliseconds)
            Date dateToEndOfDay = new Date(timeInMillis);
            sql.append(" AND st.performed_at < ?");
            parameters.add(new Timestamp(dateToEndOfDay.getTime()));
        }

        sql.append(" ORDER BY st.performed_at DESC");

        List<StockTransaction> transactions = new ArrayList<>();

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql.toString())) {

            for (int i = 0; i < parameters.size(); i++) {
                statement.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    transactions.add(mapResultSetToStockTransaction(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting filtered transactions", e);
        }

        return transactions;
    }

    public List<StockTransaction> getTransactionsByItemId(int itemId) {
        String sql = "SELECT st.*, ii.name as item_name, u.full_name as performed_by_name " +
                    "FROM StockTransactions st " +
                    "LEFT JOIN InventoryItems ii ON st.item_id = ii.item_id " +
                    "LEFT JOIN Users u ON st.performed_by = u.user_id " +
                    "WHERE st.item_id = ? " +
                    "ORDER BY st.performed_at DESC";
        List<StockTransaction> transactions = new ArrayList<>();

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, itemId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    transactions.add(mapResultSetToStockTransaction(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting transactions by item ID: " + itemId, e);
        }

        return transactions;
    }

    public boolean addTransaction(StockTransaction transaction) {
        String sql = "INSERT INTO StockTransactions (item_id, transaction_type, quantity, performed_by, notes) VALUES (?, ?, ?, ?, ?)";

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, transaction.getItemId());
            statement.setString(2, transaction.getTransactionType());
            statement.setInt(3, transaction.getQuantity());
            statement.setInt(4, transaction.getPerformedBy());
            statement.setString(5, transaction.getNotes());

            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error adding transaction", e);
            return false;
        }
    }

    public StockTransaction getTransactionById(int transactionId) {
        String sql = "SELECT st.*, ii.name as item_name, u.full_name as performed_by_name " +
                    "FROM StockTransactions st " +
                    "LEFT JOIN InventoryItems ii ON st.item_id = ii.item_id " +
                    "LEFT JOIN Users u ON st.performed_by = u.user_id " +
                    "WHERE st.transaction_id = ?";

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, transactionId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToStockTransaction(rs);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting transaction by ID: " + transactionId, e);
        }

        return null;
    }

    public List<StockTransaction> getTransactionsByDateRange(Date startDate, Date endDate) {
        String sql = "SELECT st.*, ii.name as item_name, u.full_name as performed_by_name " +
                    "FROM StockTransactions st " +
                    "LEFT JOIN InventoryItems ii ON st.item_id = ii.item_id " +
                    "LEFT JOIN Users u ON st.performed_by = u.user_id " +
                    "WHERE CAST(st.performed_at AS DATE) BETWEEN ? AND ? " +
                    "ORDER BY st.performed_at DESC";
        List<StockTransaction> transactions = new ArrayList<>();

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setDate(1, startDate);
            statement.setDate(2, endDate);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    transactions.add(mapResultSetToStockTransaction(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting transactions by date range", e);
        }

        return transactions;
    }

    private StockTransaction mapResultSetToStockTransaction(ResultSet rs) throws SQLException {
        StockTransaction transaction = new StockTransaction();
        transaction.setTransactionId(rs.getInt("transaction_id"));
        transaction.setItemId(rs.getInt("item_id"));
        transaction.setTransactionType(rs.getString("transaction_type"));
        transaction.setQuantity(rs.getInt("quantity"));
        transaction.setPerformedBy(rs.getInt("performed_by"));
        transaction.setNotes(rs.getString("notes"));
        
        if (rs.getTimestamp("performed_at") != null) {
            transaction.setPerformedAt(rs.getTimestamp("performed_at").toLocalDateTime());
        }

        // Set additional fields from joins
        transaction.setItemName(rs.getString("item_name"));
        transaction.setPerformedByName(rs.getString("performed_by_name"));

        return transaction;
    }
}
