package model;

public class PrescriptionItem {
    private int itemId;
    private int prescriptionId;
    private String medicationName;
    private String dosage;
    private String duration;
    private String instructions;

    // Constructors
    public PrescriptionItem() {}

    public PrescriptionItem(int itemId, int prescriptionId, String medicationName, String dosage, String duration, String instructions) {
        this.itemId = itemId;
        this.prescriptionId = prescriptionId;
        this.medicationName = medicationName;
        this.dosage = dosage;
        this.duration = duration;
        this.instructions = instructions;
    }

    // Getters and Setters
    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getPrescriptionId() {
        return prescriptionId;
    }

    public void setPrescriptionId(int prescriptionId) {
        this.prescriptionId = prescriptionId;
    }

    public String getMedicationName() {
        return medicationName;
    }

    public void setMedicationName(String medicationName) {
        this.medicationName = medicationName;
    }

    public String getDosage() {
        return dosage;
    }

    public void setDosage(String dosage) {
        this.dosage = dosage;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public String getInstructions() {
        return instructions;
    }

    public void setInstructions(String instructions) {
        this.instructions = instructions;
    }

    @Override
    public String toString() {
        return "PrescriptionItem{" +
                "itemId=" + itemId +
                ", prescriptionId=" + prescriptionId +
                ", medicationName='" + medicationName + '\'' +
                ", dosage='" + dosage + '\'' +
                ", duration='" + duration + '\'' +
                ", instructions='" + instructions + '\'' +
                '}';
    }
}