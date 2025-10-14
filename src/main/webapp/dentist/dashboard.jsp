<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Điều Khiển Bác Sĩ Nha Khoa - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>
    
    <c:set var="_role" value="${empty sessionScope.user or empty sessionScope.user.role or empty sessionScope.user.role.roleName ? '' : fn:toLowerCase(fn:replace(sessionScope.user.role.roleName, ' ', ''))}"/>
    <c:if test="${_role ne 'dentist'}">
        <c:redirect url="${pageContext.request.contextPath}/login"/>
    </c:if>
    
    <div class="header">
        <h1>🦷 Bảng Điều Khiển Bác Sĩ Nha Khoa</h1>
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
            <h2>Chào Mừng Đến Bảng Điều Khiển Bác Sĩ Nha Khoa</h2>
            <p>Quản lý lịch hẹn bệnh nhân, xem hồ sơ y tế và truy cập các công cụ lập kế hoạch điều trị. 
               Tập trung vào việc cung cấp dịch vụ chăm sóc nha khoa xuất sắc cho bệnh nhân.</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="card">
                <h3>📅 Lịch Trình Của Tôi</h3>
                <p>Xem lịch hẹn hàng ngày, bệnh nhân sắp tới và tình trạng lịch trình. Quản lý lịch của bạn một cách hiệu quả.</p>
            </div>
            
            <div class="card">
                <h3>📋 Hồ Sơ Bệnh Nhân</h3>
                <p>Truy cập hồ sơ y tế bệnh nhân, lịch sử điều trị và ghi chú khám bệnh. Cập nhật thông tin bệnh nhân một cách an toàn.</p>
            </div>
            
            <div class="card">
                <h3>💊 Đơn Thuốc</h3>
                <p>Tạo và quản lý đơn thuốc cho bệnh nhân. Theo dõi lịch sử thuốc và khuyến nghị liều lượng.</p>
            </div>
            
            <div class="card">
                <h3>🔬 Kế Hoạch Điều Trị</h3>
                <p>Phát triển kế hoạch điều trị toàn diện cho bệnh nhân. Theo dõi tiến độ điều trị và kết quả.</p>
            </div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">8</div>
                <div class="stat-label">Bệnh Nhân Hôm Nay</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">3</div>
                <div class="stat-label">Theo Dõi Chờ Xử Lý</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">15</div>
                <div class="stat-label">Lịch Hẹn Tuần Này</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">98%</div>
                <div class="stat-label">Sự Hài Lòng Của Bệnh Nhân</div>
            </div>
        </div>
        
        <div class="card" style="margin-top: 2rem;">
            <h3>📋 Lịch Hẹn Hôm Nay</h3>
            <p>• 9:00 - John Smith (Khám định kỳ)<br>
               • 10:30 - Sarah Johnson (Làm sạch)<br>
               • 14:00 - Mike Davis (Trám răng)<br>
               • 15:30 - Lisa Wilson (Tư vấn)<br>
               • 16:30 - Robert Brown (Theo dõi)</p>
        </div>
            </div>
        </main>
    </div>
</body>
</html>
