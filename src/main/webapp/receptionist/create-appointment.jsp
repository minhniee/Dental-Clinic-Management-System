<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${action eq 'update'}">Chỉnh Sửa Lịch Hẹn</c:when>
            <c:otherwise>Đặt Lịch Hẹn Mới</c:otherwise>
        </c:choose>
        - Hệ Thống Quản Lý Phòng Khám Nha Khoa
    </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/receptionist.css">
    <style>
        .form-container {
            max-width: 900px;
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
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .form-group .required {
            color: #dc2626;
            font-weight: 700;
        }

        .form-group label::after {
            content: '';
        }

        .form-group label:has(.required)::after {
            content: '*';
            color: #dc2626;
            font-weight: 700;
            margin-left: 0.25rem;
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

        .form-control.error {
            border-color: #dc2626;
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.1);
        }

        .error-message {
            color: #dc2626;
            font-size: 0.75rem;
            margin-top: 0.25rem;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .error-message i {
            font-size: 0.75rem;
        }

        .validation-summary {
            background-color: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
            display: none;
        }

        .validation-summary.show {
            display: block;
        }

        .validation-summary h4 {
            margin: 0 0 0.5rem 0;
            font-size: 0.875rem;
            font-weight: 600;
        }

        .validation-summary ul {
            margin: 0;
            padding-left: 1.25rem;
        }

        .validation-summary li {
            font-size: 0.75rem;
            margin-bottom: 0.25rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .validation-summary li::before {
            content: '•';
            color: #dc2626;
            font-weight: bold;
        }

        .form-group:has(.error) label {
            color: #dc2626;
        }

        .form-group:has(.error) .help-text {
            color: #dc2626;
        }

        .business-hours-info {
            background-color: #f0f9ff;
            border: 1px solid #0ea5e9;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
            color: #0c4a6e;
        }

        .business-hours-info h4 {
            margin: 0 0 0.5rem 0;
            font-size: 0.875rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .business-hours-info ul {
            margin: 0;
            padding-left: 1.25rem;
            font-size: 0.75rem;
        }

        .business-hours-info li {
            margin-bottom: 0.25rem;
        }

        .help-text {
            color: #64748b;
            font-size: 0.75rem;
            margin-top: 0.25rem;
        }

        /* DateTime Input Styling */
        .datetime-container {
            display: flex;
            gap: 0.75rem;
            align-items: stretch;
            flex-wrap: wrap;
        }

        .datetime-input-wrapper {
            flex: 1;
            min-width: 200px;
        }

        .datetime-input {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #d1d5db;
            border-radius: 0.5rem;
            font-size: 1rem;
            transition: all 0.2s ease-in-out;
            background-color: #ffffff;
        }

        .datetime-input:focus {
            outline: none;
            border-color: #06b6d4;
            box-shadow: 0 0 0 3px rgba(6, 182, 212, 0.1);
        }

        .datetime-input.error {
            border-color: #dc2626;
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.1);
        }

        .datetime-input.invalid-minutes {
            border-color: #f59e0b;
            box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.1);
            background-color: #fffbeb;
        }

        .minutes-warning {
            background-color: #fef3c7;
            color: #92400e;
            border: 1px solid #fcd34d;
            border-radius: 0.375rem;
            padding: 0.5rem 0.75rem;
            margin-top: 0.5rem;
            font-size: 0.75rem;
            display: none;
        }

        .minutes-warning.show {
            display: block;
        }

        .minutes-warning i {
            margin-right: 0.5rem;
        }

        .current-time-btn {
            padding: 0.75rem 1.25rem;
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
            background-color: #64748b;
            color: #ffffff;
            white-space: nowrap;
            min-height: 48px;
        }

        .current-time-btn:hover {
            background-color: #475569;
            transform: translateY(-1px);
        }

        .current-time-btn:active {
            transform: translateY(0);
        }

        .current-time-btn.success {
            background-color: #059669;
        }

        .datetime-help {
            margin-top: 0.5rem;
            padding: 0.75rem;
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            font-size: 0.75rem;
            color: #475569;
        }

        .datetime-help h5 {
            margin: 0 0 0.5rem 0;
            font-size: 0.75rem;
            font-weight: 600;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .datetime-help ul {
            margin: 0;
            padding-left: 1rem;
        }

        .datetime-help li {
            margin-bottom: 0.25rem;
        }

        @media (max-width: 640px) {
            .datetime-container {
                flex-direction: column;
                gap: 0.5rem;
            }
            
            .datetime-input-wrapper {
                min-width: unset;
            }
            
            .current-time-btn {
                width: 100%;
                justify-content: center;
            }
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

        .conflict-warning {
            background-color: #fef3c7;
            color: #92400e;
            border: 1px solid #fcd34d;
            margin-bottom: 1.5rem;
            padding: 1rem;
            border-radius: 0.5rem;
        }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
                gap: 1rem;
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
        <h1>
            <c:choose>
                <c:when test="${action eq 'update'}">🦷 Chỉnh Sửa Lịch Hẹn</c:when>
                <c:otherwise>🦷 Đặt Lịch Hẹn Mới</c:otherwise>
            </c:choose>
        </h1>
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
                        <h2>
                            <c:choose>
                                <c:when test="${action eq 'update'}">Chỉnh Sửa Lịch Hẹn</c:when>
                                <c:otherwise>Đặt Lịch Hẹn Mới</c:otherwise>
                            </c:choose>
                        </h2>
                        <p>
                            <c:choose>
                                <c:when test="${action eq 'update'}">
                                    Cập nhật thông tin lịch hẹn
                                </c:when>
                                <c:otherwise>
                                    Tạo lịch hẹn mới cho bệnh nhân
                                </c:otherwise>
                            </c:choose>
                        </p>
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

                    <!-- Business Hours Information -->
                    <div class="business-hours-info">
                        <h4><i class="fas fa-clock"></i> Thông Tin Giờ Làm Việc</h4>
                        <ul>
                            <li>Giờ làm việc: 8:00 - 18:00</li>
                            <li>Ngày làm việc: Thứ 2 - Thứ 6</li>
                            <li>Bước nhảy thời gian: 30 phút (8:00, 8:30, 9:00, 9:30, ...)</li>
                            <li>Có thể đặt lịch trong ngày hiện tại nếu thời gian còn hợp lệ</li>
                            <li>Không thể đặt lịch vào cuối tuần hoặc ngoài giờ làm việc</li>
                            <li>Không thể đặt lịch trước 30 phút từ thời điểm hiện tại</li>
                        </ul>
                    </div>

                    <!-- Validation Summary -->
                    <div id="validationSummary" class="validation-summary">
                        <h4><i class="fas fa-exclamation-triangle"></i> Vui lòng kiểm tra lại các thông tin sau:</h4>
                        <ul id="validationErrors"></ul>
                    </div>

                    <!-- Appointment Form -->
                    <form method="POST" action="${pageContext.request.contextPath}/receptionist/appointments" class="needs-validation" novalidate>
                        <input type="hidden" name="action" value="${action eq 'update' ? 'update' : 'create'}">
                        <c:if test="${action eq 'update' and not empty appointment}">
                            <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                        </c:if>

                        <!-- Patient Selection Section -->
                        <div class="form-group full-width">
                            <label>
                                Bệnh Nhân <span class="required">*</span>
                            </label>
                            
                            <!-- Quick Patient Search -->
                            <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 0.5rem; padding: 1rem; margin-bottom: 1rem;">
                                <h4 style="margin: 0 0 0.5rem 0; color: #0f172a; font-size: 0.875rem; font-weight: 600;">
                                    <i class="fas fa-search" style="margin-right: 0.5rem; color: #06b6d4;"></i>
                                    Tìm Kiếm Nhanh Bệnh Nhân
                                </h4>
                                <div style="display: flex; gap: 1rem; align-items: end;">
                                    <div style="flex: 1;">
                                        <input type="tel" 
                                               id="quickSearchPhone" 
                                               class="form-control" 
                                               placeholder="Nhập số điện thoại để tìm kiếm"
                                               style="margin-bottom: 0;">
                                    </div>
                                    <button type="button" id="quickSearchBtn" class="btn btn-primary" style="margin-bottom: 0;">
                                        <i class="fas fa-search"></i>
                                        Tìm Kiếm
                                    </button>
                                    <a href="${pageContext.request.contextPath}/receptionist/patients?action=new" 
                                       class="btn btn-secondary" style="margin-bottom: 0;">
                                        <i class="fas fa-user-plus"></i>
                                        Đăng Ký Mới
                                    </a>
                                </div>
                                <div id="quickSearchResult" style="margin-top: 1rem; display: none;"></div>
                            </div>
                            
                            <!-- Patient Selection Dropdown -->
                            <select id="patientId" name="patientId" class="form-control" required>
                                <option value="">Chọn bệnh nhân từ danh sách</option>
                                <c:forEach var="patient" items="${patients}">
                                    <option value="${patient.patientId}" 
                                            ${(action eq 'update' and appointment.patientId eq patient.patientId) or 
                                              (not empty selectedPatient and selectedPatient.patientId eq patient.patientId) ? 'selected' : ''}>
                                        ${patient.fullName} - ${patient.phone}
                                    </option>
                                </c:forEach>
                            </select>
                            <div id="patientId-error" class="error-message" style="display: none;">
                                <i class="fas fa-exclamation-circle"></i>
                                <span>Vui lòng chọn bệnh nhân</span>
                            </div>
                            <div class="help-text">Chọn bệnh nhân từ danh sách hoặc sử dụng tìm kiếm nhanh ở trên</div>
                        </div>

                            <!-- Dentist Selection -->
                            <div class="form-group">
                                <label for="dentistId">
                                    Bác Sĩ <span class="required">*</span>
                                </label>
                                <select id="dentistId" name="dentistId" class="form-control" required>
                                    <option value="">Chọn bác sĩ</option>
                                    <c:forEach var="dentist" items="${dentists}">
                                        <option value="${dentist.userId}" 
                                                ${action eq 'update' and appointment.dentistId eq dentist.userId ? 'selected' : ''}>
                                            ${dentist.fullName}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div id="dentistId-error" class="error-message" style="display: none;">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <span>Vui lòng chọn bác sĩ</span>
                                </div>
                                <div class="help-text">Chọn bác sĩ sẽ thực hiện điều trị</div>
                            </div>
                        </div>

                        <div class="form-row">
                            <!-- Service Selection -->
                            <div class="form-group">
                                <label for="serviceId">
                                    Dịch Vụ <span class="required">*</span>
                                </label>
                                <select id="serviceId" name="serviceId" class="form-control" required>
                                    <option value="">Chọn dịch vụ</option>
                                    <c:forEach var="service" items="${services}">
                                        <option value="${service.serviceId}" 
                                                ${action eq 'update' and appointment.serviceId eq service.serviceId ? 'selected' : ''}
                                                data-price="${service.price}"
                                                data-duration="${service.durationMinutes}">
                                            ${service.name} - 
                                            <fmt:formatNumber value="${service.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                            <c:if test="${service.durationMinutes != null}">
                                                (${service.durationMinutes} phút)
                                            </c:if>
                                        </option>
                                    </c:forEach>
                                </select>
                                <div id="serviceId-error" class="error-message" style="display: none;">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <span>Vui lòng chọn dịch vụ</span>
                                </div>
                                <div class="help-text">Chọn dịch vụ điều trị</div>
                            </div>

                            <!-- Appointment Date and Time -->
                            <div class="form-group">
                                <label for="appointmentDateTime">
                                    Ngày và Giờ Hẹn <span class="required">*</span>
                                </label>
                                <div class="datetime-container">
                                    <div class="datetime-input-wrapper">
                                        <input type="datetime-local" readonly
                                               id="appointmentDateTime" 
                                               name="appointmentDateTime" 
                                               class="datetime-input" 
                                               step="1800"
                                               required 
                                               value="${not empty appointment ? appointment.appointmentDateForInput : ''}">
                                    </div>
                                    <!-- <button type="button" 
                                            id="setCurrentTimeBtn" 
                                            class="current-time-btn">
                                        <i class="fas fa-calendar-day"></i>
                                        <span>Hôm nay</span>
                                    </button> -->
                                </div>
                                <div id="appointmentDateTime-error" class="error-message" style="display: none;">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <span id="appointmentDateTime-error-text">Vui lòng chọn ngày và giờ hẹn</span>
                                </div>
                                <div id="minutesWarning" class="minutes-warning">
                                    <i class="fas fa-exclamation-triangle"></i>
                                    <span>Phút chỉ có thể là 00 hoặc 30. Đã tự động điều chỉnh.</span>
                                </div>
                                <div class="datetime-help">
                                    <h5><i class="fas fa-info-circle"></i> Hướng dẫn đặt lịch</h5>
                                    <ul>
                                        <li>Giờ làm việc: 8:00 - 18:00 (thứ 2 - thứ 6)</li>
                                        <!-- <li><strong>Phút chỉ có thể là 00 hoặc 30</strong> (8:00, 8:30, 9:00, 9:30...)</li>
                                        <li>Có thể đặt lịch trong ngày hiện tại</li>
                                        <li>Không thể đặt lịch trước 30 phút từ hiện tại</li> -->
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Notes -->
                        <div class="form-group full-width">
                            <label for="notes">Ghi Chú</label>
                            <textarea id="notes" 
                                      name="notes" 
                                      class="form-control" 
                                      rows="4"
                                      placeholder="Nhập ghi chú về lịch hẹn (nếu có)">${appointment.notes}</textarea>
                            <div class="help-text">Ghi chú thêm về lịch hẹn, yêu cầu đặc biệt, v.v.</div>
                        </div>

                        <!-- Conflict Warning -->
                        <div id="conflictWarning" class="conflict-warning" style="display: none;">
                            <i class="fas fa-exclamation-triangle"></i>
                            <strong>Cảnh báo:</strong> Thời gian đã chọn có thể trùng với lịch khác. Vui lòng kiểm tra lại.
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/receptionist/appointments" 
                               class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i>
                                Quay Lại
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-calendar-plus"></i>
                                <c:choose>
                                    <c:when test="${action eq 'update'}">Cập Nhật Lịch Hẹn</c:when>
                                    <c:otherwise>Đặt Lịch Hẹn</c:otherwise>
                                </c:choose>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Enhanced form validation with business hours and Vietnamese error messages
        (function() {
            'use strict';
            
            // Business hours configuration
            const BUSINESS_HOURS = {
                startHour: 8,
                endHour: 18,
                workingDays: [1, 2, 3, 4, 5] // Monday to Friday
            };
            
            // Validation functions
            function validatePatient() {
                const patientId = document.getElementById('patientId');
                const errorDiv = document.getElementById('patientId-error');
                
                if (!patientId.value || patientId.value === '') {
                    showError(patientId, errorDiv, 'Vui lòng chọn bệnh nhân');
                    return false;
                } else {
                    hideError(patientId, errorDiv);
                    return true;
                }
            }
            
            function validateDentist() {
                const dentistId = document.getElementById('dentistId');
                const errorDiv = document.getElementById('dentistId-error');
                
                if (!dentistId.value || dentistId.value === '') {
                    showError(dentistId, errorDiv, 'Vui lòng chọn bác sĩ');
                    return false;
                } else {
                    hideError(dentistId, errorDiv);
                    return true;
                }
            }
            
            function validateService() {
                const serviceId = document.getElementById('serviceId');
                const errorDiv = document.getElementById('serviceId-error');
                
                if (!serviceId.value || serviceId.value === '') {
                    showError(serviceId, errorDiv, 'Vui lòng chọn dịch vụ');
                    return false;
                } else {
                    hideError(serviceId, errorDiv);
                    return true;
                }
            }
            
            function validateAppointmentDateTime() {
                const dateTimeInput = document.getElementById('appointmentDateTime');
                const errorDiv = document.getElementById('appointmentDateTime-error');
                const errorText = document.getElementById('appointmentDateTime-error-text');
                
                if (!dateTimeInput.value) {
                    showError(dateTimeInput, errorDiv, 'Vui lòng chọn ngày và giờ hẹn');
                    return false;
                }
                
                const selectedDate = new Date(dateTimeInput.value);
                const now = new Date();
                
                // Check if time is in the past (more than 30 minutes ago)
                const thirtyMinutesAgo = new Date(now.getTime() - (30 * 60 * 1000));
                if (selectedDate <= thirtyMinutesAgo) {
                    errorText.textContent = 'Không thể chọn thời gian đã qua (ít nhất 30 phút trước)';
                    showError(dateTimeInput, errorDiv, 'Không thể chọn thời gian đã qua (ít nhất 30 phút trước)');
                    return false;
                }
                
                // Check business hours
                const hour = selectedDate.getHours();
                const minutes = selectedDate.getMinutes();
                const dayOfWeek = selectedDate.getDay();
                
                if (!BUSINESS_HOURS.workingDays.includes(dayOfWeek)) {
                    errorText.textContent = 'Chỉ có thể đặt lịch từ thứ 2 đến thứ 6';
                    showError(dateTimeInput, errorDiv, 'Chỉ có thể đặt lịch từ thứ 2 đến thứ 6');
                    return false;
                }
                
                if (hour < BUSINESS_HOURS.startHour || hour >= BUSINESS_HOURS.endHour) {
                    errorText.textContent = 'Giờ làm việc từ 8:00 đến 18:00';
                    showError(dateTimeInput, errorDiv, 'Giờ làm việc từ 8:00 đến 18:00');
                    return false;
                }
                
                // Check if minutes are valid (0 or 30)
                if (minutes !== 0 && minutes !== 30) {
                    errorText.textContent = 'Phút chỉ có thể là 00 hoặc 30 (ví dụ: 8:00, 8:30, 9:00)';
                    showError(dateTimeInput, errorDiv, 'Phút chỉ có thể là 00 hoặc 30');
                    return false;
                }
                
                hideError(dateTimeInput, errorDiv);
                return true;
            }
            
            // Expose validation functions to global scope for AJAX usage
            window.validatePatient = validatePatient;
            window.validateDentist = validateDentist;
            window.validateService = validateService;
            window.validateAppointmentDateTime = validateAppointmentDateTime;
            
            function showError(input, errorDiv, message) {
                // Add error class to both datetime-input and form-control for compatibility
                input.classList.add('error');
                if (input.classList.contains('datetime-input')) {
                    input.classList.add('error');
                } else {
                    input.classList.add('error');
                }
                errorDiv.style.display = 'flex';
                errorDiv.querySelector('span').textContent = message;
            }
            
            function hideError(input, errorDiv) {
                input.classList.remove('error');
                errorDiv.style.display = 'none';
            }
            
            function validateForm() {
                const errors = [];
                
                if (!validatePatient()) {
                    errors.push('Vui lòng chọn bệnh nhân');
                }
                
                if (!validateDentist()) {
                    errors.push('Vui lòng chọn bác sĩ');
                }
                
                if (!validateService()) {
                    errors.push('Vui lòng chọn dịch vụ');
                }
                
                if (!validateAppointmentDateTime()) {
                    errors.push('Vui lòng kiểm tra lại ngày và giờ hẹn');
                }
                
                // Show validation summary
                const summaryDiv = document.getElementById('validationSummary');
                const errorsList = document.getElementById('validationErrors');
                
                if (errors.length > 0) {
                    errorsList.innerHTML = '';
                    errors.forEach(error => {
                        const li = document.createElement('li');
                        li.textContent = error;
                        errorsList.appendChild(li);
                    });
                    summaryDiv.classList.add('show');
                    summaryDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    return false;
                } else {
                    summaryDiv.classList.remove('show');
                    return true;
                }
            }
            
            // Initialize form validation
            window.addEventListener('load', function() {
                const form = document.querySelector('.needs-validation');
                
                form.addEventListener('submit', function(event) {
                    event.preventDefault();
                    event.stopPropagation();
                    
                    if (validateForm()) {
                        // If validation passes, submit the form
                        form.submit();
                    }
                });
                
                // Add real-time validation
                document.getElementById('patientId').addEventListener('change', validatePatient);
                document.getElementById('dentistId').addEventListener('change', validateDentist);
                document.getElementById('serviceId').addEventListener('change', validateService);
                document.getElementById('appointmentDateTime').addEventListener('change', validateAppointmentDateTime);
            });
        })();

        // Helper function to get current datetime in Asia/Bangkok timezone
        function getCurrentDateTimeBangkok() {
            // Get current time in Asia/Bangkok timezone (GMT+7)
            const now = new Date();
            const bangkokTime = new Date(now.toLocaleString('en-US', { timeZone: 'Asia/Bangkok' }));
            
            // Format to YYYY-MM-DDTHH:MM for datetime-local input
            const year = bangkokTime.getFullYear();
            const month = String(bangkokTime.getMonth() + 1).padStart(2, '0');
            const day = String(bangkokTime.getDate()).padStart(2, '0');
            const hours = String(bangkokTime.getHours()).padStart(2, '0');
            const minutes = String(bangkokTime.getMinutes()).padStart(2, '0');
            
            return year + '-' + month + '-' + day + 'T' + hours + ':' + minutes;
        }
        
        // Auto-set current date/time if creating new appointment
        document.addEventListener('DOMContentLoaded', function() {
            const dateTimeInput = document.getElementById('appointmentDateTime');
            
            // Only set default if this is a new appointment and no value is set
            var isUpdate = '${action}' === 'update';
            if (!isUpdate && !dateTimeInput.value) {
                // Set current datetime in Bangkok timezone
                dateTimeInput.value = getCurrentDateTimeBangkok();
            }
        });

        // Current time button functionality - Get current datetime in Bangkok timezone
        document.getElementById('setCurrentTimeBtn').addEventListener('click', function() {
            const dateTimeInput = document.getElementById('appointmentDateTime');
            
            // Set the exact current datetime in Bangkok timezone
            dateTimeInput.value = getCurrentDateTimeBangkok();
            
            // Trigger change event to run validation and auto-adjustment
            dateTimeInput.dispatchEvent(new Event('change'));
            
            // Show success message briefly
            const btn = this;
            const originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-check"></i> <span>Đã đặt</span>';
            btn.classList.add('success');
            
            setTimeout(function() {
                btn.innerHTML = originalText;
                btn.classList.remove('success');
            }, 1500);
        });

        // Check for conflicts when date/time changes
        document.getElementById('appointmentDateTime').addEventListener('change', function() {
            const selectedDate = new Date(this.value);
            const now = new Date();
            const conflictWarning = document.getElementById('conflictWarning');
            const minutesWarning = document.getElementById('minutesWarning');
            const input = this;
            
            // Clear previous warnings
            input.classList.remove('invalid-minutes');
            minutesWarning.classList.remove('show');
            
            // Check if time is more than 30 minutes in the past
            const thirtyMinutesAgo = new Date(now.getTime() - (30 * 60 * 1000));
            if (selectedDate <= thirtyMinutesAgo) {
                // Reset to minimum allowed time within business hours (30-minute intervals)
                let minDateTime = new Date(now);
                minDateTime.setMinutes(Math.ceil(minDateTime.getMinutes() / 30) * 30);
                
                // Ensure it's within business hours
                if (minDateTime.getDay() === 0) { // Sunday
                    minDateTime.setDate(minDateTime.getDate() + 1);
                    minDateTime.setHours(8, 0, 0, 0);
                } else if (minDateTime.getDay() === 6) { // Saturday
                    minDateTime.setDate(minDateTime.getDate() + 2);
                    minDateTime.setHours(8, 0, 0, 0);
                } else if (minDateTime.getHours() < 8) {
                    minDateTime.setHours(8, 0, 0, 0);
                } else if (minDateTime.getHours() >= 18) {
                    minDateTime.setDate(minDateTime.getDate() + 1);
                    minDateTime.setHours(8, 0, 0, 0);
                }
                
                this.value = minDateTime.toISOString().slice(0, 16);
                
                conflictWarning.style.display = 'block';
                conflictWarning.innerHTML = 
                    '<i class="fas fa-exclamation-triangle"></i><strong>Cảnh báo:</strong> Không thể chọn thời gian đã qua (ít nhất 30 phút trước). Đã tự động điều chỉnh về giờ làm việc gần nhất.';
            } else {
                // Check if it's within business hours
                const hour = selectedDate.getHours();
                const minutes = selectedDate.getMinutes();
                const dayOfWeek = selectedDate.getDay();
                
                if (![1, 2, 3, 4, 5].includes(dayOfWeek)) {
                    conflictWarning.style.display = 'block';
                    conflictWarning.innerHTML = 
                        '<i class="fas fa-exclamation-triangle"></i><strong>Cảnh báo:</strong> Chỉ có thể đặt lịch từ thứ 2 đến thứ 6.';
                } else if (hour < 8 || hour >= 18) {
                    conflictWarning.style.display = 'block';
                    conflictWarning.innerHTML = 
                        '<i class="fas fa-exclamation-triangle"></i><strong>Cảnh báo:</strong> Giờ làm việc từ 8:00 đến 18:00.';
                } else if (minutes !== 0 && minutes !== 30) {
                    // Auto-adjust to nearest 30-minute interval
                    const adjustedDate = new Date(selectedDate);
                    const originalMinutes = minutes;
                    
                    if (minutes < 15) {
                        adjustedDate.setMinutes(0);
                    } else if (minutes < 45) {
                        adjustedDate.setMinutes(30);
                    } else {
                        adjustedDate.setMinutes(0);
                        adjustedDate.setHours(adjustedDate.getHours() + 1);
                    }
                    
                    this.value = adjustedDate.toISOString().slice(0, 16);
                    
                    // Show minutes warning
                    input.classList.add('invalid-minutes');
                    minutesWarning.classList.add('show');
                    
                    // Hide conflict warning since we handled it
                    conflictWarning.style.display = 'none';
                } else {
                    conflictWarning.style.display = 'none';
                }
            }
        });

        // Patient search functionality (basic)
        document.getElementById('patientId').addEventListener('change', function() {
            // Could add patient details display here
        });

        // Service change handler
        document.getElementById('serviceId').addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            const duration = selectedOption.getAttribute('data-duration');
            
            // Could display estimated duration here
            if (duration && duration !== 'null') {
                console.log('Service duration: ' + duration + ' minutes');
            }
        });

        // Quick patient search functionality
        document.getElementById('quickSearchBtn').addEventListener('click', function() {
            const phone = document.getElementById('quickSearchPhone').value.trim();
            const resultDiv = document.getElementById('quickSearchResult');
            const patientSelect = document.getElementById('patientId');
            
            if (!phone) {
                resultDiv.innerHTML = '<div style="color: #dc2626; font-size: 0.875rem;"><i class="fas fa-exclamation-circle"></i> Vui lòng nhập số điện thoại</div>';
                resultDiv.style.display = 'block';
                return;
            }
            
            // Show loading
            resultDiv.innerHTML = '<div style="color: #64748b; font-size: 0.875rem;"><i class="fas fa-spinner fa-spin"></i> Đang tìm kiếm...</div>';
            resultDiv.style.display = 'block';
            
            // Make AJAX request to search for patient
            fetch('${pageContext.request.contextPath}/receptionist/patients?action=search&phone=' + encodeURIComponent(phone))
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Patient found - auto-select in dropdown
                        let patientFound = false;
                        for (let i = 0; i < patientSelect.options.length; i++) {
                            if (patientSelect.options[i].value == data.patientId) {
                                patientSelect.selectedIndex = i;
                                patientFound = true;
                                break;
                            }
                        }
                        
                        if (patientFound) {
                            // Show success message with patient info
                            resultDiv.innerHTML = '<div style="background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 0.5rem; padding: 1rem; color: #16a34a; font-size: 0.875rem;">' +
                                '<div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.5rem;"><i class="fas fa-check-circle" style="color: #16a34a;"></i><strong>Tìm thấy bệnh nhân!</strong></div>' +
                                '<div style="color: #15803d;"><strong>Tên:</strong> ' + data.fullName + '</div>' +
                                '<div style="color: #15803d;"><strong>SĐT:</strong> ' + data.phone + '</div>' +
                                (data.email ? '<div style="color: #15803d;"><strong>Email:</strong> ' + data.email + '</div>' : '') +
                                '</div>';
                            
                            // Trigger validation
                            validatePatient();
                            
                            // Scroll to patient select
                            patientSelect.scrollIntoView({ behavior: 'smooth', block: 'center' });
                            patientSelect.focus();
                        } else {
                            // Patient found in DB but not in dropdown (shouldn't happen)
                            resultDiv.innerHTML = '<div style="color: #d97706; font-size: 0.875rem;"><i class="fas fa-exclamation-triangle"></i> Bệnh nhân được tìm thấy nhưng không có trong danh sách. Vui lòng tải lại trang.</div>';
                        }
                    } else {
                        // Patient not found
                        resultDiv.innerHTML = '<div style="background: #fffbeb; border: 1px solid #fcd34d; border-radius: 0.5rem; padding: 1rem; color: #92400e; font-size: 0.875rem;">' +
                            '<div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.5rem;"><i class="fas fa-exclamation-triangle" style="color: #d97706;"></i><strong>Không tìm thấy bệnh nhân</strong></div>' +
                            '<div>Số điện thoại <strong>' + phone + '</strong> chưa được đăng ký.</div>' +
                            '<div style="margin-top: 0.5rem;">Vui lòng <a href="${pageContext.request.contextPath}/receptionist/patients?action=new" style="color: #0891b2; font-weight: 600; text-decoration: underline;">đăng ký bệnh nhân mới</a>.</div>' +
                            '</div>';
                    }
                })
                .catch(error => {
                    console.error('Search error:', error);
                    resultDiv.innerHTML = '<div style="color: #dc2626; font-size: 0.875rem;"><i class="fas fa-exclamation-circle"></i> Lỗi khi tìm kiếm: ' + error.message + '. Vui lòng thử lại.</div>';
                });
        });

        // Auto-search when Enter is pressed in phone field
        document.getElementById('quickSearchPhone').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                document.getElementById('quickSearchBtn').click();
            }
        });
    </script>
</body>
</html>
