<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page pageEncoding="UTF-8" %>

<jsp:include page="shared/header.jsp">
    <jsp:param name="pageTitle" value="Phòng Khám Nha Khoa DentalCare - Nụ Cười Của Bạn, Ưu Tiên Của Chúng Tôi" />
</jsp:include>

<main>
    <!-- Hero Section -->
    <section class="hero-section bg-white py-5">
        <div class="container">
            <div class="row align-items-center min-vh-75">
                <div class="col-lg-6">
                    <h1 class="display-4 fw-bold text-slate-900 mb-4" style="color: #0f172a;">
                        Nụ Cười Của Bạn, Ưu Tiên Của Chúng Tôi
                    </h1>
                    <p class="lead text-slate-600 mb-4" style="color: #475569; font-size: 1.25rem; line-height: 1.6;">
                        Trải nghiệm dịch vụ nha khoa đẳng cấp thế giới với đội ngũ chuyên gia chuyên nghiệp. 
                        Chúng tôi cung cấp dịch vụ nha khoa toàn diện sử dụng công nghệ tiên tiến nhất 
                        để đảm bảo sức khỏe răng miệng và nụ cười đẹp của bạn.
                    </p>
                    <div class="d-flex flex-wrap gap-3">
                        <a href="#contact" class="btn btn-primary btn-lg px-4 py-3" 
                           style="background-color: #06b6d4; border-color: #06b6d4; border-radius: 0.5rem;">
                            <i class="fas fa-calendar-plus me-2"></i>
                            Đặt Lịch Hẹn
                        </a>
                        <a href="#dentists" class="btn btn-outline-primary btn-lg px-4 py-3"
                           style="border-color: #06b6d4; color: #06b6d4; border-radius: 0.5rem; text-decoration: none; background-color: transparent;">
                            <i class="fas fa-user-md me-2"></i>
                            Gặp Gỡ Đội Ngũ
                        </a>
                    </div>
                </div>
                <div class="col-lg-6 text-center">
                    <div class="hero-image-placeholder bg-light rounded-3 p-5" 
                         style="background-color: #f8fafc; min-height: 400px; display: flex; align-items: center; justify-content: center;">
                        <div class="text-center">
                            <i class="fas fa-tooth text-primary mb-3" style="font-size: 4rem; color: #06b6d4;"></i>
                            <h5 class="text-slate-600" style="color: #475569;">Chăm Sóc Nha Khoa Chuyên Nghiệp</h5>
                            <p class="text-slate-500" style="color: #64748b;">Thiết bị hiện đại và dịch vụ tận tâm</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Alert Messages -->
    <c:if test="${not empty successMessage}">
        <div class="container mt-4">
            <div class="alert alert-success alert-dismissible fade show" role="alert" style="position: fixed; top: 100px; left: 50%; transform: translateX(-50%); z-index: 1050; min-width: 400px; max-width: 600px;">
                <i class="fas fa-check-circle me-2"></i>
                ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
    </c:if>
    
    <c:if test="${not empty errorMessage}">
        <div class="container mt-4">
            <div class="alert alert-danger alert-dismissible fade show" role="alert" style="position: fixed; top: 100px; left: 50%; transform: translateX(-50%); z-index: 1050; min-width: 400px; max-width: 600px;">
                <i class="fas fa-exclamation-triangle me-2"></i>
                ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
    </c:if>

    <!-- Dentists Section -->
    <section id="dentists" class="py-5" style="background-color: #f8fafc;">
        <div class="container">
            <div class="row">
                <div class="col-12 text-center mb-5">
                    <h2 class="display-5 fw-bold text-slate-900 mb-3" style="color: #0f172a;">
                        Gặp Gỡ Các Bác Sĩ Nha Khoa Chuyên Gia
                    </h2>
                    <p class="lead text-slate-600" style="color: #475569;">
                        Đội ngũ chuyên gia nha khoa giàu kinh nghiệm của chúng tôi cam kết mang đến cho bạn dịch vụ chăm sóc tốt nhất.
                    </p>
                </div>
            </div>
            
            <c:choose>
                <c:when test="${not empty dentists}">
                    <div class="row g-4">
                        <c:forEach var="dentist" items="${dentists}">
                            <div class="col-lg-4 col-md-6">
                                <div class="card h-100 border-0 shadow-sm" 
                                     style="border-radius: 1rem; transition: all 0.3s ease;">
                                    <div class="card-body p-4 text-center">
                                        <!-- Profile Image Placeholder -->
                                        <div class="mb-4">
                                            <div class="rounded-circle bg-primary d-inline-flex align-items-center justify-content-center" 
                                                 style="width: 120px; height: 120px; background-color: #06b6d4;">
                                                <i class="fas fa-user text-white" style="font-size: 3rem;"></i>
                                            </div>
                                        </div>
                                        
                                        <!-- Dentist Info -->
                                        <h5 class="card-title fw-semibold text-slate-900 mb-2" style="color: #0f172a; font-size: 1.25rem;">
                                            ${dentist.fullName}
                                        </h5>
                                        
                                        <c:if test="${not empty dentist.employee and not empty dentist.employee.position}">
                                            <p class="text-primary mb-3" style="color: #06b6d4; font-weight: 500;">
                                                ${dentist.employee.position}
                                            </p>
                                        </c:if>
                                        
                                        <c:if test="${not empty dentist.employee and not empty dentist.employee.hireDate}">
                                            <p class="text-slate-500 mb-3" style="color: #64748b; font-size: 0.875rem;">
                                                <i class="fas fa-calendar-alt me-1"></i>
                                                Since ${dentist.employee.hireDate}
                                            </p>
                                        </c:if>
                                        
                                        <!-- Qualifications Badge -->
                                        <div class="mb-3">
                                            <span class="badge bg-light text-primary px-3 py-2" 
                                                  style="background-color: #f1f5f9; color: #06b6d4; border-radius: 0.5rem;">
                                                <i class="fas fa-graduation-cap me-1"></i>
                                                Chuyên Gia Có Giấy Phép
                                            </span>
                                        </div>
                                        
                                        <!-- Contact Info -->
                                        <div class="text-start">
                                            <c:if test="${not empty dentist.phone}">
                                                <p class="mb-2" style="font-size: 0.875rem;">
                                                    <i class="fas fa-phone text-primary me-2" style="color: #06b6d4;"></i>
                                                    ${dentist.phone}
                                                </p>
                                            </c:if>
                                            <c:if test="${not empty dentist.email}">
                                                <p class="mb-0" style="font-size: 0.875rem;">
                                                    <i class="fas fa-envelope text-primary me-2" style="color: #06b6d4;"></i>
                                                    ${dentist.email}
                                                </p>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row">
                        <div class="col-12 text-center">
                            <div class="py-5">
                                <i class="fas fa-user-md text-muted mb-3" style="font-size: 3rem;"></i>
                                <h5 class="text-muted">Hiện tại chưa có bác sĩ nào</h5>
                                <p class="text-muted">Vui lòng kiểm tra lại sau hoặc liên hệ trực tiếp với chúng tôi.</p>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <!-- Services Section -->
    <section id="services" class="py-5 bg-white">
        <div class="container">
            <div class="row">
                <div class="col-12 text-center mb-5">
                    <h2 class="display-5 fw-bold text-slate-900 mb-3" style="color: #0f172a;">
                        Dịch Vụ Của Chúng Tôi
                    </h2>
                    <p class="lead text-slate-600" style="color: #475569;">
                        Dịch vụ nha khoa toàn diện được thiết kế phù hợp với nhu cầu và ngân sách của bạn.
                    </p>
                </div>
            </div>
            
            <c:choose>
                <c:when test="${not empty services}">
                    <div class="row g-4">
                        <c:forEach var="service" items="${services}">
                            <div class="col-lg-4 col-md-6">
                                <div class="card h-100 border border-slate-200" 
                                     style="border-radius: 1rem; transition: all 0.3s ease; border-color: #e2e8f0;">
                                    <div class="card-body p-4">
                                        <!-- Service Icon -->
                                        <div class="text-center mb-4">
                                            <div class="rounded-circle bg-primary d-inline-flex align-items-center justify-content-center mb-3" 
                                                 style="width: 80px; height: 80px; background-color: #06b6d4;">
                                                <i class="fas fa-tooth text-white" style="font-size: 2rem;"></i>
                                            </div>
                                        </div>
                                        
                                        <!-- Service Info -->
                                        <h5 class="card-title fw-semibold text-slate-900 mb-3 text-center" 
                                            style="color: #0f172a; font-size: 1.25rem;">
                                            ${service.name}
                                        </h5>
                                        
                                        <c:if test="${not empty service.description}">
                                            <p class="card-text text-slate-600 mb-4" 
                                               style="color: #475569; line-height: 1.6; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden;">
                                                ${service.description}
                                            </p>
                                        </c:if>
                                        
                                        <!-- Price and Duration -->
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <div>
                                                <span class="text-primary fw-bold fs-5" style="color: #06b6d4;">
                                                    $<fmt:formatNumber value="${service.price}" pattern="#,##0.00" />
                                                </span>
                                            </div>
                                            <c:if test="${service.durationMinutes > 0}">
                                                <div>
                                                    <span class="text-slate-500" style="color: #64748b; font-size: 0.875rem;">
                                                        <i class="fas fa-clock me-1"></i>
                                                        ${service.durationMinutes} min
                                                    </span>
                                                </div>
                                            </c:if>
                                        </div>
                                        
                                        <!-- Book Button -->
                                        <div class="text-center">
                                            <a href="#contact" class="btn btn-outline-primary w-100 position-relative overflow-hidden" 
                                               style="border: 2px solid #6bd9f1; color: #193a40; border-radius: 0.5rem; padding: 0.75rem 1.5rem; font-weight: 600; transition: all 0.3s ease;">
                                                <span class="position-relative z-index-1">
                                                    <i class="fas fa-calendar-plus me-2"></i>
                                                    Đặt Dịch Vụ Này
                                                </span>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row">
                        <div class="col-12 text-center">
                            <div class="py-5">
                                <i class="fas fa-list-alt text-muted mb-3" style="font-size: 3rem;"></i>
                                <h5 class="text-muted">Hiện tại chưa có dịch vụ nào</h5>
                                <p class="text-muted">Vui lòng kiểm tra lại sau hoặc liên hệ với chúng tôi để biết thêm thông tin.</p>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <!-- Contact/Appointment Form Section -->
    <section id="contact" class="py-5" style="background-color: #f8fafc;">
        <div class="container">
            <div class="row">
                <div class="col-12 text-center mb-5">
                    <h2 class="display-5 fw-bold text-slate-900 mb-3" style="color: #0f172a;">
                        Đặt Lịch Hẹn Của Bạn
                    </h2>
                    <p class="lead text-slate-600" style="color: #475569;">
                        Sẵn sàng chăm sóc sức khỏe răng miệng của bạn? Điền vào biểu mẫu bên dưới và chúng tôi sẽ liên hệ lại với bạn sớm.
                    </p>
                </div>
            </div>
            
            <div class="row">
                <!-- Contact Form -->
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm" style="border-radius: 1rem;">
                        <div class="card-body p-4">
                            <form action="${pageContext.request.contextPath}/appointment-request" method="POST" 
                                  class="needs-validation" novalidate>
                                
                                <div class="row">
                                    <!-- Full Name -->
                                    <div class="col-md-6 mb-3">
                                        <label for="fullName" class="form-label fw-semibold" style="color: #0f172a;">
                                            Họ và Tên <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="fullName" name="fullName" 
                                               required pattern="[a-zA-ZÀ-ỹ\s]{5,50}" minlength="5" maxlength="50"
                                               placeholder="Ví dụ: Nguyễn Văn A"
                                               style="border-color: #d1d5db; border-radius: 0.5rem;">
                                        <div class="invalid-feedback">
                                            Họ và tên phải có từ 5 đến 50 ký tự, chỉ chứa chữ cái và khoảng trắng.
                                        </div>
                                    </div>
                                    
                                    <!-- Email -->
                                    <div class="col-md-6 mb-3">
                                        <label for="email" class="form-label fw-semibold" style="color: #0f172a;">
                                            Địa Chỉ Email <span class="text-danger">*</span>
                                        </label>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               required pattern="[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                                               placeholder="Ví dụ: nguyenvana@gmail.com"
                                               style="border-color: #d1d5db; border-radius: 0.5rem;">
                                        <div class="invalid-feedback">
                                            Vui lòng nhập địa chỉ email hợp lệ (ví dụ: nguyenvana@gmail.com).
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <!-- Phone -->
                                    <div class="col-md-6 mb-3">
                                        <label for="phone" class="form-label fw-semibold" style="color: #0f172a;">
                                            Số Điện Thoại <span class="text-danger">*</span>
                                        </label>
                                        <input type="tel" class="form-control" id="phone" name="phone" 
                                               required pattern="[0-9]{10,11}" minlength="10" maxlength="11"
                                               placeholder="Ví dụ: 0912345678"
                                               style="border-color: #d1d5db; border-radius: 0.5rem;">
                                        <div class="invalid-feedback">
                                            Số điện thoại phải có từ 10 đến 11 chữ số (ví dụ: 0912345678).
                                        </div>
                                    </div>
                                    
                                    <!-- Preferred Service -->
                                    <div class="col-md-6 mb-3">
                                        <label for="serviceId" class="form-label fw-semibold" style="color: #0f172a;">
                                            Dịch Vụ Ưa Thích <span class="text-danger">*</span>
                                        </label>
                                        <select class="form-select" id="serviceId" name="serviceId" required 
                                                style="border-color: #d1d5db; border-radius: 0.5rem;">
                                            <option value="">Chọn một dịch vụ</option>
                                            <c:forEach var="service" items="${services}">
                                                <option value="${service.serviceId}">
                                                    ${service.name} - $<fmt:formatNumber value="${service.price}" pattern="#,##0.00" />
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <div class="invalid-feedback">
                                            Vui lòng chọn một dịch vụ.
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <!-- Preferred Doctor -->
                                    <div class="col-md-6 mb-3">
                                        <!-- <label for="preferredDoctorId" class="form-label fw-semibold" style="color: #0f172a;">
                                            Bác Sĩ Ưa Thích (Tùy Chọn)
                                        </label> -->
                                        <select class="form-select" id="preferredDoctorId" name="preferredDoctorId" required
                                                style="border-color: #d1d5db; border-radius: 0.5rem;">
                                            <!-- <option value="">Bất kỳ bác sĩ nào có sẵn</option> -->
                                            <c:forEach var="dentist" items="${dentists}">
                                                <option value="${dentist.userId}">
                                                    ${dentist.fullName}
                                                    <c:if test="${not empty dentist.employee and not empty dentist.employee.position}">
                                                        - ${dentist.employee.position}
                                                    </c:if>
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    
                                    <!-- Preferred Date -->
                                    <div class="col-md-6 mb-3">
                                        <label for="preferredDate" class="form-label fw-semibold" style="color: #0f172a;">
                                            Ngày Ưa Thích <span class="text-danger">*</span>
                                        </label>
                                        <input type="date" class="form-control" id="preferredDate" name="preferredDate" 
                                               required style="border-color: #d1d5db; border-radius: 0.5rem;">
                                        <div class="invalid-feedback">
                                            Vui lòng chọn ngày trong tương lai.
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Preferred Shift -->
                                <div class="mb-3">
                                    <label for="preferredShift" class="form-label fw-semibold" style="color: #0f172a;">
                                        Thời Gian Ưa Thích
                                    </label>
                                    <select class="form-select" id="preferredShift" name="preferredShift" 
                                            style="border-color: #d1d5db; border-radius: 0.5rem;">
                                        <option value="">Không có sở thích</option>
                                        <option value="Morning">Sáng (8:00 - 12:00)</option>
                                        <option value="Afternoon">Chiều (13:00 - 17:00)</option>
                                    </select>
                                </div>
                                
                                <!-- Message -->
                                <div class="mb-4">
                                    <label for="message" class="form-label fw-semibold" style="color: #0f172a;">
                                        Ghi Chú Thêm
                                    </label>
                                    <textarea class="form-control" id="message" name="message" rows="4" 
                                              placeholder="Vui lòng mô tả các vấn đề nha khoa của bạn hoặc bất kỳ yêu cầu cụ thể nào..."
                                              style="border-color: #d1d5db; border-radius: 0.5rem;"></textarea>
                                </div>
                                
                                <!-- Submit Button -->
                                <div class="text-center">
                                    <button type="submit" class="btn btn-primary btn-lg px-5 py-3" 
                                            style="background-color: #06b6d4; border-color: #06b6d4; border-radius: 0.5rem; width: 100%;">
                                        <i class="fas fa-paper-plane me-2"></i>
                                        Gửi Yêu Cầu
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                
                <!-- Contact Information -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm h-100" style="border-radius: 1rem;">
                        <div class="card-body p-4">
                            <h5 class="card-title fw-bold mb-4" style="color: #0f172a;">
                                <i class="fas fa-info-circle text-primary me-2" style="color: #06b6d4;"></i>
                                Thông Tin Liên Hệ
                            </h5>
                            
                            <div class="mb-4">
                                <h6 class="fw-semibold mb-2" style="color: #0f172a;">Địa Chỉ</h6>
                                <p class="text-slate-600 mb-0" style="color: #475569;">
                                    <i class="fas fa-map-marker-alt text-primary me-2" style="color: #06b6d4;"></i>
                                    123 Đường Sức Khỏe<br>
                                    Quận Y Tế, Thành Phố 12345
                                </p>
                            </div>
                            
                            <div class="mb-4">
                                <h6 class="fw-semibold mb-2" style="color: #0f172a;">Điện Thoại</h6>
                                <p class="text-slate-600 mb-0" style="color: #475569;">
                                    <i class="fas fa-phone text-primary me-2" style="color: #06b6d4;"></i>
                                    (555) 123-4567
                                </p>
                            </div>
                            
                            <div class="mb-4">
                                <h6 class="fw-semibold mb-2" style="color: #0f172a;">Email</h6>
                                <p class="text-slate-600 mb-0" style="color: #475569;">
                                    <i class="fas fa-envelope text-primary me-2" style="color: #06b6d4;"></i>
                                    info@dentalcare.com
                                </p>
                            </div>
                            
                            <div class="mb-4">
                                <h6 class="fw-semibold mb-2" style="color: #0f172a;">Giờ Làm Việc</h6>
                                <div class="text-slate-600" style="color: #475569;">
                                    <div class="d-flex justify-content-between mb-1">
                                        <span>Thứ Hai - Thứ Sáu</span>
                                        <span>8:00 - 18:00</span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-1">
                                        <span>Thứ Bảy</span>
                                        <span>9:00 - 15:00</span>
                                    </div>
                                    <div class="d-flex justify-content-between">
                                        <span>Chủ Nhật</span>
                                        <span>Nghỉ</span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="alert alert-info border-0" style="background-color: #f1f5f9; border-radius: 0.5rem;">
                                <h6 class="alert-heading mb-2" style="color: #0f172a;">
                                    <i class="fas fa-clock text-primary me-2" style="color: #06b6d4;"></i>
                                    Thời Gian Phản Hồi
                                </h6>
                                <p class="mb-0" style="color: #475569; font-size: 0.875rem;">
                                    Chúng tôi thường phản hồi các yêu cầu đặt lịch hẹn trong vòng 24 giờ.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<!-- Form Validation Script -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Set minimum and maximum date for preferred date field
        var preferredDateInput = document.getElementById('preferredDate');
        var today = new Date();
        var maxDate = new Date();
        maxDate.setDate(today.getDate() + 90); // 90 days from today
        
        preferredDateInput.min = today.toISOString().split('T')[0];
        preferredDateInput.max = maxDate.toISOString().split('T')[0];
        
        // Validate date range on change
        preferredDateInput.addEventListener('change', function() {
            var selectedDate = new Date(this.value);
            if (selectedDate < today) {
                this.setCustomValidity('Ngày không thể là ngày trong quá khứ.');
            } else if (selectedDate > maxDate) {
                this.setCustomValidity('Ngày hẹn không thể vượt quá 90 ngày kể từ hôm nay.');
            } else {
                this.setCustomValidity('');
            }
        });
        
        // Enhanced phone validation
        var phoneInput = document.getElementById('phone');
        phoneInput.addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9]/g, ''); // Only allow numbers
        });
        
        // Auto-hide notifications after 5 seconds
        var alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            setTimeout(function() {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }, 5000);
        });
    });
    
    // Bootstrap form validation
    (function() {
        'use strict';
        window.addEventListener('load', function() {
            var forms = document.getElementsByClassName('needs-validation');
            var validation = Array.prototype.filter.call(forms, function(form) {
                form.addEventListener('submit', function(event) {
                    if (form.checkValidity() === false) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        }, false);
    })();
</script>

<jsp:include page="shared/footer.jsp" />
