<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Lịch Hẹn - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .edit-appointment-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .edit-card {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }
        
        .edit-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .edit-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #0f172a;
            margin: 0;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }
        
        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #d1d5db;
            border-radius: 0.5rem;
            font-size: 1rem;
            transition: all 0.2s ease-in-out;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #06b6d4;
            box-shadow: 0 0 0 3px rgba(6, 182, 212, 0.1);
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
        
        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            margin-top: 2rem;
            padding-top: 1rem;
            border-top: 1px solid #e2e8f0;
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: all 0.2s ease-in-out;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.875rem;
        }
        
        .btn-primary {
            background-color: #06b6d4;
            color: #ffffff;
        }
        
        .btn-primary:hover {
            background-color: #0891b2;
        }
        
        .btn-secondary {
            background-color: #64748b;
            color: #ffffff;
        }
        
        .btn-secondary:hover {
            background-color: #475569;
        }
        
        .alert {
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
        }
        
        .alert-success {
            background-color: #f0fdf4;
            color: #16a34a;
            border: 1px solid #bbf7d0;
        }
        
        .alert-error {
            background-color: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }
        
        .status-info {
            background-color: #f0f9ff;
            border: 1px solid #bae6fd;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .status-info h4 {
            margin: 0 0 0.5rem 0;
            color: #0369a1;
            font-size: 0.875rem;
        }
        
        .status-info p {
            margin: 0;
            color: #0369a1;
            font-size: 0.875rem;
        }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>
    
    <c:set var="_role" value="${empty sessionScope.user or empty sessionScope.user.role or empty sessionScope.user.role.roleName ? '' : fn:toLowerCase(fn:replace(sessionScope.user.role.roleName, ' ', ''))}"/>
    <c:if test="${_role ne 'receptionist'}">
        <c:redirect url="${pageContext.request.contextPath}/login"/>
    </c:if>
    
    <div class="dashboard-layout">
        <jsp:include page="../shared/left-navbar.jsp"/>
        
        <main class="main-content">
            <div class="edit-appointment-container">
                <!-- Alert Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <c:out value="${successMessage}"/>
                    </div>
                </c:if>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <c:out value="${errorMessage}"/>
                    </div>
                </c:if>

                <div class="edit-card">
                    <!-- Header -->
                    <div class="edit-header">
                        <h1 class="edit-title">Chỉnh Sửa Lịch Hẹn #${appointment.appointmentId}</h1>
                        <a href="${pageContext.request.contextPath}/receptionist/appointments" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i>
                            Quay Lại
                        </a>
                    </div>

                    <!-- Status Info -->
                    <div class="status-info">
                        <h4><i class="fas fa-info-circle"></i> Trạng Thái Hiện Tại</h4>
                        <p>
                            Lịch hẹn hiện tại có trạng thái: <strong>${appointment.status}</strong>
                            <c:if test="${appointment.status eq 'COMPLETED' or appointment.status eq 'CANCELLED'}">
                                - Không thể chỉnh sửa lịch hẹn đã hoàn thành hoặc đã hủy
                            </c:if>
                        </p>
                    </div>

                    <!-- Edit Form -->
                    <c:if test="${appointment.status ne 'COMPLETED' and appointment.status ne 'CANCELLED'}">
                        <form method="POST" action="${pageContext.request.contextPath}/receptionist/appointments">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="patientId">Bệnh Nhân *</label>
                                    <select id="patientId" name="patientId" class="form-control" required>
                                        <option value="">Chọn bệnh nhân</option>
                                        <c:forEach var="patient" items="${patients}">
                                            <option value="${patient.patientId}" 
                                                    ${appointment.patientId eq patient.patientId ? 'selected' : ''}>
                                                ${patient.fullName} - ${patient.phone}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label for="dentistId">Bác Sĩ *</label>
                                    <select id="dentistId" name="dentistId" class="form-control" required>
                                        <option value="">Chọn bác sĩ</option>
                                        <c:forEach var="dentist" items="${dentists}">
                                            <option value="${dentist.userId}" 
                                                    ${appointment.dentistId eq dentist.userId ? 'selected' : ''}>
                                                ${dentist.fullName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="serviceId">Dịch Vụ *</label>
                                    <select id="serviceId" name="serviceId" class="form-control" required>
                                        <option value="">Chọn dịch vụ</option>
                                        <c:forEach var="service" items="${services}">
                                            <option value="${service.serviceId}" 
                                                    ${appointment.serviceId eq service.serviceId ? 'selected' : ''}>
                                                ${service.name} - 
                                                <fmt:formatNumber value="${service.price}" type="currency" currencyCode="VND"/>
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label for="appointmentDate">Ngày Giờ Hẹn *</label>
                                    <input type="datetime-local" 
                                           id="appointmentDate" 
                                           name="appointmentDate" 
                                           class="form-control" 
                                           value="${appointment.appointmentDateForInput}"
                                           required>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="notes">Ghi Chú</label>
                                <textarea id="notes" 
                                          name="notes" 
                                          class="form-control" 
                                          rows="3" 
                                          placeholder="Nhập ghi chú cho lịch hẹn...">${appointment.notes}</textarea>
                            </div>
                            
                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/receptionist/appointments" class="btn btn-secondary">
                                    <i class="fas fa-times"></i>
                                    Hủy
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i>
                                    Cập Nhật Lịch Hẹn
                                </button>
                            </div>
                        </form>
                    </c:if>
                    
                    <c:if test="${appointment.status eq 'COMPLETED' or appointment.status eq 'CANCELLED'}">
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-triangle"></i>
                            Không thể chỉnh sửa lịch hẹn đã hoàn thành hoặc đã hủy.
                        </div>
                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/receptionist/appointments" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i>
                                Quay Lại
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Set minimum date to now
        document.addEventListener('DOMContentLoaded', function() {
            const dateInput = document.getElementById('appointmentDate');
            if (dateInput) {
                const now = new Date();
                const minDateTime = now.toISOString().slice(0, 16);
                dateInput.min = minDateTime;
                
                // Add validation on change
                dateInput.addEventListener('change', function() {
                    const selectedDate = new Date(this.value);
                    const now = new Date();
                    
                    if (selectedDate <= now) {
                        alert('Không thể chọn thời gian trong quá khứ!');
                        this.value = minDateTime;
                    }
                });
            }
        });
    </script>
</body>
</html>
