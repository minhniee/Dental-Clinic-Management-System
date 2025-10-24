<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Khám Bệnh - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .search-container {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
        }
        
        .search-form {
            display: flex;
            gap: 1rem;
            align-items: end;
        }
        
        .search-input {
            flex: 1;
        }
        
        .search-input input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            font-size: 1rem;
        }
        
        .patient-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .patient-card:hover {
            border-color: #06b6d4;
            box-shadow: 0 4px 12px 0 rgba(6, 182, 212, 0.15);
            transform: translateY(-2px);
        }
        
        .patient-header {
            display: flex;
            justify-content: between;
            align-items: start;
            margin-bottom: 1rem;
        }
        
        .patient-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1rem;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            padding: 0.5rem;
            background-color: #f8fafc;
            border-radius: 0.5rem;
        }
        
        .info-item i {
            color: #06b6d4;
            margin-right: 0.5rem;
            width: 16px;
        }
        
        .medical-summary {
            background: #f0f9ff;
            border: 1px solid #0ea5e9;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-top: 1rem;
        }
        
        .summary-stats {
            display: flex;
            gap: 2rem;
            margin-bottom: 0.5rem;
        }
        
        .stat-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .stat-number {
            font-weight: 700;
            color: #0ea5e9;
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
                
                <!-- Error Message -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${errorMessage}
                    </div>
                </c:if>
                
                <!-- Search Container -->
                <div class="search-container">
                    <h3><i class="fas fa-search me-2"></i>Tìm Kiếm Bệnh Nhân</h3>
                    <form class="search-form" method="get">
                        <div class="search-input">
                            <input type="text" name="search" placeholder="Nhập tên bệnh nhân hoặc số điện thoại..." 
                                   value="${param.search}" autocomplete="off">
                        </div>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search me-1"></i>Tìm Kiếm
                        </button>
                    </form>
                </div>
                
                <!-- Patients List -->
                <c:choose>
                    <c:when test="${not empty patients}">
                        <c:forEach var="patient" items="${patients}">
                            <div class="patient-card" onclick="viewPatientHistory(${patient.patientId})">
                                <div class="patient-header">
                                    <h4>${patient.fullName}</h4>
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
                                
                                <div class="medical-summary">
                                    <div class="summary-stats">
                                        <div class="stat-item">
                                            <i class="fas fa-file-medical"></i>
                                            <span>Số lần khám: <span class="stat-number">${patient.medicalRecordCount}</span></span>
                                        </div>
                                        <c:if test="${not empty patient.lastVisitDateAsDate}">
                                            <div class="stat-item">
                                                <i class="fas fa-calendar"></i>
                                                <span>Lần cuối: <span class="stat-number">
                                                    <fmt:formatDate value="${patient.lastVisitDateAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </span></span>
                                            </div>
                                        </c:if>
                                    </div>
                                    <div style="color: #64748b; font-size: 0.875rem;">
                                        <i class="fas fa-info-circle me-1"></i>
                                        Nhấp để xem chi tiết lịch sử khám bệnh
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-user-friends"></i>
                            <h4>Chưa có bệnh nhân nào</h4>
                            <p>Hệ thống chưa có thông tin bệnh nhân nào.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
                
            </div>
        </main>
    </div>
    
    <script>
        function viewPatientHistory(patientId) {
            window.location.href = '/dental_clinic_management_system/dentist/medical-history?action=patient&patientId=' + patientId;
        }
    </script>
</body>
</html>
