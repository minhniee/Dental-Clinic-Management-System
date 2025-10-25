<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Vật Tư - Manager - Hệ Thống Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .detail-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 1.5rem;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #e2e8f0;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: #1a202c;
            margin: 0;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79, 172, 254, 0.4);
        }

        .btn-warning {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            color: white;
        }

        .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(250, 112, 154, 0.4);
        }

        .detail-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .detail-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e2e8f0;
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: #1a202c;
            margin: 0;
        }

        .stock-status {
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.875rem;
            font-weight: 600;
        }

        .stock-adequate {
            background: #d1fae5;
            color: #065f46;
        }

        .stock-low {
            background: #fef3c7;
            color: #92400e;
        }

        .stock-out {
            background: #fee2e2;
            color: #991b1b;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.75rem;
            padding: 0.5rem 0;
        }

        .detail-label {
            font-weight: 600;
            color: #4a5568;
        }

        .detail-value {
            color: #1a202c;
            font-weight: 500;
        }

        .transactions-table {
            background: white;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            margin-top: 0;
        }

        .table-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem;
            font-weight: 700;
            font-size: 1.25rem;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th {
            background: #f7fafc;
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: #2d3748;
            border-bottom: 2px solid #e2e8f0;
        }

        .table td {
            padding: 1rem;
            border-bottom: 1px solid #e2e8f0;
            vertical-align: middle;
        }

        .table tbody tr:hover {
            background: #f7fafc;
        }

        .transaction-type {
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.875rem;
            font-weight: 600;
        }

        .type-in {
            background: #d1fae5;
            color: #065f46;
        }

        .type-out {
            background: #fee2e2;
            color: #991b1b;
        }

        .quantity {
            font-weight: 700;
            font-size: 1.1rem;
        }

        .quantity-in {
            color: #059669;
        }

        .quantity-out {
            color: #dc2626;
        }

        .alert {
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #718096;
        }

        .empty-state-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
        }

        /* Remove custom positioning fixes */

        @media (max-width: 768px) {
            .detail-container {
                padding: 1rem;
            }
            
            .page-header {
                flex-direction: column;
                gap: 1rem;
                align-items: stretch;
            }
            
            .detail-grid {
                grid-template-columns: 1fr;
            }
            
            .table {
                font-size: 0.875rem;
            }
            
            .table th,
            .table td {
                padding: 0.75rem 0.5rem;
            }
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
        <h1>📦 Chi Tiết Vật Tư</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="detail-container">
            <!-- Page Header -->
            <div class="page-header">
                <h1 class="page-title">📦 Chi Tiết Vật Tư</h1>
                <div>
                    <a href="${pageContext.request.contextPath}/manager/inventory" class="btn btn-primary">
                        ← Quay Lại
                    </a>
                </div>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    ✅ ${success}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    ❌ ${error}
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty item}">
                    <!-- Item Details -->
                    <div class="detail-grid">
                        <div class="detail-card">
                            <div class="card-header">
                                <h3 class="card-title">📦 Thông Tin Vật Tư</h3>
                                <c:choose>
                                    <c:when test="${item.quantity == 0}">
                                        <span class="stock-status stock-out">Hết Hàng</span>
                                    </c:when>
                                    <c:when test="${item.quantity <= item.minStock}">
                                        <span class="stock-status stock-low">Sắp Hết</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="stock-status stock-adequate">Đủ Hàng</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <div class="detail-row">
                                <span class="detail-label">Tên vật tư:</span>
                                <span class="detail-value">${item.name}</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Đơn vị:</span>
                                <span class="detail-value">${item.unit}</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Tồn kho hiện tại:</span>
                                <span class="detail-value"><strong>${item.quantity}</strong></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Tồn kho tối thiểu:</span>
                                <span class="detail-value">${item.minStock}</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Ngày tạo:</span>
                                <span class="detail-value">
                                    ${item.createdAt != null ? item.createdAt.toLocalDate() : 'N/A'}
                                </span>
                            </div>
                        </div>

                        <div class="detail-card">
                            <div class="card-header">
                                <h3 class="card-title">📊 Thống Kê</h3>
                            </div>
                            
                            <div class="detail-row">
                                <span class="detail-label">Trạng thái:</span>
                                <span class="detail-value">${item.stockStatusText}</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Số lượng còn lại:</span>
                                <span class="detail-value">${item.quantity - item.minStock}</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Số ngày sử dụng ước tính:</span>
                                <span class="detail-value">
                                    <c:choose>
                                        <c:when test="${item.quantity > 0}">
                                            <c:set var="estimatedDays" value="${item.quantity / 2}"/>
                                            <c:choose>
                                                <c:when test="${estimatedDays >= 30}">
                                                    <span style="color: #059669; font-weight: 700;">
                                                        <fmt:formatNumber value="${estimatedDays}" pattern="#,##0"/> ngày (Dư thừa)
                                                    </span>
                                                </c:when>
                                                <c:when test="${estimatedDays >= 7}">
                                                    <span style="color: #059669; font-weight: 700;">
                                                        <fmt:formatNumber value="${estimatedDays}" pattern="#,##0"/> ngày (Đủ dùng)
                                                    </span>
                                                </c:when>
                                                <c:when test="${estimatedDays >= 3}">
                                                    <span style="color: #d97706; font-weight: 700;">
                                                        <fmt:formatNumber value="${estimatedDays}" pattern="#,##0"/> ngày (Sắp hết)
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #dc2626; font-weight: 700;">
                                                        <fmt:formatNumber value="${estimatedDays}" pattern="#,##0"/> ngày (Nguy hiểm)
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #dc2626; font-weight: 700;">0 ngày (Hết hàng)</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Transactions History -->
                    <div class="transactions-table">
                        <div class="table-header">
                            📋 Lịch Sử Giao Dịch
                        </div>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>📅 Ngày</th>
                                    <th>🔄 Loại</th>
                                    <th>📊 Số Lượng</th>
                                    <th>👤 Thực Hiện</th>
                                    <th>📝 Ghi Chú</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty transactions}">
                                        <c:forEach var="transaction" items="${transactions}">
                                            <tr>
                                                <td>
                                                    ${transaction.performedAt != null ? transaction.performedAt.toLocalDate() : 'N/A'}
                                                </td>
                                                <td>
                                                    <span class="transaction-type ${transaction.transactionType == 'IN' ? 'type-in' : 'type-out'}">
                                                        ${transaction.transactionType == 'IN' ? '📥 Nhập' : '📤 Xuất'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="quantity ${transaction.transactionType == 'IN' ? 'quantity-in' : 'quantity-out'}">
                                                        ${transaction.transactionType == 'IN' ? '+' : '-'}${transaction.quantity}
                                                    </span>
                                                </td>
                                                <td>${transaction.performedByName}</td>
                                                <td>${transaction.notes}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="empty-state">
                                                <div class="empty-state-icon">📊</div>
                                                <h3>Chưa có giao dịch nào</h3>
                                                <p>Vật tư này chưa có lịch sử giao dịch.</p>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-state-icon">❌</div>
                        <h3>Không tìm thấy vật tư</h3>
                        <p>Vật tư bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
                        <a href="${pageContext.request.contextPath}/admin/inventory" class="btn btn-primary">
                            ← Quay Lại Danh Sách
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
