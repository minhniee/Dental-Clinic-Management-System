<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Dental Clinic Management System</title>
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
        
        .login-container {
            background: #ffffff;
            padding: 3rem;
            border-radius: 0.75rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
            width: 100%;
            max-width: 28rem;
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .login-header h1 {
            color: #0f172a;
            font-size: 2.25rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            line-height: 1.2;
        }
        
        .login-header p {
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
        
        .btn-login {
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
        }
        
        .btn-login:hover {
            background-color: #0891b2;
        }
        
        .btn-login:focus {
            outline: none;
            box-shadow: 0 0 0 3px rgba(6, 182, 212, 0.3);
        }
        
        .forgot-password {
            text-align: center;
            margin-top: 1.5rem;
        }
        
        .forgot-password a {
            color: #06b6d4;
            text-decoration: none;
            font-size: 0.875rem;
            font-weight: 500;
            transition: color 0.2s ease-in-out;
        }
        
        .forgot-password a:hover {
            color: #0891b2;
            text-decoration: underline;
        }
        
        .forgot-password a:focus {
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
        
        .dental-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #06b6d4;
        }
        
        @media (max-width: 640px) {
            .login-container {
                padding: 2rem;
                margin: 1rem;
            }
            
            .login-header h1 {
                font-size: 1.875rem;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <div class="dental-icon">🦷</div>
            <h1>Dental Clinic</h1>
            <p>Professional Dental Care Management</p>
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
        </c:if>
        
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label for="email">Email Address:</label>
                <input type="email" id="email" name="email" required 
                       value="${param.email}" placeholder="Enter your email">
            </div>
            
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required 
                       placeholder="Enter your password">
            </div>
            
            <button type="submit" class="btn-login">Login</button>
        </form>
        
        <div class="forgot-password">
            <a href="${pageContext.request.contextPath}/forgotPassword">Forgot your password?</a>
        </div>
    </div>
</body>
</html>
