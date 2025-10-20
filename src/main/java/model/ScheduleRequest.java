package model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class ScheduleRequest {
    private int requestId;
    private int employeeId;
    private LocalDate date;
    private String shift;
    private String reason;
    private String status;
    private LocalDateTime createdAt;
    private Integer reviewedBy;
    private LocalDateTime reviewedAt;
    
    // Related objects
    private Employee employee;
    private User reviewer;

    public ScheduleRequest() {
    }

    public ScheduleRequest(int requestId, int employeeId, LocalDate date, String shift, 
                          String reason, String status, LocalDateTime createdAt, 
                          Integer reviewedBy, LocalDateTime reviewedAt) {
        this.requestId = requestId;
        this.employeeId = employeeId;
        this.date = date;
        this.shift = shift;
        this.reason = reason;
        this.status = status;
        this.createdAt = createdAt;
        this.reviewedBy = reviewedBy;
        this.reviewedAt = reviewedAt;
    }

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

    public LocalDateTime getReviewedAt() {
        return reviewedAt;
    }

    public void setReviewedAt(LocalDateTime reviewedAt) {
        this.reviewedAt = reviewedAt;
    }

    public Employee getEmployee() {
        return employee;
    }

    public void setEmployee(Employee employee) {
        this.employee = employee;
    }

    public User getReviewer() {
        return reviewer;
    }

    public void setReviewer(User reviewer) {
        this.reviewer = reviewer;
    }

    /**
     * Helper method to get date as java.util.Date for JSP formatting
     */
    public Date getDateAsDate() {
        if (date != null) {
            return Date.from(date.atStartOfDay(ZoneId.systemDefault()).toInstant());
        }
        return null;
    }

    /**
     * Helper method to get createdAt as java.util.Date for JSP formatting
     */
    public Date getCreatedAtAsDate() {
        if (createdAt != null) {
            return Date.from(createdAt.atZone(ZoneId.systemDefault()).toInstant());
        }
        return null;
    }

    /**
     * Helper method to get reviewedAt as java.util.Date for JSP formatting
     */
    public Date getReviewedAtAsDate() {
        if (reviewedAt != null) {
            return Date.from(reviewedAt.atZone(ZoneId.systemDefault()).toInstant());
        }
        return null;
    }

    @Override
    public String toString() {
        return "ScheduleRequest{" +
                "requestId=" + requestId +
                ", employeeId=" + employeeId +
                ", date=" + date +
                ", shift='" + shift + '\'' +
                ", reason='" + reason + '\'' +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", reviewedBy=" + reviewedBy +
                ", reviewedAt=" + reviewedAt +
                '}';
    }
}
