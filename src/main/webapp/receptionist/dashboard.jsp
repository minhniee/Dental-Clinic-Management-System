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
                <div class="stat-number">
                    <c:choose>
                        <c:when test="${not empty stats}">${stats.waitingPatients}</c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                </div>
                <div class="stat-label">Bệnh Nhân Đang Chờ</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <c:choose>
                        <c:when test="${not empty stats}">${stats.scheduledAppointments}</c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                </div>
                <div class="stat-label">Lịch Hẹn Hôm Nay</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <c:choose>
                        <c:when test="${not empty stats}">${stats.completedAppointments}</c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                </div>
                <div class="stat-label">Hoàn Thành Hôm Nay</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <c:choose>
                        <c:when test="${not empty stats}">${stats.cancelledAppointments}</c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                </div>
                <div class="stat-label">Không Đến</div>
            </div>
        </div>
        
        <!-- Current Queue Section -->
        <div class="card" style="margin-top: 2rem;">
            <h3>📋 Hàng Chờ Hiện Tại</h3>
            <c:choose>
                <c:when test="${not empty currentQueue}">
                    <div style="display: flex; flex-direction: column; gap: 0.5rem;">
                        <c:forEach var="queueItem" items="${currentQueue}">
                            <div style="display: flex; justify-content: space-between; align-items: center; padding: 0.75rem; background-color: #f8fafc; border-radius: 0.5rem; border-left: 4px solid #06b6d4;">
                                <div>
                                    <strong>${queueItem.appointment.patient.fullName}</strong>
                                    <span style="color: #64748b;"> - ${queueItem.appointment.dentist.fullName}</span>
                                    <span style="color: #64748b; font-size: 0.875rem;">
                                        <fmt:formatDate value="${queueItem.appointment.appointmentDate}" pattern="HH:mm"/>
                                    </span>
                                </div>
                                <div style="display: flex; align-items: center; gap: 0.5rem;">
                                    <span style="background-color: #06b6d4; color: white; padding: 0.25rem 0.5rem; border-radius: 0.25rem; font-size: 0.75rem; font-weight: 600;">
                                        #${queueItem.positionInQueue}
                                    </span>
                                    <span style="padding: 0.25rem 0.5rem; border-radius: 0.25rem; font-size: 0.75rem; font-weight: 600;
                                          <c:choose>
                                              <c:when test="${queueItem.status eq 'WAITING'}">background-color: #fef3c7; color: #d97706;</c:when>
                                              <c:when test="${queueItem.status eq 'CHECKED_IN'}">background-color: #dbeafe; color: #2563eb;</c:when>
                                              <c:when test="${queueItem.status eq 'CALLED'}">background-color: #d1fae5; color: #059669;</c:when>
                                              <c:when test="${queueItem.status eq 'IN_TREATMENT'}">background-color: #fce7f3; color: #be185d;</c:when>
                                              <c:otherwise>background-color: #f3f4f6; color: #6b7280;</c:otherwise>
                                          </c:choose>">
                                        <c:choose>
                                            <c:when test="${queueItem.status eq 'WAITING'}">Đang chờ</c:when>
                                            <c:when test="${queueItem.status eq 'CHECKED_IN'}">Đã check-in</c:when>
                                            <c:when test="${queueItem.status eq 'CALLED'}">Đã gọi</c:when>
                                            <c:when test="${queueItem.status eq 'IN_TREATMENT'}">Đang điều trị</c:when>
                                            <c:otherwise>${queueItem.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p style="color: #64748b; text-align: center; padding: 2rem;">
                        Hiện tại không có bệnh nhân nào trong hàng chờ
                    </p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Quick Actions -->
        <div class="card" style="margin-top: 1.5rem;">
            <h3>⚡ Thao Tác Nhanh</h3>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
                <a href="${pageContext.request.contextPath}/receptionist/patients?action=new" 
                   class="btn btn-primary" style="padding: 1rem; text-align: center; border-radius: 0.5rem; background-color: #06b6d4; color: white; text-decoration: none; display: flex; flex-direction: column; align-items: center; gap: 0.5rem;">
                    <i class="fas fa-user-plus" style="font-size: 1.5rem;"></i>
                    <span>Đăng Ký Bệnh Nhân</span>
                </a>
                <a href="${pageContext.request.contextPath}/receptionist/appointments?action=new" 
                   class="btn btn-primary" style="padding: 1rem; text-align: center; border-radius: 0.5rem; background-color: #06b6d4; color: white; text-decoration: none; display: flex; flex-direction: column; align-items: center; gap: 0.5rem;">
                    <i class="fas fa-calendar-plus" style="font-size: 1.5rem;"></i>
                    <span>Đặt Lịch Hẹn</span>
                </a>
                <a href="${pageContext.request.contextPath}/receptionist/queue" 
                   class="btn btn-primary" style="padding: 1rem; text-align: center; border-radius: 0.5rem; background-color: #06b6d4; color: white; text-decoration: none; display: flex; flex-direction: column; align-items: center; gap: 0.5rem;">
                    <i class="fas fa-list-ol" style="font-size: 1.5rem;"></i>
                    <span>Quản Lý Hàng Chờ</span>
                </a>
                <a href="${pageContext.request.contextPath}/receptionist/appointments?action=list" 
                   class="btn btn-primary" style="padding: 1rem; text-align: center; border-radius: 0.5rem; background-color: #06b6d4; color: white; text-decoration: none; display: flex; flex-direction: column; align-items: center; gap: 0.5rem;">
                    <i class="fas fa-calendar-alt" style="font-size: 1.5rem;"></i>
                    <span>Xem Lịch Hẹn</span>
                </a>
                <a href="${pageContext.request.contextPath}/receptionist/invoices?action=new" 
                   class="btn btn-primary" style="padding: 1rem; text-align: center; border-radius: 0.5rem; background-color: #06b6d4; color: white; text-decoration: none; display: flex; flex-direction: column; align-items: center; gap: 0.5rem;">
                    <i class="fas fa-file-invoice" style="font-size: 1.5rem;"></i>
                    <span>Tạo Hóa Đơn</span>
                </a>
            </div>
        </div>
            </div>
        </main>
    </div>
</body>
</html>
