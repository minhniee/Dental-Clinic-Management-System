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
            font-size: 2rem;
            color: white;
            margin: 0;
            font-weight: 700;
        }
        
        .btn-primary {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            padding: 0.75rem 1.5rem;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 0.75rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 0.9rem;
            font-weight: 600;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }
        
        .btn-primary:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        
        .btn-success {
            background: #10b981;
            color: white;
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 0.5rem;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-success:hover {
            background: #059669;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }
        
        .btn-danger {
            background: #ef4444;
            color: white;
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 0.5rem;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-danger:hover {
            background: #dc2626;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
        }
        
        .btn-warning {
            background: #f59e0b;
            color: white;
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 0.5rem;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-warning:hover {
            background: #d97706;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3);
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
            border-radius: 1rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            border: 1px solid #e2e8f0;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .table th {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            color: #1f2937;
            padding: 1rem;
            text-align: left;
            font-weight: 700;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #e2e8f0;
        }
        
        .table td {
            padding: 1rem;
            border-bottom: 1px solid #e2e8f0;
            font-size: 0.95rem;
            white-space: nowrap;
        }
        
        .table td:last-child {
            white-space: normal;
        }
        
        .table tr:hover {
            background: #f8fafc;
            transition: all 0.2s ease;
        }
        
        .status-badge {
            padding: 0.35rem 0.75rem;
            border-radius: 0.4rem;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-block;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            white-space: nowrap;
        }
        
        .status-active {
            background: #10b981;
            color: white;
            border: none;
        }
        
        .status-inactive {
            background: #ef4444;
            color: white;
            border: none;
        }
        
        .role-badge {
            background: #667eea;
            color: white;
            padding: 0.35rem 0.75rem;
            border-radius: 0.4rem;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            display: inline-block;
            white-space: nowrap;
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
        
        .form-control.error {
            border-color: #dc2626;
            background: #fef2f2;
        }
        
        .form-control.success {
            border-color: #059669;
        }
        
        .error-message {
            color: #dc2626;
            font-size: 0.85rem;
            margin-top: 0.25rem;
            display: none;
        }
        
        .error-message.show {
            display: block;
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
            padding: 2rem;
            border-radius: 1rem;
            width: 80%;
            max-width: 500px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: slideDown 0.3s ease;
        }
        
        @keyframes slideDown {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
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
        
        .modal-footer .btn-primary {
            background: #667eea;
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 0.5rem;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .modal-footer .btn-primary:hover {
            background: #5568d3;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 0.5rem;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .action-buttons {
            display: flex;
            gap: 0.4rem;
            flex-wrap: wrap;
            align-items: center;
        }
        
        .action-buttons .btn-primary {
            background: #3b82f6;
            color: white;
            font-size: 0.75rem;
            padding: 0.35rem 0.65rem;
            white-space: nowrap;
            flex-shrink: 0;
            border: none;
        }
        
        .action-buttons .btn-primary:hover {
            background: #2563eb;
        }
        
        .action-buttons .btn-warning,
        .action-buttons .btn-danger,
        .action-buttons .btn-success {
            font-size: 0.75rem;
            padding: 0.35rem 0.65rem;
            white-space: nowrap;
            flex-shrink: 0;
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
        <h1>Quản Lý Người Dùng</h1>
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
                    <h2 class="page-title">Quản Lý Người Dùng</h2>
                    <button class="btn-primary" onclick="openCreateUserModal()">Tạo Người Dùng Mới</button>
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
                                            ${user.active ? 'Hoạt Động' : 'Không Hoạt Động'}
                                        </span>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${user.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn-primary" onclick="openEditUserModal(${user.userId}, '${user.username}', '${user.email}', '${user.fullName}', '${user.phone}')">
                                                Chỉnh Sửa
                                            </button>
                                            <button class="btn-warning" onclick="openUpdateRoleModal(${user.userId}, '${user.role.roleName}', ${user.role.roleId})">
                                                Đổi Vai Trò
                                            </button>
                                            <button class="btn-${user.active ? 'danger' : 'success'}" 
                                                    onclick="updateUserStatus(${user.userId}, ${!user.active})">
                                                ${user.active ? 'Khóa' : 'Mở'}
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
            <form action="${pageContext.request.contextPath}/admin/users" method="post" id="createUserForm" onsubmit="return validateCreateForm()">
                <input type="hidden" name="action" value="createUser">
                
                <div class="form-group">
                    <label for="username">Tên Đăng Nhập *</label>
                    <input type="text" id="username" name="username" class="form-control" required>
                    <div class="error-message" id="usernameError">Tên đăng nhập không được để trống</div>
                </div>
                
                <div class="form-group">
                    <label for="email">Email *</label>
                    <input type="email" id="email" name="email" class="form-control" required>
                    <div class="error-message" id="emailError">Email không hợp lệ</div>
                </div>
                
                <div class="form-group">
                    <label for="password">Mật Khẩu *</label>
                    <input type="password" id="password" name="password" class="form-control" required>
                    <div class="error-message" id="passwordError">Mật khẩu phải có ít nhất 6 ký tự</div>
                </div>
                
                <div class="form-group">
                    <label for="fullName">Họ Tên *</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" required>
                    <div class="error-message" id="fullNameError">Họ tên không được để trống</div>
                </div>
                
                <div class="form-group">
                    <label for="phone">Số Điện Thoại</label>
                    <input type="text" id="phone" name="phone" class="form-control" placeholder="VD: 0123456789">
                    <div class="error-message" id="phoneError">Số điện thoại phải có 10 số và bắt đầu bằng 0</div>
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
            <form action="${pageContext.request.contextPath}/admin/users" method="post" id="editUserForm" onsubmit="return validateEditForm()">
                <input type="hidden" name="action" value="updateUser">
                <input type="hidden" id="editUserId" name="userId">
                
                <div class="form-group">
                    <label for="editUsername">Tên Đăng Nhập *</label>
                    <input type="text" id="editUsername" name="username" class="form-control" required>
                    <div class="error-message" id="editUsernameError">Tên đăng nhập không được để trống</div>
                </div>
                
                <div class="form-group">
                    <label for="editEmail">Email *</label>
                    <input type="email" id="editEmail" name="email" class="form-control" required>
                    <div class="error-message" id="editEmailError">Email không hợp lệ</div>
                </div>
                
                <div class="form-group">
                    <label for="editFullName">Họ Tên *</label>
                    <input type="text" id="editFullName" name="fullName" class="form-control" required>
                    <div class="error-message" id="editFullNameError">Họ tên không được để trống</div>
                </div>
                
                <div class="form-group">
                    <label for="editPhone">Số Điện Thoại</label>
                    <input type="text" id="editPhone" name="phone" class="form-control" placeholder="VD: 0123456789">
                    <div class="error-message" id="editPhoneError">Số điện thoại phải có 10 số và bắt đầu bằng 0</div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeEditUserModal()">Hủy</button>
                    <button type="submit" class="btn-primary">Cập Nhật Thông Tin</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Validation functions
        function validatePhone(phone) {
            // Phone must be 10 digits, start with 0, no letters
            const phoneRegex = /^0\d{9}$/;
            return phoneRegex.test(phone);
        }
        
        function validateEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }
        
        function validatePassword(password) {
            // Password must be at least 6 characters
            return password.length >= 6;
        }
        
        function showError(inputId, errorId, message) {
            const input = document.getElementById(inputId);
            const error = document.getElementById(errorId);
            input.classList.remove('success');
            input.classList.add('error');
            error.textContent = message;
            error.classList.add('show');
        }
        
        function showSuccess(inputId, errorId) {
            const input = document.getElementById(inputId);
            const error = document.getElementById(errorId);
            input.classList.remove('error');
            input.classList.add('success');
            error.classList.remove('show');
        }
        
        function validateCreateForm() {
            let isValid = true;
            
            // Validate username
            const username = document.getElementById('username').value.trim();
            if (username === '') {
                showError('username', 'usernameError', 'Tên đăng nhập không được để trống');
                isValid = false;
            } else {
                showSuccess('username', 'usernameError');
            }
            
            // Validate email
            const email = document.getElementById('email').value.trim();
            if (email === '') {
                showError('email', 'emailError', 'Email không được để trống');
                isValid = false;
            } else if (!validateEmail(email)) {
                showError('email', 'emailError', 'Email không hợp lệ');
                isValid = false;
            } else {
                showSuccess('email', 'emailError');
            }
            
            // Validate password
            const password = document.getElementById('password').value;
            if (password === '') {
                showError('password', 'passwordError', 'Mật khẩu không được để trống');
                isValid = false;
            } else if (!validatePassword(password)) {
                showError('password', 'passwordError', 'Mật khẩu phải có ít nhất 6 ký tự');
                isValid = false;
            } else {
                showSuccess('password', 'passwordError');
            }
            
            // Validate full name
            const fullName = document.getElementById('fullName').value.trim();
            if (fullName === '') {
                showError('fullName', 'fullNameError', 'Họ tên không được để trống');
                isValid = false;
            } else {
                showSuccess('fullName', 'fullNameError');
            }
            
            // Validate phone (optional but must be valid if provided)
            const phone = document.getElementById('phone').value.trim();
            if (phone !== '') {
                if (!validatePhone(phone)) {
                    showError('phone', 'phoneError', 'Số điện thoại phải có 10 số và bắt đầu bằng 0');
                    isValid = false;
                } else {
                    showSuccess('phone', 'phoneError');
                }
            }
            
            return isValid;
        }
        
        function validateEditForm() {
            let isValid = true;
            
            // Validate username
            const username = document.getElementById('editUsername').value.trim();
            if (username === '') {
                showError('editUsername', 'editUsernameError', 'Tên đăng nhập không được để trống');
                isValid = false;
            } else {
                showSuccess('editUsername', 'editUsernameError');
            }
            
            // Validate email
            const email = document.getElementById('editEmail').value.trim();
            if (email === '') {
                showError('editEmail', 'editEmailError', 'Email không được để trống');
                isValid = false;
            } else if (!validateEmail(email)) {
                showError('editEmail', 'editEmailError', 'Email không hợp lệ');
                isValid = false;
            } else {
                showSuccess('editEmail', 'editEmailError');
            }
            
            // Validate full name
            const fullName = document.getElementById('editFullName').value.trim();
            if (fullName === '') {
                showError('editFullName', 'editFullNameError', 'Họ tên không được để trống');
                isValid = false;
            } else {
                showSuccess('editFullName', 'editFullNameError');
            }
            
            // Validate phone (optional but must be valid if provided)
            const phone = document.getElementById('editPhone').value.trim();
            if (phone !== '') {
                if (!validatePhone(phone)) {
                    showError('editPhone', 'editPhoneError', 'Số điện thoại phải có 10 số và bắt đầu bằng 0');
                    isValid = false;
                } else {
                    showSuccess('editPhone', 'editPhoneError');
                }
            }
            
            return isValid;
        }
        
        // Real-time validation for phone field
        document.getElementById('phone')?.addEventListener('input', function(e) {
            const phone = e.target.value.trim();
            if (phone === '') {
                showSuccess('phone', 'phoneError');
            } else if (!validatePhone(phone)) {
                showError('phone', 'phoneError', 'Số điện thoại phải có 10 số và bắt đầu bằng 0');
            } else {
                showSuccess('phone', 'phoneError');
            }
        });
        
        document.getElementById('editPhone')?.addEventListener('input', function(e) {
            const phone = e.target.value.trim();
            if (phone === '') {
                showSuccess('editPhone', 'editPhoneError');
            } else if (!validatePhone(phone)) {
                showError('editPhone', 'editPhoneError', 'Số điện thoại phải có 10 số và bắt đầu bằng 0');
            } else {
                showSuccess('editPhone', 'editPhoneError');
            }
        });
        
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
