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

<!-- Thống kê lịch hẹn theo trạng thái -->
<div class="chart-container">
    <h3 class="chart-title">📊 Phân Bố Lịch Hẹn Theo Trạng Thái</h3>
    <div class="chart-wrapper">
        <canvas id="statusChart"></canvas>
    </div>
</div>

<!-- Lịch hẹn theo ngày trong tuần -->
<div class="chart-container">
    <h3 class="chart-title">📅 Lịch Hẹn Theo Ngày Trong Tuần</h3>
    <div class="chart-wrapper">
        <canvas id="dayChart"></canvas>
    </div>
</div>

<!-- Top bác sĩ theo số lịch hẹn -->
<div class="data-table">
    <h3 class="chart-title">👨‍⚕️ Bác Sĩ Có Nhiều Lịch Hẹn Nhất</h3>
    <table>
        <thead>
            <tr>
                <th>Bác Sĩ</th>
                <th>Số Lịch Hẹn</th>
                <th>Tỷ Lệ</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="dentist" items="${reportData.appointmentsByDentist}" varStatus="status">
                <tr>
                    <td>
                        <strong>${dentist.name}</strong>
                    </td>
                    <td>
                        <span class="stat-value">${dentist.count}</span>
                    </td>
                    <td>
                        <div style="background: #ecf0f1; height: 20px; border-radius: 10px; position: relative;">
                            <div style="background: #3498db; height: 100%; border-radius: 10px; width: ${(dentist.count / fn:length(reportData.appointmentsByDentist) * 100)}%;"></div>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- Chi tiết lịch hẹn -->
<div class="data-table">
    <h3 class="chart-title">📋 Chi Tiết Lịch Hẹn</h3>
    <table>
        <thead>
            <tr>
                <th>Trạng Thái</th>
                <th>Số Lượng</th>
                <th>Tỷ Lệ</th>
                <th>Xu Hướng</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="status" items="${reportData.appointmentsByStatus}">
                <tr>
                    <td>
                        <c:choose>
                            <c:when test="${status.key == 'Scheduled'}">
                                <span style="color: #3498db;">📅 Đã Đặt</span>
                            </c:when>
                            <c:when test="${status.key == 'Confirmed'}">
                                <span style="color: #f39c12;">✅ Đã Xác Nhận</span>
                            </c:when>
                            <c:when test="${status.key == 'Completed'}">
                                <span style="color: #27ae60;">✅ Hoàn Thành</span>
                            </c:when>
                            <c:when test="${status.key == 'Cancelled'}">
                                <span style="color: #e74c3c;">❌ Đã Hủy</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #7f8c8d;">${status.key}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <strong>${status.value}</strong>
                    </td>
                    <td>
                        <c:set var="total" value="0" />
                        <c:forEach var="s" items="${reportData.appointmentsByStatus}">
                            <c:set var="total" value="${total + s.value}" />
                        </c:forEach>
                        <fmt:formatNumber value="${(status.value / total) * 100}" maxFractionDigits="1" />%
                    </td>
                    <td>
                        <span class="trend-up">📈 +5%</span>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Biểu đồ trạng thái
    const statusCtx = document.getElementById('statusChart').getContext('2d');
    const statusData = {
        <c:forEach var="status" items="${reportData.appointmentsByStatus}" varStatus="statusLoop">
        '${status.key}': ${status.value}<c:if test="${!statusLoop.last}">,</c:if>
        </c:forEach>
    };
    
    new Chart(statusCtx, {
        type: 'doughnut',
        data: {
            labels: Object.keys(statusData),
            datasets: [{
                data: Object.values(statusData),
                backgroundColor: [
                    '#3498db', // Scheduled
                    '#f39c12', // Confirmed
                    '#27ae60', // Completed
                    '#e74c3c'  // Cancelled
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
    
    // Biểu đồ ngày trong tuần
    const dayCtx = document.getElementById('dayChart').getContext('2d');
    const dayData = [
        <c:forEach var="day" items="${reportData.appointmentsByDay}" varStatus="status">
        {
            day: '${day.day}',
            count: ${day.count}
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    
    new Chart(dayCtx, {
        type: 'bar',
        data: {
            labels: dayData.map(item => item.day),
            datasets: [{
                label: 'Số lịch hẹn',
                data: dayData.map(item => item.count),
                backgroundColor: '#3498db',
                borderColor: '#2980b9',
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
                    beginAtZero: true
                }
            }
        }
    });
});
</script>
