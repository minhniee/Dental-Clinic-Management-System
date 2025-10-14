package model;

public class WaitingQueue {
    private int queueId;
    private int appointmentId;
    private Integer positionInQueue;
    private String status;
    private Appointment appointment;

    public WaitingQueue() {
    }

    public WaitingQueue(int queueId, int appointmentId, Integer positionInQueue, String status) {
        this.queueId = queueId;
        this.appointmentId = appointmentId;
        this.positionInQueue = positionInQueue;
        this.status = status;
    }

    public int getQueueId() {
        return queueId;
    }

    public void setQueueId(int queueId) {
        this.queueId = queueId;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public Integer getPositionInQueue() {
        return positionInQueue;
    }

    public void setPositionInQueue(Integer positionInQueue) {
        this.positionInQueue = positionInQueue;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Appointment getAppointment() {
        return appointment;
    }

    public void setAppointment(Appointment appointment) {
        this.appointment = appointment;
    }

    @Override
    public String toString() {
        return "WaitingQueue{" +
                "queueId=" + queueId +
                ", appointmentId=" + appointmentId +
                ", positionInQueue=" + positionInQueue +
                ", status='" + status + '\'' +
                '}';
    }
}
