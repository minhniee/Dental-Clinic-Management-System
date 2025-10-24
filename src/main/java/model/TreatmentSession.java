package model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class TreatmentSession {
    private int sessionId;
    private int planId;
    private int recordId;
    private LocalDate sessionDate;
    private String procedure;
    private String procedureDone;
    private String notes;
    private BigDecimal sessionCost;

    // Constructors
    public TreatmentSession() {}

    public TreatmentSession(int sessionId, int planId, LocalDate sessionDate, String procedureDone, BigDecimal sessionCost) {
        this.sessionId = sessionId;
        this.planId = planId;
        this.sessionDate = sessionDate;
        this.procedureDone = procedureDone;
        this.sessionCost = sessionCost;
    }

    // Getters and Setters
    public int getSessionId() {
        return sessionId;
    }

    public void setSessionId(int sessionId) {
        this.sessionId = sessionId;
    }

    public int getPlanId() {
        return planId;
    }

    public void setPlanId(int planId) {
        this.planId = planId;
    }

    public int getRecordId() {
        return recordId;
    }

    public void setRecordId(int recordId) {
        this.recordId = recordId;
    }

    public LocalDate getSessionDate() {
        return sessionDate;
    }

    public void setSessionDate(LocalDate sessionDate) {
        this.sessionDate = sessionDate;
    }

    public String getProcedure() {
        return procedure;
    }

    public void setProcedure(String procedure) {
        this.procedure = procedure;
    }

    public String getProcedureDone() {
        return procedureDone;
    }

    public void setProcedureDone(String procedureDone) {
        this.procedureDone = procedureDone;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public BigDecimal getSessionCost() {
        return sessionCost;
    }

    public void setSessionCost(BigDecimal sessionCost) {
        this.sessionCost = sessionCost;
    }

    @Override
    public String toString() {
        return "TreatmentSession{" +
                "sessionId=" + sessionId +
                ", planId=" + planId +
                ", sessionDate=" + sessionDate +
                ", procedureDone='" + procedureDone + '\'' +
                ", sessionCost=" + sessionCost +
                '}';
    }
}