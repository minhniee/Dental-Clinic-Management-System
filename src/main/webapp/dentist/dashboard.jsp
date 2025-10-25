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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/unified-styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
        <h1>Bảng Điều Khiển Bác Sĩ Nha Khoa</h1>
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
            <p>Quản lý lịch hẹn bệnh nhân, theo dõi hàng đợi khám bệnh và truy cập lịch sử y tế. 
               Tập trung vào việc cung cấp dịch vụ chăm sóc nha khoa xuất sắc cho bệnh nhân.</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="card" onclick="window.location.href='${pageContext.request.contextPath}/dentist/schedule?action=daily'">
                <h3>Lịch Trình Hàng Ngày</h3>
                <p>Xem lịch hẹn hàng ngày, bệnh nhân sắp tới và tình trạng lịch trình. Quản lý lịch của bạn một cách hiệu quả.</p>
            </div>
            
            <div class="card" onclick="window.location.href='${pageContext.request.contextPath}/dentist/schedule?action=weekly'">
                <h3>Lịch Trình Hàng Tuần</h3>
                <p>Xem tổng quan lịch hẹn trong tuần, lập kế hoạch và điều chỉnh lịch trình làm việc.</p>
            </div>
            
            <div class="card" onclick="window.location.href='${pageContext.request.contextPath}/dentist/patients'">
                <h3>Danh Sách Bệnh Nhân</h3>
                <p>Quản lý danh sách bệnh nhân, theo dõi trạng thái khám bệnh và đánh dấu đã khám.</p>
            </div>
            
            <div class="card" onclick="window.location.href='${pageContext.request.contextPath}/dentist/medical-history'">
                <h3>Lịch Sử Khám Bệnh</h3>
                <p>Truy cập lịch sử khám bệnh của từng bệnh nhân, xem hồ sơ y tế và theo dõi tiến độ điều trị.</p>
            </div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">${patientsNotExaminedToday}</div>
                <div class="stat-label">Bệnh Nhân Chưa Khám</div>
                <div class="stat-description">Cần khám hôm nay</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${patientsExaminedToday}</div>
                <div class="stat-label">Đã Khám</div>
                <div class="stat-description">Hoàn thành hôm nay</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${totalAppointmentsToday}</div>
                <div class="stat-label">Lịch Hẹn Hôm Nay</div>
                <div class="stat-description">Tổng số cuộc hẹn</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${patientsWaitingInQueue}</div>
                <div class="stat-label">Đang Chờ</div>
                <div class="stat-description">Trong hàng đợi</div>
            </div>
        </div>
        
        <div class="quick-actions">
            <h3>Thao Tác Nhanh</h3>
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/dentist/patients" class="action-btn primary">
                    <span>Xem Danh Sách Bệnh Nhân</span>
                </a>
                <a href="${pageContext.request.contextPath}/dentist/schedule?action=daily" class="action-btn secondary">
                    <span>Lịch Hàng Ngày</span>
                </a>
                <a href="${pageContext.request.contextPath}/dentist/medical-history" class="action-btn secondary">
                    <span>Lịch Sử Khám Bệnh</span>
                </a>
            </div>
        </div>

            </div>
        </main>
    </div>
</body>
</html>
