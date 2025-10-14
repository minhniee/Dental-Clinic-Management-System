<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên Mật Khẩu - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background-color: #f8fafc;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
        }
        
        .forgot-container {
            background: #ffffff;
            padding: 3rem;
            border-radius: 0.75rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
            width: 100%;
            max-width: 28rem;
        }
        
        .forgot-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .forgot-header h1 {
            color: #0f172a;
            font-size: 2.25rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            line-height: 1.2;
        }
        
        .forgot-header p {
            color: #475569;
            font-size: 1rem;
            line-height: 1.5;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #0f172a;
            font-weight: 600;
            font-size: 0.875rem;
        }
        
        .form-group input {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #cbd5e1;
            border-radius: 0.5rem;
            font-size: 1rem;
            line-height: 1.5;
            transition: all 0.2s ease-in-out;
            background-color: #ffffff;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #06b6d4;
            box-shadow: 0 0 0 3px rgba(6, 182, 212, 0.1);
        }
        
        .btn-reset {
            width: 100%;
            padding: 0.75rem 1.5rem;
            background-color: #06b6d4;
            color: #ffffff;
            border: none;
            border-radius: 0.5rem;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease-in-out;
            min-height: 44px;
            margin-bottom: 1rem;
        }
        
        .btn-reset:hover {
            background-color: #0891b2;
        }
        
        .btn-reset:focus {
            outline: none;
            box-shadow: 0 0 0 3px rgba(6, 182, 212, 0.3);
        }
        
        .back-to-login {
            text-align: center;
            margin-top: 1.5rem;
        }
        
        .back-to-login a {
            color: #06b6d4;
            text-decoration: none;
            font-size: 0.875rem;
            font-weight: 500;
            transition: color 0.2s ease-in-out;
        }
        
        .back-to-login a:hover {
            color: #0891b2;
            text-decoration: underline;
        }
        
        .back-to-login a:focus {
            outline: none;
            text-decoration: underline;
        }
        
        .alert {
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
            font-size: 0.875rem;
            line-height: 1.5;
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
        
        .info-box {
            background-color: #f0f9ff;
            border: 1px solid #bae6fd;
            color: #0c4a6e;
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
            font-size: 0.875rem;
            line-height: 1.5;
        }
        
        .dental-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #06b6d4;
        }
        
        @media (max-width: 640px) {
            .forgot-container {
                padding: 2rem;
                margin: 1rem;
            }
            
            .forgot-header h1 {
                font-size: 1.875rem;
            }
        }
    </style>
</head>
<body>
    <div class="forgot-container">
        <div class="forgot-header">
            <div class="dental-icon">🔒</div>
            <h1>Đặt Lại Mật Khẩu</h1>
            <p>Nhập địa chỉ email của bạn để nhận mật khẩu tạm thời</p>
        </div>
        
        <!-- Display error message if exists -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                ${errorMessage}
            </div>
        </c:if>
        
        <!-- Display success message if exists -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                ${successMessage}
            </div>
            <div class="info-box">
                <strong>Quan trọng:</strong> Vui lòng lưu mật khẩu tạm thời này và thay đổi nó sau khi đăng nhập.
            </div>
        </c:if>
        
        <c:if test="${empty successMessage}">
            <div class="info-box">
                <strong>Lưu ý:</strong> Một mật khẩu tạm thời mới sẽ được tạo và hiển thị trên trang này. 
                Vui lòng thay đổi nó sau khi đăng nhập.
            </div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/forgotPassword" method="post">
            <div class="form-group">
                <label for="email">Địa Chỉ Email:</label>
                <input type="email" id="email" name="email" required 
                       value="${param.email}" placeholder="Nhập địa chỉ email của bạn">
            </div>
            
            <button type="submit" class="btn-reset">Đặt Lại Mật Khẩu</button>
        </form>
        
        <div class="back-to-login">
            <a href="${pageContext.request.contextPath}/login">← Quay Lại Đăng Nhập</a>
        </div>
    </div>
</body>
</html>
