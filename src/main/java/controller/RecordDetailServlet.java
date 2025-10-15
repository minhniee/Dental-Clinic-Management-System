package controller;

import DAO.ExaminationDAO;
import DAO.MedicalRecordDAO;
import DAO.TreatmentPlanDAO;
import DAO.TreatmentSessionDAO;
import model.Examination;
import model.MedicalRecord;
import model.TreatmentPlan;
import model.TreatmentSession;

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

@WebServlet("/record-detail")
public class RecordDetailServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(RecordDetailServlet.class.getName());
    
    private MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
    private ExaminationDAO examinationDAO = new ExaminationDAO();
    private TreatmentPlanDAO treatmentPlanDAO = new TreatmentPlanDAO();
    private TreatmentSessionDAO treatmentSessionDAO = new TreatmentSessionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get record_id from query parameter
        String recordIdStr = request.getParameter("record_id");
        if (recordIdStr == null || recordIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Thiếu thông tin hồ sơ khám");
            request.getRequestDispatcher("/dentist/dashboard.jsp").forward(request, response);
            return;
        }
        
        try {
            int recordId = Integer.parseInt(recordIdStr);
            
            // Get medical record
            MedicalRecord medicalRecord = medicalRecordDAO.getRecordById(recordId);
            if (medicalRecord == null) {
                request.setAttribute("errorMessage", "Không tìm thấy hồ sơ khám");
                request.getRequestDispatcher("/dentist/dashboard.jsp").forward(request, response);
                return;
            }
            
            // Get examinations for this record
            List<Examination> examinations = examinationDAO.getExaminationsByRecordId(recordId);
            
            // Get treatment plans for this record
            List<TreatmentPlan> treatmentPlans = treatmentPlanDAO.getTreatmentPlansByRecordId(recordId);
            
            // Get treatment sessions for each plan
            for (TreatmentPlan plan : treatmentPlans) {
                List<TreatmentSession> sessions = treatmentSessionDAO.getSessionsByPlanId(plan.getPlanId());
                plan.setTreatmentSessions(sessions);
            }
            
            // Set attributes for JSP
            request.setAttribute("medicalRecord", medicalRecord);
            request.setAttribute("examinations", examinations);
            request.setAttribute("treatmentPlans", treatmentPlans);
            
            // Forward to JSP
            request.getRequestDispatcher("/dentist/record_detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid record_id format: " + recordIdStr, e);
            request.setAttribute("errorMessage", "ID hồ sơ khám không hợp lệ");
            request.getRequestDispatcher("/dentist/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error getting record detail: " + recordIdStr, e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải chi tiết hồ sơ khám");
            request.getRequestDispatcher("/dentist/dashboard.jsp").forward(request, response);
        }
    }
}
