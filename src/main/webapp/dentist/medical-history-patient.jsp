<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Khám Bệnh - ${patient.fullName}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .patient-header {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
        }
        
        .patient-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        
        .patient-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            padding: 0.75rem;
            background-color: #f8fafc;
            border-radius: 0.5rem;
        }
        
        .info-item i {
            color: #06b6d4;
            margin-right: 0.75rem;
            width: 20px;
        }
        
        .medical-record {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
        }
        
        .medical-record:hover {
            border-color: #06b6d4;
            box-shadow: 0 4px 12px 0 rgba(6, 182, 212, 0.1);
        }
        
        .record-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .record-date {
            color: #6b7280;
            font-size: 0.875rem;
        }
        
        .record-summary {
            color: #374151;
            line-height: 1.6;
            margin-bottom: 1rem;
        }
        
        .record-actions {
            display: flex;
            gap: 0.5rem;
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
        
        .back-btn {
            background-color: #f3f4f6;
            color: #374151;
            border: 1px solid #d1d5db;
        }
        
        .back-btn:hover {
            background-color: #e5e7eb;
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
        
        .record-id {
            font-size: 0.75rem;
            color: #9ca3af;
            background: #f3f4f6;
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
        }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login.jsp"/>
    </c:if>

    <div class="header">
        <h1>📋 Lịch Sử Khám Bệnh</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="container">
                
                <!-- Back Button -->
                <div style="margin-bottom: 1rem;">
                    <a href="/dental_clinic_management_system/dentist/medical-history" class="btn back-btn">
                        <i class="fas fa-arrow-left me-1"></i>Quay Lại
                    </a>
                </div>
                
                <!-- Patient Header -->
                <div class="patient-header">
                    <div class="patient-title">
                        <h2><i class="fas fa-user me-2"></i>${patient.fullName}</h2>
                        <span class="record-id">ID: ${patient.patientId}</span>
                    </div>
                    
                    <div class="patient-info">
                        <c:if test="${not empty patient.phone}">
                            <div class="info-item">
                                <i class="fas fa-phone"></i>
                                <span>${patient.phone}</span>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty patient.email}">
                            <div class="info-item">
                                <i class="fas fa-envelope"></i>
                                <span>${patient.email}</span>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty patient.birthDate}">
                            <div class="info-item">
                                <i class="fas fa-birthday-cake"></i>
                                <span>
                                    ${patient.birthDate}
                                    (<c:choose>
                                        <c:when test="${patient.gender.toString() == 'M'}">Nam</c:when>
                                        <c:when test="${patient.gender.toString() == 'F'}">Nữ</c:when>
                                        <c:otherwise>Khác</c:otherwise>
                                    </c:choose>)
                                </span>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty patient.address}">
                            <div class="info-item">
                                <i class="fas fa-map-marker-alt"></i>
                                <span>${patient.address}</span>
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <!-- Medical Records -->
                <c:choose>
                    <c:when test="${not empty medicalRecords}">
                        <h3><i class="fas fa-file-medical me-2"></i>Lịch Sử Khám Bệnh (${medicalRecords.size()} lần)</h3>
                        
                        <c:forEach var="record" items="${medicalRecords}">
                            <div class="medical-record">
                                <div class="record-header">
                                    <div>
                                        <h4><i class="fas fa-stethoscope me-2"></i>Lần Khám #${record.recordId}</h4>
                                        <div class="record-date">
                                            <i class="fas fa-calendar me-1"></i>
                                            <fmt:formatDate value="${record.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="record-summary">
                                    <c:choose>
                                        <c:when test="${not empty record.summary}">
                                            ${record.summary}
                                        </c:when>
                                        <c:otherwise>
                                            <em style="color: #9ca3af;">Chưa có tóm tắt khám bệnh</em>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="record-actions">
                                    <a href="/dental_clinic_management_system/medical-record?action=view&recordId=${record.recordId}" 
                                       class="btn btn-primary">
                                        <i class="fas fa-eye me-1"></i>Xem Chi Tiết
                                    </a>
                                    <a href="/dental_clinic_management_system/medical-record?action=edit&recordId=${record.recordId}" 
                                       class="btn btn-secondary">
                                        <i class="fas fa-edit me-1"></i>Chỉnh Sửa
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-file-medical"></i>
                            <h4>Chưa có lịch sử khám bệnh</h4>
                            <p>Bệnh nhân này chưa có lịch sử khám bệnh nào trong hệ thống.</p>
                            <a href="/dental_clinic_management_system/medical-record?action=form&patientId=${patient.patientId}" 
                               class="btn btn-primary" style="margin-top: 1rem;">
                                <i class="fas fa-plus me-1"></i>Tạo Hồ Sơ Mới
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
                
            </div>
        </main>
    </div>
</body>
</html>
