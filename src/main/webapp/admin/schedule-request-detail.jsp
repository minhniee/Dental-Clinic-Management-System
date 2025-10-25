<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Yêu Cầu Nghỉ - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
    <style>
        .detail-card {
            border: 1px solid #e9ecef;
            border-radius: 1rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .detail-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        .detail-body {
            padding: 2rem;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #f8f9fa;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
            display: flex;
            align-items: center;
        }
        .info-label i {
            margin-right: 0.5rem;
            width: 20px;
        }
        .info-value {
            color: #212529;
            font-weight: 500;
        }
        .status-badge {
            font-size: 1rem;
            padding: 0.5rem 1rem;
            border-radius: 0.75rem;
            font-weight: 600;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
            border: 2px solid #ffeaa7;
        }
        .status-approved {
            background-color: #d4edda;
            color: #155724;
            border: 2px solid #c3e6cb;
        }
        .status-rejected {
            background-color: #f8d7da;
            color: #721c24;
            border: 2px solid #f5c6cb;
        }
        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
        }
        .btn-action {
            padding: 0.75rem 2rem;
            border-radius: 0.75rem;
            font-size: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            min-width: 150px;
        }
        .btn-approve {
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
            color: white;
        }
        .btn-approve:hover {
            background: linear-gradient(135deg, #218838, #1e7e34);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }
        .btn-reject {
            background: linear-gradient(135deg, #dc3545, #e74c3c);
            border: none;
            color: white;
        }
        .btn-reject:hover {
            background: linear-gradient(135deg, #c82333, #bd2130);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
        }
        .btn-back {
            background: linear-gradient(135deg, #6c757d, #495057);
            border: none;
            color: white;
        }
        .btn-back:hover {
            background: linear-gradient(135deg, #5a6268, #343a40);
            transform: translateY(-2px);
        }
        .reason-box {
            background-color: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 0.5rem;
            padding: 1.5rem;
            margin: 1rem 0;
        }
        .reason-text {
            font-style: italic;
            color: #495057;
            line-height: 1.6;
        }
        .timeline {
            position: relative;
            padding-left: 2rem;
        }
        .timeline::before {
            content: '';
            position: absolute;
            left: 0.75rem;
            top: 0;
            bottom: 0;
            width: 2px;
            background: linear-gradient(135deg, #667eea, #764ba2);
        }
        .timeline-item {
            position: relative;
            margin-bottom: 1.5rem;
        }
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -1.75rem;
            top: 0.5rem;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #667eea;
            border: 3px solid white;
            box-shadow: 0 0 0 2px #667eea;
        }
        .timeline-content {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 0.5rem;
            padding: 1rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
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
                    <h2>📋 Chi Tiết Yêu Cầu Nghỉ</h2>
                    <p>Xem chi tiết và duyệt yêu cầu nghỉ của nhân viên</p>
                </div>
                
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <!-- Breadcrumb -->
                        <nav aria-label="breadcrumb" class="mb-4">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/admin/schedule-requests">
                                        <i class="fas fa-arrow-left me-1"></i>Quản Lý Yêu Cầu Nghỉ
                                    </a>
                                </li>
                                <li class="breadcrumb-item active">Chi Tiết Yêu Cầu</li>
                            </ol>
                        </nav>

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

                        <!-- Chi tiết yêu cầu -->
                        <div class="detail-card">
                            <div class="detail-header">
                                <h2 class="mb-2">📋 Chi Tiết Yêu Cầu Nghỉ</h2>
                                <span class="status-badge status-${fn:toLowerCase(request.status)}">
                                    ${request.statusText}
                                </span>
                            </div>
                            
                            <div class="detail-body">
                                <!-- Thông tin cơ bản -->
                                <div class="info-row">
                                    <div class="info-label">
                                        <i class="fas fa-user"></i>Nhân viên
                                    </div>
                                    <div class="info-value">${request.employeeName}</div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="info-label">
                                        <i class="fas fa-calendar"></i>Ngày nghỉ
                                    </div>
                                    <div class="info-value">
                                        <fmt:formatDate value="${request.date}" pattern="dd/MM/yyyy"/>
                                    </div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="info-label">
                                        <i class="fas fa-clock"></i>Ca nghỉ
                                    </div>
                                    <div class="info-value">${request.shiftText}</div>
                                </div>
                                
                                <div class="info-row">
                                    <div class="info-label">
                                        <i class="fas fa-calendar-plus"></i>Ngày tạo
                                    </div>
                                    <div class="info-value">
                                        <fmt:formatDate value="${request.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </div>
                                
                                <!-- Lý do nghỉ -->
                                <div class="reason-box">
                                    <h6 class="mb-3">
                                        <i class="fas fa-file-alt me-2"></i>Lý do nghỉ
                                    </h6>
                                    <div class="reason-text">${request.reason}</div>
                                </div>
                                
                                <!-- Thông tin duyệt -->
                                <c:if test="${request.status != 'PENDING'}">
                                    <div class="info-row">
                                        <div class="info-label">
                                            <i class="fas fa-user-check"></i>Người duyệt
                                        </div>
                                        <div class="info-value">${request.reviewerName}</div>
                                    </div>
                                    
                                    <div class="info-row">
                                        <div class="info-label">
                                            <i class="fas fa-clock"></i>Thời gian duyệt
                                        </div>
                                        <div class="info-value">
                                            <fmt:formatDate value="${request.reviewedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                        
                        <!-- Timeline -->
                        <div class="detail-card mt-4">
                            <div class="detail-body">
                                <h5 class="mb-4">
                                    <i class="fas fa-history me-2"></i>Lịch Sử Xử Lý
                                </h5>
                                
                                <div class="timeline">
                                    <div class="timeline-item">
                                        <div class="timeline-content">
                                            <h6 class="mb-2">
                                                <i class="fas fa-paper-plane me-2"></i>Yêu cầu được gửi
                                            </h6>
                                            <p class="text-muted mb-0">
                                                <fmt:formatDate value="${request.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </p>
                                        </div>
                                    </div>
                                    
                                    <c:if test="${request.status != 'PENDING'}">
                                        <div class="timeline-item">
                                            <div class="timeline-content">
                                                <h6 class="mb-2">
                                                    <c:choose>
                                                        <c:when test="${request.status == 'APPROVED'}">
                                                            <i class="fas fa-check-circle me-2 text-success"></i>Yêu cầu được duyệt
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fas fa-times-circle me-2 text-danger"></i>Yêu cầu bị từ chối
                                                        </c:otherwise>
                                                    </c:choose>
                                                </h6>
                                                <p class="text-muted mb-0">
                                                    Bởi: ${request.reviewerName} - 
                                                    <fmt:formatDate value="${request.reviewedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </p>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Nút hành động -->
                        <c:if test="${request.status == 'PENDING'}">
                            <div class="action-buttons">
                                <form action="${pageContext.request.contextPath}/admin/schedule-requests" method="post" 
                                      style="display: inline;" onsubmit="return confirm('Bạn có chắc chắn muốn phê duyệt yêu cầu này?')">
                                    <input type="hidden" name="action" value="approve">
                                    <input type="hidden" name="requestId" value="${request.requestId}">
                                    <button type="submit" class="btn btn-approve btn-action">
                                        <i class="fas fa-check me-2"></i>Phê Duyệt
                                    </button>
                                </form>
                                
                                <form action="${pageContext.request.contextPath}/admin/schedule-requests" method="post" 
                                      style="display: inline;" onsubmit="return confirm('Bạn có chắc chắn muốn từ chối yêu cầu này?')">
                                    <input type="hidden" name="action" value="reject">
                                    <input type="hidden" name="requestId" value="${request.requestId}">
                                    <button type="submit" class="btn btn-reject btn-action">
                                        <i class="fas fa-times me-2"></i>Từ Chối
                                    </button>
                                </form>
                            </div>
                        </c:if>
                        
                        <!-- Nút quay lại -->
                        <div class="text-center mt-4">
                            <a href="${pageContext.request.contextPath}/admin/schedule-requests" 
                               class="btn btn-back btn-action">
                                <i class="fas fa-arrow-left me-2"></i>Quay Lại
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
