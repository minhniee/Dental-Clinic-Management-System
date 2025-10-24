package model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class Patient {
    private int patientId;
    private String fullName;
    private LocalDate birthDate;
    private String  gender;
    private String phone;
    private String email;
    private String address;
    private String avatar;
    private LocalDateTime createdAt;
    
    // Additional properties for queue management
    private Integer positionInQueue;
    private String queueStatus;
    
    // Additional properties for medical history
    private Integer medicalRecordCount;
    private LocalDateTime lastVisitDate;

    public Patient() {
    }

    public Patient(int patientId, String fullName, LocalDate birthDate, String  gender,
                   String phone, String email, String address, String avatar, LocalDateTime createdAt) {
        this.patientId = patientId;
        this.fullName = fullName;
        this.birthDate = birthDate;
        this.gender = gender;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.avatar = avatar;
        this.createdAt = createdAt;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public LocalDate getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(LocalDate birthDate) {
        this.birthDate = birthDate;
    }

    public String  getGender() {
        return gender;
    }

    public void setGender(String  gender) {
        this.gender = gender;
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

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }


    /**
     * Helper method to get birthDate as java.util.Date for JSP formatting
     */
    public Date getBirthDateAsDate() {
        if (birthDate != null) {
            return Date.from(birthDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
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

    public Integer getPositionInQueue() {
        return positionInQueue;
    }

    public void setPositionInQueue(Integer positionInQueue) {
        this.positionInQueue = positionInQueue;
    }

    public String getQueueStatus() {
        return queueStatus;
    }

    public void setQueueStatus(String queueStatus) {
        this.queueStatus = queueStatus;
    }

    public Integer getMedicalRecordCount() {
        return medicalRecordCount;
    }

    public void setMedicalRecordCount(Integer medicalRecordCount) {
        this.medicalRecordCount = medicalRecordCount;
    }

    public LocalDateTime getLastVisitDate() {
        return lastVisitDate;
    }

    public void setLastVisitDate(LocalDateTime lastVisitDate) {
        this.lastVisitDate = lastVisitDate;
    }

    /**
     * Helper method to get lastVisitDate as java.util.Date for JSP formatting
     */
    public Date getLastVisitDateAsDate() {
        if (lastVisitDate != null) {
            return Date.from(lastVisitDate.atZone(ZoneId.systemDefault()).toInstant());
        }
        return null;
    }

    @Override
    public String toString() {
        return "Patient{" +
                "patientId=" + patientId +
                ", fullName='" + fullName + '\'' +
                ", birthDate=" + birthDate +
                ", gender=" + gender +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                ", address='" + address + '\'' +
                ", avatar='" + avatar + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
