package controller;

import DAO.PrescriptionDAO;
import DAO.PrescriptionItemDAO;
import model.Prescription;
import model.PrescriptionItem;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/create-prescription")
public class CreatePrescriptionServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(CreatePrescriptionServlet.class.getName());
    
    private PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
    private PrescriptionItemDAO prescriptionItemDAO = new PrescriptionItemDAO();

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
            request.setAttribute("errorMessage", "Chỉ bác sĩ nha khoa mới có thể kê đơn thuốc");
            request.getRequestDispatcher("/dentist/prescription-form.jsp").forward(request, response);
            return;
        }
        
        // Get form parameters
        String patientIdStr = request.getParameter("patient_id");
        String notes = request.getParameter("notes");
        
        // Validate input
        if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Thiếu thông tin bệnh nhân");
            request.getRequestDispatcher("/dentist/prescription-form.jsp").forward(request, response);
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdStr);
            
            // Create new prescription
            Prescription prescription = new Prescription();
            prescription.setPatientId(patientId);
            prescription.setDentistId(currentUser.getUserId());
            prescription.setNotes(notes != null ? notes.trim() : null);
            
            boolean prescriptionSuccess = prescriptionDAO.createPrescription(prescription);
            
            if (!prescriptionSuccess) {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo đơn thuốc");
                request.getRequestDispatcher("/dentist/prescription-form.jsp").forward(request, response);
                return;
            }
            
            // Get prescription items from form
            List<PrescriptionItem> prescriptionItems = extractPrescriptionItems(request, prescription.getPrescriptionId());
            
            if (prescriptionItems.isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng thêm ít nhất một loại thuốc");
                request.getRequestDispatcher("/dentist/prescription-form.jsp").forward(request, response);
                return;
            }
            
            // Save prescription items
            boolean itemsSuccess = prescriptionItemDAO.addItemsToPrescription(prescription.getPrescriptionId(), prescriptionItems);
            
            if (itemsSuccess) {
                // Redirect to prescription detail or record detail page
                response.sendRedirect(request.getContextPath() + "/record-detail?record_id=" + request.getParameter("record_id"));
            } else {
                // Delete prescription if items failed to save
                prescriptionDAO.deletePrescription(prescription.getPrescriptionId());
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi lưu danh sách thuốc");
                request.getRequestDispatcher("/dentist/prescription-form.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid patient_id format: " + patientIdStr, e);
            request.setAttribute("errorMessage", "ID bệnh nhân không hợp lệ");
            request.getRequestDispatcher("/dentist/prescription-form.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error creating prescription for patient: " + patientIdStr, e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo đơn thuốc");
            request.getRequestDispatcher("/dentist/prescription-form.jsp").forward(request, response);
        }
    }
    
    /**
     * Extract prescription items from request parameters
     */
    private List<PrescriptionItem> extractPrescriptionItems(HttpServletRequest request, int prescriptionId) {
        List<PrescriptionItem> items = new ArrayList<>();
        
        // Get all parameter names
        Enumeration<String> parameterNames = request.getParameterNames();
        
        // Find medication names to determine how many medications we have
        List<Integer> medicationNumbers = new ArrayList<>();
        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();
            if (paramName.startsWith("medication_name_")) {
                String numberStr = paramName.substring("medication_name_".length());
                try {
                    int number = Integer.parseInt(numberStr);
                    medicationNumbers.add(number);
                } catch (NumberFormatException e) {
                    logger.log(Level.WARNING, "Invalid medication number: " + numberStr, e);
                }
            }
        }
        
        // Create prescription items for each medication
        for (Integer number : medicationNumbers) {
            String medicationName = request.getParameter("medication_name_" + number);
            String dosage = request.getParameter("dosage_" + number);
            String duration = request.getParameter("duration_" + number);
            String instructions = request.getParameter("instructions_" + number);
            String detailedInstructions = request.getParameter("detailed_instructions_" + number);
            
            // Only add if medication name is provided
            if (medicationName != null && !medicationName.trim().isEmpty()) {
                PrescriptionItem item = new PrescriptionItem();
                item.setPrescriptionId(prescriptionId);
                item.setMedicationName(medicationName.trim());
                item.setDosage(dosage != null ? dosage.trim() : null);
                item.setDuration(duration != null ? duration.trim() : null);
                
                // Combine instructions and detailed instructions
                StringBuilder combinedInstructions = new StringBuilder();
                if (instructions != null && !instructions.trim().isEmpty()) {
                    combinedInstructions.append(instructions.trim());
                }
                if (detailedInstructions != null && !detailedInstructions.trim().isEmpty()) {
                    if (combinedInstructions.length() > 0) {
                        combinedInstructions.append(" - ");
                    }
                    combinedInstructions.append(detailedInstructions.trim());
                }
                item.setInstructions(combinedInstructions.length() > 0 ? combinedInstructions.toString() : null);
                
                items.add(item);
            }
        }
        
        return items;
    }
}
