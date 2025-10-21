<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing Management - Dental Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .billing-section {
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
        .invoice-card {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            transition: all 0.3s ease;
        }
        .invoice-card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .status-badge {
            font-size: 0.8em;
            padding: 4px 8px;
            border-radius: 12px;
        }
        .status-pending { background-color: #fff3cd; color: #856404; }
        .status-paid { background-color: #d4edda; color: #155724; }
        .status-partial { background-color: #cce5ff; color: #004085; }
        .amount-display {
            font-size: 1.2em;
            font-weight: 600;
            color: #28a745;
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
                        <a class="nav-link text-white" href="queue.jsp">
                            <i class="fas fa-list-ol me-2"></i>Queue
                        </a>
                        <a class="nav-link text-white active" href="billing-management.jsp">
                            <i class="fas fa-file-invoice me-2"></i>Billing
                        </a>
                    </nav>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="fas fa-file-invoice me-2"></i>Billing Management</h2>
                    <div>
                        <button class="btn btn-success btn-custom" onclick="showCreateInvoiceModal()">
                            <i class="fas fa-plus me-2"></i>Create Invoice
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

                <!-- Completed Appointments Section -->
                <div class="billing-section">
                    <h5 class="section-title">
                        <i class="fas fa-check-circle me-2"></i>Completed Appointments (Ready for Billing)
                    </h5>
                    <c:if test="${empty completedAppointments}">
                        <div class="text-center text-muted py-4">
                            <i class="fas fa-calendar-check fa-3x mb-3"></i>
                            <p>No completed appointments today</p>
                        </div>
                    </c:if>
                    <c:if test="${not empty completedAppointments}">
                        <div class="row">
                            <c:forEach var="appointment" items="${completedAppointments}">
                                <div class="col-md-6 mb-3">
                                    <div class="invoice-card">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <h6 class="mb-1">${appointment.patient.fullName}</h6>
                                                <p class="text-muted mb-1">${appointment.service.name}</p>
                                                <small class="text-muted">
                                                    <i class="fas fa-user-md me-1"></i>${appointment.dentist.fullName}
                                                </small>
                                            </div>
                                            <div class="text-end">
                                                <div class="amount-display">$${appointment.service.price}</div>
                                                <button class="btn btn-sm btn-primary btn-custom mt-2" 
                                                        onclick="createInvoice(${appointment.appointmentId})">
                                                    <i class="fas fa-file-invoice me-1"></i>Create Invoice
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>

                <!-- Pending Invoices Section -->
                <div class="billing-section">
                    <h5 class="section-title">
                        <i class="fas fa-clock me-2"></i>Pending Invoices
                    </h5>
                    <c:if test="${empty pendingInvoices}">
                        <div class="text-center text-muted py-4">
                            <i class="fas fa-file-invoice fa-3x mb-3"></i>
                            <p>No pending invoices</p>
                        </div>
                    </c:if>
                    <c:if test="${not empty pendingInvoices}">
                        <div class="row">
                            <c:forEach var="invoice" items="${pendingInvoices}">
                                <div class="col-md-6 mb-3">
                                    <div class="invoice-card">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <h6 class="mb-1">Invoice #${invoice.invoiceId}</h6>
                                                <p class="text-muted mb-1">${invoice.patient.fullName}</p>
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${invoice.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </small>
                                            </div>
                                            <div class="text-end">
                                                <div class="amount-display">$${invoice.netAmount}</div>
                                                <span class="status-badge status-${invoice.status.toLowerCase()}">${invoice.status}</span>
                                                <div class="mt-2">
                                                    <button class="btn btn-sm btn-success btn-custom" 
                                                            onclick="showPaymentModal(${invoice.invoiceId}, ${invoice.netAmount})">
                                                        <i class="fas fa-credit-card me-1"></i>Pay
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

                <!-- Recent Payments Section -->
                <div class="billing-section">
                    <h5 class="section-title">
                        <i class="fas fa-receipt me-2"></i>Recent Payments
                    </h5>
                    <c:if test="${empty recentPayments}">
                        <div class="text-center text-muted py-4">
                            <i class="fas fa-receipt fa-3x mb-3"></i>
                            <p>No recent payments</p>
                        </div>
                    </c:if>
                    <c:if test="${not empty recentPayments}">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>Payment ID</th>
                                        <th>Invoice ID</th>
                                        <th>Amount</th>
                                        <th>Method</th>
                                        <th>Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="payment" items="${recentPayments}">
                                        <tr>
                                            <td>#${payment.paymentId}</td>
                                            <td>#${payment.invoiceId}</td>
                                            <td class="amount-display">$${payment.amount}</td>
                                            <td>
                                                <span class="badge bg-info">${payment.method}</span>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${payment.paidAtAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary me-1" 
                                                        onclick="printReceipt(${payment.paymentId})">
                                                    <i class="fas fa-print"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-success" 
                                                        onclick="emailReceipt(${payment.paymentId})">
                                                    <i class="fas fa-envelope"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Create Invoice Modal -->
    <div class="modal fade" id="createInvoiceModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Create Invoice</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="createInvoiceForm" method="post" action="billing-management">
                    <input type="hidden" name="action" value="createInvoice">
                    <input type="hidden" id="modalAppointmentId" name="appointmentId">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="discountAmount" class="form-label">Discount Amount (Optional)</label>
                            <input type="number" class="form-control" id="discountAmount" name="discountAmount" 
                                   step="0.01" min="0" placeholder="0.00">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Create Invoice</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Payment Modal -->
    <div class="modal fade" id="paymentModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Process Payment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="paymentForm" method="post" action="billing-management">
                    <input type="hidden" name="action" value="processPayment">
                    <input type="hidden" id="modalInvoiceId" name="invoiceId">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="paymentAmount" class="form-label">Payment Amount</label>
                            <input type="number" class="form-control" id="paymentAmount" name="amount" 
                                   step="0.01" min="0" required>
                        </div>
                        <div class="mb-3">
                            <label for="paymentMethod" class="form-label">Payment Method</label>
                            <select class="form-select" id="paymentMethod" name="method" required>
                                <option value="">Select Payment Method</option>
                                <option value="CASH">Cash</option>
                                <option value="CARD">Card</option>
                                <option value="TRANSFER">Bank Transfer</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">Process Payment</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Email Receipt Modal -->
    <div class="modal fade" id="emailReceiptModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Email Receipt</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="emailReceiptForm" method="post" action="billing-management">
                    <input type="hidden" name="action" value="emailReceipt">
                    <input type="hidden" id="modalPaymentId" name="paymentId">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="emailAddress" class="form-label">Email Address</label>
                            <input type="email" class="form-control" id="emailAddress" name="email" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">Send Receipt</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showCreateInvoiceModal() {
            // This would be called when creating invoice from scratch
            // For now, we'll show the completed appointments section
            document.querySelector('.billing-section').scrollIntoView({ behavior: 'smooth' });
        }
        
        function createInvoice(appointmentId) {
            document.getElementById('modalAppointmentId').value = appointmentId;
            const modal = new bootstrap.Modal(document.getElementById('createInvoiceModal'));
            modal.show();
        }
        
        function showPaymentModal(invoiceId, amount) {
            document.getElementById('modalInvoiceId').value = invoiceId;
            document.getElementById('paymentAmount').value = amount;
            document.getElementById('paymentAmount').max = amount;
            const modal = new bootstrap.Modal(document.getElementById('paymentModal'));
            modal.show();
        }
        
        function printReceipt(paymentId) {
            // Open receipt in new window for printing
            window.open('billing-management?action=printReceipt&paymentId=' + paymentId, '_blank');
        }
        
        function emailReceipt(paymentId) {
            document.getElementById('modalPaymentId').value = paymentId;
            const modal = new bootstrap.Modal(document.getElementById('emailReceiptModal'));
            modal.show();
        }
        
        // Auto-fill payment amount when modal opens
        document.getElementById('paymentModal').addEventListener('show.bs.modal', function (event) {
            const amount = document.getElementById('paymentAmount').value;
            if (amount) {
                document.getElementById('paymentAmount').value = amount;
            }
        });
    </script>
</body>
</html>
