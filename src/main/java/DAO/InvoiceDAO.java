package DAO;

import context.DBContext;
import model.Invoice;
import model.InvoiceItem;
import model.Patient;
import model.Appointment;
import model.Service;

import java.sql.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class InvoiceDAO {

    private static final Logger logger = Logger.getLogger(InvoiceDAO.class.getName());

    /**
     * Create a new invoice
     */
    public int createInvoice(Invoice invoice) {
        String sql = "INSERT INTO Invoices (patient_id, appointment_id, total_amount, discount_amount, status, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setInt(1, invoice.getPatientId());
            statement.setObject(2, invoice.getAppointmentId(), Types.INTEGER);
            statement.setBigDecimal(3, invoice.getTotalAmount() != null ? invoice.getTotalAmount() : BigDecimal.ZERO);
            statement.setBigDecimal(4, invoice.getDiscountAmount() != null ? invoice.getDiscountAmount() : BigDecimal.ZERO);
            statement.setString(5, invoice.getStatus() != null ? invoice.getStatus() : "UNPAID");
            statement.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now()));
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int invoiceId = generatedKeys.getInt(1);
                    logger.info("Created invoice with ID: " + invoiceId);
                    return invoiceId;
                }
            }
            return -1;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating invoice", e);
            return -1;
        }
    }

    /**
     * Get invoice by appointment ID
     */
    public Invoice getInvoiceByAppointment(int appointmentId) {
        String sql = "SELECT * FROM Invoices WHERE appointment_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, appointmentId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToInvoice(rs);
            }
            return null;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting invoice by appointment ID: " + appointmentId, e);
            return null;
        }
    }

    /**
     * Get invoice by ID with items
     */
    public Invoice getInvoiceById(int invoiceId) {
        String sql = "SELECT i.*, p.full_name as patient_name, p.phone as patient_phone, p.email as patient_email, " +
                     "a.appointment_date, a.status as appointment_status, " +
                     "u.full_name as dentist_name, s.name as service_name " +
                     "FROM Invoices i " +
                     "LEFT JOIN Patients p ON i.patient_id = p.patient_id " +
                     "LEFT JOIN Appointments a ON i.appointment_id = a.appointment_id " +
                     "LEFT JOIN Users u ON a.dentist_id = u.user_id " +
                     "LEFT JOIN Services s ON a.service_id = s.service_id " +
                     "WHERE i.invoice_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, invoiceId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                Invoice invoice = mapResultSetToInvoice(rs);
                invoice.setItems(getInvoiceItems(invoiceId));
                
                // Set patient object
                if (rs.getString("patient_name") != null) {
                    Patient patient = new Patient();
                    patient.setPatientId(rs.getInt("patient_id"));
                    patient.setFullName(rs.getString("patient_name"));
                    patient.setPhone(rs.getString("patient_phone"));
                    patient.setEmail(rs.getString("patient_email"));
                    invoice.setPatient(patient);
                }
                
                // Set appointment object if exists
                if (rs.getInt("appointment_id") > 0) {
                    Appointment appointment = new Appointment();
                    appointment.setAppointmentId(rs.getInt("appointment_id"));
                    Timestamp appointmentDate = rs.getTimestamp("appointment_date");
                    if (appointmentDate != null) {
                        appointment.setAppointmentDate(appointmentDate.toLocalDateTime());
                    }
                    appointment.setStatus(rs.getString("appointment_status"));
                    
                    // Set dentist info
                    if (rs.getString("dentist_name") != null) {
                        model.User dentist = new model.User();
                        dentist.setFullName(rs.getString("dentist_name"));
                        appointment.setDentist(dentist);
                    }
                    
                    // Set service info
                    if (rs.getString("service_name") != null) {
                        Service service = new Service();
                        service.setName(rs.getString("service_name"));
                        appointment.setService(service);
                    }
                    
                    invoice.setAppointment(appointment);
                }
                
                return invoice;
            }
            return null;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting invoice by ID: " + invoiceId, e);
            return null;
        }
    }

    /**
     * Get invoices by patient ID
     */
    public List<Invoice> getInvoicesByPatient(int patientId) {
        String sql = "SELECT i.*, p.full_name as patient_name, p.phone as patient_phone " +
                     "FROM Invoices i " +
                     "LEFT JOIN Patients p ON i.patient_id = p.patient_id " +
                     "WHERE i.patient_id = ? ORDER BY i.created_at DESC";
        
        List<Invoice> invoices = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, patientId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Invoice invoice = mapResultSetToInvoice(rs);
                invoices.add(invoice);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting invoices for patient: " + patientId, e);
        }
        
        return invoices;
    }

    /**
     * Get all recent invoices
     */
    public List<Invoice> getRecentInvoices(int limit) {
        String sql = "SELECT TOP (?) i.*, p.full_name as patient_name, p.phone as patient_phone " +
                     "FROM Invoices i " +
                     "LEFT JOIN Patients p ON i.patient_id = p.patient_id " +
                     "ORDER BY i.created_at DESC";
        
        List<Invoice> invoices = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, limit);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Invoice invoice = mapResultSetToInvoice(rs);
                invoices.add(invoice);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting recent invoices", e);
        }
        
        return invoices;
    }

    /**
     * Update invoice status
     */
    public boolean updateInvoiceStatus(int invoiceId, String status) {
        String sql = "UPDATE Invoices SET status = ? WHERE invoice_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, status);
            statement.setInt(2, invoiceId);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating invoice status: " + invoiceId, e);
            return false;
        }
    }

    /**
     * Update invoice total amounts
     */
    public boolean updateInvoiceAmounts(int invoiceId, BigDecimal totalAmount, BigDecimal discountAmount) {
        String sql = "UPDATE Invoices SET total_amount = ?, discount_amount = ? WHERE invoice_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setBigDecimal(1, totalAmount);
            statement.setBigDecimal(2, discountAmount);
            statement.setInt(3, invoiceId);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating invoice amounts: " + invoiceId, e);
            return false;
        }
    }

    /**
     * Add item to invoice
     */
    public boolean addInvoiceItem(int invoiceId, InvoiceItem item) {
        // First check if item already exists for this service
        String checkSql = "SELECT item_id FROM InvoiceItems WHERE invoice_id = ? AND service_id = ?";
        String updateSql = "UPDATE InvoiceItems SET quantity = quantity + ?, total_price = quantity * unit_price WHERE invoice_id = ? AND service_id = ?";
        String insertSql = "INSERT INTO InvoiceItems (invoice_id, service_id, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection connection = new DBContext().getConnection()) {
            connection.setAutoCommit(false);
            
            try {
                // Check if item exists
                try (PreparedStatement checkStmt = connection.prepareStatement(checkSql)) {
                    checkStmt.setInt(1, invoiceId);
                    checkStmt.setInt(2, item.getServiceId());
                    ResultSet rs = checkStmt.executeQuery();
                    
                    if (rs.next()) {
                        // Update existing item quantity
                        try (PreparedStatement updateStmt = connection.prepareStatement(updateSql)) {
                            updateStmt.setInt(1, item.getQuantity());
                            updateStmt.setInt(2, invoiceId);
                            updateStmt.setInt(3, item.getServiceId());
                            updateStmt.executeUpdate();
                        }
                    } else {
                        // Insert new item
                        try (PreparedStatement insertStmt = connection.prepareStatement(insertSql)) {
                            insertStmt.setInt(1, invoiceId);
                            insertStmt.setInt(2, item.getServiceId());
                            insertStmt.setInt(3, item.getQuantity());
                            insertStmt.setBigDecimal(4, item.getUnitPrice());
                            insertStmt.setBigDecimal(5, item.getTotalPrice());
                            insertStmt.executeUpdate();
                        }
                    }
                }
                
                // Recalculate invoice total
                recalculateInvoiceTotal(connection, invoiceId);
                connection.commit();
                return true;
                
            } catch (SQLException e) {
                connection.rollback();
                throw e;
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error adding invoice item", e);
            return false;
        }
    }

    /**
     * Get invoice items
     */
    public List<InvoiceItem> getInvoiceItems(int invoiceId) {
        String sql = "SELECT ii.*, s.name as service_name, s.description as service_description " +
                     "FROM InvoiceItems ii " +
                     "LEFT JOIN Services s ON ii.service_id = s.service_id " +
                     "WHERE ii.invoice_id = ?";
        
        List<InvoiceItem> items = new ArrayList<>();
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, invoiceId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                InvoiceItem item = mapResultSetToInvoiceItem(rs);
                items.add(item);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting invoice items: " + invoiceId, e);
        }
        
        return items;
    }

    /**
     * Delete invoice item
     */
    public boolean deleteInvoiceItem(int itemId) {
        String sql = "DELETE FROM InvoiceItems WHERE item_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, itemId);
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                // Get invoice ID to recalculate total
                String getInvoiceIdSql = "SELECT invoice_id FROM InvoiceItems WHERE item_id = ?";
                try (PreparedStatement getInvoiceStmt = connection.prepareStatement(getInvoiceIdSql)) {
                    getInvoiceStmt.setInt(1, itemId);
                    ResultSet rs = getInvoiceStmt.executeQuery();
                    if (rs.next()) {
                        recalculateInvoiceTotal(connection, rs.getInt("invoice_id"));
                    }
                }
                return true;
            }
            return false;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting invoice item: " + itemId, e);
            return false;
        }
    }

    /**
     * Recalculate invoice total based on items
     */
    private void recalculateInvoiceTotal(Connection connection, int invoiceId) throws SQLException {
        String sql = "UPDATE Invoices SET total_amount = (SELECT COALESCE(SUM(total_price), 0) FROM InvoiceItems WHERE invoice_id = ?) WHERE invoice_id = ?";
        
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, invoiceId);
            statement.setInt(2, invoiceId);
            statement.executeUpdate();
        }
    }

    /**
     * Map ResultSet to Invoice object
     */
    private Invoice mapResultSetToInvoice(ResultSet rs) throws SQLException {
        Invoice invoice = new Invoice();
        invoice.setInvoiceId(rs.getInt("invoice_id"));
        invoice.setPatientId(rs.getInt("patient_id"));
        invoice.setAppointmentId(rs.getObject("appointment_id", Integer.class));
        invoice.setTotalAmount(rs.getBigDecimal("total_amount"));
        invoice.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        invoice.setStatus(rs.getString("status"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            invoice.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        // Calculate net amount
        BigDecimal total = invoice.getTotalAmount() != null ? invoice.getTotalAmount() : BigDecimal.ZERO;
        BigDecimal discount = invoice.getDiscountAmount() != null ? invoice.getDiscountAmount() : BigDecimal.ZERO;
        invoice.setNetAmount(total.subtract(discount));
        
        return invoice;
    }

    /**
     * Map ResultSet to InvoiceItem object
     */
    private InvoiceItem mapResultSetToInvoiceItem(ResultSet rs) throws SQLException {
        InvoiceItem item = new InvoiceItem();
        item.setItemId(rs.getInt("item_id"));
        item.setInvoiceId(rs.getInt("invoice_id"));
        item.setServiceId(rs.getObject("service_id", Integer.class));
        item.setQuantity(rs.getInt("quantity"));
        item.setUnitPrice(rs.getBigDecimal("unit_price"));
        item.setTotalPrice(rs.getBigDecimal("total_price"));
        
        // Set service info if available
        if (rs.getString("service_name") != null) {
            Service service = new Service();
            service.setServiceId(rs.getInt("service_id"));
            service.setName(rs.getString("service_name"));
            service.setDescription(rs.getString("service_description"));
            item.setService(service);
        }
        
        return item;
    }
}
