package controller;

import DAO.InvoiceDAO;
import DAO.PaymentDAO;
import DAO.PatientMDAO;
import DAO.AppointmentDAO;
import DAO.ServiceDAO;
import model.Invoice;
import model.InvoiceItem;
import model.Payment;
import model.Patient;
import model.Appointment;
import model.Service;
import model.User;

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

@WebServlet("/receptionist/invoices")
public class InvoiceServlet extends HttpServlet {

    private InvoiceDAO invoiceDAO;
    private PaymentDAO paymentDAO;
    private PatientMDAO PatientMDAO;
    private AppointmentDAO appointmentDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        invoiceDAO = new InvoiceDAO();
        paymentDAO = new PaymentDAO();
        PatientMDAO = new PatientMDAO();
        appointmentDAO = new AppointmentDAO();
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

        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "list") {
                case "list":
                    handleListInvoices(request, response);
                    break;
                case "view":
                    handleViewInvoice(request, response);
                    break;
                case "new":
                    handleNewInvoice(request, response);
                    break;
                case "create_from_appointment":
                    handleCreateFromAppointment(request, response);
                    break;
                default:
                    handleListInvoices(request, response);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            handleListInvoices(request, response);
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
            switch (action != null ? action : "create") {
                case "create":
                    handleCreateInvoice(request, response);
                    break;
                case "addPayment":
                    handleAddPayment(request, response);
                    break;
                default:
                    request.setAttribute("errorMessage", "Invalid action");
                    handleListInvoices(request, response);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/invoices.jsp").forward(request, response);
        }
    }

    private void handleListInvoices(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String patientIdParam = request.getParameter("patientId");
        String statusParam = request.getParameter("status");
        
        List<Invoice> invoices;
        
        if (patientIdParam != null && !patientIdParam.trim().isEmpty()) {
            try {
                int patientId = Integer.parseInt(patientIdParam);
                invoices = invoiceDAO.getInvoicesByPatient(patientId);
            } catch (NumberFormatException e) {
                invoices = invoiceDAO.getRecentInvoices(50);
            }
        } else {
            invoices = invoiceDAO.getRecentInvoices(50);
        }
        
        // Filter by status if specified
        if (statusParam != null && !statusParam.trim().isEmpty()) {
            invoices.removeIf(invoice -> !statusParam.equalsIgnoreCase(invoice.getStatus()));
        }
        
        request.setAttribute("invoices", invoices);
        request.getRequestDispatcher("/receptionist/invoices.jsp").forward(request, response);
    }

    private void handleViewInvoice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String invoiceIdParam = request.getParameter("id");
        if (invoiceIdParam == null || invoiceIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "Invoice ID is required");
            handleListInvoices(request, response);
            return;
        }
        
        try {
            int invoiceId = Integer.parseInt(invoiceIdParam);
            Invoice invoice = invoiceDAO.getInvoiceById(invoiceId);
            
            if (invoice == null) {
                request.setAttribute("errorMessage", "Invoice not found");
                handleListInvoices(request, response);
                return;
            }
            
            // Get payments for this invoice
            List<Payment> payments = paymentDAO.getPaymentsByInvoice(invoiceId);
            BigDecimal totalPaid = paymentDAO.getTotalPaidAmount(invoiceId);
            
            request.setAttribute("invoice", invoice);
            request.setAttribute("payments", payments);
            request.setAttribute("totalPaid", totalPaid);
            
            request.getRequestDispatcher("/receptionist/invoice-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid invoice ID");
            handleListInvoices(request, response);
        }
    }

    private void handleNewInvoice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Load data for the form
        List<Patient> patients = PatientMDAO.getAllPatients(0, 1000);
        List<Service> services = serviceDAO.getAllActiveServices();
        
        // Check if patient ID is provided for quick invoice creation
        String patientIdParam = request.getParameter("patientId");
        Patient selectedPatient = null;
        if (patientIdParam != null && !patientIdParam.trim().isEmpty()) {
            try {
                int patientId = Integer.parseInt(patientIdParam);
                selectedPatient = PatientMDAO.getPatientById(patientId);
            } catch (NumberFormatException e) {
                // Ignore invalid patient ID
            }
        }

        // Check if appointment ID is provided for quick invoice creation
        String appointmentIdParam = request.getParameter("appointmentId");
        Appointment appointment = null;
        if (appointmentIdParam != null && !appointmentIdParam.trim().isEmpty()) {
            try {
                int appointmentId = Integer.parseInt(appointmentIdParam);
                appointment = appointmentDAO.getAppointmentById(appointmentId);
                if (appointment != null) {
                    request.setAttribute("selectedAppointment", appointment);
                    request.setAttribute("selectedPatient", appointment.getPatient());
                }
            } catch (NumberFormatException e) {
                // Ignore invalid appointment ID
            }
        } else if (selectedPatient != null) {
            request.setAttribute("selectedPatient", selectedPatient);
        }
        
        request.setAttribute("patients", patients);
        request.setAttribute("services", services);
        request.getRequestDispatcher("/receptionist/create-invoice.jsp").forward(request, response);
    }

    private void handleCreateFromAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String appointmentIdParam = request.getParameter("appointmentId");
        if (appointmentIdParam == null || appointmentIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Appointment ID is required");
            handleListInvoices(request, response);
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(appointmentIdParam);
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            
            if (appointment == null) {
                request.setAttribute("errorMessage", "Appointment not found");
                handleListInvoices(request, response);
                return;
            }
            
            // Check if appointment is completed
            if (!"COMPLETED".equals(appointment.getStatus())) {
                request.setAttribute("errorMessage", "Appointment must be completed before creating invoice");
                handleListInvoices(request, response);
                return;
            }
            
            // Check if invoice already exists for this appointment
            Invoice existingInvoice = invoiceDAO.getInvoiceByAppointment(appointmentId);
            if (existingInvoice != null) {
                request.setAttribute("errorMessage", "Invoice already exists for this appointment");
                response.sendRedirect(request.getContextPath() + "/receptionist/invoices?action=view&id=" + existingInvoice.getInvoiceId());
                return;
            }
            
            // Create invoice automatically with service from appointment
            Invoice invoice = new Invoice();
            invoice.setPatientId(appointment.getPatientId());
            invoice.setAppointmentId(appointmentId);
            invoice.setStatus("UNPAID");
            invoice.setCreatedAt(LocalDateTime.now());
            
            int invoiceId = invoiceDAO.createInvoice(invoice);
            
            if (invoiceId > 0) {
                // Add service item from appointment
                Service service = serviceDAO.getServiceById(appointment.getServiceId());
                if (service != null) {
                    InvoiceItem item = new InvoiceItem();
                    item.setInvoiceId(invoiceId);
                    item.setServiceId(service.getServiceId());
                    item.setQuantity(1);
                    item.setUnitPrice(service.getPrice());
                    item.setTotalPrice(service.getPrice());
                    
                    invoiceDAO.addInvoiceItem(invoiceId, item);
                    
                    // Update invoice amounts
                    invoiceDAO.updateInvoiceAmounts(invoiceId, service.getPrice(), BigDecimal.ZERO);
                }
                
                request.setAttribute("successMessage", "Invoice created automatically from appointment");
                response.sendRedirect(request.getContextPath() + "/receptionist/invoices?action=view&id=" + invoiceId);
            } else {
                request.setAttribute("errorMessage", "Failed to create invoice from appointment");
                handleListInvoices(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid appointment ID");
            handleListInvoices(request, response);
        }
    }

    private void handleCreateInvoice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get form parameters
        String patientIdParam = request.getParameter("patientId");
        String appointmentIdParam = request.getParameter("appointmentId");
        String discountAmountParam = request.getParameter("discountAmount");
        
        // Validate required fields
        if (patientIdParam == null || patientIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Patient is required");
            handleNewInvoice(request, response);
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdParam);
            Integer appointmentId = null;
            if (appointmentIdParam != null && !appointmentIdParam.trim().isEmpty()) {
                appointmentId = Integer.parseInt(appointmentIdParam);
            }
            
            BigDecimal discountAmount = BigDecimal.ZERO;
            if (discountAmountParam != null && !discountAmountParam.trim().isEmpty()) {
                discountAmount = new BigDecimal(discountAmountParam);
            }
            
            // Create invoice
            Invoice invoice = new Invoice();
            invoice.setPatientId(patientId);
            invoice.setAppointmentId(appointmentId);
            invoice.setTotalAmount(BigDecimal.ZERO); // Will be calculated from items
            invoice.setDiscountAmount(discountAmount);
            invoice.setStatus("UNPAID");
            invoice.setCreatedAt(LocalDateTime.now());
            
            int invoiceId = invoiceDAO.createInvoice(invoice);
            
            if (invoiceId > 0) {
                // Add invoice items
                List<InvoiceItem> items = parseInvoiceItems(request, invoiceId);
                BigDecimal totalAmount = BigDecimal.ZERO;
                
                for (InvoiceItem item : items) {
                    invoiceDAO.addInvoiceItem(invoiceId, item);
                    totalAmount = totalAmount.add(item.getTotalPrice());
                }
                
                // Update total amount
                invoiceDAO.updateInvoiceAmounts(invoiceId, totalAmount, discountAmount);
                
                request.setAttribute("successMessage", "Invoice created successfully with ID: " + invoiceId);
                response.sendRedirect(request.getContextPath() + "/receptionist/invoices?action=view&id=" + invoiceId);
            } else {
                request.setAttribute("errorMessage", "Failed to create invoice. Please try again.");
                handleNewInvoice(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid patient or appointment ID");
            handleNewInvoice(request, response);
        }
    }

    private void handleAddPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String invoiceIdParam = request.getParameter("invoiceId");
        String amountParam = request.getParameter("amount");
        String methodParam = request.getParameter("method");
        
        if (invoiceIdParam == null || invoiceIdParam.trim().isEmpty() ||
            amountParam == null || amountParam.trim().isEmpty() ||
            methodParam == null || methodParam.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Payment amount and method are required");
            response.sendRedirect(request.getContextPath() + "/receptionist/invoices?action=view&id=" + invoiceIdParam);
            return;
        }
        
        try {
            int invoiceId = Integer.parseInt(invoiceIdParam);
            BigDecimal amount = new BigDecimal(amountParam);
            String method = methodParam;
            
            // Validate amount
            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                request.setAttribute("errorMessage", "Payment amount must be greater than zero");
                response.sendRedirect(request.getContextPath() + "/receptionist/invoices?action=view&id=" + invoiceId);
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
                request.setAttribute("successMessage", "Payment recorded successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to record payment");
            }
            
            response.sendRedirect(request.getContextPath() + "/receptionist/invoices?action=view&id=" + invoiceId);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid payment amount");
            response.sendRedirect(request.getContextPath() + "/receptionist/invoices?action=view&id=" + invoiceIdParam);
        }
    }

    private List<InvoiceItem> parseInvoiceItems(HttpServletRequest request, int invoiceId) {
        List<InvoiceItem> items = new ArrayList<>();
        
        String[] serviceIds = request.getParameterValues("serviceIds");
        String[] quantities = request.getParameterValues("quantities");
        String[] unitPrices = request.getParameterValues("unitPrices");
        
        if (serviceIds != null && quantities != null && unitPrices != null) {
            for (int i = 0; i < serviceIds.length; i++) {
                try {
                    if (serviceIds[i] != null && !serviceIds[i].trim().isEmpty() &&
                        quantities[i] != null && !quantities[i].trim().isEmpty() &&
                        unitPrices[i] != null && !unitPrices[i].trim().isEmpty()) {
                        
                        int serviceId = Integer.parseInt(serviceIds[i]);
                        int quantity = Integer.parseInt(quantities[i]);
                        BigDecimal unitPrice = new BigDecimal(unitPrices[i]);
                        
                        InvoiceItem item = new InvoiceItem();
                        item.setInvoiceId(invoiceId);
                        item.setServiceId(serviceId);
                        item.setQuantity(quantity);
                        item.setUnitPrice(unitPrice);
                        item.setTotalPrice(unitPrice.multiply(BigDecimal.valueOf(quantity)));
                        
                        items.add(item);
                    }
                } catch (NumberFormatException e) {
                    // Skip invalid items
                    continue;
                }
            }
        }
        
        return items;
    }
}
