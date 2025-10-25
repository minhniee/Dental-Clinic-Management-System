<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Người Dùng - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .user-management {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .page-title {
            font-size: 2rem;
            color: #2c3e50;
            margin: 0;
        }
        
        .btn-primary {
            background: #3498db;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            transition: background 0.3s;
        }
        
        .btn-primary:hover {
            background: #2980b9;
        }
        
        .btn-success {
            background: #27ae60;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }
        
        .btn-danger {
            background: #e74c3c;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }
        
        .btn-warning {
            background: #f39c12;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 6px;
            font-weight: 500;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .users-table {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .table th {
            background: #34495e;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }
        
        .table td {
            padding: 15px;
            border-bottom: 1px solid #ecf0f1;
        }
        
        .table tr:hover {
            background: #f8f9fa;
        }
        
        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-active {
            background: #d4edda;
            color: #155724;
        }
        
        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }
        
        .role-badge {
            background: #3498db;
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }
        
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
            background-color: white;
            margin: 5% auto;
            padding: 20px;
            border-radius: 8px;
            width: 80%;
            max-width: 500px;
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #ecf0f1;
        }
        
        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close:hover {
            color: #000;
        }
        
        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid #ecf0f1;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .btn-danger {
            background: #dc3545;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }
        
        .btn-danger:hover {
            background: #c82333;
        }
        
        .btn-success {
            background: #28a745;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }
        
        .btn-success:hover {
            background: #218838;
        }
        
        .action-buttons {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }
        
        .status-active {
            color: #28a745;
            font-weight: bold;
        }
        
        .status-inactive {
            color: #dc3545;
            font-weight: bold;
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
        <h1>🦷 Quản Lý Người Dùng</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="user-management">
                <div class="page-header">
                    <h2 class="page-title">👥 Quản Lý Người Dùng</h2>
                    <button class="btn-primary" onclick="openCreateUserModal()">+ Tạo Người Dùng Mới</button>
                </div>

                <c:if test="${not empty success}">
                    <div class="alert alert-success">${success}</div>
                </c:if>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-error">${error}</div>
                </c:if>

                <div class="users-table">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên Đăng Nhập</th>
                                <th>Họ Tên</th>
                                <th>Email</th>
                                <th>Số Điện Thoại</th>
                                <th>Vai Trò</th>
                                <th>Trạng Thái</th>
                                <th>Ngày Tạo</th>
                                <th>Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td>${user.userId}</td>
                                    <td>${user.username}</td>
                                    <td>${user.fullName}</td>
                                    <td>${user.email}</td>
                                    <td>${user.phone}</td>
                                    <td>
                                        <span class="role-badge">${user.role.roleName}</span>
                                    </td>
                                    <td>
                                        <span class="status-badge ${user.active ? 'status-active' : 'status-inactive'}">
                                            ${user.active ? '✅ Hoạt Động' : '❌ Không Hoạt Động'}
                                        </span>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${user.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn-primary" onclick="openEditUserModal(${user.userId}, '${user.username}', '${user.email}', '${user.fullName}', '${user.phone}')">
                                                ✏️ Chỉnh Sửa
                                            </button>
                                            <button class="btn-warning" onclick="openUpdateRoleModal(${user.userId}, '${user.role.roleName}', ${user.role.roleId})">
                                                🔄 Đổi Vai Trò
                                            </button>
                                            <button class="btn-${user.active ? 'danger' : 'success'}" 
                                                    onclick="updateUserStatus(${user.userId}, ${!user.active})">
                                                ${user.active ? '🔒 Khóa' : '🔓 Mở'}
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Create User Modal -->
    <div id="createUserModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Tạo Người Dùng Mới</h3>
                <span class="close" onclick="closeCreateUserModal()">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/admin/users" method="post">
                <input type="hidden" name="action" value="createUser">
                
                <div class="form-group">
                    <label for="username">Tên Đăng Nhập *</label>
                    <input type="text" id="username" name="username" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="email">Email *</label>
                    <input type="email" id="email" name="email" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Mật Khẩu *</label>
                    <input type="password" id="password" name="password" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="fullName">Họ Tên *</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="phone">Số Điện Thoại</label>
                    <input type="text" id="phone" name="phone" class="form-control">
                </div>
                
                <div class="form-group">
                    <label for="roleId">Vai Trò *</label>
                    <select id="roleId" name="roleId" class="form-control" required>
                        <option value="">Chọn vai trò</option>
                        <c:forEach var="role" items="${roles}">
                            <option value="${role.roleId}">${role.roleName}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeCreateUserModal()">Hủy</button>
                    <button type="submit" class="btn-primary">Tạo Người Dùng</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Update Role Modal -->
    <div id="updateRoleModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Đổi Vai Trò</h3>
                <span class="close" onclick="closeUpdateRoleModal()">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/admin/users" method="post">
                <input type="hidden" name="action" value="updateRole">
                <input type="hidden" id="updateUserId" name="userId">
                
                <div class="form-group">
                    <label for="updateRoleId">Vai Trò Mới</label>
                    <select id="updateRoleId" name="roleId" class="form-control" required>
                        <option value="">Chọn vai trò mới</option>
                        <c:forEach var="role" items="${roles}">
                            <option value="${role.roleId}">${role.roleName}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeUpdateRoleModal()">Hủy</button>
                    <button type="submit" class="btn-primary">Cập Nhật Vai Trò</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div id="editUserModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Chỉnh Sửa Thông Tin Người Dùng</h3>
                <span class="close" onclick="closeEditUserModal()">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/admin/users" method="post">
                <input type="hidden" name="action" value="updateUser">
                <input type="hidden" id="editUserId" name="userId">
                
                <div class="form-group">
                    <label for="editUsername">Tên Đăng Nhập *</label>
                    <input type="text" id="editUsername" name="username" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="editEmail">Email *</label>
                    <input type="email" id="editEmail" name="email" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="editFullName">Họ Tên *</label>
                    <input type="text" id="editFullName" name="fullName" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="editPhone">Số Điện Thoại</label>
                    <input type="text" id="editPhone" name="phone" class="form-control">
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeEditUserModal()">Hủy</button>
                    <button type="submit" class="btn-primary">Cập Nhật Thông Tin</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openCreateUserModal() {
            document.getElementById('createUserModal').style.display = 'block';
        }
        
        function closeCreateUserModal() {
            document.getElementById('createUserModal').style.display = 'none';
        }
        
        function openUpdateRoleModal(userId, currentRoleName, currentRoleId) {
            document.getElementById('updateUserId').value = userId;
            document.getElementById('updateRoleId').value = currentRoleId;
            document.getElementById('updateRoleModal').style.display = 'block';
        }
        
        function closeUpdateRoleModal() {
            document.getElementById('updateRoleModal').style.display = 'none';
        }
        
        function openEditUserModal(userId, username, email, fullName, phone) {
            document.getElementById('editUserId').value = userId;
            document.getElementById('editUsername').value = username;
            document.getElementById('editEmail').value = email;
            document.getElementById('editFullName').value = fullName;
            document.getElementById('editPhone').value = phone || '';
            document.getElementById('editUserModal').style.display = 'block';
        }
        
        function closeEditUserModal() {
            document.getElementById('editUserModal').style.display = 'none';
        }
        
        function updateUserStatus(userId, isActive) {
            if (confirm(isActive ? 'Bạn có chắc muốn kích hoạt người dùng này?' : 'Bạn có chắc muốn vô hiệu hóa người dùng này?')) {
                const form = document.createElement('form');
                form.method = 'post';
                form.action = '${pageContext.request.contextPath}/admin/users';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'updateStatus';
                form.appendChild(actionInput);
                
                const userIdInput = document.createElement('input');
                userIdInput.type = 'hidden';
                userIdInput.name = 'userId';
                userIdInput.value = userId;
                form.appendChild(userIdInput);
                
                const statusInput = document.createElement('input');
                statusInput.type = 'hidden';
                statusInput.name = 'isActive';
                statusInput.value = isActive;
                form.appendChild(statusInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const createModal = document.getElementById('createUserModal');
            const updateModal = document.getElementById('updateRoleModal');
            const editModal = document.getElementById('editUserModal');
            
            if (event.target === createModal) {
                closeCreateUserModal();
            }
            if (event.target === updateModal) {
                closeUpdateRoleModal();
            }
            if (event.target === editModal) {
                closeEditUserModal();
            }
        }
    </script>
</body>
</html>
