<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Điều Khiển Quản Lý - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
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
        <h1>🦷 Bảng Điều Khiển Quản Lý</h1>
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
            <h2>Chào Mừng Đến Bảng Điều Khiển Quản Lý</h2>
            <p>Quản lý hoạt động hàng ngày của phòng khám, lịch trình nhân viên và dịch vụ bệnh nhân. 
               Giám sát các chỉ số hiệu suất và đảm bảo hoạt động phòng khám diễn ra suôn sẻ.</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="card">
                <h3>📅 Quản Lý Lịch Trình</h3>
                <p>Quản lý lịch trình bác sĩ, khung giờ hẹn và giờ làm việc của phòng khám. Tối ưu hóa phân bổ tài nguyên và giảm thiểu xung đột.</p>
            </div>
            
            <div class="card">
                <h3>💰 Báo Cáo Tài Chính</h3>
                <p>Xem báo cáo doanh thu, theo dõi thanh toán và phân tích tài chính. Giám sát lợi nhuận và chi phí của phòng khám.</p>
            </div>
            
            <div class="card">
                <h3>👥 Quản Lý Nhân Viên</h3>
                <p>Quản lý lịch trình nhân viên, đánh giá hiệu suất và phân bổ tài nguyên. Đảm bảo mức độ nhân sự đầy đủ.</p>
            </div>
            
            <div class="card">
                <h3>📊 Phân Tích Hiệu Suất</h3>
                <p>Theo dõi các chỉ số hiệu suất chính, chỉ số hài lòng của bệnh nhân và dữ liệu hiệu quả hoạt động.</p>
            </div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">25</div>
                <div class="stat-label">Lịch Hẹn Hôm Nay</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">$2,450</div>
                <div class="stat-label">Doanh Thu Hôm Nay</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">8</div>
                <div class="stat-label">Nhân Viên Hoạt Động</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">95%</div>
                <div class="stat-label">Sự Hài Lòng Của Bệnh Nhân</div>
            </div>
        </div>
        
        <div class="card" style="margin-top: 2rem;">
            <h3>📋 Nhiệm Vụ Hôm Nay</h3>
            <p>• Xem xét lịch hẹn hôm nay<br>
               • Kiểm tra tình trạng thanh toán<br>
               • Phối hợp với nhân viên nha khoa<br>
               • Cập nhật mức tồn kho<br>
               • Chuẩn bị báo cáo hàng ngày</p>
        </div>
            </div>
        </main>
    </div>
</body>
</html>
