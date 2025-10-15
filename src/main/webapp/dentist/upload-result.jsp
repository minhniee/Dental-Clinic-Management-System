<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Kết Quả Xét Nghiệm - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .form-container {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            max-width: 800px;
            margin: 0 auto;
        }
        
        .section-title {
            color: #0f172a;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            border-bottom: 2px solid #06b6d4;
            padding-bottom: 0.5rem;
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
        
        .file-upload-area {
            border: 2px dashed #d1d5db;
            border-radius: 0.5rem;
            padding: 2rem;
            text-align: center;
            background-color: #f8fafc;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .file-upload-area:hover {
            border-color: #06b6d4;
            background-color: #f0f9ff;
        }
        
        .file-upload-area.dragover {
            border-color: #06b6d4;
            background-color: #f0f9ff;
        }
        
        .file-upload-icon {
            font-size: 3rem;
            color: #d1d5db;
            margin-bottom: 1rem;
        }
        
        .file-upload-text {
            color: #6b7280;
            margin-bottom: 0.5rem;
        }
        
        .file-upload-hint {
            font-size: 0.875rem;
            color: #9ca3af;
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
            margin-right: 0.5rem;
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
        
        .alert-success {
            background-color: #f0fdf4;
            color: #16a34a;
            border: 1px solid #bbf7d0;
        }
        
        .form-help {
            font-size: 0.875rem;
            color: #6b7280;
            margin-top: 0.25rem;
        }
        
        .file-info {
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-top: 1rem;
            display: none;
        }
        
        .file-info.show {
            display: block;
        }
        
        .file-info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
        }
        
        .file-info-item:last-child {
            margin-bottom: 0;
        }
        
        .file-name {
            font-weight: 600;
            color: #0f172a;
        }
        
        .file-size {
            color: #6b7280;
            font-size: 0.875rem;
        }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login.jsp"/>
    </c:if>

    <div class="header">
        <h1>🦷 Upload Kết Quả Xét Nghiệm</h1>
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
                
                <!-- Success Message -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle me-2"></i>
                        ${successMessage}
                    </div>
                </c:if>
                
                <!-- Form Container -->
                <div class="form-container">
                    <h2 class="section-title">
                        <i class="fas fa-upload me-2"></i>
                        Upload File Kết Quả
                    </h2>
                    
                    <form action="${pageContext.request.contextPath}/upload-clinical-result" method="POST" 
                          enctype="multipart/form-data" id="uploadForm">
                        <input type="hidden" name="patient_id" value="${param.patient_id}">
                        
                        <div class="form-group">
                            <label for="file_description" class="form-label">
                                Mô Tả File <span class="text-danger">*</span>
                            </label>
                            <input type="text" id="file_description" name="file_description" class="form-control" 
                                   placeholder="Ví dụ: Kết quả X-quang răng số 16, Xét nghiệm máu, CT scan..." 
                                   required>
                            <div class="form-help">
                                Nhập mô tả ngắn gọn về loại kết quả xét nghiệm
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">
                                Chọn File <span class="text-danger">*</span>
                            </label>
                            <div class="file-upload-area" onclick="document.getElementById('file_input').click()">
                                <div class="file-upload-icon">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                </div>
                                <div class="file-upload-text">
                                    Nhấp để chọn file hoặc kéo thả file vào đây
                                </div>
                                <div class="file-upload-hint">
                                    Hỗ trợ: PDF, JPG, PNG, DOC, DOCX (Tối đa 10MB)
                                </div>
                            </div>
                            <input type="file" id="file_input" name="file" class="form-control" 
                                   style="display: none;" accept=".pdf,.jpg,.jpeg,.png,.doc,.docx" required>
                            
                            <div class="file-info" id="file_info">
                                <div class="file-info-item">
                                    <span class="file-name" id="file_name"></span>
                                    <span class="file-size" id="file_size"></span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-upload me-2"></i>
                                Upload File
                            </button>
                            <a href="${pageContext.request.contextPath}/record-detail?record_id=${param.record_id}" 
                               class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i>
                                Quay Lại
                            </a>
                        </div>
                    </form>
                </div>
                
            </div>
        </main>
    </div>
    
    <script>
        const fileInput = document.getElementById('file_input');
        const fileUploadArea = document.querySelector('.file-upload-area');
        const fileInfo = document.getElementById('file_info');
        const fileName = document.getElementById('file_name');
        const fileSize = document.getElementById('file_size');
        
        // File input change event
        fileInput.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                displayFileInfo(file);
            }
        });
        
        // Drag and drop functionality
        fileUploadArea.addEventListener('dragover', function(e) {
            e.preventDefault();
            fileUploadArea.classList.add('dragover');
        });
        
        fileUploadArea.addEventListener('dragleave', function(e) {
            e.preventDefault();
            fileUploadArea.classList.remove('dragover');
        });
        
        fileUploadArea.addEventListener('drop', function(e) {
            e.preventDefault();
            fileUploadArea.classList.remove('dragover');
            
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                fileInput.files = files;
                displayFileInfo(files[0]);
            }
        });
        
        function displayFileInfo(file) {
            fileName.textContent = file.name;
            fileSize.textContent = formatFileSize(file.size);
            fileInfo.classList.add('show');
        }
        
        function formatFileSize(bytes) {
            if (bytes === 0) return '0 Bytes';
            const k = 1024;
            const sizes = ['Bytes', 'KB', 'MB', 'GB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
        }
        
        // Form validation
        document.getElementById('uploadForm').addEventListener('submit', function(e) {
            const file = fileInput.files[0];
            const maxSize = 10 * 1024 * 1024; // 10MB
            
            if (file && file.size > maxSize) {
                e.preventDefault();
                alert('File quá lớn! Vui lòng chọn file nhỏ hơn 10MB.');
                return false;
            }
        });
    </script>
</body>
</html>
