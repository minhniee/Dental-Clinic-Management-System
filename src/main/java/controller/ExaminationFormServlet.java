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

@WebServlet("/examination-form")
public class ExaminationFormServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ExaminationFormServlet.class.getName());

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
            request.getRequestDispatcher("/dentist/examination-form.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error opening examination form", e);
            request.setAttribute("errorMessage", "Lỗi khi mở form khám: " + e.getMessage());
            request.getRequestDispatcher("/dentist/record_detail.jsp").forward(request, response);
        }
    }
}
