package model;

import java.time.LocalDateTime;

public class StockTransaction {
    private int transactionId;
    private int itemId;
    private String transactionType;
    private int quantity;
    private Integer performedBy;
    private LocalDateTime performedAt;
    private InventoryItem inventoryItem;
    private User performedByUser;

    public StockTransaction() {
    }

    public StockTransaction(int transactionId, int itemId, String transactionType, int quantity, 
                           Integer performedBy, LocalDateTime performedAt) {
        this.transactionId = transactionId;
        this.itemId = itemId;
        this.transactionType = transactionType;
        this.quantity = quantity;
        this.performedBy = performedBy;
        this.performedAt = performedAt;
    }

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

    public Integer getPerformedBy() {
        return performedBy;
    }

    public void setPerformedBy(Integer performedBy) {
        this.performedBy = performedBy;
    }

    public LocalDateTime getPerformedAt() {
        return performedAt;
    }

    public void setPerformedAt(LocalDateTime performedAt) {
        this.performedAt = performedAt;
    }

    public InventoryItem getInventoryItem() {
        return inventoryItem;
    }

    public void setInventoryItem(InventoryItem inventoryItem) {
        this.inventoryItem = inventoryItem;
    }

    public User getPerformedByUser() {
        return performedByUser;
    }

    public void setPerformedByUser(User performedByUser) {
        this.performedByUser = performedByUser;
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
                '}';
    }
}
