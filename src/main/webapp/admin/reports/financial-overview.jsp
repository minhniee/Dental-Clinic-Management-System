<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Tài Chính Tổng Quan - Admin - Hệ Thống Nha Khoa</title>
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
            justify-content: center;
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
        
        .expense-amount {
            font-weight: 700;
            color: #dc2626;
            font-size: 1.1rem;
        }
        
        .profit-amount {
            font-weight: 700;
            color: #059669;
            font-size: 1.1rem;
        }
        
        .profit-margin {
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
        
        .badge {
            display: inline-block;
            padding: 0.4rem 0.8rem;
            border-radius: 0.5rem;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        
        .badge-success {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            color: #065f46;
            border: 1px solid #059669;
        }
        
        .badge-danger {
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            color: #991b1b;
            border: 1px solid #dc2626;
        }
        
        .badge-warning {
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            color: #92400e;
            border: 1px solid #f59e0b;
        }
        
        .badge-info {
            background: linear-gradient(135deg, #dbeafe, #bfdbfe);
            color: #1e40af;
            border: 1px solid #3b82f6;
        }
        
        .stat-card-revenue {
            border-left: 4px solid #059669;
            background: linear-gradient(135deg, #ffffff 0%, #f0fdfa 100%);
        }
        
        .stat-card-expense {
            border-left: 4px solid #dc2626;
            background: linear-gradient(135deg, #ffffff 0%, #fef2f2 100%);
        }
        
        .stat-card-profit {
            border-left: 4px solid #667eea;
            background: linear-gradient(135deg, #ffffff 0%, #f5f3ff 100%);
        }
        
        .stat-card-margin {
            border-left: 4px solid #f59e0b;
            background: linear-gradient(135deg, #ffffff 0%, #fffbeb 100%);
        }
        
        .change-arrow {
            font-weight: 700;
            font-size: 1.1rem;
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
            margin-right: 0.5rem;
        }
        
        .btn-primary {
            background: #667eea;
            color: white;
        }
        
        .btn-primary:hover {
            background: #5568d3;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: #6b7280;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #4b5563;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(107, 114, 128, 0.3);
        }
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
        <h1>Báo Cáo Tài Chính Tổng Quan</h1>
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
                    <h2 class="page-title">Báo Cáo Tài Chính Tổng Quan</h2>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        ${error}
                    </div>
                </c:if>

                <!-- Filter Section -->
                <div class="filter-section">
                    <h3 class="filter-title">Bộ Lọc</h3>
                    <form method="get" action="${pageContext.request.contextPath}/admin/financial-reports">
                        <input type="hidden" name="type" value="overview">
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
                                    Áp Dụng
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/financial-reports?type=overview" class="btn btn-secondary" style="background: #6b7280; color: white;">
                                    Xóa Lọc
                                </a>
                            </div>
                        </div>
                    </form>
                </div>

                <c:if test="${not empty financialData}">
                    <!-- Financial Overview Statistics -->
                    <div class="stats-grid">
                        <div class="stat-card stat-card-revenue">
                            <div class="stat-header">
                                <span class="stat-title">Tổng Doanh Thu</span>
                            </div>
                            <div class="stat-value">
                                <fmt:formatNumber value="${financialData.totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                            </div>
                            <div class="stat-change positive">
                                <span class="change-arrow">↑</span>
                                <span>Từ hóa đơn và dịch vụ</span>
                            </div>
                        </div>
                        
                        <div class="stat-card stat-card-expense">
                            <div class="stat-header">
                                <span class="stat-title">Tổng Chi Phí</span>
                            </div>
                            <div class="stat-value">
                                <fmt:formatNumber value="${financialData.totalExpenses}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                            </div>
                            <div class="stat-change negative">
                                <span class="change-arrow">↓</span>
                                <span>Vật tư và vận hành</span>
                            </div>
                        </div>
                        
                        <div class="stat-card stat-card-profit">
                            <div class="stat-header">
                                <span class="stat-title">Lợi Nhuận Ròng</span>
                            </div>
                            <div class="stat-value">
                                <fmt:formatNumber value="${financialData.netProfit}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                            </div>
                            <div class="stat-change ${financialData.netProfit >= 0 ? 'positive' : 'negative'}">
                                <span class="change-arrow">${financialData.netProfit >= 0 ? '↑' : '↓'}</span>
                                <span>Doanh thu - Chi phí</span>
                            </div>
                        </div>
                        
                        <div class="stat-card stat-card-margin">
                            <div class="stat-header">
                                <span class="stat-title">Tỷ Suất Lợi Nhuận</span>
                            </div>
                            <div class="stat-value">
                                <fmt:formatNumber value="${financialData.profitMargin}" maxFractionDigits="1"/>%
                            </div>
                            <div class="stat-change ${financialData.profitMargin >= 0 ? 'positive' : 'negative'}">
                                <span class="change-arrow">${financialData.profitMargin >= 0 ? '↑' : '↓'}</span>
                                <span>Hiệu quả kinh doanh</span>
                            </div>
                        </div>
                    </div>

                    <!-- Revenue vs Expenses Chart -->
                    <div class="chart-container">
                        <h3 class="chart-title">Doanh Thu vs Chi Phí</h3>
                        <div class="chart-wrapper">
                            <canvas id="revenueExpensesChart"></canvas>
                        </div>
                    </div>

                    <!-- Revenue Breakdown -->
                    <c:if test="${not empty financialData.revenueBreakdown}">
                        <div class="table-container">
                            <div class="table-header">
                                <h3 class="table-title">Phân Tích Doanh Thu</h3>
                            </div>
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Nguồn Doanh Thu</th>
                                        <th>Số Tiền</th>
                                        <th>Tỷ Lệ</th>
                                        <th>Ghi Chú</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="revenue" items="${financialData.revenueBreakdown}">
                                        <tr>
                                            <td>
                                                <div class="revenue-source">${revenue.source}</div>
                                            </td>
                                            <td>
                                                <div class="revenue-amount">
                                                    <fmt:formatNumber value="${revenue.amount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                </div>
                                            </td>
                                            <td>
                                                <c:set var="percentage" value="${financialData.totalRevenue > 0 ? (revenue.amount / financialData.totalRevenue) * 100 : 0}"/>
                                                <div class="profit-margin">
                                                    <fmt:formatNumber value="${percentage}" maxFractionDigits="1"/>%
                                                </div>
                                                <div class="progress-bar">
                                                    <div class="progress-fill" style="width: ${percentage}%"></div>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${revenue.source == 'Hóa Đơn'}">
                                                        <span class="badge badge-success">Đã Thanh Toán</span>
                                                    </c:when>
                                                    <c:when test="${revenue.source == 'Dịch Vụ'}">
                                                        <span class="badge badge-success">Hoàn Thành</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-info">Ước Tính</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>

                    <!-- Expense Breakdown -->
                    <c:if test="${not empty financialData.expenseBreakdown}">
                        <div class="table-container">
                            <div class="table-header">
                                <h3 class="table-title">Phân Tích Chi Phí</h3>
                            </div>
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Loại Chi Phí</th>
                                        <th>Số Tiền</th>
                                        <th>Tỷ Lệ</th>
                                        <th>Ghi Chú</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="expense" items="${financialData.expenseBreakdown}">
                                        <tr>
                                            <td>
                                                <div class="revenue-source">${expense.category}</div>
                                            </td>
                                            <td>
                                                <div class="expense-amount">
                                                    <fmt:formatNumber value="${expense.amount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                </div>
                                            </td>
                                            <td>
                                                <c:set var="percentage" value="${financialData.totalExpenses > 0 ? (expense.amount / financialData.totalExpenses) * 100 : 0}"/>
                                                <div class="profit-margin">
                                                    <fmt:formatNumber value="${percentage}" maxFractionDigits="1"/>%
                                                </div>
                                                <div class="progress-bar">
                                                    <div class="progress-fill" style="width: ${percentage}%"></div>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${expense.category == 'Vật Tư'}">
                                                        <span class="badge badge-danger">Xuất Kho</span>
                                                    </c:when>
                                                    <c:when test="${expense.category == 'Vận Hành'}">
                                                        <span class="badge badge-warning">Ước Tính</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-info">Khác</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>

                    <!-- Monthly Trends Chart -->
                    <c:if test="${not empty financialData.monthlyTrends}">
                    <div class="chart-container">
                        <h3 class="chart-title">Xu Hướng Doanh Thu Theo Tháng</h3>
                            <div class="chart-wrapper">
                                <canvas id="monthlyTrendsChart"></canvas>
                            </div>
                        </div>
                    </c:if>
                </c:if>

                <c:if test="${empty financialData}">
                    <div class="table-container">
                        <div class="empty-state">
                            <h3>Không có dữ liệu tài chính</h3>
                            <p>Không tìm thấy dữ liệu tài chính trong khoảng thời gian đã chọn.</p>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>
    </div>

    <script>
        // Revenue vs Expenses Chart
        <c:if test="${not empty financialData}">
        const revenueExpensesCtx = document.getElementById('revenueExpensesChart').getContext('2d');
        new Chart(revenueExpensesCtx, {
            type: 'bar',
            data: {
                labels: ['Doanh Thu', 'Chi Phí', 'Lợi Nhuận'],
                datasets: [{
                    label: 'Số Tiền (₫)',
                    data: [
                        ${financialData.totalRevenue},
                        ${financialData.totalExpenses},
                        ${financialData.netProfit}
                    ],
                    backgroundColor: [
                        'rgba(34, 197, 94, 0.8)',
                        'rgba(239, 68, 68, 0.8)',
                        'rgba(102, 126, 234, 0.8)'
                    ],
                    borderColor: [
                        'rgba(34, 197, 94, 1)',
                        'rgba(239, 68, 68, 1)',
                        'rgba(102, 126, 234, 1)'
                    ],
                    borderWidth: 2
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
                                return context.label + ': ₫' + context.parsed.y.toLocaleString();
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

        // Monthly Trends Chart
        <c:if test="${not empty financialData.monthlyTrends}">
        const monthlyTrendsCtx = document.getElementById('monthlyTrendsChart').getContext('2d');
        new Chart(monthlyTrendsCtx, {
            type: 'line',
            data: {
                labels: [
                    <c:forEach var="trend" items="${financialData.monthlyTrends}" varStatus="status">
                    '${trend.month}/${trend.year}'<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ],
                datasets: [{
                    label: 'Doanh Thu',
                    data: [
                        <c:forEach var="trend" items="${financialData.monthlyTrends}" varStatus="status">
                        ${trend.revenue}<c:if test="${!status.last}">,</c:if>
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
