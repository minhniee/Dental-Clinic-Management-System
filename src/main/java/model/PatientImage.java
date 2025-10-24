package model;

import java.time.LocalDateTime;

public class PatientImage {
    private int imageId;
    private int patientId;
    private Integer recordId;
    private String filePath;
    private String imageType;
    private LocalDateTime uploadedAt;
    private Integer uploadedBy;
    private User uploader;

    // Constructors
    public PatientImage() {}

    public PatientImage(int imageId, int patientId, Integer recordId, String filePath, String imageType, LocalDateTime uploadedAt, Integer uploadedBy) {
        this.imageId = imageId;
        this.patientId = patientId;
        this.recordId = recordId;
        this.filePath = filePath;
        this.imageType = imageType;
        this.uploadedAt = uploadedAt;
        this.uploadedBy = uploadedBy;
    }

    // Getters and Setters
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

    public User getUploader() {
        return uploader;
    }

    public void setUploader(User uploader) {
        this.uploader = uploader;
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