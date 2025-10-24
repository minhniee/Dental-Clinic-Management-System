package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import context.DBContext;
import model.Patient;
import model.MedicalRecord;

@WebServlet("/examination-form")
public class ExaminationFormServlet extends HttpServlet {
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
            
            if (patientIdStr == null || recordIdStr == null) {
                response.sendRedirect(request.getContextPath() + "/medical-record?action=form&patientId=" + patientIdStr);
                return;
            }
            
            int patientId = Integer.parseInt(patientIdStr);
            int recordId = Integer.parseInt(recordIdStr);
            
            // Get patient information
            Patient patient = getPatientById(patientId);
            if (patient == null) {
                request.setAttribute("errorMessage", "Không tìm thấy thông tin bệnh nhân");
                request.getRequestDispatcher("/dentist/examination-form.jsp").forward(request, response);
                return;
            }
            
            // Get medical record information
            MedicalRecord record = getMedicalRecordById(recordId);
            if (record == null) {
                request.setAttribute("errorMessage", "Không tìm thấy hồ sơ y tế");
                request.getRequestDispatcher("/dentist/examination-form.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("patient", patient);
            request.setAttribute("recordId", recordId);
            request.getRequestDispatcher("/dentist/examination-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Tham số không hợp lệ");
            request.getRequestDispatcher("/dentist/examination-form.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải trang");
            request.getRequestDispatcher("/dentist/examination-form.jsp").forward(request, response);
        }
    }
    
    private Patient getPatientById(int patientId) {
        String sql = "SELECT * FROM Patients WHERE patient_id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Patient patient = new Patient();
                    patient.setPatientId(rs.getInt("patient_id"));
                    patient.setFullName(rs.getString("full_name"));
                    if (rs.getDate("birth_date") != null) {
                        patient.setBirthDate(rs.getDate("birth_date").toLocalDate());
                    }
                    patient.setPhone(rs.getString("phone"));
                    patient.setEmail(rs.getString("email"));
                    patient.setAddress(rs.getString("address"));
                    patient.setGender(rs.getString("gender"));
                    patient.setAvatar(rs.getString("avatar"));
                    return patient;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    private MedicalRecord getMedicalRecordById(int recordId) {
        String sql = "SELECT * FROM MedicalRecords WHERE record_id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, recordId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    MedicalRecord record = new MedicalRecord();
                    record.setRecordId(rs.getInt("record_id"));
                    record.setPatientId(rs.getInt("patient_id"));
                    record.setSummary(rs.getString("summary"));
                    if (rs.getTimestamp("created_at") != null) {
                        record.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    }
                    return record;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}