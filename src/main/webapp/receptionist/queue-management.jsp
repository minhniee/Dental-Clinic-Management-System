<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Queue Management - Dental Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .queue-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .section-title {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #3498db;
        }
        .btn-custom {
            border-radius: 25px;
            padding: 8px 20px;
            font-weight: 500;
        }
        .alert-custom {
            border-radius: 10px;
            border: none;
        }
        .queue-item {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            transition: all 0.3s ease;
            position: relative;
        }
        .queue-item:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .queue-item.waiting {
            border-left: 4px solid #ffc107;
            background-color: #fff9e6;
        }
        .queue-item.called {
            border-left: 4px solid #17a2b8;
            background-color: #e6f7ff;
        }
        .queue-item.in-treatment {
            border-left: 4px solid #007bff;
            background-color: #e6f2ff;
        }
        .queue-item.completed {
            border-left: 4px solid #28a745;
            background-color: #e6f7e6;
        }
        .position-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #6c757d;
            color: white;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
        .status-badge {
            font-size: 0.8em;
            padding: 4px 8px;
            border-radius: 12px;
        }
        .status-waiting { background-color: #fff3cd; color: #856404; }
        .status-called { background-color: #cce5ff; color: #004085; }
        .status-in-treatment { background-color: #cce5ff; color: #004085; }
        .status-completed { background-color: #d4edda; color: #155724; }
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
        }
        .stats-number {
            font-size: 2.5em;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .stats-label {
            font-size: 0.9em;
            opacity: 0.9;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 bg-dark text-white min-vh-100 p-0">
                <div class="p-3">
                    <h4 class="text-center mb-4">Dental Clinic</h4>
                    <nav class="nav flex-column">
                        <a class="nav-link text-white" href="dashboard.jsp">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                        <a class="nav-link text-white" href="appointment-management.jsp">
                            <i class="fas fa-calendar-plus me-2"></i>Appointments
                        </a>
                        <a class="nav-link text-white" href="patients.jsp">
                            <i class="fas fa-users me-2"></i>Patients
                        </a>
                        <a class="nav-link text-white active" href="queue-management.jsp">
                            <i class="fas fa-list-ol me-2"></i>Queue
                        </a>
                        <a class="nav-link text-white" href="billing-management.jsp">
                            <i class="fas fa-file-invoice me-2"></i>Billing
                        </a>
                    </nav>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="fas fa-list-ol me-2"></i>Queue Management</h2>
                    <div>
                        <button class="btn btn-primary btn-custom" onclick="showAddToQueueModal()">
                            <i class="fas fa-plus me-2"></i>Add to Queue
                        </button>
                    </div>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-custom alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-custom alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Queue Statistics -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="stats-card">
                            <div class="stats-number">${queueStats.waitingCount}</div>
                            <div class="stats-label">Waiting</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card">
                            <div class="stats-number">${queueStats.calledCount}</div>
                            <div class="stats-label">Called</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card">
                            <div class="stats-number">${queueStats.inTreatmentCount}</div>
                            <div class="stats-label">In Treatment</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card">
                            <div class="stats-number">${queueStats.completedCount}</div>
                            <div class="stats-label">Completed</div>
                        </div>
                    </div>
                </div>

                <!-- Current Queue -->
                <div class="queue-section">
                    <h5 class="section-title">
                        <i class="fas fa-list me-2"></i>Current Queue
                    </h5>
                    <c:if test="${empty todayQueue}">
                        <div class="text-center text-muted py-4">
                            <i class="fas fa-list fa-3x mb-3"></i>
                            <p>No patients in queue today</p>
                        </div>
                    </c:if>
                    <c:if test="${not empty todayQueue}">
                        <div class="row">
                            <c:forEach var="queueItem" items="${todayQueue}">
                                <div class="col-md-6 mb-3">
                                    <div class="queue-item ${queueItem.status.toLowerCase().replace('_', '-')}">
                                        <div class="position-badge">${queueItem.positionInQueue}</div>
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <h6 class="mb-1">${queueItem.appointment.patient.fullName}</h6>
                                                <p class="text-muted mb-1">${queueItem.appointment.service.name}</p>
                                                <small class="text-muted">
                                                    <i class="fas fa-user-md me-1"></i>${queueItem.appointment.dentist.fullName}
                                                </small>
                                                <div class="mt-2">
                                                    <span class="status-badge status-${queueItem.status.toLowerCase().replace('_', '-')}">
                                                        ${queueItem.status}
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="text-end">
                                                <div class="btn-group-vertical" role="group">
                                                    <c:if test="${queueItem.status == 'WAITING'}">
                                                        <button class="btn btn-sm btn-info btn-custom mb-1" 
                                                                onclick="updateStatus(${queueItem.queueId}, 'CALLED')">
                                                            <i class="fas fa-phone me-1"></i>Call
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${queueItem.status == 'CALLED'}">
                                                        <button class="btn btn-sm btn-primary btn-custom mb-1" 
                                                                onclick="updateStatus(${queueItem.queueId}, 'IN_TREATMENT')">
                                                            <i class="fas fa-user-md me-1"></i>Start Treatment
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${queueItem.status == 'IN_TREATMENT'}">
                                                        <button class="btn btn-sm btn-success btn-custom mb-1" 
                                                                onclick="updateStatus(${queueItem.queueId}, 'COMPLETED')">
                                                            <i class="fas fa-check me-1"></i>Complete
                                                        </button>
                                                    </c:if>
                                                    <button class="btn btn-sm btn-outline-danger" 
                                                            onclick="removeFromQueue(${queueItem.queueId})">
                                                        <i class="fas fa-times me-1"></i>Remove
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Add to Queue Modal -->
    <div class="modal fade" id="addToQueueModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add Patient to Queue</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="addToQueueForm" method="post" action="queue-management">
                    <input type="hidden" name="action" value="addToQueue">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="appointmentId" class="form-label">Appointment ID</label>
                            <input type="number" class="form-control" id="appointmentId" name="appointmentId" 
                                   required placeholder="Enter appointment ID">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add to Queue</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showAddToQueueModal() {
            const modal = new bootstrap.Modal(document.getElementById('addToQueueModal'));
            modal.show();
        }
        
        function updateStatus(queueId, status) {
            if (confirm('Are you sure you want to update the queue status?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'queue-management';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'updateStatus';
                form.appendChild(actionInput);
                
                const queueIdInput = document.createElement('input');
                queueIdInput.type = 'hidden';
                queueIdInput.name = 'queueId';
                queueIdInput.value = queueId;
                form.appendChild(queueIdInput);
                
                const statusInput = document.createElement('input');
                statusInput.type = 'hidden';
                statusInput.name = 'status';
                statusInput.value = status;
                form.appendChild(statusInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function removeFromQueue(queueId) {
            if (confirm('Are you sure you want to remove this patient from the queue?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'queue-management';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'removeFromQueue';
                form.appendChild(actionInput);
                
                const queueIdInput = document.createElement('input');
                queueIdInput.type = 'hidden';
                queueIdInput.name = 'queueId';
                queueIdInput.value = queueId;
                form.appendChild(queueIdInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Auto-refresh queue every 30 seconds
        setInterval(function() {
            location.reload();
        }, 30000);
    </script>
</body>
</html>
