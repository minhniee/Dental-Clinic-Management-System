package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet("/test-dashboard")
public class TestDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Test Dashboard</title></head><body>");
        out.println("<h1>Dashboard Test</h1>");
        
        try {
            // Test 1: Basic servlet
            out.println("<p>✅ Servlet is working</p>");
            
            // Test 2: Session
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                out.println("<p>✅ Session is working</p>");
            } else {
                out.println("<p>❌ No session or user</p>");
            }
            
            // Test 3: Date handling
            LocalDate today = LocalDate.now();
            Date todaySqlDate = Date.valueOf(today);
            out.println("<p>✅ Date handling: " + today + " -> " + todaySqlDate + "</p>");
            
            // Test 4: Database connection
            try {
                DAO.AppointmentDAO appointmentDAO = new DAO.AppointmentDAO();
                var appointments = appointmentDAO.getAppointmentsByDate(todaySqlDate);
                out.println("<p>✅ Database connection successful. Found " + appointments.size() + " appointments</p>");
            } catch (Exception e) {
                out.println("<p>❌ Database error: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
            
            // Test 5: WaitingQueueDAO
            try {
                DAO.WaitingQueueDAO waitingQueueDAO = new DAO.WaitingQueueDAO();
                var queue = waitingQueueDAO.getCurrentQueue();
                out.println("<p>✅ WaitingQueueDAO working. Found " + queue.size() + " queue items</p>");
            } catch (Exception e) {
                out.println("<p>❌ WaitingQueueDAO error: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
            
        } catch (Exception e) {
            out.println("<p>❌ Critical error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
        
        out.println("</body></html>");
    }
}
