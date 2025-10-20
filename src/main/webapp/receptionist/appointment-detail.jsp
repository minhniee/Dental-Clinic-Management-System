<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Lịch Hẹn - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .appointment-detail-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .detail-card {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
            margin-bottom: 2rem;
        }
        
        .detail-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .detail-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #0f172a;
            margin: 0;
        }
        
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 9999px;
            font-size: 0.875rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .status-scheduled {
            background-color: #dbeafe;
            color: #2563eb;
        }
        
        .status-confirmed {
            background-color: #d1fae5;
            color: #059669;
        }
        
        .status-completed {
            background-color: #f0fdf4;
            color: #16a34a;
        }
        
        .status-cancelled {
            background-color: #fef2f2;
            color: #dc2626;
        }
        
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }
        
        .detail-section {
            background: #f8fafc;
            border-radius: 0.5rem;
            padding: 1.5rem;
        }
        
        .section-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .detail-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .detail-item:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            font-weight: 600;
            color: #475569;
            min-width: 120px;
        }
        
        .detail-value {
            color: #0f172a;
            text-align: right;
        }
        
        .actions-container {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            margin-top: 2rem;
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
            background-color: #ef4444;
            color: #ffffff;
        }
        
        .btn-danger:hover {
            background-color: #dc2626;
        }
        
        .btn-success {
            background-color: #10b981;
            color: #ffffff;
        }
        
        .btn-success:hover {
            background-color: #059669;
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
    
    <div class="dashboard-layout">
        <jsp:include page="../shared/left-navbar.jsp"/>
        
        <main class="main-content">
            <div class="appointment-detail-container">
                <!-- Alert Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <c:out value="${successMessage}"/>
                    </div>
                </c:if>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <c:out value="${errorMessage}"/>
                    </div>
                </c:if>

                <div class="detail-card">
                    <!-- Header -->
                    <div class="detail-header">
                        <h1 class="detail-title">Chi Tiết Lịch Hẹn #${appointment.appointmentId}</h1>
                        <c:choose>
                            <c:when test="${appointment.status eq 'SCHEDULED'}">
                                <span class="status-badge status-scheduled">
                                    <i class="fas fa-clock"></i> Đã lên lịch
                                </span>
                            </c:when>
                            <c:when test="${appointment.status eq 'CONFIRMED'}">
                                <span class="status-badge status-confirmed">
                                    <i class="fas fa-check"></i> Đã xác nhận
                                </span>
                            </c:when>
                            <c:when test="${appointment.status eq 'COMPLETED'}">
                                <span class="status-badge status-completed">
                                    <i class="fas fa-check-circle"></i> Hoàn thành
                                </span>
                            </c:when>
                            <c:when test="${appointment.status eq 'CANCELLED'}">
                                <span class="status-badge status-cancelled">
                                    <i class="fas fa-times"></i> Đã hủy
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge">${appointment.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Detail Grid -->
                    <div class="detail-grid">
                        <!-- Appointment Information -->
                        <div class="detail-section">
                            <h3 class="section-title">
                                <i class="fas fa-calendar-alt"></i>
                                Thông Tin Lịch Hẹn
                            </h3>
                            <div class="detail-item">
                                <span class="detail-label">Ngày giờ:</span>
                                <span class="detail-value">
                                    <c:if test="${not empty appointment.appointmentDateAsDate}">
                                        <fmt:formatDate value="${appointment.appointmentDateAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </c:if>
                                </span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Trạng thái:</span>
                                <span class="detail-value">${appointment.status}</span>
                            </div>
                            <c:if test="${not empty appointment.confirmationCode}">
                                <div class="detail-item">
                                    <span class="detail-label">Mã xác nhận:</span>
                                    <span class="detail-value">${appointment.confirmationCode}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty appointment.confirmedAt}">
                                <div class="detail-item">
                                    <span class="detail-label">Xác nhận lúc:</span>
                                    <span class="detail-value">
                                        <fmt:formatDate value="${appointment.confirmedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </span>
                                </div>
                            </c:if>
                            <div class="detail-item">
                                <span class="detail-label">Nguồn:</span>
                                <span class="detail-value">${appointment.source}</span>
                            </div>
                            <c:if test="${not empty appointment.bookingChannel}">
                                <div class="detail-item">
                                    <span class="detail-label">Kênh đặt:</span>
                                    <span class="detail-value">${appointment.bookingChannel}</span>
                                </div>
                            </c:if>
                        </div>

                        <!-- Patient Information -->
                        <div class="detail-section">
                            <h3 class="section-title">
                                <i class="fas fa-user"></i>
                                Thông Tin Bệnh Nhân
                            </h3>
                            <div class="detail-item">
                                <span class="detail-label">Tên:</span>
                                <span class="detail-value">${appointment.patient.fullName}</span>
                            </div>
                            <c:if test="${not empty appointment.patient.phone}">
                                <div class="detail-item">
                                    <span class="detail-label">SĐT:</span>
                                    <span class="detail-value">${appointment.patient.phone}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty appointment.patient.email}">
                                <div class="detail-item">
                                    <span class="detail-label">Email:</span>
                                    <span class="detail-value">${appointment.patient.email}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty appointment.patient.address}">
                                <div class="detail-item">
                                    <span class="detail-label">Địa chỉ:</span>
                                    <span class="detail-value">${appointment.patient.address}</span>
                                </div>
                            </c:if>
                        </div>

                        <!-- Doctor Information -->
                        <div class="detail-section">
                            <h3 class="section-title">
                                <i class="fas fa-user-md"></i>
                                Thông Tin Bác Sĩ
                            </h3>
                            <div class="detail-item">
                                <span class="detail-label">Bác sĩ:</span>
                                <span class="detail-value">${appointment.dentist.fullName}</span>
                            </div>
                            <c:if test="${not empty appointment.dentist.phone}">
                                <div class="detail-item">
                                    <span class="detail-label">SĐT:</span>
                                    <span class="detail-value">${appointment.dentist.phone}</span>
                                </div>
                            </c:if>
                        </div>

                        <!-- Service Information -->
                        <div class="detail-section">
                            <h3 class="section-title">
                                <i class="fas fa-stethoscope"></i>
                                Thông Tin Dịch Vụ
                            </h3>
                            <div class="detail-item">
                                <span class="detail-label">Dịch vụ:</span>
                                <span class="detail-value">${appointment.service.name}</span>
                            </div>
                            <c:if test="${not empty appointment.service.description}">
                                <div class="detail-item">
                                    <span class="detail-label">Mô tả:</span>
                                    <span class="detail-value">${appointment.service.description}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty appointment.service.price}">
                                <div class="detail-item">
                                    <span class="detail-label">Giá:</span>
                                    <span class="detail-value">
                                        <fmt:formatNumber value="${appointment.service.price}" type="currency" currencyCode="VND"/>
                                    </span>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Notes Section -->
                    <c:if test="${not empty appointment.notes}">
                        <div class="detail-section" style="margin-top: 2rem;">
                            <h3 class="section-title">
                                <i class="fas fa-sticky-note"></i>
                                Ghi Chú
                            </h3>
                            <p style="color: #475569; line-height: 1.6; margin: 0;">${appointment.notes}</p>
                        </div>
                    </c:if>

                    <!-- Actions -->
                    <div class="actions-container">
                        <a href="${pageContext.request.contextPath}/receptionist/appointments" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i>
                            Quay Lại
                        </a>
                        
                        <c:if test="${appointment.status ne 'COMPLETED' and appointment.status ne 'CANCELLED'}">
                            <a href="${pageContext.request.contextPath}/receptionist/appointments?action=edit&id=${appointment.appointmentId}" 
                               class="btn btn-primary">
                                <i class="fas fa-edit"></i>
                                Chỉnh Sửa
                            </a>
                        </c:if>
                        
                        <c:if test="${appointment.status eq 'SCHEDULED'}">
                            <form method="POST" action="${pageContext.request.contextPath}/receptionist/appointments" style="display: inline;">
                                <input type="hidden" name="action" value="confirm">
                                <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-check-circle"></i>
                                    Xác Nhận
                                </button>
                            </form>
                        </c:if>
                        
                        <c:if test="${appointment.status eq 'CONFIRMED'}">
                            <form method="POST" action="${pageContext.request.contextPath}/receptionist/appointments" style="display: inline;">
                                <input type="hidden" name="action" value="update_status">
                                <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                                <input type="hidden" name="status" value="COMPLETED">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-check"></i>
                                    Hoàn Thành
                                </button>
                            </form>
                        </c:if>
                        
                        <c:if test="${appointment.status ne 'COMPLETED' and appointment.status ne 'CANCELLED'}">
                            <form method="POST" action="${pageContext.request.contextPath}/receptionist/appointments" style="display: inline;">
                                <input type="hidden" name="action" value="update_status">
                                <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                                <input type="hidden" name="status" value="CANCELLED">
                                <button type="submit" class="btn btn-danger"
                                        onclick="return confirm('Bạn có chắc chắn muốn hủy lịch hẹn này?')">
                                    <i class="fas fa-times"></i>
                                    Hủy Lịch
                                </button>
                            </form>
                        </c:if>
                        
                        <c:if test="${appointment.status eq 'COMPLETED'}">
                            <a href="${pageContext.request.contextPath}/receptionist/invoices?action=create_from_appointment&appointmentId=${appointment.appointmentId}" 
                               class="btn btn-primary">
                                <i class="fas fa-file-invoice"></i>
                                Tạo Hóa Đơn
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
