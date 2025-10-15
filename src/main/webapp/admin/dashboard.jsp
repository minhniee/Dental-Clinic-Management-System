<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Điều Khiển Quản Trị - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
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
            <h2>Chào Mừng Đến Bảng Điều Khiển Quản Trị</h2>
            <p>Bạn có quyền truy cập quản trị đầy đủ vào Hệ Thống Quản Lý Phòng Khám Nha Khoa. 
               Từ đây bạn có thể quản lý người dùng, cài đặt hệ thống và giám sát tất cả hoạt động của phòng khám.</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="card">
                <h3>👥 Quản Lý Người Dùng</h3>
                <p>Quản lý tài khoản người dùng, vai trò và quyền hạn. Tạo tài khoản mới cho nhân viên và bệnh nhân với mức độ truy cập phù hợp.</p>
            </div>
            
            <div class="card">
                <h3>📊 Báo Cáo Hệ Thống</h3>
                <p>Xem các báo cáo toàn diện về hoạt động phòng khám, dữ liệu tài chính và thống kê sử dụng hệ thống để đưa ra quyết định sáng suốt.</p>
            </div>
            
            <div class="card">
                <h3>⚙️ Cài Đặt Hệ Thống</h3>
                <p>Cấu hình cài đặt toàn hệ thống, sao lưu dữ liệu và quản lý lịch bảo trì hệ thống để đảm bảo hiệu suất tối ưu.</p>
            </div>
            
            <div class="card">
                <h3>🔐 Quản Lý Bảo Mật</h3>
                <p>Giám sát nhật ký bảo mật, quản lý chính sách mật khẩu và xem xét các điều khiển truy cập hệ thống để duy trì bảo mật dữ liệu.</p>
            </div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">5</div>
                <div class="stat-label">Tổng Người Dùng</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">3</div>
                <div class="stat-label">Vai Trò Hoạt Động</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">100%</div>
                <div class="stat-label">Thời Gian Hoạt Động Hệ Thống</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">0</div>
                <div class="stat-label">Vấn Đề Bảo Mật</div>
            </div>
        </div>
        
        <div class="quick-actions">
            <h3>📋 Hành Động Nhanh</h3>
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/admin/users" class="action-btn">
                    👥 Quản Lý Người Dùng
                </a>
                <a href="${pageContext.request.contextPath}/admin/roles" class="action-btn">
                    🔐 Quản Lý Vai Trò
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="action-btn">
                    ➕ Tạo Tài Khoản Mới
                </a>
                <a href="${pageContext.request.contextPath}/admin/roles" class="action-btn">
                    ⚙️ Cấu Hình Vai Trò
                </a>
            </div>
        </div>
            </div>
        </main>
    </div>
</body>
</html>
