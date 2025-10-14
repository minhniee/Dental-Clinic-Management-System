package model;

import java.time.LocalDateTime;

public class InventoryItem {
    private int itemId;
    private String name;
    private String unit;
    private int quantity;
    private int minStock;
    private LocalDateTime createdAt;

    public InventoryItem() {
    }

    public InventoryItem(int itemId, String name, String unit, int quantity, int minStock, LocalDateTime createdAt) {
        this.itemId = itemId;
        this.name = name;
        this.unit = unit;
        this.quantity = quantity;
        this.minStock = minStock;
        this.createdAt = createdAt;
    }

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
