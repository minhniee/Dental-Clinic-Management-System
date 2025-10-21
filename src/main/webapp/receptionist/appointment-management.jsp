<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Management - Dental Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .patient-search-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .appointment-form-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .patient-info-display {
            background: #e8f5e8;
            border: 1px solid #28a745;
            border-radius: 5px;
            padding: 15px;
            margin: 10px 0;
            display: none;
        }
        .form-section {
            margin-bottom: 25px;
        }
        .section-title {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #3498db;
        }
        .btn-custom {
            border-radius: 25px;
            padding: 8px 20px;
            font-weight: 500;
        }
        .alert-custom {
            border-radius: 10px;
            border: none;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 bg-dark text-white min-vh-100 p-0">
                <div class="p-3">
                    <h4 class="text-center mb-4">Dental Clinic</h4>
                    <nav class="nav flex-column">
                        <a class="nav-link text-white" href="dashboard.jsp">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                        <a class="nav-link text-white active" href="appointment-management.jsp">
                            <i class="fas fa-calendar-plus me-2"></i>Appointments
                        </a>
                        <a class="nav-link text-white" href="patients.jsp">
                            <i class="fas fa-users me-2"></i>Patients
                        </a>
                        <a class="nav-link text-white" href="queue.jsp">
                            <i class="fas fa-list-ol me-2"></i>Queue
                        </a>
                        <a class="nav-link text-white" href="invoices.jsp">
                            <i class="fas fa-file-invoice me-2"></i>Billing
                        </a>
                    </nav>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="fas fa-calendar-plus me-2"></i>Appointment Management</h2>
                    <div>
                        <button class="btn btn-primary btn-custom" onclick="showAppointmentForm()">
                            <i class="fas fa-plus me-2"></i>New Appointment
                        </button>
                    </div>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-custom alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-custom alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Patient Search Section -->
                <div class="patient-search-section">
                    <h5 class="section-title">
                        <i class="fas fa-search me-2"></i>Patient Search
                    </h5>
                    <form id="patientSearchForm">
                        <div class="row">
                            <div class="col-md-4">
                                <label for="searchPhone" class="form-label">Phone Number</label>
                                <input type="tel" class="form-control" id="searchPhone" name="phone" 
                                       placeholder="Enter phone number">
                            </div>
                            <div class="col-md-4">
                                <label for="searchEmail" class="form-label">Email Address</label>
                                <input type="email" class="form-control" id="searchEmail" name="email" 
                                       placeholder="Enter email address">
                            </div>
                            <div class="col-md-4 d-flex align-items-end">
                                <button type="button" class="btn btn-primary btn-custom w-100" onclick="searchPatient()">
                                    <i class="fas fa-search me-2"></i>Search Patient
                                </button>
                            </div>
                        </div>
                    </form>
                    
                    <!-- Patient Info Display -->
                    <div id="patientInfoDisplay" class="patient-info-display">
                        <h6><i class="fas fa-user me-2"></i>Patient Found</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Name:</strong> <span id="foundPatientName"></span></p>
                                <p><strong>Phone:</strong> <span id="foundPatientPhone"></span></p>
                                <p><strong>Email:</strong> <span id="foundPatientEmail"></span></p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Address:</strong> <span id="foundPatientAddress"></span></p>
                                <p><strong>Gender:</strong> <span id="foundPatientGender"></span></p>
                                <p><strong>Birth Date:</strong> <span id="foundPatientBirthDate"></span></p>
                            </div>
                        </div>
                        <button type="button" class="btn btn-success btn-custom" onclick="useFoundPatient()">
                            <i class="fas fa-check me-2"></i>Use This Patient
                        </button>
                    </div>
                </div>

                <!-- Appointment Form Section -->
                <div id="appointmentFormSection" class="appointment-form-section" style="display: none;">
                    <h5 class="section-title">
                        <i class="fas fa-calendar-plus me-2"></i>Create New Appointment
                    </h5>
                    
                    <form id="appointmentForm" method="post" action="appointment-management">
                        <input type="hidden" name="action" value="createAppointment">
                        <input type="hidden" id="patientId" name="patientId">
                        
                        <!-- Patient Information -->
                        <div class="form-section">
                            <h6 class="text-primary mb-3">
                                <i class="fas fa-user me-2"></i>Patient Information
                            </h6>
                            <div class="row">
                                <div class="col-md-6">
                                    <label for="fullName" class="form-label">Full Name *</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="phone" class="form-label">Phone Number *</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" required>
                                </div>
                            </div>
                            <div class="row mt-3">
                                <div class="col-md-6">
                                    <label for="email" class="form-label">Email Address</label>
                                    <input type="email" class="form-control" id="email" name="email">
                                </div>
                                <div class="col-md-6">
                                    <label for="gender" class="form-label">Gender</label>
                                    <select class="form-select" id="gender" name="gender">
                                        <option value="">Select Gender</option>
                                        <option value="Male">Male</option>
                                        <option value="Female">Female</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row mt-3">
                                <div class="col-md-6">
                                    <label for="birthDate" class="form-label">Birth Date</label>
                                    <input type="date" class="form-control" id="birthDate" name="birthDate">
                                </div>
                                <div class="col-md-6">
                                    <label for="address" class="form-label">Address</label>
                                    <input type="text" class="form-control" id="address" name="address">
                                </div>
                            </div>
                        </div>

                        <!-- Appointment Details -->
                        <div class="form-section">
                            <h6 class="text-primary mb-3">
                                <i class="fas fa-calendar me-2"></i>Appointment Details
                            </h6>
                            <div class="row">
                                <div class="col-md-4">
                                    <label for="dentistId" class="form-label">Dentist *</label>
                                    <select class="form-select" id="dentistId" name="dentistId" required>
                                        <option value="">Select Dentist</option>
                                        <c:forEach var="dentist" items="${dentists}">
                                            <option value="${dentist.userId}">${dentist.fullName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label for="serviceId" class="form-label">Service *</label>
                                    <select class="form-select" id="serviceId" name="serviceId" required>
                                        <option value="">Select Service</option>
                                        <c:forEach var="service" items="${services}">
                                            <option value="${service.serviceId}" data-duration="${service.durationMinutes}">
                                                ${service.name} - $${service.price}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label for="appointmentDate" class="form-label">Date & Time *</label>
                                    <input type="datetime-local" class="form-control" id="appointmentDate" name="appointmentDate" required>
                                </div>
                            </div>
                            <div class="row mt-3">
                                <div class="col-md-12">
                                    <label for="notes" class="form-label">Notes</label>
                                    <textarea class="form-control" id="notes" name="notes" rows="3" 
                                              placeholder="Additional notes for the appointment"></textarea>
                                </div>
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-section text-end">
                            <button type="button" class="btn btn-secondary btn-custom me-2" onclick="hideAppointmentForm()">
                                <i class="fas fa-times me-2"></i>Cancel
                            </button>
                            <button type="submit" class="btn btn-primary btn-custom">
                                <i class="fas fa-save me-2"></i>Create Appointment
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function searchPatient() {
            const phone = document.getElementById('searchPhone').value.trim();
            const email = document.getElementById('searchEmail').value.trim();
            
            if (!phone && !email) {
                alert('Please enter either phone number or email address');
                return;
            }
            
            const formData = new FormData();
            formData.append('action', 'searchPatient');
            if (phone) formData.append('phone', phone);
            if (email) formData.append('email', email);
            
            fetch('appointment-management', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.found) {
                    document.getElementById('foundPatientName').textContent = data.fullName;
                    document.getElementById('foundPatientPhone').textContent = data.phone;
                    document.getElementById('foundPatientEmail').textContent = data.email;
                    document.getElementById('foundPatientAddress').textContent = data.address;
                    document.getElementById('foundPatientGender').textContent = data.gender;
                    document.getElementById('foundPatientBirthDate').textContent = data.birthDate;
                    document.getElementById('patientInfoDisplay').style.display = 'block';
                } else {
                    alert('Patient not found. You can create a new patient below.');
                    document.getElementById('patientInfoDisplay').style.display = 'none';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error searching for patient');
            });
        }
        
        function useFoundPatient() {
            // Fill the appointment form with found patient data
            const phone = document.getElementById('foundPatientPhone').textContent;
            const email = document.getElementById('foundPatientEmail').textContent;
            
            // Search again to get the patient ID
            const formData = new FormData();
            formData.append('action', 'searchPatient');
            if (phone) formData.append('phone', phone);
            if (email) formData.append('email', email);
            
            fetch('appointment-management', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.found) {
                    document.getElementById('patientId').value = data.patientId;
                    document.getElementById('fullName').value = data.fullName;
                    document.getElementById('phone').value = data.phone;
                    document.getElementById('email').value = data.email;
                    document.getElementById('address').value = data.address;
                    document.getElementById('gender').value = data.gender;
                    document.getElementById('birthDate').value = data.birthDate;
                    
                    // Disable patient fields since we're using existing patient
                    document.getElementById('fullName').readOnly = true;
                    document.getElementById('phone').readOnly = true;
                    document.getElementById('email').readOnly = true;
                    document.getElementById('address').readOnly = true;
                    document.getElementById('gender').disabled = true;
                    document.getElementById('birthDate').readOnly = true;
                    
                    showAppointmentForm();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error loading patient data');
            });
        }
        
        function showAppointmentForm() {
            document.getElementById('appointmentFormSection').style.display = 'block';
            // Set minimum date to today
            const today = new Date().toISOString().slice(0, 16);
            document.getElementById('appointmentDate').min = today;
        }
        
        function hideAppointmentForm() {
            document.getElementById('appointmentFormSection').style.display = 'none';
            document.getElementById('appointmentForm').reset();
            document.getElementById('patientId').value = '';
            document.getElementById('patientInfoDisplay').style.display = 'none';
            
            // Re-enable patient fields
            document.getElementById('fullName').readOnly = false;
            document.getElementById('phone').readOnly = false;
            document.getElementById('email').readOnly = false;
            document.getElementById('address').readOnly = false;
            document.getElementById('gender').disabled = false;
            document.getElementById('birthDate').readOnly = false;
        }
        
        // Auto-fill appointment time based on service duration
        document.getElementById('serviceId').addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            const duration = selectedOption.getAttribute('data-duration');
            if (duration) {
                console.log('Service duration: ' + duration + ' minutes');
            }
        });
    </script>
</body>
</html>
