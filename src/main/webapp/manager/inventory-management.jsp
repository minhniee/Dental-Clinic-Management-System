<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Vật Tư & Thiết Bị - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .inventory-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; margin-top: 20px; }
        .inventory-card { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); border: 1px solid #e2e8f0; }
        .inventory-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .item-name { font-size: 1.2rem; font-weight: 600; color: #2c3e50; }
        .stock-status { padding: 4px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .stock-adequate { background: #d4edda; color: #155724; }
        .stock-low { background: #fff3cd; color: #856404; }
        .stock-out { background: #f8d7da; color: #721c24; }
        .item-info { margin-bottom: 15px; }
        .info-item { display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 0.9rem; }
        .info-label { color: #7f8c8d; font-weight: 500; }
        .info-value { color: #2c3e50; font-weight: 600; }
        .item-actions { display: flex; gap: 10px; }
        .btn-action { padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer; font-size: 0.8rem; text-decoration: none; display: inline-block; }
        .btn-primary { background: #667eea; color: white; }
        .btn-success { background: #28a745; color: white; }
        .btn-warning { background: #ffc107; color: #212529; }
        .btn-action:hover { opacity: 0.9; }
        .stats-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); text-align: center; }
        .stat-value { font-size: 2rem; font-weight: 700; color: #667eea; margin-bottom: 5px; }
        .stat-label { color: #7f8c8d; font-size: 0.9rem; }
        .filter-section { background: white; padding: 20px; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .filter-buttons { display: flex; gap: 10px; margin-top: 15px; }
        .filter-btn { padding: 8px 16px; border: 1px solid #dee2e6; background: white; border-radius: 6px; cursor: pointer; text-decoration: none; color: #495057; }
        .filter-btn.active { background: #667eea; color: white; border-color: #667eea; }
        .filter-btn:hover { background: #f8f9fa; }
        .filter-btn.active:hover { background: #667eea; }
        .quick-actions { background: white; padding: 20px; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .action-buttons { display: flex; gap: 15px; margin-top: 15px; }
        .btn-quick { padding: 12px 24px; border: none; border-radius: 8px; cursor: pointer; font-size: 0.9rem; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; }
        .btn-in { background: #28a745; color: white; }
        .btn-out { background: #dc3545; color: white; }
        .btn-transactions { background: #6c757d; color: white; }
        .btn-quick:hover { opacity: 0.9; }
        .btn-primary { background: #667eea; color: white; }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 0;
            border-radius: 12px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
        }
        .modal-header {
            background: #667eea;
            color: white;
            padding: 20px;
            border-radius: 12px 12px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .modal-title {
            margin: 0;
            font-size: 1.2rem;
            font-weight: 600;
        }
        .close {
            color: white;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            line-height: 1;
        }
        .close:hover { opacity: 0.7; }
        .modal-body {
            padding: 20px;
        }
        .modal-footer {
            padding: 20px;
            border-top: 1px solid #e2e8f0;
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #374151;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            display: inline-block;
        }
        .btn-secondary {
            background: #6b7280;
            color: white;
        }
        .btn-secondary:hover {
            background: #4b5563;
        }
        
        /* Filter Section Styles */
        .filter-section {
            background: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            align-items: end;
        }
        .form-group {
            display: flex;
            flex-direction: column;
        }
        .form-label {
            margin-bottom: 5px;
            font-weight: 500;
            color: #374151;
        }
        .form-control {
            padding: 10px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
        }
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .btn-warning {
            background: #f59e0b;
            color: white;
        }
        .btn-warning:hover {
            background: #d97706;
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
    <h1>🦷 Quản Lý Vật Tư & Thiết Bị</h1>
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
                <h2>📦 Quản Lý Vật Tư & Thiết Bị</h2>
                <p>Theo dõi tồn kho, nhập/xuất vật tư và cảnh báo khi tồn kho thấp</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    ❌ ${error}
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    ✅ ${success}
                </div>
            </c:if>

            <!-- Statistics Cards -->
            <div class="stats-cards">
                <div class="stat-card">
                    <div class="stat-value">${fn:length(items)}</div>
                    <div class="stat-label">Tổng Vật Tư</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${lowStockCount}</div>
                    <div class="stat-label">Tồn Kho Thấp</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">
                        <c:set var="outOfStock" value="0"/>
                        <c:forEach var="item" items="${items}">
                            <c:if test="${item.outOfStock}">
                                <c:set var="outOfStock" value="${outOfStock + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${outOfStock}
                    </div>
                    <div class="stat-label">Hết Hàng</div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <h3>⚡ Thao Tác Nhanh</h3>
                <div class="action-buttons">
                    <button onclick="openAddModal()" class="btn-quick btn-primary">➕ Thêm Vật Tư</button>
                    <a href="${pageContext.request.contextPath}/manager/inventory?action=transactions" 
                       class="btn-quick btn-transactions">📊 Xem Giao Dịch</a>
                    <a href="${pageContext.request.contextPath}/manager/inventory?action=low_stock" 
                       class="btn-quick btn-warning">⚠️ Tồn Kho Thấp</a>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <h3 style="margin-bottom: 1rem; color: #2d3748;">🔍 Lọc & Tìm Kiếm</h3>
                <div class="filter-row">
                    <div class="form-group">
                        <label class="form-label">Tìm kiếm theo tên:</label>
                        <input type="text" id="searchInput" class="form-control" placeholder="Nhập tên vật tư...">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Trạng thái tồn kho:</label>
                        <select id="stockFilter" class="form-control">
                            <option value="all">Tất Cả</option>
                            <option value="adequate">Đủ Hàng</option>
                            <option value="low">Sắp Hết</option>
                            <option value="out">Hết Hàng</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <button onclick="applyFilters()" class="btn btn-primary">🔍 Áp Dụng</button>
                        <button onclick="clearFilters()" class="btn btn-warning">🔄 Xóa Lọc</button>
                    </div>
                </div>
            </div>

            <!-- Inventory Grid -->
            <div class="inventory-grid">
                <c:forEach var="item" items="${items}">
                    <div class="inventory-card" data-name="${fn:toLowerCase(item.name)}" data-stock="${item.quantity}" data-min-stock="${item.minStock}">
                        <div class="inventory-header">
                            <div class="item-name">${item.name}</div>
                            <div class="stock-status 
                                <c:choose>
                                    <c:when test="${item.outOfStock}">stock-out</c:when>
                                    <c:when test="${item.lowStock}">stock-low</c:when>
                                    <c:otherwise>stock-adequate</c:otherwise>
                                </c:choose>">
                                <c:choose>
                                    <c:when test="${item.outOfStock}">Hết hàng</c:when>
                                    <c:when test="${item.lowStock}">Tồn kho thấp</c:when>
                                    <c:otherwise>Đủ hàng</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div class="item-info">
                            <div class="info-item">
                                <span class="info-label">📦 Số lượng:</span>
                                <span class="info-value">${item.quantity} ${item.unit}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">⚠️ Tồn kho tối thiểu:</span>
                                <span class="info-value">${item.minStock} ${item.unit}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">📅 Ngày tạo:</span>
                                <span class="info-value">
                                    ${fn:substring(item.createdAt.toString(), 0, 10)}
                                </span>
                            </div>
                        </div>
                        
                        <div class="item-actions">
                            <a href="${pageContext.request.contextPath}/manager/inventory?action=view&id=${item.itemId}" 
                               class="btn-action btn-primary">👁️ Xem Chi Tiết</a>
                            <button onclick="showStockInModal(${item.itemId}, '${item.name}')" 
                                    class="btn-action btn-success">📥 Nhập Kho</button>
                            <button onclick="showStockOutModal(${item.itemId}, '${item.name}', ${item.quantity})" 
                                    class="btn-action btn-warning">📤 Xuất Kho</button>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty items}">
                <div class="no-data">
                    <h3>📭 Không có vật tư nào</h3>
                    <p>Chưa có vật tư nào được tìm thấy.</p>
                </div>
            </c:if>
        </div>
    </main>
</div>

<!-- Stock In Modal -->
<div id="stockInModal" class="modal" style="display: none;">
    <div class="modal-content">
        <span class="close">&times;</span>
        <h3>📥 Nhập Kho</h3>
        <form id="stockInForm" method="post" action="${pageContext.request.contextPath}/manager/inventory">
            <input type="hidden" name="action" value="stock_in">
            <input type="hidden" name="itemId" id="stockInItemId">
            
            <div class="form-group">
                <label>Tên vật tư:</label>
                <input type="text" id="stockInItemName" readonly>
            </div>
            
            <div class="form-group">
                <label>Số lượng nhập:</label>
                <input type="number" name="quantity" min="1" required>
            </div>
            
            <div class="form-group">
                <label>Ghi chú:</label>
                <textarea name="notes" rows="3" placeholder="Ghi chú về việc nhập kho..."></textarea>
            </div>
            
            <div class="form-actions">
                <button type="submit" class="btn-success">📥 Nhập Kho</button>
                <button type="button" class="btn-secondary" onclick="closeModal('stockInModal')">Hủy</button>
            </div>
        </form>
    </div>
</div>

<!-- Stock Out Modal -->
<div id="stockOutModal" class="modal" style="display: none;">
    <div class="modal-content">
        <span class="close">&times;</span>
        <h3>📤 Xuất Kho</h3>
        <form id="stockOutForm" method="post" action="${pageContext.request.contextPath}/manager/inventory">
            <input type="hidden" name="action" value="stock_out">
            <input type="hidden" name="itemId" id="stockOutItemId">
            
            <div class="form-group">
                <label>Tên vật tư:</label>
                <input type="text" id="stockOutItemName" readonly>
            </div>
            
            <div class="form-group">
                <label>Tồn kho hiện tại:</label>
                <input type="text" id="stockOutCurrentStock" readonly>
            </div>
            
            <div class="form-group">
                <label>Số lượng xuất:</label>
                <input type="number" name="quantity" min="1" required>
            </div>
            
            <div class="form-group">
                <label>Ghi chú:</label>
                <textarea name="notes" rows="3" placeholder="Ghi chú về việc xuất kho..."></textarea>
            </div>
            
            <div class="form-actions">
                <button type="submit" class="btn-warning">📤 Xuất Kho</button>
                <button type="button" class="btn-secondary" onclick="closeModal('stockOutModal')">Hủy</button>
            </div>
        </form>
    </div>
</div>

<style>
    .alert { padding: 15px; margin-bottom: 20px; border-radius: 4px; font-weight: 500; }
    .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
    .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    .no-data { text-align: center; padding: 40px; color: #7f8c8d; }
    .modal { position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); }
    .modal-content { background-color: white; margin: 15% auto; padding: 20px; border-radius: 12px; width: 80%; max-width: 500px; }
    .close { color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer; }
    .close:hover { color: black; }
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 5px; font-weight: 600; color: #2c3e50; }
    .form-group input, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; }
    .form-actions { display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px; }
    .btn-secondary { background: #6c757d; color: white; padding: 10px 20px; border: none; border-radius: 6px; cursor: pointer; }
</style>

<script>
function showStockInModal(itemId, itemName) {
    document.getElementById('stockInItemId').value = itemId;
    document.getElementById('stockInItemName').value = itemName;
    document.getElementById('stockInModal').style.display = 'block';
}

function showStockOutModal(itemId, itemName, currentStock) {
    document.getElementById('stockOutItemId').value = itemId;
    document.getElementById('stockOutItemName').value = itemName;
    document.getElementById('stockOutCurrentStock').value = currentStock;
    document.getElementById('stockOutModal').style.display = 'block';
}

function closeModal(modalId) {
    document.getElementById(modalId).style.display = 'none';
}

// Close modal when clicking outside
window.onclick = function(event) {
    if (event.target.classList.contains('modal')) {
        event.target.style.display = 'none';
    }
}

// Close modal when clicking X
document.querySelectorAll('.close').forEach(function(closeBtn) {
    closeBtn.onclick = function() {
        this.closest('.modal').style.display = 'none';
    }
});

// Add Item Modal Functions
function openAddModal() {
    document.getElementById('addModal').style.display = 'block';
}
</script>

<!-- Add Item Modal -->
<div id="addModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 class="modal-title">➕ Thêm Vật Tư Mới</h3>
            <span class="close" onclick="closeModal('addModal')">&times;</span>
        </div>
        <form action="${pageContext.request.contextPath}/manager/inventory" method="post">
            <input type="hidden" name="action" value="add">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">Tên vật tư *</label>
                    <input type="text" name="name" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Đơn vị</label>
                    <input type="text" name="unit" class="form-control" placeholder="Ví dụ: hộp, chai, kg...">
                </div>
                <div class="form-group">
                    <label class="form-label">Số lượng ban đầu</label>
                    <input type="number" name="quantity" class="form-control" value="0" min="0">
                </div>
                <div class="form-group">
                    <label class="form-label">Tồn kho tối thiểu</label>
                    <input type="number" name="minStock" class="form-control" value="0" min="0">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('addModal')">Hủy</button>
                <button type="submit" class="btn btn-primary">Thêm Vật Tư</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Filter Functions
    function applyFilters() {
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        const stockFilter = document.getElementById('stockFilter').value;
        const cards = document.querySelectorAll('.inventory-card');
        
        cards.forEach(card => {
            const itemName = card.getAttribute('data-name');
            const stock = parseInt(card.getAttribute('data-stock'));
            const minStock = parseInt(card.getAttribute('data-min-stock'));
            
            let showCard = true;
            
            // Search filter
            if (searchTerm && !itemName.includes(searchTerm)) {
                showCard = false;
            }
            
            // Stock filter
            if (stockFilter !== 'all') {
                if (stockFilter === 'adequate' && stock <= minStock) {
                    showCard = false;
                } else if (stockFilter === 'low' && (stock > minStock || stock === 0)) {
                    showCard = false;
                } else if (stockFilter === 'out' && stock > 0) {
                    showCard = false;
                }
            }
            
            card.style.display = showCard ? 'block' : 'none';
        });
    }

    function clearFilters() {
        document.getElementById('searchInput').value = '';
        document.getElementById('stockFilter').value = 'all';
        const cards = document.querySelectorAll('.inventory-card');
        cards.forEach(card => card.style.display = 'block');
    }

    // Auto-apply search as user types
    document.getElementById('searchInput').addEventListener('input', applyFilters);
    document.getElementById('stockFilter').addEventListener('change', applyFilters);
</script>
</body>
</html>
