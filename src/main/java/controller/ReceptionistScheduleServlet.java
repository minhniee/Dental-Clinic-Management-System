package controller;

import DAO.DoctorScheduleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.WeekFields;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.DoctorSchedule;
import model.User;

@WebServlet("/receptionist/schedule")
public class ReceptionistScheduleServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(ReceptionistScheduleServlet.class.getName());
    private final DoctorScheduleDAO doctorScheduleDAO = new DoctorScheduleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (currentUser.getRole() == null ||
                !"receptionist".equalsIgnoreCase(currentUser.getRole().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String weekParam = request.getParameter("week");
            LocalDate selectedWeek = LocalDate.now();
            if (weekParam != null && !weekParam.isEmpty()) {
                try {
                    selectedWeek = LocalDate.parse(weekParam);
                } catch (Exception ex) {
                    // fallback to current week on invalid input
                    selectedWeek = LocalDate.now();
                }
            }

            LocalDate weekStart = selectedWeek.with(WeekFields.ISO.dayOfWeek(), 1);
            LocalDate weekEnd = weekStart.plusDays(6);

            List<DoctorSchedule> allWeekSchedules = doctorScheduleDAO.getSchedulesByDateRange(weekStart, weekEnd);

            List<DoctorSchedule> mySchedules = new ArrayList<>();
            for (DoctorSchedule schedule : allWeekSchedules) {
                if (schedule.getDoctorId() == currentUser.getUserId()) {
                    mySchedules.add(schedule);
                }
            }

            LocalDate previousWeek = weekStart.minusWeeks(1);
            LocalDate nextWeek = weekStart.plusWeeks(1);

            List<LocalDate> weekDays = new ArrayList<>();
            for (int i = 0; i < 7; i++) {
                weekDays.add(weekStart.plusDays(i));
            }

            request.setAttribute("weekStart", weekStart);
            request.setAttribute("weekEnd", weekEnd);
            request.setAttribute("previousWeek", previousWeek);
            request.setAttribute("nextWeek", nextWeek);
            request.setAttribute("currentWeek", weekStart);
            request.setAttribute("scheduleList", mySchedules);
            request.setAttribute("weekDays", weekDays);

            request.getRequestDispatcher("/receptionist/schedule.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading receptionist schedule", e);
            request.setAttribute("error", "Không thể tải lịch làm việc: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/schedule.jsp").forward(request, response);
        }
    }
}


