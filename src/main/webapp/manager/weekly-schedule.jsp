<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Làm Việc Tuần - Manager - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        /* Container và Layout */
        .schedule-container {
            background: #ffffff;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
            margin-bottom: 1.5rem;
            max-width: 100%;
            overflow-x: auto;
        }
        
        /* Header */
        .schedule-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #06b6d4;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .week-navigation {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            flex-wrap: wrap;
        }
        
        .week-info {
            text-align: center;
            min-width: 200px;
        }
        
        .week-info h2 {
            color: #0f172a;
            margin-bottom: 0.25rem;
            font-size: 1.25rem;
        }
        
        .week-info p {
            color: #64748b;
            font-size: 0.875rem;
        }
        
        /* Buttons */
        .btn {
            padding: 0.5rem 0.75rem;
            border-radius: 0.5rem;
            border: none;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            font-size: 0.875rem;
            white-space: nowrap;
        }
        
        .btn-primary {
            background: #06b6d4;
            color: white;
        }
        
        .btn-primary:hover {
            background: #0891b2;
            transform: translateY(-1px);
        }
        
        .btn-secondary {
            background: #6b7280;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #4b5563;
            transform: translateY(-1px);
        }
        
        .btn-success {
            background: #10b981;
            color: white;
        }
        
        .btn-success:hover {
            background: #059669;
            transform: translateY(-1px);
        }
        
        /* Table */
        .schedule-table {
            width: 100%;
            border-collapse: collapse;
            background: #ffffff;
            border-radius: 0.75rem;
            overflow: hidden;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            min-width: 800px;
        }
        
        .schedule-table th {
            background: #06b6d4;
            color: white;
            padding: 0.75rem 0.5rem;
            text-align: center;
            font-weight: 600;
            border: 1px solid #0891b2;
            font-size: 0.8rem;
        }
        
        .schedule-table td {
            padding: 0.5rem;
            text-align: center;
            border: 1px solid #e2e8f0;
            vertical-align: top;
            min-height: 60px;
            max-width: 120px;
        }
        
        .employee-name {
            font-weight: 600;
            color: #0f172a;
            text-align: left;
            padding: 0.5rem;
            background: #f8fafc;
            border-right: 2px solid #06b6d4;
            font-size: 0.8rem;
            line-height: 1.3;
            min-width: 120px;
            max-width: 150px;
        }
        
        .employee-role {
            color: #64748b;
            font-size: 0.7rem;
            font-weight: 400;
            margin-top: 0.25rem;
        }
        
        .day-header {
            font-weight: 600;
            font-size: 0.75rem;
        }
        
        .day-date {
            font-size: 0.65rem;
            color: #64748b;
            margin-top: 0.25rem;
        }
        
        /* Schedule Slots */
        .schedule-slot {
            background: #f0f9ff;
            border: 1px solid #06b6d4;
            border-radius: 0.5rem;
            padding: 0.5rem;
            margin-bottom: 0.4rem;
            font-size: 0.7rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            transition: all 0.2s ease;
            word-wrap: break-word;
            overflow-wrap: break-word;
        }
        
        .schedule-slot:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }
        
        .schedule-slot.morning {
            background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%);
            border-color: #16a34a;
            border-left: 3px solid #16a34a;
        }
        
        .schedule-slot.afternoon {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border-color: #d97706;
            border-left: 3px solid #d97706;
        }
        
        .schedule-slot.evening {
            background: linear-gradient(135deg, #fce7f3 0%, #fbcfe8 100%);
            border-color: #be185d;
            border-left: 3px solid #be185d;
        }
        
        .schedule-slot.full-day {
            background: linear-gradient(135deg, #e0f2fe 0%, #bae6fd 100%);
            border-color: #0284c7;
            border-left: 3px solid #0284c7;
        }
        
        .shift-time {
            font-weight: 700;
            color: #0f172a;
            font-size: 0.7rem;
            margin-bottom: 0.2rem;
            line-height: 1.2;
        }
        
        .room-info {
            color: #0369a1;
            font-size: 0.6rem;
            font-weight: 500;
            margin-bottom: 0.2rem;
            line-height: 1.2;
        }
        
        .status-badge {
            display: inline-block;
            padding: 0.1rem 0.3rem;
            border-radius: 0.25rem;
            font-size: 0.55rem;
            font-weight: 700;
            margin-top: 0.2rem;
            text-transform: uppercase;
            letter-spacing: 0.025em;
            line-height: 1;
        }
        
        .status-active {
            background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%);
            color: #166534;
            border: 1px solid #16a34a;
        }
        
        .status-locked {
            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
            color: #991b1b;
            border: 1px solid #dc2626;
        }
        
        .status-cancelled {
            background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
            color: #6b7280;
            border: 1px solid #9ca3af;
        }
        
        .empty-slot {
            color: #94a3b8;
            font-style: italic;
            font-size: 0.7rem;
            text-align: center;
            padding: 0.75rem 0.25rem;
            background: #f8fafc;
            border-radius: 0.375rem;
            border: 1px dashed #cbd5e1;
        }
        
        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.75rem;
            margin-top: 1.5rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .action-buttons .btn {
            flex: 1;
            min-width: 140px;
            max-width: 200px;
        }
        
        /* Legend */
        .legend {
            display: flex;
            justify-content: center;
            gap: 1.5rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.8rem;
        }
        
        .legend-color {
            width: 14px;
            height: 14px;
            border-radius: 0.25rem;
            flex-shrink: 0;
        }
        
        .legend-morning {
            background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%);
            border: 1px solid #16a34a;
            border-left: 3px solid #16a34a;
        }
        
        .legend-afternoon {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border: 1px solid #d97706;
            border-left: 3px solid #d97706;
        }
        
        .legend-evening {
            background: linear-gradient(135deg, #fce7f3 0%, #fbcfe8 100%);
            border: 1px solid #be185d;
            border-left: 3px solid #be185d;
        }
        
        .legend-full-day {
            background: linear-gradient(135deg, #e0f2fe 0%, #bae6fd 100%);
            border: 1px solid #0284c7;
            border-left: 3px solid #0284c7;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .schedule-container {
                padding: 1rem;
                margin: 0.5rem;
            }
            
            .schedule-header {
                flex-direction: column;
                align-items: stretch;
                gap: 1rem;
            }
            
            .week-navigation {
                justify-content: center;
            }
            
            .schedule-table {
                min-width: 600px;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .action-buttons .btn {
                width: 100%;
                max-width: 250px;
            }
        }
        
        @media (max-width: 480px) {
            .week-info h2 {
                font-size: 1.125rem;
            }
            
            .schedule-slot {
                padding: 0.4rem;
                font-size: 0.65rem;
            }
            
            .shift-time {
                font-size: 0.65rem;
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
        <h1>📅 Lịch Làm Việc Tuần</h1>
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

                <div class="schedule-container">
                    <!-- Schedule Header -->
                    <div class="schedule-header">
                        <div class="week-navigation">
                            <a href="?week=${previousWeek}" class="btn btn-secondary">← Tuần Trước</a>
                            <div class="week-info">
                                <h2>Lịch Làm Việc Tuần</h2>
                                <p>${weekStart} - ${weekEnd}</p>
                            </div>
                            <a href="?week=${nextWeek}" class="btn btn-secondary">Tuần Sau →</a>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/manager/schedules" class="btn btn-success">
                                📅 Phân Công Lịch Mới
                            </a>
                        </div>
                    </div>
                    
                    <!-- Legend -->
                    <div class="legend">
                        <div class="legend-item">
                            <div class="legend-color legend-morning"></div>
                            <span>Ca Sáng</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color legend-afternoon"></div>
                            <span>Ca Chiều</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color legend-evening"></div>
                            <span>Ca Tối</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color legend-full-day"></div>
                            <span>Cả Ngày</span>
                        </div>
                    </div>
                    
                    <!-- Schedule Table -->
                    <div style="overflow-x: auto;">
                        <table class="schedule-table">
                            <thead>
                                <tr>
                                    <th style="width: 150px;">Nhân Viên</th>
                                    <th class="day-header">
                                        Thứ 2<br>
                                        <span class="day-date">${weekStart}</span>
                                    </th>
                                    <th class="day-header">
                                        Thứ 3<br>
                                        <span class="day-date">${weekStart.plusDays(1)}</span>
                                    </th>
                                    <th class="day-header">
                                        Thứ 4<br>
                                        <span class="day-date">${weekStart.plusDays(2)}</span>
                                    </th>
                                    <th class="day-header">
                                        Thứ 5<br>
                                        <span class="day-date">${weekStart.plusDays(3)}</span>
                                    </th>
                                    <th class="day-header">
                                        Thứ 6<br>
                                        <span class="day-date">${weekStart.plusDays(4)}</span>
                                    </th>
                                    <th class="day-header">
                                        Thứ 7<br>
                                        <span class="day-date">${weekStart.plusDays(5)}</span>
                                    </th>
                                    <th class="day-header">
                                        Chủ Nhật<br>
                                        <span class="day-date">${weekStart.plusDays(6)}</span>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="employeeEntry" items="${scheduleMatrix}">
                                    <c:set var="employeeKey" value="${employeeEntry.key}"/>
                                    <c:set var="employeeName" value="${fn:substringAfter(employeeKey, '_')}"/>
                                    <c:set var="employeeId" value="${fn:substringBefore(employeeKey, '_')}"/>
                                    <tr>
                                        <td class="employee-name">
                                            ${employeeName}
                                            <div class="employee-role">(${employeeRoles[employeeKey]})</div>
                                        </td>
                                        <c:forEach var="dayIndex" begin="0" end="6">
                                            <c:set var="currentDay" value="${weekStart.plusDays(dayIndex)}"/>
                                            <c:set var="dayKey" value="${currentDay}"/>
                                            <c:set var="daySchedules" value="${employeeEntry.value[dayKey.toString()]}"/>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty daySchedules}">
                                                        <c:forEach var="schedule" items="${daySchedules}">
                                                            <c:set var="shiftClass" value="full-day"/>
                                                            <c:if test="${fn:contains(schedule.shift, 'Sáng')}">
                                                                <c:set var="shiftClass" value="morning"/>
                                                            </c:if>
                                                            <c:if test="${fn:contains(schedule.shift, 'Chiều')}">
                                                                <c:set var="shiftClass" value="afternoon"/>
                                                            </c:if>
                                                            <c:if test="${fn:contains(schedule.shift, 'Tối')}">
                                                                <c:set var="shiftClass" value="evening"/>
                                                            </c:if>
                                                            <div class="schedule-slot ${shiftClass}">
                                                                <div class="shift-time">
                                                                    <c:set var="startTime" value="${fn:substring(schedule.startTime, 0, 5)}"/>
                                                                    <c:set var="endTime" value="${fn:substring(schedule.endTime, 0, 5)}"/>
                                                                    ${startTime} - ${endTime}
                                                                </div>
                                                                <c:if test="${not empty schedule.roomNo}">
                                                                    <div class="room-info">Phòng: ${schedule.roomNo}</div>
                                                                </c:if>
                                                                <div class="status-badge status-${fn:toLowerCase(schedule.status)}">
                                                                    ${schedule.status}
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="empty-slot">-</div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </c:forEach>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/manager/schedules" class="btn btn-primary">
                            📅 Phân Công Lịch Mới
                        </a>
                        <a href="${pageContext.request.contextPath}/manager/employees" class="btn btn-secondary">
                            👥 Quản Lý Nhân Viên
                        </a>
                        <a href="${pageContext.request.contextPath}/manager/dashboard" class="btn btn-secondary">
                            🏠 Trang Chủ
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
