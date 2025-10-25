<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Yêu Cầu Nghỉ - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
    <style>
        .status-badge {
            font-size: 0.8rem;
            padding: 0.4rem 0.8rem;
            border-radius: 0.5rem;
            font-weight: 500;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        .status-approved {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .status-rejected {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .filter-tabs {
            border-bottom: 2px solid #e9ecef;
            margin-bottom: 2rem;
        }
        .filter-tab {
            padding: 0.75rem 1.5rem;
            border: none;
            background: none;
            color: #6c757d;
            font-weight: 500;
            border-bottom: 3px solid transparent;
            transition: all 0.3s ease;
        }
        .filter-tab.active {
            color: #007bff;
            border-bottom-color: #007bff;
        }
        .filter-tab:hover {
            color: #007bff;
        }
        .request-card {
            border: 1px solid #e9ecef;
            border-radius: 0.75rem;
            transition: all 0.3s ease;
            margin-bottom: 1rem;
        }
        .request-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        .request-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem;
            border-radius: 0.75rem 0.75rem 0 0;
        }
        .request-body {
            padding: 1.5rem;
        }
        .action-buttons {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
        }
        .btn-action {
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-approve {
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
            color: white;
        }
        .btn-approve:hover {
            background: linear-gradient(135deg, #218838, #1e7e34);
            transform: translateY(-1px);
        }
        .btn-reject {
            background: linear-gradient(135deg, #dc3545, #e74c3c);
            border: none;
            color: white;
        }
        .btn-reject:hover {
            background: linear-gradient(135deg, #c82333, #bd2130);
            transform: translateY(-1px);
        }
        .btn-view {
            background: linear-gradient(135deg, #007bff, #0056b3);
            border: none;
            color: white;
        }
        .btn-view:hover {
            background: linear-gradient(135deg, #0056b3, #004085);
            transform: translateY(-1px);
        }
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        .stats-number {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        .stats-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>

    <c:set var="_role" value="${empty sessionScope.user or empty sessionScope.user.role or empty sessionScope.user.role.roleName ? '' : fn:toLowerCase(fn:replace(sessionScope.user.role.roleName, ' ', ''))}"/>
    <c:if test="${_role ne 'administrator' and _role ne 'clinicmanager'}">
        <c:redirect url="${pageContext.request.contextPath}/login"/>
    </c:if>
    
    <div class="header">
        <h1>🦷 Bảng Điều Khiển Quản Trị</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="container">
                <div class="welcome-section">
                    <h2>📋 Quản Lý Yêu Cầu Nghỉ</h2>
                    <p>Duyệt và quản lý các yêu cầu nghỉ của nhân viên</p>
                </div>
                
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h3 class="mb-1">Danh Sách Yêu Cầu</h3>
                        <p class="text-muted mb-0">Quản lý và duyệt các yêu cầu nghỉ</p>
                    </div>
                    <div>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createRequestModal">
                            <i class="fas fa-plus me-2"></i>Tạo Yêu Cầu Mới
                        </button>
                    </div>
                </div>

                        <!-- Thông báo -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Thống kê -->
                        <div class="row mb-4">
                            <div class="col-md-4">
                                <div class="stats-card">
                                    <div class="stats-number">${pendingCount}</div>
                                    <div class="stats-label">Chờ Duyệt</div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="stats-card" style="background: linear-gradient(135deg, #28a745, #20c997);">
                                    <div class="stats-number">${approvedCount}</div>
                                    <div class="stats-label">Đã Duyệt</div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="stats-card" style="background: linear-gradient(135deg, #dc3545, #e74c3c);">
                                    <div class="stats-number">${rejectedCount}</div>
                                    <div class="stats-label">Từ Chối</div>
                                </div>
                            </div>
                        </div>

                        <!-- Bộ lọc -->
                        <div class="filter-tabs">
                            <button class="filter-tab ${empty currentStatus ? 'active' : ''}" 
                                    onclick="filterRequests('')">
                                <i class="fas fa-list me-2"></i>Tất Cả
                            </button>
                            <button class="filter-tab ${currentStatus == 'PENDING' ? 'active' : ''}" 
                                    onclick="filterRequests('PENDING')">
                                <i class="fas fa-clock me-2"></i>Chờ Duyệt
                            </button>
                            <button class="filter-tab ${currentStatus == 'APPROVED' ? 'active' : ''}" 
                                    onclick="filterRequests('APPROVED')">
                                <i class="fas fa-check me-2"></i>Đã Duyệt
                            </button>
                            <button class="filter-tab ${currentStatus == 'REJECTED' ? 'active' : ''}" 
                                    onclick="filterRequests('REJECTED')">
                                <i class="fas fa-times me-2"></i>Từ Chối
                            </button>
                        </div>

                        <!-- Danh sách yêu cầu -->
                        <c:choose>
                            <c:when test="${not empty requests}">
                                <div class="row">
                                    <c:forEach var="request" items="${requests}">
                                        <div class="col-md-6 col-lg-4">
                                            <div class="request-card">
                                                <div class="request-header">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <h6 class="mb-0">${request.employeeName}</h6>
                                                        <span class="status-badge status-${fn:toLowerCase(request.status)}">
                                                            ${request.statusText}
                                                        </span>
                                                    </div>
                                                </div>
                                                <div class="request-body">
                                                    <div class="mb-2">
                                                        <strong>📅 Ngày:</strong> 
                                                        <fmt:formatDate value="${request.date}" pattern="dd/MM/yyyy"/>
                                                    </div>
                                                    <div class="mb-2">
                                                        <strong>⏰ Ca:</strong> ${request.shiftText}
                                                    </div>
                                                    <div class="mb-3">
                                                        <strong>📝 Lý do:</strong>
                                                        <p class="text-muted small mt-1">${request.reason}</p>
                                                    </div>
                                                    <div class="text-muted small mb-3">
                                                        <i class="fas fa-calendar me-1"></i>
                                                        Tạo: <fmt:formatDate value="${request.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </div>
                                                    
                                                    <c:if test="${request.status == 'PENDING'}">
                                                        <div class="action-buttons">
                                                            <a href="${pageContext.request.contextPath}/admin/schedule-requests?action=view&id=${request.requestId}" 
                                                               class="btn btn-view btn-action">
                                                                <i class="fas fa-eye me-1"></i>Xem Chi Tiết
                                                            </a>
                                                        </div>
                                                    </c:if>
                                                    
                                                    <c:if test="${request.status != 'PENDING'}">
                                                        <div class="text-muted small">
                                                            <c:if test="${not empty request.reviewerName}">
                                                                <i class="fas fa-user-check me-1"></i>
                                                                Duyệt bởi: ${request.reviewerName}
                                                            </c:if>
                                                            <c:if test="${not empty request.reviewedAt}">
                                                                <br><i class="fas fa-clock me-1"></i>
                                                                <fmt:formatDate value="${request.reviewedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                            </c:if>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-inbox"></i>
                                    <h5>Không có yêu cầu nào</h5>
                                    <p class="text-muted">Chưa có yêu cầu nghỉ nào được gửi.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Modal Tạo Yêu Cầu Mới -->
    <div class="modal fade" id="createRequestModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Tạo Yêu Cầu Nghỉ Mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/schedule-requests" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="create">
                        
                        <div class="mb-3">
                            <label for="date" class="form-label">Ngày nghỉ</label>
                            <input type="date" class="form-control" id="date" name="date" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="shift" class="form-label">Ca nghỉ</label>
                            <select class="form-select" id="shift" name="shift" required>
                                <option value="">Chọn ca nghỉ</option>
                                <option value="Morning">Sáng</option>
                                <option value="Afternoon">Chiều</option>
                                <option value="FullDay">Cả ngày</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="reason" class="form-label">Lý do nghỉ</label>
                            <textarea class="form-control" id="reason" name="reason" rows="3" 
                                      placeholder="Nhập lý do nghỉ..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Gửi Yêu Cầu</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function filterRequests(status) {
            const url = new URL(window.location);
            if (status) {
                url.searchParams.set('status', status);
            } else {
                url.searchParams.delete('status');
            }
            window.location.href = url.toString();
        }
        
        // Set minimum date to today
        document.getElementById('date').min = new Date().toISOString().split('T')[0];
    </script>
</body>
</html>
