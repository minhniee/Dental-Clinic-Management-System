package controller;

import DAO.TreatmentPlanDAO;
import model.TreatmentPlan;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/create-treatment-plan")
public class CreateTreatmentPlanServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(CreateTreatmentPlanServlet.class.getName());
    
    private TreatmentPlanDAO treatmentPlanDAO = new TreatmentPlanDAO();

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
        String recordIdStr = request.getParameter("record_id");
        String planSummary = request.getParameter("plan_summary");
        String estimatedCostStr = request.getParameter("estimated_cost");
        
        // Validate input
        if (recordIdStr == null || recordIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Thiếu thông tin hồ sơ khám");
            request.getRequestDispatcher("/dentist/treatment-plan-form.jsp").forward(request, response);
            return;
        }
        
        if (planSummary == null || planSummary.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập tóm tắt kế hoạch điều trị");
            request.getRequestDispatcher("/dentist/treatment-plan-form.jsp").forward(request, response);
            return;
        }
        
        try {
            int recordId = Integer.parseInt(recordIdStr);
            
            // Create new treatment plan
            TreatmentPlan treatmentPlan = new TreatmentPlan();
            treatmentPlan.setRecordId(recordId);
            treatmentPlan.setPlanSummary(planSummary.trim());
            
            // Parse estimated cost if provided
            if (estimatedCostStr != null && !estimatedCostStr.trim().isEmpty()) {
                try {
                    BigDecimal estimatedCost = new BigDecimal(estimatedCostStr.trim());
                    treatmentPlan.setEstimatedCost(estimatedCost);
                } catch (NumberFormatException e) {
                    logger.log(Level.WARNING, "Invalid estimated cost format: " + estimatedCostStr, e);
                    // Continue without cost if invalid format
                }
            }
            
            boolean success = treatmentPlanDAO.createTreatmentPlan(treatmentPlan);
            
            if (success) {
                // Redirect back to record detail page
                response.sendRedirect(request.getContextPath() + "/record-detail?record_id=" + recordId);
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo kế hoạch điều trị");
                request.getRequestDispatcher("/dentist/treatment-plan-form.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid record_id format: " + recordIdStr, e);
            request.setAttribute("errorMessage", "ID hồ sơ khám không hợp lệ");
            request.getRequestDispatcher("/dentist/treatment-plan-form.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error creating treatment plan for record: " + recordIdStr, e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo kế hoạch điều trị");
            request.getRequestDispatcher("/dentist/treatment-plan-form.jsp").forward(request, response);
        }
    }
}
