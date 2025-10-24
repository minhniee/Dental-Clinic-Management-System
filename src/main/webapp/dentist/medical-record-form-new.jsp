<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ghi Chú & Cập Nhật Điều Trị - ${patient.fullName} - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
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
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            display: block;
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.5rem;
        }
        
        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }
        
        .form-control:focus {
            border-color: #06b6d4;
            outline: 0;
            box-shadow: 0 0 0 3px rgba(6, 182, 212, 0.1);
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
        
        .btn-warning {
            background-color: #f59e0b;
            color: white;
        }
        
        .btn-warning:hover {
            background-color: #d97706;
            color: white;
        }
        
        .btn-success {
            background-color: #10b981;
            color: white;
        }
        
        .btn-success:hover {
            background-color: #059669;
            color: white;
        }
        
        .record-item {
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1rem;
            background: #f8fafc;
            transition: all 0.15s ease-in-out;
        }
        
        .record-item:hover {
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            transform: translateY(-1px);
        }
        
        .record-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
        }
        
        .record-id {
            font-weight: 600;
            color: #06b6d4;
        }
        
        .record-date {
            color: #6b7280;
            font-size: 0.875rem;
        }
        
        .record-summary {
            color: #374151;
            margin-bottom: 0.75rem;
            line-height: 1.5;
        }
        
        .record-actions {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }
        
        .btn-sm {
            padding: 0.375rem 0.75rem;
            font-size: 0.75rem;
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
        
        .quick-actions .btn {
            width: 100%;
            margin-bottom: 0.5rem;
        }
        
        .quick-actions .btn:last-child {
            margin-bottom: 0;
        }
        
        .section-divider {
            height: 1px;
            background: linear-gradient(90deg, transparent, #e2e8f0, transparent);
            margin: 2rem 0;
        }
        
        @media (max-width: 768px) {
            .page-header {
                padding: 1rem 0;
            }
            
            .card-body {
                padding: 1rem;
            }
            
            .record-actions {
                flex-direction: column;
            }
            
            .record-actions .btn {
                width: 100%;
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
                                <h1 class="mb-1">🩺 Ghi Chú & Cập Nhật Điều Trị</h1>
                                <p class="text-muted mb-0">Bệnh nhân: <strong>${patient.fullName}</strong></p>
                            </div>
                            <a href="${pageContext.request.contextPath}/patient/profile?id=${patient.patientId}" 
                               class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Quay Lại Hồ Sơ
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Main Content -->
                <div class="container">
                    <div class="row">
                        <!-- Left Column: Main Content -->
                        <div class="col-lg-8">
                            <!-- Create New Medical Record -->
                            <div class="card">
                                <div class="card-header">
                                    <h4>
                                        <i class="fas fa-plus-circle me-2"></i>Tạo Hồ Sơ Y Tế Mới
                                    </h4>
                                </div>
                                <div class="card-body">
                                    <form action="${pageContext.request.contextPath}/medical-record/createRecord" method="post">
                                        <input type="hidden" name="patientId" value="${patient.patientId}">
                                        
                                        <div class="form-group">
                                            <label class="form-label" for="summary">Tóm Tắt Hồ Sơ</label>
                                            <textarea class="form-control" id="summary" name="summary" rows="4" 
                                                      placeholder="Nhập tóm tắt về tình trạng sức khỏe, triệu chứng, hoặc lý do khám..."></textarea>
                                        </div>
                                        
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-2"></i>Tạo Hồ Sơ Mới
                                        </button>
                                    </form>
                                </div>
                            </div>
                            
                            <!-- Existing Medical Records -->
                            <div class="card">
                                <div class="card-header">
                                    <h4>
                                        <i class="fas fa-file-medical me-2"></i>Hồ Sơ Y Tế Hiện Tại
                                    </h4>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${not empty medicalRecords}">
                                            <c:forEach var="record" items="${medicalRecords}">
                                                <div class="record-item">
                                                    <div class="record-header">
                                                        <span class="record-id">Hồ Sơ #${record.recordId}</span>
                                                        <span class="record-date">
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
                                                    <div class="record-summary">${record.summary}</div>
                                                    <div class="record-actions">
                                                        <a href="${pageContext.request.contextPath}/medical-record/view?recordId=${record.recordId}" 
                                                           class="btn btn-primary btn-sm">
                                                            <i class="fas fa-eye me-1"></i>Xem Chi Tiết
                                                        </a>
                                                        <button class="btn btn-warning btn-sm" onclick="addExamination('${record.recordId}')">
                                                            <i class="fas fa-stethoscope me-1"></i>Thêm Khám
                                                        </button>
                                                        <button class="btn btn-success btn-sm" onclick="addTreatmentPlan('${record.recordId}')">
                                                            <i class="fas fa-clipboard-list me-1"></i>Kế Hoạch Điều Trị
                                                        </button>
                                                    </div>
                                                </div>
                                            </c:forEach>
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
                            </div>
                        </div>
                        
                        <!-- Right Column: Quick Actions -->
                        <div class="col-lg-4">
                            <div class="card">
                                <div class="card-header">
                                    <h4>
                                        <i class="fas fa-bolt me-2"></i>Thao Tác Nhanh
                                    </h4>
                                </div>
                                <div class="card-body quick-actions">
                                    <button class="btn btn-warning" onclick="quickPrescription()">
                                        <i class="fas fa-prescription me-2"></i>Tạo Đơn Thuốc Nhanh
                                    </button>
                                    <button class="btn btn-success" onclick="quickTreatmentSession()">
                                        <i class="fas fa-user-md me-2"></i>Ghi Phiên Điều Trị
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function addExamination(recordId) {
            alert('Chức năng thêm khám cho hồ sơ #' + recordId + ' sẽ được triển khai');
        }
        
        function addTreatmentPlan(recordId) {
            alert('Chức năng kế hoạch điều trị cho hồ sơ #' + recordId + ' sẽ được triển khai');
        }
        
        function quickPrescription() {
            alert('Chức năng tạo đơn thuốc nhanh sẽ được triển khai');
        }
        
        function quickTreatmentSession() {
            alert('Chức năng ghi phiên điều trị sẽ được triển khai');
        }
    </script>
</body>
</html>
