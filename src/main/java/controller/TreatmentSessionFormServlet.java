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

@WebServlet("/treatment-session-form")
public class TreatmentSessionFormServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(TreatmentSessionFormServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            String planId = request.getParameter("plan_id");
            if (planId == null || planId.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Thiếu thông tin plan_id");
                request.getRequestDispatcher("/dentist/record_detail.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("plan_id", planId);
            request.getRequestDispatcher("/dentist/treatment-session-form.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error opening treatment session form", e);
            request.setAttribute("errorMessage", "Lỗi khi mở form buổi điều trị: " + e.getMessage());
            request.getRequestDispatcher("/dentist/record_detail.jsp").forward(request, response);
        }
    }
}
