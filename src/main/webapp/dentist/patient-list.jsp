<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Bệnh Nhân - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .section-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
        }
        
        .section-title {
            color: #0f172a;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            border-bottom: 2px solid #06b6d4;
            padding-bottom: 0.5rem;
        }
        
        .patient-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .patient-card:hover {
            border-color: #06b6d4;
            box-shadow: 0 4px 12px 0 rgba(6, 182, 212, 0.15);
            transform: translateY(-2px);
        }
        
        .patient-card.not-examined {
            border-left: 4px solid #10b981;
        }
        
        .patient-card.examined {
            border-left: 4px solid #6b7280;
            opacity: 0.7;
        }
        
        .patient-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1rem;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            padding: 0.5rem;
            background-color: #f8fafc;
            border-radius: 0.5rem;
        }
        
        .info-item i {
            color: #06b6d4;
            margin-right: 0.5rem;
            width: 16px;
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
        }
        
        .btn-secondary {
            background-color: #6b7280;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #4b5563;
        }
        
        .btn-success {
            background-color: #10b981;
            color: white;
        }
        
        .btn-success:hover {
            background-color: #059669;
        }
        
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-not-examined {
            background-color: #10b981;
            color: white;
        }
        
        .status-examined {
            background-color: #6b7280;
            color: white;
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6b7280;
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            color: #d1d5db;
        }
        
        .filter-tabs {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .filter-tab {
            padding: 0.75rem 1.5rem;
            border: 2px solid #e2e8f0;
            border-radius: 0.5rem;
            background: white;
            color: #6b7280;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s;
        }
        
        .filter-tab.active {
            border-color: #06b6d4;
            background-color: #06b6d4;
            color: white;
        }
        
        .filter-tab:hover {
            border-color: #06b6d4;
            color: #06b6d4;
        }
        
        .filter-tab.active:hover {
            color: white;
        }
        
        .gap-2 {
            gap: 0.5rem;
        }
        
        .badge {
            padding: 0.25rem 0.5rem;
            border-radius: 0.375rem;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .bg-primary {
            background-color: #3b82f6;
            color: white;
        }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login.jsp"/>
    </c:if>

    <div class="header">
        <h1>Danh Sách Bệnh Nhân</h1>
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
                
                
                <!-- Filter Tabs -->
                <div class="filter-tabs">
                    <a href="#" class="filter-tab active" onclick="showNotExamined()">
                        <i class="fas fa-user-clock me-2"></i>
                        Chưa Khám
                    </a>
                    <a href="#" class="filter-tab" onclick="showAll()">
                        <i class="fas fa-users me-2"></i>
                        Tất Cả Có Lịch Hẹn
                    </a>
                </div>
                
                <!-- Patients Not Examined Today -->
                <div id="not-examined-section" class="section-card">
                    <h2 class="section-title">
                        <i class="fas fa-user-clock me-2"></i>
                        Bệnh Nhân Có Lịch Hẹn Chưa Khám
                    </h2>
                    
                    <c:choose>
                        <c:when test="${not empty patientsNotExamined}">
                            <c:forEach var="patient" items="${patientsNotExamined}">
                                <div class="patient-card not-examined" onclick="openMedicalRecord('${patient.patientId}')">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <h5 class="mb-0">${patient.fullName}</h5>
                                        <div class="d-flex align-items-center gap-2">
                                            <c:if test="${not empty patient.positionInQueue}">
                                                <span class="badge bg-primary">Số ${patient.positionInQueue}</span>
                                            </c:if>
                                            <span class="status-badge status-not-examined">Chưa Khám</span>
                                        </div>
                                    </div>
                                    
                                    <div class="patient-info">
                                        <c:if test="${not empty patient.phone}">
                                            <div class="info-item">
                                                <i class="fas fa-phone"></i>
                                                <span>${patient.phone}</span>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty patient.email}">
                                            <div class="info-item">
                                                <i class="fas fa-envelope"></i>
                                                <span>${patient.email}</span>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty patient.birthDate}">
                                            <div class="info-item">
                                                <i class="fas fa-birthday-cake"></i>
                                                <span>
                                                    ${patient.birthDate}
                                                    (<c:choose>
                                                        <c:when test="${patient.gender.toString() == 'M'}">Nam</c:when>
                                                        <c:when test="${patient.gender.toString() == 'F'}">Nữ</c:when>
                                                        <c:otherwise>Khác</c:otherwise>
                                                    </c:choose>)
                                                </span>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty patient.address}">
                                            <div class="info-item">
                                                <i class="fas fa-map-marker-alt"></i>
                                                <span>${patient.address}</span>
                                            </div>
                                        </c:if>
                                    </div>
                                    
                                    <div class="d-flex justify-content-end gap-2">
                                        <a href="/dental_clinic_management_system/medical-record?action=form&patientId=${patient.patientId}" 
                                           class="btn btn-primary" onclick="event.stopPropagation()">
                                            <i class="fas fa-file-medical me-1"></i>
                                            Mở Hồ Sơ Khám
                                        </a>
                                        <button class="btn btn-success" onclick="markAsExamined('${patient.patientId}', this)" title="Đánh dấu đã khám">
                                            <i class="fas fa-check me-1"></i>
                                            Đã Khám
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-user-check"></i>
                                <h4>Tất cả bệnh nhân có lịch hẹn đã được khám!</h4>
                                <p>Không có bệnh nhân nào có lịch hẹn hôm nay chưa được khám.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- All Patients -->
                <div id="all-patients-section" class="section-card" style="display: none;">
                    <h2 class="section-title">
                        <i class="fas fa-users me-2"></i>
                        Tất Cả Bệnh Nhân Có Lịch Hẹn Hôm Nay
                    </h2>
                    
                    <c:choose>
                        <c:when test="${not empty allPatients}">
                            <c:forEach var="patient" items="${allPatients}">
                                <div class="patient-card examined" onclick="openMedicalRecord('${patient.patientId}')">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <h5 class="mb-0">${patient.fullName}</h5>
                                        <div class="d-flex align-items-center gap-2">
                                            <c:if test="${not empty patient.positionInQueue}">
                                                <span class="badge bg-primary">Số ${patient.positionInQueue}</span>
                                            </c:if>
                                            <c:choose>
                                                <c:when test="${patient.queueStatus == 'COMPLETED'}">
                                                    <span class="status-badge status-examined">Đã Khám</span>
                                                </c:when>
                                                <c:when test="${patient.queueStatus == 'IN_TREATMENT'}">
                                                    <span class="status-badge" style="background-color: #f59e0b; color: white;">Đang Khám</span>
                                                </c:when>
                                                <c:when test="${patient.queueStatus == 'CALLED'}">
                                                    <span class="status-badge" style="background-color: #3b82f6; color: white;">Đã Gọi</span>
                                                </c:when>
                                                <c:when test="${patient.queueStatus == 'CHECKED_IN'}">
                                                    <span class="status-badge" style="background-color: #10b981; color: white;">Đã Check-in</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-examined">Đã Khám</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <div class="patient-info">
                                        <c:if test="${not empty patient.phone}">
                                            <div class="info-item">
                                                <i class="fas fa-phone"></i>
                                                <span>${patient.phone}</span>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty patient.email}">
                                            <div class="info-item">
                                                <i class="fas fa-envelope"></i>
                                                <span>${patient.email}</span>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty patient.birthDate}">
                                            <div class="info-item">
                                                <i class="fas fa-birthday-cake"></i>
                                                <span>
                                                    ${patient.birthDate}
                                                    (<c:choose>
                                                        <c:when test="${patient.gender.toString() == 'M'}">Nam</c:when>
                                                        <c:when test="${patient.gender.toString() == 'F'}">Nữ</c:when>
                                                        <c:otherwise>Khác</c:otherwise>
                                                    </c:choose>)
                                                </span>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty patient.address}">
                                            <div class="info-item">
                                                <i class="fas fa-map-marker-alt"></i>
                                                <span>${patient.address}</span>
                                            </div>
                                        </c:if>
                                    </div>
                                    
                                    <div class="d-flex justify-content-end">
                                        <a href="/dental_clinic_management_system/medical-record?action=form&patientId=${patient.patientId}" 
                                           class="btn btn-secondary" onclick="event.stopPropagation()">
                                            <i class="fas fa-eye me-1"></i>
                                            Xem Hồ Sơ
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-calendar-times"></i>
                                <h4>Không có lịch hẹn hôm nay</h4>
                                <p>Không có bệnh nhân nào có lịch hẹn trong ngày hôm nay.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
            </div>
        </main>
    </div>
    
    <script>
        function showNotExamined() {
            document.getElementById('not-examined-section').style.display = 'block';
            document.getElementById('all-patients-section').style.display = 'none';
            
            // Update active tab
            document.querySelectorAll('.filter-tab').forEach(tab => tab.classList.remove('active'));
            event.target.classList.add('active');
        }
        
        function showAll() {
            document.getElementById('not-examined-section').style.display = 'none';
            document.getElementById('all-patients-section').style.display = 'block';
            
            // Update active tab
            document.querySelectorAll('.filter-tab').forEach(tab => tab.classList.remove('active'));
            event.target.classList.add('active');
        }
        
        function openMedicalRecord(patientId) {
            window.location.href = '/dental_clinic_management_system/medical-record?action=form&patientId=' + patientId;
        }
        
        function markAsExamined(patientId, buttonElement) {
            if (confirm('Bạn có chắc chắn muốn đánh dấu bệnh nhân này đã khám?')) {
                // Show loading state
                const originalText = buttonElement.innerHTML;
                buttonElement.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
                buttonElement.disabled = true;
                
                // Send request to mark as examined
                fetch('/dental_clinic_management_system/patient/mark-examined', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'patientId=' + patientId
                })
                .then(response => {
                    if (response.ok) {
                        // Get the patient card
                        const patientCard = buttonElement.closest('.patient-card');
                        
                        // Update UI
                        patientCard.classList.remove('not-examined');
                        patientCard.classList.add('examined');
                        
                        // Update status badge
                        const statusBadge = patientCard.querySelector('.status-badge');
                        statusBadge.textContent = 'Đã Khám';
                        statusBadge.className = 'status-badge status-examined';
                        
                        // Update button
                        buttonElement.innerHTML = '<i class="fas fa-check me-1"></i>Đã Khám';
                        buttonElement.className = 'btn btn-secondary';
                        buttonElement.disabled = true;
                        buttonElement.title = 'Đã được đánh dấu khám';
                        
                        // Move patient card to "All Patients" section
                        const notExaminedSection = document.getElementById('not-examined-section');
                        const allPatientsSection = document.getElementById('all-patients-section');
                        
                        // Find the patients container in all patients section
                        const allPatientsContainer = allPatientsSection.querySelector('.c:choose');
                        if (allPatientsContainer) {
                            // Clone the patient card
                            const clonedCard = patientCard.cloneNode(true);
                            
                            // Update the cloned card's button to "Xem Hồ Sơ"
                            const clonedButton = clonedCard.querySelector('.btn-success');
                            if (clonedButton) {
                                clonedButton.innerHTML = '<i class="fas fa-eye me-1"></i>Xem Hồ Sơ';
                                clonedButton.className = 'btn btn-secondary';
                                clonedButton.onclick = function() {
                                    window.location.href = '/dental_clinic_management_system/medical-record?action=form&patientId=' + patientId;
                                };
                            }
                            
                            // Add to all patients section
                            allPatientsContainer.appendChild(clonedCard);
                        }
                        
                        // Remove from not examined section
                        patientCard.remove();
                        
                        // Check if there are any more not examined patients
                        const remainingNotExamined = notExaminedSection.querySelectorAll('.patient-card.not-examined');
                        if (remainingNotExamined.length === 0) {
                            // Show empty state for not examined section
                            const notExaminedContent = notExaminedSection.querySelector('.c:choose');
                            if (notExaminedContent) {
                                notExaminedContent.innerHTML = `
                                    <div class="empty-state">
                                        <i class="fas fa-user-check"></i>
                                        <h4>Tất cả bệnh nhân đã được khám hôm nay!</h4>
                                        <p>Không có bệnh nhân nào chưa được khám trong ngày hôm nay.</p>
                                    </div>
                                `;
                            }
                        }
                        
                        // Show success message
                        alert('Đã đánh dấu bệnh nhân đã khám thành công!');
                        
                    } else {
                        throw new Error('Failed to mark patient as examined');
                    }
                })
                .catch(error => {
                    console.error('Error marking patient as examined:', error);
                    alert('Có lỗi xảy ra khi đánh dấu bệnh nhân đã khám. Vui lòng thử lại.');
                    buttonElement.innerHTML = originalText;
                    buttonElement.disabled = false;
                });
            }
        }
    </script>
</body>
</html>
