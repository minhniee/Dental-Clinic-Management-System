<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Lịch Hẹn - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .appointments-container {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .appointments-header {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }

        .filters-section {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }

        .filters-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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

        .status-completed {
            background-color: #f0fdf4;
            color: #16a34a;
        }

        .status-cancelled {
            background-color: #fef2f2;
            color: #dc2626;
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

        .actions-container {
            display: flex;
            gap: 1.5rem;
            align-items: center;
            flex-wrap: wrap;
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
        <h1>🦷 Quản Lý Lịch Hẹn</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="container">
                <div class="appointments-container">
                    
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

                    <!-- Appointments Header -->
                    <div class="appointments-header">
                        <div class="actions-container">
                            <h2 style="margin: 0; color: #0f172a;">Lịch Hẹn</h2>
                            <a href="${pageContext.request.contextPath}/receptionist/appointments?action=new" 
                               class="btn btn-primary">
                                <i class="fas fa-calendar-plus"></i>
                                Đặt Lịch Hẹn Mới
                            </a>
                            <a href="${pageContext.request.contextPath}/receptionist/appointments?action=calendar" 
                               class="btn btn-secondary">
                                <i class="fas fa-calendar-alt"></i>
                                Xem Lịch
                            </a>
                            <a href="${pageContext.request.contextPath}/receptionist/dashboard" 
                               class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i>
                                Về Dashboard
                            </a>
                        </div>
                    </div>

                    <!-- Filters Section -->
                    <form method="GET" action="${pageContext.request.contextPath}/receptionist/appointments" class="filters-section">
                        <input type="hidden" name="action" value="list">
                        <div class="filters-form">
                            <div class="form-group">
                                <label for="date">Ngày</label>
                                <input type="date"
                                       id="date"
                                       name="date"
                                       class="form-control"
                                       value="<c:if test='${not empty dateValue}'><fmt:formatDate value='${dateValue}' pattern='yyyy-MM-dd'/></c:if>">

                            </div>
                            <div class="form-group">
                                <label for="dentistId">Bác Sĩ</label>
                                <select id="dentistId" name="dentistId" class="form-control">
                                    <option value="">Tất cả bác sĩ</option>
                                    <c:forEach var="dentist" items="${dentists}">
                                        <option value="${dentist.userId}" ${selectedDentistId eq dentist.userId ? 'selected' : ''}>
                                            ${dentist.fullName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i>
                                    Lọc
                                </button>
                                <a href="${pageContext.request.contextPath}/receptionist/appointments" class="btn btn-secondary">
                                    <i class="fas fa-refresh"></i>
                                    Làm Mới
                                </a>
                            </div>
                        </div>
                    </form>

                    <!-- Appointments Table -->
                    <div class="appointments-table">
                        <c:choose>
                            <c:when test="${not empty appointments}">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Giờ Hẹn</th>
                                            <th>Tên Bệnh Nhân</th>
                                            <th>Bác Sĩ</th>
                                            <th>Dịch Vụ</th>
                                            <th>Trạng Thái</th>
                                            <th>Ghi Chú</th>
                                            <th>Thao Tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="appointment" items="${appointments}">
                                            <tr>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty appointment.appointmentDateAsDate}">
                                                            <strong style="color: #0f172a;">
                                                                <fmt:formatDate value="${appointment.appointmentDateAsDate}" pattern="HH:mm"/>
                                                            </strong>
                                                            <br>
                                                            <small style="color: #64748b;">
                                                                <fmt:formatDate value="${appointment.appointmentDateAsDate}" pattern="dd/MM/yyyy"/>
                                                            </small>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: #64748b;">N/A</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <strong style="color: #0f172a;">${appointment.patient.fullName}</strong>
                                                    <c:if test="${not empty appointment.patient.phone}">
                                                        <br>
                                                        <small style="color: #64748b;">
                                                            <i class="fas fa-phone"></i> ${appointment.patient.phone}
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
                                                            <c:if test="${not empty appointment.confirmationCode}">
                                                                <br><small style="color: #64748b; font-size: 0.75rem;">
                                                                    Mã: ${appointment.confirmationCode}
                                                                </small>
                                                            </c:if>
                                                        </c:when>
                                                        <c:when test="${appointment.status eq 'COMPLETED'}">
                                                            <span class="status-badge status-completed">Hoàn thành</span>
                                                        </c:when>
                                                        <c:when test="${appointment.status eq 'CANCELLED'}">
                                                            <span class="status-badge status-cancelled">Đã hủy</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge">${appointment.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty appointment.notes}">
                                                        <span title="${appointment.notes}">
                                                            <c:choose>
                                                                <c:when test="${fn:length(appointment.notes) > 30}">
                                                                    ${fn:substring(appointment.notes, 0, 30)}...
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${appointment.notes}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <div style="display: flex; gap: 0.5rem; flex-wrap: wrap;">
                                                        <a href="${pageContext.request.contextPath}/receptionist/appointments?action=view&id=${appointment.appointmentId}" 
                                                           class="btn btn-secondary btn-sm">
                                                            <i class="fas fa-eye"></i>
                                                            Xem Lịch
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/receptionist/appointments?action=edit&id=${appointment.appointmentId}" 
                                                           class="btn btn-primary btn-sm">
                                                           Cập nhật
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <c:if test="${appointment.status eq 'SCHEDULED'}">
                                                            <form method="POST" action="${pageContext.request.contextPath}/receptionist/appointments" style="display: inline;">
                                                                <input type="hidden" name="action" value="confirm">
                                                                <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                                                                <button type="submit" class="btn btn-primary btn-sm">
                                                                    <i class="fas fa-check-circle"></i> Xác nhận
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        
                                                        <c:if test="${appointment.status eq 'CONFIRMED'}">
                                                            <form method="POST" action="${pageContext.request.contextPath}/receptionist/appointments" style="display: inline;">
                                                                <input type="hidden" name="action" value="update_status">
                                                                <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                                                                <input type="hidden" name="status" value="COMPLETED">
                                                                <button type="submit" class="btn btn-primary btn-sm">
                                                                    <i class="fas fa-check"></i> Hoàn thành
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        
                                                        <c:if test="${appointment.status ne 'COMPLETED' and appointment.status ne 'CANCELLED'}">
                                                            <form method="POST" action="${pageContext.request.contextPath}/receptionist/appointments" style="display: inline;">
                                                                <input type="hidden" name="action" value="update_status">
                                                                <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                                                                <input type="hidden" name="status" value="CANCELLED">
                                                                <button type="submit" class="btn btn-secondary btn-sm"
                                                                        onclick="return confirm('Bạn có chắc chắn muốn hủy lịch hẹn này?')">
                                                                    <i class="fas fa-times"></i> Hủy
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        <c:if test="${appointment.status eq 'COMPLETED'}">
                                                            <a href="${pageContext.request.contextPath}/receptionist/invoices?action=create_from_appointment&appointmentId=${appointment.appointmentId}" 
                                                               class="btn btn-primary btn-sm">
                                                                <i class="fas fa-file-invoice"></i> Tạo Hóa Đơn Tự Động
                                                            </a>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-calendar-alt"></i>
                                    <h3>Không Có Lịch Hẹn</h3>
                                    <p>Không tìm thấy lịch hẹn nào theo bộ lọc đã chọn.</p>
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
        // Set today's date as default if no date is selected
        document.addEventListener('DOMContentLoaded', function() {
            const dateInput = document.getElementById('date');
            if (!dateInput.value) {
                const today = new Date().toISOString().split('T')[0];
                dateInput.value = today;
            }
        });
    </script>
</body>
</html>
