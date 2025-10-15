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
                <li><a class="${fn:endsWith(currentPath, '/admin/dashboard.jsp') ? 'active' : ''}" href="${ctx}/admin/dashboard.jsp">Tổng Quan</a></li>
                <li><a href="${ctx}/admin/users">Người Dùng</a></li>
                <li><a href="${ctx}/admin/roles">Vai Trò & Quyền Hạn</a></li>
                <li><a href="${ctx}/admin/employees">Nhân Viên</a></li>
                <li><a href="${ctx}/admin/schedules">Lịch Trình</a></li>
                <li><a href="${ctx}/admin/notifications">Thông Báo</a></li>
                <li><a href="${ctx}/admin/services">Dịch Vụ</a></li>
                <li><a href="${ctx}/admin/pricing">Giá Cả</a></li>
                <li><a href="${ctx}/admin/promotions">Khuyến Mãi</a></li>
                <li><a href="${ctx}/admin/inventory">Tồn Kho</a></li>
                <li><a href="${ctx}/admin/analytics">Phân Tích</a></li>
                <li class="divider"></li>
                <li><a href="${ctx}/admin/reports/financial">Báo Cáo Tài Chính</a></li>
                <li><a href="${ctx}/admin/reports/usage">Sử Dụng Website</a></li>
                <li><a href="${ctx}/admin/reports/treatment">Điều Trị & Bệnh Nhân</a></li>
            </ul>
        </c:if>

        <!-- Clinic Manager menu -->
        <c:if test="${role eq 'clinicmanager'}">
            <ul>
                <li><a class="${fn:endsWith(currentPath, '/manager/dashboard.jsp') ? 'active' : ''}" href="${ctx}/manager/dashboard.jsp">Tổng Quan</a></li>
                <li><a href="${ctx}/manager/employees">Nhân Viên</a></li>
                <li><a href="${ctx}/manager/schedules">Lịch Trình</a></li>
                <li><a href="${ctx}/manager/patients">Bệnh Nhân</a></li>
                <li><a href="${ctx}/manager/queue">Hàng Chờ</a></li>
                <li><a href="${ctx}/manager/online-appointments">Lịch Hẹn Trực Tuyến</a></li>
                <li><a href="${ctx}/manager/invoices">Hóa Đơn</a></li>
                <li><a href="${ctx}/manager/inventory">Tồn Kho</a></li>
                <li><a href="${ctx}/manager/feedback">Phản Hồi</a></li>
                <li><a href="${ctx}/manager/analytics">Phân Tích</a></li>
                <li class="divider"></li>
                <li><a href="${ctx}/manager/reports">Báo Cáo</a></li>
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
                <li><a href="${ctx}/receptionist/feedback">Phản Hồi</a></li>
            </ul>
        </c:if>

        <!-- Dentist menu -->
        <c:if test="${role eq 'dentist'}">
            <ul>
                <li><a class="${fn:endsWith(currentPath, '/dentist/dashboard.jsp') ? 'active' : ''}" href="${ctx}/dentist/dashboard.jsp">Tổng Quan</a></li>
                <li><a href="${ctx}/dentist/patients">Bệnh Nhân</a></li>
                <li><a href="${ctx}/dentist/medical-record">Hồ Sơ Y Tế</a></li>
                <li><a href="${ctx}/dentist/examinations">Khám Bệnh</a></li>
                <li><a href="${ctx}/dentist/treatment-plan">Kế Hoạch Điều Trị</a></li>
                <li><a href="${ctx}/dentist/clinical-results">Kết Quả Lâm Sàng</a></li>
                <li><a href="${ctx}/dentist/prescriptions">Đơn Thuốc</a></li>
                <li><a href="${ctx}/dentist/history">Lịch Sử</a></li>
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


