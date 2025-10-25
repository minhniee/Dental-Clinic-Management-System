<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giao Dịch Kho - Manager - Hệ Thống Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .transactions-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 1.5rem;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #e2e8f0;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: #1a202c;
            margin: 0;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79, 172, 254, 0.4);
        }

        .btn-warning {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            color: white;
        }

        .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(250, 112, 154, 0.4);
        }

        .filter-section {
            background: white;
            padding: 1.5rem;
            border-radius: 1rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            align-items: end;
        }

        .form-group {
            margin-bottom: 1rem;
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

        .transactions-table {
            background: white;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        }

        .table-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem;
            font-weight: 700;
            font-size: 1.25rem;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th {
            background: #f7fafc;
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: #2d3748;
            border-bottom: 2px solid #e2e8f0;
        }

        .table td {
            padding: 1rem;
            border-bottom: 1px solid #e2e8f0;
            vertical-align: middle;
        }

        .table tbody tr:hover {
            background: #f7fafc;
        }

        .transaction-type {
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.875rem;
            font-weight: 600;
        }

        .type-in {
            background: #d1fae5;
            color: #065f46;
        }

        .type-out {
            background: #fee2e2;
            color: #991b1b;
        }

        .quantity {
            font-weight: 700;
            font-size: 1.1rem;
        }

        .quantity-in {
            color: #059669;
        }

        .quantity-out {
            color: #dc2626;
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

        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .summary-card {
            background: white;
            padding: 1.5rem;
            border-radius: 1rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            text-align: center;
        }

        .summary-card h3 {
            margin: 0 0 0.5rem 0;
            color: #2d3748;
            font-size: 1.1rem;
        }

        .summary-card .number {
            font-size: 2rem;
            font-weight: 700;
            margin: 0;
        }

        .summary-card.in {
            border-left: 4px solid #059669;
        }

        .summary-card.out {
            border-left: 4px solid #dc2626;
        }

        .summary-card.total {
            border-left: 4px solid #667eea;
        }

        /* Remove custom positioning fixes */

        @media (max-width: 768px) {
            .transactions-container {
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
            
            .filter-row {
                grid-template-columns: 1fr;
            }
            
            .table {
                font-size: 0.875rem;
            }
            
            .table th,
            .table td {
                padding: 0.75rem 0.5rem;
            }
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
        <h1>📊 Giao Dịch Kho - Manager</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
        <div class="transactions-container">
            <!-- Action Buttons -->
            <div class="action-buttons" style="margin-bottom: 20px;">
                <button onclick="openAddModal()" class="btn btn-primary">➕ Thêm Giao Dịch</button>
                <button onclick="openBulkModal()" class="btn btn-success">📦 Nhập/Xuất Hàng Loạt</button>
                <a href="${pageContext.request.contextPath}/manager/inventory" class="btn btn-warning">📦 Quản Lý Kho</a>
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

            <!-- Summary Cards -->
            <div class="summary-cards">
                <div class="summary-card in">
                    <h3>📥 Tổng Nhập Kho</h3>
                    <p class="number" id="totalIn">0</p>
                </div>
                <div class="summary-card out">
                    <h3>📤 Tổng Xuất Kho</h3>
                    <p class="number" id="totalOut">0</p>
                </div>
                <div class="summary-card total">
                    <h3>📊 Tổng Giao Dịch</h3>
                    <p class="number" id="totalTransactions">0</p>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <h3 style="margin-bottom: 1rem; color: #2d3748;">🔍 Lọc & Tìm Kiếm</h3>
                <form method="get" action="${pageContext.request.contextPath}/manager/stock-transactions">
                    <input type="hidden" name="action" value="list">
                    <div class="filter-row">
                        <div class="form-group">
                            <label class="form-label">Vật tư:</label>
                            <select name="itemFilter" class="form-control">
                                <option value="">Tất Cả Vật Tư</option>
                                <c:forEach var="item" items="${allItems}">
                                    <option value="${item.itemId}" ${itemFilter == item.itemId ? 'selected' : ''}>
                                        ${item.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Loại giao dịch:</label>
                            <select name="typeFilter" class="form-control">
                                <option value="">Tất Cả</option>
                                <option value="IN" ${typeFilter == 'IN' ? 'selected' : ''}>Nhập Kho</option>
                                <option value="OUT" ${typeFilter == 'OUT' ? 'selected' : ''}>Xuất Kho</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Từ ngày:</label>
                            <input type="date" name="dateFrom" class="form-control" value="${dateFrom}">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Đến ngày:</label>
                            <input type="date" name="dateTo" class="form-control" value="${dateTo}">
                        </div>
                        <div class="form-group">
                            <button type="submit" class="btn btn-primary">🔍 Áp Dụng</button>
                            <a href="${pageContext.request.contextPath}/manager/stock-transactions" class="btn btn-warning">🔄 Xóa Lọc</a>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Transactions Table -->
            <div class="transactions-table">
                <div class="table-header">
                    📋 Danh Sách Giao Dịch Kho
                </div>
                <table class="table">
                    <thead>
                        <tr>
                            <th>📅 Ngày</th>
                            <th>📦 Vật Tư</th>
                            <th>🔄 Loại</th>
                            <th>📊 Số Lượng</th>
                            <th>👤 Thực Hiện</th>
                            <th>📝 Ghi Chú</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty transactions}">
                                <c:forEach var="transaction" items="${transactions}">
                                    <tr>
                                        <td>
                                            ${transaction.performedAt != null ? transaction.performedAt.toLocalDate() : 'N/A'}
                                        </td>
                                        <td>
                                            <strong>${transaction.itemName}</strong>
                                        </td>
                                        <td>
                                            <span class="transaction-type ${transaction.transactionType == 'IN' ? 'type-in' : 'type-out'}">
                                                ${transaction.transactionType == 'IN' ? '📥 Nhập' : '📤 Xuất'}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="quantity ${transaction.transactionType == 'IN' ? 'quantity-in' : 'quantity-out'}">
                                                ${transaction.transactionType == 'IN' ? '+' : '-'}${transaction.quantity}
                                            </span>
                                        </td>
                                        <td>${transaction.performedByName}</td>
                                        <td>${transaction.notes}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="empty-state">
                                        <div class="empty-state-icon">📊</div>
                                        <h3>Chưa có giao dịch nào</h3>
                                        <p>Hãy thêm giao dịch đầu tiên để bắt đầu theo dõi.</p>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
        </main>
    </div>

    <!-- Add Transaction Modal -->
    <div id="addModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">➕ Thêm Giao Dịch Mới</h3>
                <span class="close" onclick="closeModal('addModal')">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/manager/stock-transactions" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="form-label">Vật tư *</label>
                        <select name="itemId" class="form-control" required>
                            <option value="">Chọn vật tư...</option>
                            <c:forEach var="item" items="${allItems}">
                                <option value="${item.itemId}">${item.name} (Tồn: ${item.quantity})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Loại giao dịch *</label>
                        <select name="transactionType" class="form-control" required onchange="updateModalTitle()">
                            <option value="">Chọn loại...</option>
                            <option value="IN">📥 Nhập Kho</option>
                            <option value="OUT">📤 Xuất Kho</option>
                        </select>
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
                    <button type="button" class="btn btn-secondary" onclick="closeModal('addModal')">Hủy</button>
                    <button type="submit" class="btn btn-primary">Thêm Giao Dịch</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Bulk Transaction Modal -->
    <div id="bulkModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">📦 Nhập/Xuất Hàng Loạt</h3>
                <span class="close" onclick="closeModal('bulkModal')">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/manager/stock-transactions" method="post">
                <input type="hidden" name="action" id="bulkAction">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="form-label">Loại giao dịch *</label>
                        <select name="bulkType" class="form-control" required onchange="updateBulkAction()">
                            <option value="">Chọn loại...</option>
                            <option value="IN">📥 Nhập Kho Hàng Loạt</option>
                            <option value="OUT">📤 Xuất Kho Hàng Loạt</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Ghi chú chung</label>
                        <textarea name="notes" class="form-control" rows="3" placeholder="Ghi chú cho tất cả giao dịch..."></textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Chọn vật tư và số lượng:</label>
                        <div id="bulkItems">
                            <c:forEach var="item" items="${allItems}">
                                <div class="bulk-item" style="display: flex; gap: 1rem; margin-bottom: 1rem; align-items: center;">
                                    <input type="checkbox" name="itemIds" value="${item.itemId}" onchange="toggleQuantityInput(this)">
                                    <span style="flex: 1;">${item.name} (Tồn: ${item.quantity})</span>
                                    <input type="number" name="quantities" class="form-control" style="width: 100px;" min="1" disabled>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('bulkModal')">Hủy</button>
                    <button type="submit" class="btn btn-primary" id="bulkSubmitBtn">Xác Nhận</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Calculate summary statistics
        document.addEventListener('DOMContentLoaded', function() {
            const transactions = document.querySelectorAll('.table tbody tr');
            let totalIn = 0, totalOut = 0;
            
            transactions.forEach(row => {
                const typeCell = row.querySelector('.transaction-type');
                const quantityCell = row.querySelector('.quantity');
                
                if (typeCell && quantityCell) {
                    const quantity = parseInt(quantityCell.textContent.replace(/[+\-]/g, ''));
                    if (typeCell.classList.contains('type-in')) {
                        totalIn += quantity;
                    } else {
                        totalOut += quantity;
                    }
                }
            });
            
            document.getElementById('totalIn').textContent = totalIn;
            document.getElementById('totalOut').textContent = totalOut;
            document.getElementById('totalTransactions').textContent = transactions.length;
        });

        // Modal functions
        function openAddModal() {
            document.getElementById('addModal').style.display = 'block';
        }

        function openBulkModal() {
            document.getElementById('bulkModal').style.display = 'block';
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        function updateModalTitle() {
            const type = document.querySelector('select[name="transactionType"]').value;
            const title = document.querySelector('#addModal .modal-title');
            if (type === 'IN') {
                title.textContent = '📥 Nhập Kho';
            } else if (type === 'OUT') {
                title.textContent = '📤 Xuất Kho';
            } else {
                title.textContent = '➕ Thêm Giao Dịch Mới';
            }
        }

        function updateBulkAction() {
            const type = document.querySelector('select[name="bulkType"]').value;
            const actionInput = document.getElementById('bulkAction');
            const submitBtn = document.getElementById('bulkSubmitBtn');
            
            if (type === 'IN') {
                actionInput.value = 'bulk_in';
                submitBtn.textContent = 'Nhập Kho Hàng Loạt';
                submitBtn.className = 'btn btn-success';
            } else if (type === 'OUT') {
                actionInput.value = 'bulk_out';
                submitBtn.textContent = 'Xuất Kho Hàng Loạt';
                submitBtn.className = 'btn btn-primary';
            }
        }

        function toggleQuantityInput(checkbox) {
            const quantityInput = checkbox.parentElement.querySelector('input[name="quantities"]');
            quantityInput.disabled = !checkbox.checked;
            if (!checkbox.checked) {
                quantityInput.value = '';
            }
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
    </script>
</body>
</html>
