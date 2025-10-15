package controller;

import DAO.MedicalRecordDAO;
import model.MedicalRecord;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/create-medical-record")
public class CreateMedicalRecordServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(CreateMedicalRecordServlet.class.getName());
    
    private MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in and is a dentist
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        if (!"Dentist".equals(currentUser.getRole().getRoleName())) {
            request.setAttribute("errorMessage", "Chỉ bác sĩ nha khoa mới có thể tạo hồ sơ khám");
            request.getRequestDispatcher("/dentist/dashboard.jsp").forward(request, response);
            return;
        }
        
        // Get form parameters
        String patientIdStr = request.getParameter("patient_id");
        String summary = request.getParameter("summary");
        
        // Validate input
        if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Thiếu thông tin bệnh nhân");
            request.getRequestDispatcher("/dentist/open_medical_record.jsp").forward(request, response);
            return;
        }
        
        if (summary == null || summary.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập tóm tắt hồ sơ khám");
            request.getRequestDispatcher("/dentist/open_medical_record.jsp").forward(request, response);
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdStr);
            
            // Create new medical record
            MedicalRecord medicalRecord = new MedicalRecord();
            medicalRecord.setPatientId(patientId);
            medicalRecord.setDentistId(currentUser.getUserId());
            medicalRecord.setSummary(summary.trim());
            
            boolean success = medicalRecordDAO.createMedicalRecord(medicalRecord);
            
            if (success) {
                // Redirect to record detail page
                response.sendRedirect(request.getContextPath() + "/record-detail?record_id=" + medicalRecord.getRecordId());
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo hồ sơ khám");
                request.getRequestDispatcher("/dentist/open_medical_record.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid patient_id format: " + patientIdStr, e);
            request.setAttribute("errorMessage", "ID bệnh nhân không hợp lệ");
            request.getRequestDispatcher("/dentist/open_medical_record.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error creating medical record for patient: " + patientIdStr, e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo hồ sơ khám");
            request.getRequestDispatcher("/dentist/open_medical_record.jsp").forward(request, response);
        }
    }
}
