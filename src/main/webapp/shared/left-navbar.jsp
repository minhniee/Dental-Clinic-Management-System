<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="roleNameRaw" value="${sessionScope.user != null ? sessionScope.user.role.roleName : ''}"/>
<c:set var="role" value="${fn:toLowerCase(fn:replace(roleNameRaw, ' ', ''))}"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="currentPath" value="${pageContext.request.requestURI}"/>

<aside class="sidebar">
    <div class="sidebar-header">
        <span class="sidebar-title">Dashboard</span>
        <span class="sidebar-role">
            <c:out value="${roleNameRaw}"/>
        </span>
    </div>

    <nav class="sidebar-nav">
        <!-- Administrator menu -->
        <c:if test="${role eq 'administrator'}">
            <ul>
                <li><a class="${fn:endsWith(currentPath, '/admin/dashboard.jsp') ? 'active' : ''}" href="${ctx}/admin/dashboard.jsp">Overview</a></li>
                <li><a href="${ctx}/admin/users">Users</a></li>
                <li><a href="${ctx}/admin/roles">Roles & Permissions</a></li>
                <li><a href="${ctx}/admin/employees">Employees</a></li>
                <li><a href="${ctx}/admin/schedules">Schedules</a></li>
                <li><a href="${ctx}/admin/notifications">Notifications</a></li>
                <li><a href="${ctx}/admin/services">Services</a></li>
                <li><a href="${ctx}/admin/pricing">Pricing</a></li>
                <li><a href="${ctx}/admin/promotions">Promotions</a></li>
                <li><a href="${ctx}/admin/inventory">Inventory</a></li>
                <li><a href="${ctx}/admin/analytics">Analytics</a></li>
                <li class="divider"></li>
                <li><a href="${ctx}/admin/reports/financial">Financial Reports</a></li>
                <li><a href="${ctx}/admin/reports/usage">Website Usage</a></li>
                <li><a href="${ctx}/admin/reports/treatment">Treatment & Patient</a></li>
            </ul>
        </c:if>

        <!-- Clinic Manager menu -->
        <c:if test="${role eq 'clinicmanager'}">
            <ul>
                <li><a class="${fn:endsWith(currentPath, '/manager/dashboard.jsp') ? 'active' : ''}" href="${ctx}/manager/dashboard.jsp">Overview</a></li>
                <li><a href="${ctx}/manager/employees">Employees</a></li>
                <li><a href="${ctx}/manager/schedules">Schedules</a></li>
                <li><a href="${ctx}/manager/patients">Patients</a></li>
                <li><a href="${ctx}/manager/queue">Queue</a></li>
                <li><a href="${ctx}/manager/online-appointments">Online Appointments</a></li>
                <li><a href="${ctx}/manager/invoices">Invoices</a></li>
                <li><a href="${ctx}/manager/inventory">Inventory</a></li>
                <li><a href="${ctx}/manager/feedback">Feedback</a></li>
                <li><a href="${ctx}/manager/analytics">Analytics</a></li>
                <li class="divider"></li>
                <li><a href="${ctx}/manager/reports">Reports</a></li>
            </ul>
        </c:if>

        <!-- Receptionist menu -->
        <c:if test="${role eq 'receptionist'}">
            <ul>
                <li><a class="${fn:endsWith(currentPath, '/receptionist/dashboard.jsp') ? 'active' : ''}" href="${ctx}/receptionist/dashboard.jsp">Overview</a></li>
                <li><a href="${ctx}/receptionist/register-patient">Register Patient</a></li>
                <li><a href="${ctx}/receptionist/patients">Patient List</a></li>
                <li><a href="${ctx}/receptionist/patient-files">Patient Files</a></li>
                <li><a href="${ctx}/receptionist/queue">Waiting Queue</a></li>
                <li><a href="${ctx}/receptionist/assign">Assign to Dentist</a></li>
                <li><a href="${ctx}/receptionist/invoices">Invoices & Payments</a></li>
                <li><a href="${ctx}/receptionist/online-appointments">Online Appointments</a></li>
                <li><a href="${ctx}/receptionist/inventory">Inventory</a></li>
                <li><a href="${ctx}/receptionist/feedback">Feedback</a></li>
            </ul>
        </c:if>

        <!-- Dentist menu -->
        <c:if test="${role eq 'dentist'}">
            <ul>
                <li><a class="${fn:endsWith(currentPath, '/dentist/dashboard.jsp') ? 'active' : ''}" href="${ctx}/dentist/dashboard.jsp">Overview</a></li>
                <li><a href="${ctx}/dentist/patients">Patients</a></li>
                <li><a href="${ctx}/dentist/medical-record">Medical Records</a></li>
                <li><a href="${ctx}/dentist/examinations">Examinations</a></li>
                <li><a href="${ctx}/dentist/treatment-plan">Treatment Plans</a></li>
                <li><a href="${ctx}/dentist/clinical-results">Clinical Results</a></li>
                <li><a href="${ctx}/dentist/prescriptions">Prescriptions</a></li>
                <li><a href="${ctx}/dentist/history">History</a></li>
            </ul>
        </c:if>

        <!-- Patient menu -->
        <c:if test="${role eq 'patient'}">
            <ul>
                <li><a class="${fn:endsWith(currentPath, '/patient/dashboard.jsp') ? 'active' : ''}" href="${ctx}/patient/dashboard.jsp">Overview</a></li>
                <li><a href="${ctx}/patient/book-appointment">Book Appointment</a></li>
                <li><a href="${ctx}/patient/appointments">My Appointments</a></li>
                <li><a href="${ctx}/patient/payments">Payments</a></li>
                <li><a href="${ctx}/patient/medical-history">Medical History</a></li>
                <li><a href="${ctx}/patient/feedback">Feedback</a></li>
            </ul>
        </c:if>

        <!-- Fallback for unauthenticated -->
        <c:if test="${empty role}">
            <ul>
                <li><a href="${ctx}/login">Login</a></li>
            </ul>
        </c:if>
    </nav>
</aside>


