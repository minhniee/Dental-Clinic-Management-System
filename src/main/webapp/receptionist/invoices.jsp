<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Hóa Đơn - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/receptionist.css">
    <style>
        .invoices-container {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .invoices-header {
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

        .invoices-table {
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

        .status-paid {
            background-color: #d1fae5;
            color: #059669;
        }

        .status-partial {
            background-color: #fef3c7;
            color: #92400e;
        }

        .status-unpaid {
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
        <h1>🦷 Quản Lý Hóa Đơn</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="container">
                <div class="invoices-container">
                    
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

                    <!-- Invoices Header -->
                    <div class="invoices-header">
                        <div class="actions-container">
                            <h2 style="margin: 0; color: #0f172a;">Hóa Đơn</h2>
                            <a href="${pageContext.request.contextPath}/receptionist/invoices?action=new" 
                               class="btn btn-primary">
                                <i class="fas fa-plus"></i>
                                Tạo Hóa Đơn Mới
                            </a>
                            <a href="${pageContext.request.contextPath}/receptionist/dashboard" 
                               class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i>
                                Về Dashboard
                            </a>
                        </div>
                    </div>

                    <!-- Filters Section -->
                    <form method="GET" action="${pageContext.request.contextPath}/receptionist/invoices" class="filters-section">
                        <input type="hidden" name="action" value="list">
                        <div class="filters-form">
                            <div class="form-group">
                                <label for="patientId">Bệnh Nhân</label>
                                <input type="number" 
                                       id="patientId" 
                                       name="patientId" 
                                       class="form-control"
                                       placeholder="ID bệnh nhân"
                                       value="${param.patientId}">
                            </div>
                            <div class="form-group">
                                <label for="status">Trạng Thái</label>
                                <select id="status" name="status" class="form-control">
                                    <option value="">Tất cả</option>
                                    <option value="UNPAID" ${param.status eq 'UNPAID' ? 'selected' : ''}>Chưa thanh toán</option>
                                    <option value="PARTIAL" ${param.status eq 'PARTIAL' ? 'selected' : ''}>Thanh toán một phần</option>
                                    <option value="PAID" ${param.status eq 'PAID' ? 'selected' : ''}>Đã thanh toán</option>
                                </select>
                            </div>
                            <div>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i>
                                    Lọc
                                </button>
                                <a href="${pageContext.request.contextPath}/receptionist/invoices" class="btn btn-secondary">
                                    <i class="fas fa-refresh"></i>
                                    Làm Mới
                                </a>
                            </div>
                        </div>
                    </form>

                    <!-- Invoices Table -->
                    <div class="invoices-table">
                        <c:choose>
                            <c:when test="${not empty invoices}">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Mã Hóa Đơn</th>
                                            <th>Bệnh Nhân</th>
                                            <th>Ngày Tạo</th>
                                            <th>Tổng Tiền</th>
                                            <th>Giảm Giá</th>
                                            <th>Thành Tiền</th>
                                            <th>Trạng Thái</th>
                                            <th>Thao Tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="invoice" items="${invoices}">
                                            <tr>
                                                <td>
                                                    <strong style="color: #0f172a;">#${invoice.invoiceId}</strong>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty invoice.patient}">
                                                            <strong style="color: #0f172a;">${invoice.patient.fullName}</strong>
                                                            <c:if test="${not empty invoice.patient.phone}">
                                                                <br>
                                                                <small style="color: #64748b;">
                                                                    <i class="fas fa-phone"></i> ${invoice.patient.phone}
                                                                </small>
                                                            </c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: #64748b;">ID: ${invoice.patientId}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty invoice.createdAt}">
                                                        ${invoice.formattedCreatedAt}
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${invoice.totalAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> ₫
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${invoice.discountAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> ₫
                                                </td>
                                                <td>
                                                    <strong>
                                                        <fmt:formatNumber value="${invoice.netAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> ₫
                                                    </strong>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${invoice.status eq 'PAID'}">
                                                            <span class="status-badge status-paid">Đã thanh toán</span>
                                                        </c:when>
                                                        <c:when test="${invoice.status eq 'PARTIAL'}">
                                                            <span class="status-badge status-partial">Thanh toán một phần</span>
                                                        </c:when>
                                                        <c:when test="${invoice.status eq 'UNPAID'}">
                                                            <span class="status-badge status-unpaid">Chưa thanh toán</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge">${invoice.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div style="display: flex; gap: 0.5rem; flex-wrap: wrap;">
                                                        <a href="${pageContext.request.contextPath}/receptionist/invoices?action=view&id=${invoice.invoiceId}" 
                                                           class="btn btn-secondary btn-sm">
                                                            <i class="fas fa-eye"></i>        
                                                            Xem Chi Tiết
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-file-invoice"></i>
                                    <h3>Không Có Hóa Đơn</h3>
                                    <p>Không tìm thấy hóa đơn nào theo bộ lọc đã chọn.</p>
                                    <a href="${pageContext.request.contextPath}/receptionist/invoices?action=new" class="btn btn-primary">
                                        <i class="fas fa-plus"></i>
                                        Tạo Hóa Đơn Đầu Tiên
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
