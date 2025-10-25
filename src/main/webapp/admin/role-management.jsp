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
        
        .btn-warning {
            background: #f39c12;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }
        
        .btn-warning:hover {
            background: #e67e22;
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
        
        .table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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
        
        .table tbody tr:hover {
            background: #f8f9fa;
        }
        
        .role-badge {
            background: #3498db;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .permission-list {
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
        }
        
        .permission-tag {
            background: #e8f5e8;
            color: #2d5a2d;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            border: 1px solid #c3e6c3;
            font-weight: 500;
        }
        
        .permission-category {
            margin-bottom: 15px;
        }
        
        .permission-category-title {
            font-weight: 600;
            color: #34495e;
            margin-bottom: 8px;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .permission-group {
            display: flex;
            flex-wrap: wrap;
            gap: 4px;
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
            max-width: 600px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
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
        
        .roles-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }
        
        .role-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border: 1px solid #e0e0e0;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .role-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
        }
        
        .role-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .role-name {
            font-size: 1.2rem;
            font-weight: 700;
            color: #2c3e50;
            margin: 0;
        }
        
        .user-count {
            background: #e8f5e8;
            color: #2d5a2d;
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .role-description {
            color: #6c757d;
            margin-bottom: 1rem;
            font-style: italic;
        }
        
        .permissions-section h4 {
            font-size: 0.9rem;
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
        }
        
        .role-actions {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #f0f0f0;
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
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
        }
        
        .checkbox-group {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 10px;
            margin-top: 10px;
        }
        
        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .checkbox-item input[type="checkbox"] {
            width: 16px;
            height: 16px;
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
        
        .action-buttons {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            font-weight: 600;
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
        <h1>🔐 Quản Lý Vai Trò</h1>
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
                    <h2 class="page-title">🔐 Quản Lý Vai Trò & Phân Quyền</h2>
                    <div class="config-info">
                        📝 Hệ thống có 5 vai trò cố định: Administrator, ClinicManager, Receptionist, Dentist, Patient
                    </div>
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

                <!-- Fixed Roles Table -->
                <div class="roles-grid">
                    <c:forEach var="role" items="${roles}">
                        <div class="role-card">
                            <div class="role-header">
                                <h3 class="role-name">${role.roleName}</h3>
                                <span class="user-count">👥 ${role.userCount} người dùng</span>
                            </div>
                            <div class="role-description">
                                ${role.description}
                            </div>
                            <div class="permissions-section">
                                <h4>Quyền Hạn:</h4>
                                <div class="permission-list">
                                    <!-- Quản lý hệ thống -->
                                    <c:if test="${fn:contains(role.permissions, 'user_management') || fn:contains(role.permissions, 'role_management') || fn:contains(role.permissions, 'system_config')}">
                                        <div class="permission-category">
                                            <div class="permission-category-title">🔧 Quản Lý Hệ Thống</div>
                                            <div class="permission-group">
                                                <c:if test="${fn:contains(role.permissions, 'user_management')}">
                                                    <span class="permission-tag">👥 Quản lý người dùng</span>
                                                </c:if>
                                                <c:if test="${fn:contains(role.permissions, 'role_management')}">
                                                    <span class="permission-tag">🔑 Quản lý vai trò</span>
                                                </c:if>
                                                <c:if test="${fn:contains(role.permissions, 'system_config')}">
                                                    <span class="permission-tag">⚙️ Cấu hình hệ thống</span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <!-- Quản lý nhân sự -->
                                    <c:if test="${fn:contains(role.permissions, 'employee_management') || fn:contains(role.permissions, 'schedule_management')}">
                                        <div class="permission-category">
                                            <div class="permission-category-title">👨‍💼 Quản Lý Nhân Sự</div>
                                            <div class="permission-group">
                                                <c:if test="${fn:contains(role.permissions, 'employee_management')}">
                                                    <span class="permission-tag">👥 Quản lý nhân viên</span>
                                                </c:if>
                                                <c:if test="${fn:contains(role.permissions, 'schedule_management')}">
                                                    <span class="permission-tag">📅 Quản lý lịch làm việc</span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <!-- Quản lý kho -->
                                    <c:if test="${fn:contains(role.permissions, 'inventory_management')}">
                                        <div class="permission-category">
                                            <div class="permission-category-title">📦 Quản Lý Kho</div>
                                            <div class="permission-group">
                                                <span class="permission-tag">📦 Quản lý vật tư</span>
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <!-- Quản lý bệnh nhân -->
                                    <c:if test="${fn:contains(role.permissions, 'appointment_management') || fn:contains(role.permissions, 'patient_management') || fn:contains(role.permissions, 'appointment_view') || fn:contains(role.permissions, 'appointment_booking')}">
                                        <div class="permission-category">
                                            <div class="permission-category-title">🏥 Quản Lý Bệnh Nhân</div>
                                            <div class="permission-group">
                                                <c:if test="${fn:contains(role.permissions, 'appointment_management')}">
                                                    <span class="permission-tag">📅 Quản lý lịch hẹn</span>
                                                </c:if>
                                                <c:if test="${fn:contains(role.permissions, 'appointment_view')}">
                                                    <span class="permission-tag">👁️ Xem lịch hẹn</span>
                                                </c:if>
                                                <c:if test="${fn:contains(role.permissions, 'appointment_booking')}">
                                                    <span class="permission-tag">📝 Đặt lịch hẹn</span>
                                                </c:if>
                                                <c:if test="${fn:contains(role.permissions, 'patient_management')}">
                                                    <span class="permission-tag">👤 Quản lý bệnh nhân</span>
                                                </c:if>
                                                <c:if test="${fn:contains(role.permissions, 'patient_registration')}">
                                                    <span class="permission-tag">📋 Đăng ký bệnh nhân</span>
                                                </c:if>
                                                <c:if test="${fn:contains(role.permissions, 'patient_treatment')}">
                                                    <span class="permission-tag">🩺 Điều trị bệnh nhân</span>
                                                </c:if>
                                                <c:if test="${fn:contains(role.permissions, 'medical_records')}">
                                                    <span class="permission-tag">📋 Hồ sơ bệnh án</span>
                                                </c:if>
                                                <c:if test="${fn:contains(role.permissions, 'patient_profile')}">
                                                    <span class="permission-tag">👤 Hồ sơ cá nhân</span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <!-- Báo cáo & Tài chính -->
                                    <c:if test="${fn:contains(role.permissions, 'report_view') || fn:contains(role.permissions, 'financial_management') || fn:contains(role.permissions, 'financial_reports') || fn:contains(role.permissions, 'operational_reports')}">
                                        <div class="permission-category">
                                            <div class="permission-category-title">📊 Báo Cáo & Tài Chính</div>
                                            <div class="permission-group">
                                                <c:if test="${fn:contains(role.permissions, 'report_view')}">
                                                    <span class="permission-tag">📊 Xem báo cáo</span>
                                                </c:if>
                                                <c:if test="${fn:contains(role.permissions, 'financial_management')}">
                                                    <span class="permission-tag">💰 Quản lý tài chính</span>
                                                </c:if>
                                                <c:if test="${fn:contains(role.permissions, 'financial_reports')}">
                                                    <span class="permission-tag">💳 Báo cáo tài chính</span>
                                                </c:if>
                                                <c:if test="${fn:contains(role.permissions, 'operational_reports')}">
                                                    <span class="permission-tag">📈 Báo cáo vận hành</span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <!-- Xem lịch -->
                                    <c:if test="${fn:contains(role.permissions, 'schedule_view')}">
                                        <div class="permission-category">
                                            <div class="permission-category-title">📅 Xem Lịch</div>
                                            <div class="permission-group">
                                                <span class="permission-tag">👁️ Xem lịch làm việc</span>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                        </div>
                    </c:forEach>
                </div>
            </div>
        </main>
    </div>

    <!-- Create Role Modal -->
    <div id="createRoleModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>➕ Tạo Vai Trò Mới</h3>
                <span class="close" onclick="closeCreateRoleModal()">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/admin/roles" method="post">
                <input type="hidden" name="action" value="createRole">
                
                <div class="form-group">
                    <label for="roleName">Tên Vai Trò *</label>
                    <input type="text" id="roleName" name="roleName" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="description">Mô Tả</label>
                    <textarea id="description" name="description" class="form-control" rows="3"></textarea>
                </div>
                
                <div class="form-group">
                    <label>Quyền Hạn</label>
                    <div class="checkbox-group">
                        <!-- Quản lý hệ thống -->
                        <div class="permission-category">
                            <div class="permission-category-title">🔧 Quản Lý Hệ Thống</div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="user_management" id="perm_user_management">
                                <label for="perm_user_management">👥 Quản lý người dùng</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="role_management" id="perm_role_management">
                                <label for="perm_role_management">🔑 Quản lý vai trò</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="system_config" id="perm_system_config">
                                <label for="perm_system_config">⚙️ Cấu hình hệ thống</label>
                            </div>
                        </div>
                        
                        <!-- Quản lý nhân sự -->
                        <div class="permission-category">
                            <div class="permission-category-title">👨‍💼 Quản Lý Nhân Sự</div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="employee_management" id="perm_employee_management">
                                <label for="perm_employee_management">👥 Quản lý nhân viên</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="schedule_management" id="perm_schedule_management">
                                <label for="perm_schedule_management">📅 Quản lý lịch làm việc</label>
                            </div>
                        </div>
                        
                        <!-- Quản lý kho -->
                        <div class="permission-category">
                            <div class="permission-category-title">📦 Quản Lý Kho</div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="inventory_management" id="perm_inventory_management">
                                <label for="perm_inventory_management">📦 Quản lý vật tư</label>
                            </div>
                        </div>
                        
                        <!-- Quản lý bệnh nhân -->
                        <div class="permission-category">
                            <div class="permission-category-title">🏥 Quản Lý Bệnh Nhân</div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="appointment_management" id="perm_appointment_management">
                                <label for="perm_appointment_management">📅 Quản lý lịch hẹn</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="appointment_view" id="perm_appointment_view">
                                <label for="perm_appointment_view">👁️ Xem lịch hẹn</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="appointment_booking" id="perm_appointment_booking">
                                <label for="perm_appointment_booking">📝 Đặt lịch hẹn</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="patient_management" id="perm_patient_management">
                                <label for="perm_patient_management">👤 Quản lý bệnh nhân</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="patient_registration" id="perm_patient_registration">
                                <label for="perm_patient_registration">📋 Đăng ký bệnh nhân</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="patient_treatment" id="perm_patient_treatment">
                                <label for="perm_patient_treatment">🩺 Điều trị bệnh nhân</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="medical_records" id="perm_medical_records">
                                <label for="perm_medical_records">📋 Hồ sơ bệnh án</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="patient_profile" id="perm_patient_profile">
                                <label for="perm_patient_profile">👤 Hồ sơ cá nhân</label>
                            </div>
                        </div>
                        
                        <!-- Báo cáo & Tài chính -->
                        <div class="permission-category">
                            <div class="permission-category-title">📊 Báo Cáo & Tài Chính</div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="report_view" id="perm_report_view">
                                <label for="perm_report_view">📊 Xem báo cáo</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="financial_management" id="perm_financial_management">
                                <label for="perm_financial_management">💰 Quản lý tài chính</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="financial_reports" id="perm_financial_reports">
                                <label for="perm_financial_reports">💳 Báo cáo tài chính</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="operational_reports" id="perm_operational_reports">
                                <label for="perm_operational_reports">📈 Báo cáo vận hành</label>
                            </div>
                        </div>
                        
                        <!-- Xem lịch -->
                        <div class="permission-category">
                            <div class="permission-category-title">📅 Xem Lịch</div>
                            <div class="checkbox-item">
                                <input type="checkbox" name="permissions" value="schedule_view" id="perm_schedule_view">
                                <label for="perm_schedule_view">👁️ Xem lịch làm việc</label>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeCreateRoleModal()">Hủy</button>
                    <button type="submit" class="btn-primary">Tạo Vai Trò</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit Role Modal -->
    <div id="editRoleModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>✏️ Chỉnh Sửa Vai Trò</h3>
                <span class="close" onclick="closeEditRoleModal()">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/admin/roles" method="post">
                <input type="hidden" name="action" value="updateRole">
                <input type="hidden" id="editRoleId" name="roleId">
                
                <div class="form-group">
                    <label for="editRoleName">Tên Vai Trò *</label>
                    <input type="text" id="editRoleName" name="roleName" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="editDescription">Mô Tả</label>
                    <textarea id="editDescription" name="description" class="form-control" rows="3"></textarea>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeEditRoleModal()">Hủy</button>
                    <button type="submit" class="btn-primary">Cập Nhật</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Permission Modal -->
    <div id="permissionModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>🔑 Phân Quyền: <span id="permissionRoleName"></span></h3>
                <span class="close" onclick="closePermissionModal()">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/admin/roles" method="post">
                <input type="hidden" name="action" value="updatePermissions">
                <input type="hidden" id="permissionRoleId" name="roleId">
                
                <div class="form-group">
                    <label>Quyền Hạn</label>
                    <div class="checkbox-group" id="permissionCheckboxes">
                        <!-- Permissions will be loaded dynamically -->
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closePermissionModal()">Hủy</button>
                    <button type="submit" class="btn-primary">Cập Nhật Quyền</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Modal functions
        function openCreateRoleModal() {
            document.getElementById('createRoleModal').style.display = 'block';
        }
        
        function closeCreateRoleModal() {
            document.getElementById('createRoleModal').style.display = 'none';
        }
        
        function openEditRoleModal(roleId, roleName, description) {
            document.getElementById('editRoleId').value = roleId;
            document.getElementById('editRoleName').value = roleName;
            document.getElementById('editDescription').value = description || '';
            document.getElementById('editRoleModal').style.display = 'block';
        }
        
        function closeEditRoleModal() {
            document.getElementById('editRoleModal').style.display = 'none';
        }
        
        function openPermissionModal(roleId, roleName) {
            document.getElementById('permissionRoleId').value = roleId;
            document.getElementById('permissionRoleName').textContent = roleName;
            
            // Load permissions for this role
            loadRolePermissions(roleId);
            
            document.getElementById('permissionModal').style.display = 'block';
        }
        
        function loadRolePermissions(roleId) {
            // This would typically make an AJAX call to get current permissions
            // For now, we'll show all available permissions
            const permissionContainer = document.getElementById('permissionCheckboxes');
            permissionContainer.innerHTML = `
                <!-- Quản lý hệ thống -->
                <div class="permission-category">
                    <div class="permission-category-title">🔧 Quản Lý Hệ Thống</div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="user_management" id="perm_user_management">
                        <label for="perm_user_management">👥 Quản lý người dùng</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="role_management" id="perm_role_management">
                        <label for="perm_role_management">🔑 Quản lý vai trò</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="system_config" id="perm_system_config">
                        <label for="perm_system_config">⚙️ Cấu hình hệ thống</label>
                    </div>
                </div>
                
                <!-- Quản lý nhân sự -->
                <div class="permission-category">
                    <div class="permission-category-title">👨‍💼 Quản Lý Nhân Sự</div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="employee_management" id="perm_employee_management">
                        <label for="perm_employee_management">👥 Quản lý nhân viên</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="schedule_management" id="perm_schedule_management">
                        <label for="perm_schedule_management">📅 Quản lý lịch làm việc</label>
                    </div>
                </div>
                
                <!-- Quản lý kho -->
                <div class="permission-category">
                    <div class="permission-category-title">📦 Quản Lý Kho</div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="inventory_management" id="perm_inventory_management">
                        <label for="perm_inventory_management">📦 Quản lý vật tư</label>
                    </div>
                </div>
                
                <!-- Quản lý bệnh nhân -->
                <div class="permission-category">
                    <div class="permission-category-title">🏥 Quản Lý Bệnh Nhân</div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="appointment_management" id="perm_appointment_management">
                        <label for="perm_appointment_management">📅 Quản lý lịch hẹn</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="appointment_view" id="perm_appointment_view">
                        <label for="perm_appointment_view">👁️ Xem lịch hẹn</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="appointment_booking" id="perm_appointment_booking">
                        <label for="perm_appointment_booking">📝 Đặt lịch hẹn</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="patient_management" id="perm_patient_management">
                        <label for="perm_patient_management">👤 Quản lý bệnh nhân</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="patient_registration" id="perm_patient_registration">
                        <label for="perm_patient_registration">📋 Đăng ký bệnh nhân</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="patient_treatment" id="perm_patient_treatment">
                        <label for="perm_patient_treatment">🩺 Điều trị bệnh nhân</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="medical_records" id="perm_medical_records">
                        <label for="perm_medical_records">📋 Hồ sơ bệnh án</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="patient_profile" id="perm_patient_profile">
                        <label for="perm_patient_profile">👤 Hồ sơ cá nhân</label>
                    </div>
                </div>
                
                <!-- Báo cáo & Tài chính -->
                <div class="permission-category">
                    <div class="permission-category-title">📊 Báo Cáo & Tài Chính</div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="report_view" id="perm_report_view">
                        <label for="perm_report_view">📊 Xem báo cáo</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="financial_management" id="perm_financial_management">
                        <label for="perm_financial_management">💰 Quản lý tài chính</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="financial_reports" id="perm_financial_reports">
                        <label for="perm_financial_reports">💳 Báo cáo tài chính</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="operational_reports" id="perm_operational_reports">
                        <label for="perm_operational_reports">📈 Báo cáo vận hành</label>
                    </div>
                </div>
                
                <!-- Xem lịch -->
                <div class="permission-category">
                    <div class="permission-category-title">📅 Xem Lịch</div>
                    <div class="checkbox-item">
                        <input type="checkbox" name="permissions" value="schedule_view" id="perm_schedule_view">
                        <label for="perm_schedule_view">👁️ Xem lịch làm việc</label>
                    </div>
                </div>
            `;
        }
        
        function closePermissionModal() {
            document.getElementById('permissionModal').style.display = 'none';
        }
        
        function deleteRole(roleId, roleName) {
            if (confirm('Bạn có chắc muốn xóa vai trò "' + roleName + '"?\n\nLưu ý: Vai trò này sẽ bị xóa vĩnh viễn và không thể khôi phục.')) {
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