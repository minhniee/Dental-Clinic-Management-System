package controller;

import DAO.MedicalRecordDAO;
import DAO.PatientDAO;
import model.MedicalRecord;
import model.Patient;
import model.User;

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

@WebServlet("/dentist/medical-history")
public class MedicalHistoryServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(MedicalHistoryServlet.class.getName());
    
    private MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
    private PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in and is a dentist
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        if (!"Dentist".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            String patientIdStr = request.getParameter("patientId");
            
            if (patientIdStr != null && !patientIdStr.trim().isEmpty()) {
                // Show medical history for specific patient
                int patientId = Integer.parseInt(patientIdStr);
                Patient patient = patientDAO.getPatientById(patientId);
                
                if (patient != null) {
                    List<MedicalRecord> medicalRecords = medicalRecordDAO.getRecordsByPatientId(patientId);
                    request.setAttribute("patient", patient);
                    request.setAttribute("medicalRecords", medicalRecords);
                    request.getRequestDispatcher("/dentist/medical-history-patient.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Không tìm thấy bệnh nhân");
                    request.getRequestDispatcher("/dentist/medical-history.jsp").forward(request, response);
                }
            } else {
                // Show all patients with their medical history summary
                List<Patient> patients = patientDAO.getAllPatientsWithMedicalHistory();
                request.setAttribute("patients", patients);
                request.getRequestDispatcher("/dentist/medical-history.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid patient ID format", e);
            request.setAttribute("errorMessage", "ID bệnh nhân không hợp lệ");
            request.getRequestDispatcher("/dentist/medical-history.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error getting medical history", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải lịch sử khám bệnh");
            request.getRequestDispatcher("/dentist/medical-history.jsp").forward(request, response);
        }
    }
}
