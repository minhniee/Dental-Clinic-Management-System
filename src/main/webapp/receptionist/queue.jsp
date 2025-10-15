<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Hàng Chờ - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .queue-container {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .queue-header {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }

        .queue-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }

        .stat-item {
            text-align: center;
            padding: 1rem;
            background-color: #f8fafc;
            border-radius: 0.5rem;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: #06b6d4;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #475569;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .queue-table {
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

        .status-waiting {
            background-color: #fef3c7;
            color: #d97706;
        }

        .status-checked-in {
            background-color: #dbeafe;
            color: #2563eb;
        }

        .status-called {
            background-color: #d1fae5;
            color: #059669;
        }

        .status-in-treatment {
            background-color: #fce7f3;
            color: #be185d;
        }

        .position-badge {
            background-color: #06b6d4;
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
            font-size: 0.75rem;
            font-weight: 600;
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

        .actions-container {
            display: flex;
            gap: 1.5rem;
            align-items: center;
            flex-wrap: wrap;
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
        <h1>🦷 Quản Lý Hàng Chờ</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="container">
                <div class="queue-container">
                    
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

                    <!-- Queue Header -->
                    <div class="queue-header">
                        <div class="actions-container">
                            <h2 style="margin: 0; color: #0f172a;">Hàng Chờ Hôm Nay</h2>
                            <a href="${pageContext.request.contextPath}/receptionist/queue?action=checkin" 
                               class="btn btn-primary">
                                <i class="fas fa-user-plus"></i>
                                Check-in Bệnh Nhân
                            </a>
                        </div>

                        <!-- Queue Statistics -->
                        <c:if test="${not empty queueStats}">
                            <div class="queue-stats">
                                <div class="stat-item">
                                    <div class="stat-number">${queueStats.waitingCount}</div>
                                    <div class="stat-label">Đang Chờ</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number">${queueStats.checkedInCount}</div>
                                    <div class="stat-label">Đã Check-in</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number">${queueStats.calledCount}</div>
                                    <div class="stat-label">Đã Gọi</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number">${queueStats.inTreatmentCount}</div>
                                    <div class="stat-label">Đang Điều Trị</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number">${queueStats.completedCount}</div>
                                    <div class="stat-label">Hoàn Thành</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number">${queueStats.noShowCount}</div>
                                    <div class="stat-label">Không Đến</div>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!-- Queue Table -->
                    <div class="queue-table">
                        <c:choose>
                            <c:when test="${not empty currentQueue}">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Vị Trí</th>
                                            <th>Tên Bệnh Nhân</th>
                                            <th>Bác Sĩ</th>
                                            <th>Dịch Vụ</th>
                                            <th>Giờ Hẹn</th>
                                            <th>Trạng Thái</th>
                                            <th>Thao Tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="queueItem" items="${currentQueue}">
                                            <tr>
                                                <td>
                                                    <span class="position-badge">#${queueItem.positionInQueue}</span>
                                                </td>
                                                <td>
                                                    <strong style="color: #0f172a;">${queueItem.appointment.patient.fullName}</strong>
                                                    <c:if test="${not empty queueItem.appointment.patient.phone}">
                                                        <br>
                                                        <small style="color: #64748b;">
                                                            <i class="fas fa-phone"></i> ${queueItem.appointment.patient.phone}
                                                        </small>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty queueItem.appointment.dentist.fullName}">
                                                        ${queueItem.appointment.dentist.fullName}
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty queueItem.appointment.service.name}">
                                                        ${queueItem.appointment.service.name}
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty queueItem.appointment.appointmentDate}">
                                                        <fmt:formatDate value="${queueItem.appointment.appointmentDate}" pattern="HH:mm"/>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${queueItem.status eq 'WAITING'}">
                                                            <span class="status-badge status-waiting">Đang chờ</span>
                                                        </c:when>
                                                        <c:when test="${queueItem.status eq 'CHECKED_IN'}">
                                                            <span class="status-badge status-checked-in">Đã check-in</span>
                                                        </c:when>
                                                        <c:when test="${queueItem.status eq 'CALLED'}">
                                                            <span class="status-badge status-called">Đã gọi</span>
                                                        </c:when>
                                                        <c:when test="${queueItem.status eq 'IN_TREATMENT'}">
                                                            <span class="status-badge status-in-treatment">Đang điều trị</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge">${queueItem.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div style="display: flex; gap: 0.5rem; flex-wrap: wrap;">
                                                        <c:if test="${queueItem.status eq 'WAITING'}">
                                                            <form method="POST" action="${pageContext.request.contextPath}/receptionist/queue" style="display: inline;">
                                                                <input type="hidden" name="action" value="update_status">
                                                                <input type="hidden" name="appointmentId" value="${queueItem.appointmentId}">
                                                                <input type="hidden" name="status" value="CHECKED_IN">
                                                                <button type="submit" class="btn btn-primary btn-sm">
                                                                    <i class="fas fa-check"></i> Check-in
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        
                                                        <c:if test="${queueItem.status eq 'CHECKED_IN'}">
                                                            <form method="POST" action="${pageContext.request.contextPath}/receptionist/queue" style="display: inline;">
                                                                <input type="hidden" name="action" value="update_status">
                                                                <input type="hidden" name="appointmentId" value="${queueItem.appointmentId}">
                                                                <input type="hidden" name="status" value="CALLED">
                                                                <button type="submit" class="btn btn-primary btn-sm">
                                                                    <i class="fas fa-bullhorn"></i> Gọi
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        
                                                        <c:if test="${queueItem.status eq 'CALLED'}">
                                                            <form method="POST" action="${pageContext.request.contextPath}/receptionist/queue" style="display: inline;">
                                                                <input type="hidden" name="action" value="update_status">
                                                                <input type="hidden" name="appointmentId" value="${queueItem.appointmentId}">
                                                                <input type="hidden" name="status" value="IN_TREATMENT">
                                                                <button type="submit" class="btn btn-primary btn-sm">
                                                                    <i class="fas fa-stethoscope"></i> Bắt đầu
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        
                                                        <form method="POST" action="${pageContext.request.contextPath}/receptionist/queue" style="display: inline;">
                                                            <input type="hidden" name="action" value="remove_from_queue">
                                                            <input type="hidden" name="appointmentId" value="${queueItem.appointmentId}">
                                                            <button type="submit" class="btn btn-secondary btn-sm"
                                                                    onclick="return confirm('Bạn có chắc chắn muốn xóa bệnh nhân này khỏi hàng chờ?')">
                                                                <i class="fas fa-times"></i> Xóa
                                                            </button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-list-ol"></i>
                                    <h3>Hàng Chờ Trống</h3>
                                    <p>Hiện tại không có bệnh nhân nào trong hàng chờ.</p>
                                    <a href="${pageContext.request.contextPath}/receptionist/queue?action=checkin" class="btn btn-primary">
                                        <i class="fas fa-user-plus"></i>
                                        Check-in Bệnh Nhân Đầu Tiên
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
