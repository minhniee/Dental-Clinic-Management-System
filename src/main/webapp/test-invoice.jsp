<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Invoice System</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .section { margin-bottom: 30px; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
        .section h2 { color: #333; margin-top: 0; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #f2f2f2; }
        .btn { padding: 8px 16px; background-color: #007bff; color: white; text-decoration: none; border-radius: 4px; }
        .btn:hover { background-color: #0056b3; }
        .status-completed { color: green; font-weight: bold; }
        .status-unpaid { color: red; font-weight: bold; }
        .status-paid { color: green; font-weight: bold; }
    </style>
</head>
<body>
    <h1>🧪 Test Invoice System</h1>
    
    <!-- Completed Appointments Section -->
    <div class="section">
        <h2>📅 Completed Appointments (Ready for Invoice)</h2>
        <c:choose>
            <c:when test="${not empty completedAppointments}">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Patient</th>
                            <th>Dentist</th>
                            <th>Service</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="appointment" items="${completedAppointments}">
                            <tr>
                                <td>#${appointment.appointmentId}</td>
                                <td>${appointment.patient.fullName}</td>
                                <td>${appointment.dentist.fullName}</td>
                                <td>${appointment.service.name}</td>
                                <td><fmt:formatDate value="${appointment.appointmentDateAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td class="status-completed">${appointment.status}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/receptionist/invoices?action=create_from_appointment&appointmentId=${appointment.appointmentId}" 
                                       class="btn">Create Invoice</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p>No completed appointments found.</p>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- Services Section -->
    <div class="section">
        <h2>🛠️ Available Services</h2>
        <c:choose>
            <c:when test="${not empty services}">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Price</th>
                            <th>Duration</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="service" items="${services}">
                            <tr>
                                <td>#${service.serviceId}</td>
                                <td>${service.name}</td>
                                <td><fmt:formatNumber value="${service.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                <td>${service.durationMinutes} minutes</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p>No services found.</p>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- Recent Invoices Section -->
    <div class="section">
        <h2>📄 Recent Invoices</h2>
        <c:choose>
            <c:when test="${not empty recentInvoices}">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Patient</th>
                            <th>Appointment</th>
                            <th>Total Amount</th>
                            <th>Status</th>
                            <th>Created</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="invoice" items="${recentInvoices}">
                            <tr>
                                <td>#${invoice.invoiceId}</td>
                                <td>${invoice.patient.fullName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty invoice.appointment}">
                                            #${invoice.appointment.appointmentId}
                                        </c:when>
                                        <c:otherwise>
                                            N/A
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatNumber value="${invoice.netAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${invoice.status eq 'PAID'}">
                                            <span class="status-paid">${invoice.status}</span>
                                        </c:when>
                                        <c:when test="${invoice.status eq 'UNPAID'}">
                                            <span class="status-unpaid">${invoice.status}</span>
                                        </c:when>
                                        <c:otherwise>
                                            ${invoice.status}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${invoice.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/receptionist/invoices?action=view&id=${invoice.invoiceId}" 
                                       class="btn">View Details</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p>No invoices found.</p>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- Quick Actions -->
    <div class="section">
        <h2>⚡ Quick Actions</h2>
        <p>
            <a href="${pageContext.request.contextPath}/receptionist/invoices?action=new" class="btn">Create New Invoice</a>
            <a href="${pageContext.request.contextPath}/receptionist/invoices" class="btn">View All Invoices</a>
            <a href="${pageContext.request.contextPath}/receptionist/appointments" class="btn">View Appointments</a>
        </p>
    </div>
</body>
</html>
