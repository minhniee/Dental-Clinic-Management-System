<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Làm Việc - ${employee.fullName} - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        /* Container và Layout */
        .employee-schedule-container {
            background: #ffffff;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
            margin-bottom: 1.5rem;
            max-width: 100%;
            overflow-x: auto;
        }
        
        /* Employee Header */
        .employee-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #06b6d4;
        }
        
        .employee-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            font-weight: bold;
            color: white;
            flex-shrink: 0;
        }
        
        .employee-info h2 {
            color: #0f172a;
            margin: 0;
            font-size: 1.25rem;
            font-weight: 600;
        }
        
        .employee-info p {
            color: #64748b;
            margin: 0.25rem 0 0 0;
            font-size: 0.875rem;
        }
        
        /* Week Navigation */
        .week-navigation {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }
        
        .week-info {
            text-align: center;
            flex: 1;
            min-width: 200px;
        }
        
        .week-info h3 {
            color: #0f172a;
            margin-bottom: 0.25rem;
            font-size: 1.125rem;
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
        
        /* Schedule Grid - Responsive */
        .schedule-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 0.75rem;
            margin-bottom: 1.5rem;
            max-width: 100%;
        }
        
        @media (min-width: 768px) {
            .schedule-grid {
                grid-template-columns: repeat(7, 1fr);
            }
        }
        
        .day-column {
            background: #f8fafc;
            border-radius: 0.75rem;
            padding: 0.75rem;
            border: 1px solid #e2e8f0;
            min-height: 200px;
            max-width: 100%;
        }
        
        .day-header {
            text-align: center;
            margin-bottom: 0.75rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .day-name {
            font-weight: 600;
            color: #0f172a;
            font-size: 0.8rem;
            margin-bottom: 0.25rem;
        }
        
        .day-date {
            font-size: 0.7rem;
            color: #64748b;
        }
        
        /* Schedule Slots */
        .schedule-slot {
            background: #f0f9ff;
            border: 1px solid #06b6d4;
            border-radius: 0.5rem;
            padding: 0.5rem;
            margin-bottom: 0.5rem;
            font-size: 0.75rem;
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
            font-size: 0.75rem;
            margin-bottom: 0.25rem;
            line-height: 1.2;
        }
        
        .shift-type {
            color: #475569;
            font-size: 0.7rem;
            font-weight: 500;
            margin-bottom: 0.25rem;
            line-height: 1.2;
        }
        
        .room-info {
            color: #0369a1;
            font-size: 0.65rem;
            font-weight: 500;
            margin-bottom: 0.25rem;
            line-height: 1.2;
        }
        
        .status-badge {
            display: inline-block;
            padding: 0.15rem 0.4rem;
            border-radius: 0.25rem;
            font-size: 0.6rem;
            font-weight: 700;
            margin-top: 0.25rem;
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
            font-size: 0.75rem;
            text-align: center;
            padding: 1rem 0.5rem;
            background: #f8fafc;
            border-radius: 0.5rem;
            border: 1px dashed #cbd5e1;
            margin-top: 0.5rem;
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
            .employee-schedule-container {
                padding: 1rem;
                margin: 0.5rem;
            }
            
            .employee-header {
                flex-direction: column;
                text-align: center;
                gap: 0.75rem;
            }
            
            .week-navigation {
                flex-direction: column;
                gap: 0.5rem;
            }
            
            .week-info {
                order: -1;
            }
            
            .schedule-grid {
                grid-template-columns: 1fr;
                gap: 0.5rem;
            }
            
            .day-column {
                min-height: auto;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .action-buttons .btn {
                width: 100%;
                max-width: 250px;
            }
            
            .legend {
                gap: 1rem;
            }
        }
        
        @media (max-width: 480px) {
            .employee-info h2 {
                font-size: 1.125rem;
            }
            
            .week-info h3 {
                font-size: 1rem;
            }
            
            .schedule-slot {
                padding: 0.4rem;
                font-size: 0.7rem;
            }
            
            .shift-time {
                font-size: 0.7rem;
            }
            
            .shift-type {
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
    <c:if test="${_role ne 'administrator'}">
        <c:redirect url="${pageContext.request.contextPath}/login"/>
    </c:if>
    
    <div class="header">
        <h1>👤 Lịch Làm Việc Nhân Viên</h1>
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

                <div class="employee-schedule-container">
                    <!-- Employee Header -->
                    <div class="employee-header">
                        <div class="employee-avatar" style="background: #06b6d4;">
                            ${fn:substring(employee.fullName, 0, 1)}
                        </div>
                        <div class="employee-info">
                            <h2>${employee.fullName}</h2>
                            <p>${employee.role.roleName} • ID: ${employee.userId}</p>
                        </div>
                    </div>
                    
                    <!-- Week Navigation -->
                    <div class="week-navigation">
                        <a href="?employeeId=${employee.userId}&week=${previousWeek}" class="btn btn-secondary">← Tuần Trước</a>
                        <div class="week-info">
                            <h3>Lịch Làm Việc Tuần</h3>
                            <p>${weekStart} - ${weekEnd}</p>
                        </div>
                        <a href="?employeeId=${employee.userId}&week=${nextWeek}" class="btn btn-secondary">Tuần Sau →</a>
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
                    
                    <!-- Schedule Grid -->
                    <div class="schedule-grid">
                        <c:forEach var="dayIndex" begin="0" end="6">
                            <c:set var="currentDay" value="${weekStart.plusDays(dayIndex)}"/>
                            <c:set var="daySchedules" value="${scheduleMatrix[dayIndex]}"/>
                            <div class="day-column">
                                <div class="day-header">
                                    <div class="day-name">
                                        <c:choose>
                                            <c:when test="${dayIndex == 0}">Thứ 2</c:when>
                                            <c:when test="${dayIndex == 1}">Thứ 3</c:when>
                                            <c:when test="${dayIndex == 2}">Thứ 4</c:when>
                                            <c:when test="${dayIndex == 3}">Thứ 5</c:when>
                                            <c:when test="${dayIndex == 4}">Thứ 6</c:when>
                                            <c:when test="${dayIndex == 5}">Thứ 7</c:when>
                                            <c:when test="${dayIndex == 6}">Chủ Nhật</c:when>
                                        </c:choose>
                                    </div>
                                    <div class="day-date">${currentDay}</div>
                                </div>
                                
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
                                                <div class="shift-time">${schedule.startTime} - ${schedule.endTime}</div>
                                                <div class="shift-type">${schedule.shift}</div>
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
                                        <div class="empty-slot">Không có ca</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/admin/schedules?employeeId=${employee.userId}" class="btn btn-primary">
                            📅 Phân Công Lịch Mới
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/employees" class="btn btn-secondary">
                            👥 Quản Lý Nhân Viên
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/weekly-schedule" class="btn btn-success">
                            📊 Lịch Tuần Tổng Thể
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
