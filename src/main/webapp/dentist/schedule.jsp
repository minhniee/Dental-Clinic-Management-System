<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch làm việc của tôi - Bác sĩ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/receptionist.css">
    <style>
        .schedule-container { padding: 1.5rem; }
        .week-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; }
        .week-nav a { text-decoration: none; padding: 0.5rem 0.75rem; border: 1px solid #e5e7eb; border-radius: 0.5rem; color: #111827; }
        .week-nav a:hover { background: #f3f4f6; }
        .calendar-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 0.75rem; }
        .day-card { background: #fff; border: 1px solid #e5e7eb; border-radius: 0.75rem; padding: 0.75rem; min-height: 140px; }
        .day-title { font-weight: 700; font-size: 0.95rem; margin-bottom: 0.5rem; color: #0f172a; display:flex; justify-content:space-between; }
        .slot { border-left: 4px solid #9ca3af; background: #f9fafb; padding: 0.5rem; border-radius: 0.5rem; margin-bottom: 0.5rem; }
        .slot.morning { border-color: #06b6d4; background: #ecfeff; }
        .slot.afternoon { border-color: #f59e0b; background: #fffbeb; }
        .slot.evening { border-color: #8b5cf6; background: #f5f3ff; }
        .status { font-size: 0.75rem; font-weight: 600; }
        .status.ACTIVE { color: #059669; }
        .status.CANCELLED, .status.CANCELED { color: #b91c1c; }
        .muted { color: #6b7280; font-size: 0.85rem; }
    </style>
    <c:set var="ctx" value="${pageContext.request.contextPath}"/>
    <c:set var="role" value="${empty sessionScope.user or empty sessionScope.user.role or empty sessionScope.user.role.roleName ? '' : fn:toLowerCase(fn:replace(sessionScope.user.role.roleName, ' ', ''))}"/>
</head>
<body>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="/login"/>
    <c:remove var="sessionScope"/>
    <c:set var="__stop" value="1"/>
</c:if>
<c:if test="${role ne 'dentist'}">
    <c:redirect url="${ctx}/login"/>
</c:if>

<div class="header">
    <h1>📅 Lịch làm việc của tôi</h1>
    <div class="user-info">
        <span>${sessionScope.user.fullName}</span>
        <a href="${ctx}/logout" class="logout-btn">Đăng Xuất</a>
    </div>
    </div>

<div class="dashboard-layout">
    <jsp:include page="/shared/left-navbar.jsp"/>
    <main class="dashboard-content">
        <div class="schedule-container">
            <div class="week-header">
                <div>
                    <div class="muted">Tuần từ</div>
                    <div style="font-weight:700;">${weekStart} - ${weekEnd}</div>
                </div>
                <div class="week-nav">
                    <a href="${ctx}/dentist/schedule?week=${previousWeek}">⟵ Tuần trước</a>
                    <a href="${ctx}/dentist/schedule?week=${nextWeek}" style="margin-left:0.5rem;">Tuần sau ⟶</a>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div style="color:#b91c1c; background:#fee2e2; border:1px solid #fecaca; padding:0.75rem; border-radius:0.5rem; margin-bottom:1rem;">${error}</div>
            </c:if>

            <div class="calendar-grid">
                <c:forEach var="day" items="${weekDays}">
                    <div class="day-card">
                        <div class="day-title">
                            <span>
                                <c:choose>
                                    <c:when test="${day.dayOfWeek.value == 1}">Thứ 2</c:when>
                                    <c:when test="${day.dayOfWeek.value == 2}">Thứ 3</c:when>
                                    <c:when test="${day.dayOfWeek.value == 3}">Thứ 4</c:when>
                                    <c:when test="${day.dayOfWeek.value == 4}">Thứ 5</c:when>
                                    <c:when test="${day.dayOfWeek.value == 5}">Thứ 6</c:when>
                                    <c:when test="${day.dayOfWeek.value == 6}">Thứ 7</c:when>
                                    <c:otherwise>Chủ nhật</c:otherwise>
                                </c:choose>
                            </span>
                            <span class="muted">${day}</span>
                        </div>

                        <c:set var="hasAny" value="false"/>
                        <c:forEach var="s" items="${scheduleList}">
                            <c:if test="${s.workDate eq day}">
                                <c:set var="hasAny" value="true"/>
                                <c:set var="slotClass" value=""/>
                                <c:if test="${fn:contains(s.shift, 'Morning') or fn:contains(s.shift, 'Sáng')}">
                                    <c:set var="slotClass" value="morning"/>
                                </c:if>
                                <c:if test="${fn:contains(s.shift, 'Afternoon') or fn:contains(s.shift, 'Chiều')}">
                                    <c:set var="slotClass" value="afternoon"/>
                                </c:if>
                                <c:if test="${fn:contains(s.shift, 'Evening') or fn:contains(s.shift, 'Tối')}">
                                    <c:set var="slotClass" value="evening"/>
                                </c:if>
                                <c:if test="${fn:contains(s.shift, 'FullDay') or fn:contains(s.shift, 'Cả ngày')}">
                                    <c:set var="slotClass" value="morning"/>
                                </c:if>
                                <div class="slot ${slotClass}">
                                    <div style="font-weight:600;">${s.shift}</div>
                                    <div class="muted">
                                        <c:set var="_start" value="${s.startTime}"/>
                                        <c:set var="_end" value="${s.endTime}"/>
                                        <c:choose>
                                            <c:when test="${not empty _start and fn:length(_start) >= 5 and not empty _end and fn:length(_end) >= 5}">
                                                ${fn:substring(_start,0,5)} - ${fn:substring(_end,0,5)}
                                            </c:when>
                                            <c:otherwise>${s.startTime} - ${s.endTime}</c:otherwise>
                                        </c:choose>
                                        <c:if test="${not empty s.roomNo}"> · Phòng ${s.roomNo}</c:if>
                                    </div>
                                    <div class="status ${s.status}">
                                        <c:choose>
                                            <c:when test="${s.status eq 'ACTIVE'}">Hoạt động</c:when>
                                            <c:when test="${s.status eq 'INACTIVE'}">Không hoạt động</c:when>
                                            <c:when test="${s.status eq 'CANCELLED' or s.status eq 'CANCELED'}">Đã hủy</c:when>
                                            <c:otherwise>${s.status}</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>

                        <c:if test="${not hasAny}">
                            <div class="muted">Không có ca làm</div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </div>
    </main>
</div>

</body>
</html>


