<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dentist Dashboard - Dental Clinic Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>
    
    <c:if test="${sessionScope.user.role.roleName ne 'Dentist'}">
        <c:redirect url="/login"/>
    </c:if>
    
    <div class="header">
        <h1>🦷 Dentist Dashboard</h1>
        <div class="user-info">
            <span>Welcome, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
        </div>
    </div>
    
    <div class="container">
        <div class="welcome-section">
            <h2>Welcome to the Dentist Dashboard</h2>
            <p>Manage your patient appointments, view medical records, and access treatment planning tools. 
               Focus on providing excellent dental care to your patients.</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="card">
                <h3>📅 My Schedule</h3>
                <p>View your daily appointments, upcoming patients, and schedule availability. Manage your calendar efficiently.</p>
            </div>
            
            <div class="card">
                <h3>📋 Patient Records</h3>
                <p>Access patient medical records, treatment history, and examination notes. Update patient information securely.</p>
            </div>
            
            <div class="card">
                <h3>💊 Prescriptions</h3>
                <p>Create and manage patient prescriptions. Track medication history and dosage recommendations.</p>
            </div>
            
            <div class="card">
                <h3>🔬 Treatment Plans</h3>
                <p>Develop comprehensive treatment plans for patients. Track treatment progress and outcomes.</p>
            </div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">8</div>
                <div class="stat-label">Today's Patients</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">3</div>
                <div class="stat-label">Pending Follow-ups</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">15</div>
                <div class="stat-label">This Week's Appointments</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">98%</div>
                <div class="stat-label">Patient Satisfaction</div>
            </div>
        </div>
        
        <div class="card" style="margin-top: 2rem;">
            <h3>📋 Today's Appointments</h3>
            <p>• 9:00 AM - John Smith (Regular Checkup)<br>
               • 10:30 AM - Sarah Johnson (Cleaning)<br>
               • 2:00 PM - Mike Davis (Filling)<br>
               • 3:30 PM - Lisa Wilson (Consultation)<br>
               • 4:30 PM - Robert Brown (Follow-up)</p>
        </div>
    </div>
</body>
</html>
