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
        
        .file-upload-area {
            border: 2px dashed #d1d5db;
            border-radius: 0.5rem;
            padding: 2rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background-color: #f9fafb;
        }
        
        .file-upload-area:hover {
            border-color: #06b6d4;
            background-color: #f0f9ff;
        }
        
        .file-upload-area.dragover {
            border-color: #06b6d4;
            background-color: #f0f9ff;
            transform: scale(1.02);
        }
        
        .file-upload-icon {
            font-size: 2rem;
            color: #6b7280;
            margin-bottom: 1rem;
        }
        
        .file-upload-text {
            font-size: 1.1rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.5rem;
        }
        
        .file-upload-hint {
            font-size: 0.875rem;
            color: #6b7280;
        }
        
        .file-info {
            margin-top: 1rem;
            padding: 1rem;
            background-color: #f8fafc;
            border-radius: 0.5rem;
            border: 1px solid #e2e8f0;
        }
        
        .file-info-item {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        
        .file-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem;
            background-color: white;
            border-radius: 0.375rem;
            border: 1px solid #e2e8f0;
            margin-bottom: 0.5rem;
        }
        
        .file-preview {
            width: 60px;
            height: 60px;
            margin-right: 10px;
            border-radius: 4px;
            overflow: hidden;
            background: #f5f5f5;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        
        .file-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .file-name {
            font-weight: 500;
            color: #374151;
        }
        
        .file-size {
            font-size: 0.875rem;
            color: #6b7280;
        }
        
        .file-remove {
            color: #ef4444;
            cursor: pointer;
            padding: 0.25rem;
            border-radius: 0.25rem;
            transition: background-color 0.2s;
        }
        
        .file-remove:hover {
            background-color: #fef2f2;
        }
        
        .image-gallery {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }
        
        .image-item {
            position: relative;
            border-radius: 0.5rem;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
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
            padding: 0.5rem;
            font-size: 0.875rem;
        }
        
        .image-actions {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            display: flex;
            gap: 0.25rem;
        }
        
        .image-action-btn {
            background: rgba(0, 0, 0, 0.5);
            color: white;
            border: none;
            border-radius: 0.25rem;
            padding: 0.25rem;
            cursor: pointer;
            font-size: 0.75rem;
        }
        
        .image-action-btn:hover {
            background: rgba(0, 0, 0, 0.7);
        }
        
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.8);
        }
        
        .modal-content {
            position: relative;
            margin: 5% auto;
            padding: 20px;
            width: 80%;
            max-width: 800px;
            text-align: center;
            background: white;
            border-radius: 0.5rem;
        }
        
        .close {
            position: absolute;
            top: 10px;
            right: 20px;
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close:hover {
            color: #000;
        }
        
        .modal-caption {
            margin-top: 10px;
            font-weight: 600;
            color: #374151;
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
                
                <!-- Success/Error Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="container">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="container">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </div>
                </c:if>

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
                                    <form action="${pageContext.request.contextPath}/medical-record" method="post">
                                        <input type="hidden" name="action" value="createRecord">
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
                            
                            <!-- Medical Image Upload Section -->
                            <div class="card">
                                <div class="card-header">
                                    <h4>
                                        <i class="fas fa-images me-2"></i>Upload Ảnh Y Tế
                                    </h4>
                                </div>
                                <div class="card-body">
                                    <form id="imageUploadForm" action="/dental_clinic_management_system/medical-record" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="action" value="uploadImage">
                                        <input type="hidden" name="patientId" value="${patient.patientId}">
                                        
                                        <div class="form-group">
                                            <label class="form-label" for="imageType">Loại Ảnh</label>
                                            <select class="form-control" id="imageType" name="imageType" required>
                                                <option value="">-- Chọn loại ảnh --</option>
                                                <option value="X-Ray">X-Quang</option>
                                                <option value="Clinical">Ảnh Lâm Sàng</option>
                                                <option value="Before">Ảnh Trước Điều Trị</option>
                                                <option value="After">Ảnh Sau Điều Trị</option>
                                                <option value="Other">Khác</option>
                                            </select>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label class="form-label" for="imageFiles">Chọn Ảnh</label>
                                            <div class="file-upload-area" onclick="document.getElementById('imageFiles').click()">
                                                <div class="file-upload-icon">
                                                    <i class="fas fa-cloud-upload-alt"></i>
                                                </div>
                                                <div class="file-upload-text">
                                                    Nhấp để chọn ảnh hoặc kéo thả ảnh vào đây
                                                </div>
                                                <div class="file-upload-hint">
                                                    Hỗ trợ: JPG, JPEG, PNG, GIF (Tối đa 10MB mỗi ảnh)
                                                </div>
                                            </div>
                                            <input type="file" id="imageFiles" name="imageFiles" class="form-control" 
                                                   style="display: none;" accept="image/*" multiple>
                                            
                                            <div class="file-info" id="imageFileInfo">
                                                <div class="file-info-item" id="imageFileList">
                                                    <!-- Selected files will be displayed here -->
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="d-flex gap-2">
                                            <button type="submit" class="btn btn-primary" id="uploadBtn" disabled>
                                                <i class="fas fa-upload me-2"></i>Upload Ảnh
                                            </button>
                                            <button type="button" class="btn btn-secondary" onclick="clearImageSelection()">
                                                <i class="fas fa-times me-2"></i>Xóa Lựa Chọn
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            
                            <!-- Medical Images Gallery -->
                            <c:if test="${not empty patientImages}">
                                <div class="card">
                                    <div class="card-header">
                                        <h4>
                                            <i class="fas fa-images me-2"></i>Ảnh Y Tế Đã Upload
                                        </h4>
                                    </div>
                                    <div class="card-body">
                                        <div class="image-gallery">
                                            <c:forEach var="image" items="${patientImages}">
                                                <div class="image-item">
                                                    <img src="${pageContext.request.contextPath}/${image.filePath}" 
                                                         alt="${image.imageType}" 
                                                         onclick="openImageModal('${pageContext.request.contextPath}/${image.filePath}', '${image.imageType}')">
                                                    <div class="image-overlay">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <span>${image.imageType}</span>
                                                            <small>${image.uploadedAt}</small>
                                                        </div>
                                                    </div>
                                                    <div class="image-actions">
                                                        <button class="image-action-btn" onclick="downloadImage('${pageContext.request.contextPath}/${image.filePath}', '${image.imageType}')" title="Tải xuống">
                                                            <i class="fas fa-download"></i>
                                                        </button>
                                                        <button class="image-action-btn" onclick="deleteImage('${image.imageId}')" title="Xóa">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            
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
                                                <div class="record-item" data-record-id="${record.recordId}">
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
                                                        <a href="${pageContext.request.contextPath}/medical-record?action=view&recordId=${record.recordId}" 
                                                           class="btn btn-primary btn-sm">
                                                            <i class="fas fa-eye me-1"></i>Xem Chi Tiết
                                                        </a>
                                                         <a href="${pageContext.request.contextPath}/examination-form?patientId=${patient.patientId}&recordId=${record.recordId}" 
                                                            class="btn btn-warning btn-sm">
                                                             <i class="fas fa-stethoscope me-1"></i>Thêm Khám
                                                         </a>
                                                         <a href="${pageContext.request.contextPath}/treatment-plan-form?patientId=${patient.patientId}&recordId=${record.recordId}" 
                                                            class="btn btn-success btn-sm">
                                                             <i class="fas fa-clipboard-list me-1"></i>Kế Hoạch Điều Trị
                                                         </a>
                                                        <a href="${pageContext.request.contextPath}/treatment-session-form?patientId=${patient.patientId}&recordId=${record.recordId}" 
                                                           class="btn btn-info btn-sm">
                                                            <i class="fas fa-user-md me-1"></i>Phiên Điều Trị
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/prescription-form?patientId=${patient.patientId}&recordId=${record.recordId}" 
                                                           class="btn btn-warning btn-sm">
                                                            <i class="fas fa-prescription me-1"></i>Kê Đơn Thuốc
                                                        </a>
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
                        
                    
                    </div>
                </div>
            </div>
        </main>
    </div>




    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        
        
        function quickExamination() {
            // Get first record ID if available
            const firstRecord = document.querySelector('[data-record-id]');
            if (firstRecord) {
                const patientId = '${patient.patientId}';
                const recordId = firstRecord.getAttribute('data-record-id');
                window.location.href = '${pageContext.request.contextPath}/examination-form?patientId=' + patientId + '&recordId=' + recordId;
            } else {
                alert('Vui lòng tạo hồ sơ y tế trước khi thêm khám');
            }
        }
        
        function quickTreatmentPlan() {
            // Get first record ID if available
            const firstRecord = document.querySelector('[data-record-id]');
            if (firstRecord) {
                const patientId = '${patient.patientId}';
                const recordId = firstRecord.getAttribute('data-record-id');
                window.location.href = '${pageContext.request.contextPath}/treatment-plan-form?patientId=' + patientId + '&recordId=' + recordId;
            } else {
                alert('Vui lòng tạo hồ sơ y tế trước khi tạo kế hoạch điều trị');
            }
        }
        
        // Image upload functionality
        let selectedFiles = [];
        
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Medical record form loaded');
            
            const fileInput = document.getElementById('imageFiles');
            const uploadArea = document.querySelector('.file-upload-area');
            const uploadBtn = document.getElementById('uploadBtn');
            const imageTypeSelect = document.getElementById('imageType');
            
            if (!fileInput || !uploadArea || !uploadBtn || !imageTypeSelect) {
                console.error('Required elements not found');
                return;
            }
            
            console.log('All elements found, setting up event listeners');
            
            // File input change handler
            fileInput.addEventListener('change', handleFileSelection);
            
            // Drag and drop handlers
            uploadArea.addEventListener('dragover', handleDragOver);
            uploadArea.addEventListener('dragleave', handleDragLeave);
            uploadArea.addEventListener('drop', handleDrop);
            
            // Form submission handler
            document.getElementById('imageUploadForm').addEventListener('submit', handleFormSubmit);
            
            // Image type change handler
            imageTypeSelect.addEventListener('change', updateUploadButton);
            
            console.log('Event listeners set up successfully');
        });
        
        function handleFileSelection(event) {
            const files = Array.from(event.target.files);
            addFiles(files);
        }
        
        function handleDragOver(event) {
            event.preventDefault();
            event.currentTarget.classList.add('dragover');
        }
        
        function handleDragLeave(event) {
            event.preventDefault();
            event.currentTarget.classList.remove('dragover');
        }
        
        function handleDrop(event) {
            event.preventDefault();
            event.currentTarget.classList.remove('dragover');
            const files = Array.from(event.dataTransfer.files);
            addFiles(files);
        }
        
        function addFiles(files) {
            console.log('Adding files:', files);
            
            const validFiles = files.filter(file => {
                console.log('Validating file:', file.name, 'Type:', file.type, 'Size:', file.size);
                
                // Validate file type
                const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
                if (!allowedTypes.includes(file.type)) {
                    alert('File ' + file.name + ' không phải là ảnh hợp lệ. Chỉ chấp nhận JPG, JPEG, PNG, GIF.');
                    return false;
                }
                
                // Validate file size (max 10MB)
                const maxSize = 10 * 1024 * 1024; // 10MB
                if (file.size > maxSize) {
                    alert('File ' + file.name + ' quá lớn. Kích thước tối đa là 10MB.');
                    return false;
                }
                
                return true;
            });
            
            console.log('Valid files:', validFiles);
            selectedFiles = [...selectedFiles, ...validFiles];
            console.log('Total selected files:', selectedFiles);
            
            displaySelectedFiles();
            updateUploadButton();
        }
        
        function displaySelectedFiles() {
            const fileList = document.getElementById('imageFileList');
            fileList.innerHTML = '';
            
            if (selectedFiles.length === 0) {
                fileList.innerHTML = '<div class="text-muted">Chưa có ảnh nào được chọn</div>';
                return;
            }
            
            selectedFiles.forEach((file, index) => {
                const fileItem = document.createElement('div');
                fileItem.className = 'file-item';
                
                // Create preview element
                const previewDiv = document.createElement('div');
                previewDiv.className = 'file-preview';
                
                if (file.type.startsWith('image/')) {
                    const img = document.createElement('img');
                    img.src = URL.createObjectURL(file);
                    img.alt = 'Preview';
                    previewDiv.appendChild(img);
                } else {
                    const icon = document.createElement('i');
                    icon.className = 'fas fa-file-image';
                    icon.style.cssText = 'font-size: 24px; color: #ccc;';
                    previewDiv.appendChild(icon);
                }
                
                // Create file info div
                const fileInfoDiv = document.createElement('div');
                
                const fileNameDiv = document.createElement('div');
                fileNameDiv.className = 'file-name';
                fileNameDiv.textContent = file.name;
                
                const fileSizeDiv = document.createElement('div');
                fileSizeDiv.className = 'file-size';
                fileSizeDiv.textContent = formatFileSize(file.size);
                
                fileInfoDiv.appendChild(fileNameDiv);
                fileInfoDiv.appendChild(fileSizeDiv);
                
                // Create main content div
                const mainDiv = document.createElement('div');
                mainDiv.style.cssText = 'display: flex; align-items: center; flex: 1;';
                mainDiv.appendChild(previewDiv);
                mainDiv.appendChild(fileInfoDiv);
                
                // Create remove button
                const removeBtn = document.createElement('button');
                removeBtn.type = 'button';
                removeBtn.className = 'file-remove';
                removeBtn.onclick = function() { removeFile(index); };
                removeBtn.innerHTML = '<i class="fas fa-times"></i>';
                
                // Assemble the file item
                fileItem.appendChild(mainDiv);
                fileItem.appendChild(removeBtn);
                
                fileList.appendChild(fileItem);
            });
        }
        
        function removeFile(index) {
            selectedFiles.splice(index, 1);
            displaySelectedFiles();
            updateUploadButton();
        }
        
        function clearImageSelection() {
            // Clean up object URLs to prevent memory leaks
            selectedFiles.forEach(file => {
                if (file.type.startsWith('image/')) {
                    URL.revokeObjectURL(URL.createObjectURL(file));
                }
            });
            
            selectedFiles = [];
            document.getElementById('imageFiles').value = '';
            displaySelectedFiles();
            updateUploadButton();
        }
        
        function formatFileSize(bytes) {
            if (bytes === 0) return '0 Bytes';
            const k = 1024;
            const sizes = ['Bytes', 'KB', 'MB', 'GB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
        }
        
        function updateUploadButton() {
            const uploadBtn = document.getElementById('uploadBtn');
            const imageType = document.getElementById('imageType').value;
            
            if (selectedFiles.length > 0 && imageType) {
                uploadBtn.disabled = false;
            } else {
                uploadBtn.disabled = true;
            }
        }
        
        function handleFormSubmit(event) {
            event.preventDefault();
            
            console.log('Form submit triggered');
            console.log('Selected files:', selectedFiles);
            
            if (selectedFiles.length === 0) {
                alert('Vui lòng chọn ít nhất một ảnh để upload');
                return;
            }
            
            const imageType = document.getElementById('imageType').value;
            console.log('Image type:', imageType);
            
            if (!imageType) {
                alert('Vui lòng chọn loại ảnh');
                return;
            }
            
            // Show loading state
            const uploadBtn = document.getElementById('uploadBtn');
            const originalText = uploadBtn.innerHTML;
            uploadBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang Upload...';
            uploadBtn.disabled = true;
            
            // Create new FormData and add files
            const form = event.target;
            const formData = new FormData();
            
            // Add form fields
            formData.append('action', 'uploadImage');
            formData.append('patientId', document.querySelector('input[name="patientId"]').value);
            formData.append('imageType', imageType);
            
            // Add files
            selectedFiles.forEach((file, index) => {
                console.log('Adding file to FormData:', file.name);
                formData.append('imageFiles', file);
            });
            
            console.log('FormData entries:');
            for (let [key, value] of formData.entries()) {
                console.log(key, value);
            }
            
            // Submit via fetch
            fetch('/dental_clinic_management_system/medical-record', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                console.log('Response status:', response.status);
                console.log('Response ok:', response.ok);
                
                if (response.ok) {
                    // Show success message
                    alert('Upload ảnh thành công!');
                    // Reload page to show uploaded images
                    window.location.reload();
                } else {
                    return response.text().then(text => {
                        console.error('Server response:', text);
                        throw new Error('Upload failed: ' + text);
                    });
                }
            })
            .catch(error => {
                console.error('Upload error:', error);
                alert('Có lỗi xảy ra khi upload ảnh: ' + error.message);
                uploadBtn.innerHTML = originalText;
                uploadBtn.disabled = false;
            });
        }
        
        // Image gallery functions
        function openImageModal(imageSrc, imageType) {
            // Create modal if it doesn't exist
            let modal = document.getElementById('imageModal');
            if (!modal) {
                modal = document.createElement('div');
                modal.id = 'imageModal';
                modal.className = 'modal';
                modal.style.display = 'none';
                modal.innerHTML = `
                    <div class="modal-content">
                        <span class="close">&times;</span>
                        <img id="modalImage" src="" alt="" style="max-width: 100%; max-height: 80vh;">
                        <div class="modal-caption"></div>
                    </div>
                `;
                document.body.appendChild(modal);
                
                // Close modal when clicking X
                modal.querySelector('.close').onclick = function() {
                    modal.style.display = 'none';
                }
                
                // Close modal when clicking outside
                modal.onclick = function(event) {
                    if (event.target === modal) {
                        modal.style.display = 'none';
                    }
                }
            }
            
            // Show modal
            modal.querySelector('#modalImage').src = imageSrc;
            modal.querySelector('#modalImage').alt = imageType;
            modal.querySelector('.modal-caption').textContent = imageType;
            modal.style.display = 'block';
        }
        
        function downloadImage(imageSrc, imageType) {
            const link = document.createElement('a');
            link.href = imageSrc;
            link.download = imageType + '_' + new Date().getTime() + '.jpg';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
        
        function deleteImage(imageId) {
            if (confirm('Bạn có chắc chắn muốn xóa ảnh này?')) {
                // Create form to submit delete request
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '/dental_clinic_management_system/medical-record';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'deleteImage';
                
                const imageIdInput = document.createElement('input');
                imageIdInput.type = 'hidden';
                imageIdInput.name = 'imageId';
                imageIdInput.value = imageId;
                
                const patientIdInput = document.createElement('input');
                patientIdInput.type = 'hidden';
                patientIdInput.name = 'patientId';
                patientIdInput.value = '${patient.patientId}';
                
                form.appendChild(actionInput);
                form.appendChild(imageIdInput);
                form.appendChild(patientIdInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
    </script>
</body>
</html>
