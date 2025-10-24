package controller;

import DAO.AppointmentDAO;
import DAO.PatientDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/dentist/dashboard")
public class DentistDashboardServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(DentistDashboardServlet.class.getName());
    private PatientDAO patientDAO;
    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        patientDAO = new PatientDAO();
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (!"Dentist".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int dentistId = currentUser.getUserId();
            
            // Get statistics for today
            int totalAppointmentsToday = appointmentDAO.getAppointmentCountForDentistToday(dentistId);
            int patientsNotExaminedToday = patientDAO.getPatientsNotExaminedToday().size();
            int patientsExaminedToday = appointmentDAO.getExaminedPatientsCountForDentistToday(dentistId);
            int patientsWaitingInQueue = appointmentDAO.getWaitingPatientsCountForDentistToday(dentistId);
            
            // Set attributes for JSP
            request.setAttribute("totalAppointmentsToday", totalAppointmentsToday);
            request.setAttribute("patientsNotExaminedToday", patientsNotExaminedToday);
            request.setAttribute("patientsExaminedToday", patientsExaminedToday);
            request.setAttribute("patientsWaitingInQueue", patientsWaitingInQueue);
            
            // Forward to dashboard JSP
            request.getRequestDispatcher("/dentist/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading dentist dashboard", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải dashboard.");
            request.getRequestDispatcher("/dentist/dashboard.jsp").forward(request, response);
        }
    }
}
