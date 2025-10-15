<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kê Đơn Thuốc - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .form-container {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            max-width: 1000px;
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
        
        .btn-success {
            background-color: #10b981;
            color: white;
        }
        
        .btn-success:hover {
            background-color: #059669;
        }
        
        .btn-secondary {
            background-color: #6b7280;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #4b5563;
        }
        
        .btn-danger {
            background-color: #ef4444;
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #dc2626;
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
        
        .form-help {
            font-size: 0.875rem;
            color: #6b7280;
            margin-top: 0.25rem;
        }
        
        .medication-item {
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            padding: 1.5rem;
            margin-bottom: 1rem;
            position: relative;
        }
        
        .medication-item:last-child {
            margin-bottom: 0;
        }
        
        .medication-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 1rem;
        }
        
        .medication-number {
            background-color: #06b6d4;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            margin-right: 1rem;
        }
        
        .remove-medication {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background-color: #ef4444;
            color: white;
            border: none;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .remove-medication:hover {
            background-color: #dc2626;
        }
        
        .medication-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
        
        .medication-grid.full-width {
            grid-template-columns: 1fr;
        }
        
        .add-medication-btn {
            background-color: #10b981;
            color: white;
            border: none;
            border-radius: 0.5rem;
            padding: 1rem;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            width: 100%;
            margin-top: 1rem;
        }
        
        .add-medication-btn:hover {
            background-color: #059669;
        }
        
        .empty-state {
            text-align: center;
            padding: 2rem;
            color: #6b7280;
            background-color: #f8fafc;
            border: 2px dashed #d1d5db;
            border-radius: 0.5rem;
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
        <h1>🦷 Kê Đơn Thuốc</h1>
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
                
                <!-- Form Container -->
                <div class="form-container">
                    <h2 class="section-title">
                        <i class="fas fa-prescription me-2"></i>
                        Thông Tin Đơn Thuốc
                    </h2>
                    
                    <form action="${pageContext.request.contextPath}/create-prescription" method="POST" id="prescriptionForm">
                        <input type="hidden" name="patient_id" value="${param.patient_id}">
                        
                        <div class="form-group">
                            <label for="notes" class="form-label">
                                Ghi Chú Đơn Thuốc
                            </label>
                            <textarea id="notes" name="notes" class="form-control" rows="4" 
                                      placeholder="Nhập ghi chú về đơn thuốc, hướng dẫn sử dụng chung, lưu ý đặc biệt..."></textarea>
                            <div class="form-help">
                                Ví dụ: Uống thuốc sau khi ăn, tránh uống rượu bia, tái khám sau 1 tuần...
                            </div>
                        </div>
                        
                        <!-- Medications Section -->
                        <div class="form-group">
                            <label class="form-label">
                                Danh Sách Thuốc <span class="text-danger">*</span>
                            </label>
                            
                            <div id="medications-container">
                                <div class="empty-state" id="empty-state">
                                    <i class="fas fa-pills"></i>
                                    <p>Chưa có thuốc nào được thêm</p>
                                    <p>Nhấn nút "Thêm Thuốc" để bắt đầu</p>
                                </div>
                            </div>
                            
                            <button type="button" class="add-medication-btn" onclick="addMedication()">
                                <i class="fas fa-plus me-2"></i>
                                Thêm Thuốc
                            </button>
                        </div>
                        
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>
                                Tạo Đơn Thuốc
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
        let medicationCount = 0;
        
        function addMedication() {
            medicationCount++;
            
            // Hide empty state
            const emptyState = document.getElementById('empty-state');
            if (emptyState) {
                emptyState.style.display = 'none';
            }
            
            const container = document.getElementById('medications-container');
            const medicationItem = document.createElement('div');
            medicationItem.className = 'medication-item';
            medicationItem.id = 'medication-' + medicationCount;
            
            medicationItem.innerHTML = `
                <div class="medication-header">
                    <div class="medication-number">${medicationCount}</div>
                    <h6 class="mb-0">Thuốc ${medicationCount}</h6>
                </div>
                <button type="button" class="remove-medication" onclick="removeMedication(${medicationCount})">
                    <i class="fas fa-times"></i>
                </button>
                
                <div class="medication-grid">
                    <div class="form-group">
                        <label class="form-label">Tên Thuốc <span class="text-danger">*</span></label>
                        <input type="text" name="medication_name_${medicationCount}" class="form-control" 
                               placeholder="Ví dụ: Amoxicillin, Ibuprofen..." required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Liều Lượng</label>
                        <input type="text" name="dosage_${medicationCount}" class="form-control" 
                               placeholder="Ví dụ: 500mg, 2 viên...">
                    </div>
                </div>
                
                <div class="medication-grid">
                    <div class="form-group">
                        <label class="form-label">Thời Gian Sử Dụng</label>
                        <input type="text" name="duration_${medicationCount}" class="form-control" 
                               placeholder="Ví dụ: 7 ngày, 2 tuần...">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Cách Sử Dụng</label>
                        <input type="text" name="instructions_${medicationCount}" class="form-control" 
                               placeholder="Ví dụ: Uống 3 lần/ngày sau ăn...">
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Hướng Dẫn Chi Tiết</label>
                    <textarea name="detailed_instructions_${medicationCount}" class="form-control" rows="2" 
                              placeholder="Hướng dẫn chi tiết về cách sử dụng thuốc, lưu ý đặc biệt..."></textarea>
                </div>
            `;
            
            container.appendChild(medicationItem);
        }
        
        function removeMedication(id) {
            const medicationItem = document.getElementById('medication-' + id);
            if (medicationItem) {
                medicationItem.remove();
                
                // Show empty state if no medications left
                const container = document.getElementById('medications-container');
                const medications = container.querySelectorAll('.medication-item');
                if (medications.length === 0) {
                    const emptyState = document.getElementById('empty-state');
                    if (emptyState) {
                        emptyState.style.display = 'block';
                    }
                }
            }
        }
        
        // Form validation
        document.getElementById('prescriptionForm').addEventListener('submit', function(e) {
            const medications = document.querySelectorAll('.medication-item');
            if (medications.length === 0) {
                e.preventDefault();
                alert('Vui lòng thêm ít nhất một loại thuốc vào đơn thuốc.');
                return false;
            }
            
            // Validate required fields
            let isValid = true;
            medications.forEach((medication, index) => {
                const medicationName = medication.querySelector('input[name^="medication_name_"]');
                if (!medicationName.value.trim()) {
                    isValid = false;
                    medicationName.focus();
                }
            });
            
            if (!isValid) {
                e.preventDefault();
                alert('Vui lòng nhập tên thuốc cho tất cả các loại thuốc.');
                return false;
            }
        });
    </script>
</body>
</html>
