<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Trình Hàng Tuần - Bác Sĩ Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .schedule-container {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .schedule-header {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }

        .filters-section {
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
            padding: 0.75rem 1rem;
            border: 1px solid #d1d5db;
            border-radius: 0.5rem;
            font-size: 1rem;
            transition: all 0.2s ease-in-out;
        }

        .form-control:focus {
            outline: none;
            border-color: #06b6d4;
            box-shadow: 0 0 0 3px rgba(6, 182, 212, 0.1);
        }

        .calendar-container {
            background: #ffffff;
            border-radius: 0.75rem;
            overflow: hidden;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }

        .calendar-header {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            background-color: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
        }

        .calendar-day-header {
            padding: 1rem;
            text-align: center;
            font-weight: 600;
            color: #0f172a;
            font-size: 0.875rem;
            border-right: 1px solid #e2e8f0;
        }

        .calendar-day-header:last-child {
            border-right: none;
        }

        .calendar-body {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            min-height: 500px;
        }

        .calendar-day {
            border-right: 1px solid #e2e8f0;
            border-bottom: 1px solid #e2e8f0;
            padding: 0.75rem;
            min-height: 120px;
            position: relative;
        }

        .calendar-day:last-child {
            border-right: none;
        }

        .calendar-day.other-month {
            background-color: #f8fafc;
            color: #94a3b8;
        }

        .calendar-day.today {
            background-color: #eff6ff;
            border: 2px solid #3b82f6;
        }

        .day-number {
            font-weight: 600;
            font-size: 0.875rem;
            margin-bottom: 0.5rem;
            color: #0f172a;
        }

        .day-number.other-month {
            color: #94a3b8;
        }

        .day-number.today {
            color: #3b82f6;
        }

        .appointments-list {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .appointment-item {
            background-color: #f0f9ff;
            border: 1px solid #bae6fd;
            border-radius: 0.25rem;
            padding: 0.25rem 0.5rem;
            font-size: 0.75rem;
            cursor: pointer;
            transition: all 0.2s ease-in-out;
        }

        .appointment-item:hover {
            background-color: #e0f2fe;
            border-color: #7dd3fc;
        }

        .appointment-time {
            font-weight: 600;
            color: #0369a1;
        }

        .appointment-patient {
            color: #0c4a6e;
            font-size: 0.7rem;
        }

        .appointment-service {
            color: #075985;
            font-size: 0.7rem;
        }

        .status-badge {
            padding: 0.125rem 0.375rem;
            border-radius: 9999px;
            font-size: 0.625rem;
            font-weight: 600;
            display: inline-block;
        }

        .status-scheduled {
            background-color: #dbeafe;
            color: #2563eb;
        }

        .status-confirmed {
            background-color: #d1fae5;
            color: #059669;
        }

        .status-completed {
            background-color: #f0fdf4;
            color: #16a34a;
        }

        .status-cancelled {
            background-color: #fef2f2;
            color: #dc2626;
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

        .alert {
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .alert-success {
            background-color: #f0fdf4;
            color: #16a34a;
            border: 1px solid #bbf7d0;
        }

        .alert-error {
            background-color: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: #64748b;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #94a3b8;
        }

        .actions-container {
            display: flex;
            gap: 1.5rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .week-navigation {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .week-info {
            font-weight: 600;
            color: #0f172a;
        }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>
    
    <c:set var="_role" value="${empty sessionScope.user or empty sessionScope.user.role or empty sessionScope.user.role.roleName ? '' : fn:toLowerCase(fn:replace(sessionScope.user.role.roleName, ' ', ''))}"/>
    <c:if test="${_role ne 'dentist'}">
        <c:redirect url="${pageContext.request.contextPath}/login"/>
    </c:if>
    
    <div class="header">
        <h1>🦷 Lịch Trình Hàng Tuần</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="container">
                <div class="schedule-container">
                    
                    <!-- Alert Messages -->
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle" style="margin-right: 0.5rem;"></i>
                            ${successMessage}
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-triangle" style="margin-right: 0.5rem;"></i>
                            ${errorMessage}
                        </div>
                    </c:if>

                    <!-- Handle URL parameters for success/error messages -->
                    <c:if test="${param.success eq 'status_updated'}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle" style="margin-right: 0.5rem;"></i>
                            Trạng thái lịch hẹn đã được cập nhật thành công!
                        </div>
                    </c:if>
                    
                    <c:if test="${param.error eq 'update_failed'}">
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-triangle" style="margin-right: 0.5rem;"></i>
                            Không thể cập nhật trạng thái lịch hẹn. Vui lòng thử lại.
                        </div>
                    </c:if>
                    
                    <c:if test="${param.error eq 'unauthorized'}">
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-triangle" style="margin-right: 0.5rem;"></i>
                            Bạn không có quyền cập nhật lịch hẹn này.
                        </div>
                    </c:if>
                    
                    <c:if test="${param.error eq 'invalid_id'}">
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-triangle" style="margin-right: 0.5rem;"></i>
                            ID lịch hẹn không hợp lệ.
                        </div>
                    </c:if>

                    <!-- Schedule Header -->
                    <div class="schedule-header">
                        <div class="actions-container">
                            <h2 style="margin: 0; color: #0f172a;">Lịch Hẹn Hàng Tuần</h2>
                            <a href="${pageContext.request.contextPath}/dentist/schedule?action=daily" 
                               class="btn btn-secondary">
                                <i class="fas fa-calendar-day"></i>
                                Xem Lịch Ngày
                            </a>
                            <a href="${pageContext.request.contextPath}/dentist/dashboard" 
                               class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i>
                                Về Dashboard
                            </a>
                        </div>
                    </div>

                    <!-- Filters Section -->
                    <form method="GET" action="${pageContext.request.contextPath}/dentist/schedule" class="filters-section">
                        <input type="hidden" name="action" value="weekly">
                        <div class="filters-form">
                            <div class="form-group">
                                <label for="week">Tuần</label>
                                <input type="week"
                                       id="week"
                                       name="week"
                                       class="form-control"
                                       value="${not empty selectedWeek ? selectedWeek : ''}">
                            </div>
                            <div>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i>
                                    Xem Lịch
                                </button>
                                <a href="${pageContext.request.contextPath}/dentist/schedule?action=weekly" class="btn btn-secondary">
                                    <i class="fas fa-refresh"></i>
                                    Tuần Này
                                </a>
                            </div>
                        </div>
                    </form>

                    <!-- Calendar -->
                    <div class="calendar-container">
                        <c:choose>
                            <c:when test="${not empty calendarDays}">
                                <!-- Calendar Header -->
                                <div class="calendar-header">
                                    <div class="calendar-day-header">Thứ 2</div>
                                    <div class="calendar-day-header">Thứ 3</div>
                                    <div class="calendar-day-header">Thứ 4</div>
                                    <div class="calendar-day-header">Thứ 5</div>
                                    <div class="calendar-day-header">Thứ 6</div>
                                    <div class="calendar-day-header">Thứ 7</div>
                                    <div class="calendar-day-header">Chủ Nhật</div>
                                </div>

                                <!-- Calendar Body -->
                                <div class="calendar-body">
                                    <c:forEach var="day" items="${calendarDays}">
                                        <div class="calendar-day ${day.otherMonth ? 'other-month' : ''} ${day.today ? 'today' : ''}">
                                            <div class="day-number ${day.otherMonth ? 'other-month' : ''} ${day.today ? 'today' : ''}">
                                                ${day.dayOfMonth}
                                            </div>
                                            
                                            <c:if test="${not empty day.appointments}">
                                                <div class="appointments-list">
                                                    <c:forEach var="appointment" items="${day.appointments}">
                                                        <div class="appointment-item" 
                                                             onclick="openPatientProfile(${appointment.patient.patientId})"
                                                             title="Bệnh nhân: ${appointment.patient.fullName}&#10;Dịch vụ: ${appointment.service.name}&#10;Ghi chú: ${appointment.notes}&#10;Click để xem hồ sơ bệnh nhân">
                                        <div class="appointment-time">
                                            <c:choose>
                                                <c:when test="${not empty appointment.appointmentDateAsDate}">
                                                    <fmt:formatDate value="${appointment.appointmentDateAsDate}" pattern="HH:mm"/>
                                                </c:when>
                                                <c:otherwise>
                                                    N/A
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                                            <div class="appointment-patient">
                                                                ${appointment.patient.fullName}
                                                            </div>
                                                            <div class="appointment-service">
                                                                ${appointment.service.name}
                                                            </div>
                                                            <div>
                                                                <c:choose>
                                                                    <c:when test="${appointment.status eq 'SCHEDULED'}">
                                                                        <span class="status-badge status-scheduled">Đã lên lịch</span>
                                                                    </c:when>
                                                                    <c:when test="${appointment.status eq 'CONFIRMED'}">
                                                                        <span class="status-badge status-confirmed">Đã xác nhận</span>
                                                                    </c:when>
                                                                    <c:when test="${appointment.status eq 'COMPLETED'}">
                                                                        <span class="status-badge status-completed">Hoàn thành</span>
                                                                    </c:when>
                                                                    <c:when test="${appointment.status eq 'CANCELLED'}">
                                                                        <span class="status-badge status-cancelled">Đã hủy</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="status-badge">${appointment.status}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-calendar-alt"></i>
                                    <h3>Không Có Dữ Liệu</h3>
                                    <p>Không thể tải lịch trình cho tuần này.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Set current week as default if no week is selected
        document.addEventListener('DOMContentLoaded', function() {
            const weekInput = document.getElementById('week');
            if (!weekInput.value) {
                const today = new Date();
                const year = today.getFullYear();
                const week = getWeekNumber(today);
                weekInput.value = year + '-W' + (week < 10 ? '0' + week : week);
            }
        });

        function getWeekNumber(date) {
            // Get the Monday of the week
            const monday = new Date(date);
            const day = monday.getDay();
            const diff = monday.getDate() - day + (day === 0 ? -6 : 1);
            monday.setDate(diff);
            
            // Get the first Monday of the year
            const firstMonday = new Date(monday.getFullYear(), 0, 1);
            const firstDay = firstMonday.getDay();
            const firstMondayDate = firstMonday.getDate() - firstDay + (firstDay === 0 ? -6 : 1);
            firstMonday.setDate(firstMondayDate);
            
            // Calculate week number
            const weekNumber = Math.ceil((monday - firstMonday) / (7 * 24 * 60 * 60 * 1000)) + 1;
            return weekNumber;
        }

        function openPatientProfile(patientId) {
            // Navigate to patient profile in same tab
            window.location.href = '${pageContext.request.contextPath}/patient/profile?id=' + patientId;
        }
        
        function openAppointmentDetails(appointmentId) {
            // You can implement a modal or redirect to appointment details
            window.open('${pageContext.request.contextPath}/receptionist/appointments?action=view&id=' + appointmentId, '_blank');
        }
    </script>
</body>
</html>
