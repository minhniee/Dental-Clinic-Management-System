package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class TreatmentPlan {
    private int planId;
    private int recordId;
    private String planSummary;
    private String description;
    private String notes;
    private BigDecimal estimatedCost;
    private LocalDateTime createdAt;
    private List<TreatmentSession> treatmentSessions;

    // Constructors
    public TreatmentPlan() {}

    public TreatmentPlan(int planId, int recordId, String planSummary, BigDecimal estimatedCost, LocalDateTime createdAt) {
        this.planId = planId;
        this.recordId = recordId;
        this.planSummary = planSummary;
        this.estimatedCost = estimatedCost;
        this.createdAt = createdAt;
    }

    // Getters and Setters
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

    public String getPlanSummary() {
        return planSummary;
    }

    public void setPlanSummary(String planSummary) {
        this.planSummary = planSummary;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public BigDecimal getEstimatedCost() {
        return estimatedCost;
    }

    public void setEstimatedCost(BigDecimal estimatedCost) {
        this.estimatedCost = estimatedCost;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public List<TreatmentSession> getTreatmentSessions() {
        return treatmentSessions;
    }

    public void setTreatmentSessions(List<TreatmentSession> treatmentSessions) {
        this.treatmentSessions = treatmentSessions;
    }

    @Override
    public String toString() {
        return "TreatmentPlan{" +
                "planId=" + planId +
                ", recordId=" + recordId +
                ", planSummary='" + planSummary + '\'' +
                ", estimatedCost=" + estimatedCost +
                ", createdAt=" + createdAt +
                ", treatmentSessions=" + (treatmentSessions != null ? treatmentSessions.size() : 0) + " sessions" +
                '}';
    }
}