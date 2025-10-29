package controller;

import DAO.AppointmentRequestDAO;
import DAO.PatientDAO;
import model.AppointmentRequest;
import model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet("/appointment-request")
public class AppointmentRequestServlet extends HttpServlet {

    private AppointmentRequestDAO appointmentRequestDAO;
    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        appointmentRequestDAO = new AppointmentRequestDAO();
        patientDAO = new PatientDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get and validate form parameters with enhanced validation
            String fullName = validateFullName(request.getParameter("fullName"));
            String email = validateEmail(request.getParameter("email"));
            String phone = validatePhone(request.getParameter("phone"));
            String serviceIdStr = request.getParameter("serviceId");
            String preferredDateStr = request.getParameter("preferredDate");
            String message = request.getParameter("message");
            String preferredDoctorIdStr = request.getParameter("preferredDoctorId");
            String preferredShift = request.getParameter("preferredShift");

            // Validate service ID
            Integer serviceId;
            try {
                if (serviceIdStr == null || serviceIdStr.trim().isEmpty()) {
                    throw new IllegalArgumentException("Vui lòng chọn dịch vụ bạn muốn đặt lịch.");
                }
                serviceId = Integer.parseInt(serviceIdStr.trim());
                if (serviceId <= 0) {
                    throw new IllegalArgumentException("Lựa chọn dịch vụ không hợp lệ.");
                }
            } catch (NumberFormatException e) {
                sendErrorResponse(request, response, "Mã dịch vụ không hợp lệ. Vui lòng chọn lại dịch vụ.");
                return;
            }

            // Parse and validate preferred doctor ID (optional)
            Integer preferredDoctorId = null;
            if (preferredDoctorIdStr != null && !preferredDoctorIdStr.trim().isEmpty()) {
                try {
                    preferredDoctorId = Integer.parseInt(preferredDoctorIdStr.trim());
                    if (preferredDoctorId <= 0) {
                        preferredDoctorId = null;
                    }
                } catch (NumberFormatException e) {
                    // If invalid, just ignore it since it's optional
                    preferredDoctorId = null;
                }
            }

            // Validate preferred date using the new method
            LocalDate preferredDate = validatePreferredDate(preferredDateStr);

            // Validate message length if provided
            if (message != null && message.trim().length() > 500) {
                throw new IllegalArgumentException("Ghi chú không được vượt quá 500 ký tự.");
            }

            // Create appointment request object
            AppointmentRequest appointmentRequest = new AppointmentRequest();
            appointmentRequest.setFullName(fullName.trim());
            appointmentRequest.setEmail(email.trim());
            appointmentRequest.setPhone(phone.trim());
            appointmentRequest.setServiceId(serviceId);
            appointmentRequest.setPreferredDoctorId(preferredDoctorId);
            appointmentRequest.setPreferredDate(preferredDate);
            appointmentRequest.setPreferredShift(preferredShift);
            appointmentRequest.setNotes(message != null ? message.trim() : null);
            appointmentRequest.setStatus("PENDING");

            // Link to existing patient by phone if available
            try {
                Patient existing = patientDAO.getPatientByPhone(phone.trim());
                if (existing != null) {
                    appointmentRequest.setPatientId(existing.getPatientId());
                }
            } catch (Exception ignore) {
                // Non-blocking: if lookup fails, continue without patientId
            }

            // Save to database
            boolean success = appointmentRequestDAO.createAppointmentRequest(appointmentRequest);

            if (success) {
                // Send success response
                sendSuccessResponse(request, response, 
                    "Yêu cầu đặt lịch hẹn của bạn đã được gửi thành công! " +
                    "Chúng tôi sẽ liên hệ với bạn trong vòng 24 giờ để xác nhận lịch hẹn.");
            } else {
                sendErrorResponse(request, response, 
                    "Không thể gửi yêu cầu đặt lịch hẹn. Vui lòng thử lại.");
            }

        } catch (IllegalArgumentException e) {
            sendErrorResponse(request, response, e.getMessage());
        } catch (Exception e) {
            // Log the error
            getServletContext().log("Error processing appointment request", e);
            sendErrorResponse(request, response, 
                "Đã xảy ra lỗi không mong muốn. Vui lòng thử lại sau.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Redirect GET requests to home page
        response.sendRedirect(request.getContextPath() + "/home");
    }

    /**
     * Validate required fields
     */
    private String validateRequired(String value, String fieldName) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(fieldName + " là bắt buộc. Vui lòng điền thông tin này.");
        }
        // Check for minimum length
        if (value.trim().length() < 2) {
            throw new IllegalArgumentException(fieldName + " phải có ít nhất 2 ký tự.");
        }
        // Check for maximum length
        if (value.trim().length() > 100) {
            throw new IllegalArgumentException(fieldName + " không được vượt quá 100 ký tự.");
        }
        return value;
    }

    /**
     * Validate email format
     */
    private String validateEmail(String email) {
        email = validateRequired(email, "Email");
        
        // Remove extra spaces
        email = email.trim().toLowerCase();
        
        // Check email format
        String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
        if (!email.matches(emailRegex)) {
            throw new IllegalArgumentException("Địa chỉ email không hợp lệ. Vui lòng nhập email đúng định dạng (ví dụ: nguyenvana@gmail.com).");
        }
        
        // Check email length
        if (email.length() > 100) {
            throw new IllegalArgumentException("Email không được vượt quá 100 ký tự.");
        }
        
        return email;
    }

    /**
     * Validate phone number
     */
    private String validatePhone(String phone) {
        phone = validateRequired(phone, "Số điện thoại");
        
        // Remove spaces, dashes, parentheses
        String cleanedPhone = phone.replaceAll("[\\s\\-\\(\\)]", "");
        
        // Check if phone contains only digits
        if (!cleanedPhone.matches("^[0-9]+$")) {
            throw new IllegalArgumentException("Số điện thoại chỉ được chứa chữ số. Vui lòng nhập lại.");
        }
        
        // Check phone length (Vietnamese phone numbers are typically 10 digits)
        if (cleanedPhone.length() < 10 || cleanedPhone.length() > 11) {
            throw new IllegalArgumentException("Số điện thoại phải có từ 10 đến 11 chữ số.");
        }
        
        // Check if phone starts with 0 or +84
        if (!cleanedPhone.startsWith("0") && !cleanedPhone.startsWith("+84")) {
            throw new IllegalArgumentException("Số điện thoại Việt Nam phải bắt đầu bằng 0 hoặc +84.");
        }
        
        return phone;
    }

    /**
     * Validate full name
     */
    private String validateFullName(String fullName) {
        fullName = validateRequired(fullName, "Họ và tên");
        
        // Check if name contains only letters, spaces, and common Vietnamese characters
        if (!fullName.matches("^[\\p{L}\\s]+$")) {
            throw new IllegalArgumentException("Họ và tên chỉ được chứa chữ cái và khoảng trắng.");
        }
        
        // Check name length
        if (fullName.trim().length() < 5) {
            throw new IllegalArgumentException("Họ và tên phải có ít nhất 5 ký tự.");
        }
        
        if (fullName.trim().length() > 50) {
            throw new IllegalArgumentException("Họ và tên không được vượt quá 50 ký tự.");
        }
        
        return fullName.trim();
    }

    /**
     * Validate preferred date
     */
    private LocalDate validatePreferredDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Ngày ưa thích là bắt buộc.");
        }
        
        LocalDate preferredDate;
        try {
            preferredDate = LocalDate.parse(dateStr);
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("Định dạng ngày không hợp lệ. Vui lòng chọn lại ngày.");
        }
        
        // Check if date is in the past
        if (preferredDate.isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Ngày ưa thích không thể là ngày trong quá khứ. Vui lòng chọn ngày khác.");
        }
        
        // Check if date is too far in the future (e.g., more than 90 days)
        if (preferredDate.isAfter(LocalDate.now().plusDays(90))) {
            throw new IllegalArgumentException("Ngày hẹn không thể vượt quá 90 ngày kể từ hôm nay.");
        }
        
        return preferredDate;
    }

    /**
     * Send success response
     */
    private void sendSuccessResponse(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        
        // Store success message in session
        request.getSession().setAttribute("successMessage", message);
        
        // Redirect to home page
        response.sendRedirect(request.getContextPath() + "/home");
    }

    /**
     * Send error response
     */
    private void sendErrorResponse(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        
        // Store error message in session
        request.getSession().setAttribute("errorMessage", message);
        
        // Redirect to home page
        response.sendRedirect(request.getContextPath() + "/home");
    }
}
