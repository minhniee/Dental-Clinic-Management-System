package model;

import java.time.LocalDateTime;

public class PatientFile {
    private int fileId;
    private int patientId;
    private String content;
    private LocalDateTime uploadedAt;
    private Patient patient;

    public PatientFile() {
    }

    public PatientFile(int fileId, int patientId, String content, LocalDateTime uploadedAt) {
        this.fileId = fileId;
        this.patientId = patientId;
        this.content = content;
        this.uploadedAt = uploadedAt;
    }

    public int getFileId() {
        return fileId;
    }

    public void setFileId(int fileId) {
        this.fileId = fileId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(LocalDateTime uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    @Override
    public String toString() {
        return "PatientFile{" +
                "fileId=" + fileId +
                ", patientId=" + patientId +
                ", content='" + content + '\'' +
                ", uploadedAt=" + uploadedAt +
                '}';
    }
}
