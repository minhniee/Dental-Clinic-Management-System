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

@WebServlet("/upload-result")
public class UploadResultFormServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(UploadResultFormServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            String patientId = request.getParameter("patient_id");
            if (patientId == null || patientId.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Thiếu thông tin patient_id");
                request.getRequestDispatcher("/dentist/record_detail.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("patient_id", patientId);
            request.getRequestDispatcher("/dentist/upload-result.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error opening upload result form", e);
            request.setAttribute("errorMessage", "Lỗi khi mở form upload kết quả: " + e.getMessage());
            request.getRequestDispatcher("/dentist/record_detail.jsp").forward(request, response);
        }
    }
}
