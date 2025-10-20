package model;

import java.time.LocalDateTime;

public class InventoryItem {
    private int itemId;
    private String name;
    private String unit;
    private int quantity;
    private int minStock;
    private LocalDateTime createdAt;

    public InventoryItem() {}

    public InventoryItem(String name, String unit, int quantity, int minStock) {
        this.name = name;
        this.unit = unit;
        this.quantity = quantity;
        this.minStock = minStock;
    }

    // Getters and Setters
    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getMinStock() {
        return minStock;
    }

    public void setMinStock(int minStock) {
        this.minStock = minStock;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    // Helper methods
    public boolean isLowStock() {
        return quantity <= minStock;
    }

    public boolean isOutOfStock() {
        return quantity == 0;
    }

    public int getStockStatus() {
        if (quantity == 0) return 0; // Out of stock
        if (quantity <= minStock) return 1; // Low stock
        return 2; // Adequate stock
    }

    public String getStockStatusText() {
        switch (getStockStatus()) {
            case 0: return "Hết hàng";
            case 1: return "Sắp hết";
            case 2: return "Đủ hàng";
            default: return "Không xác định";
        }
    }

    @Override
    public String toString() {
        return "InventoryItem{" +
                "itemId=" + itemId +
                ", name='" + name + '\'' +
                ", unit='" + unit + '\'' +
                ", quantity=" + quantity +
                ", minStock=" + minStock +
                ", createdAt=" + createdAt +
                '}';
    }
}