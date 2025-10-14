<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Receptionist Dashboard - Dental Clinic Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>
    
    <c:set var="_role" value="${empty sessionScope.user or empty sessionScope.user.role or empty sessionScope.user.role.roleName ? '' : fn:toLowerCase(fn:replace(sessionScope.user.role.roleName, ' ', ''))}"/>
    <c:if test="${_role ne 'receptionist'}">
        <c:redirect url="${pageContext.request.contextPath}/login"/>
    </c:if>
    
    <div class="header">
        <h1>🦷 Receptionist Dashboard</h1>
        <div class="user-info">
            <span>Welcome, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="container">
        <div class="welcome-section">
            <h2>Welcome to the Receptionist Dashboard</h2>
            <p>Manage patient appointments, handle check-ins and check-outs, and provide excellent customer service. 
               You are the first point of contact for our patients.</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="card">
                <h3>📅 Appointment Management</h3>
                <p>Schedule new appointments, modify existing ones, and manage the clinic's appointment calendar efficiently.</p>
            </div>
            
            <div class="card">
                <h3>👥 Patient Check-in/out</h3>
                <p>Check patients in for their appointments, verify information, and handle check-out procedures including payments.</p>
            </div>
            
            <div class="card">
                <h3>📞 Patient Communication</h3>
                <p>Handle phone calls, send appointment reminders, and communicate with patients about scheduling changes.</p>
            </div>
            
            <div class="card">
                <h3>💳 Payment Processing</h3>
                <p>Process payments, issue receipts, and manage billing inquiries. Handle insurance verification when needed.</p>
            </div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">12</div>
                <div class="stat-label">Waiting Patients</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">25</div>
                <div class="stat-label">Today's Appointments</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">8</div>
                <div class="stat-label">Completed Today</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">3</div>
                <div class="stat-label">No Shows</div>
            </div>
        </div>
        
        <div class="card" style="margin-top: 2rem;">
            <h3>📋 Current Waiting Queue</h3>
            <p>• John Smith - Dr. Johnson - 9:30 AM (Waiting)<br>
               • Sarah Davis - Dr. Wilson - 10:15 AM (Called)<br>
               • Mike Brown - Dr. Johnson - 11:00 AM (Waiting)<br>
               • Lisa Garcia - Dr. Wilson - 11:45 AM (Waiting)</p>
        </div>
            </div>
        </main>
    </div>
</body>
</html>
