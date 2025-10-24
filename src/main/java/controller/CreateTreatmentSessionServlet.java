package controller;

import DAO.TreatmentSessionDAO;
import model.TreatmentSession;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/create-treatment-session")
public class CreateTreatmentSessionServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(CreateTreatmentSessionServlet.class.getName());
    
    private TreatmentSessionDAO treatmentSessionDAO = new TreatmentSessionDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in and is a dentist
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get form parameters
        String planIdStr = request.getParameter("plan_id");
        String sessionDateStr = request.getParameter("session_date");
        String sessionTimeStr = request.getParameter("session_time");
        String procedureDone = request.getParameter("procedure_done");
        String sessionCostStr = request.getParameter("session_cost");
        
        // Validate input
        if (planIdStr == null || planIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Thiếu thông tin kế hoạch điều trị");
            request.getRequestDispatcher("/dentist/treatment-session-form.jsp").forward(request, response);
            return;
        }
        
        if (sessionDateStr == null || sessionDateStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng chọn ngày điều trị");
            request.getRequestDispatcher("/dentist/treatment-session-form.jsp").forward(request, response);
            return;
        }
        
        if (sessionTimeStr == null || sessionTimeStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng chọn giờ điều trị");
            request.getRequestDispatcher("/dentist/treatment-session-form.jsp").forward(request, response);
            return;
        }
        
        if (procedureDone == null || procedureDone.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập thủ thuật đã thực hiện");
            request.getRequestDispatcher("/dentist/treatment-session-form.jsp").forward(request, response);
            return;
        }
        
        try {
            int planId = Integer.parseInt(planIdStr);
            
            // Parse session date and time
            LocalDateTime sessionDateTime = LocalDateTime.parse(
                sessionDateStr + "T" + sessionTimeStr, 
                DateTimeFormatter.ISO_LOCAL_DATE_TIME
            );
            
            // Create new treatment session
            TreatmentSession treatmentSession = new TreatmentSession();
            treatmentSession.setPlanId(planId);
            treatmentSession.setSessionDate(sessionDateTime.toLocalDate());
            treatmentSession.setProcedureDone(procedureDone.trim());
            
            // Parse session cost if provided
            if (sessionCostStr != null && !sessionCostStr.trim().isEmpty()) {
                try {
                    BigDecimal sessionCost = new BigDecimal(sessionCostStr.trim());
                    treatmentSession.setSessionCost(sessionCost);
                } catch (NumberFormatException e) {
                    logger.log(Level.WARNING, "Invalid session cost format: " + sessionCostStr, e);
                    // Continue without cost if invalid format
                }
            }
            
            boolean success = treatmentSessionDAO.createTreatmentSession(treatmentSession);
            
            if (success) {
                // Redirect back to record detail page
                response.sendRedirect(request.getContextPath() + "/record-detail?record_id=" + request.getParameter("record_id"));
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo buổi điều trị");
                request.getRequestDispatcher("/dentist/treatment-session-form.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid plan_id format: " + planIdStr, e);
            request.setAttribute("errorMessage", "ID kế hoạch điều trị không hợp lệ");
            request.getRequestDispatcher("/dentist/treatment-session-form.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error creating treatment session for plan: " + planIdStr, e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo buổi điều trị");
            request.getRequestDispatcher("/dentist/treatment-session-form.jsp").forward(request, response);
        }
    }
}
