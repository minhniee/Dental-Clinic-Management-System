<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Buổi Điều Trị - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
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
        
        .form-help {
            font-size: 0.875rem;
            color: #6b7280;
            margin-top: 0.25rem;
        }
        
        .cost-input {
            position: relative;
        }
        
        .cost-input::after {
            content: "VNĐ";
            position: absolute;
            right: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: #6b7280;
            font-weight: 600;
        }
        
        .datetime-input {
            display: flex;
            gap: 1rem;
        }
        
        .datetime-input .form-control {
            flex: 1;
        }
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login.jsp"/>
    </c:if>

    <div class="header">
        <h1>🦷 Thêm Buổi Điều Trị</h1>
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
                        <i class="fas fa-calendar-check me-2"></i>
                        Thông Tin Buổi Điều Trị
                    </h2>
                    
                    <form action="${pageContext.request.contextPath}/create-treatment-session" method="POST">
                        <input type="hidden" name="plan_id" value="${param.plan_id}">
                        
                        <div class="form-group">
                            <label for="session_date" class="form-label">
                                Ngày và Giờ Điều Trị <span class="text-danger">*</span>
                            </label>
                            <div class="datetime-input">
                                <input type="date" id="session_date" name="session_date" class="form-control" 
                                       required>
                                <input type="time" id="session_time" name="session_time" class="form-control" 
                                       required>
                            </div>
                            <div class="form-help">
                                Chọn ngày và giờ thực hiện buổi điều trị
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="procedure_done" class="form-label">
                                Thủ Thuật Đã Thực Hiện <span class="text-danger">*</span>
                            </label>
                            <textarea id="procedure_done" name="procedure_done" class="form-control" rows="6" 
                                      placeholder="Mô tả chi tiết các thủ thuật đã thực hiện trong buổi điều trị này..." 
                                      required></textarea>
                            <div class="form-help">
                                Ví dụ: 
                                <br>• Làm sạch cao răng toàn bộ hàm trên và dưới
                                <br>• Đánh bóng răng bằng máy chuyên dụng
                                <br>• Hướng dẫn bệnh nhân cách chăm sóc răng miệng
                                <br>• Kê đơn thuốc kháng viêm
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="session_cost" class="form-label">
                                Chi Phí Buổi Điều Trị
                            </label>
                            <div class="cost-input">
                                <input type="number" id="session_cost" name="session_cost" class="form-control" 
                                       placeholder="Nhập chi phí buổi điều trị" min="0" step="1000">
                            </div>
                            <div class="form-help">
                                Nhập chi phí cho buổi điều trị này (không bắt buộc)
                            </div>
                        </div>
                        
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>
                                Lưu Buổi Điều Trị
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
        // Set default date to today
        document.getElementById('session_date').value = new Date().toISOString().split('T')[0];
        
        // Set default time to current time
        const now = new Date();
        const timeString = now.getHours().toString().padStart(2, '0') + ':' + 
                          now.getMinutes().toString().padStart(2, '0');
        document.getElementById('session_time').value = timeString;
    </script>
</body>
</html>
