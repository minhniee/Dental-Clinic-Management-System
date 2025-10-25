package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.ScheduleRequest;
import DAO.ScheduleRequestDAO;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/admin/schedule-requests")
public class ScheduleRequestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ScheduleRequestDAO scheduleRequestDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        scheduleRequestDAO = new ScheduleRequestDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Kiểm tra quyền truy cập (chỉ Clinic Manager và Administrator)
        if (currentUser == null || (currentUser.getRoleId() != 1 && currentUser.getRoleId() != 2)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            String action = request.getParameter("action");
            
            if ("view".equals(action)) {
                // Xem chi tiết yêu cầu
                viewRequest(request, response);
            } else {
                // Danh sách yêu cầu
                listRequests(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/admin/schedule-requests.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Kiểm tra quyền truy cập
        if (currentUser == null || (currentUser.getRoleId() != 1 && currentUser.getRoleId() != 2)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            String action = request.getParameter("action");
            
            if ("approve".equals(action)) {
                approveRequest(request, response);
            } else if ("reject".equals(action)) {
                rejectRequest(request, response);
            } else if ("create".equals(action)) {
                createRequest(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/schedule-requests");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xử lý yêu cầu: " + e.getMessage());
            request.getRequestDispatcher("/admin/schedule-requests.jsp").forward(request, response);
        }
    }
    
    private void listRequests(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        String status = request.getParameter("status");
        List<ScheduleRequest> requests;
        
        if (status != null && !status.isEmpty()) {
            requests = scheduleRequestDAO.getRequestsByStatus(status);
        } else {
            requests = scheduleRequestDAO.getAllRequests();
        }
        
        // Lấy thống kê
        int pendingCount = scheduleRequestDAO.getRequestCountByStatus("PENDING");
        int approvedCount = scheduleRequestDAO.getRequestCountByStatus("APPROVED");
        int rejectedCount = scheduleRequestDAO.getRequestCountByStatus("REJECTED");
        
        request.setAttribute("requests", requests);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("approvedCount", approvedCount);
        request.setAttribute("rejectedCount", rejectedCount);
        request.setAttribute("currentStatus", status);
        
        request.getRequestDispatcher("/admin/schedule-requests.jsp").forward(request, response);
    }
    
    private void viewRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        int requestId = Integer.parseInt(request.getParameter("id"));
        ScheduleRequest requestObj = scheduleRequestDAO.getRequestById(requestId);
        
        if (requestObj == null) {
            request.setAttribute("error", "Không tìm thấy yêu cầu");
            request.getRequestDispatcher("/admin/schedule-requests.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("request", requestObj);
        request.getRequestDispatcher("/admin/schedule-request-detail.jsp").forward(request, response);
    }
    
    private void approveRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        int requestId = Integer.parseInt(request.getParameter("requestId"));
        boolean success = scheduleRequestDAO.approveRequest(requestId, currentUser.getUserId());
        
        if (success) {
            request.setAttribute("success", "Đã phê duyệt yêu cầu thành công");
        } else {
            request.setAttribute("error", "Không thể phê duyệt yêu cầu");
        }
        
        // Redirect về danh sách
        response.sendRedirect(request.getContextPath() + "/admin/schedule-requests");
    }
    
    private void rejectRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        int requestId = Integer.parseInt(request.getParameter("requestId"));
        boolean success = scheduleRequestDAO.rejectRequest(requestId, currentUser.getUserId());
        
        if (success) {
            request.setAttribute("success", "Đã từ chối yêu cầu thành công");
        } else {
            request.setAttribute("error", "Không thể từ chối yêu cầu");
        }
        
        // Redirect về danh sách
        response.sendRedirect(request.getContextPath() + "/admin/schedule-requests");
    }
    
    private void createRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Lấy employee_id từ user_id
        int employeeId = getEmployeeIdByUserId(currentUser.getUserId());
        
        LocalDate date = LocalDate.parse(request.getParameter("date"));
        String shift = request.getParameter("shift");
        String reason = request.getParameter("reason");
        
        boolean success = scheduleRequestDAO.createRequest(employeeId, date, shift, reason);
        
        if (success) {
            request.setAttribute("success", "Đã gửi yêu cầu nghỉ thành công");
        } else {
            request.setAttribute("error", "Không thể gửi yêu cầu nghỉ");
        }
        
        // Redirect về danh sách
        response.sendRedirect(request.getContextPath() + "/admin/schedule-requests");
    }
    
    private int getEmployeeIdByUserId(int userId) throws SQLException {
        String sql = "SELECT employee_id FROM Employees WHERE user_id = ?";
        try (var conn = new context.DBContext().getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (var rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("employee_id") : 0;
            }
        }
    }
}
