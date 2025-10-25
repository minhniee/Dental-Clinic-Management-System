package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;

@WebServlet("/admin/test-report")
public class TestReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !currentUser.getRole().getRoleName().equals("Administrator")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            System.out.println("TestReportServlet: Starting doGet");
            System.out.println("TestReportServlet: User: " + currentUser.getFullName());
            System.out.println("TestReportServlet: Role: " + currentUser.getRole().getRoleName());
            
            request.setAttribute("message", "Test servlet hoạt động bình thường!");
            request.setAttribute("user", currentUser.getFullName());
            
            request.getRequestDispatcher("/admin/test-report.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("TestReportServlet: Error occurred: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
