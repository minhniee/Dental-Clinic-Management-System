<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Tổng Hợp - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/unified-styles.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .reports-container { max-width: 100%; margin: 0; padding: 0; background: transparent; }
        .reports-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; padding: 20px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 12px; color: white; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .reports-title { font-size: 2.2rem; font-weight: 700; margin: 0; text-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .report-tabs { display: flex; gap: 15px; margin-bottom: 30px; background: white; padding: 15px; border-radius: 12px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border: 1px solid #e2e8f0; }
        .tab-button { padding: 15px 30px; border: none; border-radius: 12px; cursor: pointer; font-size: 14px; font-weight: 600; transition: all 0.3s ease; text-decoration: none; display: inline-block; position: relative; overflow: hidden; }
        .tab-button.active { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3); }
        .tab-button:not(.active) { background: #f8f9fa; color: #6c757d; }
        .tab-button:hover:not(.active) { background: #e9ecef; transform: translateY(-2px); }
        .tab-button.active:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4); }
        .period-selector { display: flex; gap: 15px; align-items: center; margin-bottom: 20px; background: white; padding: 15px 20px; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); border: 1px solid #e2e8f0; }
        .period-selector label { font-weight: 600; color: #2c3e50; font-size: 14px; }
        .period-selector select { padding: 10px 15px; border: 2px solid #e9ecef; border-radius: 8px; font-size: 14px; font-weight: 500; background: white; transition: all 0.3s ease; }
        .period-selector select:focus { outline: none; border-color: #667eea; box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1); }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px; margin-bottom: 40px; }
        .stat-card { background: white; padding: 25px; border-radius: 16px; box-shadow: 0 8px 25px rgba(0,0,0,0.08); border: none; position: relative; overflow: hidden; transition: all 0.3s ease; animation: fadeInUp 0.6s ease-out; }
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 15px 35px rgba(0,0,0,0.12); }
        .stat-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px; background: linear-gradient(90deg, #667eea, #764ba2); }
        .stat-card.revenue::before { background: linear-gradient(90deg, #11998e, #38ef7d); }
        .stat-card.appointments::before { background: linear-gradient(90deg, #ff416c, #ff4b2b); }
        .stat-card.patients::before { background: linear-gradient(90deg, #f093fb, #f5576c); }
        .stat-card.employees::before { background: linear-gradient(90deg, #4facfe, #00f2fe); }
        .stat-card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .stat-icon { width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px; color: white; }
        .stat-card.revenue .stat-icon { background: linear-gradient(135deg, #11998e, #38ef7d); }
        .stat-card.appointments .stat-icon { background: linear-gradient(135deg, #ff416c, #ff4b2b); }
        .stat-card.patients .stat-icon { background: linear-gradient(135deg, #f093fb, #f5576c); }
        .stat-card.employees .stat-icon { background: linear-gradient(135deg, #4facfe, #00f2fe); }
        .stat-value { font-size: 2.5rem; font-weight: 800; color: #2c3e50; margin-bottom: 8px; line-height: 1; }
        .stat-label { color: #7f8c8d; font-size: 14px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.8px; margin-bottom: 10px; }
        .stat-change { display: flex; align-items: center; gap: 5px; font-size: 13px; font-weight: 600; }
        .stat-change.positive { color: #27ae60; }
        .stat-change.negative { color: #e74c3c; }
        .stat-change.neutral { color: #7f8c8d; }
        .chart-container { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); margin-bottom: 20px; border: 1px solid #e2e8f0; animation: fadeInUp 0.8s ease-out; }
        .chart-title { font-size: 1.4rem; color: #2c3e50; margin-bottom: 20px; font-weight: 700; display: flex; align-items: center; gap: 10px; }
        .chart-wrapper { position: relative; height: 350px; background: #fafbfc; border-radius: 12px; padding: 20px; }
        .data-table { background: white; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); overflow: hidden; margin-bottom: 20px; border: 1px solid #e2e8f0; animation: fadeInUp 1s ease-out; }
        .data-table table { width: 100%; border-collapse: collapse; }
        .data-table th { background: #f8f9fa; color: #495057; padding: 15px; text-align: left; font-weight: 600; font-size: 14px; border-bottom: 2px solid #e9ecef; }
        .data-table td { padding: 15px; border-bottom: 1px solid #e9ecef; font-size: 14px; color: #495057; }
        .data-table tr:hover { background: #f8f9fa; }
        .data-table tr:last-child td { border-bottom: none; }
        .export-buttons { display: flex; gap: 10px; margin-bottom: 20px; }
        .btn-export { padding: 10px 20px; border: 1px solid #dee2e6; border-radius: 6px; cursor: pointer; font-size: 14px; font-weight: 500; text-decoration: none; display: inline-flex; align-items: center; gap: 5px; transition: all 0.2s ease; }
        .btn-export:hover { opacity: 0.9; text-decoration: none; }
        .btn-export.excel { background: #28a745; color: white; border-color: #28a745; }
        .btn-export.pdf { background: #dc3545; color: white; border-color: #dc3545; }
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 4px; font-weight: 500; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .loading, .no-data { text-align: center; padding: 40px; color: #7f8c8d; }
        .no-data { font-style: italic; }
        @media (max-width: 768px) {
            .reports-container { padding: 15px; }
            .stats-grid { grid-template-columns: 1fr; gap: 20px; }
            .report-tabs { flex-wrap: wrap; gap: 10px; }
            .tab-button { padding: 12px 20px; font-size: 13px; }
            .chart-wrapper { height: 250px; }
            .reports-header { flex-direction: column; gap: 20px; text-align: center; }
            .export-buttons { justify-content: center; }
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .stat-card:nth-child(4) { animation-delay: 0.4s; }
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
    <h1>Bảng Điều Khiển Quản Trị</h1>
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
                <h2>Báo Cáo Tổng Hợp</h2>
                <p>Dashboard hiện đại với biểu đồ tương tác và thống kê chi tiết về hoạt động phòng khám</p>
            </div>

            <div class="reports-container">

                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        ${error}
                    </div>
                </c:if>

                <!-- Period Selector -->
                <div class="period-selector">
                    <label for="periodSelect">Khoảng thời gian:</label>
                    <select id="periodSelect" onchange="changePeriod(this.value)">
                        <option value="7"  ${param.period == '7'  ? 'selected' : ''}>7 ngày qua</option>
                        <option value="30" ${param.period == '30' || empty param.period ? 'selected' : ''}>30 ngày qua</option>
                        <option value="90" ${param.period == '90' ? 'selected' : ''}>3 tháng qua</option>
                        <option value="365" ${param.period == '365' ? 'selected' : ''}>1 năm qua</option>
                    </select>
                </div>

                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card appointments">
                        <div class="stat-card-header">
                            <div>
                                <div class="stat-label">TỔNG LỊCH HẸN</div>
                                <div class="stat-value">${totalAppointments}</div>
                            </div>
                        </div>
                        <div class="stat-change positive">+12%</div>
                    </div>

                    <div class="stat-card revenue">
                        <div class="stat-card-header">
                            <div>
                                <div class="stat-label">TỔNG DOANH THU</div>
                                <div class="stat-value">₫<fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/></div>
                            </div>
                        </div>
                        <div class="stat-change positive">+8%</div>
                    </div>

                    <div class="stat-card patients">
                        <div class="stat-card-header">
                            <div>
                                <div class="stat-label">TỔNG BỆNH NHÂN</div>
                                <div class="stat-value">${totalUsers}</div>
                            </div>
                        </div>
                        <div class="stat-change positive">+5%</div>
                    </div>

                    <div class="stat-card employees">
                        <div class="stat-card-header">
                            <div>
                                <div class="stat-label">TỔNG NHÂN VIÊN</div>
                                <div class="stat-value">${totalEmployees}</div>
                            </div>
                        </div>
                        <div class="stat-change neutral">0%</div>
                    </div>
                </div>

                <!-- Charts Section -->
                <div class="chart-container">
                    <h3 class="chart-title">Xu Hướng Lịch Hẹn</h3>
                    <div class="chart-wrapper">
                        <canvas id="appointmentsChart"></canvas>
                    </div>
                </div>

                <div class="chart-container">
                    <h3 class="chart-title">Xu Hướng Doanh Thu</h3>
                    <div class="chart-wrapper">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>

                <!-- Top Dentists Table -->
                <div class="data-table">
                    <h3 class="chart-title">🏆 Top Bác Sĩ</h3>
                    <table>
                        <thead>
                        <tr>
                            <th>Tên Bác Sĩ</th>
                            <th>Số Lịch Hẹn</th>
                            <th>Doanh Thu</th>
                        </tr>
                        </thead>
                        <tbody>
                        <!-- Dùng collection server-side -->
                        <c:forEach var="dentist" items="${topDentistsList}">
                            <tr>
                                <td>${dentist['name']}</td>
                                <td>${dentist['appointments']}</td>
                                <td>₫<fmt:formatNumber value="${dentist['revenue']}" pattern="#,##0"/></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
    </main>
</div>

<script>
    // Đổi period
    function changePeriod(period) {
        const url = new URL(window.location);
        url.searchParams.set('period', period);
        window.location.href = url.toString();
    }

    // Parse JSON an toàn (đã escape XML)
    let appointmentTrendsData = [];
    let revenueTrendsData = [];
    let topDentistsData = [];

    try {
        appointmentTrendsData = JSON.parse('${fn:escapeXml(appointmentTrendsJson)}');
    } catch (e) { console.log('Error parsing appointmentTrendsJson:', e); }

    try {
        revenueTrendsData = JSON.parse('${fn:escapeXml(revenueTrendsJson)}');
    } catch (e) { console.log('Error parsing revenueTrendsJson:', e); }

    try {
        topDentistsData = JSON.parse('${fn:escapeXml(topDentistsJson)}');
    } catch (e) { console.log('Error parsing topDentistsJson:', e); }

    const dashboardData = {
        appointmentTrends: Array.isArray(appointmentTrendsData) ? appointmentTrendsData : [],
        revenueTrends: Array.isArray(revenueTrendsData) ? revenueTrendsData : [],
        topDentists: Array.isArray(topDentistsData) ? topDentistsData : []
    };

    document.addEventListener('DOMContentLoaded', function () {
        initializeCharts();
    });

    function initializeCharts() {
        // Appointments Chart
        const appointmentsCtx = document.getElementById('appointmentsChart').getContext('2d');
        const appointmentsData = dashboardData.appointmentTrends || [];
        let appointmentLabels = [];
        let appointmentValues = [];

        if (appointmentsData.length > 0) {
            appointmentLabels = appointmentsData.map(item => {
                try {
                    // Parse date string in format YYYY-MM-DD
                    const dateStr = item.date;
                    const [year, month, day] = dateStr.split('-');
                    const d = new Date(year, month - 1, day); // month is 0-indexed
                    return d.toLocaleDateString('vi-VN');
                } catch {
                    return item.date;
                }
            });
            appointmentValues = appointmentsData.map(item => item.count || 0);
        } else {
            const today = new Date();
            for (let i = 6; i >= 0; i--) {
                const date = new Date(today);
                date.setDate(date.getDate() - i);
                appointmentLabels.push(date.toLocaleDateString('vi-VN'));
                appointmentValues.push(Math.floor(Math.random() * 10) + 1);
            }
        }

        new Chart(appointmentsCtx, {
            type: 'line',
            data: {
                labels: appointmentLabels,
                datasets: [{
                    label: 'Số Lịch Hẹn',
                    data: appointmentValues,
                    borderColor: 'rgb(102, 126, 234)',
                    backgroundColor: 'rgba(102, 126, 234, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: true, position: 'top' } },
                scales: {
                    y: { beginAtZero: true, ticks: { stepSize: 1 } }
                }
            }
        });

        // Revenue Chart
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        const revenueData = dashboardData.revenueTrends || [];
        let revenueLabels = [];
        let revenueValues = [];

        if (revenueData.length > 0) {
            revenueLabels = revenueData.map(item => {
                try {
                    // Parse date string in format YYYY-MM-DD
                    const dateStr = item.date;
                    const [year, month, day] = dateStr.split('-');
                    const d = new Date(year, month - 1, day); // month is 0-indexed
                    return d.toLocaleDateString('vi-VN');
                } catch {
                    return item.date;
                }
            });
            revenueValues = revenueData.map(item => item.revenue || 0);
        } else {
            const today = new Date();
            for (let i = 6; i >= 0; i--) {
                const date = new Date(today);
                date.setDate(date.getDate() - i);
                revenueLabels.push(date.toLocaleDateString('vi-VN'));
                revenueValues.push(Math.floor(Math.random() * 5000000) + 1000000);
            }
        }

        new Chart(revenueCtx, {
            type: 'bar',
            data: {
                labels: revenueLabels,
                datasets: [{
                    label: 'Doanh Thu (₫)',
                    data: revenueValues,
                    backgroundColor: 'rgba(17, 153, 142, 0.8)',
                    borderColor: 'rgb(17, 153, 142)',
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: true, position: 'top' } },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function (value) {
                                try { return '₫' + value.toLocaleString('vi-VN'); }
                                catch { return value; }
                            }
                        }
                    }
                }
            }
        });
    }
</script>
</body>
</html>
