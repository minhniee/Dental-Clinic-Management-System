<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page pageEncoding="UTF-8" %>

<jsp:include page="shared/header.jsp">
    <jsp:param name="pageTitle" value="DentalCare Clinic - Your Smile, Our Priority" />
</jsp:include>

<main>
    <!-- Hero Section -->
    <section class="hero-section bg-white py-5">
        <div class="container">
            <div class="row align-items-center min-vh-75">
                <div class="col-lg-6">
                    <h1 class="display-4 fw-bold text-slate-900 mb-4" style="color: #0f172a;">
                        Your Smile, Our Priority
                    </h1>
                    <p class="lead text-slate-600 mb-4" style="color: #475569; font-size: 1.25rem; line-height: 1.6;">
                        Experience world-class dental care with our team of expert professionals. 
                        We provide comprehensive dental services using the latest technology 
                        to ensure your oral health and beautiful smile.
                    </p>
                    <div class="d-flex flex-wrap gap-3">
                        <a href="#contact" class="btn btn-primary btn-lg px-4 py-3" 
                           style="background-color: #06b6d4; border-color: #06b6d4; border-radius: 0.5rem;">
                            <i class="fas fa-calendar-plus me-2"></i>
                            Book Appointment
                        </a>
                        <a href="#dentists" class="btn btn-outline-primary btn-lg px-4 py-3"
                           style="border-color: #06b6d4; color: #06b6d4; border-radius: 0.5rem;">
                            <i class="fas fa-user-md me-2"></i>
                            Meet Our Team
                        </a>
                    </div>
                </div>
                <div class="col-lg-6 text-center">
                    <div class="hero-image-placeholder bg-light rounded-3 p-5" 
                         style="background-color: #f8fafc; min-height: 400px; display: flex; align-items: center; justify-content: center;">
                        <div class="text-center">
                            <i class="fas fa-tooth text-primary mb-3" style="font-size: 4rem; color: #06b6d4;"></i>
                            <h5 class="text-slate-600" style="color: #475569;">Professional Dental Care</h5>
                            <p class="text-slate-500" style="color: #64748b;">State-of-the-art equipment and compassionate care</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Alert Messages -->
    <c:if test="${not empty successMessage}">
        <div class="container mt-4">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
    </c:if>
    
    <c:if test="${not empty errorMessage}">
        <div class="container mt-4">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
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
                        Meet Our Expert Dentists
                    </h2>
                    <p class="lead text-slate-600" style="color: #475569;">
                        Our experienced team of dental professionals is dedicated to providing you with the best care.
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
                                                Since <fmt:formatDate value="${dentist.employee.hireDate}" pattern="yyyy" />
                                            </p>
                                        </c:if>
                                        
                                        <!-- Qualifications Badge -->
                                        <div class="mb-3">
                                            <span class="badge bg-light text-primary px-3 py-2" 
                                                  style="background-color: #f1f5f9; color: #06b6d4; border-radius: 0.5rem;">
                                                <i class="fas fa-graduation-cap me-1"></i>
                                                Licensed Professional
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
                                <h5 class="text-muted">No dentists available at the moment</h5>
                                <p class="text-muted">Please check back later or contact us directly.</p>
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
                        Our Services
                    </h2>
                    <p class="lead text-slate-600" style="color: #475569;">
                        Comprehensive dental care tailored to meet your needs and budget.
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
                                            <a href="#contact" class="btn btn-outline-primary w-100" 
                                               style="border-color: #06b6d4; color: #06b6d4; border-radius: 0.5rem;">
                                                <i class="fas fa-calendar-plus me-2"></i>
                                                Book This Service
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
                                <h5 class="text-muted">No services available at the moment</h5>
                                <p class="text-muted">Please check back later or contact us for more information.</p>
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
                        Book Your Appointment
                    </h2>
                    <p class="lead text-slate-600" style="color: #475569;">
                        Ready to take care of your dental health? Fill out the form below and we'll get back to you soon.
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
                                            Full Name <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="fullName" name="fullName" 
                                               required style="border-color: #d1d5db; border-radius: 0.5rem;">
                                        <div class="invalid-feedback">
                                            Please provide your full name.
                                        </div>
                                    </div>
                                    
                                    <!-- Email -->
                                    <div class="col-md-6 mb-3">
                                        <label for="email" class="form-label fw-semibold" style="color: #0f172a;">
                                            Email Address <span class="text-danger">*</span>
                                        </label>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               required style="border-color: #d1d5db; border-radius: 0.5rem;">
                                        <div class="invalid-feedback">
                                            Please provide a valid email address.
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <!-- Phone -->
                                    <div class="col-md-6 mb-3">
                                        <label for="phone" class="form-label fw-semibold" style="color: #0f172a;">
                                            Phone Number <span class="text-danger">*</span>
                                        </label>
                                        <input type="tel" class="form-control" id="phone" name="phone" 
                                               required style="border-color: #d1d5db; border-radius: 0.5rem;">
                                        <div class="invalid-feedback">
                                            Please provide your phone number.
                                        </div>
                                    </div>
                                    
                                    <!-- Preferred Service -->
                                    <div class="col-md-6 mb-3">
                                        <label for="serviceId" class="form-label fw-semibold" style="color: #0f172a;">
                                            Preferred Service <span class="text-danger">*</span>
                                        </label>
                                        <select class="form-select" id="serviceId" name="serviceId" required 
                                                style="border-color: #d1d5db; border-radius: 0.5rem;">
                                            <option value="">Select a service</option>
                                            <c:forEach var="service" items="${services}">
                                                <option value="${service.serviceId}">
                                                    ${service.name} - $<fmt:formatNumber value="${service.price}" pattern="#,##0.00" />
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <div class="invalid-feedback">
                                            Please select a service.
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <!-- Preferred Doctor -->
                                    <div class="col-md-6 mb-3">
                                        <label for="preferredDoctorId" class="form-label fw-semibold" style="color: #0f172a;">
                                            Preferred Doctor (Optional)
                                        </label>
                                        <select class="form-select" id="preferredDoctorId" name="preferredDoctorId" 
                                                style="border-color: #d1d5db; border-radius: 0.5rem;">
                                            <option value="">Any available doctor</option>
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
                                            Preferred Date <span class="text-danger">*</span>
                                        </label>
                                        <input type="date" class="form-control" id="preferredDate" name="preferredDate" 
                                               required style="border-color: #d1d5db; border-radius: 0.5rem;">
                                        <div class="invalid-feedback">
                                            Please select a preferred date.
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Preferred Shift -->
                                <div class="mb-3">
                                    <label for="preferredShift" class="form-label fw-semibold" style="color: #0f172a;">
                                        Preferred Time
                                    </label>
                                    <select class="form-select" id="preferredShift" name="preferredShift" 
                                            style="border-color: #d1d5db; border-radius: 0.5rem;">
                                        <option value="">No preference</option>
                                        <option value="Morning">Morning (8:00 AM - 12:00 PM)</option>
                                        <option value="Afternoon">Afternoon (1:00 PM - 5:00 PM)</option>
                                    </select>
                                </div>
                                
                                <!-- Message -->
                                <div class="mb-4">
                                    <label for="message" class="form-label fw-semibold" style="color: #0f172a;">
                                        Additional Notes
                                    </label>
                                    <textarea class="form-control" id="message" name="message" rows="4" 
                                              placeholder="Please describe your dental concerns or any specific requirements..."
                                              style="border-color: #d1d5db; border-radius: 0.5rem;"></textarea>
                                </div>
                                
                                <!-- Submit Button -->
                                <div class="text-center">
                                    <button type="submit" class="btn btn-primary btn-lg px-5 py-3" 
                                            style="background-color: #06b6d4; border-color: #06b6d4; border-radius: 0.5rem; width: 100%;">
                                        <i class="fas fa-paper-plane me-2"></i>
                                        Submit Request
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
                                Contact Information
                            </h5>
                            
                            <div class="mb-4">
                                <h6 class="fw-semibold mb-2" style="color: #0f172a;">Address</h6>
                                <p class="text-slate-600 mb-0" style="color: #475569;">
                                    <i class="fas fa-map-marker-alt text-primary me-2" style="color: #06b6d4;"></i>
                                    123 Health Street<br>
                                    Medical District, City 12345
                                </p>
                            </div>
                            
                            <div class="mb-4">
                                <h6 class="fw-semibold mb-2" style="color: #0f172a;">Phone</h6>
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
                                <h6 class="fw-semibold mb-2" style="color: #0f172a;">Business Hours</h6>
                                <div class="text-slate-600" style="color: #475569;">
                                    <div class="d-flex justify-content-between mb-1">
                                        <span>Monday - Friday</span>
                                        <span>8:00 AM - 6:00 PM</span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-1">
                                        <span>Saturday</span>
                                        <span>9:00 AM - 3:00 PM</span>
                                    </div>
                                    <div class="d-flex justify-content-between">
                                        <span>Sunday</span>
                                        <span>Closed</span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="alert alert-info border-0" style="background-color: #f1f5f9; border-radius: 0.5rem;">
                                <h6 class="alert-heading mb-2" style="color: #0f172a;">
                                    <i class="fas fa-clock text-primary me-2" style="color: #06b6d4;"></i>
                                    Response Time
                                </h6>
                                <p class="mb-0" style="color: #475569; font-size: 0.875rem;">
                                    We typically respond to appointment requests within 24 hours.
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
    // Set minimum date to today
    document.getElementById('preferredDate').min = new Date().toISOString().split('T')[0];
    
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
