package model;

import java.time.LocalDateTime;

public class Examination {
    private int examId;
    private int recordId;
    private String findings;
    private String diagnosis;
    private LocalDateTime createdAt;
    private MedicalRecord medicalRecord;

    public Examination() {
    }

    public Examination(int examId, int recordId, String findings, String diagnosis, LocalDateTime createdAt) {
        this.examId = examId;
        this.recordId = recordId;
        this.findings = findings;
        this.diagnosis = diagnosis;
        this.createdAt = createdAt;
    }

    public int getExamId() {
        return examId;
    }

    public void setExamId(int examId) {
        this.examId = examId;
    }

    public int getRecordId() {
        return recordId;
    }

    public void setRecordId(int recordId) {
        this.recordId = recordId;
    }

    public String getFindings() {
        return findings;
    }

    public void setFindings(String findings) {
        this.findings = findings;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public MedicalRecord getMedicalRecord() {
        return medicalRecord;
    }

    public void setMedicalRecord(MedicalRecord medicalRecord) {
        this.medicalRecord = medicalRecord;
    }

    @Override
    public String toString() {
        return "Examination{" +
                "examId=" + examId +
                ", recordId=" + recordId +
                ", findings='" + findings + '\'' +
                ", diagnosis='" + diagnosis + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
