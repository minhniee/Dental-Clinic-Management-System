<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kế Hoạch Điều Trị - ${patient.fullName} - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .page-header {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
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
        
        .treatment-card {
            border: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border-radius: 1rem;
            margin-bottom: 2rem;
        }
        
        .treatment-header {
            background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
            border-bottom: 3px solid #10b981;
            border-radius: 1rem 1rem 0 0 !important;
            padding: 1.5rem;
        }
        
        .treatment-header h2 {
            color: #065f46;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
        }
        
        .treatment-body {
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
            border-color: #10b981;
            outline: 0;
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
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
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            box-shadow: 0 4px 6px rgba(16, 185, 129, 0.3);
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(16, 185, 129, 0.4);
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
            background: #d1fae5;
            border: 1px solid #10b981;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
            color: #065f46;
        }
        
        .form-note i {
            color: #10b981;
            margin-right: 0.5rem;
        }
        
        .cost-input {
            position: relative;
        }
        
        .cost-input input {
            padding-right: 12px;
        }
        
        .treatment-steps {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        
        .treatment-steps h5 {
            color: #065f46;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .treatment-steps ul {
            margin: 0;
            padding-left: 1.5rem;
        }
        
        .treatment-steps li {
            color: #374151;
            margin-bottom: 0.25rem;
        }
        
        @media (max-width: 768px) {
            .page-header {
                padding: 1rem 0;
            }
            
            .treatment-body {
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
                                <h1 class="mb-1">📋 Kế Hoạch Điều Trị</h1>
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
                    
                    <!-- Treatment Plan Form -->
                    <div class="treatment-card">
                        <div class="treatment-header">
                            <h2><i class="fas fa-clipboard-list me-2"></i>Kế Hoạch Điều Trị Chi Tiết</h2>
                        </div>
                        <div class="treatment-body">
                            <form action="${pageContext.request.contextPath}/medical-record" method="post">
                                <input type="hidden" name="action" value="addTreatmentPlan">
                                <input type="hidden" name="recordId" value="${recordId}">
                                <input type="hidden" name="patientId" value="${patient.patientId}">
                                
                                <div class="form-note">
                                    <i class="fas fa-info-circle"></i>
                                    <strong>Lưu ý:</strong> Kế hoạch điều trị cần được xây dựng dựa trên kết quả khám lâm sàng và chẩn đoán. Vui lòng mô tả chi tiết các bước điều trị.
                                </div>
                                
                                <!-- Treatment Description -->
                                <div class="form-section">
                                    <h4><i class="fas fa-list-ol me-2"></i>Mô Tả Kế Hoạch Điều Trị</h4>
                                    <div class="form-group">
                                        <label class="form-label required-field" for="description">Kế Hoạch Điều Trị Chi Tiết</label>
                                        <textarea class="form-control" id="description" name="description" rows="6" 
                                                  placeholder="Mô tả chi tiết kế hoạch điều trị, bao gồm các bước thực hiện...&#10;&#10;Ví dụ:&#10;1. Điều trị tủy răng số 6&#10;   - Làm sạch ống tủy&#10;   - Đặt thuốc sát khuẩn&#10;   - Trám bít ống tủy&#10;&#10;2. Điều trị viêm nướu&#10;   - Cạo vôi răng&#10;   - Hướng dẫn vệ sinh răng miệng&#10;&#10;3. Trám răng sâu&#10;   - Làm sạch vùng sâu&#10;   - Trám composite" required></textarea>
                                    </div>
                                    
                                    <div class="treatment-steps">
                                        <h5><i class="fas fa-lightbulb me-2"></i>Gợi Ý Các Bước Điều Trị Thường Gặp:</h5>
                                        <ul>
                                            <li>Khám và chẩn đoán ban đầu</li>
                                            <li>Chụp X-quang (nếu cần)</li>
                                            <li>Điều trị tủy răng (nếu cần)</li>
                                            <li>Trám răng sâu</li>
                                            <li>Cạo vôi răng, làm sạch nướu</li>
                                            <li>Hướng dẫn vệ sinh răng miệng</li>
                                            <li>Hẹn tái khám</li>
                                        </ul>
                                    </div>
                                </div>
                                
                                <!-- Cost Estimation -->
                                <div class="form-section">
                                    <h4><i class="fas fa-calculator me-2"></i>Ước Tính Chi Phí</h4>
                                    <div class="form-group">
                                        <label class="form-label required-field" for="estimatedCost">Chi Phí Ước Tính (VNĐ)</label>
                                        <div class="cost-input">
                                            <input type="text" class="form-control" id="estimatedCost" name="estimatedCost" 
                                                   placeholder="Nhập chi phí ước tính (không giới hạn)..." required>
                                        </div>
                                        <small class="text-muted">
                                            <i class="fas fa-info-circle me-1"></i>
                                            Nhập số tiền ước tính cho toàn bộ quá trình điều trị. 
                                            <strong>Không giới hạn số tiền</strong> - có thể nhập bất kỳ số tiền nào.
                                        </small>
                                    </div>
                                </div>
                                
                                <!-- Additional Notes -->
                                <div class="form-section">
                                    <h4><i class="fas fa-sticky-note me-2"></i>Ghi Chú Bổ Sung</h4>
                                    <div class="form-group">
                                        <label class="form-label" for="notes">Ghi Chú Thêm</label>
                                        <textarea class="form-control" id="notes" name="notes" rows="4" 
                                                  placeholder="Ghi chú thêm về kế hoạch điều trị, lưu ý đặc biệt, thời gian điều trị dự kiến, hoặc các yêu cầu của bệnh nhân...&#10;&#10;Ví dụ:&#10;- Bệnh nhân cần điều trị trong 3-4 buổi&#10;- Cần chụp X-quang trước khi điều trị tủy&#10;- Bệnh nhân có tiền sử dị ứng thuốc tê&#10;- Hẹn tái khám sau 1 tuần"></textarea>
                                    </div>
                                </div>
                                
                                <!-- Action Buttons -->
                                <div class="d-flex justify-content-between align-items-center mt-4">
                                    <a href="${pageContext.request.contextPath}/medical-record?action=form&patientId=${patient.patientId}" 
                                       class="btn btn-secondary">
                                        <i class="fas fa-times me-2"></i>Hủy Bỏ
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i>Lưu Kế Hoạch Điều Trị
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
        
        // Format cost input with unlimited amount
        document.getElementById('estimatedCost').addEventListener('input', function() {
            let value = this.value.replace(/\D/g, '');
            if (value) {
                // Remove leading zeros
                value = value.replace(/^0+/, '') || '0';
                // Format with Vietnamese locale
                this.value = parseInt(value).toLocaleString('vi-VN');
            }
        });
        
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
            
            // Validate cost input
            const costInput = document.getElementById('estimatedCost');
            if (costInput.value.trim()) {
                const numericValue = costInput.value.replace(/\D/g, '');
                if (numericValue === '' || numericValue === '0') {
                    costInput.style.borderColor = '#ef4444';
                    isValid = false;
                    alert('Chi phí ước tính phải lớn hơn 0!');
                } else {
                    costInput.style.borderColor = '#e5e7eb';
                }
            }
            
            if (!isValid) {
                e.preventDefault();
                if (!costInput.style.borderColor.includes('ef4444')) {
                    alert('Vui lòng điền đầy đủ các trường bắt buộc!');
                }
            }
        });
        
        // Add cost formatting on page load
        document.addEventListener('DOMContentLoaded', function() {
            const costInput = document.getElementById('estimatedCost');
            if (costInput.value) {
                const numericValue = costInput.value.replace(/\D/g, '');
                if (numericValue) {
                    costInput.value = parseInt(numericValue).toLocaleString('vi-VN');
                }
            }
        });
    </script>
</body>
</html>