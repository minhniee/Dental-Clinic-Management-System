package model;

import java.time.LocalDate;

public class DoctorSchedule {
    private int scheduleId;
    private int doctorId;
    private LocalDate workDate;
    private String shift;
    private String startTime;
    private String endTime;
    private String roomNo;
    private String notes;
    private String status; // ACTIVE, LOCKED, CANCELLED

    public DoctorSchedule() {
    }

    public DoctorSchedule(int scheduleId, int doctorId, LocalDate workDate, String shift, 
                         String startTime, String endTime, String roomNo, String notes, String status) {
        this.scheduleId = scheduleId;
        this.doctorId = doctorId;
        this.workDate = workDate;
        this.shift = shift;
        this.startTime = startTime;
        this.endTime = endTime;
        this.roomNo = roomNo;
        this.notes = notes;
        this.status = status;
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

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getRoomNo() {
        return roomNo;
    }

    public void setRoomNo(String roomNo) {
        this.roomNo = roomNo;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "DoctorSchedule{" +
                "scheduleId=" + scheduleId +
                ", doctorId=" + doctorId +
                ", workDate=" + workDate +
                ", shift='" + shift + '\'' +
                ", startTime='" + startTime + '\'' +
                ", endTime='" + endTime + '\'' +
                ", roomNo='" + roomNo + '\'' +
                ", notes='" + notes + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}