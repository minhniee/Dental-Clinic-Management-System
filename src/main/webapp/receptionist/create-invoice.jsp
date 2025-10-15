<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo Hóa Đơn - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .form-container {
            max-width: 1000px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }

        .form-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .form-header h2 {
            color: #0f172a;
            font-size: 1.875rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .form-header p {
            color: #475569;
            font-size: 1rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }

        .form-group .required {
            color: #dc2626;
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

        .items-section {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .items-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .item-row {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr auto;
            gap: 1rem;
            align-items: end;
            margin-bottom: 1rem;
            padding: 1rem;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 0.375rem;
        }

        .totals-section {
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
        }

        .total-row.final {
            border-top: 2px solid #06b6d4;
            font-weight: 600;
            font-size: 1.125rem;
            margin-top: 0.5rem;
            padding-top: 1rem;
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

        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #e2e8f0;
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

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .item-row {
                grid-template-columns: 1fr;
                gap: 0.5rem;
            }
            
            .form-actions {
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
        <h1>🦷 Tạo Hóa Đơn</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="container">
                <div class="form-container">
                    
                    <!-- Form Header -->
                    <div class="form-header">
                        <h2>Tạo Hóa Đơn Mới</h2>
                        <p>Nhập thông tin để tạo hóa đơn cho bệnh nhân</p>
                    </div>

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

                    <!-- Invoice Form -->
                    <form method="POST" action="${pageContext.request.contextPath}/receptionist/invoices" class="needs-validation" novalidate>
                        <input type="hidden" name="action" value="create">

                        <div class="form-row">
                            <!-- Patient Selection -->
                            <div class="form-group">
                                <label for="patientId">
                                    Bệnh Nhân <span class="required">*</span>
                                </label>
                                <select id="patientId" name="patientId" class="form-control" required>
                                    <option value="">Chọn bệnh nhân</option>
                                    <c:forEach var="patient" items="${patients}">
                                        <option value="${patient.patientId}" 
                                                ${not empty selectedPatient and selectedPatient.patientId eq patient.patientId ? 'selected' : ''}>
                                            ${patient.fullName} - ${patient.phone}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Optional Appointment -->
                            <div class="form-group">
                                <label for="appointmentId">Lịch Hẹn (Tùy chọn)</label>
                                <input type="number" 
                                       id="appointmentId" 
                                       name="appointmentId" 
                                       class="form-control"
                                       value="${not empty selectedAppointment ? selectedAppointment.appointmentId : ''}"
                                       placeholder="ID lịch hẹn">
                            </div>
                        </div>

                        <!-- Invoice Items Section -->
                        <div class="items-section">
                            <div class="items-header">
                                <h3 style="margin: 0;">Chi Tiết Dịch Vụ</h3>
                                <button type="button" class="btn btn-secondary btn-sm" onclick="addItemRow()">
                                    <i class="fas fa-plus"></i> Thêm Dịch Vụ
                                </button>
                            </div>
                            
                            <div id="itemsContainer">
                                <!-- First item row -->
                                <div class="item-row">
                                    <div class="form-group">
                                        <label>Dịch Vụ <span class="required">*</span></label>
                                        <select name="serviceIds" class="form-control" required onchange="updateUnitPrice(this)">
                                            <option value="">Chọn dịch vụ</option>
                                            <c:forEach var="service" items="${services}">
                                                <option value="${service.serviceId}" data-price="${service.price}">
                                                    ${service.name} - <fmt:formatNumber value="${service.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Số Lượng <span class="required">*</span></label>
                                        <input type="number" name="quantities" class="form-control" value="1" min="1" required onchange="calculateTotal(this)">
                                    </div>
                                    <div class="form-group">
                                        <label>Đơn Giá <span class="required">*</span></label>
                                        <input type="number" name="unitPrices" class="form-control" step="0.01" min="0" required onchange="calculateTotal(this)">
                                    </div>
                                    <div class="form-group">
                                        <label>Thành Tiền</label>
                                        <input type="text" class="form-control item-total" readonly>
                                    </div>
                                    <div class="form-group">
                                        <button type="button" class="btn btn-danger btn-sm" onclick="removeItemRow(this)" style="margin-top: 1.75rem;">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Discount Section -->
                        <div class="form-row">
                            <div class="form-group">
                                <label for="discountAmount">Giảm Giá</label>
                                <input type="number" 
                                       id="discountAmount" 
                                       name="discountAmount" 
                                       class="form-control" 
                                       step="0.01" 
                                       min="0"
                                       value="0"
                                       onchange="calculateInvoiceTotal()">
                                <div class="help-text">Số tiền giảm giá (không bắt buộc)</div>
                            </div>
                        </div>

                        <!-- Totals Section -->
                        <div class="totals-section">
                            <div class="total-row">
                                <span>Tổng Tiền:</span>
                                <span id="subtotal">₫0</span>
                            </div>
                            <div class="total-row">
                                <span>Giảm Giá:</span>
                                <span id="discount-display">₫0</span>
                            </div>
                            <div class="total-row final">
                                <span>Thành Tiền:</span>
                                <span id="final-total">₫0</span>
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/receptionist/invoices" 
                               class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i>
                                Quay Lại
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i>
                                Tạo Hóa Đơn
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Add new item row
        function addItemRow() {
            const container = document.getElementById('itemsContainer');
            const newRow = document.createElement('div');
            newRow.className = 'item-row';
            newRow.innerHTML = `
                <div class="form-group">
                    <label>Dịch Vụ <span class="required">*</span></label>
                    <select name="serviceIds" class="form-control" required onchange="updateUnitPrice(this)">
                        <option value="">Chọn dịch vụ</option>
                        <c:forEach var="service" items="${services}">
                            <option value="${service.serviceId}" data-price="${service.price}">
                                ${service.name} - <fmt:formatNumber value="${service.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label>Số Lượng <span class="required">*</span></label>
                    <input type="number" name="quantities" class="form-control" value="1" min="1" required onchange="calculateTotal(this)">
                </div>
                <div class="form-group">
                    <label>Đơn Giá <span class="required">*</span></label>
                    <input type="number" name="unitPrices" class="form-control" step="0.01" min="0" required onchange="calculateTotal(this)">
                </div>
                <div class="form-group">
                    <label>Thành Tiền</label>
                    <input type="text" class="form-control item-total" readonly>
                </div>
                <div class="form-group">
                    <button type="button" class="btn btn-danger btn-sm" onclick="removeItemRow(this)" style="margin-top: 1.75rem;">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            `;
            container.appendChild(newRow);
        }

        // Remove item row
        function removeItemRow(button) {
            button.closest('.item-row').remove();
            calculateInvoiceTotal();
        }

        // Update unit price when service is selected
        function updateUnitPrice(selectElement) {
            const selectedOption = selectElement.options[selectElement.selectedIndex];
            const price = selectedOption.getAttribute('data-price');
            const row = selectElement.closest('.item-row');
            const unitPriceInput = row.querySelector('input[name="unitPrices"]');
            
            if (price && price !== 'null') {
                unitPriceInput.value = parseFloat(price) || 0;
            } else {
                unitPriceInput.value = 0;
            }
            
            calculateTotal(unitPriceInput);
        }

        // Calculate item total
        function calculateTotal(inputElement) {
            const row = inputElement.closest('.item-row');
            const quantityInput = row.querySelector('input[name="quantities"]');
            const unitPriceInput = row.querySelector('input[name="unitPrices"]');
            const totalInput = row.querySelector('.item-total');
            
            const quantity = parseFloat(quantityInput.value) || 0;
            const unitPrice = parseFloat(unitPriceInput.value) || 0;
            const total = quantity * unitPrice;
            
            totalInput.value = formatCurrency(total);
            calculateInvoiceTotal();
        }

        // Calculate invoice total
        function calculateInvoiceTotal() {
            let subtotal = 0;
            const itemTotals = document.querySelectorAll('.item-total');
            
            itemTotals.forEach(totalInput => {
                const value = parseFloat(totalInput.value.replace(/[₫,]/g, '')) || 0;
                subtotal += value;
            });
            
            const discountAmount = parseFloat(document.getElementById('discountAmount').value) || 0;
            const finalTotal = Math.max(0, subtotal - discountAmount);
            
            document.getElementById('subtotal').textContent = formatCurrency(subtotal);
            document.getElementById('discount-display').textContent = formatCurrency(discountAmount);
            document.getElementById('final-total').textContent = formatCurrency(finalTotal);
        }

        // Format currency
        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND',
                minimumFractionDigits: 0
            }).format(amount).replace('VND', '₫');
        }

        // Form validation
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                var forms = document.getElementsByClassName('needs-validation');
                var validation = Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();

        // Initialize calculation on page load
        document.addEventListener('DOMContentLoaded', function() {
            calculateInvoiceTotal();
        });
    </script>
</body>
</html>
