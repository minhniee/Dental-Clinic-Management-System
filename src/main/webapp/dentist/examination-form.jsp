<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Phiên Khám - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
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
    </style>
</head>
<body>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login.jsp"/>
    </c:if>

    <div class="header">
        <h1>🦷 Thêm Phiên Khám</h1>
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
                        <i class="fas fa-stethoscope me-2"></i>
                        Thông Tin Phiên Khám
                    </h2>
                    
                    <form action="${pageContext.request.contextPath}/create-examination" method="POST">
                        <input type="hidden" name="record_id" value="${param.record_id}">
                        
                        <div class="form-group">
                            <label for="findings" class="form-label">
                                Kết Quả Khám <span class="text-danger">*</span>
                            </label>
                            <textarea id="findings" name="findings" class="form-control" rows="6" 
                                      placeholder="Mô tả chi tiết kết quả khám, các triệu chứng quan sát được, tình trạng răng miệng..." 
                                      required></textarea>
                            <div class="form-help">
                                Ví dụ: Răng cửa số 11 có vết nứt nhỏ, nướu viêm nhẹ, cao răng nhiều...
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="diagnosis" class="form-label">
                                Chẩn Đoán <span class="text-danger">*</span>
                            </label>
                            <textarea id="diagnosis" name="diagnosis" class="form-control" rows="6" 
                                      placeholder="Đưa ra chẩn đoán dựa trên kết quả khám, các bệnh lý phát hiện..." 
                                      required></textarea>
                            <div class="form-help">
                                Ví dụ: Viêm nướu cấp tính, sâu răng nhẹ, cần làm sạch cao răng...
                            </div>
                        </div>
                        
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>
                                Lưu Phiên Khám
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
</body>
</html>
