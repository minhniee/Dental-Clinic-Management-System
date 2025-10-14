<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Dental Clinic Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>
    
    <c:if test="${sessionScope.user.role.roleName ne 'Administrator'}">
        <c:redirect url="/login"/>
    </c:if>
    
    <div class="header">
        <h1>🦷 Admin Dashboard</h1>
        <div class="user-info">
            <span>Welcome, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
        </div>
    </div>
    
    <div class="container">
        <div class="welcome-section">
            <h2>Welcome to the Admin Dashboard</h2>
            <p>You have full administrative access to the Dental Clinic Management System. 
               From here you can manage users, system settings, and oversee all clinic operations.</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="card">
                <h3>👥 User Management</h3>
                <p>Manage user accounts, roles, and permissions. Create new accounts for staff members and patients with appropriate access levels.</p>
            </div>
            
            <div class="card">
                <h3>📊 System Reports</h3>
                <p>View comprehensive reports on clinic operations, financial data, and system usage statistics to make informed decisions.</p>
            </div>
            
            <div class="card">
                <h3>⚙️ System Settings</h3>
                <p>Configure system-wide settings, backup data, and manage system maintenance schedules to ensure optimal performance.</p>
            </div>
            
            <div class="card">
                <h3>🔐 Security Management</h3>
                <p>Monitor security logs, manage password policies, and review system access controls to maintain data security.</p>
            </div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">5</div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">3</div>
                <div class="stat-label">Active Roles</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">100%</div>
                <div class="stat-label">System Uptime</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">0</div>
                <div class="stat-label">Security Issues</div>
            </div>
        </div>
        
        <div class="quick-actions">
            <h3>📋 Quick Actions</h3>
            <p>• Create new user accounts<br>
               • View system logs<br>
               • Configure clinic settings<br>
               • Generate monthly reports<br>
               • Backup system data</p>
        </div>
    </div>
</body>
</html>
