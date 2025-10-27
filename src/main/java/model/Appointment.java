package model;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class Appointment {
    private int appointmentId;
    private int patientId;
    private int dentistId;
    private int serviceId;
    private LocalDateTime appointmentDate;
    private String status;
    private String notes;
    private LocalDateTime createdAt;
    private String source;
    private String bookingChannel;
    private Integer createdByPatientId;
    private Integer createdByUserId;
    private String confirmationCode;
    private LocalDateTime confirmedAt;
    
    // Related objects
    private Patient patient;
    private User dentist;
    private Service service;
    private Patient createdByPatient;
    private User createdByUser;

    public Appointment() {
    }

    public Appointment(int appointmentId, int patientId, int dentistId, int serviceId, 
                      LocalDateTime appointmentDate, String status, String notes, 
                      LocalDateTime createdAt, String source, String bookingChannel, 
                      Integer createdByPatientId, Integer createdByUserId, 
                      String confirmationCode, LocalDateTime confirmedAt) {
        this.appointmentId = appointmentId;
        this.patientId = patientId;
        this.dentistId = dentistId;
        this.serviceId = serviceId;
        this.appointmentDate = appointmentDate;
        this.status = status;
        this.notes = notes;
        this.createdAt = createdAt;
        this.source = source;
        this.bookingChannel = bookingChannel;
        this.createdByPatientId = createdByPatientId;
        this.createdByUserId = createdByUserId;
        this.confirmationCode = confirmationCode;
        this.confirmedAt = confirmedAt;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public int getDentistId() {
        return dentistId;
    }

    public void setDentistId(int dentistId) {
        this.dentistId = dentistId;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public LocalDateTime getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(LocalDateTime appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getBookingChannel() {
        return bookingChannel;
    }

    public void setBookingChannel(String bookingChannel) {
        this.bookingChannel = bookingChannel;
    }

    public Integer getCreatedByPatientId() {
        return createdByPatientId;
    }

    public void setCreatedByPatientId(Integer createdByPatientId) {
        this.createdByPatientId = createdByPatientId;
    }

    public Integer getCreatedByUserId() {
        return createdByUserId;
    }

    public void setCreatedByUserId(Integer createdByUserId) {
        this.createdByUserId = createdByUserId;
    }

    public String getConfirmationCode() {
        return confirmationCode;
    }

    public void setConfirmationCode(String confirmationCode) {
        this.confirmationCode = confirmationCode;
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

    public User getDentist() {
        return dentist;
    }

    public void setDentist(User dentist) {
        this.dentist = dentist;
    }

    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    public Patient getCreatedByPatient() {
        return createdByPatient;
    }

    public void setCreatedByPatient(Patient createdByPatient) {
        this.createdByPatient = createdByPatient;
    }

    public User getCreatedByUser() {
        return createdByUser;
    }

    public void setCreatedByUser(User createdByUser) {
        this.createdByUser = createdByUser;
    }

    /**
     * Helper method to get appointmentDate as java.util.Date for JSP formatting
     */
    public Date getAppointmentDateAsDate() {
        if (appointmentDate != null) {
            return Date.from(appointmentDate.atZone(ZoneId.systemDefault()).toInstant());
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
     * Helper method to get confirmedAt as java.util.Date for JSP formatting
     */
    public Date getConfirmedAtAsDate() {
        if (confirmedAt != null) {
            return Date.from(confirmedAt.atZone(ZoneId.systemDefault()).toInstant());
        }
        return null;
    }

    /**
     * Helper method to format appointmentDate for HTML datetime-local input
     */
    public String getAppointmentDateForInput() {
        if (appointmentDate != null) {
            return appointmentDate.toString().substring(0, 16); // Format: YYYY-MM-DDTHH:mm
        }
        return "";
    }

    @Override
    public String toString() {
        return "Appointment{" +
                "appointmentId=" + appointmentId +
                ", patientId=" + patientId +
                ", dentistId=" + dentistId +
                ", serviceId=" + serviceId +
                ", appointmentDate=" + appointmentDate +
                ", status='" + status + '\'' +
                ", notes='" + notes + '\'' +
                ", createdAt=" + createdAt +
                ", source='" + source + '\'' +
                ", bookingChannel='" + bookingChannel + '\'' +
                ", createdByPatientId=" + createdByPatientId +
                ", createdByUserId=" + createdByUserId +
                ", confirmationCode='" + confirmationCode + '\'' +
                ", confirmedAt=" + confirmedAt +
                '}';
    }
}
