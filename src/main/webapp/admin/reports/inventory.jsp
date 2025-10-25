<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- Tóm tắt tồn kho -->
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-value">${reportData.inventorySummary.totalItems}</div>
        <div class="stat-label">📦 Tổng Vật Tư</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-value">${reportData.inventorySummary.lowStockItems}</div>
        <div class="stat-label">⚠️ Sắp Hết Hàng</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-value">${reportData.inventorySummary.outOfStockItems}</div>
        <div class="stat-label">❌ Hết Hàng</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-value">
            <fmt:formatNumber value="${reportData.inventorySummary.totalValue}" type="currency" currencySymbol="₫" />
        </div>
        <div class="stat-label">💰 Tổng Giá Trị</div>
    </div>
</div>

<!-- Cảnh báo vật tư sắp hết -->
<c:if test="${reportData.inventorySummary.lowStockItems > 0}">
    <div class="alert alert-error">
        <strong>⚠️ Cảnh Báo:</strong> Có ${reportData.inventorySummary.lowStockItems} vật tư sắp hết hàng cần bổ sung!
    </div>
</c:if>

<!-- Danh sách vật tư sắp hết -->
<div class="data-table">
    <h3 class="chart-title">⚠️ Vật Tư Sắp Hết Hàng</h3>
    <table>
        <thead>
            <tr>
                <th>Vật Tư</th>
                <th>Số Lượng Hiện Tại</th>
                <th>Mức Tối Thiểu</th>
                <th>Đơn Giá</th>
                <th>Trạng Thái</th>
                <th>Hành Động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${reportData.lowStockItems}" varStatus="status">
                <tr>
                    <td>
                        <strong>${item.name}</strong>
                    </td>
                    <td>
                        <span class="stat-value">${item.quantity}</span>
                    </td>
                    <td>
                        ${item.minStock}
                    </td>
                    <td>
                        <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫" />
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${item.quantity == 0}">
                                <span style="color: #e74c3c; font-weight: bold;">❌ HẾT HÀNG</span>
                            </c:when>
                            <c:when test="${item.quantity <= item.minStock}">
                                <span style="color: #f39c12; font-weight: bold;">⚠️ SẮP HẾT</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #27ae60;">✅ ĐỦ HÀNG</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${item.quantity == 0}">
                                <button class="btn-export excel" style="background: #e74c3c; padding: 5px 10px; font-size: 12px;">
                                    🚨 Nhập Khẩn Cấp
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button class="btn-export excel" style="background: #f39c12; padding: 5px 10px; font-size: 12px;">
                                    📦 Nhập Thêm
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- Biểu đồ phân bố tồn kho -->
<div class="chart-container">
    <h3 class="chart-title">📊 Phân Bố Tồn Kho Theo Trạng Thái</h3>
    <div class="chart-wrapper">
        <canvas id="inventoryStatusChart"></canvas>
    </div>
</div>

<!-- Xu hướng nhập/xuất kho -->
<div class="chart-container">
    <h3 class="chart-title">📈 Xu Hướng Nhập/Xuất Kho (30 ngày gần nhất)</h3>
    <div class="chart-wrapper">
        <canvas id="stockMovementChart"></canvas>
    </div>
</div>

<!-- Chi tiết giao dịch kho -->
<div class="data-table">
    <h3 class="chart-title">📋 Chi Tiết Giao Dịch Kho</h3>
    <table>
        <thead>
            <tr>
                <th>Ngày</th>
                <th>Vật Tư</th>
                <th>Loại</th>
                <th>Số Lượng</th>
                <th>Đơn Giá</th>
                <th>Thành Tiền</th>
                <th>Ghi Chú</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="movement" items="${reportData.stockMovements}" varStatus="status">
                <tr>
                    <td>
                        <fmt:formatDate value="${movement.date}" pattern="dd/MM/yyyy" />
                    </td>
                    <td>
                        <strong>${movement.itemName}</strong>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${movement.type == 'IN'}">
                                <span style="color: #27ae60; font-weight: bold;">📥 NHẬP</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #e74c3c; font-weight: bold;">📤 XUẤT</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <span class="stat-value">${movement.quantity}</span>
                    </td>
                    <td>
                        <fmt:formatNumber value="${movement.unitPrice}" type="currency" currencySymbol="₫" />
                    </td>
                    <td>
                        <fmt:formatNumber value="${movement.totalAmount}" type="currency" currencySymbol="₫" />
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty movement.notes}">
                                ${movement.notes}
                            </c:when>
                            <c:otherwise>
                                <span style="color: #7f8c8d; font-style: italic;">Không có ghi chú</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- Tóm tắt giá trị tồn kho -->
<div class="chart-container">
    <h3 class="chart-title">💰 Phân Tích Giá Trị Tồn Kho</h3>
    <div class="chart-wrapper">
        <canvas id="inventoryValueChart"></canvas>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Biểu đồ trạng thái tồn kho
    const inventoryStatusCtx = document.getElementById('inventoryStatusChart').getContext('2d');
    const inventoryStatusData = {
        'Đủ hàng': ${reportData.inventorySummary.totalItems - reportData.inventorySummary.lowStockItems - reportData.inventorySummary.outOfStockItems},
        'Sắp hết': ${reportData.inventorySummary.lowStockItems},
        'Hết hàng': ${reportData.inventorySummary.outOfStockItems}
    };
    
    new Chart(inventoryStatusCtx, {
        type: 'doughnut',
        data: {
            labels: Object.keys(inventoryStatusData),
            datasets: [{
                data: Object.values(inventoryStatusData),
                backgroundColor: [
                    '#27ae60', // Đủ hàng
                    '#f39c12', // Sắp hết
                    '#e74c3c'  // Hết hàng
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
    
    // Biểu đồ xu hướng nhập/xuất
    const stockMovementCtx = document.getElementById('stockMovementChart').getContext('2d');
    const stockMovementData = [
        <c:forEach var="movement" items="${reportData.stockMovements}" varStatus="status">
        {
            date: '${movement.date}',
            in: ${movement.type == 'IN' ? movement.quantity : 0},
            out: ${movement.type == 'OUT' ? movement.quantity : 0}
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    
    new Chart(stockMovementCtx, {
        type: 'bar',
        data: {
            labels: stockMovementData.map(item => item.date),
            datasets: [
                {
                    label: 'Nhập kho',
                    data: stockMovementData.map(item => item.in),
                    backgroundColor: '#27ae60',
                    borderColor: '#229954',
                    borderWidth: 1
                },
                {
                    label: 'Xuất kho',
                    data: stockMovementData.map(item => item.out),
                    backgroundColor: '#e74c3c',
                    borderColor: '#c0392b',
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
    
    // Biểu đồ giá trị tồn kho
    const inventoryValueCtx = document.getElementById('inventoryValueChart').getContext('2d');
    const inventoryValueData = [
        <c:forEach var="item" items="${reportData.inventorySummary}" varStatus="status">
        {
            name: '${item.name}',
            value: ${item.value}
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    
    new Chart(inventoryValueCtx, {
        type: 'pie',
        data: {
            labels: inventoryValueData.map(item => item.name),
            datasets: [{
                data: inventoryValueData.map(item => item.value),
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
