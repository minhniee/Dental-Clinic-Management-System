<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Vai Trò - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .role-management {
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
        
        .roles-table {
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
        
        .role-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        
        .role-info h4 {
            margin: 0 0 10px 0;
            color: #2c3e50;
        }
        
        .role-info p {
            margin: 5px 0;
            color: #6c757d;
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
        <h1>🦷 Quản Lý Vai Trò</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="role-management">
                <div class="page-header">
                    <h2 class="page-title">🔐 Quản Lý Vai Trò</h2>
                    <button class="btn-primary" onclick="openCreateRoleModal()">+ Tạo Vai Trò Mới</button>
                </div>

                <c:if test="${not empty success}">
                    <div class="alert alert-success">${success}</div>
                </c:if>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-error">${error}</div>
                </c:if>

                <div class="role-info">
                    <h4>Thông Tin Vai Trò Hệ Thống</h4>
                    <p><strong>Administrator:</strong> Quyền quản trị toàn hệ thống, có thể quản lý tất cả người dùng và cài đặt.</p>
                    <p><strong>ClinicManager:</strong> Quyền quản lý phòng khám, xem báo cáo và quản lý nhân viên.</p>
                    <p><strong>Dentist:</strong> Quyền bác sĩ, có thể xem lịch hẹn, khám bệnh và tạo hồ sơ bệnh nhân.</p>
                    <p><strong>Receptionist:</strong> Quyền lễ tân, có thể đặt lịch hẹn và quản lý thông tin bệnh nhân.</p>
                    <p><strong>Patient:</strong> Quyền bệnh nhân, có thể xem lịch hẹn và thông tin cá nhân.</p>
                </div>

                <div class="roles-table">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên Vai Trò</th>
                                <th>Mô Tả</th>
                                <th>Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="role" items="${roles}">
                                <tr>
                                    <td>${role.roleId}</td>
                                    <td>
                                        <span class="role-badge">${role.roleName}</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${role.roleName == 'Administrator'}">
                                                Quyền quản trị toàn hệ thống
                                            </c:when>
                                            <c:when test="${role.roleName == 'ClinicManager'}">
                                                Quyền quản lý phòng khám
                                            </c:when>
                                            <c:when test="${role.roleName == 'Dentist'}">
                                                Quyền bác sĩ nha khoa
                                            </c:when>
                                            <c:when test="${role.roleName == 'Receptionist'}">
                                                Quyền lễ tân
                                            </c:when>
                                            <c:when test="${role.roleName == 'Patient'}">
                                                Quyền bệnh nhân
                                            </c:when>
                                            <c:otherwise>
                                                Vai trò tùy chỉnh
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button class="btn-warning" onclick="openUpdateRoleModal(${role.roleId}, '${role.roleName}')">
                                            Chỉnh Sửa
                                        </button>
                                        <c:if test="${role.roleName != 'Administrator' && role.roleName != 'Dentist' && role.roleName != 'Receptionist' && role.roleName != 'Patient'}">
                                            <button class="btn-danger" onclick="deleteRole(${role.roleId}, '${role.roleName}')">
                                                Xóa
                                            </button>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Create Role Modal -->
    <div id="createRoleModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Tạo Vai Trò Mới</h3>
                <span class="close" onclick="closeCreateRoleModal()">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/admin/roles" method="post">
                <input type="hidden" name="action" value="createRole">
                
                <div class="form-group">
                    <label for="roleName">Tên Vai Trò *</label>
                    <input type="text" id="roleName" name="roleName" class="form-control" required>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeCreateRoleModal()">Hủy</button>
                    <button type="submit" class="btn-primary">Tạo Vai Trò</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Update Role Modal -->
    <div id="updateRoleModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Chỉnh Sửa Vai Trò</h3>
                <span class="close" onclick="closeUpdateRoleModal()">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/admin/roles" method="post">
                <input type="hidden" name="action" value="updateRole">
                <input type="hidden" id="updateRoleId" name="roleId">
                
                <div class="form-group">
                    <label for="updateRoleName">Tên Vai Trò *</label>
                    <input type="text" id="updateRoleName" name="roleName" class="form-control" required>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeUpdateRoleModal()">Hủy</button>
                    <button type="submit" class="btn-primary">Cập Nhật Vai Trò</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openCreateRoleModal() {
            document.getElementById('createRoleModal').style.display = 'block';
        }
        
        function closeCreateRoleModal() {
            document.getElementById('createRoleModal').style.display = 'none';
        }
        
        function openUpdateRoleModal(roleId, roleName) {
            document.getElementById('updateRoleId').value = roleId;
            document.getElementById('updateRoleName').value = roleName;
            document.getElementById('updateRoleModal').style.display = 'block';
        }
        
        function closeUpdateRoleModal() {
            document.getElementById('updateRoleModal').style.display = 'none';
        }
        
        function deleteRole(roleId, roleName) {
            if (confirm('Bạn có chắc muốn xóa vai trò "' + roleName + '"?')) {
                const form = document.createElement('form');
                form.method = 'post';
                form.action = '${pageContext.request.contextPath}/admin/roles';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'deleteRole';
                form.appendChild(actionInput);
                
                const roleIdInput = document.createElement('input');
                roleIdInput.type = 'hidden';
                roleIdInput.name = 'roleId';
                roleIdInput.value = roleId;
                form.appendChild(roleIdInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const createModal = document.getElementById('createRoleModal');
            const updateModal = document.getElementById('updateRoleModal');
            
            if (event.target === createModal) {
                closeCreateRoleModal();
            }
            if (event.target === updateModal) {
                closeUpdateRoleModal();
            }
        }
    </script>
</body>
</html>
