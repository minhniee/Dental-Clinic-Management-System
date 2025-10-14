<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard - Dental Clinic Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>
    
    <c:if test="${sessionScope.user.role.roleName ne 'ClinicManager'}">
        <c:redirect url="/login"/>
    </c:if>
    
    <div class="header">
        <h1>🦷 Manager Dashboard</h1>
        <div class="user-info">
            <span>Welcome, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
        </div>
    </div>
    
    <div class="container">
        <div class="welcome-section">
            <h2>Welcome to the Manager Dashboard</h2>
            <p>Manage daily clinic operations, staff schedules, and patient services. 
               Monitor performance metrics and ensure smooth clinic operations.</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="card">
                <h3>📅 Schedule Management</h3>
                <p>Manage doctor schedules, appointment slots, and clinic hours. Optimize resource allocation and minimize conflicts.</p>
            </div>
            
            <div class="card">
                <h3>💰 Financial Reports</h3>
                <p>View revenue reports, payment tracking, and financial analytics. Monitor clinic profitability and expenses.</p>
            </div>
            
            <div class="card">
                <h3>👥 Staff Management</h3>
                <p>Manage staff schedules, performance reviews, and resource allocation. Ensure adequate staffing levels.</p>
            </div>
            
            <div class="card">
                <h3>📊 Performance Analytics</h3>
                <p>Track key performance indicators, patient satisfaction metrics, and operational efficiency data.</p>
            </div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">25</div>
                <div class="stat-label">Today's Appointments</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">$2,450</div>
                <div class="stat-label">Today's Revenue</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">8</div>
                <div class="stat-label">Active Staff</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">95%</div>
                <div class="stat-label">Patient Satisfaction</div>
            </div>
        </div>
        
        <div class="card" style="margin-top: 2rem;">
            <h3>📋 Today's Tasks</h3>
            <p>• Review today's appointment schedule<br>
               • Check payment status<br>
               • Coordinate with dental staff<br>
               • Update inventory levels<br>
               • Prepare daily reports</p>
        </div>
    </div>
</body>
</html>
