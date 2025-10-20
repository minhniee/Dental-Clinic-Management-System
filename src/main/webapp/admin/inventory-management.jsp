<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Kho - Hệ Thống Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        /* Use dashboard.css container styles */

        /* Remove custom page header styles - use dashboard.css defaults */

        .action-buttons {
            display: flex;
            gap: 1rem;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            transition: background 0.3s;
        }

        .btn-primary {
            background: #3498db;
            color: white;
        }

        .btn-primary:hover {
            background: #2980b9;
        }

        .btn-success {
            background: #27ae60;
            color: white;
        }

        .btn-success:hover {
            background: #229954;
        }

        .btn-warning {
            background: #f39c12;
            color: white;
        }

        .btn-warning:hover {
            background: #e67e22;
        }

        .btn-danger {
            background: #e74c3c;
            color: white;
        }

        .btn-danger:hover {
            background: #c0392b;
        }

        .inventory-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .inventory-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border: 1px solid #e0e0e0;
            transition: box-shadow 0.3s;
        }

        .inventory-card:hover {
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .item-name {
            font-size: 1.25rem;
            font-weight: 700;
            color: #1a202c;
            margin: 0;
        }

        .stock-status {
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.875rem;
            font-weight: 600;
        }

        .stock-adequate {
            background: #d1fae5;
            color: #065f46;
        }

        .stock-low {
            background: #fef3c7;
            color: #92400e;
        }

        .stock-out {
            background: #fee2e2;
            color: #991b1b;
        }

        .item-details {
            margin-bottom: 1rem;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
        }

        .detail-label {
            font-weight: 600;
            color: #4a5568;
        }

        .detail-value {
            color: #1a202c;
        }

        .card-actions {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
        }

        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 0;
            border-radius: 1rem;
            width: 90%;
            max-width: 600px;
            box-shadow: 0 20px 25px rgba(0, 0, 0, 0.1);
            animation: modalSlideIn 0.3s ease;
        }

        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .modal-header {
            padding: 1.5rem;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1a202c;
            margin: 0;
        }

        .close {
            font-size: 2rem;
            font-weight: bold;
            color: #a0aec0;
            cursor: pointer;
            transition: color 0.2s ease;
        }

        .close:hover {
            color: #e53e3e;
        }

        .modal-body {
            padding: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 0.5rem;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e2e8f0;
            border-radius: 0.5rem;
            font-size: 1rem;
            transition: border-color 0.2s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .modal-footer {
            padding: 1.5rem;
            border-top: 1px solid #e2e8f0;
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
        }

        .alert {
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #718096;
        }

        .empty-state-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
        }

        .filter-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            align-items: end;
        }

        /* Remove custom positioning fixes */

        @media (max-width: 768px) {
            .inventory-container {
                padding: 1rem;
            }
            
            .page-header {
                flex-direction: column;
                gap: 1rem;
                align-items: stretch;
            }
            
            .action-buttons {
                justify-content: center;
            }
            
            .inventory-grid {
                grid-template-columns: 1fr;
            }
            
            .card-actions {
                justify-content: center;
            }
        }
</style>
></head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>

    <c:set var="_role" value="${empty sessionScope.user or empty sessionScope.user.role or empty sessionScope.user.role.roleName ? '' : fn:toLowerCase(fn:replace(sessionScope.user.role.roleName, ' ', ''))}"/>
    <c:if test="${_role ne 'administrator'}">
        <c:redirect url="${pageContext.request.contextPath}/login"/>
    </c:if>

    <div class="header">
        <h1>📦 Quản Lý Kho</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="container">
                <!-- Action Buttons -->
                <div class="action-buttons" style="margin-bottom: 20px;">
                    <button onclick="openAddModal()" class="btn btn-primary">➕ Thêm Vật Tư</button>
                    <a href="${pageContext.request.contextPath}/admin/stock-transactions" class="btn btn-success">📊 Giao Dịch Kho</a>
                </div>

            <!-- Alert Messages -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    ✅ ${success}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    ❌ ${error}
                </div>
            </c:if>

            <!-- Low Stock Warning -->
            <c:if test="${lowStockCount > 0}">
                <div class="alert alert-warning" style="background: #fef3c7; color: #92400e; border: 1px solid #fbbf24;">
                    ⚠️ <strong>Cảnh báo tồn kho thấp!</strong> Có ${lowStockCount} vật tư sắp hết hàng. 
                    <a href="#lowStockSection" style="color: #92400e; text-decoration: underline;">Xem chi tiết</a>
                </div>
            </c:if>

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

            <!-- Low Stock Section -->
            <c:if test="${lowStockCount > 0}">
                <div id="lowStockSection" class="filter-section" style="background: #fef3c7; border-left: 4px solid #f59e0b;">
                    <h3 style="margin-bottom: 1rem; color: #92400e;">⚠️ Vật Tư Sắp Hết Hàng</h3>
                    <div class="inventory-grid" style="grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));">
                        <c:forEach var="item" items="${lowStockItems}">
                            <div class="inventory-card" style="border-left: 4px solid #f59e0b; background: #fffbeb;">
                                <div class="card-header">
                                    <h3 class="item-name" style="color: #92400e;">${item.name}</h3>
                                    <span class="stock-status stock-low">Sắp Hết</span>
                                </div>
                                <div class="item-details">
                                    <div class="detail-row">
                                        <span class="detail-label">📦 Tồn kho:</span>
                                        <span class="detail-value" style="color: #dc2626; font-weight: 700;">${item.quantity}</span>
                                    </div>
                                    <div class="detail-row">
                                        <span class="detail-label">⚠️ Tồn kho tối thiểu:</span>
                                        <span class="detail-value">${item.minStock}</span>
                                    </div>
                                    <div class="detail-row">
                                        <span class="detail-label">📏 Đơn vị:</span>
                                        <span class="detail-value">${item.unit}</span>
                                    </div>
                                </div>
                                <div class="card-actions">
                                    <button onclick="openStockModal(${item.itemId}, '${item.name}', 'IN')" 
                                            class="btn btn-success btn-sm">
                                        📥 Nhập Kho Ngay
                                    </button>
                                    <button onclick="viewItemDetails(${item.itemId})" 
                                            class="btn btn-primary btn-sm">
                                        👁️ Chi Tiết
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <!-- Inventory Grid -->
            <div class="inventory-grid" id="inventoryGrid">
                <c:choose>
                    <c:when test="${not empty items}">
                        <c:forEach var="item" items="${items}">
                            <div class="inventory-card" data-name="${fn:toLowerCase(item.name)}" data-stock="${item.quantity}">
                                <div class="card-header">
                                    <h3 class="item-name">${item.name}</h3>
                                    <c:choose>
                                        <c:when test="${item.quantity == 0}">
                                            <span class="stock-status stock-out">Hết Hàng</span>
                                        </c:when>
                                        <c:when test="${item.quantity <= item.minStock}">
                                            <span class="stock-status stock-low">Sắp Hết</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="stock-status stock-adequate">Đủ Hàng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="item-details">
                                    <div class="detail-row">
                                        <span class="detail-label">📦 Tồn kho:</span>
                                        <span class="detail-value"><strong>${item.quantity}</strong></span>
                                    </div>
                                    <div class="detail-row">
                                        <span class="detail-label">⚠️ Tồn kho tối thiểu:</span>
                                        <span class="detail-value">${item.minStock}</span>
                                    </div>
                                    <div class="detail-row">
                                        <span class="detail-label">📏 Đơn vị:</span>
                                        <span class="detail-value">${item.unit}</span>
                                    </div>
                                    <div class="detail-row">
                                        <span class="detail-label">📅 Ngày tạo:</span>
                                        <span class="detail-value">
                                            ${item.createdAt != null ? item.createdAt.toLocalDate() : 'N/A'}
                                        </span>
                                    </div>
                                </div>

                                <div class="card-actions">
                                    <button onclick="openEditModal(${item.itemId}, '${item.name}', '${item.unit}', ${item.minStock})" 
                                            class="btn btn-warning btn-sm">
                                        ✏️ Sửa
                                    </button>
                                    <button onclick="openStockModal(${item.itemId}, '${item.name}', 'IN')" 
                                            class="btn btn-success btn-sm">
                                        📥 Nhập Kho
                                    </button>
                                    <button onclick="openStockModal(${item.itemId}, '${item.name}', 'OUT')" 
                                            class="btn btn-primary btn-sm">
                                        📤 Xuất Kho
                                    </button>
                                    <button onclick="viewItemDetails(${item.itemId})" 
                                            class="btn btn-primary btn-sm">
                                        👁️ Chi Tiết
                                    </button>
                                    <button onclick="deleteItem(${item.itemId}, '${item.name}')" 
                                            class="btn btn-danger btn-sm">
                                        🗑️ Xóa
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-state-icon">📦</div>
                            <h3>Chưa có vật tư nào</h3>
                            <p>Hãy thêm vật tư đầu tiên để bắt đầu quản lý kho.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            </div>
        </main>
    </div>

    <!-- Add Item Modal -->
    <div id="addModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">➕ Thêm Vật Tư Mới</h3>
                <span class="close" onclick="closeModal('addModal')">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/admin/inventory" method="post">
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

    <!-- Edit Item Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">✏️ Chỉnh Sửa Vật Tư</h3>
                <span class="close" onclick="closeModal('editModal')">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/admin/inventory" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="itemId" id="editItemId">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="form-label">Tên vật tư *</label>
                        <input type="text" name="name" id="editName" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Đơn vị</label>
                        <input type="text" name="unit" id="editUnit" class="form-control">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Tồn kho tối thiểu</label>
                        <input type="number" name="minStock" id="editMinStock" class="form-control" min="0">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('editModal')">Hủy</button>
                    <button type="submit" class="btn btn-primary">Cập Nhật</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Stock Transaction Modal -->
    <div id="stockModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="stockModalTitle">📥 Nhập Kho</h3>
                <span class="close" onclick="closeModal('stockModal')">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/admin/inventory" method="post">
                <input type="hidden" name="action" id="stockAction">
                <input type="hidden" name="itemId" id="stockItemId">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="form-label">Vật tư</label>
                        <input type="text" id="stockItemName" class="form-control" readonly>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Số lượng *</label>
                        <input type="number" name="quantity" class="form-control" required min="1">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Ghi chú</label>
                        <textarea name="notes" class="form-control" rows="3" placeholder="Ghi chú về giao dịch..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('stockModal')">Hủy</button>
                    <button type="submit" class="btn btn-primary" id="stockSubmitBtn">Xác Nhận</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Modal functions
        function openAddModal() {
            document.getElementById('addModal').style.display = 'block';
        }

        function openEditModal(itemId, name, unit, minStock) {
            document.getElementById('editItemId').value = itemId;
            document.getElementById('editName').value = name;
            document.getElementById('editUnit').value = unit;
            document.getElementById('editMinStock').value = minStock;
            document.getElementById('editModal').style.display = 'block';
        }

        function openStockModal(itemId, itemName, type) {
            document.getElementById('stockItemId').value = itemId;
            document.getElementById('stockItemName').value = itemName;
            document.getElementById('stockAction').value = type === 'IN' ? 'stock_in' : 'stock_out';
            
            const title = document.getElementById('stockModalTitle');
            const submitBtn = document.getElementById('stockSubmitBtn');
            
            if (type === 'IN') {
                title.textContent = '📥 Nhập Kho';
                submitBtn.textContent = 'Nhập Kho';
                submitBtn.className = 'btn btn-success';
            } else {
                title.textContent = '📤 Xuất Kho';
                submitBtn.textContent = 'Xuất Kho';
                submitBtn.className = 'btn btn-primary';
            }
            
            document.getElementById('stockModal').style.display = 'block';
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        function viewItemDetails(itemId) {
            window.location.href = '${pageContext.request.contextPath}/admin/inventory?action=view&id=' + itemId;
        }

        function deleteItem(itemId, itemName) {
            if (confirm('Bạn có chắc chắn muốn xóa vật tư "' + itemName + '"?')) {
                const form = document.createElement('form');
                form.method = 'post';
                form.action = '${pageContext.request.contextPath}/admin/inventory';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const itemIdInput = document.createElement('input');
                itemIdInput.type = 'hidden';
                itemIdInput.name = 'itemId';
                itemIdInput.value = itemId;
                
                form.appendChild(actionInput);
                form.appendChild(itemIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        // Filter functions
        function applyFilters() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const stockFilter = document.getElementById('stockFilter').value;
            const cards = document.querySelectorAll('.inventory-card');
            
            cards.forEach(card => {
                const itemName = card.getAttribute('data-name');
                const stock = parseInt(card.getAttribute('data-stock'));
                const minStock = parseInt(card.querySelector('.detail-row:nth-child(2) .detail-value').textContent);
                
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

        // Close modals when clicking outside
        window.onclick = function(event) {
            const modals = document.querySelectorAll('.modal');
            modals.forEach(modal => {
                if (event.target === modal) {
                    modal.style.display = 'none';
                }
            });
        }

        // Auto-apply search as user types
        document.getElementById('searchInput').addEventListener('input', applyFilters);
        document.getElementById('stockFilter').addEventListener('change', applyFilters);
    </script>
</body>
</html>
