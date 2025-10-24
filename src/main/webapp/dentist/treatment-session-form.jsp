<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ghi Phiên Điều Trị - ${patient.fullName} - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .page-header {
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
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
        
        .session-card {
            border: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border-radius: 1rem;
            margin-bottom: 2rem;
        }
        
        .session-header {
            background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
            border-bottom: 3px solid #3b82f6;
            border-radius: 1rem 1rem 0 0 !important;
            padding: 1.5rem;
        }
        
        .session-header h2 {
            color: #1e40af;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
        }
        
        .session-body {
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
            border-color: #3b82f6;
            outline: 0;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
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
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            color: white;
            box-shadow: 0 4px 6px rgba(59, 130, 246, 0.3);
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #1d4ed8 0%, #1e40af 100%);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(59, 130, 246, 0.4);
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
            background: #dbeafe;
            border: 1px solid #3b82f6;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
            color: #1e40af;
        }
        
        .form-note i {
            color: #3b82f6;
            margin-right: 0.5rem;
        }
        
        .cost-input {
            position: relative;
        }
        
        .cost-input input {
            padding-right: 12px;
        }
        
        .procedure-examples {
            background: #f0f9ff;
            border: 1px solid #bae6fd;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        
        .procedure-examples h5 {
            color: #0c4a6e;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .procedure-examples ul {
            margin: 0;
            padding-left: 1.5rem;
        }
        
        .procedure-examples li {
            color: #374151;
            margin-bottom: 0.25rem;
        }
        
        @media (max-width: 768px) {
            .page-header {
                padding: 1rem 0;
            }
            
            .session-body {
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
                                <h1 class="mb-1">👨‍⚕️ Ghi Phiên Điều Trị</h1>
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
                                <span><strong>Ngày Sinh:</strong> 
                                    <c:choose>
                                        <c:when test="${not empty patient.birthDate}">
                                            <fmt:formatDate value="${patient.birthDateAsDate}" pattern="dd/MM/yyyy"/>
                                        </c:when>
                                        <c:otherwise>
                                            Chưa cập nhật
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="patient-detail">
                                <i class="fas fa-phone"></i>
                                <span><strong>SĐT:</strong> ${patient.phone}</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Treatment Session Form -->
                    <div class="session-card">
                        <div class="session-header">
                            <h2><i class="fas fa-user-md me-2"></i>Ghi Phiên Điều Trị Chi Tiết</h2>
                        </div>
                        <div class="session-body">
                            <form action="${pageContext.request.contextPath}/medical-record" method="post">
                                <input type="hidden" name="action" value="addTreatmentSession">
                                <input type="hidden" name="recordId" value="${recordId}">
                                <input type="hidden" name="patientId" value="${patient.patientId}">
                                
                                <div class="form-note">
                                    <i class="fas fa-info-circle"></i>
                                    <strong>Lưu ý:</strong> Ghi lại chi tiết phiên điều trị đã thực hiện, bao gồm thủ thuật, chi phí và ghi chú.
                                </div>
                                
                                <!-- Session Date -->
                                <div class="form-section">
                                    <h4><i class="fas fa-calendar-alt me-2"></i>Thông Tin Phiên Điều Trị</h4>
                                    <div class="form-group">
                                        <label class="form-label required-field" for="sessionDate">Ngày Điều Trị</label>
                                        <input type="date" class="form-control" id="sessionDate" name="sessionDate" 
                                               value="${param.sessionDate}" required>
                                    </div>
                                </div>
                                
                                <!-- Procedure Details -->
                                <div class="form-section">
                                    <h4><i class="fas fa-procedures me-2"></i>Thủ Thuật Thực Hiện</h4>
                                    <div class="form-group">
                                        <label class="form-label required-field" for="procedure">Mô Tả Thủ Thuật</label>
                                        <textarea class="form-control" id="procedure" name="procedure" rows="5" 
                                                  placeholder="Mô tả chi tiết thủ thuật đã thực hiện...&#10;&#10;Ví dụ:&#10;- Điều trị tủy răng số 6&#10;- Làm sạch ống tủy, đặt thuốc sát khuẩn&#10;- Trám bít ống tủy bằng gutta-percha&#10;- Chụp X-quang kiểm tra" required></textarea>
                                    </div>
                                    
                                    <div class="procedure-examples">
                                        <h5><i class="fas fa-lightbulb me-2"></i>Gợi Ý Các Thủ Thuật Thường Gặp:</h5>
                                        <ul>
                                            <li>Điều trị tủy răng (Root canal treatment)</li>
                                            <li>Trám răng sâu (Dental filling)</li>
                                            <li>Cạo vôi răng (Teeth cleaning)</li>
                                            <li>Nhổ răng (Tooth extraction)</li>
                                            <li>Làm cầu răng (Dental bridge)</li>
                                            <li>Làm răng giả (Dentures)</li>
                                            <li>Chỉnh nha (Orthodontics)</li>
                                            <li>Phẫu thuật nha chu (Periodontal surgery)</li>
                                        </ul>
                                    </div>
                                </div>
                                
                                <!-- Cost Information -->
                                <div class="form-section">
                                    <h4><i class="fas fa-calculator me-2"></i>Chi Phí Phiên Điều Trị</h4>
                                    <div class="form-group">
                                        <label class="form-label required-field" for="sessionCost">Chi Phí Phiên (VNĐ)</label>
                                        <div class="cost-input">
                                            <input type="text" class="form-control" id="sessionCost" name="sessionCost" 
                                                   placeholder="Nhập chi phí phiên điều trị (không giới hạn)..." required>
                                        </div>
                                        <small class="text-muted">
                                            <i class="fas fa-info-circle me-1"></i>
                                            Nhập chi phí thực tế của phiên điều trị này. 
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
                                                  placeholder="Ghi chú thêm về phiên điều trị, tình trạng bệnh nhân, phản ứng thuốc, hoặc các lưu ý đặc biệt...&#10;&#10;Ví dụ:&#10;- Bệnh nhân phản ứng tốt với thuốc tê&#10;- Cần theo dõi tình trạng sưng nướu&#10;- Hẹn tái khám sau 1 tuần&#10;- Hướng dẫn vệ sinh răng miệng"></textarea>
                                    </div>
                                </div>
                                
                                <!-- Action Buttons -->
                                <div class="d-flex justify-content-between align-items-center mt-4">
                                    <a href="${pageContext.request.contextPath}/medical-record?action=form&patientId=${patient.patientId}" 
                                       class="btn btn-secondary">
                                        <i class="fas fa-times me-2"></i>Hủy Bỏ
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i>Lưu Phiên Điều Trị
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
        document.getElementById('sessionDate').value = new Date().toISOString().split('T')[0];
        
        // Format cost input with unlimited amount
        document.getElementById('sessionCost').addEventListener('input', function() {
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
            const costInput = document.getElementById('sessionCost');
            if (costInput.value.trim()) {
                const numericValue = costInput.value.replace(/\D/g, '');
                if (numericValue === '' || numericValue === '0') {
                    costInput.style.borderColor = '#ef4444';
                    isValid = false;
                    alert('Chi phí phiên điều trị phải lớn hơn 0!');
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
            const costInput = document.getElementById('sessionCost');
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

