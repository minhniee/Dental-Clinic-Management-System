<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Check-in Bệnh Nhân - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .checkin-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .checkin-header {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }

        .appointments-table {
            background: #ffffff;
            border-radius: 0.75rem;
            overflow: hidden;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table thead {
            background-color: #f8fafc;
        }

        .table th,
        .table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }

        .table th {
            font-weight: 600;
            color: #0f172a;
            font-size: 0.875rem;
        }

        .table td {
            color: #475569;
            font-size: 0.875rem;
        }

        .table tbody tr:hover {
            background-color: #f8fafc;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-block;
        }

        .status-scheduled {
            background-color: #dbeafe;
            color: #2563eb;
        }

        .status-confirmed {
            background-color: #d1fae5;
            color: #059669;
        }

        .in-queue-badge {
            background-color: #fce7f3;
            color: #be185d;
        }

        .btn {
            padding: 0.5rem 1rem;
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

        .btn-disabled {
            background-color: #e2e8f0;
            color: #94a3b8;
            cursor: not-allowed;
        }

        .btn-sm {
            padding: 0.25rem 0.75rem;
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

        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: #64748b;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #94a3b8;
        }

        .search-filter {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
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
        <h1>Check-in Bệnh Nhân</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="container">
                <div class="checkin-container">
                    
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

                    <!-- Check-in Header -->
                    <div class="checkin-header">
                        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                            <div>
                                <h2 style="margin: 0; color: #0f172a;">Lịch Hẹn Hôm Nay</h2>
                                <p style="margin: 0.5rem 0 0 0; color: #64748b;">Chọn bệnh nhân để check-in vào hàng chờ</p>
                            </div>
                            <div style="display: flex; gap: 0.75rem;">
                                <a href="${pageContext.request.contextPath}/receptionist/queue?action=list" 
                                   class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i>
                                    Quay Lại Hàng Chờ
                                </a>
                                <a href="${pageContext.request.contextPath}/receptionist/appointments?action=list" 
                                   class="btn btn-primary">
                                    <i class="fas fa-calendar"></i>
                                    Xem Lịch Hẹn
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Search and Filter -->
                    <div class="search-filter">
                        <div style="display: flex; gap: 1rem; align-items: end;">
                            <div style="flex: 1;">
                                <label for="searchPatient" style="display: block; font-weight: 600; color: #0f172a; margin-bottom: 0.5rem; font-size: 0.875rem;">
                                    Tìm Kiếm Bệnh Nhân
                                </label>
                                <input type="text" 
                                       id="searchPatient" 
                                       class="form-control" 
                                       placeholder="Nhập tên bệnh nhân hoặc số điện thoại...">
                            </div>
                        </div>
                    </div>

                    <!-- Appointments Table -->
                    <div class="appointments-table">
                        <c:choose>
                            <c:when test="${not empty todayAppointments}">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Thời Gian</th>
                                            <th>Tên Bệnh Nhân</th>
                                            <th>Bác Sĩ</th>
                                            <th>Dịch Vụ</th>
                                            <th>Trạng Thái</th>
                                            <th>Trạng Thái Hàng Chờ</th>
                                            <th>Thao Tác</th>
                                        </tr>
                                    </thead>
                                    <tbody id="appointmentsTableBody">
                                        <c:forEach var="appointment" items="${todayAppointments}">
                                            <c:choose>
                                                <c:when test="${not empty appointment.patient}">
                                                    <c:set var="patientName" value="${not empty appointment.patient.fullName ? appointment.patient.fullName : 'N/A'}"/>
                                                    <c:set var="patientPhone" value="${not empty appointment.patient.phone ? appointment.patient.phone : ''}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="patientName" value="N/A"/>
                                                    <c:set var="patientPhone" value=""/>
                                                </c:otherwise>
                                            </c:choose>
                                            <tr data-patient-name="${fn:toLowerCase(patientName)}" 
                                                data-patient-phone="${patientPhone}">
                                                <td>
                                                    <strong style="color: #0f172a;">
                                                        <fmt:formatDate value="${appointment.appointmentDate}" pattern="HH:mm"/>
                                                    </strong>
                                                </td>
                                                <td>
                                                    <strong style="color: #0f172a;">${patientName}</strong>
                                                    <c:if test="${not empty patientPhone}">
                                                        <br>
                                                        <small style="color: #64748b;">
                                                            <i class="fas fa-phone"></i> ${patientPhone}
                                                        </small>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty appointment.dentist.fullName}">
                                                        ${appointment.dentist.fullName}
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty appointment.service.name}">
                                                        ${appointment.service.name}
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${appointment.status eq 'SCHEDULED'}">
                                                            <span class="status-badge status-scheduled">Đã lên lịch</span>
                                                        </c:when>
                                                        <c:when test="${appointment.status eq 'CONFIRMED'}">
                                                            <span class="status-badge status-confirmed">Đã xác nhận</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge">${appointment.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <!-- This would need to be populated with queue status -->
                                                    <span class="status-badge" id="queueStatus_${appointment.appointmentId}">
                                                        Chưa check-in
                                                    </span>
                                                </td>
                                                <td>
                                                    <form method="POST" action="${pageContext.request.contextPath}/receptionist/queue" style="display: inline;">
                                                        <input type="hidden" name="action" value="checkin">
                                                        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                                                        <button type="submit" class="btn btn-primary btn-sm" id="checkinBtn_${appointment.appointmentId}">
                                                            <i class="fas fa-user-plus"></i> Check-in
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-calendar-times"></i>
                                    <h3>Không Có Lịch Hẹn</h3>
                                    <p>Không có lịch hẹn nào trong ngày hôm nay.</p>
                                    <a href="${pageContext.request.contextPath}/receptionist/appointments?action=new" class="btn btn-primary">
                                        <i class="fas fa-calendar-plus"></i>
                                        Đặt Lịch Hẹn Mới
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Search functionality
        document.getElementById('searchPatient').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const rows = document.querySelectorAll('#appointmentsTableBody tr');
            
            rows.forEach(row => {
                const patientName = row.getAttribute('data-patient-name');
                const patientPhone = row.getAttribute('data-patient-phone');
                
                if (patientName.includes(searchTerm) || patientPhone.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });

        // Check if appointments are already in queue (this would need AJAX call to check queue status)
        // For now, we'll rely on the server-side processing
    </script>
</body>
</html>
