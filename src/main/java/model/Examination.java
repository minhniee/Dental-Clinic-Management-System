package model;

import java.time.LocalDateTime;
import java.time.LocalDate;

public class Examination {
    private int examId;
    private int recordId;
    private String findings;
    private String diagnosis;
    private String notes;
    private LocalDate examinationDate;
    private LocalDateTime createdAt;

    // Constructors
    public Examination() {}

    public Examination(int examId, int recordId, String findings, String diagnosis, LocalDateTime createdAt) {
        this.examId = examId;
        this.recordId = recordId;
        this.findings = findings;
        this.diagnosis = diagnosis;
        this.createdAt = createdAt;
    }

    // Getters and Setters
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

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public LocalDate getExaminationDate() {
        return examinationDate;
    }

    public void setExaminationDate(LocalDate examinationDate) {
        this.examinationDate = examinationDate;
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