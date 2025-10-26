-- ===================================================================
-- 🦷 Dental Clinic Management System - Sample Data
-- Complete sample data for all tables with proper relationships
-- ===================================================================

USE DentalClinicDB_MVP;
GO

-- ======================================================
-- 1️⃣ CLEAR EXISTING DATA (Optional - for fresh start)
-- ======================================================
-- Uncomment these lines if you want to clear existing data
/*
DELETE FROM Payments;
DELETE FROM InvoiceItems;
DELETE FROM Invoices;
DELETE FROM StockTransactions;
DELETE FROM PrescriptionItems;
DELETE FROM Prescriptions;
DELETE FROM TreatmentSessions;
DELETE FROM TreatmentPlans;
DELETE FROM Examinations;
DELETE FROM MedicalRecords;
DELETE FROM WaitingQueue;
DELETE FROM Appointments;
DELETE FROM AppointmentRequests;
DELETE FROM PatientImages;
DELETE FROM PatientFiles;
DELETE FROM Patients;
DELETE FROM ScheduleRequests;
DELETE FROM DoctorSchedules;
DELETE FROM Employees;
DELETE FROM Users;
DELETE FROM Roles;
DELETE FROM InventoryItems;
DELETE FROM Services;
DELETE FROM SystemConfigs;
GO
*/

-- ======================================================
-- 2️⃣ ROLES DATA
-- ======================================================
INSERT INTO Roles (role_name)
VALUES 
    ('Administrator'), 
    ('ClinicManager'), 
    ('Dentist'), 
    ('Receptionist'), 
    ('Patient');
GO

-- ======================================================
-- 3️⃣ USERS DATA
-- ======================================================
INSERT INTO Users (username, email, password_hash, full_name, phone, role_id, is_active)
VALUES
    -- Administrators
    ('admin', 'admin@antamclinic.com', 'admin123', N'Nguyễn Văn Admin', '0900000001', 1, 1),
    
    -- Clinic Managers
    ('manager1', 'manager@antamclinic.com', 'manager123', N'Trần Thị Manager', '0900000002', 2, 1),
    
    -- Dentists
    ('dr.minh', 'dr.minh@antamclinic.com', 'dentist123', N'BS. Nguyễn Văn Minh', '0900000003', 3, 1),
    ('dr.lan', 'dr.lan@antamclinic.com', 'dentist123', N'BS. Lê Thị Lan', '0900000004', 3, 1),
    ('dr.hung', 'dr.hung@antamclinic.com', 'dentist123', N'BS. Phạm Văn Hùng', '0900000005', 3, 1),
    ('dr.thao', 'dr.thao@antamclinic.com', 'dentist123', N'BS. Hoàng Thị Thảo', '0900000006', 3, 1),
    
    -- Receptionists
    ('reception1', 'reception1@antamclinic.com', 'reception123', N'Nguyễn Thị Mai', '0900000007', 4, 1),
    ('reception2', 'reception2@antamclinic.com', 'reception123', N'Trần Văn Nam', '0900000008', 4, 1),
    
    -- Patients (as users for online booking)
    ('patient1', 'patient1@email.com', 'patient123', N'Lê Văn An', '0900000009', 5, 1),
    ('patient2', 'patient2@email.com', 'patient123', N'Phạm Thị Bình', '0900000010', 5, 1);
GO

-- ======================================================
-- 4️⃣ EMPLOYEES DATA
-- ======================================================
INSERT INTO Employees (user_id, position, hire_date)
VALUES
    (1, N'System Administrator', '2020-01-01'),
    (2, N'Clinic Manager', '2020-02-01'),
    (3, N'Dentist - General Practice', '2020-03-01'),
    (4, N'Dentist - Orthodontist', '2020-04-01'),
    (5, N'Dentist - Oral Surgery', '2020-05-01'),
    (6, N'Dentist - Pediatric', '2020-06-01'),
    (7, N'Receptionist', '2020-07-01'),
    (8, N'Receptionist', '2020-08-01');
GO

-- ======================================================
-- 5️⃣ PATIENTS DATA
-- ======================================================
INSERT INTO Patients (full_name, birth_date, gender, phone, email, address)
VALUES
    (N'Nguyễn Văn An', '1985-03-15', 'M', '0901234567', 'nguyenvanan@email.com', N'123 Đường ABC, Quận 1, TP.HCM'),
    (N'Trần Thị Bình', '1990-07-22', 'F', '0901234568', 'tranthibinh@email.com', N'456 Đường XYZ, Quận 2, TP.HCM'),
    (N'Lê Văn Cường', '1988-11-08', 'M', '0901234569', 'levancuong@email.com', N'789 Đường DEF, Quận 3, TP.HCM'),
    (N'Phạm Thị Dung', '1992-05-14', 'F', '0901234570', 'phamthidung@email.com', N'321 Đường GHI, Quận 4, TP.HCM'),
    (N'Hoàng Văn Em', '1987-09-30', 'M', '0901234571', 'hoangvanem@email.com', N'654 Đường JKL, Quận 5, TP.HCM'),
    (N'Võ Thị Phương', '1995-01-18', 'F', '0901234572', 'vothiphuong@email.com', N'987 Đường MNO, Quận 6, TP.HCM'),
    (N'Đặng Văn Giang', '1983-12-25', 'M', '0901234573', 'dangvangiang@email.com', N'147 Đường PQR, Quận 7, TP.HCM'),
    (N'Bùi Thị Hoa', '1991-08-12', 'F', '0901234574', 'buithihoa@email.com', N'258 Đường STU, Quận 8, TP.HCM'),
    (N'Ngô Văn Inh', '1989-04-03', 'M', '0901234575', 'ngovaninh@email.com', N'369 Đường VWX, Quận 9, TP.HCM'),
    (N'Dương Thị Kim', '1993-10-27', 'F', '0901234576', 'duongthikim@email.com', N'741 Đường YZA, Quận 10, TP.HCM'),
    (N'Lý Văn Long', '1986-06-19', 'M', '0901234577', 'lyvanlong@email.com', N'852 Đường BCD, Quận 11, TP.HCM'),
    (N'Chu Thị Mai', '1994-02-11', 'F', '0901234578', 'chuthimai@email.com', N'963 Đường EFG, Quận 12, TP.HCM'),
    (N'Đinh Văn Nam', '1984-08-05', 'M', '0901234579', 'dinhvannam@email.com', N'159 Đường HIJ, Quận Bình Thạnh, TP.HCM'),
    (N'Lưu Thị Oanh', '1990-12-16', 'F', '0901234580', 'luuthioanh@email.com', N'357 Đường KLM, Quận Tân Bình, TP.HCM'),
    (N'Phan Văn Phúc', '1987-05-28', 'M', '0901234581', 'phanvanphuc@email.com', N'468 Đường NOP, Quận Phú Nhuận, TP.HCM');
GO

-- ======================================================
-- 6️⃣ SERVICES DATA
-- ======================================================
INSERT INTO Services (name, description, price, duration_minutes, is_active)
VALUES
    (N'Khám tổng quát', N'Kiểm tra sức khỏe răng miệng tổng quát', 100000, 20, 1),
    (N'Cạo vôi răng', N'Làm sạch cao răng và đánh bóng răng', 300000, 40, 1),
    (N'Trám răng', N'Trám răng sâu bằng composite', 500000, 45, 1),
    (N'Điều trị tủy', N'Điều trị tủy răng (root canal)', 1500000, 90, 1),
    (N'Nhổ răng', N'Nhổ răng khôn, răng sâu', 800000, 60, 1),
    (N'Niềng răng', N'Điều trị chỉnh nha', 5000000, 120, 1),
    (N'Làm răng giả', N'Làm cầu răng, implant', 3000000, 150, 1),
    (N'Tẩy trắng răng', N'Tẩy trắng răng bằng laser', 2000000, 90, 1),
    (N'Chữa viêm nướu', N'Điều trị viêm nướu, viêm quanh răng', 400000, 30, 1),
    (N'Khám định kỳ', N'Khám và theo dõi định kỳ', 80000, 15, 1);
GO

-- ======================================================
-- 7️⃣ DOCTOR SCHEDULES DATA
-- ======================================================
INSERT INTO DoctorSchedules (doctor_id, work_date, shift, start_time, end_time, room_no, status)
VALUES
    -- Dr. Minh (user_id = 3)
    (3, '2024-01-15', 'Morning', '08:00:00', '12:00:00', 'P001', 'ACTIVE'),
    (3, '2024-01-15', 'Afternoon', '13:00:00', '17:00:00', 'P001', 'ACTIVE'),
    (3, '2024-01-16', 'Morning', '08:00:00', '12:00:00', 'P001', 'ACTIVE'),
    (3, '2024-01-17', 'FullDay', '08:00:00', '17:00:00', 'P001', 'ACTIVE'),
    
    -- Dr. Lan (user_id = 4)
    (4, '2024-01-15', 'Morning', '08:00:00', '12:00:00', 'P002', 'ACTIVE'),
    (4, '2024-01-16', 'Afternoon', '13:00:00', '17:00:00', 'P002', 'ACTIVE'),
    (4, '2024-01-17', 'Morning', '08:00:00', '12:00:00', 'P002', 'ACTIVE'),
    
    -- Dr. Hùng (user_id = 5)
    (5, '2024-01-15', 'Afternoon', '13:00:00', '17:00:00', 'P003', 'ACTIVE'),
    (5, '2024-01-16', 'FullDay', '08:00:00', '17:00:00', 'P003', 'ACTIVE'),
    (5, '2024-01-17', 'Afternoon', '13:00:00', '17:00:00', 'P003', 'ACTIVE'),
    
    -- Dr. Thảo (user_id = 6)
    (6, '2024-01-15', 'FullDay', '08:00:00', '17:00:00', 'P004', 'ACTIVE'),
    (6, '2024-01-16', 'Morning', '08:00:00', '12:00:00', 'P004', 'ACTIVE'),
    (6, '2024-01-17', 'Morning', '08:00:00', '12:00:00', 'P004', 'ACTIVE');
GO

-- ======================================================
-- 8️⃣ APPOINTMENT REQUESTS DATA
-- ======================================================
INSERT INTO AppointmentRequests (patient_id, full_name, phone, email, service_id, preferred_doctor_id, preferred_date, preferred_shift, notes, status, otp_code, otp_expires_at, confirmed_at)
VALUES
    (1, N'Nguyễn Văn An', '0901234567', 'nguyenvanan@email.com', 1, 3, '2024-01-15', 'Morning', N'Cần khám răng sâu', 'CONFIRMED', '123456', DATEADD(HOUR, 1, GETDATE()), GETDATE()),
    (2, N'Trần Thị Bình', '0901234568', 'tranthibinh@email.com', 2, 4, '2024-01-16', 'Afternoon', N'Làm sạch răng', 'PENDING', '234567', DATEADD(HOUR, 1, GETDATE()), NULL),
    (3, N'Lê Văn Cường', '0901234569', 'levancuong@email.com', 3, 5, '2024-01-17', 'Morning', N'Trám răng', 'CONFIRMED', '345678', DATEADD(HOUR, 1, GETDATE()), GETDATE()),
    (NULL, N'Phạm Thị Dung', '0901234570', 'phamthidung@email.com', 4, 6, '2024-01-18', 'Afternoon', N'Điều trị tủy', 'PENDING', '456789', DATEADD(HOUR, 1, GETDATE()), NULL),
    (5, N'Hoàng Văn Em', '0901234571', 'hoangvanem@email.com', 5, 3, '2024-01-19', 'Morning', N'Nhổ răng khôn', 'REJECTED', '567890', DATEADD(HOUR, 1, GETDATE()), NULL);
GO

-- ======================================================
-- 9️⃣ APPOINTMENTS DATA
-- ======================================================
INSERT INTO Appointments (patient_id, dentist_id, service_id, appointment_date, status, notes, source, booking_channel, created_by_user_id, confirmation_code, confirmed_at)
VALUES
    (1, 3, 1, '2024-01-15 09:00:00', 'CONFIRMED', N'Khám tổng quát', 'INTERNAL', 'WEB', 7, 'APT001', '2024-01-14 10:00:00'),
    (2, 4, 2, '2024-01-16 14:00:00', 'SCHEDULED', N'Cạo vôi răng', 'ONLINE', 'WEB', NULL, 'APT002', '2024-01-15 11:00:00'),
    (3, 5, 3, '2024-01-17 10:00:00', 'CONFIRMED', N'Trám răng', 'INTERNAL', 'KIOSK', 8, 'APT003', '2024-01-16 09:00:00'),
    (4, 6, 4, '2024-01-18 15:00:00', 'SCHEDULED', N'Điều trị tủy', 'ONLINE', 'MOBILE', NULL, 'APT004', '2024-01-17 14:00:00'),
    (5, 3, 5, '2024-01-19 11:00:00', 'COMPLETED', N'Nhổ răng khôn', 'INTERNAL', 'WEB', 7, 'APT005', '2024-01-18 10:00:00'),
    (6, 4, 1, '2024-01-20 09:30:00', 'SCHEDULED', N'Khám định kỳ', 'INTERNAL', 'WEB', 8, 'APT006', '2024-01-19 16:00:00'),
    (7, 5, 2, '2024-01-21 13:30:00', 'SCHEDULED', N'Cạo vôi răng', 'ONLINE', 'WEB', NULL, 'APT007', '2024-01-20 11:00:00'),
    (8, 6, 3, '2024-01-22 10:30:00', 'SCHEDULED', N'Trám răng', 'INTERNAL', 'KIOSK', 7, 'APT008', '2024-01-21 15:00:00');
GO

-- ======================================================
-- 🔟 WAITING QUEUE DATA
-- ======================================================
INSERT INTO WaitingQueue (appointment_id, position_in_queue, status)
VALUES
    (1, 1, 'COMPLETED'),
    (2, 2, 'WAITING'),
    (3, 3, 'WAITING'),
    (4, 4, 'WAITING'),
    (5, NULL, 'COMPLETED'),
    (6, 5, 'WAITING'),
    (7, 6, 'WAITING'),
    (8, 7, 'WAITING');
GO

-- ======================================================
-- 1️⃣1️⃣ MEDICAL RECORDS DATA
-- ======================================================
INSERT INTO MedicalRecords (patient_id, dentist_id, summary, created_at)
VALUES
    (1, 3, N'Bệnh nhân đến khám với triệu chứng đau răng hàm dưới bên phải. Khám lâm sàng phát hiện sâu răng số 46.', '2024-01-15 09:30:00'),
    (2, 4, N'Bệnh nhân đến làm sạch răng định kỳ. Tình trạng răng miệng tốt, chỉ có một ít cao răng.', '2024-01-16 14:30:00'),
    (3, 5, N'Bệnh nhân có lỗ sâu răng số 36, cần trám composite.', '2024-01-17 10:30:00'),
    (4, 6, N'Bệnh nhân đau răng dữ dội, cần điều trị tủy răng số 16.', '2024-01-18 15:30:00'),
    (5, 3, N'Bệnh nhân có răng khôn mọc lệch, cần nhổ bỏ.', '2024-01-19 11:30:00');
GO

-- ======================================================
-- 1️⃣2️⃣ EXAMINATIONS DATA
-- ======================================================
INSERT INTO Examinations (record_id, findings, diagnosis, created_at)
VALUES
    (1, N'Răng số 46 có lỗ sâu lớn, tủy răng có thể bị viêm', N'Sâu răng số 46, viêm tủy', '2024-01-15 09:45:00'),
    (2, N'Răng miệng sạch sẽ, có một ít cao răng ở mặt trong răng hàm', N'Cao răng nhẹ, sức khỏe răng miệng tốt', '2024-01-16 14:45:00'),
    (3, N'Lỗ sâu răng số 36 kích thước trung bình, chưa ảnh hưởng tủy', N'Sâu răng số 36', '2024-01-17 10:45:00'),
    (4, N'Răng số 16 có lỗ sâu lớn, tủy răng bị viêm nặng', N'Viêm tủy răng số 16', '2024-01-18 15:45:00'),
    (5, N'Răng khôn số 48 mọc lệch, gây đau và viêm nướu', N'Răng khôn mọc lệch số 48', '2024-01-19 11:45:00');
GO

-- ======================================================
-- 1️⃣3️⃣ TREATMENT PLANS DATA
-- ======================================================
INSERT INTO TreatmentPlans (record_id, plan_summary, estimated_cost, created_at)
VALUES
    (1, N'Điều trị tủy răng số 46, sau đó trám composite', 2000000, '2024-01-15 10:00:00'),
    (2, N'Cạo vôi răng và đánh bóng', 300000, '2024-01-16 15:00:00'),
    (3, N'Trám composite răng số 36', 500000, '2024-01-17 11:00:00'),
    (4, N'Điều trị tủy răng số 16, sau đó làm cầu răng', 5000000, '2024-01-18 16:00:00'),
    (5, N'Nhổ răng khôn số 48', 800000, '2024-01-19 12:00:00');
GO

-- ======================================================
-- 1️⃣4️⃣ TREATMENT SESSIONS DATA
-- ======================================================
INSERT INTO TreatmentSessions (plan_id, session_date, procedure_done, session_cost)
VALUES
    (1, '2024-01-15 10:30:00', N'Điều trị tủy răng số 46', 1500000),
    (1, '2024-01-22 10:30:00', N'Trám composite răng số 46', 500000),
    (2, '2024-01-16 15:30:00', N'Cạo vôi răng và đánh bóng', 300000),
    (3, '2024-01-17 11:30:00', N'Trám composite răng số 36', 500000),
    (4, '2024-01-18 16:30:00', N'Điều trị tủy răng số 16', 1500000),
    (4, '2024-01-25 16:30:00', N'Làm cầu răng số 16', 3500000),
    (5, '2024-01-19 12:30:00', N'Nhổ răng khôn số 48', 800000);
GO

-- ======================================================
-- 1️⃣5️⃣ PRESCRIPTIONS DATA
-- ======================================================
INSERT INTO Prescriptions (patient_id, dentist_id, notes, created_at)
VALUES
    (1, 3, N'Thuốc giảm đau và kháng viêm sau điều trị tủy', '2024-01-15 11:00:00'),
    (2, 4, N'Thuốc súc miệng và kem đánh răng chuyên dụng', '2024-01-16 16:00:00'),
    (3, 5, N'Thuốc giảm đau nhẹ sau trám răng', '2024-01-17 12:00:00'),
    (4, 6, N'Thuốc kháng sinh và giảm đau sau điều trị tủy', '2024-01-18 17:00:00'),
    (5, 3, N'Thuốc kháng sinh và giảm đau sau nhổ răng', '2024-01-19 13:00:00');
GO

-- ======================================================
-- 1️⃣6️⃣ PRESCRIPTION ITEMS DATA
-- ======================================================
INSERT INTO PrescriptionItems (prescription_id, medication_name, dosage, duration, instructions)
VALUES
    (1, N'Ibuprofen', N'400mg', N'3 ngày', N'Uống sau ăn, 3 lần/ngày'),
    (1, N'Amoxicillin', N'500mg', N'7 ngày', N'Uống trước ăn, 2 lần/ngày'),
    (2, N'Nước súc miệng Listerine', N'500ml', N'1 tháng', N'Súc miệng 2 lần/ngày'),
    (2, N'Kem đánh răng Sensodyne', N'75ml', N'1 tháng', N'Đánh răng 2 lần/ngày'),
    (3, N'Paracetamol', N'500mg', N'2 ngày', N'Uống khi đau, tối đa 4 viên/ngày'),
    (4, N'Ciprofloxacin', N'500mg', N'5 ngày', N'Uống sau ăn, 2 lần/ngày'),
    (4, N'Ibuprofen', N'400mg', N'5 ngày', N'Uống sau ăn, 3 lần/ngày'),
    (5, N'Amoxicillin', N'500mg', N'7 ngày', N'Uống trước ăn, 2 lần/ngày'),
    (5, N'Ibuprofen', N'400mg', N'5 ngày', N'Uống sau ăn, 3 lần/ngày');
GO

-- ======================================================
-- 1️⃣7️⃣ INVENTORY ITEMS DATA
-- ======================================================
INSERT INTO InventoryItems (name, unit, quantity, min_stock)
VALUES
    (N'Găng tay y tế', 'hộp', 50, 10),
    (N'Khẩu trang y tế', 'hộp', 40, 10),
    (N'Nước súc miệng', 'chai', 20, 5),
    (N'Thuốc tê Lidocaine', 'ống', 30, 8),
    (N'Composite trám răng', 'hộp', 15, 5),
    (N'Bông gòn y tế', 'hộp', 25, 8),
    (N'Kim tiêm', 'hộp', 20, 5),
    (N'Thuốc kháng sinh', 'hộp', 18, 6),
    (N'Dụng cụ nha khoa', 'bộ', 12, 3),
    (N'Thuốc giảm đau', 'hộp', 22, 7);
GO

-- ======================================================
-- 1️⃣8️⃣ STOCK TRANSACTIONS DATA
-- ======================================================
INSERT INTO StockTransactions (item_id, transaction_type, quantity, performed_by, notes)
VALUES
    (1, 'IN', 20, 2, N'Nhập kho găng tay mới'),
    (2, 'IN', 15, 2, N'Nhập kho khẩu trang'),
    (3, 'IN', 10, 2, N'Nhập kho nước súc miệng'),
    (4, 'IN', 12, 2, N'Nhập kho thuốc tê'),
    (5, 'IN', 8, 2, N'Nhập kho composite'),
    (1, 'OUT', 5, 3, N'Sử dụng cho ca điều trị'),
    (2, 'OUT', 3, 4, N'Sử dụng cho ca khám'),
    (4, 'OUT', 2, 5, N'Sử dụng cho ca nhổ răng'),
    (5, 'OUT', 1, 3, N'Sử dụng cho ca trám răng'),
    (6, 'OUT', 4, 4, N'Sử dụng cho ca cạo vôi');
GO

-- ======================================================
-- 1️⃣9️⃣ INVOICES DATA
-- ======================================================
INSERT INTO Invoices (patient_id, appointment_id, total_amount, discount_amount, status, created_at)
VALUES
    (1, 1, 100000, 0, 'PAID', '2024-01-15 09:30:00'),
    (2, 2, 300000, 30000, 'UNPAID', '2024-01-16 14:30:00'),
    (3, 3, 500000, 0, 'PAID', '2024-01-17 10:30:00'),
    (4, 4, 1500000, 150000, 'UNPAID', '2024-01-18 15:30:00'),
    (5, 5, 800000, 0, 'PAID', '2024-01-19 11:30:00'),
    (6, 6, 100000, 0, 'UNPAID', '2024-01-20 09:30:00'),
    (7, 7, 300000, 0, 'UNPAID', '2024-01-21 13:30:00'),
    (8, 8, 500000, 50000, 'UNPAID', '2024-01-22 10:30:00');
GO

-- ======================================================
-- 2️⃣0️⃣ INVOICE ITEMS DATA
-- ======================================================
INSERT INTO InvoiceItems (invoice_id, service_id, quantity, unit_price)
VALUES
    (1, 1, 1, 100000),
    (2, 2, 1, 300000),
    (3, 3, 1, 500000),
    (4, 4, 1, 1500000),
    (5, 5, 1, 800000),
    (6, 1, 1, 100000),
    (7, 2, 1, 300000),
    (8, 3, 1, 500000);
GO

-- ======================================================
-- 2️⃣1️⃣ PAYMENTS DATA
-- ======================================================
INSERT INTO Payments (invoice_id, amount, method, paid_at)
VALUES
    (1, 100000, 'CASH', '2024-01-15 09:45:00'),
    (3, 500000, 'CARD', '2024-01-17 11:00:00'),
    (5, 800000, 'TRANSFER', '2024-01-19 12:00:00');
GO

-- ======================================================
-- 2️⃣2️⃣ SCHEDULE REQUESTS DATA
-- ======================================================
INSERT INTO ScheduleRequests (employee_id, date, shift, reason, status, reviewed_by, reviewed_at)
VALUES
    (3, '2024-01-25', 'Morning', N'Nghỉ phép cá nhân', 'APPROVED', 2, '2024-01-20 10:00:00'),
    (4, '2024-01-26', 'Afternoon', N'Họp gia đình', 'PENDING', NULL, NULL),
    (5, '2024-01-27', 'FullDay', N'Nghỉ ốm', 'REJECTED', 2, '2024-01-21 14:00:00'),
    (6, '2024-01-28', 'Morning', N'Đi khám sức khỏe', 'APPROVED', 2, '2024-01-22 09:00:00'),
    (7, '2024-01-29', 'Afternoon', N'Nghỉ phép', 'PENDING', NULL, NULL);
GO

-- ======================================================
-- 2️⃣3️⃣ PATIENT FILES DATA
-- ======================================================
INSERT INTO PatientFiles (patient_id, content, uploaded_at)
VALUES
    (1, N'Giấy tờ tùy thân: CMND/CCCD\nBảo hiểm y tế: Có\nTiền sử bệnh: Không có', '2024-01-15 09:00:00'),
    (2, N'Giấy tờ tùy thân: CMND/CCCD\nBảo hiểm y tế: Có\nTiền sử bệnh: Dị ứng penicillin', '2024-01-16 14:00:00'),
    (3, N'Giấy tờ tùy thân: CMND/CCCD\nBảo hiểm y tế: Không\nTiền sử bệnh: Không có', '2024-01-17 10:00:00'),
    (4, N'Giấy tờ tùy thân: CMND/CCCD\nBảo hiểm y tế: Có\nTiền sử bệnh: Cao huyết áp', '2024-01-18 15:00:00'),
    (5, N'Giấy tờ tùy thân: CMND/CCCD\nBảo hiểm y tế: Có\nTiền sử bệnh: Không có', '2024-01-19 11:00:00');
GO

-- ======================================================
-- 2️⃣4️⃣ PATIENT IMAGES DATA
-- ======================================================
INSERT INTO PatientImages (patient_id, record_id, file_path, image_type, uploaded_by)
VALUES
    (1, 1, '/uploads/xray/patient1_r46_xray.jpg', 'X-RAY', 3),
    (1, 1, '/uploads/before/patient1_r46_before.jpg', 'BEFORE', 3),
    (1, 1, '/uploads/after/patient1_r46_after.jpg', 'AFTER', 3),
    (2, 2, '/uploads/before/patient2_cleaning_before.jpg', 'BEFORE', 4),
    (2, 2, '/uploads/after/patient2_cleaning_after.jpg', 'AFTER', 4),
    (3, 3, '/uploads/before/patient3_r36_before.jpg', 'BEFORE', 5),
    (3, 3, '/uploads/after/patient3_r36_after.jpg', 'AFTER', 5),
    (4, 4, '/uploads/xray/patient4_r16_xray.jpg', 'X-RAY', 6),
    (5, 5, '/uploads/xray/patient5_r48_xray.jpg', 'X-RAY', 3);
GO

-- ======================================================
-- 2️⃣5️⃣ SYSTEM CONFIGS DATA
-- ======================================================
INSERT INTO SystemConfigs (config_key, config_value, updated_by)
VALUES
    ('clinic_name', N'Nha khoa An Tâm', 1),
    ('clinic_phone', '0901234567', 1),
    ('clinic_email', 'contact@antamclinic.com', 1),
    ('clinic_address', N'123 Đường ABC, Quận 1, TP.HCM', 1),
    ('payment_methods', 'CASH,CARD,TRANSFER', 1),
    ('logo_url', '/assets/logo.png', 1),
    ('appointment_duration_default', '30', 1),
    ('max_appointments_per_day', '50', 1),
    ('otp_expiry_minutes', '60', 1),
    ('clinic_hours_morning_start', '08:00', 1),
    ('clinic_hours_morning_end', '12:00', 1),
    ('clinic_hours_afternoon_start', '13:00', 1),
    ('clinic_hours_afternoon_end', '17:00', 1);
GO

PRINT '✅ Sample data inserted successfully!';
PRINT '📊 Data Summary:';
PRINT '   - Roles: 5';
PRINT '   - Users: 10';
PRINT '   - Employees: 8';
PRINT '   - Patients: 15';
PRINT '   - Services: 10';
PRINT '   - Doctor Schedules: 13';
PRINT '   - Appointment Requests: 5';
PRINT '   - Appointments: 8';
PRINT '   - Waiting Queue: 8';
PRINT '   - Medical Records: 5';
PRINT '   - Examinations: 5';
PRINT '   - Treatment Plans: 5';
PRINT '   - Treatment Sessions: 7';
PRINT '   - Prescriptions: 5';
PRINT '   - Prescription Items: 9';
PRINT '   - Inventory Items: 10';
PRINT '   - Stock Transactions: 10';
PRINT '   - Invoices: 8';
PRINT '   - Invoice Items: 8';
PRINT '   - Payments: 3';
PRINT '   - Schedule Requests: 5';
PRINT '   - Patient Files: 5';
PRINT '   - Patient Images: 9';
PRINT '   - System Configs: 13';
