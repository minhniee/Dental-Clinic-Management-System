<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
    <!-- Footer -->
    <footer class="bg-dark text-light py-5 mt-5">
        <div class="container">
            <div class="row">
                <!-- About Clinic -->
                <div class="col-lg-4 col-md-6 mb-4">
                    <h5 class="text-white mb-3">
                        Phòng Khám Nha Khoa DentalCare
                    </h5>
                    <p class="text-light opacity-75 mb-3">
                        Đối tác đáng tin cậy trong chăm sóc sức khỏe răng miệng. Chúng tôi cung cấp dịch vụ nha khoa toàn diện 
                        với công nghệ tiên tiến và dịch vụ tận tâm.
                    </p>
                    <div class="d-flex">
                        <a href="#" class="text-light me-3" aria-label="Facebook">
                            Facebook
                        </a>
                        <a href="#" class="text-light me-3" aria-label="Twitter">
                            Twitter
                        </a>
                        <a href="#" class="text-light me-3" aria-label="Instagram">
                            Instagram
                        </a>
                        <a href="#" class="text-light" aria-label="LinkedIn">
                            LinkedIn
                        </a>
                    </div>
                </div>
                
                <!-- Quick Links -->
                <div class="col-lg-2 col-md-6 mb-4">
                    <h6 class="text-white mb-3">Liên Kết Nhanh</h6>
                    <ul class="list-unstyled">
                        <li class="mb-2">
                            <a href="${pageContext.request.contextPath}/home" class="text-light opacity-75 text-decoration-none">
                                Trang Chủ
                            </a>
                        </li>
                        <li class="mb-2">
                            <a href="${pageContext.request.contextPath}/home#dentists" class="text-light opacity-75 text-decoration-none">
                                Bác Sĩ
                            </a>
                        </li>
                        <li class="mb-2">
                            <a href="${pageContext.request.contextPath}/home#services" class="text-light opacity-75 text-decoration-none">
                                Dịch Vụ
                            </a>
                        </li>
                        <li class="mb-2">
                            <a href="${pageContext.request.contextPath}/home#contact" class="text-light opacity-75 text-decoration-none">
                                Liên Hệ
                            </a>
                        </li>
                        <li class="mb-2">
                            <a href="${pageContext.request.contextPath}/login.jsp" class="text-light opacity-75 text-decoration-none">
                                Đăng Nhập Bệnh Nhân
                            </a>
                        </li>
                    </ul>
                </div>
                
                <!-- Contact Info -->
                <div class="col-lg-3 col-md-6 mb-4">
                    <h6 class="text-white mb-3">Thông Tin Liên Hệ</h6>
                    <div class="mb-3">
                        <p class="text-light opacity-75 mb-0">
                            123 Đường Sức Khỏe<br>
                            Quận Y Tế, Thành Phố 12345
                        </p>
                    </div>
                    <div class="mb-3">
                        <p class="text-light opacity-75 mb-0">(555) 123-4567</p>
                    </div>
                    <div class="mb-3">
                        <p class="text-light opacity-75 mb-0">info@dentalcare.com</p>
                    </div>
                    <div>
                        <p class="text-light opacity-75 mb-0">
                            Mon-Fri: 8:00 AM - 6:00 PM<br>
                            Sat: 9:00 AM - 3:00 PM<br>
                            Sun: Closed
                        </p>
                    </div>
                </div>
                
                <!-- Emergency Contact -->
                <div class="col-lg-3 col-md-6 mb-4">
                    <h6 class="text-white mb-3">Cấp Cứu</h6>
                    <div class="bg-danger bg-opacity-10 p-3 rounded">
                        <h6 class="text-danger mb-2">
                            Cấp Cứu Nha Khoa?
                        </h6>
                        <p class="text-light opacity-75 mb-2">
                            Gọi đường dây cấp cứu 24/7 của chúng tôi để được chăm sóc nha khoa khẩn cấp.
                        </p>
                        <a href="tel:+15551234567" class="btn btn-danger btn-sm">
                            (555) 123-HELP
                        </a>
                    </div>
                </div>
            </div>
            
            <hr class="my-4 border-secondary">
            
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p class="text-light opacity-75 mb-0">
                        &copy; 2024 Phòng Khám Nha Khoa DentalCare. Tất cả quyền được bảo lưu.
                    </p>
                </div>
                <div class="col-md-6 text-md-end">
                    <a href="#" class="text-light opacity-75 text-decoration-none me-3">Chính Sách Bảo Mật</a>
                    <a href="#" class="text-light opacity-75 text-decoration-none">Điều Khoản Dịch Vụ</a>
                </div>
            </div>
        </div>
    </footer>
    
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script>
        // Smooth scrolling for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
        
        // Add active class to navigation links based on current section
        window.addEventListener('scroll', function() {
            const sections = document.querySelectorAll('section[id]');
            const navLinks = document.querySelectorAll('.navbar-nav .nav-link[href^="#"]');
            
            let current = '';
            sections.forEach(section => {
                const sectionTop = section.offsetTop;
                const sectionHeight = section.clientHeight;
                if (scrollY >= (sectionTop - 200)) {
                    current = section.getAttribute('id');
                }
            });
            
            navLinks.forEach(link => {
                link.classList.remove('active');
                if (link.getAttribute('href') === '#' + current) {
                    link.classList.add('active');
                }
            });
        });
    </script>
    
    <!-- Chatbot Component -->
    <jsp:include page="chatbot.jsp" />
</body>
</html>
