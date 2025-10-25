<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Nhân Viên - Manager - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .employee-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .employee-card {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 1.5rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
            transition: all 0.2s ease-in-out;
        }
        
        .employee-card:hover {
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            transform: translateY(-1px);
        }
        
        .employee-header {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }
        
        .employee-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #06b6d4, #0891b2);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 1.2rem;
            margin-right: 1rem;
        }
        
        .employee-info h3 {
            margin: 0;
            color: #0f172a;
            font-size: 1.1rem;
            font-weight: 600;
        }
        
        .employee-info p {
            margin: 0.25rem 0 0 0;
            color: #64748b;
            font-size: 0.875rem;
        }
        
        .employee-details {
            margin-bottom: 1rem;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }
        
        .detail-label {
            color: #64748b;
            font-weight: 500;
        }
        
        .detail-value {
            color: #0f172a;
        }
        
        .employee-actions {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }
        
        .btn-small {
            padding: 0.375rem 0.75rem;
            font-size: 0.75rem;
            border-radius: 0.375rem;
            border: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            transition: all 0.2s ease;
        }
        
        .btn-primary {
            background: #06b6d4;
            color: white;
        }
        
        .btn-primary:hover {
            background: #0891b2;
        }
        
        .btn-warning {
            background: #f59e0b;
            color: white;
        }
        
        .btn-warning:hover {
            background: #d97706;
        }
        
        .btn-success {
            background: #10b981;
            color: white;
        }
        
        .btn-success:hover {
            background: #059669;
        }
        
        .btn-danger {
            background: #ef4444;
            color: white;
        }
        
        .btn-danger:hover {
            background: #dc2626;
        }
        
        .status-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 0.375rem;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .status-active {
            background: #dcfce7;
            color: #166534;
        }
        
        .status-inactive {
            background: #fee2e2;
            color: #991b1b;
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
        }
        
        .modal-content {
            background-color: #ffffff;
            margin: 5% auto;
            padding: 2rem;
            border-radius: 0.75rem;
            width: 90%;
            max-width: 600px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        
        .modal-header h2 {
            margin: 0;
            color: #0f172a;
        }
        
        .close {
            color: #64748b;
            font-size: 1.5rem;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close:hover {
            color: #0f172a;
        }
        
        .form-group {
            margin-bottom: 1rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #374151;
            font-weight: 500;
        }
        
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 0.5rem;
            border: 1px solid #d1d5db;
            border-radius: 0.375rem;
            font-size: 0.875rem;
        }
        
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #06b6d4;
            box-shadow: 0 0 0 3px rgba(6, 182, 212, 0.1);
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
        
        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
            margin-top: 1.5rem;
        }
        
        .btn {
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            border: none;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        
        .btn-secondary {
            background: #6b7280;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #4b5563;
        }
        
        .stats-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .stat-card {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 1.5rem;
            text-align: center;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: #06b6d4;
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            color: #64748b;
            font-size: 0.875rem;
            font-weight: 500;
        }
        
        .day-checkbox {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 0.75rem;
            border: 2px solid #e2e8f0;
            border-radius: 0.5rem;
            cursor: pointer;
            transition: all 0.2s ease;
            background: #ffffff;
        }
        
        .day-checkbox:hover {
            border-color: #06b6d4;
            background: #f0f9ff;
        }
        
        .day-checkbox input[type="checkbox"] {
            margin-bottom: 0.5rem;
            transform: scale(1.2);
        }
        
        .day-checkbox input[type="checkbox"]:checked + span {
            color: #06b6d4;
            font-weight: 600;
        }
        
        .day-checkbox:has(input[type="checkbox"]:checked) {
            border-color: #06b6d4;
            background: #f0f9ff;
        }
        
        .day-checkbox span {
            font-size: 0.875rem;
            font-weight: 500;
            color: #64748b;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .employee-card {
            animation: fadeIn 0.3s ease-in-out;
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
        <h1>👥 Quản Lý Nhân Viên</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="container">
                <!-- Success/Error Messages -->
                <c:if test="${not empty success}">
                    <div style="background: #dcfce7; color: #166534; padding: 1rem; border-radius: 0.5rem; margin-bottom: 1rem;">
                        ${success}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div style="background: #fee2e2; color: #991b1b; padding: 1rem; border-radius: 0.5rem; margin-bottom: 1rem;">
                        ${error}
                    </div>
                </c:if>

                <!-- Statistics Summary -->
                <div class="stats-summary">
                    <div class="stat-card">
                        <div class="stat-number">${fn:length(employees)}</div>
                        <div class="stat-label">Tổng Nhân Viên</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <c:set var="activeCount" value="0"/>
                            <c:forEach var="user" items="${employees}">
                                <c:if test="${user.active}">
                                    <c:set var="activeCount" value="${activeCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${activeCount}
                        </div>
                        <div class="stat-label">Đang Hoạt Động</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <c:set var="doctorCount" value="0"/>
                            <c:forEach var="user" items="${employees}">
                                <c:if test="${fn:toLowerCase(user.role.roleName) eq 'dentist'}">
                                    <c:set var="doctorCount" value="${doctorCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${doctorCount}
                        </div>
                        <div class="stat-label">Bác Sĩ</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <c:set var="staffCount" value="0"/>
                            <c:forEach var="user" items="${employees}">
                                <c:if test="${fn:toLowerCase(user.role.roleName) ne 'dentist'}">
                                    <c:set var="staffCount" value="${staffCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${staffCount}
                        </div>
                        <div class="stat-label">Nhân Viên Khác</div>
                    </div>
                </div>

                <!-- Employee Type Filter -->
                <div class="form-group" style="margin-bottom: 1.5rem;">
                    <label for="employeeTypeFilter" style="font-weight: 600; margin-bottom: 0.5rem; display: block;">Lọc theo loại nhân viên:</label>
                    <select id="employeeTypeFilter" onchange="filterEmployeesByType()" style="padding: 0.75rem; border: 2px solid #e2e8f0; border-radius: 0.5rem; font-size: 1rem; background: white; cursor: pointer; transition: border-color 0.2s ease;">
                        <option value="all">Tất Cả Nhân Viên</option>
                        <option value="dentist">Bác Sĩ (Dentist)</option>
                        <option value="receptionist">Lễ Tân (Receptionist)</option>
                        <option value="nurse">Y Tá (Nurse)</option>
                        <option value="clinicmanager">Quản Lý (Clinic Manager)</option>
                    </select>
                </div>

                <!-- Schedule Management Buttons -->
                <div style="margin-bottom: 1.5rem; display: flex; gap: 1rem; flex-wrap: wrap;">
                    <button onclick="viewAllSchedules()" class="btn btn-primary">
                        📅 Quản Lý Lịch Làm Việc Tổng Thể
                    </button>
                    <button onclick="assignMultipleEmployees()" class="btn btn-success">
                        👥 Phân Công Cho Nhiều Nhân Viên
                    </button>
                </div>

                <!-- Employee Cards -->
                <div class="employee-grid" id="employeeGrid">
                    <c:forEach var="user" items="${employees}">
                        <div class="employee-card" data-role="${fn:toLowerCase(user.role.roleName)}">
                            <div class="employee-header">
                                <div class="employee-avatar">
                                    ${fn:substring(user.fullName, 0, 1)}
                                </div>
                                <div class="employee-info">
                                    <h3>${user.fullName}</h3>
                                    <p>${user.role.roleName}</p>
                                </div>
                            </div>
                            
                            <div class="employee-details">
                                <div class="detail-row">
                                    <span class="detail-label">ID:</span>
                                    <span class="detail-value">${user.userId}</span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">Tên đăng nhập:</span>
                                    <span class="detail-value">${user.username}</span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">Số điện thoại:</span>
                                    <span class="detail-value">${user.phone}</span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">Email:</span>
                                    <span class="detail-value">${user.email}</span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">Ngày tạo:</span>
                                    <span class="detail-value">
                                        <fmt:formatDate value="${user.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </span>
                                </div>
                                <div class="detail-row">
                                    <span class="detail-label">Trạng thái:</span>
                                    <span class="status-badge ${user.active ? 'status-active' : 'status-inactive'}">
                                        ${user.active ? 'Hoạt Động' : 'Không Hoạt Động'}
                                    </span>
                                </div>
                            </div>
                            
                            <div class="employee-actions">
                                <button class="btn-small btn-primary" onclick="assignWorkSchedule(${user.userId}, '${user.fullName}', '${user.role.roleName}')">
                                    📅 Phân Công Lịch Làm Việc
                                </button>
                                <button class="btn-small btn-success" onclick="viewEmployeeSchedule(${user.userId})">
                                    👁️ Xem Lịch Làm Việc
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </main>
    </div>

    <!-- Work Schedule Assignment Modal -->
    <div id="workScheduleModal" class="modal">
        <div class="modal-content" style="max-width: 800px;">
            <div class="modal-header">
                <h2>Phân Công Lịch Làm Việc Theo Tuần</h2>
                <span class="close" onclick="closeWorkScheduleModal()">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/admin/schedules" method="post">
                <input type="hidden" name="action" value="assignWeeklySchedule">
                <input type="hidden" id="scheduleEmployeeId" name="employeeId">
                
                <div class="form-group">
                    <label>Nhân viên: <strong id="scheduleEmployeeName"></strong></label>
                    <input type="hidden" id="scheduleEmployeePosition">
                </div>
                
                <!-- Week Selection -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="weekStart">Tuần từ ngày *</label>
                        <input type="date" id="weekStart" name="weekStart" required onchange="updateWeekDays()">
                    </div>
                    <div class="form-group">
                        <label for="weekEnd">Đến ngày *</label>
                        <input type="date" id="weekEnd" name="weekEnd" required readonly>
                    </div>
                </div>
                
                <!-- Days of Week Selection -->
                <div class="form-group">
                    <label>Chọn các ngày trong tuần:</label>
                    <div class="week-days" style="display: grid; grid-template-columns: repeat(7, 1fr); gap: 0.5rem; margin-top: 0.5rem;">
                        <label class="day-checkbox">
                            <input type="checkbox" name="workDays" value="monday">
                            <span>T2</span>
                        </label>
                        <label class="day-checkbox">
                            <input type="checkbox" name="workDays" value="tuesday">
                            <span>T3</span>
                        </label>
                        <label class="day-checkbox">
                            <input type="checkbox" name="workDays" value="wednesday">
                            <span>T4</span>
                        </label>
                        <label class="day-checkbox">
                            <input type="checkbox" name="workDays" value="thursday">
                            <span>T5</span>
                        </label>
                        <label class="day-checkbox">
                            <input type="checkbox" name="workDays" value="friday">
                            <span>T6</span>
                        </label>
                        <label class="day-checkbox">
                            <input type="checkbox" name="workDays" value="saturday">
                            <span>T7</span>
                        </label>
                        <label class="day-checkbox">
                            <input type="checkbox" name="workDays" value="sunday">
                            <span>CN</span>
                        </label>
                    </div>
                </div>
                
                <!-- Shift Selection -->
                <div class="form-group">
                    <label for="shift">Ca Làm Việc *</label>
                    <select id="shift" name="shift" required>
                        <option value="">Chọn ca</option>
                        <option value="Sáng (7:00-12:00)">Sáng (7:00-12:00)</option>
                        <option value="Chiều (13:00-18:00)">Chiều (13:00-18:00)</option>
                        <option value="Tối (18:00-22:00)">Tối (18:00-22:00)</option>
                        <option value="Cả ngày (7:00-18:00)">Cả ngày (7:00-18:00)</option>
                    </select>
                </div>
                
                <!-- Time Selection -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="startTime">Giờ Bắt Đầu</label>
                        <input type="time" id="startTime" name="startTime">
                    </div>
                    <div class="form-group">
                        <label for="endTime">Giờ Kết Thúc</label>
                        <input type="time" id="endTime" name="endTime">
                    </div>
                </div>
                
                <!-- Notes removed - not supported in database -->
                
                <!-- Preview -->
                <div class="form-group">
                    <label>Xem trước lịch làm việc:</label>
                    <div id="schedulePreview" style="background: #f8fafc; padding: 1rem; border-radius: 0.5rem; margin-top: 0.5rem;">
                        <p style="color: #64748b; font-style: italic;">Chọn tuần và ngày để xem trước</p>
                    </div>
                </div>
                
                <div class="modal-actions">
                    <button type="button" class="btn btn-secondary" onclick="closeWorkScheduleModal()">Hủy</button>
                    <button type="submit" class="btn btn-primary">Phân Công Lịch Tuần</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Multiple Employees Schedule Assignment Modal -->
    <div id="multipleEmployeesModal" class="modal">
        <div class="modal-content" style="max-width: 900px;">
            <div class="modal-header">
                <h2>Phân Công Lịch Làm Việc Cho Nhiều Nhân Viên</h2>
                <span class="close" onclick="closeMultipleEmployeesModal()">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/admin/schedules" method="post">
                <input type="hidden" name="action" value="assignMultipleWeeklySchedule">
                
                <!-- Employee Type Filter for Multiple Selection -->
                <div class="form-group">
                    <label for="multiEmployeeTypeFilter" style="font-weight: 600; margin-bottom: 0.5rem; display: block;">Lọc theo loại nhân viên:</label>
                    <select id="multiEmployeeTypeFilter" onchange="filterMultiEmployeesByType()" style="padding: 0.5rem; border: 1px solid #d1d5db; border-radius: 0.375rem; font-size: 0.875rem; background: white; cursor: pointer; margin-bottom: 1rem;">
                        <option value="all">Tất Cả Nhân Viên</option>
                        <option value="dentist">Bác Sĩ (Dentist)</option>
                        <option value="receptionist">Lễ Tân (Receptionist)</option>
                        <option value="nurse">Y Tá (Nurse)</option>
                        <option value="clinicmanager">Quản Lý (Clinic Manager)</option>
                    </select>
                </div>

                <!-- Employee Selection -->
                <div class="form-group">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                        <label>Chọn nhân viên:</label>
                        <div style="display: flex; gap: 0.5rem;">
                            <button type="button" onclick="selectAllVisibleEmployees()" class="btn-small btn-primary" style="padding: 0.25rem 0.5rem; font-size: 0.75rem;">Chọn Tất Cả</button>
                            <button type="button" onclick="deselectAllEmployees()" class="btn-small btn-secondary" style="padding: 0.25rem 0.5rem; font-size: 0.75rem;">Bỏ Chọn Tất Cả</button>
                        </div>
                    </div>
                    <div class="employee-selection" id="multiEmployeeSelection" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 0.5rem; margin-top: 0.5rem; max-height: 200px; overflow-y: auto;">
                        <c:forEach var="user" items="${employees}">
                            <label class="employee-checkbox" data-role="${fn:toLowerCase(user.role.roleName)}" style="display: flex; align-items: center; padding: 0.5rem; border: 1px solid #e2e8f0; border-radius: 0.5rem; cursor: pointer; transition: all 0.2s ease;">
                                <input type="checkbox" name="selectedEmployees" value="${user.userId}" style="margin-right: 0.5rem;">
                                <span>${user.fullName} (${user.role.roleName})</span>
                            </label>
                        </c:forEach>
                    </div>
                </div>
                
                <!-- Week Selection -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="multiWeekStart">Tuần từ ngày *</label>
                        <input type="date" id="multiWeekStart" name="weekStart" required onchange="updateMultiWeekDays()">
                    </div>
                    <div class="form-group">
                        <label for="multiWeekEnd">Đến ngày *</label>
                        <input type="date" id="multiWeekEnd" name="weekEnd" required readonly>
                    </div>
                </div>
                
                <!-- Days of Week Selection -->
                <div class="form-group">
                    <label>Chọn các ngày trong tuần:</label>
                    <div class="week-days" style="display: grid; grid-template-columns: repeat(7, 1fr); gap: 0.5rem; margin-top: 0.5rem;">
                        <label class="day-checkbox">
                            <input type="checkbox" name="multiWorkDays" value="monday">
                            <span>T2</span>
                        </label>
                        <label class="day-checkbox">
                            <input type="checkbox" name="multiWorkDays" value="tuesday">
                            <span>T3</span>
                        </label>
                        <label class="day-checkbox">
                            <input type="checkbox" name="multiWorkDays" value="wednesday">
                            <span>T4</span>
                        </label>
                        <label class="day-checkbox">
                            <input type="checkbox" name="multiWorkDays" value="thursday">
                            <span>T5</span>
                        </label>
                        <label class="day-checkbox">
                            <input type="checkbox" name="multiWorkDays" value="friday">
                            <span>T6</span>
                        </label>
                        <label class="day-checkbox">
                            <input type="checkbox" name="multiWorkDays" value="saturday">
                            <span>T7</span>
                        </label>
                        <label class="day-checkbox">
                            <input type="checkbox" name="multiWorkDays" value="sunday">
                            <span>CN</span>
                        </label>
                    </div>
                </div>
                
                <!-- Shift Selection -->
                <div class="form-group">
                    <label for="multiShift">Ca Làm Việc *</label>
                    <select id="multiShift" name="shift" required>
                        <option value="">Chọn ca</option>
                        <option value="Sáng (7:00-12:00)">Sáng (7:00-12:00)</option>
                        <option value="Chiều (13:00-18:00)">Chiều (13:00-18:00)</option>
                        <option value="Tối (18:00-22:00)">Tối (18:00-22:00)</option>
                        <option value="Cả ngày (7:00-18:00)">Cả ngày (7:00-18:00)</option>
                    </select>
                </div>
                
                <!-- Time Selection -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="multiStartTime">Giờ Bắt Đầu</label>
                        <input type="time" id="multiStartTime" name="startTime">
                    </div>
                    <div class="form-group">
                        <label for="multiEndTime">Giờ Kết Thúc</label>
                        <input type="time" id="multiEndTime" name="endTime">
                    </div>
                </div>
                
                <!-- Notes removed - not supported in database -->
                
                <!-- Preview -->
                <div class="form-group">
                    <label>Xem trước lịch làm việc:</label>
                    <div id="multiSchedulePreview" style="background: #f8fafc; padding: 1rem; border-radius: 0.5rem; margin-top: 0.5rem;">
                        <p style="color: #64748b; font-style: italic;">Chọn nhân viên, tuần và ngày để xem trước</p>
                    </div>
                </div>
                
                <div class="modal-actions">
                    <button type="button" class="btn btn-secondary" onclick="closeMultipleEmployeesModal()">Hủy</button>
                    <button type="submit" class="btn btn-primary">Phân Công Cho Tất Cả</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Work Schedule Functions
        function assignWorkSchedule(employeeId, fullName, position) {
            document.getElementById('scheduleEmployeeId').value = employeeId;
            document.getElementById('scheduleEmployeeName').textContent = fullName;
            document.getElementById('scheduleEmployeePosition').value = position;
            
            // Set default date to today
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('workDate').value = today;
            
            document.getElementById('workScheduleModal').style.display = 'block';
        }

        function closeWorkScheduleModal() {
            document.getElementById('workScheduleModal').style.display = 'none';
        }

        function viewEmployeeSchedule(employeeId) {
            window.location.href = '${pageContext.request.contextPath}/admin/employee-schedule?employeeId=' + employeeId;
        }

        function viewAllSchedules() {
            window.location.href = '${pageContext.request.contextPath}/admin/schedules';
        }

        function assignMultipleEmployees() {
            document.getElementById('multipleEmployeesModal').style.display = 'block';
        }

        function closeMultipleEmployeesModal() {
            document.getElementById('multipleEmployeesModal').style.display = 'none';
        }

        // Filter employees by type
        function filterEmployeesByType() {
            const selectedType = document.getElementById('employeeTypeFilter').value;
            const employeeCards = document.querySelectorAll('.employee-card');
            
            employeeCards.forEach(card => {
                const role = card.getAttribute('data-role');
                
                if (selectedType === 'all' || role === selectedType) {
                    card.style.display = 'block';
                    card.style.animation = 'fadeIn 0.3s ease-in-out';
                } else {
                    card.style.display = 'none';
                }
            });
            
            // Update statistics based on filtered results
            updateFilteredStatistics();
        }
        
        // Update statistics based on filtered employees
        function updateFilteredStatistics() {
            const selectedType = document.getElementById('employeeTypeFilter').value;
            const visibleCards = document.querySelectorAll('.employee-card[style*="block"], .employee-card:not([style*="none"])');
            
            // Update total count
            const totalCount = selectedType === 'all' ? 
                document.querySelectorAll('.employee-card').length : 
                visibleCards.length;
            
            // You can update the statistics display here if needed
            console.log(`Showing ${totalCount} employees of type: ${selectedType}`);
        }
        
        // Filter employees in multiple selection modal
        function filterMultiEmployeesByType() {
            const selectedType = document.getElementById('multiEmployeeTypeFilter').value;
            const employeeCheckboxes = document.querySelectorAll('#multiEmployeeSelection .employee-checkbox');
            
            employeeCheckboxes.forEach(checkbox => {
                const role = checkbox.getAttribute('data-role');
                
                if (selectedType === 'all' || role === selectedType) {
                    checkbox.style.display = 'flex';
                    checkbox.style.animation = 'fadeIn 0.3s ease-in-out';
                } else {
                    checkbox.style.display = 'none';
                }
            });
        }
        
        // Select all visible employees
        function selectAllVisibleEmployees() {
            const visibleCheckboxes = document.querySelectorAll('#multiEmployeeSelection .employee-checkbox[style*="flex"], #multiEmployeeSelection .employee-checkbox:not([style*="none"])');
            visibleCheckboxes.forEach(checkbox => {
                const input = checkbox.querySelector('input[type="checkbox"]');
                if (input) {
                    input.checked = true;
                }
            });
            updateMultiSchedulePreview();
        }
        
        // Deselect all employees
        function deselectAllEmployees() {
            const allCheckboxes = document.querySelectorAll('#multiEmployeeSelection input[type="checkbox"]');
            allCheckboxes.forEach(checkbox => {
                checkbox.checked = false;
            });
            updateMultiSchedulePreview();
        }

        // Auto-fill time based on shift selection and update preview
        document.addEventListener('DOMContentLoaded', function() {
            const shiftSelect = document.getElementById('shift');
            const startTimeInput = document.getElementById('startTime');
            const endTimeInput = document.getElementById('endTime');
            const weekStartInput = document.getElementById('weekStart');
            const workDaysCheckboxes = document.querySelectorAll('input[name="workDays"]');
            
            // Update time when shift changes
            if (shiftSelect) {
                shiftSelect.addEventListener('change', function() {
                    const shift = this.value;
                    switch(shift) {
                        case 'Sáng (7:00-12:00)':
                            startTimeInput.value = '07:00';
                            endTimeInput.value = '12:00';
                            break;
                        case 'Chiều (13:00-18:00)':
                            startTimeInput.value = '13:00';
                            endTimeInput.value = '18:00';
                            break;
                        case 'Tối (18:00-22:00)':
                            startTimeInput.value = '18:00';
                            endTimeInput.value = '22:00';
                            break;
                        case 'Cả ngày (7:00-18:00)':
                            startTimeInput.value = '07:00';
                            endTimeInput.value = '18:00';
                            break;
                        default:
                            startTimeInput.value = '';
                            endTimeInput.value = '';
                    }
                    updateSchedulePreview();
                });
            }
            
            // Update preview when work days change
            workDaysCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', updateSchedulePreview);
            });
            
            // Update preview when week start changes
            if (weekStartInput) {
                weekStartInput.addEventListener('change', updateSchedulePreview);
            }
            
            // Multiple employees modal logic
            const multiShiftSelect = document.getElementById('multiShift');
            const multiStartTimeInput = document.getElementById('multiStartTime');
            const multiEndTimeInput = document.getElementById('multiEndTime');
            const multiWeekStartInput = document.getElementById('multiWeekStart');
            const multiWorkDaysCheckboxes = document.querySelectorAll('input[name="multiWorkDays"]');
            const selectedEmployeesCheckboxes = document.querySelectorAll('input[name="selectedEmployees"]');
            
            // Update time when shift changes (multiple employees)
            if (multiShiftSelect) {
                multiShiftSelect.addEventListener('change', function() {
                    const shift = this.value;
                    switch(shift) {
                        case 'Sáng (7:00-12:00)':
                            multiStartTimeInput.value = '07:00';
                            multiEndTimeInput.value = '12:00';
                            break;
                        case 'Chiều (13:00-18:00)':
                            multiStartTimeInput.value = '13:00';
                            multiEndTimeInput.value = '18:00';
                            break;
                        case 'Tối (18:00-22:00)':
                            multiStartTimeInput.value = '18:00';
                            multiEndTimeInput.value = '22:00';
                            break;
                        case 'Cả ngày (7:00-18:00)':
                            multiStartTimeInput.value = '07:00';
                            multiEndTimeInput.value = '18:00';
                            break;
                        default:
                            multiStartTimeInput.value = '';
                            multiEndTimeInput.value = '';
                    }
                    updateMultiSchedulePreview();
                });
            }
            
            // Update preview when work days change (multiple employees)
            multiWorkDaysCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', updateMultiSchedulePreview);
            });
            
            // Update preview when week start changes (multiple employees)
            if (multiWeekStartInput) {
                multiWeekStartInput.addEventListener('change', updateMultiSchedulePreview);
            }
            
            // Update preview when employees selection changes
            selectedEmployeesCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', updateMultiSchedulePreview);
            });
        });
        
        // Update week end date when week start changes
        function updateWeekDays() {
            const weekStart = document.getElementById('weekStart').value;
            if (weekStart) {
                const startDate = new Date(weekStart);
                const endDate = new Date(startDate);
                endDate.setDate(startDate.getDate() + 6);
                
                document.getElementById('weekEnd').value = endDate.toISOString().split('T')[0];
                updateSchedulePreview();
            }
        }
        
        // Update schedule preview
        function updateSchedulePreview() {
            const weekStart = document.getElementById('weekStart').value;
            const shift = document.getElementById('shift').value;
            const startTime = document.getElementById('startTime').value;
            const endTime = document.getElementById('endTime').value;
            const selectedDays = Array.from(document.querySelectorAll('input[name="workDays"]:checked')).map(cb => cb.value);
            
            const preview = document.getElementById('schedulePreview');
            
            if (!weekStart || selectedDays.length === 0) {
                preview.innerHTML = '<p style="color: #64748b; font-style: italic;">Chọn tuần và ngày để xem trước</p>';
                return;
            }
            
            let previewHTML = '<div style="font-weight: 600; margin-bottom: 0.5rem;">Lịch làm việc tuần này:</div>';
            
            const startDate = new Date(weekStart);
            const dayNames = ['Chủ Nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy'];
            const dayValues = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
            
            for (let i = 0; i < 7; i++) {
                const currentDate = new Date(startDate);
                currentDate.setDate(startDate.getDate() + i);
                const dayValue = dayValues[currentDate.getDay()];
                
                if (selectedDays.includes(dayValue)) {
                    const dateStr = currentDate.toLocaleDateString('vi-VN');
                    const dayName = dayNames[currentDate.getDay()];
                    const timeStr = startTime && endTime ? `${startTime} - ${endTime}` : shift;
                    
                    previewHTML += `
                        <div style="display: flex; justify-content: space-between; padding: 0.5rem; background: #e0f2fe; border-radius: 0.25rem; margin-bottom: 0.25rem;">
                            <span><strong>${dayName}</strong> (${dateStr})</span>
                            <span style="color: #0369a1;">${timeStr}</span>
                        </div>
                    `;
                }
            }
            
            preview.innerHTML = previewHTML;
        }
        
        // Update multi week end date when week start changes
        function updateMultiWeekDays() {
            const weekStart = document.getElementById('multiWeekStart').value;
            if (weekStart) {
                const startDate = new Date(weekStart);
                const endDate = new Date(startDate);
                endDate.setDate(startDate.getDate() + 6);
                
                document.getElementById('multiWeekEnd').value = endDate.toISOString().split('T')[0];
                updateMultiSchedulePreview();
            }
        }
        
        // Update multiple employees schedule preview
        function updateMultiSchedulePreview() {
            const weekStart = document.getElementById('multiWeekStart').value;
            const shift = document.getElementById('multiShift').value;
            const startTime = document.getElementById('multiStartTime').value;
            const endTime = document.getElementById('multiEndTime').value;
            const selectedDays = Array.from(document.querySelectorAll('input[name="multiWorkDays"]:checked')).map(cb => cb.value);
            const selectedEmployees = Array.from(document.querySelectorAll('input[name="selectedEmployees"]:checked')).map(cb => cb.value);
            
            const preview = document.getElementById('multiSchedulePreview');
            
            if (!weekStart || selectedDays.length === 0 || selectedEmployees.length === 0) {
                preview.innerHTML = '<p style="color: #64748b; font-style: italic;">Chọn nhân viên, tuần và ngày để xem trước</p>';
                return;
            }
            
            let previewHTML = `<div style="font-weight: 600; margin-bottom: 0.5rem;">Lịch làm việc cho ${selectedEmployees.length} nhân viên:</div>`;
            
            const startDate = new Date(weekStart);
            const dayNames = ['Chủ Nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy'];
            const dayValues = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
            
            for (let i = 0; i < 7; i++) {
                const currentDate = new Date(startDate);
                currentDate.setDate(startDate.getDate() + i);
                const dayValue = dayValues[currentDate.getDay()];
                
                if (selectedDays.includes(dayValue)) {
                    const dateStr = currentDate.toLocaleDateString('vi-VN');
                    const dayName = dayNames[currentDate.getDay()];
                    const timeStr = startTime && endTime ? `${startTime} - ${endTime}` : shift;
                    
                    previewHTML += `
                        <div style="display: flex; justify-content: space-between; padding: 0.5rem; background: #e0f2fe; border-radius: 0.25rem; margin-bottom: 0.25rem;">
                            <span><strong>${dayName}</strong> (${dateStr})</span>
                            <span style="color: #0369a1;">${timeStr} - ${selectedEmployees.length} nhân viên</span>
                        </div>
                    `;
                }
            }
            
            preview.innerHTML = previewHTML;
        }

        // Close modals when clicking outside
        window.onclick = function(event) {
            const workScheduleModal = document.getElementById('workScheduleModal');
            const multipleEmployeesModal = document.getElementById('multipleEmployeesModal');
            
            if (event.target === workScheduleModal) {
                closeWorkScheduleModal();
            }
            if (event.target === multipleEmployeesModal) {
                closeMultipleEmployeesModal();
            }
        }
    </script>
</body>
</html>
