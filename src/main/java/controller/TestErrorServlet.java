package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Test servlet to demonstrate error pages
 * Remove this in production - it's only for testing purposes
 */
@WebServlet("/test-error")
public class TestErrorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String errorType = request.getParameter("type");
        
        if ("404".equals(errorType)) {
            // Simulate 404 error
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Test 404 Error");
        } else if ("500".equals(errorType)) {
            // Simulate 500 error
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Test 500 Error");
        } else {
            // Show available test options
            response.setContentType("text/html");
            response.getWriter().println("""
                <html>
                <head><title>Error Page Test</title></head>
                <body>
                    <h2>Error Page Test</h2>
                    <p>Click the links below to test error pages:</p>
                    <ul>
                        <li><a href="?type=404">Test 404 Error Page</a></li>
                        <li><a href="?type=500">Test 500 Error Page</a></li>
                    </ul>
                    <p><a href="../home">Back to Home</a></p>
                </body>
                </html>
                """);
        }
    }
}
