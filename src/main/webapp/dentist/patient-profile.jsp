<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Bệnh Nhân - ${patient.fullName} - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .patient-header {
            background: #06b6d4;
            color: white;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border-radius: 0.5rem;
        }
        
        .patient-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            border: 3px solid white;
            object-fit: cover;
            margin-right: 1rem;
            display: block;
            background-color: #f3f4f6;
        }
        
        .avatar-container {
            position: relative;
            display: inline-block;
            margin-right: 1rem;
        }
        
        .avatar-upload-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.6);
            border-radius: 50%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.7rem;
            opacity: 0;
            transition: opacity 0.3s ease;
            cursor: pointer;
        }
        
        .avatar-container:hover .avatar-upload-overlay {
            opacity: 1;
        }
        
        /* Hide upload overlay for Dentist role */
        .avatar-container.no-upload:hover .avatar-upload-overlay {
            opacity: 0;
        }
        
        .avatar-upload-overlay i {
            font-size: 1rem;
            margin-bottom: 0.2rem;
        }
        
        #avatarFile {
            display: none;
        }
        
        .patient-info {
            flex: 1;
            display: flex;
            align-items: center;
            gap: 2rem;
        }
        
        .patient-name {
            font-size: 1.5rem;
            font-weight: 700;
            margin: 0;
            min-width: 200px;
        }
        
        .patient-details {
            display: flex;
            gap: 1.5rem;
            flex: 1;
        }
        
        .detail-item {
            display: flex;
            align-items: center;
            padding: 0.4rem 0.8rem;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 0.25rem;
            white-space: nowrap;
        }
        
        .detail-item i {
            font-size: 0.9rem;
            margin-right: 0.4rem;
            width: 16px;
            text-align: center;
        }
        
        .detail-item span {
            font-weight: 500;
            font-size: 0.9rem;
        }
        
        .patient-actions {
            display: flex;
            gap: 0.8rem;
            align-items: center;
        }
        
        .btn-back {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            padding: 0.4rem 0.8rem;
            border-radius: 0.25rem;
            font-weight: 500;
            text-decoration: none;
            transition: background-color 0.2s ease;
            font-size: 0.875rem;
        }
        
        .btn-back:hover {
            background: rgba(255, 255, 255, 0.3);
            color: white;
        }
        
        .patient-status {
            display: inline-flex;
            align-items: center;
            padding: 0.2rem 0.6rem;
            background: rgba(34, 197, 94, 0.2);
            border: 1px solid rgba(34, 197, 94, 0.3);
            border-radius: 0.25rem;
            color: #dcfce7;
            font-weight: 500;
            font-size: 0.8rem;
        }
        
        .patient-status i {
            margin-right: 0.4rem;
            font-size: 0.8rem;
        }
        
        /* Responsive for smaller screens */
        @media (max-width: 1200px) {
            .patient-details {
                gap: 1rem;
            }
            
            .detail-item {
                padding: 0.3rem 0.6rem;
                font-size: 0.85rem;
            }
        }
        
        @media (max-width: 992px) {
            .patient-info {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
            
            .patient-details {
                flex-wrap: wrap;
                gap: 0.8rem;
            }
        }
        
        @media (max-width: 768px) {
            .patient-header {
                padding: 1rem;
            }
            
            .patient-avatar {
                width: 60px;
                height: 60px;
            }
            
            .patient-name {
                font-size: 1.25rem;
                min-width: auto;
            }
            
            .detail-item {
                padding: 0.25rem 0.5rem;
                font-size: 0.8rem;
            }
        }
        
        .patient-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            padding: 0.75rem;
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 0.5rem;
            backdrop-filter: blur(10px);
        }
        
        .info-item i {
            margin-right: 0.5rem;
            width: 20px;
            text-align: center;
        }
        
        .section-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }
        
        .section-title {
            color: #0f172a;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            border-bottom: 2px solid #06b6d4;
            padding-bottom: 0.5rem;
        }
        
        .tab-button {
            background: none;
            border: none;
            color: #6b7280;
            font-weight: 500;
            padding: 0.75rem 1.5rem;
            margin-right: 0.5rem;
            border-radius: 0.5rem 0.5rem 0 0;
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
            font-size: 0.95rem;
        }
        
        .tab-button:hover {
            background-color: #f1f5f9;
            color: #06b6d4;
        }
        
        .tab-button.active {
            background: #06b6d4;
            color: white;
            font-weight: 600;
        }
        
        .tab-button.active::after {
            content: '';
            position: absolute;
            bottom: -1px;
            left: 0;
            right: 0;
            height: 2px;
            background: #06b6d4;
        }
        
        .tab-content-container {
            min-height: 500px;
            padding: 1.5rem;
        }
        
        .tab-pane {
            display: none;
            min-height: 450px;
        }
        
        .tab-pane.active {
            display: block;
        }
        
        .tab-pane.loading {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 300px;
        }
        
        .tab-pane h5 {
            color: #0f172a;
            font-weight: 600;
            font-size: 1.25rem;
        }
        
        .badge {
            font-size: 0.75rem;
            padding: 0.375rem 0.75rem;
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
            background: #e2e8f0;
        }
        
        .timeline-item {
            position: relative;
            margin-bottom: 2rem;
            padding-left: 2rem;
        }
        
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -1.5rem;
            top: 0.5rem;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #06b6d4;
            border: 3px solid white;
            box-shadow: 0 0 0 3px #e2e8f0;
        }
        
        .timeline-content {
            background: white;
            border-radius: 0.75rem;
            padding: 1.5rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }
        
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            font-weight: 500;
        }
        
        .status-scheduled {
            background-color: #fef3c7;
            color: #92400e;
        }
        
        .status-confirmed {
            background-color: #dbeafe;
            color: #1e40af;
        }
        
        .status-completed {
            background-color: #d1fae5;
            color: #065f46;
        }
        
        .status-cancelled {
            background-color: #fee2e2;
            color: #991b1b;
        }
        
        .image-gallery {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }
        
        .image-item {
            position: relative;
            border-radius: 0.75rem;
            overflow: hidden;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
            border: 1px solid #e2e8f0;
        }
        
        .image-item:hover {
            transform: scale(1.05);
        }
        
        .image-item img {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }
        
        .image-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(0, 0, 0, 0.7));
            color: white;
            padding: 1rem;
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
            color: white;
        }
        
        .btn-secondary {
            background-color: #6b7280;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #4b5563;
            color: white;
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: #6b7280;
        }
        
        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #d1d5db;
        }
        
        .table {
            margin-bottom: 0;
        }
        
        .table th {
            background-color: #f8fafc;
            border-top: none;
            font-weight: 600;
            color: #374151;
            padding: 0.75rem;
        }
        
        .table td {
            padding: 0.75rem;
            vertical-align: middle;
        }
        
        .table-hover tbody tr:hover {
            background-color: #f8fafc;
        }
        
        .card {
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
        }
        
        .card-header {
            background-color: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            font-weight: 600;
        }
        
        @media (max-width: 768px) {
            .tab-content {
                padding: 1rem;
            }
            
            .patient-info-grid {
                grid-template-columns: 1fr;
            }
            
            .table-responsive {
                font-size: 0.875rem;
            }
            
            .timeline {
                padding-left: 1rem;
            }
            
            .timeline::before {
                left: 0.5rem;
            }
            
            .timeline-item {
                padding-left: 1.5rem;
            }
            
            .timeline-item::before {
                left: -1rem;
            }
        }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>
    
    <!-- Header -->
    <div class="header">
        <h1>🦷 Hồ Sơ Bệnh Nhân - ${patient.fullName}</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
                <div class="container">
                <!-- Patient Header -->
                <div class="patient-header">
                    <div class="d-flex align-items-center">
                        <div class="avatar-container ${currentUser.role.roleName == 'Dentist' ? 'no-upload' : ''}">
                            <c:choose>
                                <c:when test="${not empty patient.avatar}">
                                    <c:choose>
                                        <c:when test="${patient.avatar.startsWith('http')}">
                                            <img src="${patient.avatar}" 
                                                 alt="Avatar" class="patient-avatar" id="avatarImage"
                                                 onerror="this.src='https://via.placeholder.com/80x80/06b6d4/ffffff?text=${patient.fullName.charAt(0)}'">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}${patient.avatar}" 
                                                 alt="Avatar" class="patient-avatar" id="avatarImage"
                                                 onerror="this.src='https://via.placeholder.com/80x80/06b6d4/ffffff?text=${patient.fullName.charAt(0)}'">
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <img src="https://via.placeholder.com/80x80/06b6d4/ffffff?text=${patient.fullName.charAt(0)}" 
                                         alt="Avatar" class="patient-avatar" id="avatarImage">
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${currentUser.role.roleName == 'Administrator' || currentUser.role.roleName == 'Receptionist'}">
                                <div class="avatar-upload-overlay" onclick="document.getElementById('avatarFile').click()">
                                    <i class="fas fa-camera"></i>
                                    <span>Đổi ảnh</span>
                        </div>
                            </c:if>
                        </div>
                            <div class="patient-info">
                                <h1 class="patient-name">${patient.fullName}</h1>
                                
                                <div class="patient-details">
                                    <div class="detail-item">
                                        <i class="fas fa-phone"></i>
                                        <span>${patient.phone}</span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="fas fa-envelope"></i>
                                        <span>${patient.email}</span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="fas fa-birthday-cake"></i>
                                        <span>${patient.birthDate}</span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="fas fa-venus-mars"></i>
                                        <span>
                                    <c:choose>
                                        <c:when test="${patient.gender == 'M'}">Nam</c:when>
                                        <c:when test="${patient.gender == 'F'}">Nữ</c:when>
                                        <c:otherwise>Khác</c:otherwise>
                                    </c:choose>
                                </span>
                        </div>
                                </div>
                                
                                <div class="patient-actions">
                                    <div class="patient-status">
                                        <i class="fas fa-user-check"></i>
                                        <span>Bệnh nhân</span>
                                    </div>
                                    <c:if test="${currentUser.role.roleName == 'Dentist' || currentUser.role.roleName == 'Administrator'}">
                                        <a href="${pageContext.request.contextPath}/medical-record?action=form&patientId=${patient.patientId}" 
                                           class="btn-back" style="background: rgba(59, 130, 246, 0.2); border-color: rgba(59, 130, 246, 0.3);">
                                            <i class="fas fa-edit me-2"></i>Ghi Chú & Điều Trị
                                        </a>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/dentist/patients" 
                                       class="btn-back">
                                <i class="fas fa-arrow-left me-2"></i>Quay Lại
                            </a>
                                </div>
                        </div>
                    </div>
                </div>
            </div>

                <!-- Additional Patient Info -->
                <div class="section-card">
                    <div class="section-title">
                        <i class="fas fa-info-circle me-2"></i>Thông Tin Chi Tiết
                    </div>
                    <div class="patient-info-grid">
                        <div class="info-item">
                            <i class="fas fa-map-marker-alt"></i>
                            <span>${patient.address}</span>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-calendar-plus"></i>
                            <span>Ngày tạo: ${patient.createdAt}</span>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-id-card"></i>
                            <span>ID: ${patient.patientId}</span>
                    </div>
                </div>
            </div>

                <!-- Main Content -->
                <div class="row">
                    <!-- Basic Information -->
                    <div class="col-md-4">
                        <div class="section-card">
                            <h3 class="section-title">
                                    <i class="fas fa-user me-2"></i>Thông Tin Cá Nhân
                            </h3>
                            
                                <div class="info-item">
                                <i class="fas fa-user"></i>
                                <div>
                                    <strong>Họ Tên:</strong><br>
                                    ${patient.fullName}
                                </div>
                            </div>
                            
                                <div class="info-item">
                                <i class="fas fa-birthday-cake"></i>
                                <div>
                                    <strong>Ngày Sinh:</strong><br>
                                        ${patient.birthDate}
                                </div>
                            </div>
                            
                                <div class="info-item">
                                <i class="fas fa-venus-mars"></i>
                                <div>
                                    <strong>Giới Tính:</strong><br>
                                        <c:choose>
                                            <c:when test="${patient.gender == 'M'}">Nam</c:when>
                                            <c:when test="${patient.gender == 'F'}">Nữ</c:when>
                                            <c:otherwise>Khác</c:otherwise>
                                        </c:choose>
                                </div>
                                </div>
                            
                                <div class="info-item">
                                <i class="fas fa-phone"></i>
                                <div>
                                    <strong>Số Điện Thoại:</strong><br>
                                    ${patient.phone}
                                </div>
                            </div>
                            
                                <div class="info-item">
                                <i class="fas fa-envelope"></i>
                                <div>
                                    <strong>Email:</strong><br>
                                    ${patient.email}
                                </div>
                            </div>
                            
                                <div class="info-item">
                                <i class="fas fa-map-marker-alt"></i>
                                <div>
                                    <strong>Địa Chỉ:</strong><br>
                                    ${patient.address}
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tabs Content -->
                    <div class="col-md-8">
                        <div class="section-card">
                        <!-- Tabs Navigation -->
                            <div class="d-flex border-bottom mb-3">
                                <button class="tab-button active" data-tab="medical">
                                    <i class="fas fa-file-medical me-2"></i>Hồ Sơ Y Tế
                                </button>
                                <button class="tab-button" data-tab="appointments">
                                    <i class="fas fa-calendar-alt me-2"></i>Lịch Hẹn
                                </button>
                                <button class="tab-button" data-tab="prescriptions">
                                    <i class="fas fa-prescription me-2"></i>Đơn Thuốc
                                </button>
                                <button class="tab-button" data-tab="images">
                                    <i class="fas fa-images me-2"></i>Hình Ảnh
                                </button>
                            </div>

                        <!-- Tab Content -->
                            <div class="tab-content-container">
                            <!-- Medical Records Tab -->
                                <div class="tab-pane active" id="medical" data-loaded="true">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h5 class="mb-0">
                                    <i class="fas fa-file-medical me-2"></i>Hồ Sơ Y Tế
                                </h5>
                                        <span class="badge bg-primary">${medicalRecords.size()} hồ sơ</span>
                                    </div>
                                
                                <c:choose>
                                    <c:when test="${not empty medicalRecords}">
                                        <div class="timeline">
                                            <c:forEach var="record" items="${medicalRecords}">
                                                <div class="timeline-item">
                                                    <div class="timeline-content">
                                                        <div class="d-flex justify-content-between align-items-start mb-3">
                                                            <h6 class="mb-0">
                                                                <i class="fas fa-file-medical me-2"></i>
                                                                Hồ Sơ #${record.recordId}
                                                            </h6>
                                                            <small class="text-muted">
                                                                ${record.createdAt}
                                                            </small>
                                                        </div>
                                                        
                                                        <p class="text-muted mb-3">${record.summary}</p>
                                                        
                                                        <c:if test="${not empty record.dentist}">
                                                            <p class="mb-2">
                                                                <i class="fas fa-user-md me-2"></i>
                                                                Bác sĩ: ${record.dentist.fullName}
                                                            </p>
                                                        </c:if>
                                                        
                                                        <!-- Examinations -->
                                                        <c:if test="${not empty record.examinations}">
                                                            <div class="mt-3">
                                                                <h6 class="text-primary mb-2">
                                                                    <i class="fas fa-stethoscope me-2"></i>Kết Quả Khám
                                                                </h6>
                                                                <c:forEach var="exam" items="${record.examinations}">
                                                                    <div class="card mb-2">
                                                                        <div class="card-body py-2">
                                                                            <p class="mb-1"><strong>Triệu chứng:</strong> ${exam.findings}</p>
                                                                            <p class="mb-0"><strong>Chẩn đoán:</strong> ${exam.diagnosis}</p>
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                            </div>
                                                        </c:if>
                                                        
                                                        <!-- Treatment Plans -->
                                                        <c:if test="${not empty record.treatmentPlans}">
                                                            <div class="mt-3">
                                                                <h6 class="text-success mb-2">
                                                                    <i class="fas fa-clipboard-list me-2"></i>Kế Hoạch Điều Trị
                                                                </h6>
                                                                <c:forEach var="plan" items="${record.treatmentPlans}">
                                                                    <div class="card mb-2">
                                                                        <div class="card-body py-2">
                                                                            <p class="mb-1">${plan.planSummary}</p>
                                                                            <p class="mb-0 text-success">
                                                                                <strong>Chi phí dự kiến:</strong> 
                                                                                <fmt:formatNumber value="${plan.estimatedCost}" type="currency" currencySymbol="₫"/>
                                                                            </p>
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
                                                <i class="fas fa-file-medical"></i>
                                                <h5>Chưa có hồ sơ y tế</h5>
                                                <p>Bệnh nhân chưa có hồ sơ khám bệnh nào</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Appointments Tab -->
                                <div class="tab-pane" id="appointments" data-loaded="true">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h5 class="mb-0">
                                    <i class="fas fa-calendar-alt me-2"></i>Lịch Hẹn
                                </h5>
                                        <span class="badge bg-primary">${appointments.size()} cuộc hẹn</span>
                                    </div>
                                
                                <c:choose>
                                    <c:when test="${not empty appointments}">
                                        <div class="table-responsive">
                                            <table class="table table-hover">
                                                <thead>
                                                    <tr>
                                                        <th>Ngày Giờ</th>
                                                        <th>Dịch Vụ</th>
                                                        <th>Bác Sĩ</th>
                                                        <th>Trạng Thái</th>
                                                        <th>Ghi Chú</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="appointment" items="${appointments}">
                                                        <tr>
                                                            <td>
                                                                    <div class="d-flex flex-column">
                                                                        <span class="fw-bold">
                                                                            <fmt:formatDate value="${appointment.appointmentDateAsDate}" pattern="dd/MM/yyyy"/>
                                                                        </span>
                                                                        <small class="text-muted">
                                                                            <fmt:formatDate value="${appointment.appointmentDateAsDate}" pattern="HH:mm"/>
                                                                        </small>
                                                                    </div>
                                                            </td>
                                                                <td>
                                                                    <span class="fw-medium">${appointment.service.name}</span>
                                                                </td>
                                                                <td>
                                                                    <div class="d-flex align-items-center">
                                                                        <i class="fas fa-user-md me-2 text-primary"></i>
                                                                        <span>${appointment.dentist.fullName}</span>
                                                                    </div>
                                                                </td>
                                                            <td>
                                                                <span class="status-badge status-${appointment.status.toLowerCase()}">
                                                                    <c:choose>
                                                                        <c:when test="${appointment.status == 'SCHEDULED'}">Đã Lên Lịch</c:when>
                                                                        <c:when test="${appointment.status == 'CONFIRMED'}">Đã Xác Nhận</c:when>
                                                                        <c:when test="${appointment.status == 'COMPLETED'}">Hoàn Thành</c:when>
                                                                        <c:when test="${appointment.status == 'CANCELLED'}">Đã Hủy</c:when>
                                                                        <c:otherwise>${appointment.status}</c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty appointment.notes}">
                                                                            <span class="text-truncate d-inline-block" style="max-width: 200px;" title="${appointment.notes}">
                                                                                ${appointment.notes}
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">-</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                            <div class="empty-state">
                                                <i class="fas fa-calendar-alt"></i>
                                                <h5>Chưa có lịch hẹn</h5>
                                                <p>Bệnh nhân chưa có lịch hẹn nào</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Prescriptions Tab -->
                                <div class="tab-pane" id="prescriptions" data-loaded="true">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h5 class="mb-0">
                                    <i class="fas fa-prescription me-2"></i>Đơn Thuốc
                                </h5>
                                        <span class="badge bg-primary">${prescriptions.size()} đơn thuốc</span>
                                    </div>
                                
                                <c:choose>
                                    <c:when test="${not empty prescriptions}">
                                        <c:forEach var="prescription" items="${prescriptions}">
                                            <div class="card mb-3">
                                                <div class="card-header d-flex justify-content-between align-items-center">
                                                    <h6 class="mb-0">
                                                            <i class="fas fa-prescription me-2 text-primary"></i>
                                                        Đơn Thuốc #${prescription.prescriptionId}
                                                    </h6>
                                                        <div class="d-flex align-items-center">
                                                            <i class="fas fa-calendar me-2 text-muted"></i>
                                                            <small class="text-muted">${prescription.createdAt}</small>
                                                        </div>
                                                </div>
                                                <div class="card-body">
                                                        <div class="row mb-3">
                                                    <c:if test="${not empty prescription.dentist}">
                                                                <div class="col-md-6">
                                                                    <div class="d-flex align-items-center">
                                                                        <i class="fas fa-user-md me-2 text-primary"></i>
                                                                        <div>
                                                                            <small class="text-muted d-block">Bác sĩ kê đơn</small>
                                                                            <span class="fw-medium">${prescription.dentist.fullName}</span>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                    </c:if>
                                                        </div>
                                                    
                                                    <c:if test="${not empty prescription.notes}">
                                                            <div class="alert alert-info mb-3">
                                                                <i class="fas fa-info-circle me-2"></i>
                                                            <strong>Ghi chú:</strong> ${prescription.notes}
                                                            </div>
                                                    </c:if>
                                                    
                                                    <c:if test="${not empty prescription.prescriptionItems}">
                                                            <h6 class="text-primary mb-3">
                                                                <i class="fas fa-pills me-2"></i>Thuốc được kê
                                                            </h6>
                                                        <div class="table-responsive">
                                                                <table class="table table-sm table-hover">
                                                                <thead>
                                                                    <tr>
                                                                            <th><i class="fas fa-medkit me-1"></i> Tên Thuốc</th>
                                                                            <th><i class="fas fa-weight me-1"></i> Liều Lượng</th>
                                                                            <th><i class="fas fa-clock me-1"></i> Thời Gian</th>
                                                                            <th><i class="fas fa-info-circle me-1"></i> Hướng Dẫn</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:forEach var="item" items="${prescription.prescriptionItems}">
                                                                        <tr>
                                                                                <td class="fw-medium">${item.medicationName}</td>
                                                                                <td><span class="badge bg-light text-dark">${item.dosage}</span></td>
                                                                                <td><span class="text-muted">${item.duration}</span></td>
                                                                                <td><small class="text-muted">${item.instructions}</small></td>
                                                                        </tr>
                                                                    </c:forEach>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                            <div class="empty-state">
                                                <i class="fas fa-prescription"></i>
                                                <h5>Chưa có đơn thuốc</h5>
                                                <p>Bệnh nhân chưa có đơn thuốc nào</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Images Tab -->
                                <div class="tab-pane" id="images" data-loaded="true">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h5 class="mb-0">
                                    <i class="fas fa-images me-2"></i>Hình Ảnh
                                </h5>
                                        <span class="badge bg-primary">${patientImages.size()} hình ảnh</span>
                                    </div>
                                
                                <c:choose>
                                    <c:when test="${not empty patientImages}">
                                        <div class="image-gallery">
                                            <c:forEach var="image" items="${patientImages}">
                                                <div class="image-item">
                                                    <img src="${image.filePath}" alt="Patient Image">
                                                    <div class="image-overlay">
                                                        <h6 class="mb-1">${image.imageType}</h6>
                                                            <small>${image.uploadedAt}</small>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                            <div class="empty-state">
                                                <i class="fas fa-images"></i>
                                                <h5>Chưa có hình ảnh</h5>
                                                <p>Bệnh nhân chưa có hình ảnh nào</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Avatar Upload Form (only for Administrator and Receptionist) -->
    <c:if test="${currentUser.role.roleName == 'Administrator' || currentUser.role.roleName == 'Receptionist'}">
        <form id="avatarUploadForm" action="${pageContext.request.contextPath}/patient/profile" method="post" enctype="multipart/form-data" style="display: none;">
            <input type="hidden" name="action" value="uploadAvatar">
            <input type="hidden" name="patientId" value="${patient.patientId}">
            <input type="file" id="avatarFile" name="avatar" accept="image/*" onchange="uploadAvatar()">
        </form>
    </c:if>

    <script>
        function uploadAvatar() {
            // Check if user has permission to upload avatar
            const userRole = '${currentUser.role.roleName}';
            if (userRole !== 'Administrator' && userRole !== 'Receptionist') {
                alert('Bạn không có quyền cập nhật ảnh đại diện của bệnh nhân');
                return;
            }
            
            const fileInput = document.getElementById('avatarFile');
            if (!fileInput) {
                alert('Chức năng upload không khả dụng');
                return;
            }
            
            const file = fileInput.files[0];
            if (!file) {
                return;
            }
            
            // Validate file type
            const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
            if (!allowedTypes.includes(file.type)) {
                alert('Chỉ chấp nhận file ảnh (JPG, JPEG, PNG, GIF)');
                return;
            }
            
            // Validate file size (max 10MB)
            const maxSize = 10 * 1024 * 1024; // 10MB
            if (file.size > maxSize) {
                alert('Kích thước file không được vượt quá 10MB');
                return;
            }
            
            // Show loading
            const avatarImage = document.getElementById('avatarImage');
            const originalSrc = avatarImage.src;
            avatarImage.style.opacity = '0.5';
            
            // Submit form
            const form = document.getElementById('avatarUploadForm');
            form.submit();
        }
        
        function checkMedicalRecordAccess() {
            const userRole = '${currentUser.role.roleName}';
            console.log('User role:', userRole);
            
            if (userRole !== 'Dentist' && userRole !== 'Administrator') {
                alert('Bạn không có quyền truy cập chức năng này');
                return false;
            }
            
            const patientId = '${patient.patientId}';
            console.log('Patient ID:', patientId);
            
            if (!patientId) {
                alert('Không tìm thấy ID bệnh nhân');
                return false;
            }
            
            // Test URL
            const url = '${pageContext.request.contextPath}/medical-record/form?patientId=' + patientId;
            console.log('Redirecting to:', url);
            
            return true;
        }
    </script>
    
    <!-- Success/Error Messages -->
    <c:if test="${not empty successMessage}">
        <script>
            alert('${successMessage}');
        </script>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <script>
            alert('${errorMessage}');
        </script>
    </c:if>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Tab switching functionality
        document.addEventListener('DOMContentLoaded', function() {
            const tabButtons = document.querySelectorAll('.tab-button');
            const tabPanes = document.querySelectorAll('.tab-pane');
            
            tabButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const targetTab = this.getAttribute('data-tab');
                    
                    // Remove active class from all buttons and panes
                    tabButtons.forEach(btn => btn.classList.remove('active'));
                    tabPanes.forEach(pane => pane.classList.remove('active'));
                    
                    // Add active class to clicked button
                    this.classList.add('active');
                    
                    // Show target tab
                    const targetPane = document.getElementById(targetTab);
                    if (targetPane) {
                        targetPane.classList.add('active');
                    }
                });
            });
        });
        
        
    </script>
</body>
</html>
