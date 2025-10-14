package model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class DoctorSchedule {
    private int scheduleId;
    private int doctorId;
    private LocalDate workDate;
    private String shift;
    private LocalTime startTime;
    private LocalTime endTime;
    private String roomNo;
    private String status;
    private LocalDateTime createdAt;
    private User doctor;

    public DoctorSchedule() {
    }

    public DoctorSchedule(int scheduleId, int doctorId, LocalDate workDate, String shift, 
                         LocalTime startTime, LocalTime endTime, String roomNo, String status, LocalDateTime createdAt) {
        this.scheduleId = scheduleId;
        this.doctorId = doctorId;
        this.workDate = workDate;
        this.shift = shift;
        this.startTime = startTime;
        this.endTime = endTime;
        this.roomNo = roomNo;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public int getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public LocalDate getWorkDate() {
        return workDate;
    }

    public void setWorkDate(LocalDate workDate) {
        this.workDate = workDate;
    }

    public String getShift() {
        return shift;
    }

    public void setShift(String shift) {
        this.shift = shift;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public String getRoomNo() {
        return roomNo;
    }

    public void setRoomNo(String roomNo) {
        this.roomNo = roomNo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public User getDoctor() {
        return doctor;
    }

    public void setDoctor(User doctor) {
        this.doctor = doctor;
    }

    @Override
    public String toString() {
        return "DoctorSchedule{" +
                "scheduleId=" + scheduleId +
                ", doctorId=" + doctorId +
                ", workDate=" + workDate +
                ", shift='" + shift + '\'' +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", roomNo='" + roomNo + '\'' +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
