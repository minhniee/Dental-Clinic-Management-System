package controller;

import context.DBContext;
import model.MedicalRecord;
import model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/prescription-form")
public class PrescriptionFormServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            String patientIdStr = request.getParameter("patientId");
            String recordIdStr = request.getParameter("recordId");
            
            if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "ID bệnh nhân không được để trống");
                request.getRequestDispatcher("/dentist/patient-list.jsp").forward(request, response);
                return;
            }
            
            int patientId = Integer.parseInt(patientIdStr);
            int recordId = 0;
            
            if (recordIdStr != null && !recordIdStr.trim().isEmpty()) {
                recordId = Integer.parseInt(recordIdStr);
            }
            
            // Get patient information
            Patient patient = getPatientById(patientId);
            if (patient == null) {
                request.setAttribute("errorMessage", "Không tìm thấy bệnh nhân với ID: " + patientId);
                request.getRequestDispatcher("/dentist/patient-list.jsp").forward(request, response);
                return;
            }
            
            // Get medical record if recordId is provided
            MedicalRecord medicalRecord = null;
            if (recordId > 0) {
                medicalRecord = getMedicalRecordById(recordId);
            }
            
            request.setAttribute("patient", patient);
            request.setAttribute("recordId", recordId);
            request.setAttribute("medicalRecord", medicalRecord);
            
            request.getRequestDispatcher("/dentist/prescription-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID bệnh nhân không hợp lệ");
            request.getRequestDispatcher("/dentist/patient-list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/dentist/patient-list.jsp").forward(request, response);
        }
    }
    
    private Patient getPatientById(int patientId) {
        String sql = "SELECT patient_id, full_name, birth_date, phone, email, address, avatar FROM Patients WHERE patient_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, patientId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                Patient patient = new Patient();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setFullName(rs.getString("full_name"));
                
                // Handle birth_date
                java.sql.Date birthDate = rs.getDate("birth_date");
                if (birthDate != null) {
                    patient.setBirthDate(birthDate.toLocalDate());
                }
                
                patient.setPhone(rs.getString("phone"));
                patient.setEmail(rs.getString("email"));
                patient.setAddress(rs.getString("address"));
                patient.setAvatar(rs.getString("avatar"));
                
                return patient;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    private MedicalRecord getMedicalRecordById(int recordId) {
        String sql = "SELECT record_id, patient_id, summary, created_at FROM MedicalRecords WHERE record_id = ?";
        
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, recordId);
            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                MedicalRecord record = new MedicalRecord();
                record.setRecordId(rs.getInt("record_id"));
                record.setPatientId(rs.getInt("patient_id"));
                record.setSummary(rs.getString("summary"));
                
                // Handle created_at
                java.sql.Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    record.setCreatedAt(createdAt.toLocalDateTime());
                }
                
                return record;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
}