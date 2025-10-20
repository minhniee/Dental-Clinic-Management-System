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

        .form-control.error {
            border-color: #dc2626;
        }

        .error-message {
            color: #dc2626;
            font-size: 0.75rem;
            margin-top: 0.25rem;
        }

        .help-text {
            color: #64748b;
            font-size: 0.75rem;
            margin-top: 0.25rem;
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
                                <div class="help-text">Chọn dịch vụ điều trị</div>
                            </div>

                            <!-- Appointment Date and Time -->
                            <div class="form-group">
                                <label for="appointmentDateTime">
                                    Ngày và Giờ Hẹn <span class="required">*</span>
                                </label>
                                <input type="datetime-local" 
                                       id="appointmentDateTime" 
                                       name="appointmentDateTime" 
                                       class="form-control" 
                                       required 
                                       value="${not empty appointment ? appointment.appointmentDateForInput : ''}">
                                <div class="help-text">Chọn ngày và giờ hẹn khám</div>
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

        // Auto-set current date/time if creating new appointment
        document.addEventListener('DOMContentLoaded', function() {
            const dateTimeInput = document.getElementById('appointmentDateTime');
            
            // Set minimum date/time to now
            const now = new Date();
            const minDateTime = now.toISOString().slice(0, 16);
            dateTimeInput.min = minDateTime;
            
            // Only set default if this is a new appointment and no value is set
            <c:if test="${action ne 'update'}">
                if (!dateTimeInput.value) {
                    // Round to next 15 minutes
                    const rounded = new Date(Math.ceil(now.getTime() / (15 * 60 * 1000)) * (15 * 60 * 1000));
                    dateTimeInput.value = rounded.toISOString().slice(0, 16);
                }
            </c:if>
        });

        // Check for conflicts when date/time changes
        document.getElementById('appointmentDateTime').addEventListener('change', function() {
            const selectedDate = new Date(this.value);
            const now = new Date();
            
            if (selectedDate <= now) {
                // Reset to minimum allowed time
                const minDateTime = now.toISOString().slice(0, 16);
                this.value = minDateTime;
                
                document.getElementById('conflictWarning').style.display = 'block';
                document.getElementById('conflictWarning').innerHTML = 
                    '<i class="fas fa-exclamation-triangle"></i><strong>Cảnh báo:</strong> Không thể chọn thời gian trong quá khứ. Đã tự động điều chỉnh về thời gian hiện tại.';
            } else {
                document.getElementById('conflictWarning').style.display = 'none';
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
            
            if (!phone) {
                resultDiv.innerHTML = '<div style="color: #dc2626; font-size: 0.875rem;">Vui lòng nhập số điện thoại</div>';
                resultDiv.style.display = 'block';
                return;
            }
            
            // Show loading
            resultDiv.innerHTML = '<div style="color: #64748b; font-size: 0.875rem;"><i class="fas fa-spinner fa-spin"></i> Đang tìm kiếm...</div>';
            resultDiv.style.display = 'block';
            
            // Make AJAX request to search for patient
            fetch('${pageContext.request.contextPath}/receptionist/patients?action=search&phone=' + encodeURIComponent(phone))
                .then(response => response.text())
                .then(html => {
                    // Parse the response to extract patient data
                    // This is a simplified approach - in a real app you'd use JSON API
                    if (html.includes('existingPatient')) {
                        // Patient found - extract patient info and update dropdown
                        resultDiv.innerHTML = '<div style="color: #059669; font-size: 0.875rem;"><i class="fas fa-check-circle"></i> Tìm thấy bệnh nhân. Vui lòng chọn từ danh sách bên dưới.</div>';
                        
                        // You could also auto-select the patient here
                        // For now, we'll just show success message
                    } else {
                        resultDiv.innerHTML = '<div style="color: #d97706; font-size: 0.875rem;"><i class="fas fa-exclamation-triangle"></i> Không tìm thấy bệnh nhân với số điện thoại này. Vui lòng đăng ký bệnh nhân mới.</div>';
                    }
                })
                .catch(error => {
                    resultDiv.innerHTML = '<div style="color: #dc2626; font-size: 0.875rem;"><i class="fas fa-exclamation-circle"></i> Lỗi khi tìm kiếm. Vui lòng thử lại.</div>';
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
