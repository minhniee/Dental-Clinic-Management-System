<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard - Dental Clinic Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>
    
    <c:set var="_role" value="${empty sessionScope.user or empty sessionScope.user.role or empty sessionScope.user.role.roleName ? '' : fn:toLowerCase(fn:replace(sessionScope.user.role.roleName, ' ', ''))}"/>
    <c:if test="${_role ne 'patient'}">
        <c:redirect url="${pageContext.request.contextPath}/login"/>
    </c:if>
    
    <div class="header">
        <h1>🦷 Patient Portal</h1>
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
            <h2>Welcome to Your Patient Portal</h2>
            <p>Access your dental records, manage appointments, and stay informed about your dental health. 
               Your oral health is our priority.</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="card">
                <h3>📅 My Appointments</h3>
                <p>View your upcoming appointments, check appointment history, and request new appointments online.</p>
            </div>
            
            <div class="card">
                <h3>📋 Medical Records</h3>
                <p>Access your dental records, treatment history, and examination results. Keep track of your oral health journey.</p>
            </div>
            
            <div class="card">
                <h3>💊 Prescriptions</h3>
                <p>View your current and past prescriptions, medication instructions, and refill requests.</p>
            </div>
            
            <div class="card">
                <h3>💳 Billing & Payments</h3>
                <p>View your invoices, payment history, and make online payments. Manage your dental insurance information.</p>
            </div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">2</div>
                <div class="stat-label">Upcoming Appointments</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">5</div>
                <div class="stat-label">Total Visits</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">$450</div>
                <div class="stat-label">Outstanding Balance</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">1</div>
                <div class="stat-label">Active Prescriptions</div>
            </div>
        </div>
        
        <div class="card" style="margin-top: 2rem;">
            <h3>📅 Upcoming Appointments</h3>
            <p>• October 20, 2024 - 2:00 PM - Dr. Johnson (Regular Checkup)<br>
               • November 5, 2024 - 10:30 AM - Dr. Wilson (Cleaning)<br>
               <br>
               <strong>Need to reschedule?</strong> Please call our office at (555) 123-4567</p>
        </div>
            </div>
        </main>
    </div>
</body>
</html>
