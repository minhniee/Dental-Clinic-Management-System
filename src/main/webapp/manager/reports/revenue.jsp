<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Doanh Thu - Manager - Hệ Thống Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .reports-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 1.5rem;
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding: 1.5rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 1rem;
            color: white;
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }
        
        .page-title {
            font-size: 2.5rem;
            font-weight: 800;
            margin: 0;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .action-buttons {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
        }
        
        .btn-primary {
            background: rgba(255,255,255,0.2);
            color: white;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .btn-primary:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .filter-section {
            background: white;
            padding: 2rem;
            border-radius: 1rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
        }
        
        .filter-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            align-items: end;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-label {
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #4a5568;
            font-size: 0.9rem;
        }
        
        .form-control {
            padding: 0.875rem;
            border: 2px solid #e2e8f0;
            border-radius: 0.75rem;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .stat-card {
            background: white;
            padding: 2rem;
            border-radius: 1rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
            transition: all 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }
        
        .stat-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
        }
        
        .stat-title {
            font-size: 1rem;
            font-weight: 600;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .stat-icon {
            font-size: 2rem;
            opacity: 0.7;
        }
        
        .stat-value {
            font-size: 2.5rem;
            font-weight: 800;
            color: #1f2937;
            margin-bottom: 0.5rem;
        }
        
        .stat-change {
            font-size: 0.9rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }
        
        .stat-change.positive {
            color: #059669;
        }
        
        .stat-change.negative {
            color: #dc2626;
        }
        
        .chart-container {
            background: white;
            padding: 2rem;
            border-radius: 1rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
        }
        
        .chart-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .chart-wrapper {
            position: relative;
            height: 400px;
        }
        
        .table-container {
            background: white;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
        }
        
        .table-header {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            padding: 1.5rem 2rem;
            border-bottom: 2px solid #e2e8f0;
        }
        
        .table-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1f2937;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .table th {
            background: #f8fafc;
            padding: 1.25rem 1rem;
            text-align: left;
            font-weight: 700;
            color: #374151;
            border-bottom: 2px solid #e2e8f0;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .table td {
            padding: 1rem;
            border-bottom: 1px solid #e2e8f0;
            font-size: 0.95rem;
        }
        
        .table tbody tr:hover {
            background: #f8fafc;
            transition: all 0.2s ease;
        }
        
        .alert {
            padding: 1.5rem;
            border-radius: 1rem;
            margin-bottom: 2rem;
            font-weight: 500;
        }
        
        .alert-error {
            background: linear-gradient(135deg, #fef2f2, #fee2e2);
            color: #dc2626;
            border: 2px solid #fecaca;
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #6b7280;
        }
        
        .empty-state h3 {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: #374151;
        }
        
        .empty-state p {
            font-size: 1rem;
            margin-bottom: 0;
        }
        
        .revenue-source {
            font-weight: 600;
            color: #1f2937;
        }
        
        .revenue-amount {
            font-weight: 700;
            color: #059669;
            font-size: 1.1rem;
        }
        
        .revenue-percentage {
            font-size: 0.9rem;
            color: #6b7280;
            font-weight: 500;
        }
        
        .progress-bar {
            width: 100%;
            height: 8px;
            background: #e5e7eb;
            border-radius: 4px;
            overflow: hidden;
            margin-top: 0.5rem;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea, #764ba2);
            border-radius: 4px;
            transition: width 0.3s ease;
        }
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
        <h1>💰 Báo Cáo Doanh Thu</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="reports-container">
                <div class="page-header">
                    <h2 class="page-title">💰 Báo Cáo Doanh Thu</h2>
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/manager/reports?type=appointments" class="btn btn-primary">
                            📅 Báo Cáo Lịch Hẹn
                        </a>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        ❌ ${error}
                    </div>
                </c:if>

                <!-- Filter Section -->
                <div class="filter-section">
                    <h3 class="filter-title">🔍 Bộ Lọc</h3>
                    <form method="get" action="${pageContext.request.contextPath}/manager/reports">
                        <input type="hidden" name="type" value="revenue">
                        <div class="filter-row">
                            <div class="form-group">
                                <label class="form-label">Từ ngày:</label>
                                <input type="date" name="dateFrom" class="form-control" value="${dateFrom}">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Đến ngày:</label>
                                <input type="date" name="dateTo" class="form-control" value="${dateTo}">
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn btn-primary" style="background: #667eea; color: white;">
                                    🔍 Áp Dụng
                                </button>
                                <a href="${pageContext.request.contextPath}/manager/reports?type=revenue" class="btn btn-primary" style="background: #6b7280; color: white;">
                                    🔄 Xóa Lọc
                                </a>
                            </div>
                        </div>
                    </form>
                </div>

                <c:if test="${not empty revenueData}">
                    <!-- Revenue Statistics -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-header">
                                <span class="stat-title">Tổng Doanh Thu</span>
                                <span class="stat-icon">💰</span>
                            </div>
                            <div class="stat-value">
                                <fmt:formatNumber value="${revenueData.totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                            </div>
                            <div class="stat-change positive">
                                <span>✅</span>
                                <span>Từ Hóa Đơn Đã Thanh Toán</span>
                            </div>
                        </div>
                        
                        <div class="stat-card">
                            <div class="stat-header">
                                <span class="stat-title">Số Hóa Đơn</span>
                                <span class="stat-icon">🧾</span>
                            </div>
                            <div class="stat-value">
                                ${not empty revenueData.invoiceList ? revenueData.invoiceList.size() : 0}
                            </div>
                            <div class="stat-change positive">
                                <span>📊</span>
                                <span>Hóa Đơn Đã Thanh Toán</span>
                            </div>
                        </div>
                    </div>

                    <!-- Invoice List Table -->
                    <c:if test="${not empty revenueData.invoiceList}">
                        <div class="table-container" style="margin-bottom: 2rem;">
                            <div class="table-header">
                                <h3 class="table-title">🧾 Danh Sách Hóa Đơn Đã Thanh Toán</h3>
                            </div>
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Mã HĐ</th>
                                        <th>Ngày Tạo</th>
                                        <th>Bệnh Nhân</th>
                                        <th>Bác Sĩ</th>
                                        <th>Số Tiền</th>
                                        <th>Trạng Thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="invoice" items="${revenueData.invoiceList}">
                                        <tr>
                                            <td>
                                                <div class="revenue-source">#${invoice.invoiceId}</div>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td>${invoice.patientName}</td>
                                            <td>${invoice.doctorName}</td>
                                            <td>
                                                <div class="revenue-amount">
                                                    <fmt:formatNumber value="${invoice.netAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                </div>
                                            </td>
                                            <td>
                                                <span style="color: #059669; font-weight: 600;">✅ ${invoice.status}</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>

                    <!-- Revenue by Day Chart -->
                    <c:if test="${not empty revenueData.revenueByDay}">
                        <div class="chart-container">
                            <h3 class="chart-title">📈 Doanh Thu Theo Ngày</h3>
                            <div class="chart-wrapper">
                                <canvas id="revenueByDayChart"></canvas>
                            </div>
                        </div>
                    </c:if>

                    <!-- Revenue by Service Table -->
                    <c:if test="${not empty revenueData.revenueByService}">
                        <div class="table-container" style="margin-bottom: 2rem;">
                            <div class="table-header">
                                <h3 class="table-title">🦷 Doanh Thu Theo Dịch Vụ (Từ Hóa Đơn)</h3>
                            </div>
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Tên Dịch Vụ</th>
                                        <th>Doanh Thu</th>
                                        <th>Biểu Đồ</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:set var="totalServiceRevenue" value="0"/>
                                    <c:forEach var="service" items="${revenueData.revenueByService}">
                                        <c:set var="totalServiceRevenue" value="${totalServiceRevenue + service.revenue}"/>
                                    </c:forEach>
                                    
                                    <c:forEach var="service" items="${revenueData.revenueByService}">
                                        <c:set var="percentage" value="${totalServiceRevenue > 0 ? (service.revenue / totalServiceRevenue * 100) : 0}"/>
                                        <tr>
                                            <td>
                                                <div class="revenue-source">${service.serviceName}</div>
                                            </td>
                                            <td>
                                                <div class="revenue-amount">
                                                    <fmt:formatNumber value="${service.revenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="revenue-percentage">
                                                    <fmt:formatNumber value="${percentage}" maxFractionDigits="1"/>%
                                                </div>
                                                <div class="progress-bar">
                                                    <div class="progress-fill" style="width: ${percentage}%"></div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>

                    <!-- Revenue by Doctor Table -->
                    <c:if test="${not empty revenueData.revenueByDoctor}">
                        <div class="table-container">
                            <div class="table-header">
                                <h3 class="table-title">👨‍⚕️ Doanh Thu Theo Bác Sĩ (Từ Hóa Đơn)</h3>
                            </div>
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Tên Bác Sĩ</th>
                                        <th>Doanh Thu</th>
                                        <th>Biểu Đồ</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:set var="totalDoctorRevenue" value="0"/>
                                    <c:forEach var="doctor" items="${revenueData.revenueByDoctor}">
                                        <c:set var="totalDoctorRevenue" value="${totalDoctorRevenue + doctor.revenue}"/>
                                    </c:forEach>
                                    
                                    <c:forEach var="doctor" items="${revenueData.revenueByDoctor}">
                                        <c:set var="percentage" value="${totalDoctorRevenue > 0 ? (doctor.revenue / totalDoctorRevenue * 100) : 0}"/>
                                        <tr>
                                            <td>
                                                <div class="revenue-source">${doctor.doctorName}</div>
                                            </td>
                                            <td>
                                                <div class="revenue-amount">
                                                    <fmt:formatNumber value="${doctor.revenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="revenue-percentage">
                                                    <fmt:formatNumber value="${percentage}" maxFractionDigits="1"/>%
                                                </div>
                                                <div class="progress-bar">
                                                    <div class="progress-fill" style="width: ${percentage}%"></div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </c:if>

                <c:if test="${empty revenueData}">
                    <div class="table-container">
                        <div class="empty-state">
                            <h3>📊 Không có dữ liệu doanh thu</h3>
                            <p>Không tìm thấy dữ liệu doanh thu trong khoảng thời gian đã chọn.</p>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>
    </div>

    <script>
        // Revenue by Day Chart
        <c:if test="${not empty revenueData.revenueByDay}">
        const revenueByDayCtx = document.getElementById('revenueByDayChart').getContext('2d');
        new Chart(revenueByDayCtx, {
            type: 'line',
            data: {
                labels: [
                    <c:forEach var="day" items="${revenueData.revenueByDay}" varStatus="status">
                    '${day.date}'<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ],
                datasets: [{
                    label: 'Doanh Thu',
                    data: [
                        <c:forEach var="day" items="${revenueData.revenueByDay}" varStatus="status">
                        ${day.revenue}<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ],
                    borderColor: '#667eea',
                    backgroundColor: 'rgba(102, 126, 234, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return 'Doanh Thu: ₫' + context.parsed.y.toLocaleString();
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '₫' + value.toLocaleString();
                            }
                        }
                    }
                }
            }
        });
        </c:if>
    </script>
</body>
</html>