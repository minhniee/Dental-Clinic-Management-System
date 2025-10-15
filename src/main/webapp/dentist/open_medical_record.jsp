<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mở Hồ Sơ Khám - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .patient-info-card {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
        }
        
        .section-title {
            color: #0f172a;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            border-bottom: 2px solid #06b6d4;
            padding-bottom: 0.5rem;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
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
        
        .file-list, .record-list {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
        }
        
        .file-item, .record-item {
            padding: 1rem;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
            background-color: #f8fafc;
        }
        
        .file-item:last-child, .record-item:last-child {
            margin-bottom: 0;
        }
        
        .form-container {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            color: #0f172a;
            font-weight: 600;
        }
        
        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 0.5rem;
            font-size: 1rem;
            transition: border-color 0.2s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #06b6d4;
            box-shadow: 0 0 0 3px rgba(6, 182, 212, 0.1);
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 0.5rem;
            font-size: 1rem;
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
        
        .alert {
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
        }
        
        .alert-error {
            background-color: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
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
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login.jsp"/>
    </c:if>

    <div class="header">
        <h1>🦷 Mở Hồ Sơ Khám</h1>
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
                
                <!-- Patient Information -->
                <c:if test="${not empty patient}">
                    <div class="patient-info-card">
                        <h2 class="section-title">
                            <i class="fas fa-user me-2"></i>
                            Thông Tin Bệnh Nhân
                        </h2>
                        
                        <div class="info-grid">
                            <div class="info-item">
                                <i class="fas fa-id-card"></i>
                                <div>
                                    <strong>Họ và Tên:</strong> ${patient.fullName}
                                </div>
                            </div>
                            
                            <c:if test="${not empty patient.birthDate}">
                                <div class="info-item">
                                    <i class="fas fa-birthday-cake"></i>
                                    <div>
                                        <strong>Ngày Sinh:</strong> 
                                        ${patient.birthDate}
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty patient.gender}">
                                <div class="info-item">
                                    <i class="fas fa-venus-mars"></i>
                                    <div>
                                        <strong>Giới Tính:</strong> 
                                        <c:choose>
                                            <c:when test="${patient.gender.toString() == 'M'}">Nam</c:when>
                                            <c:when test="${patient.gender.toString() == 'F'}">Nữ</c:when>
                                            <c:otherwise>Khác</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty patient.phone}">
                                <div class="info-item">
                                    <i class="fas fa-phone"></i>
                                    <div>
                                        <strong>Điện Thoại:</strong> ${patient.phone}
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty patient.email}">
                                <div class="info-item">
                                    <i class="fas fa-envelope"></i>
                                    <div>
                                        <strong>Email:</strong> ${patient.email}
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty patient.address}">
                                <div class="info-item">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <div>
                                        <strong>Địa Chỉ:</strong> ${patient.address}
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:if>
                
                <!-- Patient Files -->
                <div class="file-list">
                    <h3 class="section-title">
                        <i class="fas fa-file-alt me-2"></i>
                        File Đính Kèm
                    </h3>
                    
                    <c:choose>
                        <c:when test="${not empty patientFiles}">
                            <c:forEach var="file" items="${patientFiles}">
                                <div class="file-item">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <h6 class="mb-1">${file.content}</h6>
                                            <small class="text-muted">
                                                <i class="fas fa-clock me-1"></i>
                                                ${file.uploadedAt}
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-file-alt"></i>
                                <p>Chưa có file đính kèm nào</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Medical Records History -->
                <div class="record-list">
                    <h3 class="section-title">
                        <i class="fas fa-history me-2"></i>
                        Lịch Sử Khám Bệnh
                    </h3>
                    
                    <c:choose>
                        <c:when test="${not empty medicalRecords}">
                            <c:forEach var="record" items="${medicalRecords}">
                                <div class="record-item">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <h6 class="mb-1">
                                                <a href="${pageContext.request.contextPath}/record-detail?record_id=${record.recordId}" 
                                                   class="text-decoration-none">
                                                    Hồ Sơ #${record.recordId}
                                                </a>
                                            </h6>
                                            <p class="mb-1">${record.summary}</p>
                                            <small class="text-muted">
                                                <i class="fas fa-user-md me-1"></i>
                                                ${record.dentist.fullName} - 
                                                <i class="fas fa-clock me-1"></i>
                                                ${record.createdAt}
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-history"></i>
                                <p>Chưa có lịch sử khám bệnh</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Create New Medical Record Form -->
                <div class="form-container">
                    <h3 class="section-title">
                        <i class="fas fa-plus-circle me-2"></i>
                        Tạo Hồ Sơ Khám Mới
                    </h3>
                    
                    <form action="${pageContext.request.contextPath}/create-medical-record" method="POST">
                        <input type="hidden" name="patient_id" value="${patient.patientId}">
                        
                        <div class="form-group">
                            <label for="summary" class="form-label">
                                Tóm Tắt Hồ Sơ Khám <span class="text-danger">*</span>
                            </label>
                            <textarea id="summary" name="summary" class="form-control" rows="6" 
                                      placeholder="Nhập tóm tắt về tình trạng sức khỏe răng miệng, triệu chứng, dị ứng, tiền sử bệnh..." 
                                      required></textarea>
                        </div>
                        
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>
                                Tạo Hồ Sơ Khám
                            </button>
                            <a href="${pageContext.request.contextPath}/dentist/patients" class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i>
                                Quay Lại
                            </a>
                        </div>
                    </form>
                </div>
                
            </div>
        </main>
    </div>
</body>
</html>
