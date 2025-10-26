<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Hẹn Trực Tuyến - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/receptionist.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .page-header {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }
        
        .page-title {
            font-size: 1.875rem;
            font-weight: 700;
            color: #0f172a;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .page-description {
            color: #64748b;
            margin-top: 0.5rem;
            margin-bottom: 0;
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
            padding: 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }

        .form-control:focus {
            outline: none;
            border-color: #06b6d4;
            box-shadow: 0 0 0 3px rgba(6, 182, 212, 0.1);
        }

        .content-card {
            background: #ffffff;
            border-radius: 0.75rem;
            overflow: hidden;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }

        .card-body {
            padding: 0;
        }

        .table-responsive {
            overflow-x: auto;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1000px;
        }

        .table thead {
            background-color: #f8fafc;
        }

        .table th,
        .table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
            vertical-align: top;
        }

        .table th {
            font-weight: 600;
            color: #0f172a;
            font-size: 0.875rem;
            white-space: nowrap;
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
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            white-space: nowrap;
        }

        .status-pending {
            background-color: #fef3c7;
            color: #d97706;
        }

        .status-confirmed {
            background-color: #d1fae5;
            color: #059669;
        }

        .status-rejected {
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
            white-space: nowrap;
        }

        .btn-primary {
            background-color: #06b6d4;
            color: #ffffff;
        }

        .btn-primary:hover {
            background-color: #0891b2;
        }

        .btn-success {
            background-color: #10b981;
            color: #ffffff;
        }

        .btn-success:hover {
            background-color: #059669;
        }

        .btn-danger {
            background-color: #ef4444;
            color: #ffffff;
        }

        .btn-danger:hover {
            background-color: #dc2626;
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
            display: flex;
            align-items: center;
            gap: 0.5rem;
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
            padding: 4rem 2rem;
            color: #64748b;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            color: #94a3b8;
        }

        .empty-state h3 {
            margin-bottom: 0.5rem;
            color: #0f172a;
        }

        .actions-container {
            display: flex;
            gap: 0.5rem;
            align-items: center;
            flex-wrap: wrap;
            justify-content: flex-start;
        }

        .request-info {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .request-name {
            font-weight: 600;
            color: #0f172a;
        }

        .request-contact {
            color: #64748b;
            font-size: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .text-muted {
            color: #94a3b8;
            font-style: italic;
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }
            
            .page-header {
                padding: 1.5rem;
            }
            
            .page-title {
                font-size: 1.5rem;
            }
            
            .filters-form {
                grid-template-columns: 1fr;
            }
            
            .table {
                font-size: 0.75rem;
            }
            
            .table th,
            .table td {
                padding: 0.75rem 0.5rem;
            }
            
            .actions-container {
                flex-direction: column;
                align-items: stretch;
                gap: 0.25rem;
            }
            
            .btn {
                justify-content: center;
            }
        }
    </style>
    
    <script>
        function confirmRequest(requestId, status, statusFilter) {
            if (confirm('Bạn có chắc chắn muốn xác nhận yêu cầu này?')) {
                updateRequestStatus(requestId, status, statusFilter);
            }
        }
        
        function rejectRequest(requestId, statusFilter) {
            if (confirm('Bạn có chắc chắn muốn từ chối yêu cầu này?')) {
                updateRequestStatus(requestId, 'REJECTED', statusFilter);
            }
        }
        
        function updateRequestStatus(requestId, status, statusFilter) {
            // Create a form dynamically
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/receptionist/online-appointments';
            
            // Add form fields
            const actionField = document.createElement('input');
            actionField.type = 'hidden';
            actionField.name = 'action';
            actionField.value = 'update_status';
            form.appendChild(actionField);
            
            const requestIdField = document.createElement('input');
            requestIdField.type = 'hidden';
            requestIdField.name = 'requestId';
            requestIdField.value = requestId;
            form.appendChild(requestIdField);
            
            const statusField = document.createElement('input');
            statusField.type = 'hidden';
            statusField.name = 'status';
            statusField.value = status;
            form.appendChild(statusField);
            
            const statusFilterField = document.createElement('input');
            statusFilterField.type = 'hidden';
            statusFilterField.name = 'statusFilter';
            statusFilterField.value = statusFilter || '';
            form.appendChild(statusFilterField);
            
            // Submit the form
            document.body.appendChild(form);
            form.submit();
        }
    </script>
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
            <div class="container">
                <!-- Header Section -->
                <div class="page-header">
                    <h1 class="page-title">
                        <i class="fas fa-globe"></i>
                        Lịch Hẹn Trực Tuyến
                    </h1>
                    <p class="page-description">Quản lý các yêu cầu đặt lịch hẹn từ hệ thống trực tuyến</p>
                </div>

                <!-- Alerts -->
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

                <!-- Filters Section -->
                <div class="filters-section">
                    <form method="get" class="filters-form">
                        <div class="form-group">
                            <label for="status">Trạng Thái:</label>
                            <select id="status" name="status" class="form-control">
                                <option value="ALL" ${statusFilter eq 'ALL' ? 'selected' : ''}>Tất Cả</option>
                                <option value="PENDING" ${statusFilter eq 'PENDING' ? 'selected' : ''}>Chờ Xử Lý</option>
                                <option value="CONFIRMED" ${statusFilter eq 'CONFIRMED' ? 'selected' : ''}>Đã Xác Nhận</option>
                                <option value="REJECTED" ${statusFilter eq 'REJECTED' ? 'selected' : ''}>Từ Chối</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <div class="button-group">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-filter"></i>
                                    Lọc
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Content Card -->
                <div class="content-card">
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty appointmentRequests}">
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Thông Tin Khách Hàng</th>
                                                <th>Dịch Vụ</th>
                                                <th>Bác Sĩ Ưa Thích</th>
                                                <th>Ngày Hẹn</th>
                                                <th>Ca Khám</th>
                                                <th>Trạng Thái</th>
                                                <th>Ngày Tạo</th>
                                                <th>Thao Tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="request" items="${appointmentRequests}">
                                            <tr>
                                                <td>
                                                    <div class="request-info">
                                                        <span class="request-name">
                                                            <c:out value="${request.fullName}"/>
                                                        </span>
                                                        <span class="request-contact">
                                                            <i class="fas fa-phone"></i> <c:out value="${request.phone}"/>
                                                        </span>
                                                        <span class="request-contact">
                                                            <i class="fas fa-envelope"></i> <c:out value="${request.email}"/>
                                                        </span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty request.service}">
                                                            <c:out value="${request.service.name}"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa chọn</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty request.preferredDoctor}">
                                                            <c:out value="${request.preferredDoctor.fullName}"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Không yêu cầu</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty request.preferredDate}">
                                                            <div style="display: flex; flex-direction: column; gap: 0.25rem;">
                                                                <span style="font-weight: 600; color: #0f172a;">
                                                                    <fmt:formatDate value="${request.preferredDateAsDate}" pattern="dd/MM/yyyy"/>
                                                                </span>
                                                                <span style="font-size: 0.75rem; color: #64748b;">
                                                                    <fmt:formatDate value="${request.preferredDateAsDate}" pattern="EEEE"/>
                                                                </span>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa chọn</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty request.preferredShift}">
                                                            <span style="background-color: #e0f2fe; color: #0277bd; padding: 0.25rem 0.5rem; border-radius: 0.25rem; font-size: 0.75rem; font-weight: 500;">
                                                                <c:out value="${request.preferredShift}"/>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Không chọn</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${request.status eq 'PENDING'}">
                                                            <span class="status-badge status-pending">
                                                                <i class="fas fa-clock"></i> Chờ Xử Lý
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${request.status eq 'CONFIRMED'}">
                                                            <span class="status-badge status-confirmed">
                                                                <i class="fas fa-check"></i> Đã Xác Nhận
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${request.status eq 'REJECTED'}">
                                                            <span class="status-badge status-rejected">
                                                                <i class="fas fa-times"></i> Từ Chối
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-pending">
                                                                <c:out value="${request.status}"/>
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty request.createdAt}">
                                                            <div style="display: flex; flex-direction: column; gap: 0.25rem;">
                                                                <span style="font-weight: 500;">
                                                                    <fmt:formatDate value="${request.createdAtAsDate}" pattern="dd/MM/yyyy"/>
                                                                </span>
                                                                <span style="font-size: 0.75rem; color: #64748b;">
                                                                    <fmt:formatDate value="${request.createdAtAsDate}" pattern="HH:mm"/>
                                                                </span>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">N/A</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="actions-container">
                                                        <a href="${pageContext.request.contextPath}/receptionist/online-appointments?action=view&id=${request.requestId}" 
                                                           class="btn btn-secondary btn-sm">
                                                            <i class="fas fa-eye"></i> Xem
                                                        </a>
                                                        
                                                        <c:if test="${request.status eq 'PENDING'}">
                                                            <button type="button" class="btn btn-success btn-sm" 
                                                                    onclick="confirmRequest(${request.requestId}, 'CONFIRMED', '${statusFilter}')">
                                                                <i class="fas fa-check"></i> Xác Nhận
                                                            </button>
                                                            
                                                            <button type="button" class="btn btn-danger btn-sm" 
                                                                    onclick="rejectRequest(${request.requestId}, '${statusFilter}')">
                                                                <i class="fas fa-times"></i> Từ Chối
                                                            </button>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-globe"></i>
                                    <h3>Không Có Yêu Cầu</h3>
                                    <p>Không tìm thấy yêu cầu đặt lịch nào theo bộ lọc đã chọn.</p>
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
