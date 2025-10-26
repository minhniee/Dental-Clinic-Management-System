<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Lịch Làm Việc - Manager - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .schedule-form {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
            margin-bottom: 2rem;
        }
        
        .form-section {
            margin-bottom: 2rem;
        }
        
        .form-section h3 {
            color: #0f172a;
            font-size: 1.125rem;
            font-weight: 600;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #06b6d4;
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
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 0.5rem;
            border: 1px solid #d1d5db;
            border-radius: 0.375rem;
            font-size: 0.875rem;
        }
        
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #06b6d4;
            box-shadow: 0 0 0 3px rgba(6, 182, 212, 0.1);
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
        
        .employee-selection {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 0.5rem;
            margin-top: 0.5rem;
            max-height: 200px;
            overflow-y: auto;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            padding: 1rem;
        }
        
        .employee-checkbox {
            display: flex;
            align-items: center;
            padding: 0.5rem;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .employee-checkbox:hover {
            border-color: #06b6d4;
            background: #f0f9ff;
        }
        
        .employee-checkbox input[type="checkbox"] {
            margin-right: 0.5rem;
            transform: scale(1.1);
        }
        
        .week-days {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 0.5rem;
            margin-top: 0.5rem;
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
        
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            border: none;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-primary {
            background: #06b6d4;
            color: white;
        }
        
        .btn-primary:hover {
            background: #0891b2;
        }
        
        .btn-success {
            background: #10b981;
            color: white;
        }
        
        .btn-success:hover {
            background: #059669;
        }
        
        .btn-warning {
            background: #f59e0b;
            color: white;
        }
        
        .btn-warning:hover {
            background: #d97706;
        }
        
        .btn-secondary {
            background: #6b7280;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #4b5563;
        }
        
        .preview-section {
            background: #f8fafc;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-top: 1rem;
        }
        
        .preview-section h4 {
            color: #0f172a;
            margin-bottom: 0.5rem;
        }
        
        .preview-item {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem;
            background: #e0f2fe;
            border-radius: 0.25rem;
            margin-bottom: 0.25rem;
        }
        
        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
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
        <h1>📅 Quản Lý Lịch Làm Việc</h1>
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

                <!-- Schedule Assignment Form -->
                <div class="schedule-form">
                    <h2>Phân Công Lịch Làm Việc</h2>
                    
                    <form action="${pageContext.request.contextPath}/manager/schedules" method="post" id="scheduleForm">
                        <input type="hidden" name="action" value="preview">
                        
                        <!-- Employee Type Filter -->
                        <div class="form-section">
                            <h3>1. Chọn Loại Nhân Viên</h3>
                            <div class="form-group">
                                <label for="employeeTypeFilter">Lọc theo loại nhân viên:</label>
                                <select id="employeeTypeFilter" onchange="filterEmployeesByType()">
                                    <option value="all">Tất Cả Nhân Viên</option>
                                    <option value="dentist">Bác Sĩ (Dentist)</option>
                                    <option value="receptionist">Lễ Tân (Receptionist)</option>
                                    <option value="nurse">Y Tá (Nurse)</option>
                                    <option value="clinicmanager">Quản Lý (Clinic Manager)</option>
                                </select>
                            </div>
                        </div>
                        
                        <!-- Employee Selection -->
                        <div class="form-section">
                            <h3>2. Chọn Nhân Viên</h3>
                            <div class="form-group">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                                    <label>Chọn nhân viên cần phân công:</label>
                                    <div style="display: flex; gap: 0.5rem;">
                                        <button type="button" onclick="selectAllVisibleEmployees()" class="btn btn-primary" style="padding: 0.25rem 0.5rem; font-size: 0.75rem;">Chọn Tất Cả</button>
                                        <button type="button" onclick="deselectAllEmployees()" class="btn btn-secondary" style="padding: 0.25rem 0.5rem; font-size: 0.75rem;">Bỏ Chọn Tất Cả</button>
                                    </div>
                                </div>
                                <div class="employee-selection" id="employeeSelection">
                                    <c:forEach var="user" items="${employees}">
                                        <label class="employee-checkbox" data-role="${fn:toLowerCase(user.role.roleName)}">
                                            <input type="checkbox" name="selectedEmployees" value="${user.userId}">
                                            <span>${user.fullName} (${user.role.roleName})</span>
                                        </label>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Week Selection -->
                        <div class="form-section">
                            <h3>3. Chọn Tuần Làm Việc</h3>
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="weekStart">Tuần từ ngày *</label>
                                    <input type="date" id="weekStart" name="weekStart" required onchange="updateWeekEnd()">
                                </div>
                                <div class="form-group">
                                    <label for="weekEnd">Đến ngày *</label>
                                    <input type="date" id="weekEnd" name="weekEnd" required readonly>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Days of Week Selection -->
                        <div class="form-section">
                            <h3>4. Chọn Ngày Trong Tuần</h3>
                            <div class="form-group">
                                <label>Chọn các ngày trong tuần sẽ làm việc:</label>
                                <div class="week-days">
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
                        </div>
                        
                        <!-- Shift Selection -->
                        <div class="form-section">
                            <h3>5. Chọn Ca Làm Việc</h3>
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="shift">Ca Làm Việc *</label>
                                    <select id="shift" name="shift" required onchange="updateTimeFields()">
                                        <option value="">Chọn ca</option>
                                        <option value="Sáng (7:00-12:00)">Sáng (7:00-12:00)</option>
                                        <option value="Chiều (13:00-18:00)">Chiều (13:00-18:00)</option>
                                        <option value="Tối (18:00-22:00)">Tối (18:00-22:00)</option>
                                        <option value="Cả ngày (7:00-18:00)">Cả ngày (7:00-18:00)</option>
                                        <option value="Tùy chỉnh">Tùy chỉnh</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="roomNo">Phòng Khám</label>
                                    <input type="text" id="roomNo" name="roomNo" placeholder="VD: P001, P002...">
                                </div>
                            </div>
                            
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
                        </div>
                        
                        <!-- Notes -->
                        <!-- Notes section removed - not supported in database -->
                        
                        <!-- Preview Section -->
                        <div class="preview-section" id="previewSection" style="display: none;">
                            <h4>Xem Trước Lịch Làm Việc:</h4>
                            <div id="schedulePreview">
                                <p style="color: #64748b; font-style: italic;">Chọn đầy đủ thông tin để xem trước</p>
                            </div>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/manager/weekly-schedule" class="btn btn-secondary">
                                📊 Xem Lịch Tuần
                            </a>
                            <button type="submit" class="btn btn-primary">
                                📅 Phân Công Lịch Làm Việc
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Filter employees by type
        function filterEmployeesByType() {
            const selectedType = document.getElementById('employeeTypeFilter').value;
            const employeeCheckboxes = document.querySelectorAll('#employeeSelection .employee-checkbox');
            
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
            const visibleCheckboxes = document.querySelectorAll('#employeeSelection .employee-checkbox[style*="flex"], #employeeSelection .employee-checkbox:not([style*="none"])');
            visibleCheckboxes.forEach(checkbox => {
                const input = checkbox.querySelector('input[type="checkbox"]');
                if (input) {
                    input.checked = true;
                }
            });
        }
        
        // Deselect all employees
        function deselectAllEmployees() {
            const allCheckboxes = document.querySelectorAll('#employeeSelection input[type="checkbox"]');
            allCheckboxes.forEach(checkbox => {
                checkbox.checked = false;
            });
        }
        
        // Update week end date
        function updateWeekEnd() {
            const weekStart = document.getElementById('weekStart').value;
            if (weekStart) {
                const startDate = new Date(weekStart);
                const endDate = new Date(startDate);
                endDate.setDate(startDate.getDate() + 6);
                
                document.getElementById('weekEnd').value = endDate.toISOString().split('T')[0];
            }
        }
        
        // Update time fields based on shift selection
        function updateTimeFields() {
            const shift = document.getElementById('shift').value;
            const startTimeInput = document.getElementById('startTime');
            const endTimeInput = document.getElementById('endTime');
            
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
                case 'Tùy chỉnh':
                    startTimeInput.value = '';
                    endTimeInput.value = '';
                    break;
                default:
                    startTimeInput.value = '';
                    endTimeInput.value = '';
            }
        }
        
        // Generate preview
        function generatePreview() {
            const weekStart = document.getElementById('weekStart').value;
            const weekEnd = document.getElementById('weekEnd').value;
            const selectedEmployees = Array.from(document.querySelectorAll('input[name="selectedEmployees"]:checked')).map(cb => cb.value);
            const selectedDays = Array.from(document.querySelectorAll('input[name="workDays"]:checked')).map(cb => cb.value);
            const shift = document.getElementById('shift').value;
            const startTime = document.getElementById('startTime').value;
            const endTime = document.getElementById('endTime').value;
            const roomNo = document.getElementById('roomNo').value;
            
            if (!weekStart || selectedEmployees.length === 0 || selectedDays.length === 0 || !shift) {
                alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                return;
            }
            
            // Show preview section
            document.getElementById('previewSection').style.display = 'block';
            
            // Generate preview content
            let previewHTML = '<div style="font-weight: 600; margin-bottom: 0.5rem;">Lịch làm việc sẽ được tạo:</div>';
            
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
                        <div class="preview-item">
                            <span><strong>${dayName}</strong> (${dateStr})</span>
                            <span style="color: #0369a1;">${timeStr} - ${selectedEmployees.length} nhân viên</span>
                        </div>
                    `;
                }
            }
            
            document.getElementById('schedulePreview').innerHTML = previewHTML;
        }
        
        // Set default date to today
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('weekStart').value = today;
            updateWeekEnd();
        });
    </script>
</body>
</html>
