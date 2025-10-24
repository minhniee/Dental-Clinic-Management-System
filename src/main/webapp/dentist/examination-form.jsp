<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Kết Quả Khám - ${patient.fullName} - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .page-header {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
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
        
        .examination-card {
            border: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border-radius: 1rem;
            margin-bottom: 2rem;
        }
        
        .examination-header {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border-bottom: 3px solid #f59e0b;
            border-radius: 1rem 1rem 0 0 !important;
            padding: 1.5rem;
        }
        
        .examination-header h2 {
            color: #92400e;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
        }
        
        .examination-body {
            padding: 2rem;
            background: #fefefe;
        }
        
        .form-section {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        .form-section h4 {
            color: #374151;
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            display: block;
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
        }
        
        .form-control {
            width: 100%;
            padding: 0.875rem;
            border: 2px solid #e5e7eb;
            border-radius: 0.5rem;
            font-size: 0.95rem;
            transition: all 0.2s ease-in-out;
            background: white;
        }
        
        .form-control:focus {
            border-color: #f59e0b;
            outline: 0;
            box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.1);
        }
        
        .form-control:focus {
            transform: translateY(-1px);
        }
        
        .btn {
            padding: 0.875rem 2rem;
            border-radius: 0.5rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease-in-out;
            border: none;
            cursor: pointer;
            font-size: 0.95rem;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            color: white;
            box-shadow: 0 4px 6px rgba(245, 158, 11, 0.3);
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(245, 158, 11, 0.4);
        }
        
        .btn-secondary {
            background: #6b7280;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #4b5563;
            color: white;
            transform: translateY(-1px);
        }
        
        .patient-info {
            background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
            border: 1px solid #93c5fd;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .patient-info h3 {
            color: #1e40af;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        
        .patient-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }
        
        .patient-detail {
            display: flex;
            align-items: center;
            color: #374151;
        }
        
        .patient-detail i {
            color: #3b82f6;
            margin-right: 0.5rem;
            width: 20px;
        }
        
        .required-field::after {
            content: " *";
            color: #ef4444;
            font-weight: bold;
        }
        
        .form-note {
            background: #fef3c7;
            border: 1px solid #f59e0b;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
            color: #92400e;
        }
        
        .form-note i {
            color: #f59e0b;
            margin-right: 0.5rem;
        }
        
        @media (max-width: 768px) {
            .page-header {
                padding: 1rem 0;
            }
            
            .examination-body {
                padding: 1rem;
            }
            
            .patient-details {
                grid-template-columns: 1fr;
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
                                <h1 class="mb-1">🩺 Thêm Kết Quả Khám</h1>
                                <p class="text-muted mb-0">Bệnh nhân: <strong>${patient.fullName}</strong></p>
                            </div>
                            <a href="${pageContext.request.contextPath}/medical-record?action=form&patientId=${patient.patientId}" 
                               class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Quay Lại
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
                    <!-- Patient Information -->
                    <div class="patient-info">
                        <h3><i class="fas fa-user me-2"></i>Thông Tin Bệnh Nhân</h3>
                        <div class="patient-details">
                            <div class="patient-detail">
                                <i class="fas fa-id-card"></i>
                                <span><strong>Mã BN:</strong> ${patient.patientId}</span>
                            </div>
                            <div class="patient-detail">
                                <i class="fas fa-user"></i>
                                <span><strong>Họ Tên:</strong> ${patient.fullName}</span>
                            </div>
                            <div class="patient-detail">
                                <i class="fas fa-calendar"></i>
                                <span><strong>Ngày Sinh:</strong> ${patient.birthDate}</span>
                            </div>
                            <div class="patient-detail">
                                <i class="fas fa-phone"></i>
                                <span><strong>SĐT:</strong> ${patient.phone}</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Examination Form -->
                    <div class="examination-card">
                        <div class="examination-header">
                            <h2><i class="fas fa-stethoscope me-2"></i>Kết Quả Khám Lâm Sàng</h2>
                        </div>
                        <div class="examination-body">
                            <form action="${pageContext.request.contextPath}/medical-record" method="post">
                                <input type="hidden" name="action" value="addExamination">
                                <input type="hidden" name="recordId" value="${recordId}">
                                <input type="hidden" name="patientId" value="${patient.patientId}">
                                
                                <div class="form-note">
                                    <i class="fas fa-info-circle"></i>
                                    <strong>Lưu ý:</strong> Vui lòng điền đầy đủ thông tin khám bệnh để đảm bảo chất lượng chẩn đoán và điều trị.
                                </div>
                                
                                <!-- Examination Date -->
                                <div class="form-section">
                                    <h4><i class="fas fa-calendar-alt me-2"></i>Thông Tin Khám</h4>
                                    <div class="form-group">
                                        <label class="form-label required-field" for="examinationDate">Ngày Khám</label>
                                        <input type="date" class="form-control" id="examinationDate" name="examinationDate" 
                                               value="${param.examinationDate}" required>
                                    </div>
                                </div>
                                
                                <!-- Clinical Findings -->
                                <div class="form-section">
                                    <h4><i class="fas fa-search me-2"></i>Triệu Chứng & Kết Quả Khám</h4>
                                    <div class="form-group">
                                        <label class="form-label required-field" for="findings">Triệu Chứng / Kết Quả Khám Lâm Sàng</label>
                                        <textarea class="form-control" id="findings" name="findings" rows="5" 
                                                  placeholder="Mô tả chi tiết các triệu chứng, dấu hiệu lâm sàng, kết quả khám thực thể...&#10;&#10;Ví dụ:&#10;- Đau răng vùng hàm dưới bên phải&#10;- Sưng nướu, chảy máu khi đánh răng&#10;- Răng số 6 có lỗ sâu lớn, tủy lộ&#10;- Nướu viêm đỏ, có mủ" required></textarea>
                                    </div>
                                </div>
                                
                                <!-- Diagnosis -->
                                <div class="form-section">
                                    <h4><i class="fas fa-diagnoses me-2"></i>Chẩn Đoán</h4>
                                    <div class="form-group">
                                        <label class="form-label required-field" for="diagnosis">Chẩn Đoán</label>
                                        <textarea class="form-control" id="diagnosis" name="diagnosis" rows="4" 
                                                  placeholder="Chẩn đoán dựa trên kết quả khám lâm sàng...&#10;&#10;Ví dụ:&#10;- Viêm tủy răng cấp tính răng số 6&#10;- Viêm nướu do mảng bám&#10;- Sâu răng mức độ 3" required></textarea>
                                    </div>
                                </div>
                                
                                <!-- Additional Notes -->
                                <div class="form-section">
                                    <h4><i class="fas fa-sticky-note me-2"></i>Ghi Chú Bổ Sung</h4>
                                    <div class="form-group">
                                        <label class="form-label" for="notes">Ghi Chú Thêm</label>
                                        <textarea class="form-control" id="notes" name="notes" rows="3" 
                                                  placeholder="Ghi chú thêm về tình trạng bệnh nhân, tiền sử bệnh, phản ứng thuốc, hoặc các lưu ý đặc biệt..."></textarea>
                                    </div>
                                </div>
                                
                                <!-- Action Buttons -->
                                <div class="d-flex justify-content-between align-items-center mt-4">
                                    <a href="${pageContext.request.contextPath}/medical-record?action=form&patientId=${patient.patientId}" 
                                       class="btn btn-secondary">
                                        <i class="fas fa-times me-2"></i>Hủy Bỏ
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i>Lưu Kết Quả Khám
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-resize textareas
        document.querySelectorAll('textarea').forEach(textarea => {
            textarea.addEventListener('input', function() {
                this.style.height = 'auto';
                this.style.height = this.scrollHeight + 'px';
            });
        });
        
        // Set today's date as default
        document.getElementById('examinationDate').value = new Date().toISOString().split('T')[0];
        
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const requiredFields = this.querySelectorAll('[required]');
            let isValid = true;
            
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    field.style.borderColor = '#ef4444';
                    isValid = false;
                } else {
                    field.style.borderColor = '#e5e7eb';
                }
            });
            
            if (!isValid) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ các trường bắt buộc!');
            }
        });
    </script>
</body>
</html>