<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Điều Khiển Bệnh Nhân - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>
    
    <c:set var="_role" value="${empty sessionScope.user or empty sessionScope.user.role or empty sessionScope.user.role.roleName ? '' : fn:toLowerCase(fn:replace(sessionScope.user.role.roleName, ' ', ''))}"/>
    <c:if test="${_role ne 'patient'}">
        <c:redirect url="${pageContext.request.contextPath}/login"/>
    </c:if>
    
    <div class="header">
        <h1>🦷 Cổng Thông Tin Bệnh Nhân</h1>
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
            <h2>Chào Mừng Đến Cổng Thông Tin Bệnh Nhân Của Bạn</h2>
            <p>Truy cập hồ sơ nha khoa của bạn, quản lý lịch hẹn và cập nhật thông tin về sức khỏe răng miệng của bạn. 
               Sức khỏe răng miệng của bạn là ưu tiên của chúng tôi.</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="card">
                <h3>📅 Lịch Hẹn Của Tôi</h3>
                <p>Xem lịch hẹn sắp tới, kiểm tra lịch sử lịch hẹn và yêu cầu lịch hẹn mới trực tuyến.</p>
            </div>
            
            <div class="card">
                <h3>📋 Hồ Sơ Y Tế</h3>
                <p>Truy cập hồ sơ nha khoa, lịch sử điều trị và kết quả khám bệnh. Theo dõi hành trình sức khỏe răng miệng của bạn.</p>
            </div>
            
            <div class="card">
                <h3>💊 Đơn Thuốc</h3>
                <p>Xem đơn thuốc hiện tại và trước đây, hướng dẫn sử dụng thuốc và yêu cầu tái kê đơn.</p>
            </div>
            
            <div class="card">
                <h3>💳 Thanh Toán & Hóa Đơn</h3>
                <p>Xem hóa đơn, lịch sử thanh toán và thực hiện thanh toán trực tuyến. Quản lý thông tin bảo hiểm nha khoa của bạn.</p>
            </div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">2</div>
                <div class="stat-label">Lịch Hẹn Sắp Tới</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">5</div>
                <div class="stat-label">Tổng Lần Khám</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">$450</div>
                <div class="stat-label">Số Dư Chưa Thanh Toán</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">1</div>
                <div class="stat-label">Đơn Thuốc Đang Hoạt Động</div>
            </div>
        </div>
        
        <div class="card" style="margin-top: 2rem;">
            <h3>📅 Lịch Hẹn Sắp Tới</h3>
            <p>• 20 tháng 10, 2024 - 14:00 - Bác sĩ Johnson (Khám định kỳ)<br>
               • 5 tháng 11, 2024 - 10:30 - Bác sĩ Wilson (Làm sạch)<br>
               <br>
               <strong>Cần đổi lịch?</strong> Vui lòng gọi văn phòng của chúng tôi tại (555) 123-4567</p>
        </div>
            </div>
        </main>
    </div>
</body>
</html>
