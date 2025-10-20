package model;

import java.time.LocalDateTime;

public class StockTransaction {
    private int transactionId;
    private int itemId;
    private String transactionType;
    private int quantity;
    private int performedBy;
    private LocalDateTime performedAt;
    private String notes;
    
    // Additional fields from joins
    private String itemName;
    private String performedByName;

    public StockTransaction() {}

    public StockTransaction(int itemId, String transactionType, int quantity, int performedBy, String notes) {
        this.itemId = itemId;
        this.transactionType = transactionType;
        this.quantity = quantity;
        this.performedBy = performedBy;
        this.notes = notes;
    }

    // Getters and Setters
    public int getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(int transactionId) {
        this.transactionId = transactionId;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public String getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getPerformedBy() {
        return performedBy;
    }

    public void setPerformedBy(int performedBy) {
        this.performedBy = performedBy;
    }

    public LocalDateTime getPerformedAt() {
        return performedAt;
    }

    public void setPerformedAt(LocalDateTime performedAt) {
        this.performedAt = performedAt;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getPerformedByName() {
        return performedByName;
    }

    public void setPerformedByName(String performedByName) {
        this.performedByName = performedByName;
    }

    // Helper methods
    public boolean isInTransaction() {
        return "IN".equals(transactionType);
    }

    public boolean isOutTransaction() {
        return "OUT".equals(transactionType);
    }

    public String getTransactionTypeText() {
        return isInTransaction() ? "Nhập kho" : "Xuất kho";
    }

    public String getTransactionTypeIcon() {
        return isInTransaction() ? "📥" : "📤";
    }

    public String getFormattedQuantity() {
        return (isInTransaction() ? "+" : "-") + quantity;
    }

    @Override
    public String toString() {
        return "StockTransaction{" +
                "transactionId=" + transactionId +
                ", itemId=" + itemId +
                ", transactionType='" + transactionType + '\'' +
                ", quantity=" + quantity +
                ", performedBy=" + performedBy +
                ", performedAt=" + performedAt +
                ", notes='" + notes + '\'' +
                ", itemName='" + itemName + '\'' +
                ", performedByName='" + performedByName + '\'' +
                '}';
    }
}