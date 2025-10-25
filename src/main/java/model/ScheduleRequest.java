package model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class ScheduleRequest {
    private int requestId;
    private int employeeId;
    private String employeeName;
    private LocalDate date;
    private String shift;
    private String reason;
    private String status;
    private LocalDateTime createdAt;
    private Integer reviewedBy;
    private String reviewerName;
    private LocalDateTime reviewedAt;
    
    // Constructors
    public ScheduleRequest() {}
    
    public ScheduleRequest(int requestId, int employeeId, String employeeName, LocalDate date, 
                          String shift, String reason, String status, LocalDateTime createdAt, 
                          Integer reviewedBy, String reviewerName, LocalDateTime reviewedAt) {
        this.requestId = requestId;
        this.employeeId = employeeId;
        this.employeeName = employeeName;
        this.date = date;
        this.shift = shift;
        this.reason = reason;
        this.status = status;
        this.createdAt = createdAt;
        this.reviewedBy = reviewedBy;
        this.reviewerName = reviewerName;
        this.reviewedAt = reviewedAt;
    }
    
    // Getters and Setters
    public int getRequestId() {
        return requestId;
    }
    
    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }
    
    public int getEmployeeId() {
        return employeeId;
    }
    
    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }
    
    public String getEmployeeName() {
        return employeeName;
    }
    
    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }
    
    public LocalDate getDate() {
        return date;
    }
    
    public void setDate(LocalDate date) {
        this.date = date;
    }
    
    public String getShift() {
        return shift;
    }
    
    public void setShift(String shift) {
        this.shift = shift;
    }
    
    public String getReason() {
        return reason;
    }
    
    public void setReason(String reason) {
        this.reason = reason;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public Integer getReviewedBy() {
        return reviewedBy;
    }
    
    public void setReviewedBy(Integer reviewedBy) {
        this.reviewedBy = reviewedBy;
    }
    
    public String getReviewerName() {
        return reviewerName;
    }
    
    public void setReviewerName(String reviewerName) {
        this.reviewerName = reviewerName;
    }
    
    public LocalDateTime getReviewedAt() {
        return reviewedAt;
    }
    
    public void setReviewedAt(LocalDateTime reviewedAt) {
        this.reviewedAt = reviewedAt;
    }
    
    // Helper methods
    public String getStatusText() {
        switch (status) {
            case "PENDING": return "Chờ duyệt";
            case "APPROVED": return "Đã duyệt";
            case "REJECTED": return "Từ chối";
            default: return status;
        }
    }
    
    public String getShiftText() {
        switch (shift) {
            case "Morning": return "Sáng";
            case "Afternoon": return "Chiều";
            case "FullDay": return "Cả ngày";
            default: return shift;
        }
    }
    
    public String getStatusColor() {
        switch (status) {
            case "PENDING": return "warning";
            case "APPROVED": return "success";
            case "REJECTED": return "danger";
            default: return "secondary";
        }
    }
}