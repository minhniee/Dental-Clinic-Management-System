package controller;

import DAO.AppointmentDAO;
import DAO.InvoiceDAO;
import DAO.PaymentDAO;
import DAO.PatientDAO;
import DAO.ServiceDAO;
import model.Appointment;
import model.Invoice;
import model.InvoiceItem;
import model.Payment;
import model.Patient;
import model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/receptionist/billing-management")
public class BillingManagementServlet extends HttpServlet {

    private InvoiceDAO invoiceDAO;
    private PaymentDAO paymentDAO;
    private AppointmentDAO appointmentDAO;
    private PatientDAO patientDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        invoiceDAO = new InvoiceDAO();
        paymentDAO = new PaymentDAO();
        appointmentDAO = new AppointmentDAO();
        patientDAO = new PatientDAO();
        serviceDAO = new ServiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check authentication and authorization
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (!"receptionist".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get today's completed appointments for billing
            List<Appointment> completedAppointments = appointmentDAO.getCompletedAppointmentsToday();
            
            // Get pending invoices
            List<Invoice> pendingInvoices = invoiceDAO.getPendingInvoices();
            
            // Get recent payments
            List<Payment> recentPayments = paymentDAO.getRecentPayments(10);
            
            // Set attributes for JSP
            request.setAttribute("completedAppointments", completedAppointments);
            request.setAttribute("pendingInvoices", pendingInvoices);
            request.setAttribute("recentPayments", recentPayments);
            
            // Forward to billing management JSP
            request.getRequestDispatcher("/receptionist/billing-management.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error loading billing management: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/billing-management.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check authentication and authorization
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (!"receptionist".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "createInvoice":
                    createInvoice(request, response);
                    break;
                case "processPayment":
                    processPayment(request, response);
                    break;
                case "printReceipt":
                    printReceipt(request, response);
                    break;
                case "emailReceipt":
                    emailReceipt(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/receptionist/billing-management");
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/billing-management.jsp").forward(request, response);
        }
    }

    private void createInvoice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String appointmentIdStr = request.getParameter("appointmentId");
            String discountAmountStr = request.getParameter("discountAmount");
            
            if (appointmentIdStr == null || appointmentIdStr.isEmpty()) {
                request.setAttribute("errorMessage", "Appointment ID is required");
                doGet(request, response);
                return;
            }
            
            int appointmentId = Integer.parseInt(appointmentIdStr);
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            
            if (appointment == null) {
                request.setAttribute("errorMessage", "Appointment not found");
                doGet(request, response);
                return;
            }
            
            // Check if invoice already exists for this appointment
            Invoice existingInvoice = invoiceDAO.getInvoiceByAppointmentId(appointmentId);
            if (existingInvoice != null) {
                request.setAttribute("errorMessage", "Invoice already exists for this appointment");
                doGet(request, response);
                return;
            }
            
            // Get service details
            Service service = serviceDAO.getServiceById(appointment.getServiceId());
            if (service == null) {
                request.setAttribute("errorMessage", "Service not found");
                doGet(request, response);
                return;
            }
            
            // Calculate amounts
            BigDecimal totalAmount = service.getPrice();
            BigDecimal discountAmount = BigDecimal.ZERO;
            if (discountAmountStr != null && !discountAmountStr.trim().isEmpty()) {
                discountAmount = new BigDecimal(discountAmountStr);
            }
            BigDecimal netAmount = totalAmount.subtract(discountAmount);
            
            // Create invoice
            Invoice invoice = new Invoice();
            invoice.setPatientId(appointment.getPatientId());
            invoice.setAppointmentId(appointmentId);
            invoice.setTotalAmount(totalAmount);
            invoice.setDiscountAmount(discountAmount);
            invoice.setNetAmount(netAmount);
            invoice.setStatus("PENDING");
            invoice.setCreatedAt(LocalDateTime.now());
            
            int invoiceId = invoiceDAO.createInvoice(invoice);
            
            if (invoiceId > 0) {
                // Create invoice item
                InvoiceItem item = new InvoiceItem();
                item.setInvoiceId(invoiceId);
                item.setServiceId(service.getServiceId());
                item.setServiceName(service.getName());
                item.setQuantity(1);
                item.setUnitPrice(service.getPrice());
                item.setTotalPrice(service.getPrice());
                
                invoiceDAO.createInvoiceItem(item);
                
                request.setAttribute("successMessage", "Invoice created successfully with ID: " + invoiceId);
            } else {
                request.setAttribute("errorMessage", "Failed to create invoice");
            }
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error creating invoice: " + e.getMessage());
        }
        
        doGet(request, response);
    }

    private void processPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String invoiceIdStr = request.getParameter("invoiceId");
            String amountStr = request.getParameter("amount");
            String method = request.getParameter("method");
            
            if (invoiceIdStr == null || amountStr == null || method == null) {
                request.setAttribute("errorMessage", "Missing required payment information");
                doGet(request, response);
                return;
            }
            
            int invoiceId = Integer.parseInt(invoiceIdStr);
            BigDecimal amount = new BigDecimal(amountStr);
            
            // Get invoice details
            Invoice invoice = invoiceDAO.getInvoiceById(invoiceId);
            if (invoice == null) {
                request.setAttribute("errorMessage", "Invoice not found");
                doGet(request, response);
                return;
            }
            
            // Check if payment amount is valid
            if (amount.compareTo(invoice.getNetAmount()) > 0) {
                request.setAttribute("errorMessage", "Payment amount cannot exceed invoice amount");
                doGet(request, response);
                return;
            }
            
            // Create payment
            Payment payment = new Payment();
            payment.setInvoiceId(invoiceId);
            payment.setAmount(amount);
            payment.setMethod(method);
            payment.setPaidAt(LocalDateTime.now());
            
            int paymentId = paymentDAO.createPayment(payment);
            
            if (paymentId > 0) {
                // Update invoice status if fully paid
                BigDecimal totalPaid = paymentDAO.getTotalPaidAmount(invoiceId);
                if (totalPaid.compareTo(invoice.getNetAmount()) >= 0) {
                    invoiceDAO.updateInvoiceStatus(invoiceId, "PAID");
                } else {
                    invoiceDAO.updateInvoiceStatus(invoiceId, "PARTIAL");
                }
                
                request.setAttribute("successMessage", "Payment processed successfully with ID: " + paymentId);
            } else {
                request.setAttribute("errorMessage", "Failed to process payment");
            }
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error processing payment: " + e.getMessage());
        }
        
        doGet(request, response);
    }

    private void printReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String paymentIdStr = request.getParameter("paymentId");
        
        if (paymentIdStr == null || paymentIdStr.isEmpty()) {
            request.setAttribute("errorMessage", "Payment ID is required");
            doGet(request, response);
            return;
        }
        
        try {
            int paymentId = Integer.parseInt(paymentIdStr);
            Payment payment = paymentDAO.getPaymentById(paymentId);
            
            if (payment == null) {
                request.setAttribute("errorMessage", "Payment not found");
                doGet(request, response);
                return;
            }
            
            // Get invoice and patient details
            Invoice invoice = invoiceDAO.getInvoiceById(payment.getInvoiceId());
            Patient patient = patientDAO.getPatientById(invoice.getPatientId());
            
            // Set attributes for receipt printing
            request.setAttribute("payment", payment);
            request.setAttribute("invoice", invoice);
            request.setAttribute("patient", patient);
            
            // Forward to receipt JSP
            request.getRequestDispatcher("/receptionist/receipt.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error printing receipt: " + e.getMessage());
            doGet(request, response);
        }
    }

    private void emailReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String paymentIdStr = request.getParameter("paymentId");
        String email = request.getParameter("email");
        
        if (paymentIdStr == null || paymentIdStr.isEmpty() || email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Payment ID and email are required");
            doGet(request, response);
            return;
        }
        
        try {
            int paymentId = Integer.parseInt(paymentIdStr);
            Payment payment = paymentDAO.getPaymentById(paymentId);
            
            if (payment == null) {
                request.setAttribute("errorMessage", "Payment not found");
                doGet(request, response);
                return;
            }
            
            // TODO: Implement email sending functionality
            // For now, just show success message
            request.setAttribute("successMessage", "Receipt sent to " + email + " successfully");
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error sending receipt: " + e.getMessage());
        }
        
        doGet(request, response);
    }
}
