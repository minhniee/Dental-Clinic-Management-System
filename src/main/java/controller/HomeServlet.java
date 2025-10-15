package controller;

import DAO.DentistDAO;
import DAO.ServiceDAO;
import model.User;
import model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private DentistDAO dentistDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        dentistDAO = new DentistDAO();
        serviceDAO = new ServiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Load dentists from database
            List<User> dentists = dentistDAO.getAllActiveDentists();
            request.setAttribute("dentists", dentists);
            
            // Load services from database
            List<Service> services = serviceDAO.getAllActiveServices();
            request.setAttribute("services", services);
            
            // Forward to home page
            request.getRequestDispatcher("/home.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Log the error
            getServletContext().log("Error loading homepage data", e);
            e.printStackTrace(); // Print stack trace for debugging
            
            // Set empty lists to avoid null pointer exceptions
            request.setAttribute("dentists", new ArrayList<>());
            request.setAttribute("services", new ArrayList<>());
            request.setAttribute("errorMessage", "Unable to load page content. Please try again later.");
            
            // Forward to home page with error message
            request.getRequestDispatcher("/home.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Redirect POST requests to GET for home page
        response.sendRedirect(request.getContextPath() + "/home");
    }
}
