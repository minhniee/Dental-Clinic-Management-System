<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Điều Trị - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .history-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .section-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
        }
        
        .section-title {
            color: #0f172a;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            border-bottom: 2px solid #06b6d4;
            padding-bottom: 0.5rem;
        }
        
        .timeline {
            position: relative;
            padding-left: 2rem;
        }
        
        .timeline::before {
            content: '';
            position: absolute;
            left: 1rem;
            top: 0;
            bottom: 0;
            width: 2px;
            background-color: #e2e8f0;
        }
        
        .timeline-item {
            position: relative;
            margin-bottom: 2rem;
            background: white;
            border-radius: 0.75rem;
            padding: 1.5rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border-left: 4px solid #06b6d4;
        }
        
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -2.5rem;
            top: 1.5rem;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background-color: #06b6d4;
            border: 3px solid white;
            box-shadow: 0 0 0 3px #e2e8f0;
        }
        
        .timeline-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 1rem;
        }
        
        .timeline-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #0f172a;
            margin: 0;
        }
        
        .timeline-date {
            color: #6b7280;
            font-size: 0.875rem;
        }
        
        .timeline-content {
            color: #374151;
            line-height: 1.6;
        }
        
        .prescription-item {
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 0.5rem;
        }
        
        .prescription-item:last-child {
            margin-bottom: 0;
        }
        
        .medication-name {
            font-weight: 600;
            color: #0f172a;
        }
        
        .medication-details {
            color: #6b7280;
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }
        
        .treatment-plan-item {
            background-color: #f0f9ff;
            border: 1px solid #bae6fd;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        
        .treatment-session-item {
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 0.5rem;
        }
        
        .cost-badge {
            background-color: #10b981;
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.875rem;
            font-weight: 600;
        }
        
        .btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
        }
        
        .btn-primary {
            background-color: #06b6d4;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #0891b2;
        }
        
        .btn-secondary {
            background-color: #6b7280;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #4b5563;
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6b7280;
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            color: #d1d5db;
        }
        
        .filter-tabs {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .filter-tab {
            padding: 0.75rem 1.5rem;
            border: 2px solid #e2e8f0;
            border-radius: 0.5rem;
            background: white;
            color: #6b7280;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s;
        }
        
        .filter-tab.active {
            border-color: #06b6d4;
            background-color: #06b6d4;
            color: white;
        }
        
        .filter-tab:hover {
            border-color: #06b6d4;
            color: #06b6d4;
        }
        
        .filter-tab.active:hover {
            color: white;
        }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login.jsp"/>
    </c:if>

    <div class="header">
        <h1>🦷 Lịch Sử Điều Trị</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="container">
                
                <!-- Error Message -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${errorMessage}
                    </div>
                </c:if>
                
                <div class="history-container">
                    
                    <!-- Filter Tabs -->
                    <div class="filter-tabs">
                        <a href="#" class="filter-tab active" onclick="showAll()">
                            <i class="fas fa-list me-2"></i>
                            Tất Cả
                        </a>
                        <a href="#" class="filter-tab" onclick="showMedicalRecords()">
                            <i class="fas fa-file-medical me-2"></i>
                            Hồ Sơ Khám
                        </a>
                        <a href="#" class="filter-tab" onclick="showPrescriptions()">
                            <i class="fas fa-prescription me-2"></i>
                            Đơn Thuốc
                        </a>
                    </div>
                    
                    <!-- Medical Records Timeline -->
                    <div id="medical-records-section" class="section-card">
                        <h2 class="section-title">
                            <i class="fas fa-file-medical me-2"></i>
                            Lịch Sử Khám Bệnh
                        </h2>
                        
                        <c:choose>
                            <c:when test="${not empty medicalRecords}">
                                <div class="timeline">
                                    <c:forEach var="record" items="${medicalRecords}">
                                        <div class="timeline-item medical-record-item">
                                            <div class="timeline-header">
                                                <h3 class="timeline-title">Hồ Sơ Khám #${record.recordId}</h3>
                                                <span class="timeline-date">
                                                    ${record.createdAt}
                                                </span>
                                            </div>
                                            
                                            <div class="timeline-content">
                                                <p><strong>Bác sĩ:</strong> ${record.dentist.fullName}</p>
                                                <p><strong>Tóm tắt:</strong> ${record.summary}</p>
                                                
                                                <!-- Treatment Plans -->
                                                <c:if test="${not empty record.treatmentPlans}">
                                                    <div class="mt-3">
                                                        <h6 class="mb-2">Kế hoạch điều trị:</h6>
                                                        <c:forEach var="plan" items="${record.treatmentPlans}">
                                                            <div class="treatment-plan-item">
                                                                <h6 class="mb-1">Kế hoạch #${plan.planId}</h6>
                                                                <p class="mb-1">${plan.planSummary}</p>
                                                                <c:if test="${not empty plan.estimatedCost}">
                                                                    <span class="cost-badge">
                                                                        <i class="fas fa-dollar-sign me-1"></i>
                                                                        <fmt:formatNumber value="${plan.estimatedCost}" pattern="#,##0" /> VNĐ
                                                                    </span>
                                                                </c:if>
                                                                
                                                                <!-- Treatment Sessions -->
                                                                <c:if test="${not empty plan.treatmentSessions}">
                                                                    <div class="mt-2">
                                                                        <h6 class="mb-1">Buổi điều trị:</h6>
                                                                        <c:forEach var="session" items="${plan.treatmentSessions}">
                                                                            <div class="treatment-session-item">
                                                                                <div class="d-flex justify-content-between align-items-start">
                                                                                    <div>
                                                                                        <h6 class="mb-1">Buổi #${session.sessionId}</h6>
                                                                                        <p class="mb-1">${session.procedureDone}</p>
                                                                                        <c:if test="${not empty session.sessionCost}">
                                                                                            <span class="cost-badge">
                                                                                                <i class="fas fa-dollar-sign me-1"></i>
                                                                                                <fmt:formatNumber value="${session.sessionCost}" pattern="#,##0" /> VNĐ
                                                                                            </span>
                                                                                        </c:if>
                                                                                    </div>
                                                                                    <div>
                                                                                        <span class="timeline-date">
                                                                                            ${session.sessionDate}
                                                                                        </span>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </c:forEach>
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-file-medical"></i>
                                    <h4>Chưa có lịch sử khám bệnh</h4>
                                    <p>Bệnh nhân chưa có hồ sơ khám bệnh nào trong hệ thống.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <!-- Prescriptions Timeline -->
                    <div id="prescriptions-section" class="section-card">
                        <h2 class="section-title">
                            <i class="fas fa-prescription me-2"></i>
                            Lịch Sử Đơn Thuốc
                        </h2>
                        
                        <c:choose>
                            <c:when test="${not empty prescriptions}">
                                <div class="timeline">
                                    <c:forEach var="prescription" items="${prescriptions}">
                                        <div class="timeline-item prescription-item">
                                            <div class="timeline-header">
                                                <h3 class="timeline-title">Đơn Thuốc #${prescription.prescriptionId}</h3>
                                                <span class="timeline-date">
                                                    ${prescription.createdAt}
                                                </span>
                                            </div>
                                            
                                            <div class="timeline-content">
                                                <p><strong>Bác sĩ:</strong> ${prescription.dentist.fullName}</p>
                                                <c:if test="${not empty prescription.notes}">
                                                    <p><strong>Ghi chú:</strong> ${prescription.notes}</p>
                                                </c:if>
                                                
                                                <!-- Prescription Items -->
                                                <c:if test="${not empty prescription.prescriptionItems}">
                                                    <div class="mt-3">
                                                        <h6 class="mb-2">Danh sách thuốc:</h6>
                                                        <c:forEach var="item" items="${prescription.prescriptionItems}">
                                                            <div class="prescription-item">
                                                                <div class="medication-name">${item.medicationName}</div>
                                                                <div class="medication-details">
                                                                    <c:if test="${not empty item.dosage}">
                                                                        <strong>Liều lượng:</strong> ${item.dosage}
                                                                    </c:if>
                                                                    <c:if test="${not empty item.duration}">
                                                                        <br><strong>Thời gian:</strong> ${item.duration}
                                                                    </c:if>
                                                                    <c:if test="${not empty item.instructions}">
                                                                        <br><strong>Hướng dẫn:</strong> ${item.instructions}
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-prescription"></i>
                                    <h4>Chưa có đơn thuốc nào</h4>
                                    <p>Bệnh nhân chưa có đơn thuốc nào trong hệ thống.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <!-- Quick Actions -->
                    <div class="section-card">
                        <h3 class="section-title">
                            <i class="fas fa-bolt me-2"></i>
                            Hành Động Nhanh
                        </h3>
                        <div class="d-flex flex-wrap gap-2">
                            <a href="${pageContext.request.contextPath}/open-medical-record?patient_id=${patientId}" 
                               class="btn btn-primary">
                                <i class="fas fa-file-medical me-1"></i>
                                Tạo Hồ Sơ Mới
                            </a>
                            <a href="${pageContext.request.contextPath}/prescription-form?patient_id=${patientId}" 
                               class="btn btn-success">
                                <i class="fas fa-prescription me-1"></i>
                                Kê Đơn Thuốc
                            </a>
                            <a href="${pageContext.request.contextPath}/dentist/patients" 
                               class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-1"></i>
                                Quay Lại
                            </a>
                        </div>
                    </div>
                    
                </div>
                
            </div>
        </main>
    </div>
    
    <script>
        function showAll() {
            document.getElementById('medical-records-section').style.display = 'block';
            document.getElementById('prescriptions-section').style.display = 'block';
            
            // Update active tab
            document.querySelectorAll('.filter-tab').forEach(tab => tab.classList.remove('active'));
            event.target.classList.add('active');
        }
        
        function showMedicalRecords() {
            document.getElementById('medical-records-section').style.display = 'block';
            document.getElementById('prescriptions-section').style.display = 'none';
            
            // Update active tab
            document.querySelectorAll('.filter-tab').forEach(tab => tab.classList.remove('active'));
            event.target.classList.add('active');
        }
        
        function showPrescriptions() {
            document.getElementById('medical-records-section').style.display = 'none';
            document.getElementById('prescriptions-section').style.display = 'block';
            
            // Update active tab
            document.querySelectorAll('.filter-tab').forEach(tab => tab.classList.remove('active'));
            event.target.classList.add('active');
        }
    </script>
</body>
</html>
