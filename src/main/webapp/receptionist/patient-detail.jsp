<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông Tin Bệnh Nhân - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .patient-detail-container {
            max-width: 1000px;
            margin: 0 auto;
        }

        .patient-header {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }

        .patient-header-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .patient-info {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .patient-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: #06b6d4;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-size: 2rem;
            font-weight: bold;
        }

        .patient-basic-info h1 {
            color: #0f172a;
            font-size: 1.875rem;
            font-weight: 700;
            margin: 0 0 0.5rem 0;
        }

        .patient-basic-info p {
            color: #64748b;
            margin: 0;
            font-size: 0.875rem;
        }

        .patient-actions {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
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

        .info-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .info-card {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 1.5rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }

        .info-card h3 {
            color: #0f172a;
            font-size: 1.125rem;
            font-weight: 600;
            margin: 0 0 1rem 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            border-bottom: 1px solid #f1f5f9;
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 500;
            color: #475569;
            font-size: 0.875rem;
        }

        .info-value {
            color: #0f172a;
            font-size: 0.875rem;
            text-align: right;
            word-break: break-word;
        }

        .empty-value {
            color: #94a3b8;
            font-style: italic;
        }

        .contact-links {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .contact-link {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: #06b6d4;
            text-decoration: none;
            font-size: 0.875rem;
            transition: color 0.2s ease-in-out;
        }

        .contact-link:hover {
            color: #0891b2;
        }

        .gender-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .gender-badge.male {
            background-color: #dbeafe;
            color: #1e40af;
        }

        .gender-badge.female {
            background-color: #fce7f3;
            color: #be185d;
        }

        .gender-badge.other {
            background-color: #f3f4f6;
            color: #6b7280;
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
            .patient-header-content {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .patient-actions {
                width: 100%;
                justify-content: flex-start;
            }
            
            .info-cards {
                grid-template-columns: 1fr;
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
        <h1>🦷 Thông Tin Bệnh Nhân</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="container">
                <div class="patient-detail-container">
                    
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

                    <c:choose>
                        <c:when test="${not empty patient}">
                            
                            <!-- Patient Header -->
                            <div class="patient-header">
                                <div class="patient-header-content">
                                    <div class="patient-info">
                                        <div class="patient-avatar">
                                            <c:choose>
                                                <c:when test="${patient.gender eq 'M'}">👨</c:when>
                                                <c:when test="${patient.gender eq 'F'}">👩</c:when>
                                                <c:otherwise>👤</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="patient-basic-info">
                                            <h1>${patient.fullName}</h1>
                                            <p>ID: #${patient.patientId}</p>
                                        </div>
                                    </div>
                                    <div class="patient-actions">
                                        <a href="${pageContext.request.contextPath}/receptionist/patients?action=edit&id=${patient.patientId}" 
                                           class="btn btn-primary">
                                            <i class="fas fa-edit"></i>
                                            Chỉnh Sửa
                                        </a>
                                        <a href="${pageContext.request.contextPath}/receptionist/invoices?action=new&patientId=${patient.patientId}" 
                                           class="btn btn-primary">
                                            <i class="fas fa-file-invoice"></i>
                                            Tạo Hóa Đơn
                                        </a>
                                        <a href="${pageContext.request.contextPath}/receptionist/invoices?patientId=${patient.patientId}" 
                                           class="btn btn-secondary">
                                            <i class="fas fa-history"></i>
                                            Xem Hóa Đơn
                                        </a>
                                        <a href="${pageContext.request.contextPath}/receptionist/patients?action=list" 
                                           class="btn btn-secondary">
                                            <i class="fas fa-arrow-left"></i>
                                            Quay Lại
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <!-- Patient Information Cards -->
                            <div class="info-cards">
                                
                                <!-- Personal Information -->
                                <div class="info-card">
                                    <h3>
                                        <i class="fas fa-user" style="color: #06b6d4;"></i>
                                        Thông Tin Cá Nhân
                                    </h3>
                                    <div class="info-item">
                                        <span class="info-label">Mã Bệnh Nhân:</span>
                                        <span class="info-value"><strong>#${patient.patientId}</strong></span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Họ và Tên:</span>
                                        <span class="info-value"><strong>${patient.fullName}</strong></span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Ngày Sinh:</span>
                                        <span class="info-value">
                                            <c:choose>
                                                <c:when test="${not empty patient.birthDateAsDate}">
                                                    <fmt:formatDate value="${patient.birthDateAsDate}" pattern="dd/MM/yyyy"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="empty-value">Chưa cập nhật</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Giới Tính:</span>
                                        <span class="info-value">
                                            <c:choose>
                                                <c:when test="${patient.gender eq 'M'}">
                                                    <span class="gender-badge male">Nam</span>
                                                </c:when>
                                                <c:when test="${patient.gender eq 'F'}">
                                                    <span class="gender-badge female">Nữ</span>
                                                </c:when>
                                                <c:when test="${patient.gender eq 'O'}">
                                                    <span class="gender-badge other">Khác</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="empty-value">Chưa cập nhật</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Ngày Đăng Ký:</span>
                                        <span class="info-value">
                                            <c:choose>
                                                <c:when test="${not empty patient.createdAtAsDate}">
                                                    <fmt:formatDate value="${patient.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="empty-value">Không có</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>

                                <!-- Contact Information -->
                                <div class="info-card">
                                    <h3>
                                        <i class="fas fa-address-book" style="color: #06b6d4;"></i>
                                        Thông Tin Liên Hệ
                                    </h3>
                                    <div class="info-item">
                                        <span class="info-label">Số Điện Thoại:</span>
                                        <span class="info-value">
                                            <c:choose>
                                                <c:when test="${not empty patient.phone}">
                                                    <a href="tel:${patient.phone}" class="contact-link">
                                                        <i class="fas fa-phone"></i>
                                                        ${patient.phone}
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="empty-value">Chưa cập nhật</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Email:</span>
                                        <span class="info-value">
                                            <c:choose>
                                                <c:when test="${not empty patient.email}">
                                                    <a href="mailto:${patient.email}" class="contact-link">
                                                        <i class="fas fa-envelope"></i>
                                                        ${patient.email}
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="empty-value">Chưa cập nhật</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="info-item" style="align-items: flex-start;">
                                        <span class="info-label">Địa Chỉ:</span>
                                        <span class="info-value" style="text-align: left;">
                                            <c:choose>
                                                <c:when test="${not empty patient.address}">
                                                    ${patient.address}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="empty-value">Chưa cập nhật</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>

                                <!-- Quick Actions -->
                                <div class="info-card">
                                    <h3>
                                        <i class="fas fa-tasks" style="color: #06b6d4;"></i>
                                        Thao Tác Nhanh
                                    </h3>
                                    <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                                        <a href="${pageContext.request.contextPath}/receptionist/appointments?action=new&patientId=${patient.patientId}" 
                                           class="btn btn-primary" style="width: 100%; justify-content: center;">
                                            <i class="fas fa-calendar-plus"></i>
                                            Đặt Lịch Hẹn
                                        </a>
                                        <c:if test="${not empty patient.phone}">
                                            <a href="tel:${patient.phone}" class="btn btn-secondary" style="width: 100%; justify-content: center;">
                                                <i class="fas fa-phone"></i>
                                                Gọi Điện Thoại
                                            </a>
                                        </c:if>
                                        <c:if test="${not empty patient.email}">
                                            <a href="mailto:${patient.email}" class="btn btn-secondary" style="width: 100%; justify-content: center;">
                                                <i class="fas fa-envelope"></i>
                                                Gửi Email
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                            <!-- Invoice History -->
                            <c:if test="${not empty patientInvoices}">
                                <div class="invoice-history-section" style="margin-top: 2rem;">
                                    <h2 style="color: #0f172a; margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.75rem;">
                                        <i class="fas fa-file-invoice" style="color: #06b6d4;"></i>
                                        Lịch Sử Hóa Đơn
                                    </h2>
                                    <div class="invoice-list" style="display: grid; gap: 1rem;">
                                        <c:forEach var="invoice" items="${patientInvoices}">
                                            <div class="info-card" style="border-left: 4px solid #06b6d4;">
                                                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1rem;">
                                                    <div>
                                                        <h4 style="color: #0f172a; margin: 0;">
                                                            Hóa Đơn #${invoice.invoiceId}
                                                        </h4>
                                                        <p style="color: #64748b; margin: 0.25rem 0 0 0; font-size: 0.875rem;">
                                                            <fmt:formatDate value="${invoice.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </p>
                                                    </div>
                                                    <div style="text-align: right;">
                                                        <div style="font-weight: 600; color: #0f172a;">
                                                            <fmt:formatNumber value="${invoice.netAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                        </div>
                                                        <c:choose>
                                                            <c:when test="${invoice.status eq 'PAID'}">
                                                                <span style="padding: 0.25rem 0.5rem; border-radius: 0.25rem; font-size: 0.75rem; font-weight: 600; background-color: #d1fae5; color: #059669;">Đã Thanh Toán</span>
                                                            </c:when>
                                                            <c:when test="${invoice.status eq 'PARTIAL'}">
                                                                <span style="padding: 0.25rem 0.5rem; border-radius: 0.25rem; font-size: 0.75rem; font-weight: 600; background-color: #fef3c7; color: #d97706;">Thanh Toán Một Phần</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span style="padding: 0.25rem 0.5rem; border-radius: 0.25rem; font-size: 0.75rem; font-weight: 600; background-color: #fee2e2; color: #dc2626;">Chưa Thanh Toán</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                                <div style="display: flex; gap: 0.5rem;">
                                                    <a href="${pageContext.request.contextPath}/receptionist/invoices?action=view&id=${invoice.invoiceId}" 
                                                       class="btn btn-secondary btn-sm">
                                                        <i class="fas fa-eye"></i> Xem Chi Tiết
                                                    </a>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>

                        </c:when>
                        <c:otherwise>
                            <div class="patient-header">
                                <div style="text-align: center; padding: 3rem 1rem; color: #64748b;">
                                    <i class="fas fa-exclamation-triangle" style="font-size: 3rem; margin-bottom: 1rem; color: #f59e0b;"></i>
                                    <h2>Không Tìm Thấy Bệnh Nhân</h2>
                                    <p>Bệnh nhân bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
                                    <a href="${pageContext.request.contextPath}/receptionist/patients?action=list" class="btn btn-primary">
                                        <i class="fas fa-arrow-left"></i>
                                        Quay Về Danh Sách
                                    </a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>
        </main>
    </div>
</body>
</html>
