<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết Quả Phân Công Lịch Làm Việc - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .result-container {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
            margin-bottom: 2rem;
        }
        
        .result-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .result-header h2 {
            color: #0f172a;
            margin-bottom: 0.5rem;
        }
        
        .result-status {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 1rem;
            margin-bottom: 2rem;
            padding: 1rem;
            border-radius: 0.5rem;
            font-size: 1.125rem;
            font-weight: 600;
        }
        
        .result-success {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #16a34a;
        }
        
        .result-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #dc2626;
        }
        
        .result-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .stat-card {
            background: #f8fafc;
            border-radius: 0.5rem;
            padding: 1.5rem;
            text-align: center;
            border: 1px solid #e2e8f0;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: #06b6d4;
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            color: #64748b;
            font-size: 0.875rem;
            font-weight: 500;
        }
        
        .result-details {
            background: #f8fafc;
            border-radius: 0.5rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .result-details h3 {
            color: #0f172a;
            margin-bottom: 1rem;
        }
        
        .detail-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem;
            background: #ffffff;
            border-radius: 0.375rem;
            margin-bottom: 0.5rem;
            border: 1px solid #e2e8f0;
        }
        
        .detail-label {
            color: #374151;
            font-weight: 500;
        }
        
        .detail-value {
            color: #0f172a;
            font-weight: 600;
        }
        
        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            border: none;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-primary {
            background: #06b6d4;
            color: white;
        }
        
        .btn-primary:hover {
            background: #0891b2;
        }
        
        .btn-secondary {
            background: #6b7280;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #4b5563;
        }
        
        .btn-success {
            background: #10b981;
            color: white;
        }
        
        .btn-success:hover {
            background: #059669;
        }
        
        .warning-message {
            background: #fef3c7;
            color: #92400e;
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
            border: 1px solid #f59e0b;
        }
        
        .success-message {
            background: #dcfce7;
            color: #166534;
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
            border: 1px solid #16a34a;
        }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>

    <c:set var="_role" value="${empty sessionScope.user or empty sessionScope.user.role or empty sessionScope.user.role.roleName ? '' : fn:toLowerCase(fn:replace(sessionScope.user.role.roleName, ' ', ''))}"/>
    <c:if test="${_role ne 'administrator'}">
        <c:redirect url="${pageContext.request.contextPath}/login"/>
    </c:if>
    
    <div class="header">
        <h1>📊 Kết Quả Phân Công Lịch Làm Việc</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="container">
                <c:if test="${not empty result}">
                    <div class="result-container">
                        <div class="result-header">
                            <h2>Kết Quả Phân Công Lịch Làm Việc</h2>
                            <p>Thông tin chi tiết về quá trình phân công lịch làm việc</p>
                        </div>
                        
                        <!-- Result Status -->
                        <c:choose>
                            <c:when test="${result.success}">
                                <div class="result-status result-success">
                                    <span>✅</span>
                                    <span>Phân công lịch làm việc thành công!</span>
                                </div>
                                
                                <div class="success-message">
                                    <strong>Thành công!</strong> Hệ thống đã hoàn thành việc phân công lịch làm việc theo yêu cầu của bạn.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="result-status result-error">
                                    <span>❌</span>
                                    <span>Có lỗi xảy ra trong quá trình phân công!</span>
                                </div>
                                
                                <div class="warning-message">
                                    <strong>Lỗi:</strong> ${result.error}
                                </div>
                            </c:otherwise>
                        </c:choose>
                        
                        <!-- Result Statistics -->
                        <c:if test="${result.success}">
                            <div class="result-stats">
                                <div class="stat-card">
                                    <div class="stat-number">${result.insertedCount}</div>
                                    <div class="stat-label">Ca Được Tạo</div>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-number">${result.skippedExists}</div>
                                    <div class="stat-label">Ca Bị Bỏ Qua (Đã Tồn Tại)</div>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-number">${result.skippedLocked}</div>
                                    <div class="stat-label">Ca Bị Bỏ Qua (Đã Khóa)</div>
                                </div>
                            </div>
                            
                            <!-- Result Details -->
                            <div class="result-details">
                                <h3>Chi Tiết Kết Quả:</h3>
                                
                                <div class="detail-item">
                                    <span class="detail-label">Tổng số ca được tạo:</span>
                                    <span class="detail-value">${result.insertedCount} ca</span>
                                </div>
                                
                                <c:if test="${result.skippedExists > 0}">
                                    <div class="detail-item">
                                        <span class="detail-label">Ca bị bỏ qua (đã tồn tại):</span>
                                        <span class="detail-value">${result.skippedExists} ca</span>
                                    </div>
                                </c:if>
                                
                                <c:if test="${result.skippedLocked > 0}">
                                    <div class="detail-item">
                                        <span class="detail-label">Ca bị bỏ qua (đã khóa):</span>
                                        <span class="detail-value">${result.skippedLocked} ca</span>
                                    </div>
                                </c:if>
                                
                                <div class="detail-item">
                                    <span class="detail-label">Thời gian hoàn thành:</span>
                                    <span class="detail-value">
                                        <fmt:formatDate value="${result.completedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                    </span>
                                </div>
                            </div>
                            
                            <!-- Additional Information -->
                            <c:if test="${result.skippedExists > 0 or result.skippedLocked > 0}">
                                <div class="warning-message">
                                    <strong>Lưu ý:</strong>
                                    <ul style="margin: 0.5rem 0 0 1rem;">
                                        <c:if test="${result.skippedExists > 0}">
                                            <li>${result.skippedExists} ca đã tồn tại trong hệ thống và được bỏ qua.</li>
                                        </c:if>
                                        <c:if test="${result.skippedLocked > 0}">
                                            <li>${result.skippedLocked} ca đã bị khóa và không thể ghi đè.</li>
                                        </c:if>
                                    </ul>
                                </div>
                            </c:if>
                        </c:if>
                        
                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/admin/schedules" class="btn btn-primary">
                                📅 Phân Công Lịch Mới
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/employees" class="btn btn-secondary">
                                👥 Quản Lý Nhân Viên
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-success">
                                🏠 Trang Chủ
                            </a>
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${empty result}">
                    <div class="result-container">
                        <div style="text-align: center; padding: 2rem;">
                            <h2>Không có kết quả để hiển thị</h2>
                            <p>Vui lòng quay lại và thực hiện phân công lịch làm việc.</p>
                            <a href="${pageContext.request.contextPath}/admin/schedules" class="btn btn-primary">
                                Quay Lại Phân Công
                            </a>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>
    </div>
</body>
</html>
