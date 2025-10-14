package model;

import java.time.LocalDateTime;

public class Prescription {
    private int prescriptionId;
    private int patientId;
    private Integer dentistId;
    private LocalDateTime createdAt;
    private String notes;
    private Patient patient;
    private User dentist;

    public Prescription() {
    }

    public Prescription(int prescriptionId, int patientId, Integer dentistId, LocalDateTime createdAt, String notes) {
        this.prescriptionId = prescriptionId;
        this.patientId = patientId;
        this.dentistId = dentistId;
        this.createdAt = createdAt;
        this.notes = notes;
    }

    public int getPrescriptionId() {
        return prescriptionId;
    }

    public void setPrescriptionId(int prescriptionId) {
        this.prescriptionId = prescriptionId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public Integer getDentistId() {
        return dentistId;
    }

    public void setDentistId(Integer dentistId) {
        this.dentistId = dentistId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
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

    @Override
    public String toString() {
        return "Prescription{" +
                "prescriptionId=" + prescriptionId +
                ", patientId=" + patientId +
                ", dentistId=" + dentistId +
                ", createdAt=" + createdAt +
                ", notes='" + notes + '\'' +
                '}';
    }
}
