<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Hẹn Theo Tuần - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .calendar-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .calendar-header {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }
        
        .calendar-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }
        
        .calendar-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #0f172a;
            margin: 0;
        }
        
        .nav-buttons {
            display: flex;
            gap: 1rem;
            align-items: center;
        }
        
        .btn {
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: all 0.2s ease-in-out;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.875rem;
        }
        
        .btn-primary {
            background-color: #06b6d4;
            color: #ffffff;
        }
        
        .btn-primary:hover {
            background-color: #0891b2;
        }
        
        .btn-secondary {
            background-color: #64748b;
            color: #ffffff;
        }
        
        .btn-secondary:hover {
            background-color: #475569;
        }
        
        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 1px;
            background-color: #e2e8f0;
            border-radius: 0.75rem;
            overflow: hidden;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
        }
        
        .calendar-day-header {
            background-color: #f8fafc;
            padding: 1rem;
            text-align: center;
            font-weight: 600;
            color: #0f172a;
            font-size: 0.875rem;
        }
        
        .calendar-day {
            background-color: #ffffff;
            min-height: 120px;
            padding: 0.5rem;
            border: 1px solid #e2e8f0;
            position: relative;
        }
        
        .calendar-day.other-month {
            background-color: #f8fafc;
            color: #94a3b8;
        }
        
        .calendar-day.today {
            background-color: #f0f9ff;
            border-color: #06b6d4;
        }
        
        .day-number {
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 0.5rem;
        }
        
        .appointment-item {
            background-color: #06b6d4;
            color: #ffffff;
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
            font-size: 0.75rem;
            margin-bottom: 0.25rem;
            cursor: pointer;
            transition: all 0.2s ease-in-out;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .appointment-item:hover {
            background-color: #0891b2;
        }
        
        .appointment-item.scheduled {
            background-color: #dbeafe;
            color: #2563eb;
        }
        
        .appointment-item.confirmed {
            background-color: #d1fae5;
            color: #059669;
        }
        
        .appointment-item.completed {
            background-color: #f0fdf4;
            color: #16a34a;
        }
        
        .appointment-item.cancelled {
            background-color: #fef2f2;
            color: #dc2626;
        }
        
        .calendar-filters {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }
        
        .filters-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            align-items: end;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-group label {
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }
        
        .form-control {
            padding: 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #06b6d4;
            box-shadow: 0 0 0 3px rgba(6, 182, 212, 0.1);
        }
        
        .legend {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            margin-top: 1rem;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.875rem;
        }
        
        .legend-color {
            width: 1rem;
            height: 1rem;
            border-radius: 0.25rem;
        }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>
    
    <c:set var="_role" value="${empty sessionScope.user or empty sessionScope.user.role or empty sessionScope.user.role.roleName ? '' : fn:toLowerCase(fn:replace(sessionScope.user.role.roleName, ' ', ''))}"/>
    <c:if test="${_role ne 'receptionist'}">
        <c:redirect url="${pageContext.request.contextPath}/login"/>
    </c:if>
    
    <div class="dashboard-layout">
        <jsp:include page="../shared/left-navbar.jsp"/>
        
        <main class="main-content">
            <div class="calendar-container">
                <!-- Calendar Header -->
                <div class="calendar-header">
                    <div class="calendar-nav">
                        <h1 class="calendar-title">Lịch Hẹn Theo Tuần</h1>
                        <div class="nav-buttons">
                            <a href="${pageContext.request.contextPath}/receptionist/appointments" class="btn btn-secondary">
                                <i class="fas fa-list"></i>
                                Xem Danh Sách
                            </a>
                            <a href="${pageContext.request.contextPath}/receptionist/appointments?action=new" class="btn btn-primary">
                                <i class="fas fa-calendar-plus"></i>
                                Đặt Lịch Mới
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Filters -->
                <div class="calendar-filters">
                    <form method="GET" action="${pageContext.request.contextPath}/receptionist/appointments">
                        <input type="hidden" name="action" value="calendar">
                        <div class="filters-form">
                            <div class="form-group">
                                <label for="week">Tuần</label>
                                <input type="week" 
                                       id="week" 
                                       name="week" 
                                       class="form-control"
                                       value="${selectedWeek}">
                            </div>
                            <div class="form-group">
                                <label for="dentistId">Bác Sĩ</label>
                                <select id="dentistId" name="dentistId" class="form-control">
                                    <option value="">Tất cả bác sĩ</option>
                                    <c:forEach var="dentist" items="${dentists}">
                                        <option value="${dentist.userId}" ${selectedDentistId eq dentist.userId ? 'selected' : ''}>
                                            ${dentist.fullName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i>
                                    Lọc
                                </button>
                            </div>
                        </div>
                    </form>
                    
                    <!-- Legend -->
                    <div class="legend">
                        <div class="legend-item">
                            <div class="legend-color" style="background-color: #dbeafe;"></div>
                            <span>Đã lên lịch</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color" style="background-color: #d1fae5;"></div>
                            <span>Đã xác nhận</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color" style="background-color: #f0fdf4;"></div>
                            <span>Hoàn thành</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color" style="background-color: #fef2f2;"></div>
                            <span>Đã hủy</span>
                        </div>
                    </div>
                </div>

                <!-- Calendar Grid -->
                <div class="calendar-grid">
                    <!-- Day Headers -->
                    <div class="calendar-day-header">Thứ 2</div>
                    <div class="calendar-day-header">Thứ 3</div>
                    <div class="calendar-day-header">Thứ 4</div>
                    <div class="calendar-day-header">Thứ 5</div>
                    <div class="calendar-day-header">Thứ 6</div>
                    <div class="calendar-day-header">Thứ 7</div>
                    <div class="calendar-day-header">Chủ Nhật</div>
                    
                    <!-- Calendar Days -->
                    <c:forEach var="day" items="${calendarDays}">
                        <div class="calendar-day ${day.isOtherMonth ? 'other-month' : ''} ${day.isToday ? 'today' : ''}">
                            <div class="day-number">${day.dayOfMonth}</div>
                            <c:forEach var="appointment" items="${day.appointments}">
                                <div class="appointment-item ${fn:toLowerCase(appointment.status)}"
                                     onclick="window.location.href='${pageContext.request.contextPath}/receptionist/appointments?action=view&id=${appointment.appointmentId}'"
                                     title="${appointment.patient.fullName} - ${appointment.service.name}">
                                    <fmt:formatDate value="${appointment.appointmentDateAsDate}" pattern="HH:mm"/>
                                    ${appointment.patient.fullName}
                                </div>
                            </c:forEach>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Set current week as default
        document.addEventListener('DOMContentLoaded', function() {
            const weekInput = document.getElementById('week');
            if (!weekInput.value) {
                const now = new Date();
                const year = now.getFullYear();
                const week = getWeekNumber(now);
                const weekString = `${year}-W${week.toString().padStart(2, '0')}`;
                weekInput.value = weekString;
            }
        });
        
        function getWeekNumber(date) {
            const firstDayOfYear = new Date(date.getFullYear(), 0, 1);
            const pastDaysOfYear = (date - firstDayOfYear) / 86400000;
            return Math.ceil((pastDaysOfYear + firstDayOfYear.getDay() + 1) / 7);
        }
    </script>
</body>
</html>
