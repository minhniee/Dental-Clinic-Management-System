package DAO;

import model.ScheduleRequest;
import context.DBContext;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ScheduleRequestDAO {
    
    // Lấy tất cả yêu cầu nghỉ
    public List<ScheduleRequest> getAllRequests() throws SQLException {
        String sql = "SELECT sr.request_id, sr.employee_id, u.full_name as employee_name, " +
                    "sr.date, sr.shift, sr.reason, sr.status, sr.created_at, " +
                    "sr.reviewed_by, reviewer.full_name as reviewer_name, sr.reviewed_at, sr.manager_notes " +
                    "FROM ScheduleRequests sr " +
                    "INNER JOIN Employees e ON sr.employee_id = e.employee_id " +
                    "INNER JOIN Users u ON e.user_id = u.user_id " +
                    "LEFT JOIN Users reviewer ON sr.reviewed_by = reviewer.user_id " +
                    "ORDER BY sr.created_at DESC";
        
        List<ScheduleRequest> requests = new ArrayList<>();
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                requests.add(mapResultSetToScheduleRequest(rs));
            }
        }
        return requests;
    }
    
    // Lấy yêu cầu theo ID
    public ScheduleRequest getRequestById(int requestId) throws SQLException {
        String sql = "SELECT sr.request_id, sr.employee_id, u.full_name as employee_name, " +
                    "sr.date, sr.shift, sr.reason, sr.status, sr.created_at, " +
                    "sr.reviewed_by, reviewer.full_name as reviewer_name, sr.reviewed_at, sr.manager_notes " +
                    "FROM ScheduleRequests sr " +
                    "INNER JOIN Employees e ON sr.employee_id = e.employee_id " +
                    "INNER JOIN Users u ON e.user_id = u.user_id " +
                    "LEFT JOIN Users reviewer ON sr.reviewed_by = reviewer.user_id " +
                    "WHERE sr.request_id = ?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToScheduleRequest(rs);
                }
            }
        }
        return null;
    }
    
    // Lấy yêu cầu theo trạng thái
    public List<ScheduleRequest> getRequestsByStatus(String status) throws SQLException {
        String sql = "SELECT sr.request_id, sr.employee_id, u.full_name as employee_name, " +
                    "sr.date, sr.shift, sr.reason, sr.status, sr.created_at, " +
                    "sr.reviewed_by, reviewer.full_name as reviewer_name, sr.reviewed_at, sr.manager_notes " +
                    "FROM ScheduleRequests sr " +
                    "INNER JOIN Employees e ON sr.employee_id = e.employee_id " +
                    "INNER JOIN Users u ON e.user_id = u.user_id " +
                    "LEFT JOIN Users reviewer ON sr.reviewed_by = reviewer.user_id " +
                    "WHERE sr.status = ? " +
                    "ORDER BY sr.created_at DESC";
        
        List<ScheduleRequest> requests = new ArrayList<>();
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    requests.add(mapResultSetToScheduleRequest(rs));
                }
            }
        }
        return requests;
    }
    
    // Tạo yêu cầu nghỉ mới
    public boolean createRequest(int employeeId, LocalDate date, String shift, String reason) throws SQLException {
        String sql = "INSERT INTO ScheduleRequests (employee_id, date, shift, reason, status, created_at) " +
                    "VALUES (?, ?, ?, ?, 'PENDING', GETDATE())";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setDate(2, Date.valueOf(date));
            ps.setString(3, shift);
            ps.setString(4, reason);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    // Phê duyệt yêu cầu
    public boolean approveRequest(int requestId, int reviewerId, String managerNotes) throws SQLException {
        String sql = "UPDATE ScheduleRequests SET status = 'APPROVED', reviewed_by = ?, reviewed_at = GETDATE(), manager_notes = ? " +
                    "WHERE request_id = ?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewerId);
            ps.setString(2, managerNotes);
            ps.setInt(3, requestId);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    // Phê duyệt yêu cầu (overload method without notes)
    public boolean approveRequest(int requestId, int reviewerId) throws SQLException {
        return approveRequest(requestId, reviewerId, null);
    }
    
    // Từ chối yêu cầu
    public boolean rejectRequest(int requestId, int reviewerId, String managerNotes) throws SQLException {
        String sql = "UPDATE ScheduleRequests SET status = 'REJECTED', reviewed_by = ?, reviewed_at = GETDATE(), manager_notes = ? " +
                    "WHERE request_id = ?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewerId);
            ps.setString(2, managerNotes);
            ps.setInt(3, requestId);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    // Từ chối yêu cầu (overload method without notes)
    public boolean rejectRequest(int requestId, int reviewerId) throws SQLException {
        return rejectRequest(requestId, reviewerId, null);
    }
    
    // Lấy số lượng yêu cầu theo trạng thái
    public int getRequestCountByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM ScheduleRequests WHERE status = ?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }
    
    // Map ResultSet to ScheduleRequest
    private ScheduleRequest mapResultSetToScheduleRequest(ResultSet rs) throws SQLException {
        ScheduleRequest request = new ScheduleRequest();
        request.setRequestId(rs.getInt("request_id"));
        request.setEmployeeId(rs.getInt("employee_id"));
        request.setEmployeeName(rs.getString("employee_name"));
        request.setDate(rs.getDate("date").toLocalDate());
        request.setShift(rs.getString("shift"));
        request.setReason(rs.getString("reason"));
        request.setStatus(rs.getString("status"));
        request.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        
        // Handle nullable fields
        if (rs.getObject("reviewed_by") != null) {
            request.setReviewedBy(rs.getInt("reviewed_by"));
        }
        request.setReviewerName(rs.getString("reviewer_name"));
        
        if (rs.getTimestamp("reviewed_at") != null) {
            request.setReviewedAt(rs.getTimestamp("reviewed_at").toLocalDateTime());
        }
        
        // Handle manager notes
        request.setManagerNotes(rs.getString("manager_notes"));
        
        return request;
    }
}
