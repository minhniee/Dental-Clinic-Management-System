<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="shared/header.jsp">
    <jsp:param name="pageTitle" value="Lỗi Máy Chủ - Phòng Khám Nha Khoa DentalCare" />
</jsp:include>

<main class="min-vh-100 d-flex align-items-center" style="background-color: #f8fafc;">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-xl-6 text-center">
                <!-- Error Icon -->
                <div class="mb-4">
                    <div class="rounded-circle bg-warning d-inline-flex align-items-center justify-content-center mb-3" 
                         style="width: 120px; height: 120px; background-color: #f59e0b;">
                        <i class="fas fa-exclamation-triangle text-white" style="font-size: 3rem;"></i>
                    </div>
                </div>
                
                <!-- Error Message -->
                <h1 class="display-4 fw-bold text-slate-900 mb-3" style="color: #0f172a;">
                    500
                </h1>
                <h2 class="h3 fw-semibold text-slate-700 mb-3" style="color: #334155;">
                    Lỗi Máy Chủ Nội Bộ
                </h2>
                <p class="lead text-slate-600 mb-4" style="color: #475569; font-size: 1.125rem; line-height: 1.6;">
                    Chúng tôi đang gặp khó khăn về mặt kỹ thuật. Đội ngũ của chúng tôi đã được thông báo và đang làm việc 
                    để giải quyết vấn đề. Vui lòng thử lại sau vài phút.
                </p>
                
                <!-- Action Buttons -->
                <div class="d-flex flex-column flex-sm-row gap-3 justify-content-center mb-5">
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary btn-lg px-4 py-3" 
                       style="background-color: #06b6d4; border-color: #06b6d4; border-radius: 0.5rem;">
                        <i class="fas fa-home me-2"></i>
                        Về Trang Chủ
                    </a>
                    <button onclick="window.location.reload()" class="btn btn-outline-primary btn-lg px-4 py-3"
                            style="border-color: #06b6d4; color: #06b6d4; border-radius: 0.5rem;">
                        <i class="fas fa-redo me-2"></i>
                        Thử Lại
                    </button>
                </div>
                
                <!-- Status Information -->
                <div class="card border-0 shadow-sm mb-4" style="border-radius: 1rem; background-color: white;">
                    <div class="card-body p-4">
                        <h5 class="card-title fw-semibold mb-3" style="color: #0f172a;">
                            <i class="fas fa-info-circle text-primary me-2" style="color: #06b6d4;"></i>
                            Điều gì đã xảy ra?
                        </h5>
                        <p class="text-slate-600 mb-3" style="color: #475569;">
                            Máy chủ gặp lỗi không mong muốn khi xử lý yêu cầu của bạn. 
                            Điều này thường là tạm thời và sẽ được giải quyết sớm.
                        </p>
                        <div class="alert alert-info border-0 mb-0" style="background-color: #f1f5f9; border-radius: 0.5rem;">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-clock text-primary me-3" style="color: #06b6d4;"></i>
                                <div>
                                    <strong style="color: #0f172a;">Thời Gian Giải Quyết Dự Kiến:</strong>
                                    <span class="text-slate-600 ms-2" style="color: #475569;">5-10 phút</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Contact Information -->
                <div class="card border-0 shadow-sm" style="border-radius: 1rem; background-color: white;">
                    <div class="card-body p-4">
                        <h5 class="card-title fw-semibold mb-3" style="color: #0f172a;">
                            <i class="fas fa-headset text-primary me-2" style="color: #06b6d4;"></i>
                            Cần Hỗ Trợ Ngay Lập Tức?
                        </h5>
                        <p class="text-slate-600 mb-3" style="color: #475569;">
                            Nếu bạn cần đặt lịch hẹn khẩn cấp, vui lòng liên hệ trực tiếp với chúng tôi:
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
                        
                        <!-- Emergency Contact -->
                        <div class="mt-4 pt-3 border-top">
                            <div class="alert alert-danger border-0 mb-0" style="background-color: #fef2f2; border-radius: 0.5rem;">
                                <div class="d-flex align-items-center">
                                    <i class="fas fa-exclamation-triangle text-danger me-3"></i>
                                    <div>
                                        <strong class="text-danger">Cấp Cứu Nha Khoa?</strong>
                                        <br>
                                        <small class="text-danger">
                                            Gọi đường dây cấp cứu 24/7 của chúng tôi: <strong>(555) 123-HELP</strong>
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Links -->
                <div class="mt-4">
                    <h6 class="fw-semibold text-slate-700 mb-3" style="color: #334155;">
                        Thử Các Trang Này:
                    </h6>
                    <div class="d-flex flex-wrap justify-content-center gap-3">
                        <a href="${pageContext.request.contextPath}/home" class="text-decoration-none">
                            <span class="badge bg-light text-primary px-3 py-2" 
                                  style="background-color: #f1f5f9; color: #06b6d4; border-radius: 0.5rem;">
                                <i class="fas fa-home me-1"></i>
                                Trang Chủ
                            </span>
                        </a>
                        <a href="${pageContext.request.contextPath}/login.jsp" class="text-decoration-none">
                            <span class="badge bg-light text-primary px-3 py-2" 
                                  style="background-color: #f1f5f9; color: #06b6d4; border-radius: 0.5rem;">
                                <i class="fas fa-sign-in-alt me-1"></i>
                                Đăng Nhập
                            </span>
                        </a>
                        <a href="tel:+15551234567" class="text-decoration-none">
                            <span class="badge bg-light text-primary px-3 py-2" 
                                  style="background-color: #f1f5f9; color: #06b6d4; border-radius: 0.5rem;">
                                <i class="fas fa-phone me-1"></i>
                                Gọi Chúng Tôi
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
    
    .alert {
        border-left: 4px solid;
    }
    
    .alert-info {
        border-left-color: #06b6d4 !important;
    }
    
    .alert-danger {
        border-left-color: #ef4444 !important;
    }
</style>

<jsp:include page="shared/footer.jsp" />
