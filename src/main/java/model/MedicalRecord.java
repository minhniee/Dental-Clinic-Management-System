package model;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

public class MedicalRecord {
    private int recordId;
    private int patientId;
    private Integer dentistId;
    private String summary;
    private LocalDateTime createdAt;
    private Patient patient;
    private User dentist;
    private List<Examination> examinations;
    private List<TreatmentPlan> treatmentPlans;
    private List<TreatmentSession> treatmentSessions;
    private List<Prescription> prescriptions;

    public MedicalRecord() {
    }

    public MedicalRecord(int recordId, int patientId, Integer dentistId, String summary, LocalDateTime createdAt) {
        this.recordId = recordId;
        this.patientId = patientId;
        this.dentistId = dentistId;
        this.summary = summary;
        this.createdAt = createdAt;
    }

    public int getRecordId() {
        return recordId;
    }

    public void setRecordId(int recordId) {
        this.recordId = recordId;
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

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
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

    public User getDentist() {
        return dentist;
    }

    public void setDentist(User dentist) {
        this.dentist = dentist;
    }

    public List<TreatmentPlan> getTreatmentPlans() {
        return treatmentPlans;
    }

    public void setTreatmentPlans(List<TreatmentPlan> treatmentPlans) {
        this.treatmentPlans = treatmentPlans;
    }

    public List<Examination> getExaminations() {
        return examinations;
    }

    public void setExaminations(List<Examination> examinations) {
        this.examinations = examinations;
    }

    public List<TreatmentSession> getTreatmentSessions() {
        return treatmentSessions;
    }

    public void setTreatmentSessions(List<TreatmentSession> treatmentSessions) {
        this.treatmentSessions = treatmentSessions;
    }

    public List<Prescription> getPrescriptions() {
        return prescriptions;
    }

    public void setPrescriptions(List<Prescription> prescriptions) {
        this.prescriptions = prescriptions;
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
        return "MedicalRecord{" +
                "recordId=" + recordId +
                ", patientId=" + patientId +
                ", dentistId=" + dentistId +
                ", summary='" + summary + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
