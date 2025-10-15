package controller;

import DAO.PatientFileDAO;
import model.PatientFile;

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
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/upload-clinical-result")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class UploadClinicalResultServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(UploadClinicalResultServlet.class.getName());
    
    private PatientFileDAO patientFileDAO = new PatientFileDAO();
    
    // Directory to store uploaded files
    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in and has permission
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get form parameters
        String patientIdStr = request.getParameter("patient_id");
        String fileDescription = request.getParameter("file_description");
        Part filePart = request.getPart("file");
        
        // Validate input
        if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Thiếu thông tin bệnh nhân");
            request.getRequestDispatcher("/dentist/upload-result.jsp").forward(request, response);
            return;
        }
        
        if (fileDescription == null || fileDescription.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập mô tả file");
            request.getRequestDispatcher("/dentist/upload-result.jsp").forward(request, response);
            return;
        }
        
        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("errorMessage", "Vui lòng chọn file để upload");
            request.getRequestDispatcher("/dentist/upload-result.jsp").forward(request, response);
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdStr);
            
            // Get file information
            String fileName = getFileName(filePart);
            String fileExtension = getFileExtension(fileName);
            
            // Validate file type
            if (!isValidFileType(fileExtension)) {
                request.setAttribute("errorMessage", "Loại file không được hỗ trợ. Chỉ chấp nhận: PDF, JPG, PNG, DOC, DOCX");
                request.getRequestDispatcher("/dentist/upload-result.jsp").forward(request, response);
                return;
            }
            
            // Create upload directory if it doesn't exist
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Generate unique filename
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            Path filePath = Paths.get(uploadPath, uniqueFileName);
            
            // Save file to disk
            try (InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, filePath, StandardCopyOption.REPLACE_EXISTING);
            }
            
            // Save file information to database
            PatientFile patientFile = new PatientFile();
            patientFile.setPatientId(patientId);
            patientFile.setContent(fileDescription.trim() + " - " + fileName);
            
            boolean success = patientFileDAO.createPatientFile(patientFile);
            
            if (success) {
                request.setAttribute("successMessage", "Upload file thành công!");
                // Redirect to patient's medical record page
                response.sendRedirect(request.getContextPath() + "/open-medical-record?patient_id=" + patientId);
            } else {
                // Delete uploaded file if database save failed
                Files.deleteIfExists(filePath);
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi lưu thông tin file");
                request.getRequestDispatcher("/dentist/upload-result.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid patient_id format: " + patientIdStr, e);
            request.setAttribute("errorMessage", "ID bệnh nhân không hợp lệ");
            request.getRequestDispatcher("/dentist/upload-result.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error uploading file for patient: " + patientIdStr, e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi upload file");
            request.getRequestDispatcher("/dentist/upload-result.jsp").forward(request, response);
        }
    }
    
    /**
     * Get filename from Part
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "unknown";
    }
    
    /**
     * Get file extension
     */
    private String getFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return "";
        }
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex == -1) {
            return "";
        }
        return fileName.substring(lastDotIndex + 1).toLowerCase();
    }
    
    /**
     * Validate file type
     */
    private boolean isValidFileType(String extension) {
        String[] allowedExtensions = {"pdf", "jpg", "jpeg", "png", "doc", "docx"};
        for (String allowedExt : allowedExtensions) {
            if (allowedExt.equals(extension)) {
                return true;
            }
        }
        return false;
    }
}
