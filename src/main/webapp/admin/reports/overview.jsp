<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="period-selector">
    <label for="period">Khoảng thời gian:</label>
    <select id="period" onchange="changePeriod(this.value)">
        <option value="week">7 ngày qua</option>
        <option value="month" selected>30 ngày qua</option>
        <option value="quarter">3 tháng qua</option>
        <option value="year">1 năm qua</option>
    </select>
</div>

<!-- Thống kê tổng quan -->
<div class="stats-grid">
    <div class="stat-card appointments">
        <div class="stat-card-header">
            <div>
                <div class="stat-label">📅 TỔNG LỊCH HẸN</div>
                <div class="stat-value">${reportData.totalAppointments}</div>
            </div>
            <div class="stat-icon">📅</div>
        </div>
        <div class="stat-change positive">
            <span>↗️</span>
            <span>+12%</span>
        </div>
    </div>
    
    <div class="stat-card revenue">
        <div class="stat-card-header">
            <div>
                <div class="stat-label">💰 TỔNG DOANH THU</div>
                <div class="stat-value">
                    <fmt:formatNumber value="${reportData.totalRevenue}" type="currency" currencySymbol="₫" />
                </div>
            </div>
            <div class="stat-icon">💰</div>
        </div>
        <div class="stat-change positive">
            <span>↗️</span>
            <span>+8%</span>
        </div>
    </div>
    
    <div class="stat-card patients">
        <div class="stat-card-header">
            <div>
                <div class="stat-label">👥 TỔNG BỆNH NHÂN</div>
                <div class="stat-value">${reportData.totalPatients}</div>
            </div>
            <div class="stat-icon">👥</div>
        </div>
        <div class="stat-change positive">
            <span>↗️</span>
            <span>+5%</span>
        </div>
    </div>
    
    <div class="stat-card employees">
        <div class="stat-card-header">
            <div>
                <div class="stat-label">👨‍💼 TỔNG NHÂN VIÊN</div>
                <div class="stat-value">${reportData.totalEmployees}</div>
            </div>
            <div class="stat-icon">👨‍💼</div>
        </div>
        <div class="stat-change neutral">
            <span>➡️</span>
            <span>0%</span>
        </div>
    </div>
</div>

<!-- Biểu đồ xu hướng -->
<div class="chart-container">
    <h3 class="chart-title">📈 Xu Hướng Lịch Hẹn (7 ngày gần nhất)</h3>
    <div class="chart-wrapper">
        <canvas id="appointmentsChart"></canvas>
    </div>
</div>

<div class="chart-container">
    <h3 class="chart-title">💰 Xu Hướng Doanh Thu (7 ngày gần nhất)</h3>
    <div class="chart-wrapper">
        <canvas id="revenueChart"></canvas>
    </div>
</div>

<!-- Top bác sĩ -->
<div class="data-table">
    <h3 class="chart-title">🏆 Top Bác Sĩ Năng Suất</h3>
    <table>
        <thead>
            <tr>
                <th>Bác Sĩ</th>
                <th>Số Lịch Hẹn</th>
                <th>Tỷ Lệ Hoàn Thành</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="dentist" items="${reportData.topDentists}" varStatus="status">
                <tr>
                    <td>
                        <strong>${dentist.name}</strong>
                    </td>
                    <td>
                        <span class="stat-value">${dentist.count}</span>
                    </td>
                    <td>
                        <span class="trend-up">📈 95%</span>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Lịch hẹn chart
    const appointmentsCtx = document.getElementById('appointmentsChart').getContext('2d');
    const appointmentsData = [
        <c:forEach var="appointment" items="${reportData.recentAppointments}" varStatus="status">
        {
            date: '${appointment.date}',
            count: ${appointment.count}
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    
    new Chart(appointmentsCtx, {
        type: 'line',
        data: {
            labels: appointmentsData.map(item => item.date),
            datasets: [{
                label: 'Số lịch hẹn',
                data: appointmentsData.map(item => item.count),
                borderColor: '#e74c3c',
                backgroundColor: 'rgba(231, 76, 60, 0.1)',
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
    
    // Doanh thu chart
    const revenueCtx = document.getElementById('revenueChart').getContext('2d');
    const revenueData = [
        <c:forEach var="revenue" items="${reportData.recentRevenue}" varStatus="status">
        {
            date: '${revenue.date}',
            amount: ${revenue.revenue}
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    
    new Chart(revenueCtx, {
        type: 'bar',
        data: {
            labels: revenueData.map(item => item.date),
            datasets: [{
                label: 'Doanh thu (₫)',
                data: revenueData.map(item => item.amount),
                backgroundColor: '#27ae60',
                borderColor: '#229954',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return new Intl.NumberFormat('vi-VN', {
                                style: 'currency',
                                currency: 'VND'
                            }).format(value);
                        }
                    }
                }
            }
        }
    });
});
</script>
