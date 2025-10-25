<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Lịch Hẹn - Manager - Hệ Thống Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .reports-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 1.5rem;
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding: 1.5rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 1rem;
            color: white;
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }
        
        .page-title {
            font-size: 2.5rem;
            font-weight: 800;
            margin: 0;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .action-buttons {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
        }
        
        .btn-primary {
            background: rgba(255,255,255,0.2);
            color: white;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .btn-primary:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .filter-section {
            background: white;
            padding: 2rem;
            border-radius: 1rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
        }
        
        .filter-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            align-items: end;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-label {
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #4a5568;
            font-size: 0.9rem;
        }
        
        .form-control {
            padding: 0.875rem;
            border: 2px solid #e2e8f0;
            border-radius: 0.75rem;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .table-container {
            background: white;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
        }
        
        .table-header {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            padding: 1.5rem 2rem;
            border-bottom: 2px solid #e2e8f0;
        }
        
        .table-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1f2937;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .table th {
            background: #f8fafc;
            padding: 1.25rem 1rem;
            text-align: left;
            font-weight: 700;
            color: #374151;
            border-bottom: 2px solid #e2e8f0;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .table td {
            padding: 1rem;
            border-bottom: 1px solid #e2e8f0;
            font-size: 0.95rem;
        }
        
        .table tbody tr:hover {
            background: #f8fafc;
            transition: all 0.2s ease;
        }
        
        .badge {
            padding: 0.5rem 1rem;
            border-radius: 0.75rem;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .badge-success {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #065f46;
        }
        
        .badge-warning {
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            color: #92400e;
        }
        
        .badge-danger {
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            color: #991b1b;
        }
        
        .badge-info {
            background: linear-gradient(135deg, #dbeafe, #bfdbfe);
            color: #1e40af;
        }
        
        .alert {
            padding: 1.5rem;
            border-radius: 1rem;
            margin-bottom: 2rem;
            font-weight: 500;
        }
        
        .alert-error {
            background: linear-gradient(135deg, #fef2f2, #fee2e2);
            color: #dc2626;
            border: 2px solid #fecaca;
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #6b7280;
        }
        
        .empty-state h3 {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: #374151;
        }
        
        .empty-state p {
            font-size: 1rem;
            margin-bottom: 0;
        }
        
        .patient-info {
            font-weight: 600;
            color: #1f2937;
        }
        
        .patient-contact {
            font-size: 0.85rem;
            color: #6b7280;
            margin-top: 0.25rem;
        }
        
        .service-info {
            font-weight: 500;
            color: #374151;
        }
        
        .notes {
            font-style: italic;
            color: #6b7280;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>

    <c:set var="_role" value="${empty sessionScope.user or empty sessionScope.user.role or empty sessionScope.user.role.roleName ? '' : fn:toLowerCase(fn:replace(sessionScope.user.role.roleName, ' ', ''))}"/>
    <c:if test="${_role ne 'clinicmanager'}">
        <c:redirect url="${pageContext.request.contextPath}/login"/>
    </c:if>

    <div class="header">
        <h1>📅 Báo Cáo Lịch Hẹn</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="reports-container">
                <div class="page-header">
                    <h2 class="page-title">📅 Báo Cáo Lịch Hẹn</h2>
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/manager/reports?type=revenue" class="btn btn-primary">
                            💰 Báo Cáo Doanh Thu
                        </a>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        ❌ ${error}
                    </div>
                </c:if>

                <!-- Filter Section -->
                <div class="filter-section">
                    <h3 class="filter-title">🔍 Bộ Lọc</h3>
                    <form method="get" action="${pageContext.request.contextPath}/manager/reports">
                        <input type="hidden" name="type" value="appointments">
                        <div class="filter-row">
                            <div class="form-group">
                                <label class="form-label">Từ ngày:</label>
                                <input type="date" name="dateFrom" class="form-control" value="${dateFrom}">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Đến ngày:</label>
                                <input type="date" name="dateTo" class="form-control" value="${dateTo}">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Tên bác sĩ:</label>
                                <input type="text" name="doctorName" class="form-control" value="${doctorName}" placeholder="Nhập tên bác sĩ...">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Trạng thái:</label>
                                <select name="status" class="form-control">
                                    <option value="">Tất cả</option>
                                    <option value="SCHEDULED" ${status == 'SCHEDULED' ? 'selected' : ''}>Đã đặt</option>
                                    <option value="CONFIRMED" ${status == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                                    <option value="COMPLETED" ${status == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                                    <option value="CANCELLED" ${status == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn btn-primary" style="background: #667eea; color: white;">
                                    🔍 Áp Dụng
                                </button>
                                <a href="${pageContext.request.contextPath}/manager/reports?type=appointments" class="btn btn-primary" style="background: #6b7280; color: white;">
                                    🔄 Xóa Lọc
                                </a>
                            </div>
                        </div>
                    </form>
                </div>

                <c:if test="${not empty appointmentsData.appointmentsList}">
                    <!-- Appointments Table -->
                    <div class="table-container">
                        <div class="table-header">
                            <h3 class="table-title">📋 Danh Sách Lịch Hẹn</h3>
                        </div>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Mã Lịch Hẹn</th>
                                    <th>Ngày Hẹn</th>
                                    <th>Khách Hàng</th>
                                    <th>Bác Sĩ</th>
                                    <th>Dịch Vụ</th>
                                    <th>Trạng Thái</th>
                                    <th>Ghi Chú</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="appointment" items="${appointmentsData.appointmentsList}">
                                    <tr>
                                        <td><strong>#${appointment.appointmentId}</strong></td>
                                        <td>
                                            <strong><fmt:formatDate value="${appointment.appointmentDate}" pattern="dd/MM/yyyy HH:mm"/></strong>
                                        </td>
                                        <td>
                                            <div class="patient-info">${appointment.patientName}</div>
                                            <c:if test="${not empty appointment.patientPhone}">
                                                <div class="patient-contact">📞 ${appointment.patientPhone}</div>
                                            </c:if>
                                            <c:if test="${not empty appointment.patientEmail}">
                                                <div class="patient-contact">✉️ ${appointment.patientEmail}</div>
                                            </c:if>
                                        </td>
                                        <td>
                                            <div class="patient-info">${appointment.doctorName}</div>
                                        </td>
                                        <td>
                                            <div class="service-info">${appointment.serviceName}</div>
                                        </td>
                                        <td>
                                            <span class="badge badge-${appointment.status == 'COMPLETED' ? 'success' : appointment.status == 'CONFIRMED' ? 'success' : appointment.status == 'SCHEDULED' ? 'info' : 'danger'}">
                                                <c:choose>
                                                    <c:when test="${appointment.status == 'COMPLETED'}">✅ Hoàn Thành</c:when>
                                                    <c:when test="${appointment.status == 'CONFIRMED'}">✅ Đã Xác Nhận</c:when>
                                                    <c:when test="${appointment.status == 'SCHEDULED'}">📋 Đã Đặt</c:when>
                                                    <c:when test="${appointment.status == 'CANCELLED'}">❌ Đã Hủy</c:when>
                                                    <c:otherwise>${appointment.status}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>
                                            <c:if test="${not empty appointment.notes}">
                                                <div class="notes">${appointment.notes}</div>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <c:if test="${empty appointmentsData.appointmentsList}">
                    <div class="table-container">
                        <div class="empty-state">
                            <h3>📊 Không có dữ liệu lịch hẹn</h3>
                            <p>Không tìm thấy lịch hẹn nào trong khoảng thời gian đã chọn.</p>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>
    </div>
</body>
</html>