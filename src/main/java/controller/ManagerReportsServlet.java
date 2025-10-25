package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import context.DBContext;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/manager/reports")
public class ManagerReportsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DBContext dbContext = new DBContext();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // Check if user is logged in and is clinic manager
        if (currentUser == null || !"ClinicManager".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String reportType = request.getParameter("type");
        if (reportType == null) {
            reportType = "appointments";
        }

        try {
            switch (reportType) {
                case "appointments":
                    showAppointmentsReport(request, response);
                    break;
                case "revenue":
                    showRevenueReport(request, response);
                    break;
                default:
                    showAppointmentsReport(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải báo cáo.");
            request.getRequestDispatcher("/manager/reports/appointments.jsp").forward(request, response);
        }
    }


    private void showAppointmentsReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Map<String, Object> appointmentsData = new HashMap<>();
            
            // Get filter parameters
            String dateFrom = request.getParameter("dateFrom");
            String dateTo = request.getParameter("dateTo");
            String doctorName = request.getParameter("doctorName");
            String status = request.getParameter("status");
            
            if (dateFrom == null || dateFrom.isEmpty()) {
                dateFrom = LocalDate.now().minusDays(30).toString();
            }
            if (dateTo == null || dateTo.isEmpty()) {
                dateTo = LocalDate.now().toString();
            }
            
            // Get all appointments with filters
            List<Map<String, Object>> appointmentsList = getAllAppointments(dateFrom, dateTo, doctorName, status);
            appointmentsData.put("appointmentsList", appointmentsList);
            
            // Get doctors list for filter
            List<Map<String, Object>> doctorsList = getAllDoctors();
            appointmentsData.put("doctorsList", doctorsList);
            
            request.setAttribute("appointmentsData", appointmentsData);
            request.setAttribute("dateFrom", dateFrom);
            request.setAttribute("dateTo", dateTo);
            request.setAttribute("doctorName", doctorName);
            request.setAttribute("status", status);
            request.getRequestDispatcher("/manager/reports/appointments.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải báo cáo lịch hẹn.");
            request.getRequestDispatcher("/manager/reports/appointments.jsp").forward(request, response);
        }
    }

    private void showRevenueReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Map<String, Object> revenueData = new HashMap<>();
            
            // Get date range
            String dateFrom = request.getParameter("dateFrom");
            String dateTo = request.getParameter("dateTo");
            
            if (dateFrom == null || dateFrom.isEmpty()) {
                dateFrom = LocalDate.now().minusDays(7).toString();
            }
            if (dateTo == null || dateTo.isEmpty()) {
                dateTo = LocalDate.now().toString();
            }
            
            // Revenue from Invoices
            double invoiceRevenue = getInvoiceRevenue(dateFrom, dateTo);
            revenueData.put("invoiceRevenue", invoiceRevenue);
            
            // Revenue from Appointments (Services)
            double appointmentRevenue = getAppointmentRevenue(dateFrom, dateTo);
            revenueData.put("appointmentRevenue", appointmentRevenue);
            
            // Revenue from Inventory Items (if any sales)
            double inventoryRevenue = getInventoryRevenue(dateFrom, dateTo);
            revenueData.put("inventoryRevenue", inventoryRevenue);
            
            // Total combined revenue
            double totalRevenue = invoiceRevenue + appointmentRevenue + inventoryRevenue;
            revenueData.put("totalRevenue", totalRevenue);
            
            // Revenue breakdown by source
            List<Map<String, Object>> revenueBySource = getRevenueBySource(dateFrom, dateTo);
            revenueData.put("revenueBySource", revenueBySource);
            
            // Revenue by day
            List<Map<String, Object>> revenueByDay = getRevenueByDay(dateFrom, dateTo);
            revenueData.put("revenueByDay", revenueByDay);
            
            // Revenue by service
            List<Map<String, Object>> revenueByService = getRevenueByService(dateFrom, dateTo);
            revenueData.put("revenueByService", revenueByService);
            
            // Revenue by doctor
            List<Map<String, Object>> revenueByDoctor = getRevenueByDoctor(dateFrom, dateTo);
            revenueData.put("revenueByDoctor", revenueByDoctor);
            
            request.setAttribute("revenueData", revenueData);
            request.setAttribute("dateFrom", dateFrom);
            request.setAttribute("dateTo", dateTo);
            request.getRequestDispatcher("/manager/reports/revenue.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải báo cáo doanh thu.");
            request.getRequestDispatcher("/manager/reports/revenue.jsp").forward(request, response);
        }
    }

    // Database helper methods
    private List<Map<String, Object>> getAllAppointments(String dateFrom, String dateTo, String doctorName, String status) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT a.appointment_id, a.appointment_date, a.status, a.notes, ");
        sql.append("p.full_name as patient_name, p.phone as patient_phone, p.email as patient_email, ");
        sql.append("u.full_name as doctor_name, s.name as service_name ");
        sql.append("FROM Appointments a ");
        sql.append("JOIN Patients p ON a.patient_id = p.patient_id ");
        sql.append("JOIN Users u ON a.dentist_id = u.user_id ");
        sql.append("JOIN Services s ON a.service_id = s.service_id ");
        sql.append("WHERE a.appointment_date BETWEEN ? AND ? ");
        
        List<Object> parameters = new ArrayList<>();
        parameters.add(dateFrom);
        parameters.add(dateTo);
        
        if (doctorName != null && !doctorName.trim().isEmpty()) {
            sql.append("AND u.full_name LIKE ? ");
            parameters.add("%" + doctorName.trim() + "%");
        }
        
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND a.status = ? ");
            parameters.add(status.trim());
        }
        
        sql.append("ORDER BY a.appointment_date DESC");
        
        List<Map<String, Object>> appointments = new ArrayList<>();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> appointment = new HashMap<>();
                    appointment.put("appointmentId", rs.getInt("appointment_id"));
                    appointment.put("appointmentDate", rs.getTimestamp("appointment_date"));
                    appointment.put("status", rs.getString("status"));
                    appointment.put("notes", rs.getString("notes"));
                    appointment.put("patientName", rs.getString("patient_name"));
                    appointment.put("patientPhone", rs.getString("patient_phone"));
                    appointment.put("patientEmail", rs.getString("patient_email"));
                    appointment.put("doctorName", rs.getString("doctor_name"));
                    appointment.put("serviceName", rs.getString("service_name"));
                    appointments.add(appointment);
                }
            }
        }
        return appointments;
    }
    
    private List<Map<String, Object>> getAllDoctors() throws SQLException {
        String sql = "SELECT DISTINCT u.full_name as doctor_name " +
                    "FROM Users u " +
                    "JOIN Roles r ON u.role_id = r.role_id " +
                    "WHERE r.role_name = 'Dentist' AND u.is_active = 1 " +
                    "ORDER BY u.full_name";
        
        List<Map<String, Object>> doctors = new ArrayList<>();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> doctor = new HashMap<>();
                doctor.put("doctorName", rs.getString("doctor_name"));
                doctors.add(doctor);
            }
        }
        return doctors;
    }
    private int getTotalAppointments(String dateFrom, String dateTo) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Appointments WHERE appointment_date BETWEEN ? AND ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dateFrom);
            ps.setString(2, dateTo);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private double getInvoiceRevenue(String dateFrom, String dateTo) throws SQLException {
        String sql = "SELECT COALESCE(SUM(net_amount), 0) FROM Invoices WHERE created_at BETWEEN ? AND ? AND status = 'PAID'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dateFrom);
            ps.setString(2, dateTo);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble(1) : 0.0;
            }
        }
    }
    
    private double getAppointmentRevenue(String dateFrom, String dateTo) throws SQLException {
        String sql = "SELECT COALESCE(SUM(s.price), 0) FROM Appointments a " +
                    "JOIN Services s ON a.service_id = s.service_id " +
                    "WHERE a.appointment_date BETWEEN ? AND ? AND a.status = 'COMPLETED'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dateFrom);
            ps.setString(2, dateTo);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble(1) : 0.0;
            }
        }
    }
    
    private double getInventoryRevenue(String dateFrom, String dateTo) throws SQLException {
        // Note: This assumes inventory items can be sold. If not, return 0
        // For now, we'll return 0 as inventory items are typically for internal use
        return 0.0;
    }
    
    private List<Map<String, Object>> getRevenueBySource(String dateFrom, String dateTo) throws SQLException {
        List<Map<String, Object>> revenueBySource = new ArrayList<>();
        
        // Invoice Revenue
        Map<String, Object> invoiceData = new HashMap<>();
        invoiceData.put("source", "Hóa Đơn");
        invoiceData.put("revenue", getInvoiceRevenue(dateFrom, dateTo));
        invoiceData.put("percentage", 0.0); // Will be calculated later
        revenueBySource.add(invoiceData);
        
        // Appointment Revenue
        Map<String, Object> appointmentData = new HashMap<>();
        appointmentData.put("source", "Dịch Vụ");
        appointmentData.put("revenue", getAppointmentRevenue(dateFrom, dateTo));
        appointmentData.put("percentage", 0.0); // Will be calculated later
        revenueBySource.add(appointmentData);
        
        // Inventory Revenue
        Map<String, Object> inventoryData = new HashMap<>();
        inventoryData.put("source", "Vật Tư");
        inventoryData.put("revenue", getInventoryRevenue(dateFrom, dateTo));
        inventoryData.put("percentage", 0.0); // Will be calculated later
        revenueBySource.add(inventoryData);
        
        // Calculate percentages
        double totalRevenue = getInvoiceRevenue(dateFrom, dateTo) + 
                            getAppointmentRevenue(dateFrom, dateTo) + 
                            getInventoryRevenue(dateFrom, dateTo);
        
        if (totalRevenue > 0) {
            for (Map<String, Object> data : revenueBySource) {
                double revenue = (Double) data.get("revenue");
                double percentage = (revenue / totalRevenue) * 100;
                data.put("percentage", percentage);
            }
        }
        
        return revenueBySource;
    }

    private int getTotalPatients(String dateFrom, String dateTo) throws SQLException {
        String sql = "SELECT COUNT(DISTINCT patient_id) FROM Appointments WHERE appointment_date BETWEEN ? AND ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dateFrom);
            ps.setString(2, dateTo);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private List<Map<String, Object>> getRecentAppointments(int limit) throws SQLException {
        String sql = "SELECT TOP " + limit + " a.appointment_id, a.appointment_date, " +
                    "p.full_name as patient_name, u.full_name as doctor_name, a.status " +
                    "FROM Appointments a " +
                    "JOIN Patients p ON a.patient_id = p.patient_id " +
                    "JOIN Users u ON a.dentist_id = u.user_id " +
                    "ORDER BY a.appointment_date DESC";
        List<Map<String, Object>> appointments = new ArrayList<>();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> appointment = new HashMap<>();
                    appointment.put("appointmentId", rs.getInt("appointment_id"));
                    appointment.put("appointmentDate", rs.getTimestamp("appointment_date"));
                    appointment.put("patientName", rs.getString("patient_name"));
                    appointment.put("doctorName", rs.getString("doctor_name"));
                    appointment.put("status", rs.getString("status"));
                    appointments.add(appointment);
                }
            }
        }
        return appointments;
    }

    private List<Map<String, Object>> getRevenueByDay(String dateFrom, String dateTo) throws SQLException {
        String sql = "SELECT created_at, COALESCE(SUM(net_amount), 0) as daily_revenue " +
                    "FROM Invoices WHERE created_at BETWEEN ? AND ? AND status = 'PAID' " +
                    "GROUP BY created_at ORDER BY created_at";
        List<Map<String, Object>> revenueByDay = new ArrayList<>();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dateFrom);
            ps.setString(2, dateTo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> dayRevenue = new HashMap<>();
                    dayRevenue.put("date", rs.getString("created_at"));
                    dayRevenue.put("revenue", rs.getDouble("daily_revenue"));
                    revenueByDay.add(dayRevenue);
                }
            }
        }
        return revenueByDay;
    }

    private List<Map<String, Object>> getAppointmentsByStatus(String dateFrom, String dateTo) throws SQLException {
        String sql = "SELECT status, COUNT(*) as count FROM Appointments " +
                    "WHERE appointment_date BETWEEN ? AND ? GROUP BY status";
        List<Map<String, Object>> appointmentsByStatus = new ArrayList<>();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dateFrom);
            ps.setString(2, dateTo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> statusData = new HashMap<>();
                    statusData.put("status", rs.getString("status"));
                    statusData.put("count", rs.getInt("count"));
                    appointmentsByStatus.add(statusData);
                }
            }
        }
        return appointmentsByStatus;
    }

    private List<Map<String, Object>> getAppointmentsByDoctor(String dateFrom, String dateTo) throws SQLException {
        String sql = "SELECT u.full_name as doctor_name, COUNT(*) as count " +
                    "FROM Appointments a " +
                    "JOIN Users u ON a.dentist_id = u.user_id " +
                    "WHERE a.appointment_date BETWEEN ? AND ? " +
                    "GROUP BY u.full_name ORDER BY count DESC";
        List<Map<String, Object>> appointmentsByDoctor = new ArrayList<>();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dateFrom);
            ps.setString(2, dateTo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> doctorData = new HashMap<>();
                    doctorData.put("doctorName", rs.getString("doctor_name"));
                    doctorData.put("count", rs.getInt("count"));
                    appointmentsByDoctor.add(doctorData);
                }
            }
        }
        return appointmentsByDoctor;
    }

    private List<Map<String, Object>> getAppointmentsByDay(String dateFrom, String dateTo) throws SQLException {
        String sql = "SELECT appointment_date, COUNT(*) as count FROM Appointments " +
                    "WHERE appointment_date BETWEEN ? AND ? " +
                    "GROUP BY appointment_date ORDER BY appointment_date";
        List<Map<String, Object>> appointmentsByDay = new ArrayList<>();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dateFrom);
            ps.setString(2, dateTo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> dayData = new HashMap<>();
                    dayData.put("date", rs.getString("appointment_date"));
                    dayData.put("count", rs.getInt("count"));
                    appointmentsByDay.add(dayData);
                }
            }
        }
        return appointmentsByDay;
    }

    private List<Map<String, Object>> getRevenueByService(String dateFrom, String dateTo) throws SQLException {
        String sql = "SELECT s.name as service_name, COALESCE(SUM(ii.quantity * ii.unit_price), 0) as revenue " +
                    "FROM Invoices i " +
                    "JOIN InvoiceItems ii ON i.invoice_id = ii.invoice_id " +
                    "JOIN Services s ON ii.service_id = s.service_id " +
                    "WHERE i.created_at BETWEEN ? AND ? AND i.status = 'PAID' " +
                    "GROUP BY s.name ORDER BY revenue DESC";
        List<Map<String, Object>> revenueByService = new ArrayList<>();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dateFrom);
            ps.setString(2, dateTo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> serviceData = new HashMap<>();
                    serviceData.put("serviceName", rs.getString("service_name"));
                    serviceData.put("revenue", rs.getDouble("revenue"));
                    revenueByService.add(serviceData);
                }
            }
        }
        return revenueByService;
    }

    private List<Map<String, Object>> getRevenueByDoctor(String dateFrom, String dateTo) throws SQLException {
        String sql = "SELECT u.full_name as doctor_name, COALESCE(SUM(i.net_amount), 0) as revenue " +
                    "FROM Invoices i " +
                    "JOIN Appointments a ON i.appointment_id = a.appointment_id " +
                    "JOIN Users u ON a.dentist_id = u.user_id " +
                    "WHERE i.created_at BETWEEN ? AND ? AND i.status = 'PAID' " +
                    "GROUP BY u.full_name ORDER BY revenue DESC";
        List<Map<String, Object>> revenueByDoctor = new ArrayList<>();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dateFrom);
            ps.setString(2, dateTo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> doctorData = new HashMap<>();
                    doctorData.put("doctorName", rs.getString("doctor_name"));
                    doctorData.put("revenue", rs.getDouble("revenue"));
                    revenueByDoctor.add(doctorData);
                }
            }
        }
        return revenueByDoctor;
    }

    private double getAppointmentCompletionRate(String dateFrom, String dateTo) throws SQLException {
        String sql = "SELECT COUNT(*) as total, COUNT(CASE WHEN status = 'COMPLETED' THEN 1 END) as completed " +
                    "FROM Appointments WHERE appointment_date BETWEEN ? AND ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dateFrom);
            ps.setString(2, dateTo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int total = rs.getInt("total");
                    int completed = rs.getInt("completed");
                    return total > 0 ? (double) completed / total * 100 : 0.0;
                }
            }
        }
        return 0.0;
    }

}
