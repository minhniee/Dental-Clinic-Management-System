package controller;

import DAO.PatientDAO;
import model.Patient;

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

@WebServlet("/dentist/patients")
public class PatientListServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(PatientListServlet.class.getName());
    
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
        
        try {
            // Get patients who haven't been examined today
            List<Patient> patientsNotExamined = patientDAO.getPatientsNotExaminedToday();
            
            // Get all patients for reference
            List<Patient> allPatients = patientDAO.getAllPatients();
            
            // Set attributes for JSP
            request.setAttribute("patientsNotExamined", patientsNotExamined);
            request.setAttribute("allPatients", allPatients);
            
            // Forward to JSP
            request.getRequestDispatcher("/dentist/patient-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error getting patient list", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải danh sách bệnh nhân");
            request.getRequestDispatcher("/dentist/dashboard.jsp").forward(request, response);
        }
    }
}
