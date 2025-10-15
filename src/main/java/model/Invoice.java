package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;

public class Invoice {
    private int invoiceId;
    private int patientId;
    private Integer appointmentId;
    private BigDecimal totalAmount;
    private BigDecimal discountAmount;
    private BigDecimal netAmount;
    private String status;
    private LocalDateTime createdAt;
    private Patient patient;
    private Appointment appointment;
    private List<InvoiceItem> items;

    public Invoice() {
    }

    public Invoice(int invoiceId, int patientId, Integer appointmentId, BigDecimal totalAmount, 
                   BigDecimal discountAmount, String status, LocalDateTime createdAt) {
        this.invoiceId = invoiceId;
        this.patientId = patientId;
        this.appointmentId = appointmentId;
        this.totalAmount = totalAmount;
        this.discountAmount = discountAmount;
        this.status = status;
        this.createdAt = createdAt;
        // Calculate net amount
        this.netAmount = totalAmount.subtract(discountAmount != null ? discountAmount : BigDecimal.ZERO);
    }

    public String getFormattedCreatedAt() {
        if (createdAt == null) return "";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        return createdAt.format(formatter);
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public Integer getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(Integer appointmentId) {
        this.appointmentId = appointmentId;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
        // Recalculate net amount when discount changes
        if (this.totalAmount != null) {
            this.netAmount = this.totalAmount.subtract(discountAmount != null ? discountAmount : BigDecimal.ZERO);
        }
    }

    public BigDecimal getNetAmount() {
        return netAmount;
    }

    public void setNetAmount(BigDecimal netAmount) {
        this.netAmount = netAmount;
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

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public Appointment getAppointment() {
        return appointment;
    }

    public void setAppointment(Appointment appointment) {
        this.appointment = appointment;
    }

    public List<InvoiceItem> getItems() {
        return items;
    }

    public void setItems(List<InvoiceItem> items) {
        this.items = items;
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

    @Override
    public String toString() {
        return "Invoice{" +
                "invoiceId=" + invoiceId +
                ", patientId=" + patientId +
                ", appointmentId=" + appointmentId +
                ", totalAmount=" + totalAmount +
                ", discountAmount=" + discountAmount +
                ", netAmount=" + netAmount +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
