package controller;

import DAO.MedicalRecordDAO;
import DAO.PrescriptionDAO;
import DAO.PrescriptionItemDAO;
import DAO.TreatmentPlanDAO;
import DAO.TreatmentSessionDAO;
import model.MedicalRecord;
import model.Prescription;
import model.PrescriptionItem;
import model.TreatmentPlan;
import model.TreatmentSession;
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

@WebServlet("/treatment-history")
public class TreatmentHistoryServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(TreatmentHistoryServlet.class.getName());
    
    private MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
    private PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
    private PrescriptionItemDAO prescriptionItemDAO = new PrescriptionItemDAO();
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
        
        User currentUser = (User) session.getAttribute("user");
        String patientIdStr = request.getParameter("patient_id");
        
        // Determine patient ID based on user role
        int patientId;
        if ("Patient".equals(currentUser.getRole().getRoleName())) {
            // If user is a patient, get their own patient ID
            // This would need to be implemented based on your user-patient relationship
            patientId = getPatientIdFromUser(currentUser);
            if (patientId == -1) {
                request.setAttribute("errorMessage", "Không tìm thấy thông tin bệnh nhân");
                request.getRequestDispatcher("/patient/dashboard.jsp").forward(request, response);
                return;
            }
        } else {
            // If user is dentist/admin, get patient ID from parameter
            if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Thiếu thông tin bệnh nhân");
                request.getRequestDispatcher("/dentist/dashboard.jsp").forward(request, response);
                return;
            }
            
            try {
                patientId = Integer.parseInt(patientIdStr);
            } catch (NumberFormatException e) {
                logger.log(Level.WARNING, "Invalid patient_id format: " + patientIdStr, e);
                request.setAttribute("errorMessage", "ID bệnh nhân không hợp lệ");
                request.getRequestDispatcher("/dentist/dashboard.jsp").forward(request, response);
                return;
            }
        }
        
        try {
            // Get medical records
            List<MedicalRecord> medicalRecords = medicalRecordDAO.getRecordsByPatientId(patientId);
            
            // Get prescriptions
            List<Prescription> prescriptions = prescriptionDAO.getPrescriptionsByPatientId(patientId);
            
            // Get prescription items for each prescription
            for (Prescription prescription : prescriptions) {
                List<PrescriptionItem> items = prescriptionItemDAO.getItemsByPrescriptionId(prescription.getPrescriptionId());
                prescription.setPrescriptionItems(items);
            }
            
            // Get treatment plans and sessions
            for (MedicalRecord record : medicalRecords) {
                List<TreatmentPlan> plans = treatmentPlanDAO.getTreatmentPlansByRecordId(record.getRecordId());
                for (TreatmentPlan plan : plans) {
                    List<TreatmentSession> sessions = treatmentSessionDAO.getSessionsByPlanId(plan.getPlanId());
                    plan.setTreatmentSessions(sessions);
                }
                record.setTreatmentPlans(plans);
            }
            
            // Set attributes for JSP
            request.setAttribute("patientId", patientId);
            request.setAttribute("medicalRecords", medicalRecords);
            request.setAttribute("prescriptions", prescriptions);
            request.setAttribute("currentUser", currentUser);
            
            // Forward to appropriate JSP based on user role
            if ("Patient".equals(currentUser.getRole().getRoleName())) {
                request.getRequestDispatcher("/patient/treatment-history.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/dentist/treatment-history.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error getting treatment history for patient: " + patientId, e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải lịch sử điều trị");
            if ("Patient".equals(currentUser.getRole().getRoleName())) {
                request.getRequestDispatcher("/patient/dashboard.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/dentist/dashboard.jsp").forward(request, response);
            }
        }
    }
    
    /**
     * Get patient ID from user (this would need to be implemented based on your user-patient relationship)
     */
    private int getPatientIdFromUser(User user) {
        // This is a placeholder implementation
        // You would need to implement this based on how you link users to patients
        // For example, if you have a patient_id field in the Users table or a separate mapping table
        
        // For now, return -1 to indicate not found
        // You might want to add a method in PatientDAO to get patient by user ID
        return -1;
    }
}
