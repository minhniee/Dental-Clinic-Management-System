<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kê Đơn Thuốc - ${patient.fullName} - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
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
        
        .prescription-card {
            border: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border-radius: 1rem;
            margin-bottom: 2rem;
        }
        
        .prescription-header {
            background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
            border-bottom: 3px solid #10b981;
            border-radius: 1rem 1rem 0 0 !important;
            padding: 1.5rem;
        }
        
        .prescription-header h2 {
            color: #047857;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
        }
        
        .prescription-body {
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
        
        .btn-success {
            background: #10b981;
            color: white;
        }
        
        .btn-success:hover {
            background: #059669;
            color: white;
            transform: translateY(-1px);
        }
        
        .btn-danger {
            background: #ef4444;
            color: white;
        }
        
        .btn-danger:hover {
            background: #dc2626;
            color: white;
            transform: translateY(-1px);
        }
        
        .patient-info {
            background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
            border: 1px solid #6ee7b7;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .patient-info h3 {
            color: #047857;
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
            color: #10b981;
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
            color: #047857;
        }
        
        .form-note i {
            color: #10b981;
            margin-right: 0.5rem;
        }
        
        .medication-item {
            background: #f0fdf4;
            border: 2px solid #bbf7d0;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 1rem;
            position: relative;
        }
        
        .medication-item h5 {
            color: #047857;
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }
        
        .medication-item .remove-btn {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: #ef4444;
            color: white;
            border: none;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .medication-item .remove-btn:hover {
            background: #dc2626;
            transform: scale(1.1);
        }
        
        .medication-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 1rem;
        }
        
        .medication-grid .form-group {
            margin-bottom: 0;
        }
        
        .add-medication-btn {
            background: #10b981;
            color: white;
            border: 2px dashed #6ee7b7;
            border-radius: 0.75rem;
            padding: 2rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
            margin-bottom: 1.5rem;
        }
        
        .add-medication-btn:hover {
            background: #059669;
            border-color: #10b981;
            transform: translateY(-2px);
        }
        
        .add-medication-btn i {
            font-size: 2rem;
            margin-bottom: 0.5rem;
            display: block;
        }
        
        .medication-examples {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        
        .medication-examples h5 {
            color: #047857;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .medication-examples ul {
            margin: 0;
            padding-left: 1.5rem;
        }
        
        .medication-examples li {
            color: #374151;
            margin-bottom: 0.25rem;
        }
        
        .prescription-summary {
            background: #f0fdf4;
            border: 2px solid #10b981;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        .prescription-summary h4 {
            color: #047857;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        
        .prescription-summary .summary-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid #d1fae5;
        }
        
        .prescription-summary .summary-item:last-child {
            border-bottom: none;
            font-weight: 700;
            color: #047857;
        }
        
        @media (max-width: 768px) {
            .page-header {
                padding: 1rem 0;
            }
            
            .prescription-body {
                padding: 1rem;
            }
            
            .patient-details {
                grid-template-columns: 1fr;
            }
            
            .medication-grid {
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
                                <h1 class="mb-1">💊 Kê Đơn Thuốc Điện Tử</h1>
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
                    
                    <!-- Prescription Form -->
                    <div class="prescription-card">
                        <div class="prescription-header">
                            <h2><i class="fas fa-prescription-bottle-alt me-2"></i>Kê Đơn Thuốc Chi Tiết</h2>
                        </div>
                        <div class="prescription-body">
                            <form action="${pageContext.request.contextPath}/medical-record" method="post" id="prescriptionForm">
                                <input type="hidden" name="action" value="addPrescription">
                                <input type="hidden" name="recordId" value="${recordId}">
                                <input type="hidden" name="patientId" value="${patient.patientId}">
                                
                                <div class="form-note">
                                    <i class="fas fa-info-circle"></i>
                                    <strong>Lưu ý:</strong> Kê đơn thuốc điện tử cho bệnh nhân. Có thể thêm nhiều loại thuốc khác nhau.
                                </div>
                                
                                <!-- Prescription Date -->
                                <div class="form-section">
                                    <h4><i class="fas fa-calendar-alt me-2"></i>Thông Tin Đơn Thuốc</h4>
                                    <div class="form-group">
                                        <label class="form-label required-field" for="prescriptionDate">Ngày Kê Đơn</label>
                                        <input type="date" class="form-control" id="prescriptionDate" name="prescriptionDate" 
                                               value="${param.prescriptionDate}" required>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="notes">Ghi Chú Chung</label>
                                        <textarea class="form-control" id="notes" name="notes" rows="3" 
                                                  placeholder="Ghi chú chung cho toàn bộ đơn thuốc...&#10;&#10;Ví dụ:&#10;- Uống thuốc sau khi ăn&#10;- Tái khám sau 1 tuần&#10;- Tránh thức ăn cay nóng&#10;- Nếu có phản ứng phụ thì ngừng thuốc và liên hệ bác sĩ"></textarea>
                                    </div>
                                </div>
                                
                                <!-- Medications -->
                                <div class="form-section">
                                    <h4><i class="fas fa-pills me-2"></i>Danh Sách Thuốc</h4>
                                    
                                    <div class="medication-examples">
                                        <h5><i class="fas fa-lightbulb me-2"></i>Gợi Ý Các Loại Thuốc Thường Dùng:</h5>
                                        <ul>
                                            <li><strong>Giảm đau:</strong> Paracetamol, Ibuprofen, Diclofenac</li>
                                            <li><strong>Kháng sinh:</strong> Amoxicillin, Ciprofloxacin, Metronidazole</li>
                                            <li><strong>Chống viêm:</strong> Prednisolone, Dexamethasone</li>
                                            <li><strong>Gây tê:</strong> Lidocaine, Articaine</li>
                                            <li><strong>Kháng histamine:</strong> Cetirizine, Loratadine</li>
                                            <li><strong>Bổ sung:</strong> Vitamin C, Canxi, Fluoride</li>
                                        </ul>
                                    </div>
                                    
                                    <div id="medicationsContainer">
                                        <!-- Medications will be added here dynamically -->
                                    </div>
                                    
                                    <div class="add-medication-btn" onclick="addMedication()">
                                        <i class="fas fa-plus-circle"></i>
                                        <div>Thêm Thuốc Mới</div>
                                        <small>Nhấn để thêm loại thuốc khác</small>
                                    </div>
                                </div>
                                
                                <!-- Prescription Summary -->
                                <div class="prescription-summary" id="prescriptionSummary" style="display: none;">
                                    <h4><i class="fas fa-list-check me-2"></i>Tóm Tắt Đơn Thuốc</h4>
                                    <div id="summaryContent">
                                        <!-- Summary will be generated here -->
                                    </div>
                                </div>
                                
                                <!-- Action Buttons -->
                                <div class="d-flex justify-content-between align-items-center mt-4">
                                    <a href="${pageContext.request.contextPath}/medical-record?action=form&patientId=${patient.patientId}" 
                                       class="btn btn-secondary">
                                        <i class="fas fa-times me-2"></i>Hủy Bỏ
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i>Lưu Đơn Thuốc
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
        let medicationCount = 0;
        
        // Set today's date as default
        document.getElementById('prescriptionDate').value = new Date().toISOString().split('T')[0];
        
        // Add medication function
        function addMedication() {
            medicationCount++;
            const container = document.getElementById('medicationsContainer');
            const medicationHtml = `
                <div class="medication-item" id="medication-${medicationCount}">
                    <h5><i class="fas fa-pills me-2"></i>Thuốc #${medicationCount}</h5>
                    <button type="button" class="remove-btn" onclick="removeMedication(${medicationCount})">
                        <i class="fas fa-times"></i>
                    </button>
                    <div class="medication-grid">
                        <div class="form-group">
                            <label class="form-label required-field">Tên Thuốc</label>
                            <input type="text" class="form-control" name="medicationName" 
                                   placeholder="Ví dụ: Paracetamol 500mg" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label required-field">Liều Lượng</label>
                            <input type="text" class="form-control" name="dosage" 
                                   placeholder="Ví dụ: 2 viên/lần" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label required-field">Thời Gian</label>
                            <input type="text" class="form-control" name="duration" 
                                   placeholder="Ví dụ: 7 ngày" required>
                        </div>
                    </div>
                    <div class="form-group mt-3">
                        <label class="form-label">Hướng Dẫn Sử Dụng</label>
                        <textarea class="form-control" name="instructions" rows="2" 
                                  placeholder="Hướng dẫn chi tiết cách sử dụng thuốc...&#10;Ví dụ: Uống sau khi ăn, 2 lần/ngày, sáng và tối"></textarea>
                    </div>
                </div>
            `;
            container.insertAdjacentHTML('beforeend', medicationHtml);
            updateSummary();
        }
        
        // Remove medication function
        function removeMedication(id) {
            const medication = document.getElementById(`medication-${id}`);
            if (medication) {
                medication.remove();
                updateSummary();
            }
        }
        
        // Update prescription summary
        function updateSummary() {
            const medications = document.querySelectorAll('.medication-item');
            const summary = document.getElementById('prescriptionSummary');
            const summaryContent = document.getElementById('summaryContent');
            
            if (medications.length === 0) {
                summary.style.display = 'none';
                return;
            }
            
            let summaryHtml = '';
            medications.forEach((med, index) => {
                const name = med.querySelector('input[name="medicationName"]').value || 'Chưa nhập tên';
                const dosage = med.querySelector('input[name="dosage"]').value || 'Chưa nhập liều';
                const duration = med.querySelector('input[name="duration"]').value || 'Chưa nhập thời gian';
                const instructions = med.querySelector('textarea[name="instructions"]').value || 'Chưa có hướng dẫn';
                
                summaryHtml += `
                    <div class="summary-item">
                        <span><strong>${index + 1}. ${name}</strong></span>
                        <span>${dosage} - ${duration}</span>
                    </div>
                `;
            });
            
            summaryContent.innerHTML = summaryHtml;
            summary.style.display = 'block';
        }
        
        // Add event listeners for real-time summary update
        document.addEventListener('input', function(e) {
            if (e.target.matches('input[name="medicationName"], input[name="dosage"], input[name="duration"], textarea[name="instructions"]')) {
                updateSummary();
            }
        });
        
        // Form validation
        document.getElementById('prescriptionForm').addEventListener('submit', function(e) {
            const medications = document.querySelectorAll('.medication-item');
            
            if (medications.length === 0) {
                e.preventDefault();
                alert('Vui lòng thêm ít nhất một loại thuốc!');
                return;
            }
            
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
        
        // Auto-resize textareas
        document.addEventListener('input', function(e) {
            if (e.target.tagName === 'TEXTAREA') {
                e.target.style.height = 'auto';
                e.target.style.height = e.target.scrollHeight + 'px';
            }
        });
        
        // Add first medication on page load
        document.addEventListener('DOMContentLoaded', function() {
            addMedication();
        });
    </script>
</body>
</html>