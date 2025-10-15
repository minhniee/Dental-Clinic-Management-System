package controller;

import DAO.MedicalRecordDAO;
import DAO.PatientDAO;
import DAO.PatientFileDAO;
import model.MedicalRecord;
import model.Patient;
import model.PatientFile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/open-medical-record")
public class OpenMedicalRecordPageServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(OpenMedicalRecordPageServlet.class.getName());
    
    private PatientDAO patientDAO = new PatientDAO();
    private PatientFileDAO patientFileDAO = new PatientFileDAO();
    private MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in and is a dentist
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get patient_id from query parameter
        String patientIdStr = request.getParameter("patient_id");
        if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Thiếu thông tin bệnh nhân");
            request.getRequestDispatcher("/dentist/patient-list.jsp").forward(request, response);
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdStr);
            
            // Get patient information
            Patient patient = patientDAO.getPatientById(patientId);
            if (patient == null) {
                request.setAttribute("errorMessage", "Không tìm thấy thông tin bệnh nhân");
                request.getRequestDispatcher("/dentist/patient-list.jsp").forward(request, response);
                return;
            }
            
            // Get patient files
            List<PatientFile> patientFiles = patientFileDAO.getFilesByPatientId(patientId);
            
            // Get medical records history
            List<MedicalRecord> medicalRecords = medicalRecordDAO.getRecordsByPatientId(patientId);
            
            // Set attributes for JSP
            request.setAttribute("patient", patient);
            request.setAttribute("patientFiles", patientFiles);
            request.setAttribute("medicalRecords", medicalRecords);
            
            // Forward to JSP
            request.getRequestDispatcher("/dentist/open_medical_record.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid patient_id format: " + patientIdStr, e);
            request.setAttribute("errorMessage", "ID bệnh nhân không hợp lệ");
            request.getRequestDispatcher("/dentist/patient-list.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error opening medical record page for patient: " + patientIdStr, e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi mở hồ sơ khám");
            request.getRequestDispatcher("/dentist/patient-list.jsp").forward(request, response);
        }
    }
}
