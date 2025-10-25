<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xem Trước Lịch Làm Việc - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .preview-container {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
            margin-bottom: 2rem;
        }
        
        .preview-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .preview-header h2 {
            color: #0f172a;
            margin-bottom: 0.5rem;
        }
        
        .preview-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
            padding: 1rem;
            background: #f8fafc;
            border-radius: 0.5rem;
        }
        
        .info-item {
            text-align: center;
        }
        
        .info-label {
            color: #64748b;
            font-size: 0.875rem;
            font-weight: 500;
        }
        
        .info-value {
            color: #0f172a;
            font-size: 1.125rem;
            font-weight: 600;
            margin-top: 0.25rem;
        }
        
        .schedule-matrix {
            overflow-x: auto;
            margin-bottom: 2rem;
        }
        
        .matrix-table {
            width: 100%;
            border-collapse: collapse;
            background: #ffffff;
            border-radius: 0.5rem;
            overflow: hidden;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
        }
        
        .matrix-table th {
            background: #06b6d4;
            color: white;
            padding: 1rem;
            text-align: center;
            font-weight: 600;
        }
        
        .matrix-table td {
            padding: 0.75rem;
            text-align: center;
            border: 1px solid #e2e8f0;
        }
        
        .status-new {
            background: #dcfce7;
            color: #166534;
            font-weight: 600;
        }
        
        .status-exists {
            background: #fef3c7;
            color: #92400e;
            font-weight: 600;
        }
        
        .status-locked {
            background: #fee2e2;
            color: #991b1b;
            font-weight: 600;
        }
        
        .legend {
            display: flex;
            justify-content: center;
            gap: 2rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .legend-color {
            width: 20px;
            height: 20px;
            border-radius: 0.25rem;
        }
        
        .legend-new {
            background: #dcfce7;
            border: 1px solid #166534;
        }
        
        .legend-exists {
            background: #fef3c7;
            border: 1px solid #92400e;
        }
        
        .legend-locked {
            background: #fee2e2;
            border: 1px solid #991b1b;
        }
        
        .action-section {
            background: #f8fafc;
            border-radius: 0.5rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .action-section h3 {
            color: #0f172a;
            margin-bottom: 1rem;
        }
        
        .mode-selection {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }
        
        .mode-option {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 0.5rem;
            cursor: pointer;
            transition: all 0.2s ease;
            background: #ffffff;
        }
        
        .mode-option:hover {
            border-color: #06b6d4;
            background: #f0f9ff;
        }
        
        .mode-option input[type="radio"] {
            transform: scale(1.2);
        }
        
        .mode-option input[type="radio"]:checked + label {
            color: #06b6d4;
            font-weight: 600;
        }
        
        .mode-option:has(input[type="radio"]:checked) {
            border-color: #06b6d4;
            background: #f0f9ff;
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
        
        .btn-secondary {
            background: #6b7280;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #4b5563;
        }
        
        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
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
        <h1>👁️ Xem Trước Lịch Làm Việc</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="container">
                <c:if test="${not empty previewData}">
                    <div class="preview-container">
                        <div class="preview-header">
                            <h2>Xem Trước Lịch Làm Việc</h2>
                            <p>Kiểm tra và xác nhận lịch làm việc trước khi lưu</p>
                        </div>
                        
                        <!-- Preview Information -->
                        <div class="preview-info">
                            <div class="info-item">
                                <div class="info-label">Tuần làm việc</div>
                                <div class="info-value">
                                    ${previewData.weekStart} - ${previewData.weekEnd}
                                </div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Số nhân viên</div>
                                <div class="info-value">${fn:length(previewData.employees)}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Số ngày làm việc</div>
                                <div class="info-value">${fn:length(previewData.workDates)}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Ca làm việc</div>
                                <div class="info-value">${previewData.shift}</div>
                            </div>
                        </div>
                        
                        <!-- Legend -->
                        <div class="legend">
                            <div class="legend-item">
                                <div class="legend-color legend-new"></div>
                                <span>Ca mới - Có thể tạo</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-color legend-exists"></div>
                                <span>Đã có ca - Sẽ bỏ qua nếu chọn "Chỉ thêm mới"</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-color legend-locked"></div>
                                <span>Đã khóa - Không thể ghi đè</span>
                            </div>
                        </div>
                        
                        <!-- Schedule Matrix -->
                        <div class="schedule-matrix">
                            <table class="matrix-table">
                                <thead>
                                    <tr>
                                        <th>Nhân Viên</th>
                                        <c:forEach var="workDate" items="${previewData.workDates}">
                                            <th>
                                                ${workDate}
                                                <br>
                                                <small>
                                                    <c:choose>
                                                        <c:when test="${workDate.dayOfWeek.value == 1}">CN</c:when>
                                                        <c:when test="${workDate.dayOfWeek.value == 2}">T2</c:when>
                                                        <c:when test="${workDate.dayOfWeek.value == 3}">T3</c:when>
                                                        <c:when test="${workDate.dayOfWeek.value == 4}">T4</c:when>
                                                        <c:when test="${workDate.dayOfWeek.value == 5}">T5</c:when>
                                                        <c:when test="${workDate.dayOfWeek.value == 6}">T6</c:when>
                                                        <c:when test="${workDate.dayOfWeek.value == 7}">T7</c:when>
                                                    </c:choose>
                                                </small>
                                            </th>
                                        </c:forEach>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="employee" items="${previewData.employees}">
                                        <tr>
                                            <td style="font-weight: 600; text-align: left;">
                                                ${employee.fullName}<br>
                                                <small style="color: #64748b;">${employee.role.roleName}</small>
                                            </td>
                                            <c:forEach var="workDate" items="${previewData.workDates}">
                                                <c:set var="scheduleKey" value="${employee.userId}_${workDate}"/>
                                                <c:set var="status" value="${previewData.scheduleStatus[scheduleKey]}"/>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${status == 'NEW'}">
                                                            <span class="status-new">MỚI</span>
                                                        </c:when>
                                                        <c:when test="${status == 'EXISTS'}">
                                                            <span class="status-exists">TRÙNG</span>
                                                        </c:when>
                                                        <c:when test="${status == 'LOCKED'}">
                                                            <span class="status-locked">KHÓA</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: #64748b;">-</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </c:forEach>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Hidden Form for Commit -->
                        <form id="commitForm" method="post" action="${pageContext.request.contextPath}/manager/schedules" style="display: none;">
                            <input type="hidden" name="action" value="commit">
                            <input type="hidden" name="mode" id="commitMode" value="ONLYNEW">
                            <input type="hidden" name="weekStart" value="${previewData.weekStart}">
                            <input type="hidden" name="weekEnd" value="${previewData.weekEnd}">
                            <c:forEach var="employee" items="${previewData.employees}">
                                <input type="hidden" name="selectedEmployees" value="${employee.userId}">
                            </c:forEach>
                            <c:forEach var="workDate" items="${previewData.workDates}">
                                <input type="hidden" name="workDays" value="${workDate.dayOfWeek.name().toLowerCase()}">
                            </c:forEach>
                            <input type="hidden" name="shift" value="${previewData.shift}">
                            <input type="hidden" name="startTime" value="${previewData.startTime}">
                            <input type="hidden" name="endTime" value="${previewData.endTime}">
                            <input type="hidden" name="roomNo" value="${previewData.roomNo}">
                            <input type="hidden" name="notes" value="${previewData.notes}">
                        </form>

                        <!-- Action Section -->
                        <div class="action-section">
                            <h3>Chọn Chế Độ Lưu:</h3>
                            <div class="mode-selection">
                                <div class="mode-option">
                                    <input type="radio" id="onlyNew" name="mode" value="ONLYNEW" checked>
                                    <label for="onlyNew">
                                        <strong>✅ Chỉ thêm mới (ONLYNEW)</strong><br>
                                        <small>Bỏ qua ca trùng và ca khóa, chỉ thêm ca mới</small>
                                    </label>
                                </div>
                                <div class="mode-option">
                                    <input type="radio" id="upsert" name="mode" value="UPSERT">
                                    <label for="upsert">
                                        <strong>🔁 Ghi đè (UPSERT)</strong><br>
                                        <small>Xóa ca trùng (chưa khóa) và thêm lại ca mới</small>
                                    </label>
                                </div>
                            </div>
                            
                            <div class="action-buttons">
                                <a href="${pageContext.request.contextPath}/manager/schedules" class="btn btn-secondary">
                                    ← Quay Lại
                                </a>
                                <button onclick="commitSchedule()" class="btn btn-primary">
                                    📅 Phân Công Cho Tất Cả
                                </button>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${empty previewData}">
                    <div class="preview-container">
                        <div style="text-align: center; padding: 2rem;">
                            <h2>Không có dữ liệu để xem trước</h2>
                            <p>Vui lòng quay lại và chọn đầy đủ thông tin.</p>
                            <a href="${pageContext.request.contextPath}/manager/schedules" class="btn btn-primary">
                                Quay Lại
                            </a>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>
    </div>

    <script>
        function commitSchedule() {
            const mode = document.querySelector('input[name="mode"]:checked').value;
            
            // Show loading message
            alert('Đang xử lý phân công lịch làm việc...');
            
            // Update the hidden form with selected mode
            document.getElementById('commitMode').value = mode;
            
            // Submit the form
            document.getElementById('commitForm').submit();
        }
    </script>
</body>
</html>
