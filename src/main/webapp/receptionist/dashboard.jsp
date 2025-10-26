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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/receptionist.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .btn-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: #06b6d4;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.875rem;
            margin-top: 1rem;
            transition: color 0.2s ease-in-out;
        }
        
        .btn-link:hover {
            color: #0891b2;
            text-decoration: underline;
        }
        
        .card {
            position: relative;
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        }
        
        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px 0 rgba(0, 0, 0, 0.15);
        }
        
        .quick-action-btn {
            padding: 1.5rem;
            text-align: center;
            border-radius: 0.75rem;
            background: linear-gradient(135deg, #06b6d4, #0891b2);
            color: white;
            text-decoration: none;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.75rem;
            transition: all 0.3s ease-in-out;
            border: none;
            box-shadow: 0 2px 4px 0 rgba(6, 182, 212, 0.2);
        }
        
        .quick-action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px 0 rgba(6, 182, 212, 0.4);
            color: white;
            text-decoration: none;
        }
        
        .quick-action-btn i {
            font-size: 1.75rem;
        }
        
        .quick-action-btn span {
            font-weight: 600;
            font-size: 0.875rem;
        }
        
        .status-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .status-waiting {
            background-color: #fef3c7;
            color: #d97706;
        }
        
        .status-checked-in {
            background-color: #dbeafe;
            color: #2563eb;
        }
        
        .status-called {
            background-color: #d1fae5;
            color: #059669;
        }
        
        .status-in-treatment {
            background-color: #fce7f3;
            color: #be185d;
        }
        
        .status-default {
            background-color: #f3f4f6;
            color: #6b7280;
        }
    </style>
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
            <h2><i class="fas fa-user-md"></i> Chào Mừng Đến Bảng Điều Khiển Lễ Tân</h2>
            <p>Quản lý lịch hẹn bệnh nhân, xử lý check-in và check-out, và cung cấp dịch vụ khách hàng xuất sắc. 
               Bạn là điểm tiếp xúc đầu tiên với bệnh nhân của chúng tôi.</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="card">
                <h3><i class="fas fa-calendar-alt"></i> Quản Lý Lịch Hẹn</h3>
                <p>Lên lịch hẹn mới, sửa đổi các lịch hẹn hiện có và quản lý lịch hẹn của phòng khám một cách hiệu quả.</p>
                <a href="${pageContext.request.contextPath}/receptionist/appointments" class="btn-link">
                    <i class="fas fa-arrow-right"></i> Xem Chi Tiết
                </a>
            </div>
            
            <div class="card">
                <h3><i class="fas fa-users"></i> Check-in/out Bệnh Nhân</h3>
                <p>Check-in bệnh nhân cho lịch hẹn của họ, xác minh thông tin và xử lý thủ tục check-out bao gồm thanh toán.</p>
                <a href="${pageContext.request.contextPath}/receptionist/queue" class="btn-link">
                    <i class="fas fa-arrow-right"></i> Xem Chi Tiết
                </a>
            </div>
            
            <div class="card">
                <h3><i class="fas fa-phone"></i> Giao Tiếp Với Bệnh Nhân</h3>
                <p>Xử lý cuộc gọi điện thoại, gửi lời nhắc lịch hẹn và giao tiếp với bệnh nhân về các thay đổi lịch trình.</p>
                <a href="${pageContext.request.contextPath}/receptionist/patients" class="btn-link">
                    <i class="fas fa-arrow-right"></i> Xem Chi Tiết
                </a>
            </div>
            
            <div class="card">
                <h3><i class="fas fa-credit-card"></i> Xử Lý Thanh Toán</h3>
                <p>Xử lý thanh toán, phát hành biên lai và quản lý các yêu cầu thanh toán. Xử lý xác minh bảo hiểm khi cần thiết.</p>
                <a href="${pageContext.request.contextPath}/receptionist/invoices" class="btn-link">
                    <i class="fas fa-arrow-right"></i> Xem Chi Tiết
                </a>
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
                                    <strong>
                                        <c:choose>
                                            <c:when test="${not empty queueItem.appointment.patient.fullName}">
                                                ${queueItem.appointment.patient.fullName}
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </strong>
                                    <span style="color: #64748b;"> - 
                                        <c:choose>
                                            <c:when test="${not empty queueItem.appointment.dentist.fullName}">
                                                ${queueItem.appointment.dentist.fullName}
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span style="color: #64748b; font-size: 0.875rem;">
                                        <c:choose>
                                            <c:when test="${not empty queueItem.appointment.appointmentDateAsDate}">
                                                <fmt:formatDate value="${queueItem.appointment.appointmentDateAsDate}" pattern="HH:mm"/>
                                            </c:when>
                                            <c:otherwise>
                                                N/A
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div style="display: flex; align-items: center; gap: 0.5rem;">
                                    <span style="background-color: #06b6d4; color: white; padding: 0.25rem 0.5rem; border-radius: 0.25rem; font-size: 0.75rem; font-weight: 600;">
                                        #<c:choose>
                                            <c:when test="${not empty queueItem.positionInQueue}">
                                                ${queueItem.positionInQueue}
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="status-badge
                                          <c:choose>
                                              <c:when test="${queueItem.status eq 'WAITING'}"> status-waiting</c:when>
                                              <c:when test="${queueItem.status eq 'CHECKED_IN'}"> status-checked-in</c:when>
                                              <c:when test="${queueItem.status eq 'CALLED'}"> status-called</c:when>
                                              <c:when test="${queueItem.status eq 'IN_TREATMENT'}"> status-in-treatment</c:when>
                                              <c:otherwise> status-default</c:otherwise>
                                          </c:choose>">
                                        <c:choose>
                                            <c:when test="${queueItem.status eq 'WAITING'}">Đang chờ</c:when>
                                            <c:when test="${queueItem.status eq 'CHECKED_IN'}">Đã check-in</c:when>
                                            <c:when test="${queueItem.status eq 'CALLED'}">Đã gọi</c:when>
                                            <c:when test="${queueItem.status eq 'IN_TREATMENT'}">Đang điều trị</c:when>
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${not empty queueItem.status}">${queueItem.status}</c:when>
                                                    <c:otherwise>N/A</c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
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
            <h3><i class="fas fa-bolt"></i> Thao Tác Nhanh</h3>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem;">
                <a href="${pageContext.request.contextPath}/receptionist/patients?action=new" 
                   class="quick-action-btn">
                    <i class="fas fa-user-plus"></i>
                    <span>Đăng Ký Bệnh Nhân</span>
                </a>
                <a href="${pageContext.request.contextPath}/receptionist/appointments?action=new" 
                   class="quick-action-btn">
                    <i class="fas fa-calendar-plus"></i>
                    <span>Đặt Lịch Hẹn</span>
                </a>
                <a href="${pageContext.request.contextPath}/receptionist/queue" 
                   class="quick-action-btn">
                    <i class="fas fa-list-ol"></i>
                    <span>Quản Lý Hàng Chờ</span>
                </a>
                <a href="${pageContext.request.contextPath}/receptionist/appointment-calendar" 
                   class="quick-action-btn">
                    <i class="fas fa-calendar-alt"></i>
                    <span>Xem Lịch Tuần</span>
                </a>
                <a href="${pageContext.request.contextPath}/receptionist/invoices?action=new" 
                   class="quick-action-btn">
                    <i class="fas fa-file-invoice"></i>
                    <span>Tạo Hóa Đơn</span>
                </a>
                <a href="${pageContext.request.contextPath}/receptionist/online-appointments" 
                   class="quick-action-btn">
                    <i class="fas fa-globe"></i>
                    <span>Lịch Hẹn Online</span>
                </a>
            </div>
        </div>
            </div>
        </main>
    </div>
</body>
</html>
