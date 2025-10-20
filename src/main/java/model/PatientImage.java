package model;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class PatientImage {
    private int imageId;
    private int patientId;
    private Integer recordId;
    private String filePath;
    private String imageType;
    private LocalDateTime uploadedAt;
    private Integer uploadedBy;
    
    // Related objects
    private Patient patient;
    private MedicalRecord medicalRecord;
    private User uploadedByUser;

    public PatientImage() {
    }

    public PatientImage(int imageId, int patientId, Integer recordId, String filePath, 
                      String imageType, LocalDateTime uploadedAt, Integer uploadedBy) {
        this.imageId = imageId;
        this.patientId = patientId;
        this.recordId = recordId;
        this.filePath = filePath;
        this.imageType = imageType;
        this.uploadedAt = uploadedAt;
        this.uploadedBy = uploadedBy;
    }

    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public Integer getRecordId() {
        return recordId;
    }

    public void setRecordId(Integer recordId) {
        this.recordId = recordId;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getImageType() {
        return imageType;
    }

    public void setImageType(String imageType) {
        this.imageType = imageType;
    }

    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(LocalDateTime uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    public Integer getUploadedBy() {
        return uploadedBy;
    }

    public void setUploadedBy(Integer uploadedBy) {
        this.uploadedBy = uploadedBy;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public MedicalRecord getMedicalRecord() {
        return medicalRecord;
    }

    public void setMedicalRecord(MedicalRecord medicalRecord) {
        this.medicalRecord = medicalRecord;
    }

    public User getUploadedByUser() {
        return uploadedByUser;
    }

    public void setUploadedByUser(User uploadedByUser) {
        this.uploadedByUser = uploadedByUser;
    }

    /**
     * Helper method to get uploadedAt as java.util.Date for JSP formatting
     */
    public Date getUploadedAtAsDate() {
        if (uploadedAt != null) {
            return Date.from(uploadedAt.atZone(ZoneId.systemDefault()).toInstant());
        }
        return null;
    }

    /**
     * Helper method to get file name from file path
     */
    public String getFileName() {
        if (filePath != null && filePath.contains("/")) {
            return filePath.substring(filePath.lastIndexOf("/") + 1);
        }
        return filePath;
    }

    @Override
    public String toString() {
        return "PatientImage{" +
                "imageId=" + imageId +
                ", patientId=" + patientId +
                ", recordId=" + recordId +
                ", filePath='" + filePath + '\'' +
                ", imageType='" + imageType + '\'' +
                ", uploadedAt=" + uploadedAt +
                ", uploadedBy=" + uploadedBy +
                '}';
    }
}
