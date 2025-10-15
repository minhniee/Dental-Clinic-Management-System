package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;

public class Payment {
    private int paymentId;
    private int invoiceId;
    private BigDecimal amount;
    private String method;
    private LocalDateTime paidAt;
    private Invoice invoice;

    public Payment() {
    }

    public Payment(int paymentId, int invoiceId, BigDecimal amount, String method, LocalDateTime paidAt) {
        this.paymentId = paymentId;
        this.invoiceId = invoiceId;
        this.amount = amount;
        this.method = method;
        this.paidAt = paidAt;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public LocalDateTime getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
    }

    public Invoice getInvoice() {
        return invoice;
    }

    public void setInvoice(Invoice invoice) {
        this.invoice = invoice;
    }

    /**
     * Get formatted paidAt date
     */
    public String getFormattedPaidAt() {
        if (paidAt == null) return "";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        return paidAt.format(formatter);
    }

    /**
     * Helper method to get paidAt as java.util.Date for JSP formatting
     */
    public Date getPaidAtAsDate() {
        if (paidAt != null) {
            return Date.from(paidAt.atZone(ZoneId.systemDefault()).toInstant());
        }
        return null;
    }

    @Override
    public String toString() {
        return "Payment{" +
                "paymentId=" + paymentId +
                ", invoiceId=" + invoiceId +
                ", amount=" + amount +
                ", method='" + method + '\'' +
                ", paidAt=" + paidAt +
                '}';
    }
}
