package controller;

import DAO.ExaminationDAO;
import model.Examination;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/create-examination")
public class CreateExaminationServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(CreateExaminationServlet.class.getName());
    
    private ExaminationDAO examinationDAO = new ExaminationDAO();

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
        String findings = request.getParameter("findings");
        String diagnosis = request.getParameter("diagnosis");
        
        // Validate input
        if (recordIdStr == null || recordIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Thiếu thông tin hồ sơ khám");
            request.getRequestDispatcher("/dentist/examination-form.jsp").forward(request, response);
            return;
        }
        
        if (findings == null || findings.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập kết quả khám");
            request.getRequestDispatcher("/dentist/examination-form.jsp").forward(request, response);
            return;
        }
        
        if (diagnosis == null || diagnosis.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập chẩn đoán");
            request.getRequestDispatcher("/dentist/examination-form.jsp").forward(request, response);
            return;
        }
        
        try {
            int recordId = Integer.parseInt(recordIdStr);
            
            // Create new examination
            Examination examination = new Examination();
            examination.setRecordId(recordId);
            examination.setFindings(findings.trim());
            examination.setDiagnosis(diagnosis.trim());
            
            boolean success = examinationDAO.createExamination(examination);
            
            if (success) {
                // Redirect back to record detail page
                response.sendRedirect(request.getContextPath() + "/record-detail?record_id=" + recordId);
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo phiên khám");
                request.getRequestDispatcher("/dentist/examination-form.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid record_id format: " + recordIdStr, e);
            request.setAttribute("errorMessage", "ID hồ sơ khám không hợp lệ");
            request.getRequestDispatcher("/dentist/examination-form.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error creating examination for record: " + recordIdStr, e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo phiên khám");
            request.getRequestDispatcher("/dentist/examination-form.jsp").forward(request, response);
        }
    }
}
