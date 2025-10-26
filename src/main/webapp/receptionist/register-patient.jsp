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
            <c:when test="${action eq 'update'}">Chỉnh Sửa Bệnh Nhân</c:when>
            <c:otherwise>Đăng Ký Bệnh Nhân Mới</c:otherwise>
        </c:choose>
        - Hệ Thống Quản Lý Phòng Khám Nha Khoa
    </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/receptionist.css">
    <style>
        .form-container {
            max-width: 800px;
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
                <c:when test="${action eq 'update'}">🦷 Chỉnh Sửa Bệnh Nhân</c:when>
                <c:otherwise>🦷 Đăng Ký Bệnh Nhân Mới</c:otherwise>
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
                                <c:when test="${action eq 'update'}">Chỉnh Sửa Thông Tin Bệnh Nhân</c:when>
                                <c:otherwise>Đăng Ký Bệnh Nhân Mới</c:otherwise>
                            </c:choose>
                        </h2>
                        <p>
                            <c:choose>
                                <c:when test="${action eq 'update'}">
                                    Cập nhật thông tin cho bệnh nhân hệ thống
                                </c:when>
                                <c:otherwise>
                                    Nhập thông tin để tạo hồ sơ bệnh nhân mới
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

                    <!-- Patient Search Section -->
                    <c:if test="${action eq 'create'}">
                        <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 0.5rem; padding: 1.5rem; margin-bottom: 2rem;">
                            <h3 style="margin: 0 0 1rem 0; color: #0f172a; font-size: 1.125rem;">
                                <i class="fas fa-search" style="margin-right: 0.5rem; color: #06b6d4;"></i>
                                Tìm Kiếm Bệnh Nhân Hiện Có
                            </h3>
                            <p style="margin: 0 0 1rem 0; color: #64748b; font-size: 0.875rem;">
                                Nhập số điện thoại để kiểm tra xem bệnh nhân đã có trong hệ thống chưa
                            </p>
                            <form method="GET" action="${pageContext.request.contextPath}/receptionist/patients" style="display: flex; gap: 1rem; align-items: end;">
                                <input type="hidden" name="action" value="new">
                                <div style="flex: 1;">
                                    <label for="searchPhone" style="display: block; font-weight: 600; color: #0f172a; margin-bottom: 0.5rem; font-size: 0.875rem;">
                                        Số Điện Thoại
                                    </label>
                                    <input type="tel" 
                                           id="searchPhone" 
                                           name="phone" 
                                           class="form-control" 
                                           value="${searchPhone}"
                                           placeholder="0123456789"
                                           style="margin-bottom: 0;">
                                </div>
                                <input type="hidden" name="searchAction" value="search">
                                <button type="submit" class="btn btn-primary" style="margin-bottom: 0;">
                                    <i class="fas fa-search"></i>
                                    Tìm Kiếm
                                </button>
                            </form>
                            
                            <!-- Search Results -->
                            <c:if test="${not empty existingPatient}">
                                <div style="margin-top: 1rem; padding: 1rem; background: #d1fae5; border: 1px solid #bbf7d0; border-radius: 0.5rem;">
                                    <div style="display: flex; justify-content: space-between; align-items: center;">
                                        <div>
                                            <h4 style="margin: 0 0 0.5rem 0; color: #059669; font-size: 1rem;">
                                                <i class="fas fa-user-check" style="margin-right: 0.5rem;"></i>
                                                Tìm Thấy Bệnh Nhân
                                            </h4>
                                            <p style="margin: 0; color: #047857; font-size: 0.875rem;">
                                                <strong>${existingPatient.fullName}</strong> - ${existingPatient.phone}
                                                <c:if test="${not empty existingPatient.email}">
                                                    - ${existingPatient.email}
                                                </c:if>
                                            </p>
                                        </div>
                                        <div style="display: flex; gap: 0.5rem;">
                                            <a href="${pageContext.request.contextPath}/receptionist/patients?action=quick_appointment&patientId=${existingPatient.patientId}" 
                                               class="btn btn-primary btn-sm">
                                                <i class="fas fa-calendar-plus"></i>
                                                Đặt Lịch
                                            </a>
                                            <a href="${pageContext.request.contextPath}/receptionist/patients?action=view&id=${existingPatient.patientId}" 
                                               class="btn btn-secondary btn-sm">
                                                <i class="fas fa-eye"></i>
                                                Xem Chi Tiết
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty noPatientFound}">
                                <div style="margin-top: 1rem; padding: 1rem; background: #fef3c7; border: 1px solid #fde68a; border-radius: 0.5rem;">
                                    <p style="margin: 0; color: #d97706; font-size: 0.875rem;">
                                        <i class="fas fa-exclamation-triangle" style="margin-right: 0.5rem;"></i>
                                        Không tìm thấy bệnh nhân với số điện thoại "${searchPhone}". Vui lòng tạo hồ sơ mới bên dưới.
                                    </p>
                                </div>
                            </c:if>
                        </div>
                    </c:if>

                    <!-- Patient Registration Form -->
                    <form method="POST" action="${pageContext.request.contextPath}/receptionist/patients" class="needs-validation" novalidate>
                        <input type="hidden" name="action" value="${action eq 'update' ? 'update' : 'create'}">
                        <c:if test="${action eq 'update' and not empty patient}">
                            <input type="hidden" name="patientId" value="${patient.patientId}">
                        </c:if>

                        <!-- Full Name -->
                        <div class="form-group full-width">
                            <label for="fullName">
                                Họ và Tên <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   id="fullName" 
                                   name="fullName" 
                                   class="form-control" 
                                   required 
                                   value="${patient.fullName}"
                                   placeholder="Nhập họ và tên đầy đủ">
                            <div class="help-text">Vui lòng nhập họ và tên đầy đủ của bệnh nhân</div>
                        </div>

                        <div class="form-row">
                            <!-- Birth Date -->
                            <div class="form-group">
                                <label for="birthDate">Ngày Sinh</label>
                                <input type="date" 
                                       id="birthDate" 
                                       name="birthDate" 
                                       class="form-control"
                                       value="<c:if test='${not empty patient.birthDate}'><fmt:formatDate value='${patient.birthDateAsDate}' pattern='yyyy-MM-dd'/></c:if>">
                                <div class="help-text">Nhập ngày sinh (tùy chọn)</div>
                            </div>

                            <!-- Gender -->
                            <div class="form-group">
                                <label for="gender">Giới Tính</label>
                                <select id="gender" name="gender" class="form-control">
                                    <option value="">Chọn giới tính</option>
                                    <option value="M" ${patient.gender eq 'M' ? 'selected' : ''}>Nam</option>
                                    <option value="F" ${patient.gender eq 'F' ? 'selected' : ''}>Nữ</option>
                                    <option value="O" ${patient.gender eq 'O' ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <!-- Phone -->
                            <div class="form-group">
                                <label for="phone">
                                    Số Điện Thoại <span class="required">*</span>
                                </label>
                                <input type="tel" 
                                       id="phone" 
                                       name="phone" 
                                       class="form-control" 
                                       required 
                                       value="${not empty patient.phone ? patient.phone : searchPhone}"
                                       placeholder="0123456789">
                                <div class="help-text">Số điện thoại là bắt buộc để liên lạc</div>
                            </div>

                            <!-- Email -->
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" 
                                       id="email" 
                                       name="email" 
                                       class="form-control"
                                       value="${patient.email}"
                                       placeholder="email@example.com">
                                <div class="help-text">Email để gửi nhắc nhở lịch hẹn</div>
                            </div>
                        </div>

                        <!-- Address -->
                        <div class="form-group full-width">
                            <label for="address">Địa Chỉ</label>
                            <textarea id="address" 
                                      name="address" 
                                      class="form-control" 
                                      rows="3"
                                      placeholder="Nhập địa chỉ đầy đủ của bệnh nhân">${patient.address}</textarea>
                            <div class="help-text">Địa chỉ nhà hoặc nơi ở hiện tại</div>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/receptionist/patients?action=list" 
                               class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i>
                                Quay Lại
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i>
                                <c:choose>
                                    <c:when test="${action eq 'update'}">Cập Nhật Bệnh Nhân</c:when>
                                    <c:otherwise>Đăng Ký Bệnh Nhân</c:otherwise>
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

        // Phone number formatting
        document.getElementById('phone').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            e.target.value = value;
        });

        // Auto-focus first input
        document.addEventListener('DOMContentLoaded', function() {
            const firstInput = document.querySelector('input[type="text"]');
            if (firstInput) {
                firstInput.focus();
            }
        });
    </script>
</body>
</html>
