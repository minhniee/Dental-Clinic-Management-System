package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class TreatmentPlan {
    private int planId;
    private int recordId;
    private String planSummary;
    private BigDecimal estimatedCost;
    private LocalDateTime createdAt;
    private MedicalRecord medicalRecord;

    public TreatmentPlan() {
    }

    public TreatmentPlan(int planId, int recordId, String planSummary, BigDecimal estimatedCost, LocalDateTime createdAt) {
        this.planId = planId;
        this.recordId = recordId;
        this.planSummary = planSummary;
        this.estimatedCost = estimatedCost;
        this.createdAt = createdAt;
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

    public String getPlanSummary() {
        return planSummary;
    }

    public void setPlanSummary(String planSummary) {
        this.planSummary = planSummary;
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

    public MedicalRecord getMedicalRecord() {
        return medicalRecord;
    }

    public void setMedicalRecord(MedicalRecord medicalRecord) {
        this.medicalRecord = medicalRecord;
    }

    @Override
    public String toString() {
        return "TreatmentPlan{" +
                "planId=" + planId +
                ", recordId=" + recordId +
                ", planSummary='" + planSummary + '\'' +
                ", estimatedCost=" + estimatedCost +
                ", createdAt=" + createdAt +
                '}';
    }
}
