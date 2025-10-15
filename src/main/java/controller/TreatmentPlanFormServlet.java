package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/treatment-plan-form")
public class TreatmentPlanFormServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(TreatmentPlanFormServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            String recordId = request.getParameter("record_id");
            if (recordId == null || recordId.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Thiếu thông tin record_id");
                request.getRequestDispatcher("/dentist/record_detail.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("record_id", recordId);
            request.getRequestDispatcher("/dentist/treatment-plan-form.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error opening treatment plan form", e);
            request.setAttribute("errorMessage", "Lỗi khi mở form kế hoạch điều trị: " + e.getMessage());
            request.getRequestDispatcher("/dentist/record_detail.jsp").forward(request, response);
        }
    }
}
