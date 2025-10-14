<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="shared/header.jsp">
    <jsp:param name="pageTitle" value="Không Tìm Thấy Trang - Phòng Khám Nha Khoa DentalCare" />
</jsp:include>

<main class="min-vh-100 d-flex align-items-center" style="background-color: #f8fafc;">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-xl-6 text-center">
                <!-- Error Icon -->
                <div class="mb-4">
                    <div class="rounded-circle bg-primary d-inline-flex align-items-center justify-content-center mb-3" 
                         style="width: 120px; height: 120px; background-color: #06b6d4;">
                        <i class="fas fa-search text-white" style="font-size: 3rem;"></i>
                    </div>
                </div>
                
                <!-- Error Message -->
                <h1 class="display-4 fw-bold text-slate-900 mb-3" style="color: #0f172a;">
                    404
                </h1>
                <h2 class="h3 fw-semibold text-slate-700 mb-3" style="color: #334155;">
                    Không Tìm Thấy Trang
                </h2>
                <p class="lead text-slate-600 mb-4" style="color: #475569; font-size: 1.125rem; line-height: 1.6;">
                    Xin lỗi, chúng tôi không thể tìm thấy trang bạn đang tìm kiếm. Trang có thể đã được di chuyển, 
                    xóa, hoặc bạn có thể đã nhập URL không chính xác.
                </p>
                
                <!-- Action Buttons -->
                <div class="d-flex flex-column flex-sm-row gap-3 justify-content-center mb-5">
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary btn-lg px-4 py-3" 
                       style="background-color: #06b6d4; border-color: #06b6d4; border-radius: 0.5rem;">
                        <i class="fas fa-home me-2"></i>
                        Về Trang Chủ
                    </a>
                    <a href="${pageContext.request.contextPath}/home#contact" class="btn btn-outline-primary btn-lg px-4 py-3"
                       style="border-color: #06b6d4; color: #06b6d4; border-radius: 0.5rem;">
                        <i class="fas fa-calendar-plus me-2"></i>
                        Đặt Lịch Hẹn
                    </a>
                </div>
                
                <!-- Help Section -->
                <div class="card border-0 shadow-sm" style="border-radius: 1rem; background-color: white;">
                    <div class="card-body p-4">
                        <h5 class="card-title fw-semibold mb-3" style="color: #0f172a;">
                            <i class="fas fa-question-circle text-primary me-2" style="color: #06b6d4;"></i>
                            Cần Trợ Giúp?
                        </h5>
                        <p class="text-slate-600 mb-3" style="color: #475569;">
                            Nếu bạn tin rằng đây là lỗi hoặc cần hỗ trợ, vui lòng liên hệ với chúng tôi:
                        </p>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="d-flex align-items-center">
                                    <i class="fas fa-phone text-primary me-3" style="color: #06b6d4;"></i>
                                    <div>
                                        <small class="text-slate-500 d-block" style="color: #64748b;">Điện Thoại</small>
                                        <span class="fw-semibold" style="color: #0f172a;">(555) 123-4567</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="d-flex align-items-center">
                                    <i class="fas fa-envelope text-primary me-3" style="color: #06b6d4;"></i>
                                    <div>
                                        <small class="text-slate-500 d-block" style="color: #64748b;">Email</small>
                                        <span class="fw-semibold" style="color: #0f172a;">info@dentalcare.com</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Links -->
                <div class="mt-4">
                    <h6 class="fw-semibold text-slate-700 mb-3" style="color: #334155;">
                        Các Trang Phổ Biến:
                    </h6>
                    <div class="d-flex flex-wrap justify-content-center gap-3">
                        <a href="${pageContext.request.contextPath}/home" class="text-decoration-none">
                            <span class="badge bg-light text-primary px-3 py-2" 
                                  style="background-color: #f1f5f9; color: #06b6d4; border-radius: 0.5rem;">
                                <i class="fas fa-home me-1"></i>
                                Trang Chủ
                            </span>
                        </a>
                        <a href="${pageContext.request.contextPath}/home#dentists" class="text-decoration-none">
                            <span class="badge bg-light text-primary px-3 py-2" 
                                  style="background-color: #f1f5f9; color: #06b6d4; border-radius: 0.5rem;">
                                <i class="fas fa-user-md me-1"></i>
                                Bác Sĩ
                            </span>
                        </a>
                        <a href="${pageContext.request.contextPath}/home#services" class="text-decoration-none">
                            <span class="badge bg-light text-primary px-3 py-2" 
                                  style="background-color: #f1f5f9; color: #06b6d4; border-radius: 0.5rem;">
                                <i class="fas fa-list-alt me-1"></i>
                                Dịch Vụ
                            </span>
                        </a>
                        <a href="${pageContext.request.contextPath}/home#contact" class="text-decoration-none">
                            <span class="badge bg-light text-primary px-3 py-2" 
                                  style="background-color: #f1f5f9; color: #06b6d4; border-radius: 0.5rem;">
                                <i class="fas fa-envelope me-1"></i>
                                Liên Hệ
                            </span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Custom Styles for Error Page -->
<style>
    .min-vh-100 {
        min-height: 100vh;
    }
    
    .btn:hover {
        transform: translateY(-1px);
        transition: all 0.3s ease;
    }
    
    .badge:hover {
        background-color: #06b6d4 !important;
        color: white !important;
        transition: all 0.3s ease;
    }
    
    .card {
        transition: all 0.3s ease;
    }
    
    .card:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1) !important;
    }
</style>

<jsp:include page="shared/footer.jsp" />
