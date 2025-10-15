<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Hồ Sơ Khám - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .record-header {
            background: linear-gradient(135deg, #06b6d4, #0891b2);
            color: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
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
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 1rem;
            border-bottom: 2px solid #06b6d4;
            padding-bottom: 0.5rem;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            padding: 0.75rem;
            background-color: #f8fafc;
            border-radius: 0.5rem;
            margin-bottom: 0.5rem;
        }
        
        .info-item i {
            color: #06b6d4;
            margin-right: 0.75rem;
            width: 20px;
        }
        
        .examination-item, .plan-item, .session-item {
            padding: 1rem;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
            background-color: #f8fafc;
        }
        
        .examination-item:last-child, .plan-item:last-child, .session-item:last-child {
            margin-bottom: 0;
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
        
        .btn-success {
            background-color: #10b981;
            color: white;
        }
        
        .btn-success:hover {
            background-color: #059669;
        }
        
        .btn-warning {
            background-color: #f59e0b;
            color: white;
        }
        
        .btn-warning:hover {
            background-color: #d97706;
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
            padding: 2rem;
            color: #6b7280;
        }
        
        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #d1d5db;
        }
        
        .cost-badge {
            background-color: #10b981;
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.875rem;
            font-weight: 600;
        }
        
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.875rem;
            font-weight: 600;
        }
        
        .status-completed {
            background-color: #10b981;
            color: white;
        }
        
        .status-pending {
            background-color: #f59e0b;
            color: white;
        }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login.jsp"/>
    </c:if>

    <div class="header">
        <h1>🦷 Chi Tiết Hồ Sơ Khám</h1>
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
                
                <!-- Record Header -->
                <c:if test="${not empty medicalRecord}">
                    <div class="record-header">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h2 class="mb-2">
                                    <i class="fas fa-file-medical me-2"></i>
                                    Hồ Sơ Khám #${medicalRecord.recordId}
                                </h2>
                                <p class="mb-1">
                                    <i class="fas fa-user me-2"></i>
                                    Bệnh nhân: ${medicalRecord.patient.fullName}
                                </p>
                                <p class="mb-1">
                                    <i class="fas fa-user-md me-2"></i>
                                    Bác sĩ: ${medicalRecord.dentist.fullName}
                                </p>
                                <p class="mb-0">
                                    <i class="fas fa-clock me-2"></i>
                                    Ngày tạo: ${medicalRecord.createdAt}
                                </p>
                            </div>
                            <div>
                                <a href="${pageContext.request.contextPath}/open-medical-record?patient_id=${medicalRecord.patientId}" 
                                   class="btn btn-secondary">
                                    <i class="fas fa-arrow-left me-1"></i>
                                    Quay Lại
                                </a>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Summary -->
                    <div class="section-card">
                        <h3 class="section-title">
                            <i class="fas fa-clipboard-list me-2"></i>
                            Tóm Tắt Hồ Sơ
                        </h3>
                        <div class="info-item">
                            <i class="fas fa-file-text"></i>
                            <div>${medicalRecord.summary}</div>
                        </div>
                    </div>
                </c:if>
                
                <!-- Examinations -->
                <div class="section-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h3 class="section-title mb-0">
                            <i class="fas fa-stethoscope me-2"></i>
                            Phiên Khám & Chẩn Đoán
                        </h3>
                        <a href="${pageContext.request.contextPath}/examination-form?record_id=${medicalRecord.recordId}" 
                           class="btn btn-primary">
                            <i class="fas fa-plus me-1"></i>
                            Thêm Phiên Khám
                        </a>
                    </div>
                    
                    <c:choose>
                        <c:when test="${not empty examinations}">
                            <c:forEach var="exam" items="${examinations}">
                                <div class="examination-item">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <h6 class="mb-1">Phiên Khám #${exam.examId}</h6>
                                            <c:if test="${not empty exam.findings}">
                                                <p class="mb-1"><strong>Kết quả khám:</strong> ${exam.findings}</p>
                                            </c:if>
                                            <c:if test="${not empty exam.diagnosis}">
                                                <p class="mb-1"><strong>Chẩn đoán:</strong> ${exam.diagnosis}</p>
                                            </c:if>
                                            <small class="text-muted">
                                                <i class="fas fa-clock me-1"></i>
                                                ${exam.createdAt}
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-stethoscope"></i>
                                <p>Chưa có phiên khám nào</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Treatment Plans -->
                <div class="section-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h3 class="section-title mb-0">
                            <i class="fas fa-clipboard-check me-2"></i>
                            Kế Hoạch Điều Trị
                        </h3>
                        <a href="${pageContext.request.contextPath}/treatment-plan-form?record_id=${medicalRecord.recordId}" 
                           class="btn btn-success">
                            <i class="fas fa-plus me-1"></i>
                            Thêm Kế Hoạch
                        </a>
                    </div>
                    
                    <c:choose>
                        <c:when test="${not empty treatmentPlans}">
                            <c:forEach var="plan" items="${treatmentPlans}">
                                <div class="plan-item">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div>
                                            <h6 class="mb-1">Kế Hoạch #${plan.planId}</h6>
                                            <p class="mb-1">${plan.planSummary}</p>
                                            <c:if test="${not empty plan.estimatedCost}">
                                                <span class="cost-badge">
                                                    <i class="fas fa-dollar-sign me-1"></i>
                                                    <fmt:formatNumber value="${plan.estimatedCost}" pattern="#,##0" /> VNĐ
                                                </span>
                                            </c:if>
                                        </div>
                                        <div>
                                            <a href="${pageContext.request.contextPath}/treatment-session-form?plan_id=${plan.planId}" 
                                               class="btn btn-warning">
                                                <i class="fas fa-plus me-1"></i>
                                                Thêm Buổi Điều Trị
                                            </a>
                                        </div>
                                    </div>
                                    
                                    <!-- Treatment Sessions -->
                                    <c:if test="${not empty plan.treatmentSessions}">
                                        <div class="mt-3">
                                            <h6 class="mb-2">Buổi Điều Trị:</h6>
                                            <c:forEach var="session" items="${plan.treatmentSessions}">
                                                <div class="session-item">
                                                    <div class="d-flex justify-content-between align-items-start">
                                                        <div>
                                                            <h6 class="mb-1">Buổi #${session.sessionId}</h6>
                                                            <c:if test="${not empty session.procedureDone}">
                                                                <p class="mb-1">${session.procedureDone}</p>
                                                            </c:if>
                                                            <c:if test="${not empty session.sessionCost}">
                                                                <span class="cost-badge">
                                                                    <i class="fas fa-dollar-sign me-1"></i>
                                                                    <fmt:formatNumber value="${session.sessionCost}" pattern="#,##0" /> VNĐ
                                                                </span>
                                                            </c:if>
                                                        </div>
                                                        <div>
                                                            <span class="status-badge status-completed">
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
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-clipboard-check"></i>
                                <p>Chưa có kế hoạch điều trị nào</p>
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
                        <a href="${pageContext.request.contextPath}/prescription-form?patient_id=${medicalRecord.patientId}" 
                           class="btn btn-primary">
                            <i class="fas fa-prescription me-1"></i>
                            Kê Đơn Thuốc
                        </a>
                        <a href="${pageContext.request.contextPath}/upload-result?patient_id=${medicalRecord.patientId}" 
                           class="btn btn-success">
                            <i class="fas fa-upload me-1"></i>
                            Upload Kết Quả
                        </a>
                        <a href="${pageContext.request.contextPath}/treatment-history?patient_id=${medicalRecord.patientId}" 
                           class="btn btn-secondary">
                            <i class="fas fa-history me-1"></i>
                            Xem Lịch Sử
                        </a>
                    </div>
                </div>
                
            </div>
        </main>
    </div>
</body>
</html>
