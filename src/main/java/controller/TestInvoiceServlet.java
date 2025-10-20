package controller;

import DAO.InvoiceDAO;
import DAO.AppointmentDAO;
import DAO.ServiceDAO;
import model.Invoice;
import model.Appointment;
import model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/test-invoice")
public class TestInvoiceServlet extends HttpServlet {

    private InvoiceDAO invoiceDAO;
    private AppointmentDAO appointmentDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        invoiceDAO = new InvoiceDAO();
        appointmentDAO = new AppointmentDAO();
        serviceDAO = new ServiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get completed appointments
            List<Appointment> completedAppointments = appointmentDAO.getAppointmentsByStatus("COMPLETED");
            
            // Get all services
            List<Service> services = serviceDAO.getAllActiveServices();
            
            // Get recent invoices
            List<Invoice> recentInvoices = invoiceDAO.getRecentInvoices(10);
            
            request.setAttribute("completedAppointments", completedAppointments);
            request.setAttribute("services", services);
            request.setAttribute("recentInvoices", recentInvoices);
            
            request.getRequestDispatcher("/test-invoice.jsp").forward(request, response);
            
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
            e.printStackTrace(response.getWriter());
        }
    }
}
