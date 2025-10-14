package model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class AppointmentRequest {
    private int requestId;
    private Integer patientId;
    private String fullName;
    private String phone;
    private String email;
    private Integer serviceId;
    private Integer preferredDoctorId;
    private LocalDate preferredDate;
    private String preferredShift;
    private String notes;
    private String status;
    private String otpCode;
    private LocalDateTime otpExpiresAt;
    private LocalDateTime createdAt;
    private LocalDateTime confirmedAt;
    
    // Related objects
    private Patient patient;
    private Service service;
    private User preferredDoctor;

    public AppointmentRequest() {
    }

    public AppointmentRequest(int requestId, Integer patientId, String fullName, String phone, String email,
                             Integer serviceId, Integer preferredDoctorId, LocalDate preferredDate, 
                             String preferredShift, String notes, String status, String otpCode,
                             LocalDateTime otpExpiresAt, LocalDateTime createdAt, LocalDateTime confirmedAt) {
        this.requestId = requestId;
        this.patientId = patientId;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.serviceId = serviceId;
        this.preferredDoctorId = preferredDoctorId;
        this.preferredDate = preferredDate;
        this.preferredShift = preferredShift;
        this.notes = notes;
        this.status = status;
        this.otpCode = otpCode;
        this.otpExpiresAt = otpExpiresAt;
        this.createdAt = createdAt;
        this.confirmedAt = confirmedAt;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public Integer getPatientId() {
        return patientId;
    }

    public void setPatientId(Integer patientId) {
        this.patientId = patientId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Integer getServiceId() {
        return serviceId;
    }

    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }

    public Integer getPreferredDoctorId() {
        return preferredDoctorId;
    }

    public void setPreferredDoctorId(Integer preferredDoctorId) {
        this.preferredDoctorId = preferredDoctorId;
    }

    public LocalDate getPreferredDate() {
        return preferredDate;
    }

    public void setPreferredDate(LocalDate preferredDate) {
        this.preferredDate = preferredDate;
    }

    public String getPreferredShift() {
        return preferredShift;
    }

    public void setPreferredShift(String preferredShift) {
        this.preferredShift = preferredShift;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getOtpCode() {
        return otpCode;
    }

    public void setOtpCode(String otpCode) {
        this.otpCode = otpCode;
    }

    public LocalDateTime getOtpExpiresAt() {
        return otpExpiresAt;
    }

    public void setOtpExpiresAt(LocalDateTime otpExpiresAt) {
        this.otpExpiresAt = otpExpiresAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getConfirmedAt() {
        return confirmedAt;
    }

    public void setConfirmedAt(LocalDateTime confirmedAt) {
        this.confirmedAt = confirmedAt;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    public User getPreferredDoctor() {
        return preferredDoctor;
    }

    public void setPreferredDoctor(User preferredDoctor) {
        this.preferredDoctor = preferredDoctor;
    }

    @Override
    public String toString() {
        return "AppointmentRequest{" +
                "requestId=" + requestId +
                ", patientId=" + patientId +
                ", fullName='" + fullName + '\'' +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                ", serviceId=" + serviceId +
                ", preferredDoctorId=" + preferredDoctorId +
                ", preferredDate=" + preferredDate +
                ", preferredShift='" + preferredShift + '\'' +
                ", notes='" + notes + '\'' +
                ", status='" + status + '\'' +
                ", otpCode='" + otpCode + '\'' +
                ", otpExpiresAt=" + otpExpiresAt +
                ", createdAt=" + createdAt +
                ", confirmedAt=" + confirmedAt +
                '}';
    }
}
