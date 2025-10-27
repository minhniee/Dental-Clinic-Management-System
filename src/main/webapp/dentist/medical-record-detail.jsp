<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Hồ Sơ Y Tế #${record.recordId} - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .page-header {
            background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            border-radius: 0 0 1rem 1rem;
        }
        
        .page-header h1 {
            color: white;
            font-weight: 700;
        }
        
        .page-header .text-muted {
            color: rgba(255, 255, 255, 0.8) !important;
        }
        
        .card {
            border: none;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border-radius: 0.75rem;
            margin-bottom: 1.5rem;
        }
        
        .card-header {
            background: #f8fafc;
            border-bottom: 2px solid #e2e8f0;
            border-radius: 0.75rem 0.75rem 0 0 !important;
            padding: 1rem 1.5rem;
        }
        
        .card-header h4 {
            color: #0f172a;
            font-weight: 600;
            margin: 0;
        }
        
        .card-body {
            padding: 1.5rem;
        }
        
        .record-info {
            background: #f8fafc;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .record-info h5 {
            color: #06b6d4;
            margin-bottom: 0.5rem;
        }
        
        .record-meta {
            display: flex;
            gap: 2rem;
            margin-bottom: 1rem;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .meta-item i {
            color: #6b7280;
        }
        
        .examination-item, .treatment-item {
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1rem;
            background: #f8fafc;
        }
        
        .examination-item h6, .treatment-item h6 {
            color: #06b6d4;
            margin-bottom: 0.5rem;
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.15s ease-in-out;
            border: none;
            cursor: pointer;
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
            padding: 2rem;
            color: #6b7280;
        }
        
        .empty-state i {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: #d1d5db;
        }
        
        @media (max-width: 768px) {
            .page-header {
                padding: 1rem 0;
            }
            
            .card-body {
                padding: 1rem;
            }
            
            .record-meta {
                flex-direction: column;
                gap: 0.5rem;
            }
        }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>
    
    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="container-fluid">
                <!-- Page Header -->
                <div class="page-header">
                    <div class="container">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h1 class="mb-1">📋 Chi Tiết Hồ Sơ Y Tế #${record.recordId}</h1>
                                <p class="text-muted mb-0">Bệnh nhân: <strong>${record.patient.fullName}</strong></p>
                            </div>
                            <a href="${pageContext.request.contextPath}/medical-record?action=form&patientId=${record.patientId}" 
                               class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Quay Lại
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Main Content -->
                <div class="container">
                    <!-- Record Information -->
                    <div class="card">
                        <div class="card-header">
                            <h4>
                                <i class="fas fa-file-medical me-2"></i>Thông Tin Hồ Sơ
                            </h4>
                        </div>
                        <div class="card-body">
                            <div class="record-info">
                                <h5>Tóm Tắt Hồ Sơ</h5>
                                <p>${record.summary}</p>
                                
                                <div class="record-meta">
                                    <div class="meta-item">
                                        <i class="fas fa-calendar"></i>
                                        <span>Ngày tạo: 
                                            <c:choose>
                                                <c:when test="${not empty record.createdAt}">
                                                    ${record.createdAt.dayOfMonth}/${record.createdAt.monthValue}/${record.createdAt.year} ${record.createdAt.hour}:${record.createdAt.minute < 10 ? '0' : ''}${record.createdAt.minute}
                                                </c:when>
                                                <c:otherwise>
                                                    Chưa có ngày tạo
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="meta-item">
                                        <i class="fas fa-user"></i>
                                        <span>Bệnh nhân: ${record.patient.fullName}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Examinations -->
                    <div class="card">
                        <div class="card-header">
                            <h4>
                                <i class="fas fa-stethoscope me-2"></i>Kết Quả Khám
                            </h4>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty record.examinations}">
                                    <c:forEach var="exam" items="${record.examinations}">
                                        <div class="examination-item">
                                            <h6>Khám #${exam.examId}</h6>
                                            <p><strong>Triệu chứng:</strong> ${exam.findings}</p>
                                            <p><strong>Chẩn đoán:</strong> ${exam.diagnosis}</p>
                                            <p><strong>Ghi chú:</strong> ${exam.notes}</p>
                                            <small class="text-muted">
                                                <i class="fas fa-calendar me-1"></i>
                                                <c:choose>
                                                    <c:when test="${not empty exam.examinationDate}">
                                                        ${exam.examinationDate.dayOfMonth}/${exam.examinationDate.monthValue}/${exam.examinationDate.year}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Chưa có ngày khám
                                                    </c:otherwise>
                                                </c:choose>
                                            </small>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <i class="fas fa-stethoscope"></i>
                                        <h5>Chưa có kết quả khám</h5>
                                        <p>Hồ sơ này chưa có kết quả khám nào</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- Treatment Plans -->
                    <div class="card">
                        <div class="card-header">
                            <h4>
                                <i class="fas fa-clipboard-list me-2"></i>Kế Hoạch Điều Trị
                            </h4>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty record.treatmentPlans}">
                                    <c:forEach var="plan" items="${record.treatmentPlans}">
                                        <div class="treatment-item">
                                            <h6>Kế hoạch #${plan.planId}</h6>
                                            <p><strong>Mô tả:</strong> ${plan.planSummary}</p>
                                            <p><strong>Chi phí ước tính:</strong> ${plan.estimatedCost} VNĐ</p>
                                            <p><strong>Ghi chú:</strong> ${plan.notes}</p>
                                            <small class="text-muted">
                                                <i class="fas fa-calendar me-1"></i>
                                                <c:choose>
                                                    <c:when test="${not empty plan.createdAt}">
                                                        ${plan.createdAt.dayOfMonth}/${plan.createdAt.monthValue}/${plan.createdAt.year}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Chưa có ngày tạo
                                                    </c:otherwise>
                                                </c:choose>
                                            </small>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <i class="fas fa-clipboard-list"></i>
                                        <h5>Chưa có kế hoạch điều trị</h5>
                                        <p>Hồ sơ này chưa có kế hoạch điều trị nào</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- Treatment Sessions -->
                    <div class="card">
                        <div class="card-header">
                            <h4>
                                <i class="fas fa-user-md me-2"></i>Phiên Điều Trị
                            </h4>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty record.treatmentSessions}">
                                    <c:forEach var="session" items="${record.treatmentSessions}">
                                        <div class="treatment-item">
                                            <h6>Phiên #${session.sessionId}</h6>
                                            <p><strong>Thủ thuật:</strong> ${session.procedureDone}</p>
                                            <p><strong>Chi phí:</strong> ${session.sessionCost} VNĐ</p>
                                            <!-- <p><strong>Ghi chú:</strong> ${session.notes}</p> -->
                                            <small class="text-muted">
                                                <i class="fas fa-calendar me-1"></i>
                                                <c:choose>
                                                    <c:when test="${not empty session.sessionDate}">
                                                        ${session.sessionDate.dayOfMonth}/${session.sessionDate.monthValue}/${session.sessionDate.year}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Chưa có ngày điều trị
                                                    </c:otherwise>
                                                </c:choose>
                                            </small>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <i class="fas fa-user-md"></i>
                                        <h5>Chưa có phiên điều trị</h5>
                                        <p>Hồ sơ này chưa có phiên điều trị nào</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- Prescriptions -->
                    <div class="card">
                        <div class="card-header">
                            <h4>
                                <i class="fas fa-prescription me-2"></i>Đơn Thuốc
                            </h4>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty record.prescriptions}">
                                    <c:forEach var="prescription" items="${record.prescriptions}">
                                        <div class="card mb-3" style="border: 2px solid #06b6d4;">
                                            <div class="card-header" style="background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%); color: white;">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <h6 class="mb-0 text-white">
                                                        <i class="fas fa-prescription me-2"></i>Đơn Thuốc #${prescription.prescriptionId}
                                                    </h6>
                                                    <small class="text-white">
                                                        <i class="fas fa-calendar me-1"></i>
                                                        <c:choose>
                                                            <c:when test="${not empty prescription.createdAt}">
                                                                ${prescription.createdAt.dayOfMonth}/${prescription.createdAt.monthValue}/${prescription.createdAt.year}
                                                            </c:when>
                                                            <c:otherwise>
                                                                Chưa có ngày
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </small>
                                                </div>
                                            </div>
                                            <div class="card-body">
                                                <c:if test="${not empty prescription.dentist}">
                                                    <div class="mb-2">
                                                        <i class="fas fa-user-md me-2 text-primary"></i>
                                                        <strong>Bác sĩ kê đơn:</strong> 
                                                        <span class="text-primary">${prescription.dentist.fullName}</span>
                                                    </div>
                                                </c:if>
                                                
                                                <c:if test="${not empty prescription.notes}">
                                                    <div class="alert alert-info mb-3">
                                                        <i class="fas fa-info-circle me-2"></i>
                                                        <strong>Ghi chú:</strong> ${prescription.notes}
                                                    </div>
                                                </c:if>
                                                
                                                <c:choose>
                                                    <c:when test="${not empty prescription.prescriptionItems}">
                                                        <h6 class="text-primary mb-3">
                                                            <i class="fas fa-pills me-2"></i>Thuốc được kê (${prescription.prescriptionItems.size()})
                                                        </h6>
                                                        <div class="table-responsive">
                                                            <table class="table table-sm table-hover table-bordered">
                                                                <thead class="table-primary">
                                                                    <tr>
                                                                        <th style="width: 35%;">
                                                                            <i class="fas fa-medkit me-1"></i> Tên Thuốc
                                                                        </th>
                                                                        <th style="width: 20%;">
                                                                            <i class="fas fa-weight me-1"></i> Liều Lượng
                                                                        </th>
                                                                        <th style="width: 20%;">
                                                                            <i class="fas fa-clock me-1"></i> Thời Gian
                                                                        </th>
                                                                        <th style="width: 25%;">
                                                                            <i class="fas fa-info-circle me-1"></i> Hướng Dẫn
                                                                        </th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:forEach var="item" items="${prescription.prescriptionItems}">
                                                                        <tr>
                                                                            <td class="fw-bold text-primary">${item.medicationName}</td>
                                                                            <td>
                                                                                <span class="badge bg-success">${item.dosage}</span>
                                                                            </td>
                                                                            <td>
                                                                                <span class="text-muted">${item.duration}</span>
                                                                            </td>
                                                                            <td>
                                                                                <small class="text-muted">${item.instructions}</small>
                                                                            </td>
                                                                        </tr>
                                                                    </c:forEach>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="alert alert-warning mb-0">
                                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                                            Đơn thuốc này chưa có thuốc nào
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <i class="fas fa-prescription"></i>
                                        <h5>Chưa có đơn thuốc</h5>
                                        <p>Hồ sơ này chưa có đơn thuốc nào</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
