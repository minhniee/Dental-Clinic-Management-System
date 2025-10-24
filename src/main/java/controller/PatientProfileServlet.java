package controller;

import DAO.*;
import model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/patient/profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class PatientProfileServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(PatientProfileServlet.class.getName());
    
    private final PatientDAO patientDAO = new PatientDAO();
    private final MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
    private final ExaminationDAO examinationDAO = new ExaminationDAO();
    private final TreatmentPlanDAO treatmentPlanDAO = new TreatmentPlanDAO();
    private final TreatmentSessionDAO treatmentSessionDAO = new TreatmentSessionDAO();
    private final PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
    private final PrescriptionItemDAO prescriptionItemDAO = new PrescriptionItemDAO();
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final PatientImageDAO patientImageDAO = new PatientImageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Check if user has permission to view patient profiles
        if (!"Dentist".equals(currentUser.getRole().getRoleName()) && 
            !"Receptionist".equals(currentUser.getRole().getRoleName()) &&
            !"Administrator".equals(currentUser.getRole().getRoleName())) {
            request.setAttribute("errorMessage", "Bạn không có quyền truy cập trang này");
            request.getRequestDispatcher("/error/403.jsp").forward(request, response);
            return;
        }
        
        String patientIdStr = request.getParameter("id");
        if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "ID bệnh nhân không được để trống");
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
            
            // Get medical records with examinations
            List<MedicalRecord> medicalRecords = medicalRecordDAO.getRecordsByPatientId(patientId);
            for (MedicalRecord record : medicalRecords) {
                List<Examination> examinations = examinationDAO.getExaminationsByRecordId(record.getRecordId());
                record.setExaminations(examinations);
                
                List<TreatmentPlan> treatmentPlans = treatmentPlanDAO.getTreatmentPlansByRecordId(record.getRecordId());
                for (TreatmentPlan plan : treatmentPlans) {
                    List<TreatmentSession> sessions = treatmentSessionDAO.getSessionsByPlanId(plan.getPlanId());
                    plan.setTreatmentSessions(sessions);
                }
                record.setTreatmentPlans(treatmentPlans);
            }
            
            // Get prescriptions with items
            List<Prescription> prescriptions = prescriptionDAO.getPrescriptionsByPatientId(patientId);
            for (Prescription prescription : prescriptions) {
                List<PrescriptionItem> items = prescriptionItemDAO.getItemsByPrescriptionId(prescription.getPrescriptionId());
                prescription.setPrescriptionItems(items);
            }
            
            // Get appointment history
            List<Appointment> appointments = appointmentDAO.getAppointmentsByPatientId(patientId);
            
            // Get patient images
            List<PatientImage> patientImages = patientImageDAO.getImagesByPatientId(patientId);
            
            // Set attributes for JSP
            request.setAttribute("patient", patient);
            request.setAttribute("medicalRecords", medicalRecords);
            request.setAttribute("prescriptions", prescriptions);
            request.setAttribute("appointments", appointments);
            request.setAttribute("patientImages", patientImages);
            request.setAttribute("currentUser", currentUser);
            
            // Forward to JSP
            request.getRequestDispatcher("/dentist/patient-profile.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid patient_id format: " + patientIdStr, e);
            request.setAttribute("errorMessage", "ID bệnh nhân không hợp lệ");
            request.getRequestDispatcher("/dentist/patient-list.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading patient profile: " + patientIdStr, e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải hồ sơ bệnh nhân");
            request.getRequestDispatcher("/dentist/patient-list.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Check if user has permission to update patient profiles (only Administrator and Receptionist)
        if (!"Receptionist".equals(currentUser.getRole().getRoleName()) &&
            !"Administrator".equals(currentUser.getRole().getRoleName())) {
            request.setAttribute("errorMessage", "Bạn không có quyền cập nhật hồ sơ bệnh nhân");
            request.getRequestDispatcher("/error/403.jsp").forward(request, response);
            return;
        }
        
        String action = request.getParameter("action");
        if ("uploadAvatar".equals(action)) {
            handleAvatarUpload(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/dentist/patients");
        }
    }
    
    private void handleAvatarUpload(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String patientIdStr = request.getParameter("patientId");
        if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "ID bệnh nhân không được để trống");
            response.sendRedirect(request.getContextPath() + "/dentist/patients");
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdStr);
            
            // Get patient information
            Patient patient = patientDAO.getPatientById(patientId);
            if (patient == null) {
                request.setAttribute("errorMessage", "Không tìm thấy thông tin bệnh nhân");
                response.sendRedirect(request.getContextPath() + "/dentist/patients");
                return;
            }
            
            // Get uploaded file
            Part filePart = request.getPart("avatar");
            if (filePart == null || filePart.getSize() == 0) {
                request.setAttribute("errorMessage", "Vui lòng chọn file ảnh");
                response.sendRedirect(request.getContextPath() + "/patient/profile?id=" + patientId);
                return;
            }
            
            // Validate file type
            String fileName = getFileName(filePart);
            if (fileName == null || (!fileName.toLowerCase().endsWith(".jpg") && 
                !fileName.toLowerCase().endsWith(".jpeg") && 
                !fileName.toLowerCase().endsWith(".png") && 
                !fileName.toLowerCase().endsWith(".gif"))) {
                request.setAttribute("errorMessage", "Chỉ chấp nhận file ảnh (JPG, JPEG, PNG, GIF)");
                response.sendRedirect(request.getContextPath() + "/patient/profile?id=" + patientId);
                return;
            }
            
            // Create avatar directory if not exists
            String uploadPath = getServletContext().getRealPath("/avatarPatient");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Generate unique filename
            String fileExtension = fileName.substring(fileName.lastIndexOf("."));
            String uniqueFileName = "patient_" + patientId + "_" + UUID.randomUUID().toString() + fileExtension;
            String filePath = uploadPath + File.separator + uniqueFileName;
            
            // Save file
            filePart.write(filePath);
            
            // Update patient avatar in database
            String avatarUrl = "/avatarPatient/" + uniqueFileName;
            patient.setAvatar(avatarUrl);
            
            // Update in database (you'll need to add this method to PatientDAO)
            boolean updated = updatePatientAvatar(patientId, avatarUrl);
            
            if (updated) {
                request.setAttribute("successMessage", "Cập nhật ảnh đại diện thành công");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật ảnh đại diện");
            }
            
            response.sendRedirect(request.getContextPath() + "/patient/profile?id=" + patientId);
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid patient_id format: " + patientIdStr, e);
            request.setAttribute("errorMessage", "ID bệnh nhân không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/dentist/patients");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error uploading avatar for patient: " + patientIdStr, e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi upload ảnh đại diện");
            response.sendRedirect(request.getContextPath() + "/patient/profile?id=" + patientIdStr);
        }
    }
    
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            String[] tokens = contentDisposition.split(";");
            for (String token : tokens) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf("=") + 2, token.length() - 1);
                }
            }
        }
        return null;
    }
    
    private boolean updatePatientAvatar(int patientId, String avatarUrl) {
        // This method should be implemented in PatientDAO
        // For now, we'll return true as a placeholder
        try {
            // You'll need to add this method to PatientDAO
            return patientDAO.updatePatientAvatar(patientId, avatarUrl);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating patient avatar", e);
            return false;
        }
    }
}
