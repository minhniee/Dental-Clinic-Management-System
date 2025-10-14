package model;

import java.math.BigDecimal;

public class InvoiceItem {
    private int itemId;
    private int invoiceId;
    private Integer serviceId;
    private int quantity;
    private BigDecimal unitPrice;
    private BigDecimal totalPrice;
    private Invoice invoice;
    private Service service;

    public InvoiceItem() {
    }

    public InvoiceItem(int itemId, int invoiceId, Integer serviceId, int quantity, BigDecimal unitPrice) {
        this.itemId = itemId;
        this.invoiceId = invoiceId;
        this.serviceId = serviceId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        // Calculate total price
        this.totalPrice = unitPrice.multiply(BigDecimal.valueOf(quantity));
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public Integer getServiceId() {
        return serviceId;
    }

    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
        // Recalculate total price when quantity changes
        if (this.unitPrice != null) {
            this.totalPrice = this.unitPrice.multiply(BigDecimal.valueOf(quantity));
        }
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
        // Recalculate total price when unit price changes
        if (this.quantity > 0) {
            this.totalPrice = unitPrice.multiply(BigDecimal.valueOf(this.quantity));
        }
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Invoice getInvoice() {
        return invoice;
    }

    public void setInvoice(Invoice invoice) {
        this.invoice = invoice;
    }

    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    @Override
    public String toString() {
        return "InvoiceItem{" +
                "itemId=" + itemId +
                ", invoiceId=" + invoiceId +
                ", serviceId=" + serviceId +
                ", quantity=" + quantity +
                ", unitPrice=" + unitPrice +
                ", totalPrice=" + totalPrice +
                '}';
    }
}
