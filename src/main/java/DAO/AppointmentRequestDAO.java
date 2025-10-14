package DAO;

import context.DBContext;
import model.AppointmentRequest;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AppointmentRequestDAO {

    private static final Logger logger = Logger.getLogger(AppointmentRequestDAO.class.getName());

    /**
     * Create a new appointment request
     */
    public boolean createAppointmentRequest(AppointmentRequest request) {
        String sql = "INSERT INTO AppointmentRequests " +
                    "(patient_id, full_name, phone, email, service_id, preferred_doctor_id, " +
                    "preferred_date, preferred_shift, notes, status, otp_code, otp_expires_at, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // Generate OTP code
            String otpCode = generateOTP();
            
            // Set OTP expiration (24 hours from now)
            LocalDateTime otpExpiry = LocalDateTime.now().plusDays(1);
            
            statement.setObject(1, request.getPatientId(), Types.INTEGER);
            statement.setString(2, request.getFullName());
            statement.setString(3, request.getPhone());
            statement.setString(4, request.getEmail());
            statement.setObject(5, request.getServiceId(), Types.INTEGER);
            statement.setObject(6, request.getPreferredDoctorId(), Types.INTEGER);
            statement.setDate(7, Date.valueOf(request.getPreferredDate()));
            statement.setString(8, request.getPreferredShift());
            statement.setString(9, request.getNotes());
            statement.setString(10, "PENDING");
            statement.setString(11, otpCode);
            statement.setTimestamp(12, Timestamp.valueOf(otpExpiry));
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                // Get the generated request ID
                try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        request.setRequestId(generatedKeys.getInt(1));
                        request.setOtpCode(otpCode);
                        request.setOtpExpiresAt(otpExpiry);
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating appointment request", e);
        }
        
        return false;
    }

    /**
     * Generate a 6-digit OTP code
     */
    public String generateOTP() {
        Random random = new Random();
        return String.format("%06d", random.nextInt(1000000));
    }

    /**
     * Get appointment request by ID
     */
    public AppointmentRequest getAppointmentRequestById(int requestId) {
        String sql = "SELECT * FROM AppointmentRequests WHERE request_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, requestId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToAppointmentRequest(rs);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting appointment request by ID: " + requestId, e);
        }
        
        return null;
    }

    /**
     * Update appointment request status
     */
    public boolean updateRequestStatus(int requestId, String status) {
        String sql = "UPDATE AppointmentRequests SET status = ?, confirmed_at = GETDATE() WHERE request_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, status);
            statement.setInt(2, requestId);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating appointment request status: " + requestId, e);
            return false;
        }
    }

    /**
     * Verify OTP code for appointment request
     */
    public boolean verifyOTP(int requestId, String otpCode) {
        String sql = "SELECT 1 FROM AppointmentRequests " +
                    "WHERE request_id = ? AND otp_code = ? AND otp_expires_at >= CAST(GETDATE() AS DATE)";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, requestId);
            statement.setString(2, otpCode);
            ResultSet rs = statement.executeQuery();
            
            return rs.next();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error verifying OTP for request: " + requestId, e);
            return false;
        }
    }

    /**
     * Map ResultSet to AppointmentRequest object
     */
    private AppointmentRequest mapResultSetToAppointmentRequest(ResultSet rs) throws SQLException {
        AppointmentRequest request = new AppointmentRequest();
        request.setRequestId(rs.getInt("request_id"));
        request.setPatientId(rs.getInt("patient_id"));
        if (rs.wasNull()) request.setPatientId(null);
        
        request.setFullName(rs.getString("full_name"));
        request.setPhone(rs.getString("phone"));
        request.setEmail(rs.getString("email"));
        
        request.setServiceId(rs.getInt("service_id"));
        if (rs.wasNull()) request.setServiceId(null);
        
        request.setPreferredDoctorId(rs.getInt("preferred_doctor_id"));
        if (rs.wasNull()) request.setPreferredDoctorId(null);
        
        request.setPreferredDate(rs.getDate("preferred_date").toLocalDate());
        request.setPreferredShift(rs.getString("preferred_shift"));
        request.setNotes(rs.getString("notes"));
        request.setStatus(rs.getString("status"));
        request.setOtpCode(rs.getString("otp_code"));
        
        Timestamp otpExpiresAt = rs.getTimestamp("otp_expires_at");
        if (otpExpiresAt != null) {
            request.setOtpExpiresAt(otpExpiresAt.toLocalDateTime());
        }
        
        request.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        
        Timestamp confirmedAt = rs.getTimestamp("confirmed_at");
        if (confirmedAt != null) {
            request.setConfirmedAt(confirmedAt.toLocalDateTime());
        }
        
        return request;
    }
}
