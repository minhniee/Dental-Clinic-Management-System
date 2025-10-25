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

<!-- Hiệu suất bác sĩ -->
<div class="chart-container">
    <h3 class="chart-title">👨‍⚕️ Hiệu Suất Bác Sĩ</h3>
    <div class="chart-wrapper">
        <canvas id="performanceChart"></canvas>
    </div>
</div>

<!-- Bảng xếp hạng bác sĩ -->
<div class="data-table">
    <h3 class="chart-title">🏆 Bảng Xếp Hạng Bác Sĩ</h3>
    <table>
        <thead>
            <tr>
                <th>Hạng</th>
                <th>Bác Sĩ</th>
                <th>Tổng Lịch Hẹn</th>
                <th>Hoàn Thành</th>
                <th>Tỷ Lệ Hoàn Thành</th>
                <th>Doanh Thu</th>
                <th>Đánh Giá</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="dentist" items="${reportData.dentistPerformance}" varStatus="status">
                <tr>
                    <td>
                        <c:choose>
                            <c:when test="${status.index == 0}">
                                <span style="color: #f39c12;">🥇</span>
                            </c:when>
                            <c:when test="${status.index == 1}">
                                <span style="color: #95a5a6;">🥈</span>
                            </c:when>
                            <c:when test="${status.index == 2}">
                                <span style="color: #cd7f32;">🥉</span>
                            </c:when>
                            <c:otherwise>
                                <strong>${status.index + 1}</strong>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <strong>${dentist.name}</strong>
                    </td>
                    <td>
                        <span class="stat-value">${dentist.total}</span>
                    </td>
                    <td>
                        <span class="stat-value">${dentist.completed}</span>
                    </td>
                    <td>
                        <c:set var="completionRate" value="${(dentist.completed / dentist.total) * 100}" />
                        <c:choose>
                            <c:when test="${completionRate >= 90}">
                                <span class="trend-up">📈 <fmt:formatNumber value="${completionRate}" maxFractionDigits="1" />%</span>
                            </c:when>
                            <c:when test="${completionRate >= 70}">
                                <span class="trend-neutral">📊 <fmt:formatNumber value="${completionRate}" maxFractionDigits="1" />%</span>
                            </c:when>
                            <c:otherwise>
                                <span class="trend-down">📉 <fmt:formatNumber value="${completionRate}" maxFractionDigits="1" />%</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <fmt:formatNumber value="${dentist.revenue}" type="currency" currencySymbol="₫" />
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${completionRate >= 90}">
                                <span style="color: #27ae60;">⭐⭐⭐⭐⭐</span>
                            </c:when>
                            <c:when test="${completionRate >= 80}">
                                <span style="color: #f39c12;">⭐⭐⭐⭐</span>
                            </c:when>
                            <c:when test="${completionRate >= 70}">
                                <span style="color: #e67e22;">⭐⭐⭐</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #e74c3c;">⭐⭐</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- Thống kê hoàn thành lịch hẹn -->
<div class="chart-container">
    <h3 class="chart-title">📊 Tỷ Lệ Hoàn Thành Lịch Hẹn</h3>
    <div class="chart-wrapper">
        <canvas id="completionChart"></canvas>
    </div>
</div>

<!-- Đánh giá hài lòng bệnh nhân -->
<div class="data-table">
    <h3 class="chart-title">😊 Đánh Giá Hài Lòng Bệnh Nhân</h3>
    <table>
        <thead>
            <tr>
                <th>Bác Sĩ</th>
                <th>Điểm Trung Bình</th>
                <th>Số Đánh Giá</th>
                <th>Xu Hướng</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="satisfaction" items="${reportData.patientSatisfaction}" varStatus="status">
                <tr>
                    <td>
                        <strong>${satisfaction.name}</strong>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${satisfaction.rating >= 4.5}">
                                <span style="color: #27ae60; font-size: 1.2em;">⭐⭐⭐⭐⭐</span>
                                <strong>${satisfaction.rating}/5</strong>
                            </c:when>
                            <c:when test="${satisfaction.rating >= 4.0}">
                                <span style="color: #f39c12; font-size: 1.2em;">⭐⭐⭐⭐</span>
                                <strong>${satisfaction.rating}/5</strong>
                            </c:when>
                            <c:when test="${satisfaction.rating >= 3.5}">
                                <span style="color: #e67e22; font-size: 1.2em;">⭐⭐⭐</span>
                                <strong>${satisfaction.rating}/5</strong>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #e74c3c; font-size: 1.2em;">⭐⭐</span>
                                <strong>${satisfaction.rating}/5</strong>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <span class="stat-value">${satisfaction.reviews}</span>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${satisfaction.trend > 0}">
                                <span class="trend-up">📈 +${satisfaction.trend}%</span>
                            </c:when>
                            <c:when test="${satisfaction.trend < 0}">
                                <span class="trend-down">📉 ${satisfaction.trend}%</span>
                            </c:when>
                            <c:otherwise>
                                <span class="trend-neutral">➡️ 0%</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- Tóm tắt hiệu suất -->
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-value">
            <fmt:formatNumber value="${reportData.averageCompletionRate}" maxFractionDigits="1" />%
        </div>
        <div class="stat-label">📊 Tỷ Lệ Hoàn Thành TB</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-value">
            <fmt:formatNumber value="${reportData.averageRating}" maxFractionDigits="1" />
        </div>
        <div class="stat-label">⭐ Đánh Giá TB</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-value">${reportData.totalReviews}</div>
        <div class="stat-label">💬 Tổng Đánh Giá</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-value">
            <fmt:formatNumber value="${reportData.improvementRate}" maxFractionDigits="1" />%
        </div>
        <div class="stat-label">📈 Cải Thiện</div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Biểu đồ hiệu suất bác sĩ
    const performanceCtx = document.getElementById('performanceChart').getContext('2d');
    const performanceData = [
        <c:forEach var="dentist" items="${reportData.dentistPerformance}" varStatus="status">
        {
            name: '${dentist.name}',
            completed: ${dentist.completed},
            total: ${dentist.total},
            revenue: ${dentist.revenue}
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    
    new Chart(performanceCtx, {
        type: 'bar',
        data: {
            labels: performanceData.map(item => item.name),
            datasets: [
                {
                    label: 'Hoàn thành',
                    data: performanceData.map(item => item.completed),
                    backgroundColor: '#27ae60',
                    borderColor: '#229954',
                    borderWidth: 1
                },
                {
                    label: 'Tổng lịch hẹn',
                    data: performanceData.map(item => item.total),
                    backgroundColor: '#3498db',
                    borderColor: '#2980b9',
                    borderWidth: 1
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'top'
                }
            },
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
    
    // Biểu đồ tỷ lệ hoàn thành
    const completionCtx = document.getElementById('completionChart').getContext('2d');
    const completionData = [
        <c:forEach var="completion" items="${reportData.appointmentCompletion}" varStatus="status">
        {
            period: '${completion.period}',
            rate: ${completion.rate}
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    
    new Chart(completionCtx, {
        type: 'line',
        data: {
            labels: completionData.map(item => item.period),
            datasets: [{
                label: 'Tỷ lệ hoàn thành (%)',
                data: completionData.map(item => item.rate),
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
                    beginAtZero: true,
                    max: 100
                }
            }
        }
    });
});
</script>
