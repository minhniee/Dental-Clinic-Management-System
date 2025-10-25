<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="period-selector">
    <label for="period">Khoảng thời gian:</label>
    <select id="period" onchange="changePeriod(this.value)">
        <option value="week" ${reportData.period == 'week' ? 'selected' : ''}>7 ngày qua</option>
        <option value="month" ${reportData.period == 'month' ? 'selected' : ''}>30 ngày qua</option>
        <option value="quarter" ${reportData.period == 'quarter' ? 'selected' : ''}>3 tháng qua</option>
        <option value="year" ${reportData.period == 'year' ? 'selected' : ''}>1 năm qua</option>
    </select>
</div>

<!-- Biểu đồ doanh thu theo tháng -->
<div class="chart-container">
    <h3 class="chart-title">💰 Xu Hướng Doanh Thu Theo Tháng</h3>
    <div class="chart-wrapper">
        <canvas id="revenueTrendChart"></canvas>
    </div>
</div>

<!-- Doanh thu theo dịch vụ -->
<div class="chart-container">
    <h3 class="chart-title">🦷 Doanh Thu Theo Dịch Vụ</h3>
    <div class="chart-wrapper">
        <canvas id="serviceRevenueChart"></canvas>
    </div>
</div>

<!-- Top dịch vụ -->
<div class="data-table">
    <h3 class="chart-title">🏆 Dịch Vụ Có Doanh Thu Cao Nhất</h3>
    <table>
        <thead>
            <tr>
                <th>Dịch Vụ</th>
                <th>Doanh Thu</th>
                <th>Tỷ Lệ</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="service" items="${reportData.revenueByService}" varStatus="status">
                <tr>
                    <td>
                        <strong>${service.service}</strong>
                    </td>
                    <td>
                        <fmt:formatNumber value="${service.revenue}" type="currency" currencySymbol="₫" />
                    </td>
                    <td>
                        <c:set var="totalRevenue" value="0" />
                        <c:forEach var="s" items="${reportData.revenueByService}">
                            <c:set var="totalRevenue" value="${totalRevenue + s.revenue}" />
                        </c:forEach>
                        <fmt:formatNumber value="${(service.revenue / totalRevenue) * 100}" maxFractionDigits="1" />%
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- Doanh thu theo bác sĩ -->
<div class="data-table">
    <h3 class="chart-title">👨‍⚕️ Doanh Thu Theo Bác Sĩ</h3>
    <table>
        <thead>
            <tr>
                <th>Bác Sĩ</th>
                <th>Doanh Thu</th>
                <th>Số Lịch Hẹn</th>
                <th>Trung Bình/Lịch</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="dentist" items="${reportData.revenueByDentist}" varStatus="status">
                <tr>
                    <td>
                        <strong>${dentist.name}</strong>
                    </td>
                    <td>
                        <fmt:formatNumber value="${dentist.revenue}" type="currency" currencySymbol="₫" />
                    </td>
                    <td>
                        ${dentist.appointments}
                    </td>
                    <td>
                        <fmt:formatNumber value="${dentist.revenue / dentist.appointments}" type="currency" currencySymbol="₫" />
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- Tóm tắt doanh thu -->
<div class="stats-grid">
    <div class="stat-card revenue">
        <div class="stat-value">
            <fmt:formatNumber value="${reportData.totalRevenue}" type="currency" currencySymbol="₫" />
        </div>
        <div class="stat-label">💰 Tổng Doanh Thu</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-value">
            <fmt:formatNumber value="${reportData.averageRevenue}" type="currency" currencySymbol="₫" />
        </div>
        <div class="stat-label">📊 Trung Bình/Ngày</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-value">${reportData.totalInvoices}</div>
        <div class="stat-label">📄 Tổng Hóa Đơn</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-value">
            <fmt:formatNumber value="${reportData.growthRate}" maxFractionDigits="1" />%
        </div>
        <div class="stat-label">📈 Tăng Trưởng</div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Biểu đồ xu hướng doanh thu
    const revenueTrendCtx = document.getElementById('revenueTrendChart').getContext('2d');
    const revenueTrendData = [
        <c:forEach var="revenue" items="${reportData.revenueByMonth}" varStatus="status">
        {
            month: '${revenue.month}/${revenue.year}',
            amount: ${revenue.revenue}
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    
    new Chart(revenueTrendCtx, {
        type: 'line',
        data: {
            labels: revenueTrendData.map(item => item.month),
            datasets: [{
                label: 'Doanh thu (₫)',
                data: revenueTrendData.map(item => item.amount),
                borderColor: '#27ae60',
                backgroundColor: 'rgba(39, 174, 96, 0.1)',
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
    
    // Biểu đồ doanh thu theo dịch vụ
    const serviceRevenueCtx = document.getElementById('serviceRevenueChart').getContext('2d');
    const serviceRevenueData = [
        <c:forEach var="service" items="${reportData.revenueByService}" varStatus="status">
        {
            service: '${service.service}',
            revenue: ${service.revenue}
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    
    new Chart(serviceRevenueCtx, {
        type: 'pie',
        data: {
            labels: serviceRevenueData.map(item => item.service),
            datasets: [{
                data: serviceRevenueData.map(item => item.revenue),
                backgroundColor: [
                    '#3498db',
                    '#e74c3c',
                    '#f39c12',
                    '#27ae60',
                    '#9b59b6',
                    '#1abc9c'
                ],
                borderWidth: 2,
                borderColor: '#fff'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    });
});
</script>
