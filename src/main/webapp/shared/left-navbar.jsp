<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="roleNameRaw" value="${sessionScope.user != null ? sessionScope.user.role.roleName : ''}"/>
<c:set var="role" value="${fn:toLowerCase(fn:replace(roleNameRaw, ' ', ''))}"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="currentPath" value="${pageContext.request.requestURI}"/>

<aside class="sidebar">
    <div class="sidebar-header">
        <span class="sidebar-title">Bảng Điều Khiển</span>
        <span class="sidebar-role">
            <c:out value="${roleNameRaw}"/>
        </span>
    </div>

    <nav class="sidebar-nav">
        <!-- Administrator menu -->
        <c:if test="${role eq 'administrator'}">
            <ul>
                <li><a class="${fn:endsWith(currentPath, '/admin/dashboard') ? 'active' : ''}" href="${ctx}/admin/dashboard">📊 Báo Cáo Tổng Hợp</a></li>
                <li class="divider"></li>
                <li><a href="${ctx}/admin/users">👥 Quản Lý Người Dùng</a></li>
                <li><a href="${ctx}/admin/roles">🔐 Vai Trò & Quyền Hạn</a></li>
                <li class="divider"></li>
                <li><a href="${ctx}/admin/financial-reports?type=overview">💰 Báo Cáo Tài Chính Tổng Quan</a></li>
            </ul>
        </c:if>

        <!-- Clinic Manager menu -->
        <c:if test="${role eq 'clinicmanager'}">
            <ul>
                <li><a class="${fn:endsWith(currentPath, '/manager/dashboard') ? 'active' : ''}" href="${ctx}/manager/dashboard">📊 Báo Cáo Vận Hành</a></li>
                <li class="divider"></li>
                <li><a href="${ctx}/manager/employees">👥 Quản Lý Nhân Viên</a></li>
                <li><a href="${ctx}/manager/schedule-requests">📋 Phê Duyệt Yêu Cầu Nghỉ</a></li>
                <li class="divider"></li>
                <li><a href="${ctx}/manager/inventory">📦 Quản Lý Vật Tư & Thiết Bị</a></li>
                <li><a href="${ctx}/manager/stock-transactions">📊 Giao Dịch Kho</a></li>
                <li class="divider"></li>
                <li><a href="${ctx}/manager/schedules">📅 Quản Lý Lịch Làm Việc</a></li>
                <li><a href="${ctx}/manager/weekly-schedule">📆 Lịch Tuần</a></li>
                <li class="divider"></li>
                <li><a href="${ctx}/manager/reports?type=appointments">📅 Báo Cáo Lịch Hẹn</a></li>
                <li><a href="${ctx}/manager/reports?type=revenue">💰 Báo Cáo Doanh Thu</a></li>
            </ul>
        </c:if>

        <!-- Receptionist menu -->
        <c:if test="${role eq 'receptionist'}">
            <ul>
                <li><a class="${fn:endsWith(currentPath, '/receptionist/dashboard') or fn:endsWith(currentPath, '/receptionist/dashboard.jsp') ? 'active' : ''}" href="${ctx}/receptionist/dashboard">Tổng Quan</a></li>
                <li><a href="${ctx}/receptionist/patients?action=new">Đăng Ký Bệnh Nhân</a></li>
                <li><a href="${ctx}/receptionist/patients">Danh Sách Bệnh Nhân</a></li>
                <li><a class="${fn:endsWith(currentPath, '/receptionist/appointments') ? 'active' : ''}" href="${ctx}/receptionist/appointments">Lịch Hẹn</a></li>
                <li><a class="${fn:endsWith(currentPath, '/receptionist/queue') ? 'active' : ''}" href="${ctx}/receptionist/queue">Hàng Chờ</a></li>
                <li><a href="${ctx}/receptionist/invoices">Hóa Đơn & Thanh Toán</a></li>
                <li><a class="${fn:endsWith(currentPath, '/receptionist/online-appointments') ? 'active' : ''}" href="${ctx}/receptionist/online-appointments">Lịch Hẹn Trực Tuyến</a></li>
                
            </ul>
        </c:if>

        <!-- Dentist menu -->
        <c:if test="${role eq 'dentist'}">
            <ul>
                <li><a class="${fn:endsWith(currentPath, '/dentist/dashboard.jsp') ? 'active' : ''}" href="${ctx}/dentist/dashboard.jsp">Tổng Quan</a></li>
                <li><a class="${fn:contains(currentPath, '/dentist/schedule') ? 'active' : ''}" href="${ctx}/dentist/schedule?action=daily">📅 Lịch Trình Hàng Ngày</a></li>
                <li><a class="${fn:contains(currentPath, '/dentist/schedule') ? 'active' : ''}" href="${ctx}/dentist/schedule?action=weekly">📅 Lịch Trình Hàng Tuần</a></li>
                <li><a class="${fn:contains(currentPath, '/dentist/patients') ? 'active' : ''}" href="${ctx}/dentist/patients">👥 Danh Sách Bệnh Nhân</a></li>
                <li><a class="${fn:contains(currentPath, '/dentist/medical-history') ? 'active' : ''}" href="${ctx}/dentist/medical-history">📋 Lịch Sử Khám Bệnh</a></li>
            </ul>
        </c:if>

        <!-- Patient menu -->
        <c:if test="${role eq 'patient'}">
            <ul>
                <li><a class="${fn:endsWith(currentPath, '/patient/dashboard.jsp') ? 'active' : ''}" href="${ctx}/patient/dashboard.jsp">Tổng Quan</a></li>
                <li><a href="${ctx}/patient/book-appointment">Đặt Lịch Hẹn</a></li>
                <li><a href="${ctx}/patient/appointments">Lịch Hẹn Của Tôi</a></li>
                <li><a href="${ctx}/patient/payments">Thanh Toán</a></li>
                <li><a href="${ctx}/patient/medical-history">Lịch Sử Y Tế</a></li>
                <li><a href="${ctx}/patient/feedback">Phản Hồi</a></li>
            </ul>
        </c:if>

        <!-- Fallback for unauthenticated -->
        <c:if test="${empty role}">
            <ul>
                <li><a href="${ctx}/login">Đăng Nhập</a></li>
            </ul>
        </c:if>
    </nav>
</aside>


