<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Hóa Đơn #${invoice.invoiceId} - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/receptionist.css">
    <style>
        .invoice-container {
            max-width: 1000px;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .invoice-header {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }

        .invoice-header-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin-bottom: 1.5rem;
        }

        .header-section h3 {
            color: #0f172a;
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .header-section p {
            margin: 0.25rem 0;
            color: #475569;
        }

        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 9999px;
            font-size: 0.875rem;
            font-weight: 600;
            display: inline-block;
            margin-top: 1rem;
        }

        .status-paid {
            background-color: #d1fae5;
            color: #059669;
        }

        .status-partial {
            background-color: #fef3c7;
            color: #92400e;
        }

        .status-unpaid {
            background-color: #fef2f2;
            color: #dc2626;
        }

        .invoice-content {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }

        .invoice-items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 2rem;
        }

        .invoice-items-table th,
        .invoice-items-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }

        .invoice-items-table th {
            background-color: #f8fafc;
            font-weight: 600;
            color: #0f172a;
            font-size: 0.875rem;
        }

        .invoice-items-table td {
            color: #475569;
            font-size: 0.875rem;
        }

        .invoice-items-table tbody tr:hover {
            background-color: #f8fafc;
        }

        .totals-section {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #e2e8f0;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
        }

        .total-row.final {
            border-top: 2px solid #06b6d4;
            font-weight: 600;
            font-size: 1.125rem;
            margin-top: 1rem;
            padding-top: 1rem;
        }

        .payments-section {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
            margin-top: 2rem;
        }

        .add-payment-form {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            padding: 1.5rem;
            margin-top: 1.5rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr auto;
            gap: 1rem;
            align-items: end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }

        .form-control {
            padding: 0.75rem 1rem;
            border: 1px solid #d1d5db;
            border-radius: 0.5rem;
            font-size: 1rem;
            transition: all 0.2s ease-in-out;
        }

        .form-control:focus {
            outline: none;
            border-color: #06b6d4;
            box-shadow: 0 0 0 3px rgba(6, 182, 212, 0.1);
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: all 0.2s ease-in-out;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.875rem;
        }

        .btn-primary {
            background-color: #06b6d4;
            color: #ffffff;
        }

        .btn-primary:hover {
            background-color: #0891b2;
        }

        .btn-secondary {
            background-color: #64748b;
            color: #ffffff;
        }

        .btn-secondary:hover {
            background-color: #475569;
        }

        .btn-danger {
            background-color: #dc2626;
            color: #ffffff;
        }

        .btn-danger:hover {
            background-color: #b91c1c;
        }

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.75rem;
        }

        .alert {
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .alert-success {
            background-color: #f0fdf4;
            color: #16a34a;
            border: 1px solid #bbf7d0;
        }

        .alert-error {
            background-color: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        .actions-section {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #e2e8f0;
        }

        .payment-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr 1fr auto;
            gap: 1rem;
            align-items: center;
            padding: 1rem;
            border-bottom: 1px solid #e2e8f0;
        }

        .payment-row:last-child {
            border-bottom: none;
        }

        @media (max-width: 768px) {
            .invoice-header-row {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .form-row {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .actions-section {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>
    
    <c:set var="_role" value="${empty sessionScope.user or empty sessionScope.user.role or empty sessionScope.user.role.roleName ? '' : fn:toLowerCase(fn:replace(sessionScope.user.role.roleName, ' ', ''))}"/>
    <c:if test="${_role ne 'receptionist'}">
        <c:redirect url="${pageContext.request.contextPath}/login"/>
    </c:if>
    
    <div class="header">
        <h1>🦷 Chi Tiết Hóa Đơn #${invoice.invoiceId}</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="container">
                <div class="invoice-container">
                    <!-- Calculate remaining amount -->
                    <c:set var="remainingAmount" value="${invoice.netAmount != null && totalPaid != null ? invoice.netAmount.subtract(totalPaid) : (invoice.netAmount != null ? invoice.netAmount : 0)}"/>
                    
                    <!-- Alert Messages -->
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle" style="margin-right: 0.5rem;"></i>
                            ${successMessage}
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-triangle" style="margin-right: 0.5rem;"></i>
                            ${errorMessage}
                        </div>
                    </c:if>

                    <!-- Invoice Header -->
                    <div class="invoice-header">
                        <div class="invoice-header-row">
                            <div class="header-section">
                                <h3>Thông Tin Hóa Đơn</h3>
                                <p><strong>Mã Hóa Đơn:</strong> #${invoice.invoiceId}</p>
                                <p><strong>Ngày Tạo:</strong> <c:out value="${invoice.getFormattedCreatedAt()}"/></p>
                                <c:if test="${not empty invoice.appointment}">
                                    <p><strong>Lịch Hẹn:</strong> #${invoice.appointment.appointmentId}</p>
                                </c:if>
                            </div>
                            <div class="header-section">
                                <h3>Thông Tin Bệnh Nhân</h3>
                                <c:choose>
                                    <c:when test="${not empty invoice.patient}">
                                        <p><strong>Tên:</strong> ${invoice.patient.fullName}</p>
                                        <c:if test="${not empty invoice.patient.phone}">
                                            <p><strong>Số Điện Thoại:</strong> ${invoice.patient.phone}</p>
                                        </c:if>
                                        <c:if test="${not empty invoice.patient.email}">
                                            <p><strong>Email:</strong> ${invoice.patient.email}</p>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <p><strong>Mã Bệnh Nhân:</strong> ${invoice.patientId}</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div>
                            <c:choose>
                                <c:when test="${invoice.status eq 'PAID'}">
                                    <span class="status-badge status-paid">Đã thanh toán</span>
                                </c:when>
                                <c:when test="${invoice.status eq 'PARTIAL'}">
                                    <span class="status-badge status-partial">Thanh toán một phần</span>
                                </c:when>
                                <c:when test="${invoice.status eq 'UNPAID'}">
                                    <span class="status-badge status-unpaid">Chưa thanh toán</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge">${invoice.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Invoice Content -->
                    <div class="invoice-content">
                        <h3 style="margin-bottom: 1.5rem; color: #0f172a;">Chi Tiết Dịch Vụ</h3>
                        
                        <c:choose>
                            <c:when test="${not empty invoice.items}">
                                <table class="invoice-items-table">
                                    <thead>
                                        <tr>
                                            <th>Dịch Vụ</th>
                                            <th>Số Lượng</th>
                                            <th>Đơn Giá</th>
                                            <th>Thành Tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${invoice.items}">
                                            <tr>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty item.service}">
                                                            <strong>${item.service.name}</strong>
                                                            <c:if test="${not empty item.service.description}">
                                                                <br><small style="color: #64748b;">${item.service.description}</small>
                                                            </c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            Dịch vụ #${item.serviceId}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${item.quantity}</td>
                                                <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                                <td><strong><fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></strong></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div style="text-align: center; padding: 2rem; color: #64748b;">
                                    <i class="fas fa-file-invoice" style="font-size: 3rem; margin-bottom: 1rem; color: #94a3b8;"></i>
                                    <p>Không có dịch vụ nào trong hóa đơn này.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- Totals -->
                        <div class="totals-section">
                            <div class="total-row">
                                <span>Tổng Tiền:</span>
                                <span><fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                            </div>
                            <div class="total-row">
                                <span>Giảm Giá:</span>
                                <span><fmt:formatNumber value="${invoice.discountAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                            </div>
                            <div class="total-row final">
                                <span>Thành Tiền:</span>
                                <span><fmt:formatNumber value="${invoice.netAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                            </div>
                        </div>
                    </div>

                    <!-- Payments Section -->
                    <div class="payments-section">
                        <h3 style="margin-bottom: 1.5rem; color: #0f172a;">Lịch Sử Thanh Toán</h3>
                        
                        <c:choose>
                            <c:when test="${not empty payments}">
                                <div style="margin-bottom: 1.5rem;">
                                    <c:forEach var="payment" items="${payments}">
                                        <div class="payment-row">
                                            <div>
                                                <strong>Mã Thanh Toán:</strong> #${payment.paymentId}
                                            </div>
                                            <div>
                                                <fmt:formatNumber value="${payment.amount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                            </div>
                                            <div>
                                                <c:choose>
                                                    <c:when test="${payment.method eq 'CASH'}">Tiền mặt</c:when>
                                                    <c:when test="${payment.method eq 'CARD'}">Thẻ</c:when>
                                                    <c:when test="${payment.method eq 'BANK_TRANSFER'}">Chuyển khoản</c:when>
                                                    <c:otherwise>${payment.method}</c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div>
                                                <c:out value="${payment.getFormattedPaidAt()}"/>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                
                                <div class="total-row" style="border-top: 1px solid #e2e8f0; padding-top: 1rem;">
                                    <strong>Đã Thanh Toán:</strong>
                                    <strong><fmt:formatNumber value="${totalPaid}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></strong>
                                </div>
                                
                                <div class="total-row final">
                                    <span>Còn Lại:</span>
                                    <span><fmt:formatNumber value="${invoice.netAmount.subtract(totalPaid)}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p style="color: #64748b; text-align: center; padding: 2rem;">Chưa có thanh toán nào.</p>
                            </c:otherwise>
                        </c:choose>

                        <!-- Add Payment Form -->
                        <c:if test="${invoice.status ne 'PAID'}">
                            <div class="add-payment-form">
                                <h4 style="margin-bottom: 1rem; color: #0f172a;">Thêm Thanh Toán</h4>
                                <form method="POST" action="${pageContext.request.contextPath}/receptionist/invoices">
                                    <input type="hidden" name="action" value="addPayment">
                                    <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">
                                    
                                    <div class="form-row">
                                        <div class="form-group">
                                            <label for="amount">Số Tiền <span style="color: #dc2626;">*</span></label>
                                            <input type="number" 
                                                   id="amount" 
                                                   name="amount" 
                                                   class="form-control" 
                                                   step="0.01" 
                                                   min="0.01"
                                                   required>
                                        </div>
                                        <div class="form-group">
                                            <label for="method">Phương Thức <span style="color: #dc2626;">*</span></label>
                                            <select id="method" name="method" class="form-control" required>
                                                <option value="">Chọn phương thức</option>
                                                <option value="CASH">Tiền mặt</option>
                                                <option value="CARD">Thẻ</option>
                                                <option value="BANK_TRANSFER">Chuyển khoản</option>
                                            </select>
                                        </div>
                                        <div>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-plus"></i>
                                                Thêm Thanh Toán
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </c:if>
                    </div>

                    <!-- Actions -->
                    <div class="actions-section">
                        <a href="${pageContext.request.contextPath}/receptionist/invoices" 
                           class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i>
                            Quay Lại
                        </a>
                        <c:if test="${not empty invoice.patient}">
                            <a href="${pageContext.request.contextPath}/receptionist/patients?action=view&id=${invoice.patient.patientId}" 
                               class="btn btn-secondary">
                                <i class="fas fa-user"></i>
                                Xem Bệnh Nhân
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Set max amount validation
        document.addEventListener('DOMContentLoaded', function() {
            const amountInput = document.getElementById('amount');
            if (amountInput) {
                // Convert BigDecimal to number safely
                const maxAmountValue = ${remainingAmount != null ? remainingAmount : 0};
                const maxAmount = typeof maxAmountValue === 'number' ? maxAmountValue : parseFloat(maxAmountValue) || 0;
                
                if (maxAmount > 0) {
                    amountInput.setAttribute('max', maxAmount);
                    amountInput.setAttribute('placeholder', 'Tối đa: ' + maxAmount.toLocaleString('vi-VN') + ' ₫');
                }
                
                amountInput.addEventListener('input', function() {
                    const inputAmount = parseFloat(this.value) || 0;
                    
                    if (maxAmount > 0 && inputAmount > maxAmount) {
                        this.setCustomValidity('Số tiền không được vượt quá số còn lại');
                    } else {
                        this.setCustomValidity('');
                    }
                });
            }
        });
    </script>
</body>
</html>
