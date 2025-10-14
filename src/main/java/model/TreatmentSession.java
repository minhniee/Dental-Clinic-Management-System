package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class TreatmentSession {
    private int sessionId;
    private int planId;
    private LocalDateTime sessionDate;
    private String procedureDone;
    private BigDecimal sessionCost;
    private TreatmentPlan treatmentPlan;

    public TreatmentSession() {
    }

    public TreatmentSession(int sessionId, int planId, LocalDateTime sessionDate, String procedureDone, BigDecimal sessionCost) {
        this.sessionId = sessionId;
        this.planId = planId;
        this.sessionDate = sessionDate;
        this.procedureDone = procedureDone;
        this.sessionCost = sessionCost;
    }

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

    public LocalDateTime getSessionDate() {
        return sessionDate;
    }

    public void setSessionDate(LocalDateTime sessionDate) {
        this.sessionDate = sessionDate;
    }

    public String getProcedureDone() {
        return procedureDone;
    }

    public void setProcedureDone(String procedureDone) {
        this.procedureDone = procedureDone;
    }

    public BigDecimal getSessionCost() {
        return sessionCost;
    }

    public void setSessionCost(BigDecimal sessionCost) {
        this.sessionCost = sessionCost;
    }

    public TreatmentPlan getTreatmentPlan() {
        return treatmentPlan;
    }

    public void setTreatmentPlan(TreatmentPlan treatmentPlan) {
        this.treatmentPlan = treatmentPlan;
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
