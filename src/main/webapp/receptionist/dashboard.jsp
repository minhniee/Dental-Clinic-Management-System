<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Điều Khiển Lễ Tân - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
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
        <h1>🦷 Bảng Điều Khiển Lễ Tân</h1>
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
            <h2>Chào Mừng Đến Bảng Điều Khiển Lễ Tân</h2>
            <p>Quản lý lịch hẹn bệnh nhân, xử lý check-in và check-out, và cung cấp dịch vụ khách hàng xuất sắc. 
               Bạn là điểm tiếp xúc đầu tiên với bệnh nhân của chúng tôi.</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="card">
                <h3>📅 Quản Lý Lịch Hẹn</h3>
                <p>Lên lịch hẹn mới, sửa đổi các lịch hẹn hiện có và quản lý lịch hẹn của phòng khám một cách hiệu quả.</p>
            </div>
            
            <div class="card">
                <h3>👥 Check-in/out Bệnh Nhân</h3>
                <p>Check-in bệnh nhân cho lịch hẹn của họ, xác minh thông tin và xử lý thủ tục check-out bao gồm thanh toán.</p>
            </div>
            
            <div class="card">
                <h3>📞 Giao Tiếp Với Bệnh Nhân</h3>
                <p>Xử lý cuộc gọi điện thoại, gửi lời nhắc lịch hẹn và giao tiếp với bệnh nhân về các thay đổi lịch trình.</p>
            </div>
            
            <div class="card">
                <h3>💳 Xử Lý Thanh Toán</h3>
                <p>Xử lý thanh toán, phát hành biên lai và quản lý các yêu cầu thanh toán. Xử lý xác minh bảo hiểm khi cần thiết.</p>
            </div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">12</div>
                <div class="stat-label">Bệnh Nhân Đang Chờ</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">25</div>
                <div class="stat-label">Lịch Hẹn Hôm Nay</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">8</div>
                <div class="stat-label">Hoàn Thành Hôm Nay</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">3</div>
                <div class="stat-label">Không Đến</div>
            </div>
        </div>
        
        <div class="card" style="margin-top: 2rem;">
            <h3>📋 Hàng Chờ Hiện Tại</h3>
            <p>• John Smith - Bác sĩ Johnson - 9:30 (Đang chờ)<br>
               • Sarah Davis - Bác sĩ Wilson - 10:15 (Đã gọi)<br>
               • Mike Brown - Bác sĩ Johnson - 11:00 (Đang chờ)<br>
               • Lisa Garcia - Bác sĩ Wilson - 11:45 (Đang chờ)</p>
        </div>
            </div>
        </main>
    </div>
</body>
</html>
