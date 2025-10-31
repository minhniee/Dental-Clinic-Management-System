<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Vận Hành - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px; margin-bottom: 40px; }
        .stat-card { background: white; padding: 25px; border-radius: 16px; box-shadow: 0 8px 25px rgba(0,0,0,0.08); border: none; position: relative; overflow: hidden; transition: all 0.3s ease; }
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 15px 35px rgba(0,0,0,0.12); }
        .stat-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px; background: linear-gradient(90deg, #667eea, #764ba2); }
        .stat-card.revenue::before { background: linear-gradient(90deg, #11998e, #38ef7d); }
        .stat-card.appointments::before { background: linear-gradient(90deg, #ff416c, #ff4b2b); }
        .stat-card.employees::before { background: linear-gradient(90deg, #4facfe, #00f2fe); }
        .stat-card.requests::before { background: linear-gradient(90deg, #f093fb, #f5576c); }
        .stat-card.inventory::before { background: linear-gradient(90deg, #ff9a9e, #fecfef); }
        .stat-card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .stat-icon { width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px; color: white; }
        .stat-card.revenue .stat-icon { background: linear-gradient(135deg, #11998e, #38ef7d); }
        .stat-card.appointments .stat-icon { background: linear-gradient(135deg, #ff416c, #ff4b2b); }
        .stat-card.employees .stat-icon { background: linear-gradient(135deg, #4facfe, #00f2fe); }
        .stat-card.requests .stat-icon { background: linear-gradient(135deg, #f093fb, #f5576c); }
        .stat-card.inventory .stat-icon { background: linear-gradient(135deg, #ff9a9e, #fecfef); }
        .stat-value { font-size: 2.5rem; font-weight: 800; color: #2c3e50; margin-bottom: 8px; line-height: 1; }
        .stat-label { color: #7f8c8d; font-size: 14px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.8px; margin-bottom: 10px; }
        .stat-change { display: flex; align-items: center; gap: 5px; font-size: 13px; font-weight: 600; }
        .stat-change.positive { color: #27ae60; }
        .stat-change.negative { color: #e74c3c; }
        .stat-change.neutral { color: #7f8c8d; }
        .quick-actions { background: white; padding: 25px; border-radius: 16px; margin-bottom: 30px; box-shadow: 0 8px 25px rgba(0,0,0,0.08); }
        .action-buttons { display: flex; gap: 15px; margin-top: 20px; flex-wrap: wrap; }
        .btn-quick { padding: 12px 24px; border: none; border-radius: 8px; cursor: pointer; font-size: 0.9rem; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; transition: all 0.3s ease; }
        .btn-quick:hover { transform: translateY(-2px); opacity: 0.9; }
        .btn-primary { background: linear-gradient(135deg, #667eea, #764ba2); color: white; }
        .btn-success { background: linear-gradient(135deg, #11998e, #38ef7d); color: white; }
        .btn-warning { background: linear-gradient(135deg, #ff416c, #ff4b2b); color: white; }
        .btn-danger { background: linear-gradient(135deg, #ff9a9e, #fecfef); color: #333; }
        .recent-section { background: white; padding: 25px; border-radius: 16px; box-shadow: 0 8px 25px rgba(0,0,0,0.08); }
        .requests-list { margin-top: 20px; }
        .request-item { display: flex; justify-content: space-between; align-items: center; padding: 15px; border: 1px solid #e2e8f0; border-radius: 8px; margin-bottom: 10px; background: #f8f9fa; }
        .request-info { display: flex; gap: 15px; align-items: center; }
        .request-date { color: #7f8c8d; font-size: 0.9rem; }
        .request-shift { background: #667eea; color: white; padding: 2px 8px; border-radius: 12px; font-size: 0.8rem; }
        .status-badge { padding: 4px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-approved { background: #d4edda; color: #155724; }
        .status-rejected { background: #f8d7da; color: #721c24; }
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 8px; font-weight: 500; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
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
                <h2>📊 Báo Cáo Vận Hành</h2>
                <p>Dashboard hiện đại với thống kê chi tiết về hoạt động vận hành phòng khám</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    ❌ ${error}
                </div>
            </c:if>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card employees">
                    <div class="stat-card-header">
                        <div>
                            <div class="stat-label">TỔNG NHÂN VIÊN</div>
                            <div class="stat-value">${totalEmployees}</div>
                        </div>
                        <div class="stat-icon">👥</div>
                    </div>
                    <div class="stat-change positive"><span>↗</span> +5%</div>
                </div>

                <div class="stat-card appointments">
                    <div class="stat-card-header">
                        <div>
                            <div class="stat-label">LỊCH HẸN TUẦN</div>
                            <div class="stat-value">${totalAppointments}</div>
                        </div>
                        <div class="stat-icon">📅</div>
                    </div>
                    <div class="stat-change positive"><span>↗</span> +12%</div>
                </div>

                <div class="stat-card revenue">
                    <div class="stat-card-header">
                        <div>
                            <div class="stat-label">DOANH THU TUẦN</div>
                            <div class="stat-value">₫<fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/></div>
                        </div>
                        <div class="stat-icon">💰</div>
                    </div>
                    <div class="stat-change positive"><span>↗</span> +8%</div>
                </div>

                <div class="stat-card inventory">
                    <div class="stat-card-header">
                        <div>
                            <div class="stat-label">VẬT TƯ TỒN KHO THẤP</div>
                            <div class="stat-value">${lowStockItems}</div>
                        </div>
                        <div class="stat-icon">⚠️</div>
                    </div>
                    <div class="stat-change negative"><span>↘</span> -2%</div>
                </div>
            </div>

            <!-- Quick Actions -->
            <!-- <div class="quick-actions">
                <h3>⚡ Thao Tác Nhanh</h3>
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/manager/schedule-requests?action=pending" 
                       class="btn-quick btn-warning">📋 Duyệt Yêu Cầu</a>
                    
                    <a href="${pageContext.request.contextPath}/manager/schedules" 
                       class="btn-quick btn-primary">📅 Quản Lý Lịch</a>
                    <a href="${pageContext.request.contextPath}/manager/employees" 
                       class="btn-quick btn-success">👥 Nhân Viên</a>
                </div>
            </div> -->

            <!-- Recent Schedule Requests -->
            <!-- <c:if test="${not empty recentScheduleRequestsList}">
                <div class="recent-section">
                    <h3>📋 Yêu Cầu Nghỉ Gần Đây</h3>
                    <div class="requests-list">
                        <c:forEach var="request" items="${recentScheduleRequestsList}">
                            <div class="request-item">
                                <div class="request-info">
                                    <strong>${request.employeeName}</strong>
                                    <span class="request-date">
                                        <fmt:formatDate value="${request.requestDate}" pattern="dd/MM/yyyy"/>
                                    </span>
                                    <span class="request-shift">${request.shift}</span>
                                </div>
                                <div class="request-status">
                                    <span class="status-badge 
                                        <c:choose>
                                            <c:when test="${request.status eq 'PENDING'}">status-pending</c:when>
                                            <c:when test="${request.status eq 'APPROVED'}">status-approved</c:when>
                                            <c:when test="${request.status eq 'REJECTED'}">status-rejected</c:when>
                                        </c:choose>">
                                        <c:choose>
                                            <c:when test="${request.status eq 'PENDING'}">⏳ Chờ duyệt</c:when>
                                            <c:when test="${request.status eq 'APPROVED'}">✅ Đã duyệt</c:when>
                                            <c:when test="${request.status eq 'REJECTED'}">❌ Từ chối</c:when>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if> -->
        </div>
    </main>
</div>
</body>
</html>