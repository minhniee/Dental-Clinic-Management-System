package DAO;

import context.DBContext;
import model.Payment;

import java.sql.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PaymentDAO {

    private static final Logger logger = Logger.getLogger(PaymentDAO.class.getName());

    /**
     * Create a new payment
     */
    public int createPayment(Payment payment) {
        String sql = "INSERT INTO Payments (invoice_id, amount, method, paid_at) VALUES (?, ?, ?, ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setInt(1, payment.getInvoiceId());
            statement.setBigDecimal(2, payment.getAmount());
            statement.setString(3, payment.getMethod());
            statement.setTimestamp(4, Timestamp.valueOf(payment.getPaidAt() != null ? payment.getPaidAt() : LocalDateTime.now()));
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int paymentId = generatedKeys.getInt(1);
                    logger.info("Created payment with ID: " + paymentId);
                    
                    // Update invoice status based on total payments
                    updateInvoiceStatusBasedOnPayments(connection, payment.getInvoiceId());
                    
                    return paymentId;
                }
            }
            return -1;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating payment", e);
            return -1;
        }
    }

    /**
     * Get payment by ID
     */
    public Payment getPaymentById(int paymentId) {
        String sql = "SELECT * FROM Payments WHERE payment_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, paymentId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPayment(rs);
            }
            return null;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting payment by ID: " + paymentId, e);
            return null;
        }
    }

    /**
     * Get all payments for an invoice
     */
    public List<Payment> getPaymentsByInvoice(int invoiceId) {
        String sql = "SELECT * FROM Payments WHERE invoice_id = ? ORDER BY paid_at DESC";
        
        List<Payment> payments = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, invoiceId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Payment payment = mapResultSetToPayment(rs);
                payments.add(payment);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting payments for invoice: " + invoiceId, e);
        }
        
        return payments;
    }

    /**
     * Get total amount paid for an invoice
     */
    public BigDecimal getTotalPaidAmount(int invoiceId) {
        String sql = "SELECT SUM(amount) as total_paid FROM Payments WHERE invoice_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, invoiceId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal("total_paid");
                return total != null ? total : BigDecimal.ZERO;
            }
            return BigDecimal.ZERO;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting total paid amount for invoice: " + invoiceId, e);
            return BigDecimal.ZERO;
        }
    }

    /**
     * Get recent payments
     */
    public List<Payment> getRecentPayments(int limit) {
        String sql = "SELECT TOP (?) p.*, i.patient_id FROM Payments p " +
                     "LEFT JOIN Invoices i ON p.invoice_id = i.invoice_id " +
                     "ORDER BY p.paid_at DESC";
        
        List<Payment> payments = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, limit);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Payment payment = mapResultSetToPayment(rs);
                payments.add(payment);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting recent payments", e);
        }
        
        return payments;
    }

    /**
     * Delete payment
     */
    public boolean deletePayment(int paymentId) {
        String sql = "DELETE FROM Payments WHERE payment_id = ?";
        
        try (Connection connection = new DBContext().getConnection()) {
            // Get invoice ID before deleting
            String getInvoiceIdSql = "SELECT invoice_id FROM Payments WHERE payment_id = ?";
            int invoiceId = -1;
            
            try (PreparedStatement getInvoiceStmt = connection.prepareStatement(getInvoiceIdSql)) {
                getInvoiceStmt.setInt(1, paymentId);
                ResultSet rs = getInvoiceStmt.executeQuery();
                if (rs.next()) {
                    invoiceId = rs.getInt("invoice_id");
                }
            }
            
            // Delete payment
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setInt(1, paymentId);
                int rowsAffected = statement.executeUpdate();
                
                if (rowsAffected > 0 && invoiceId > 0) {
                    // Update invoice status after payment deletion
                    updateInvoiceStatusBasedOnPayments(connection, invoiceId);
                    return true;
                }
                return false;
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting payment: " + paymentId, e);
            return false;
        }
    }

    /**
     * Update invoice status based on total payments
     */
    private void updateInvoiceStatusBasedOnPayments(Connection connection, int invoiceId) throws SQLException {
        // Get invoice details first
        String invoiceSql = "SELECT net_amount FROM Invoices WHERE invoice_id = ?";
        BigDecimal netAmount;
        
        try (PreparedStatement invoiceStmt = connection.prepareStatement(invoiceSql)) {
            invoiceStmt.setInt(1, invoiceId);
            ResultSet rs = invoiceStmt.executeQuery();
            if (rs.next()) {
                netAmount = rs.getBigDecimal("net_amount");
            } else {
                return; // Invoice not found
            }
        }
        
        // Get total paid amount
        BigDecimal totalPaid = getTotalPaidAmount(invoiceId);
        
        // Determine new status
        String newStatus;
        if (totalPaid.compareTo(netAmount) >= 0) {
            newStatus = "PAID";
        } else if (totalPaid.compareTo(BigDecimal.ZERO) > 0) {
            newStatus = "PARTIAL";
        } else {
            newStatus = "UNPAID";
        }
        
        // Update invoice status
        String updateSql = "UPDATE Invoices SET status = ? WHERE invoice_id = ?";
        try (PreparedStatement updateStmt = connection.prepareStatement(updateSql)) {
            updateStmt.setString(1, newStatus);
            updateStmt.setInt(2, invoiceId);
            updateStmt.executeUpdate();
        }
    }

    /**
     * Helper method to update invoice status (public version)
     */
    public boolean updateInvoiceStatusBasedOnPayments(int invoiceId) {
        try (Connection connection = new DBContext().getConnection()) {
            updateInvoiceStatusBasedOnPayments(connection, invoiceId);
            return true;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating invoice status for: " + invoiceId, e);
            return false;
        }
    }

    /**
     * Get payments by date range
     */
    public List<Payment> getPaymentsByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        String sql = "SELECT p.*, i.patient_id FROM Payments p " +
                     "LEFT JOIN Invoices i ON p.invoice_id = i.invoice_id " +
                     "WHERE p.paid_at >= ? AND p.paid_at <= ? " +
                     "ORDER BY p.paid_at DESC";
        
        List<Payment> payments = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setTimestamp(1, Timestamp.valueOf(startDate));
            statement.setTimestamp(2, Timestamp.valueOf(endDate));
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Payment payment = mapResultSetToPayment(rs);
                payments.add(payment);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting payments by date range", e);
        }
        
        return payments;
    }

    /**
     * Map ResultSet to Payment object
     */
    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(rs.getInt("payment_id"));
        payment.setInvoiceId(rs.getInt("invoice_id"));
        payment.setAmount(rs.getBigDecimal("amount"));
        payment.setMethod(rs.getString("method"));
        
        Timestamp paidAt = rs.getTimestamp("paid_at");
        if (paidAt != null) {
            payment.setPaidAt(paidAt.toLocalDateTime());
        }
        
        return payment;
    }
}
