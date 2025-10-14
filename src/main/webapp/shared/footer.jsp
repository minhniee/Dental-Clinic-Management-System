    <!-- Footer -->
    <footer class="bg-dark text-light py-5 mt-5">
        <div class="container">
            <div class="row">
                <!-- About Clinic -->
                <div class="col-lg-4 col-md-6 mb-4">
                    <h5 class="text-white mb-3">
                        <i class="fas fa-tooth text-primary me-2"></i>
                        DentalCare Clinic
                    </h5>
                    <p class="text-light opacity-75 mb-3">
                        Your trusted partner in dental health. We provide comprehensive dental care 
                        with state-of-the-art technology and compassionate service.
                    </p>
                    <div class="d-flex">
                        <a href="#" class="text-light me-3" aria-label="Facebook">
                            <i class="fab fa-facebook-f fs-5"></i>
                        </a>
                        <a href="#" class="text-light me-3" aria-label="Twitter">
                            <i class="fab fa-twitter fs-5"></i>
                        </a>
                        <a href="#" class="text-light me-3" aria-label="Instagram">
                            <i class="fab fa-instagram fs-5"></i>
                        </a>
                        <a href="#" class="text-light" aria-label="LinkedIn">
                            <i class="fab fa-linkedin-in fs-5"></i>
                        </a>
                    </div>
                </div>
                
                <!-- Quick Links -->
                <div class="col-lg-2 col-md-6 mb-4">
                    <h6 class="text-white mb-3">Quick Links</h6>
                    <ul class="list-unstyled">
                        <li class="mb-2">
                            <a href="${pageContext.request.contextPath}/home" class="text-light opacity-75 text-decoration-none">
                                Home
                            </a>
                        </li>
                        <li class="mb-2">
                            <a href="${pageContext.request.contextPath}/home#dentists" class="text-light opacity-75 text-decoration-none">
                                Our Dentists
                            </a>
                        </li>
                        <li class="mb-2">
                            <a href="${pageContext.request.contextPath}/home#services" class="text-light opacity-75 text-decoration-none">
                                Services
                            </a>
                        </li>
                        <li class="mb-2">
                            <a href="${pageContext.request.contextPath}/home#contact" class="text-light opacity-75 text-decoration-none">
                                Contact
                            </a>
                        </li>
                        <li class="mb-2">
                            <a href="${pageContext.request.contextPath}/login.jsp" class="text-light opacity-75 text-decoration-none">
                                Patient Login
                            </a>
                        </li>
                    </ul>
                </div>
                
                <!-- Contact Info -->
                <div class="col-lg-3 col-md-6 mb-4">
                    <h6 class="text-white mb-3">Contact Info</h6>
                    <div class="d-flex align-items-start mb-3">
                        <i class="fas fa-map-marker-alt text-primary me-3 mt-1"></i>
                        <div>
                            <p class="text-light opacity-75 mb-0">
                                123 Health Street<br>
                                Medical District, City 12345
                            </p>
                        </div>
                    </div>
                    <div class="d-flex align-items-center mb-3">
                        <i class="fas fa-phone text-primary me-3"></i>
                        <p class="text-light opacity-75 mb-0">(555) 123-4567</p>
                    </div>
                    <div class="d-flex align-items-center mb-3">
                        <i class="fas fa-envelope text-primary me-3"></i>
                        <p class="text-light opacity-75 mb-0">info@dentalcare.com</p>
                    </div>
                    <div class="d-flex align-items-start">
                        <i class="fas fa-clock text-primary me-3 mt-1"></i>
                        <div>
                            <p class="text-light opacity-75 mb-0">
                                Mon-Fri: 8:00 AM - 6:00 PM<br>
                                Sat: 9:00 AM - 3:00 PM<br>
                                Sun: Closed
                            </p>
                        </div>
                    </div>
                </div>
                
                <!-- Emergency Contact -->
                <div class="col-lg-3 col-md-6 mb-4">
                    <h6 class="text-white mb-3">Emergency</h6>
                    <div class="bg-danger bg-opacity-10 p-3 rounded">
                        <h6 class="text-danger mb-2">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Dental Emergency?
                        </h6>
                        <p class="text-light opacity-75 mb-2">
                            Call our 24/7 emergency line for urgent dental care.
                        </p>
                        <a href="tel:+15551234567" class="btn btn-danger btn-sm">
                            <i class="fas fa-phone me-1"></i>
                            (555) 123-HELP
                        </a>
                    </div>
                </div>
            </div>
            
            <hr class="my-4 border-secondary">
            
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p class="text-light opacity-75 mb-0">
                        &copy; 2024 DentalCare Clinic. All rights reserved.
                    </p>
                </div>
                <div class="col-md-6 text-md-end">
                    <a href="#" class="text-light opacity-75 text-decoration-none me-3">Privacy Policy</a>
                    <a href="#" class="text-light opacity-75 text-decoration-none">Terms of Service</a>
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
</body>
</html>
