package model;

import java.time.LocalDateTime;
import java.time.LocalDate;
import java.util.List;

public class Prescription {
    private int prescriptionId;
    private int patientId;
    private Integer dentistId;
    private String notes;
    private LocalDate prescriptionDate;
    private LocalDateTime createdAt;
    private List<PrescriptionItem> prescriptionItems;
    private User dentist;

    // Constructors
    public Prescription() {}

    public Prescription(int prescriptionId, int patientId, Integer dentistId, String notes, LocalDateTime createdAt) {
        this.prescriptionId = prescriptionId;
        this.patientId = patientId;
        this.dentistId = dentistId;
        this.notes = notes;
        this.createdAt = createdAt;
    }

    // Getters and Setters
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

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public LocalDate getPrescriptionDate() {
        return prescriptionDate;
    }

    public void setPrescriptionDate(LocalDate prescriptionDate) {
        this.prescriptionDate = prescriptionDate;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public List<PrescriptionItem> getPrescriptionItems() {
        return prescriptionItems;
    }

    public void setPrescriptionItems(List<PrescriptionItem> prescriptionItems) {
        this.prescriptionItems = prescriptionItems;
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
                ", notes='" + notes + '\'' +
                ", createdAt=" + createdAt +
                ", prescriptionItems=" + (prescriptionItems != null ? prescriptionItems.size() : 0) + " items" +
                '}';
    }
}