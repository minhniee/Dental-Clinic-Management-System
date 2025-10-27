package controller;

import DAO.*;
import model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.File;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

@WebServlet("/medical-record")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class MedicalRecordServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(MedicalRecordServlet.class.getName());
    
    private final MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
    private final ExaminationDAO examinationDAO = new ExaminationDAO();
    private final TreatmentPlanDAO treatmentPlanDAO = new TreatmentPlanDAO();
    private final TreatmentSessionDAO treatmentSessionDAO = new TreatmentSessionDAO();
    private final PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
    private final PrescriptionItemDAO prescriptionItemDAO = new PrescriptionItemDAO();
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
        
        // Check if user has permission to view medical records
        if (!"Dentist".equals(currentUser.getRole().getRoleName()) && 
            !"Administrator".equals(currentUser.getRole().getRoleName())) {
            request.setAttribute("errorMessage", "Bạn không có quyền truy cập hồ sơ y tế");
            request.getRequestDispatcher("/error/403.jsp").forward(request, response);
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("form".equals(action)) {
                // Show form for creating/editing medical record
                showMedicalRecordForm(request, response, currentUser);
            } else if ("view".equals(action)) {
                // View specific medical record
                viewMedicalRecord(request, response);
            } else {
                // Default: redirect to patient profile
                String patientId = request.getParameter("patientId");
                if (patientId != null) {
                    response.sendRedirect(request.getContextPath() + "/patient/profile?patientId=" + patientId);
                } else {
                    response.sendRedirect(request.getContextPath() + "/dentist/patients");
                }
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in MedicalRecordServlet GET", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải hồ sơ y tế");
            request.getRequestDispatcher("/error/500.jsp").forward(request, response);
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
        
        // Check if user has permission to create/update medical records
        if (!"Dentist".equals(currentUser.getRole().getRoleName()) && 
            !"Administrator".equals(currentUser.getRole().getRoleName())) {
            request.setAttribute("errorMessage", "Bạn không có quyền cập nhật hồ sơ y tế");
            request.getRequestDispatcher("/error/403.jsp").forward(request, response);
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("createRecord".equals(action)) {
                createMedicalRecord(request, response, currentUser);
            } else if ("addExamination".equals(action)) {
                addExamination(request, response, currentUser);
            } else if ("addTreatmentPlan".equals(action)) {
                addTreatmentPlan(request, response, currentUser);
            } else if ("addTreatmentSession".equals(action)) {
                addTreatmentSession(request, response, currentUser);
            } else if ("addPrescription".equals(action)) {
                addPrescription(request, response, currentUser);
            } else if ("uploadImage".equals(action)) {
                uploadMedicalImage(request, response, currentUser);
            } else if ("deleteImage".equals(action)) {
                deleteMedicalImage(request, response, currentUser);
            } else {
                response.sendRedirect(request.getContextPath() + "/dentist/patients");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in MedicalRecordServlet POST", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật hồ sơ y tế");
            request.getRequestDispatcher("/error/500.jsp").forward(request, response);
        }
    }
    
    private void showMedicalRecordForm(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String patientIdStr = request.getParameter("patientId");
        if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "ID bệnh nhân không được để trống");
            request.getRequestDispatcher("/dentist/patients").forward(request, response);
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdStr);
            
            // Get patient information
            PatientDAO patientDAO = new PatientDAO();
            Patient patient = patientDAO.getPatientById(patientId);
            if (patient == null) {
                request.setAttribute("errorMessage", "Không tìm thấy thông tin bệnh nhân");
                request.getRequestDispatcher("/dentist/patients").forward(request, response);
                return;
            }
            
            // Get existing medical records
            List<MedicalRecord> medicalRecords = medicalRecordDAO.getRecordsByPatientId(patientId);
            
            // Get patient images
            List<PatientImage> patientImages = patientImageDAO.getImagesByPatientId(patientId);
            
            request.setAttribute("patient", patient);
            request.setAttribute("medicalRecords", medicalRecords);
            request.setAttribute("patientImages", patientImages);
            request.setAttribute("currentUser", currentUser);
            
            request.getRequestDispatcher("/dentist/medical-record-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid patient_id format: " + patientIdStr, e);
            request.setAttribute("errorMessage", "ID bệnh nhân không hợp lệ");
            request.getRequestDispatcher("/dentist/patients").forward(request, response);
        }
    }
    
    private void createMedicalRecord(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String patientIdStr = request.getParameter("patientId");
        String summary = request.getParameter("summary");
        
        if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "ID bệnh nhân không được để trống");
            response.sendRedirect(request.getContextPath() + "/dentist/patients");
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdStr);
            
            MedicalRecord record = new MedicalRecord();
            record.setPatientId(patientId);
            record.setDentistId(currentUser.getUserId());
            record.setSummary(summary);
            record.setCreatedAt(LocalDateTime.now());
            
            boolean success = medicalRecordDAO.createMedicalRecord(record);
            
            if (success) {
                request.setAttribute("successMessage", "Tạo hồ sơ y tế thành công");
                // Redirect back to medical record form to show the new record
                response.sendRedirect(request.getContextPath() + "/medical-record?action=form&patientId=" + patientId);
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo hồ sơ y tế");
                // Redirect back to medical record form with error
                response.sendRedirect(request.getContextPath() + "/medical-record?action=form&patientId=" + patientId);
            }
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid patient_id format: " + patientIdStr, e);
            request.setAttribute("errorMessage", "ID bệnh nhân không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/medical-record?action=form&patientId=" + patientIdStr);
        }
    }
    
    private void addExamination(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String recordIdStr = request.getParameter("recordId");
        String findings = request.getParameter("findings");
        String diagnosis = request.getParameter("diagnosis");
        String notes = request.getParameter("notes");
        String examinationDateStr = request.getParameter("examinationDate");
        
        if (recordIdStr == null || recordIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "ID hồ sơ không được để trống");
            response.sendRedirect(request.getContextPath() + "/dentist/patients");
            return;
        }
        
        try {
            int recordId = Integer.parseInt(recordIdStr);
            
            Examination examination = new Examination();
            examination.setRecordId(recordId);
            examination.setFindings(findings);
            examination.setDiagnosis(diagnosis);
            examination.setNotes(notes);
            examination.setCreatedAt(LocalDateTime.now());
            
            // Parse examination date
            if (examinationDateStr != null && !examinationDateStr.trim().isEmpty()) {
                examination.setExaminationDate(LocalDate.parse(examinationDateStr));
            }
            
            boolean success = examinationDAO.createExamination(examination);
            
            if (success) {
                request.setAttribute("successMessage", "Thêm kết quả khám thành công");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi thêm kết quả khám");
            }
            
            // Get patient ID from record
            MedicalRecord record = medicalRecordDAO.getRecordById(recordId);
            if (record != null) {
                response.sendRedirect(request.getContextPath() + "/medical-record?action=form&patientId=" + record.getPatientId());
            } else {
                response.sendRedirect(request.getContextPath() + "/dentist/patients");
            }
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid record_id format: " + recordIdStr, e);
            request.setAttribute("errorMessage", "ID hồ sơ không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/dentist/patients");
        }
    }
    
    private void addTreatmentPlan(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String recordIdStr = request.getParameter("recordId");
        String description = request.getParameter("description");
        String estimatedCostStr = request.getParameter("estimatedCost");
        String notes = request.getParameter("notes");
        
        if (recordIdStr == null || recordIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "ID hồ sơ không được để trống");
            response.sendRedirect(request.getContextPath() + "/dentist/patients");
            return;
        }
        
        try {
            int recordId = Integer.parseInt(recordIdStr);
            double estimatedCost = 0.0;
            if (estimatedCostStr != null && !estimatedCostStr.trim().isEmpty()) {
                // Remove formatting (commas) and parse
                String cleanCost = estimatedCostStr.replaceAll("[^0-9]", "");
                estimatedCost = cleanCost.isEmpty() ? 0.0 : Double.parseDouble(cleanCost);
            }
            
            TreatmentPlan plan = new TreatmentPlan();
            plan.setRecordId(recordId);
            plan.setPlanSummary(description);
            plan.setNotes(notes);
            plan.setEstimatedCost(BigDecimal.valueOf(estimatedCost));
            plan.setCreatedAt(LocalDateTime.now());
            
            boolean success = treatmentPlanDAO.createTreatmentPlan(plan);
            
            if (success) {
                request.setAttribute("successMessage", "Thêm kế hoạch điều trị thành công");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi thêm kế hoạch điều trị");
            }
            
            // Get patient ID from record
            MedicalRecord record = medicalRecordDAO.getRecordById(recordId);
            if (record != null) {
                response.sendRedirect(request.getContextPath() + "/medical-record?action=form&patientId=" + record.getPatientId());
            } else {
                response.sendRedirect(request.getContextPath() + "/dentist/patients");
            }
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid record_id format: " + recordIdStr, e);
            request.setAttribute("errorMessage", "ID hồ sơ không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/dentist/patients");
        }
    }
    
    private void addTreatmentSession(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String recordIdStr = request.getParameter("recordId");
        String sessionDateStr = request.getParameter("sessionDate");
        String procedure = request.getParameter("procedure");
        String sessionCostStr = request.getParameter("sessionCost");
        String notes = request.getParameter("notes");
        
        if (recordIdStr == null || recordIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "ID hồ sơ không được để trống");
            response.sendRedirect(request.getContextPath() + "/dentist/patients");
            return;
        }
        
        try {
            int recordId = Integer.parseInt(recordIdStr);
            LocalDate sessionDate = sessionDateStr != null && !sessionDateStr.trim().isEmpty()
                ? LocalDate.parse(sessionDateStr) : LocalDate.now();
            double sessionCost = sessionCostStr != null && !sessionCostStr.trim().isEmpty()
                ? Double.parseDouble(sessionCostStr) : 0.0;
            
            TreatmentSession session = new TreatmentSession();
            
            // Get the first treatment plan for this record to use as plan_id
            List<TreatmentPlan> plans = treatmentPlanDAO.getTreatmentPlansByRecordId(recordId);
            if (plans.isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng tạo kế hoạch điều trị trước khi ghi phiên điều trị");
                response.sendRedirect(request.getContextPath() + "/medical-record?action=form&patientId=" + 
                    request.getParameter("patientId"));
                return;
            }
            
            // Use the first plan's ID
            int planId = plans.get(0).getPlanId();
            session.setPlanId(planId);
            session.setRecordId(recordId);
            session.setSessionDate(sessionDate);
            session.setProcedureDone(procedure);
            session.setNotes(notes);
            session.setSessionCost(BigDecimal.valueOf(sessionCost));
            
            boolean success = treatmentSessionDAO.createTreatmentSession(session);
            
            if (success) {
                request.setAttribute("successMessage", "Thêm phiên điều trị thành công");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi thêm phiên điều trị");
            }
            
            // Get patient ID from record
            MedicalRecord record = medicalRecordDAO.getRecordById(recordId);
            if (record != null) {
                response.sendRedirect(request.getContextPath() + "/medical-record?action=form&patientId=" + record.getPatientId());
            } else {
                response.sendRedirect(request.getContextPath() + "/dentist/patients");
            }
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid record_id format: " + recordIdStr, e);
            request.setAttribute("errorMessage", "ID hồ sơ không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/dentist/patients");
        }
    }
    
    private void addPrescription(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String recordIdStr = request.getParameter("recordId");
        String notes = request.getParameter("notes");
        String prescriptionDateStr = request.getParameter("prescriptionDate");
        String[] medicationNames = request.getParameterValues("medicationName[]");
        String[] dosages = request.getParameterValues("dosage[]");
        String[] durations = request.getParameterValues("duration[]");
        String[] instructions = request.getParameterValues("instructions[]");
        
        if (recordIdStr == null || recordIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "ID hồ sơ không được để trống");
            response.sendRedirect(request.getContextPath() + "/dentist/patients");
            return;
        }
        
        try {
            int recordId = Integer.parseInt(recordIdStr);
            
            // Get patient ID from record
            MedicalRecord record = medicalRecordDAO.getRecordById(recordId);
            if (record == null) {
                request.setAttribute("errorMessage", "Không tìm thấy hồ sơ y tế");
                response.sendRedirect(request.getContextPath() + "/dentist/patients");
                return;
            }
            
            Prescription prescription = new Prescription();
            prescription.setPatientId(record.getPatientId());
            prescription.setDentistId(currentUser.getUserId());
            prescription.setNotes(notes);
            prescription.setCreatedAt(LocalDateTime.now());
            
            // Parse prescription date
            if (prescriptionDateStr != null && !prescriptionDateStr.trim().isEmpty()) {
                prescription.setPrescriptionDate(LocalDate.parse(prescriptionDateStr));
            }
            prescription.setCreatedAt(LocalDateTime.now());
            
            boolean success = prescriptionDAO.createPrescription(prescription);
            
            if (success && medicationNames != null && medicationNames.length > 0) {
                // Create prescription items
                for (int i = 0; i < medicationNames.length; i++) {
                    if (medicationNames[i] != null && !medicationNames[i].trim().isEmpty()) {
                        PrescriptionItem item = new PrescriptionItem();
                        item.setPrescriptionId(prescription.getPrescriptionId());
                        item.setMedicationName(medicationNames[i]);
                        item.setDosage(dosages != null && i < dosages.length ? dosages[i] : "");
                        item.setDuration(durations != null && i < durations.length ? durations[i] : "");
                        item.setInstructions(instructions != null && i < instructions.length ? instructions[i] : "");
                        
                        prescriptionDAO.createPrescriptionItem(item);
                    }
                }
                request.setAttribute("successMessage", "Tạo đơn thuốc thành công");
            } else if (success) {
                request.setAttribute("successMessage", "Tạo đơn thuốc thành công");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo đơn thuốc");
            }
            
            response.sendRedirect(request.getContextPath() + "/medical-record?action=form&patientId=" + record.getPatientId());
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid record_id format: " + recordIdStr, e);
            request.setAttribute("errorMessage", "ID hồ sơ không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/dentist/patients");
        }
    }
    
    private void viewMedicalRecord(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String recordIdStr = request.getParameter("recordId");
        if (recordIdStr == null || recordIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "ID hồ sơ không được để trống");
            request.getRequestDispatcher("/dentist/patients").forward(request, response);
            return;
        }
        
        try {
            int recordId = Integer.parseInt(recordIdStr);
            
            MedicalRecord record = medicalRecordDAO.getRecordById(recordId);
            if (record == null) {
                request.setAttribute("errorMessage", "Không tìm thấy hồ sơ y tế");
                request.getRequestDispatcher("/dentist/patients").forward(request, response);
                return;
            }
            
            // Get related data
            List<Examination> examinations = examinationDAO.getExaminationsByRecordId(recordId);
            List<TreatmentPlan> treatmentPlans = treatmentPlanDAO.getTreatmentPlansByRecordId(recordId);
            List<TreatmentSession> treatmentSessions = treatmentSessionDAO.getTreatmentSessionsByRecordId(recordId);
            List<Prescription> prescriptions = prescriptionDAO.getPrescriptionsByRecordId(recordId);
            
            // Load prescription items for each prescription
            for (Prescription prescription : prescriptions) {
                List<PrescriptionItem> items = prescriptionItemDAO.getItemsByPrescriptionId(prescription.getPrescriptionId());
                prescription.setPrescriptionItems(items);
            }
            
            record.setExaminations(examinations);
            record.setTreatmentPlans(treatmentPlans);
            record.setTreatmentSessions(treatmentSessions);
            record.setPrescriptions(prescriptions);
            
            request.setAttribute("record", record);
            request.getRequestDispatcher("/dentist/medical-record-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid record_id format: " + recordIdStr, e);
            request.setAttribute("errorMessage", "ID hồ sơ không hợp lệ");
            request.getRequestDispatcher("/dentist/patients").forward(request, response);
        }
    }
    
    private void uploadMedicalImage(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String patientIdStr = request.getParameter("patientId");
        String imageType = request.getParameter("imageType");
        
        if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "ID bệnh nhân không được để trống");
            request.getRequestDispatcher("/dentist/medical-record-form.jsp").forward(request, response);
            return;
        }
        
        if (imageType == null || imageType.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng chọn loại ảnh");
            request.getRequestDispatcher("/dentist/medical-record-form.jsp").forward(request, response);
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdStr);
            
            // Get patient information
            PatientDAO patientDAO = new PatientDAO();
            Patient patient = patientDAO.getPatientById(patientId);
            if (patient == null) {
                request.setAttribute("errorMessage", "Không tìm thấy thông tin bệnh nhân");
                request.getRequestDispatcher("/dentist/medical-record-form.jsp").forward(request, response);
                return;
            }
            
            // Create upload directory if it doesn't exist
            String uploadPath = request.getServletContext().getRealPath("/") + "uploads/medical-images/";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            int uploadedCount = 0;
            int totalFiles = 0;
            
            // Process each uploaded file
            for (Part part : request.getParts()) {
                if (part.getName().equals("imageFiles") && part.getSize() > 0) {
                    totalFiles++;
                    
                    String fileName = getFileName(part);
                    if (fileName != null && !fileName.isEmpty()) {
                        // Generate unique filename
                        String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                        String uniqueFileName = System.currentTimeMillis() + "_" + patientId + "_" + totalFiles + fileExtension;
                        String filePath = uploadPath + uniqueFileName;
                        
                        // Save file
                        part.write(filePath);
                        
                        // Save to database
                        PatientImage patientImage = new PatientImage();
                        patientImage.setPatientId(patientId);
                        patientImage.setRecordId(null); // Can be linked to specific record later
                        patientImage.setFilePath("uploads/medical-images/" + uniqueFileName);
                        patientImage.setImageType(imageType);
                        patientImage.setUploadedAt(LocalDateTime.now());
                        patientImage.setUploadedBy(currentUser.getUserId());
                        
                        if (patientImageDAO.createPatientImage(patientImage)) {
                            uploadedCount++;
                        }
                    }
                }
            }
            
            if (uploadedCount > 0) {
                request.setAttribute("successMessage", "Đã upload thành công " + uploadedCount + " ảnh");
            } else {
                request.setAttribute("errorMessage", "Không có ảnh nào được upload thành công");
            }
            
            // Redirect back to medical record form
            response.sendRedirect(request.getContextPath() + "/medical-record?action=form&patientId=" + patientId);
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid patient_id format: " + patientIdStr, e);
            request.setAttribute("errorMessage", "ID bệnh nhân không hợp lệ");
            request.getRequestDispatcher("/dentist/medical-record-form.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error uploading medical images", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi upload ảnh");
            request.getRequestDispatcher("/dentist/medical-record-form.jsp").forward(request, response);
        }
    }
    
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            for (String token : contentDisposition.split(";")) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf("=") + 2, token.length() - 1);
                }
            }
        }
        return null;
    }
    
    private void deleteMedicalImage(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String imageIdStr = request.getParameter("imageId");
        String patientIdStr = request.getParameter("patientId");
        
        if (imageIdStr == null || imageIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "ID ảnh không được để trống");
            response.sendRedirect(request.getContextPath() + "/medical-record?action=form&patientId=" + patientIdStr);
            return;
        }
        
        try {
            int imageId = Integer.parseInt(imageIdStr);
            
            // Get image info before deleting
            PatientImage image = patientImageDAO.getImageById(imageId);
            if (image == null) {
                request.setAttribute("errorMessage", "Không tìm thấy ảnh");
                response.sendRedirect(request.getContextPath() + "/medical-record?action=form&patientId=" + patientIdStr);
                return;
            }
            
            // Delete from database
            if (patientImageDAO.deletePatientImage(imageId)) {
                // Delete physical file
                String filePath = request.getServletContext().getRealPath("/") + image.getFilePath();
                File file = new File(filePath);
                if (file.exists()) {
                    file.delete();
                }
                
                request.setAttribute("successMessage", "Đã xóa ảnh thành công");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi xóa ảnh");
            }
            
            // Redirect back to medical record form
            response.sendRedirect(request.getContextPath() + "/medical-record?action=form&patientId=" + patientIdStr);
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid image_id format: " + imageIdStr, e);
            request.setAttribute("errorMessage", "ID ảnh không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/medical-record?action=form&patientId=" + patientIdStr);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deleting medical image", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi xóa ảnh");
            response.sendRedirect(request.getContextPath() + "/medical-record?action=form&patientId=" + patientIdStr);
        }
    }
}
