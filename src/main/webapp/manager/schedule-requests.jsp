<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phê Duyệt Yêu Cầu Nghỉ - Hệ Thống Quản Lý Phòng Khám Nha Khoa</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .requests-table { background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1); margin-top: 20px; }
        .requests-table table { width: 100%; border-collapse: collapse; }
        .requests-table th { background: #f8f9fa; color: #495057; padding: 15px; text-align: left; font-weight: 600; font-size: 14px; border-bottom: 2px solid #e9ecef; }
        .requests-table td { padding: 15px; border-bottom: 1px solid #e9ecef; font-size: 14px; color: #495057; }
        .requests-table tr:hover { background: #f8f9fa; }
        .requests-table tr:last-child td { border-bottom: none; }
        .status-badge { padding: 4px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 500; }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-approved { background: #d4edda; color: #155724; }
        .status-rejected { background: #f8d7da; color: #721c24; }
        .action-buttons { display: flex; gap: 8px; }
        .btn-action { padding: 6px 12px; border: none; border-radius: 4px; cursor: pointer; font-size: 0.8rem; text-decoration: none; display: inline-block; }
        .btn-approve { background: #28a745; color: white; }
        .btn-reject { background: #dc3545; color: white; }
        .btn-view { background: #667eea; color: white; }
        .btn-action:hover { opacity: 0.9; }
        .stats-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); text-align: center; }
        .stat-value { font-size: 2rem; font-weight: 700; color: #667eea; margin-bottom: 5px; }
        .stat-label { color: #7f8c8d; font-size: 0.9rem; }
        .filter-section { background: white; padding: 20px; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .filter-buttons { display: flex; gap: 10px; margin-top: 15px; }
        .filter-btn { padding: 8px 16px; border: 1px solid #dee2e6; background: white; border-radius: 6px; cursor: pointer; text-decoration: none; color: #495057; }
        .filter-btn.active { background: #667eea; color: white; border-color: #667eea; }
        .filter-btn:hover { background: #f8f9fa; }
        .filter-btn.active:hover { background: #667eea; }
        .modal { position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); }
        .modal-content { background-color: white; margin: 10% auto; padding: 20px; border-radius: 12px; width: 80%; max-width: 600px; }
        .close { color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer; }
        .close:hover { color: black; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 600; color: #2c3e50; }
        .form-group input, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; }
        .form-actions { display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px; }
        .btn-secondary { background: #6c757d; color: white; padding: 10px 20px; border: none; border-radius: 6px; cursor: pointer; }
    </style>
</head>
<body>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="/login"/>
</c:if>

<c:set var="_role" value="${empty sessionScope.user or empty sessionScope.user.role or empty sessionScope.user.role.roleName ? '' : fn:toLowerCase(fn:replace(sessionScope.user.role.roleName, ' ', ''))}"/>
<c:if test="${_role ne 'clinicmanager'}">
    <c:redirect url="${pageContext.request.contextPath}/login"/>
</c:if>

<div class="header">
    <h1>🦷 Phê Duyệt Yêu Cầu Nghỉ</h1>
    <div class="user-info">
        <span>Chào mừng, ${sessionScope.user.fullName}</span>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng Xuất</a>
    </div>
</div>

<div class="dashboard-layout">
    <jsp:include page="/shared/left-navbar.jsp"/>
    <main class="dashboard-content">
        <div class="container">
            <div class="welcome-section">
                <h2>📋 Phê Duyệt Yêu Cầu Nghỉ</h2>
                <p>Xem và phê duyệt các yêu cầu nghỉ của nhân viên</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    ❌ ${error}
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    ✅ ${success}
                </div>
            </c:if>

            <!-- Statistics Cards -->
            <div class="stats-cards">
                <div class="stat-card">
                    <div class="stat-value">${pendingCount}</div>
                    <div class="stat-label">Chờ Duyệt</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${approvedCount}</div>
                    <div class="stat-label">Đã Duyệt</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${rejectedCount}</div>
                    <div class="stat-label">Từ Chối</div>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <h3>🔍 Lọc Theo Trạng Thái</h3>
                <div class="filter-buttons">
                    <a href="${pageContext.request.contextPath}/manager/schedule-requests" 
                       class="filter-btn ${empty filterStatus ? 'active' : ''}">Tất Cả</a>
                    <a href="${pageContext.request.contextPath}/manager/schedule-requests?action=pending" 
                       class="filter-btn ${filterStatus eq 'PENDING' ? 'active' : ''}">Chờ Duyệt</a>
                    <a href="${pageContext.request.contextPath}/manager/schedule-requests?action=approved" 
                       class="filter-btn ${filterStatus eq 'APPROVED' ? 'active' : ''}">Đã Duyệt</a>
                    <a href="${pageContext.request.contextPath}/manager/schedule-requests?action=rejected" 
                       class="filter-btn ${filterStatus eq 'REJECTED' ? 'active' : ''}">Từ Chối</a>
                </div>
            </div>

            <!-- Requests Table -->
            <div class="requests-table">
                <table>
                    <thead>
                        <tr>
                            <th>Nhân Viên</th>
                            <th>Ngày Nghỉ</th>
                            <th>Ca Làm Việc</th>
                            <th>Lý Do</th>
                            <th>Trạng Thái</th>
                            <th>Ngày Tạo</th>
                            <th>Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="request" items="${requests}">
                            <tr>
                                <td>
                                    <strong>${request.employeeName}</strong>
                                </td>
                                <td>
                                    <fmt:formatDate value="${request.date}" pattern="dd/MM/yyyy"/>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${request.shift eq 'Morning'}">🌅 Sáng</c:when>
                                        <c:when test="${request.shift eq 'Afternoon'}">🌆 Chiều</c:when>
                                        <c:when test="${request.shift eq 'FullDay'}">🌞 Cả ngày</c:when>
                                        <c:otherwise>${request.shift}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span title="${request.reason}">
                                        ${fn:length(request.reason) > 30 ? fn:substring(request.reason, 0, 30) : request.reason}${fn:length(request.reason) > 30 ? '...' : ''}
                                    </span>
                                </td>
                                <td>
                                    <span class="status-badge 
                                        <c:choose>
                                            <c:when test="${request.status eq 'PENDING'}">status-pending</c:when>
                                            <c:when test="${request.status eq 'APPROVED'}">status-approved</c:when>
                                            <c:when test="${request.status eq 'REJECTED'}">status-rejected</c:when>
                                        </c:choose>">
                                        <c:choose>
                                            <c:when test="${request.status eq 'PENDING'}">⏳ Chờ duyệt</c:when>
                                            <c:when test="${request.status eq 'APPROVED'}">✅ Đã duyệt</c:when>
                                            <c:when test="${request.status eq 'REJECTED'}">❌ Từ chối</c:when>
                                            <c:otherwise>${request.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <fmt:formatDate value="${request.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/manager/schedule-requests?action=view&id=${request.requestId}" 
                                           class="btn-action btn-view">👁️ Xem</a>
                                        <c:if test="${request.status eq 'PENDING'}">
                                            <button onclick="showApproveModal(${request.requestId}, '${request.employeeName}')" 
                                                    class="btn-action btn-approve">✅ Duyệt</button>
                                            <button onclick="showRejectModal(${request.requestId}, '${request.employeeName}')" 
                                                    class="btn-action btn-reject">❌ Từ chối</button>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${empty requests}">
                <div class="no-data">
                    <h3>📭 Không có yêu cầu nào</h3>
                    <p>Chưa có yêu cầu nghỉ nào được tìm thấy.</p>
                </div>
            </c:if>
        </div>
    </main>
</div>

<!-- Approve Modal -->
<div id="approveModal" class="modal" style="display: none;">
    <div class="modal-content">
        <span class="close">&times;</span>
        <h3>✅ Phê Duyệt Yêu Cầu Nghỉ</h3>
        <form id="approveForm" method="post" action="${pageContext.request.contextPath}/manager/schedule-requests">
            <input type="hidden" name="action" value="approve">
            <input type="hidden" name="requestId" id="approveRequestId">
            
            <div class="form-group">
                <label>Nhân viên:</label>
                <input type="text" id="approveEmployeeName" readonly>
            </div>
            
            <div class="form-group">
                <label>Ghi chú của quản lý:</label>
                <textarea name="managerNotes" rows="3" placeholder="Ghi chú về việc phê duyệt..."></textarea>
            </div>
            
            <div class="form-actions">
                <button type="submit" class="btn-approve">✅ Phê Duyệt</button>
                <button type="button" class="btn-secondary" onclick="closeModal('approveModal')">Hủy</button>
            </div>
        </form>
    </div>
</div>

<!-- Reject Modal -->
<div id="rejectModal" class="modal" style="display: none;">
    <div class="modal-content">
        <span class="close">&times;</span>
        <h3>❌ Từ Chối Yêu Cầu Nghỉ</h3>
        <form id="rejectForm" method="post" action="${pageContext.request.contextPath}/manager/schedule-requests">
            <input type="hidden" name="action" value="reject">
            <input type="hidden" name="requestId" id="rejectRequestId">
            
            <div class="form-group">
                <label>Nhân viên:</label>
                <input type="text" id="rejectEmployeeName" readonly>
            </div>
            
            <div class="form-group">
                <label>Lý do từ chối:</label>
                <textarea name="managerNotes" rows="3" placeholder="Lý do từ chối yêu cầu..." required></textarea>
            </div>
            
            <div class="form-actions">
                <button type="submit" class="btn-reject">❌ Từ Chối</button>
                <button type="button" class="btn-secondary" onclick="closeModal('rejectModal')">Hủy</button>
            </div>
        </form>
    </div>
</div>

<style>
    .alert { padding: 15px; margin-bottom: 20px; border-radius: 4px; font-weight: 500; }
    .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
    .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    .no-data { text-align: center; padding: 40px; color: #7f8c8d; }
</style>

<script>
function showApproveModal(requestId, employeeName) {
    document.getElementById('approveRequestId').value = requestId;
    document.getElementById('approveEmployeeName').value = employeeName;
    document.getElementById('approveModal').style.display = 'block';
}

function showRejectModal(requestId, employeeName) {
    document.getElementById('rejectRequestId').value = requestId;
    document.getElementById('rejectEmployeeName').value = employeeName;
    document.getElementById('rejectModal').style.display = 'block';
}

function closeModal(modalId) {
    document.getElementById(modalId).style.display = 'none';
}

// Close modal when clicking outside
window.onclick = function(event) {
    if (event.target.classList.contains('modal')) {
        event.target.style.display = 'none';
    }
}

// Close modal when clicking X
document.querySelectorAll('.close').forEach(function(closeBtn) {
    closeBtn.onclick = function() {
        this.closest('.modal').style.display = 'none';
    }
});
</script>
</body>
</html>
