<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Bệnh Nhân - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .search-container {
            background: #ffffff;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }

        .search-form {
            display: flex;
            gap: 1rem;
            align-items: end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            flex: 1;
        }

        .form-group label {
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }

        .form-control {
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

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
        }

        .patients-table {
            background: #ffffff;
            border-radius: 0.75rem;
            overflow: hidden;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table thead {
            background-color: #f8fafc;
        }

        .table th,
        .table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }

        .table th {
            font-weight: 600;
            color: #0f172a;
            font-size: 0.875rem;
        }

        .table td {
            color: #475569;
            font-size: 0.875rem;
        }

        .table tbody tr:hover {
            background-color: #f8fafc;
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            margin-top: 2rem;
        }

        .pagination a,
        .pagination span {
            padding: 0.5rem 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 0.375rem;
            color: #475569;
            text-decoration: none;
            font-size: 0.875rem;
        }

        .pagination a:hover {
            background-color: #f3f4f6;
        }

        .pagination .current {
            background-color: #06b6d4;
            color: #ffffff;
            border-color: #06b6d4;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .status-badge.active {
            background-color: #dcfce7;
            color: #16a34a;
        }

        .alert {
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
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

        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: #64748b;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #94a3b8;
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
    
    <div class="header">
        <h1>🦷 Quản Lý Bệnh Nhân</h1>
        <div class="user-info">
            <span>Chào mừng, ${sessionScope.user.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
        </div>
    </div>

    <div class="dashboard-layout">
        <jsp:include page="/shared/left-navbar.jsp"/>
        <main class="dashboard-content">
            <div class="container">
                
                <!-- Alert Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle" style="margin-right: 0.5rem;"></i>
                        ${successMessage}
                    </div>
                </c:if>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-triangle" style="margin-right: 0.5rem;"></i>
                        ${errorMessage}
                    </div>
                </c:if>

                <!-- Search and Add Section -->
                <div class="search-container">
                    <div class="search-form">
                        <div class="form-group" style="flex: 2;">
                            <label for="search">Tìm Kiếm Bệnh Nhân</label>
                            <form method="GET" action="${pageContext.request.contextPath}/receptionist/patients">
                                <input type="hidden" name="action" value="search">
                                <input type="text" 
                                       id="search" 
                                       name="search" 
                                       class="form-control" 
                                       placeholder="Tìm theo tên, số điện thoại hoặc email..."
                                       value="${searchTerm}">
                            </form>
                        </div>
                        <div style="display: flex; gap: 0.5rem;">
                            <button type="submit" form="searchForm" class="btn btn-secondary">
                                <i class="fas fa-search"></i> Tìm Kiếm
                            </button>
                            <a href="${pageContext.request.contextPath}/receptionist/patients?action=new" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Thêm Bệnh Nhân
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Patients Table -->
                <div class="patients-table">
                    <c:choose>
                        <c:when test="${not empty patients}">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Họ và Tên</th>
                                        <th>Ngày Sinh</th>
                                        <th>Giới Tính</th>
                                        <th>Số Điện Thoại</th>
                                        <th>Email</th>
                                        <th>Địa Chỉ</th>
                                        <th>Ngày Tạo</th>
                                        <th>Thao Tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="patient" items="${patients}">
                                        <tr>
                                            <td><strong>#${patient.patientId}</strong></td>
                                            <td>
                                                <strong style="color: #0f172a;">${patient.fullName}</strong>
                                            </td>
                                            <td>
                                                <c:if test="${not empty patient.birthDateAsDate}">
                                                    <fmt:formatDate value="${patient.birthDateAsDate}" pattern="dd/MM/yyyy"/>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${patient.gender eq 'M'}">Nam</c:when>
                                                    <c:when test="${patient.gender eq 'F'}">Nữ</c:when>
                                                    <c:otherwise>Khác</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:if test="${not empty patient.phone}">
                                                    <a href="tel:${patient.phone}" style="color: #06b6d4; text-decoration: none;">
                                                        <i class="fas fa-phone" style="margin-right: 0.25rem;"></i>${patient.phone}
                                                    </a>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${not empty patient.email}">
                                                    <a href="mailto:${patient.email}" style="color: #06b6d4; text-decoration: none;">
                                                        ${patient.email}
                                                    </a>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${not empty patient.address}">
                                                    <span title="${patient.address}">
                                                        <c:choose>
                                                            <c:when test="${fn:length(patient.address) > 30}">
                                                                ${fn:substring(patient.address, 0, 30)}...
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${patient.address}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${not empty patient.createdAtAsDate}">
                                                    <fmt:formatDate value="${patient.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </c:if>
                                            </td>
                                            <td>
                                                <div style="display: flex; gap: 0.5rem;">
                                                    <a href="${pageContext.request.contextPath}/receptionist/patients?action=view&id=${patient.patientId}" 
                                                       class="btn btn-secondary btn-sm">
                                                        <i class="fas fa-eye"></i>
                                                        Thông tin
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/receptionist/patients?action=edit&id=${patient.patientId}" 
                                                       class="btn btn-primary btn-sm">
                                                        <i class="fas fa-edit"></i>
                                                        Cập nhật
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-users"></i>
                                <h3>Không Tìm Thấy Bệnh Nhân</h3>
                                <p>Có vẻ như chưa có bệnh nhân nào được đăng ký.</p>
                                <a href="${pageContext.request.contextPath}/receptionist/patients?action=new" class="btn btn-primary">
                                    <i class="fas fa-plus"></i> Thêm Bệnh Nhân Đầu Tiên
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <c:if test="${currentPage > 1}">
                            <a href="${pageContext.request.contextPath}/receptionist/patients?page=${currentPage - 1}${not empty searchTerm ? '&search=' : ''}${not empty searchTerm ? searchTerm : ''}">
                                <i class="fas fa-chevron-left"></i> Trước
                            </a>
                        </c:if>
                        
                        <c:forEach begin="1" end="${totalPages}" var="pageNum">
                            <c:choose>
                                <c:when test="${pageNum == currentPage}">
                                    <span class="current">${pageNum}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/receptionist/patients?page=${pageNum}${not empty searchTerm ? '&search=' : ''}${not empty searchTerm ? searchTerm : ''}">
                                        ${pageNum}
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        
                        <c:if test="${currentPage < totalPages}">
                            <a href="${pageContext.request.contextPath}/receptionist/patients?page=${currentPage + 1}${not empty searchTerm ? '&search=' : ''}${not empty searchTerm ? searchTerm : ''}">
                                Sau <i class="fas fa-chevron-right"></i>
                            </a>
                        </c:if>
                    </div>
                </c:if>

                <!-- Summary -->
                <c:if test="${not empty patients}">
                    <div style="text-align: center; margin-top: 2rem; color: #64748b; font-size: 0.875rem;">
                        Hiển thị ${fn:length(patients)} trong tổng số ${totalCount} bệnh nhân
                    </div>
                </c:if>

            </div>
        </main>
    </div>

    <script>
        // Auto-submit search form on Enter
        document.getElementById('search').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                this.form.submit();
            }
        });
    </script>
</body>
</html>
