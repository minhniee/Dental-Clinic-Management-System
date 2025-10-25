-- Seed data đơn giản để test dashboard
-- Chạy script này để thêm dữ liệu mẫu

PRINT 'Bắt đầu thêm dữ liệu test cho dashboard...';

-- 1. Thêm Users (nếu chưa có)
IF NOT EXISTS (SELECT 1 FROM Users WHERE username = 'admin')
BEGIN
    INSERT INTO Users (username, email, password_hash, full_name, phone, role_id, is_active, created_at) VALUES
    ('admin', 'admin@clinic.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'System Admin', '0900000000', 1, 1, GETDATE()),
    ('manager', 'manager@clinic.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Clinic Manager', '0900000001', 2, 1, GETDATE()),
    ('reception', 'reception@clinic.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Reception Staff', '0900000002', 4, 1, GETDATE()),
    ('dentist1', 'dentist1@clinic.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Dr. John Doe', '0900000003', 3, 1, GETDATE()),
    ('dentist2', 'dentist2@clinic.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Dr. Jane Smith', '0900000004', 3, 1, GETDATE()),
    ('dentist3', 'dentist3@clinic.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Dr. Mike Johnson', '0900000005', 3, 1, GETDATE()),
    ('patient1', 'patient1@email.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Nguyễn Văn A', '0900000006', 5, 1, GETDATE()),
    ('patient2', 'patient2@email.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Trần Thị B', '0900000007', 5, 1, GETDATE()),
    ('patient3', 'patient3@email.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Lê Văn C', '0900000008', 5, 1, GETDATE()),
    ('patient4', 'patient4@email.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Phạm Thị D', '0900000009', 5, 1, GETDATE()),
    ('patient5', 'patient5@email.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Hoàng Văn E', '0900000010', 5, 1, GETDATE());
    PRINT 'Đã thêm Users';
END

-- 2. Thêm Employees
IF NOT EXISTS (SELECT 1 FROM Employees WHERE user_id = (SELECT user_id FROM Users WHERE username = 'manager'))
BEGIN
    INSERT INTO Employees (user_id, position, hire_date) VALUES
    ((SELECT user_id FROM Users WHERE username = 'manager'), 'Clinic Manager', '2024-01-01'),
    ((SELECT user_id FROM Users WHERE username = 'reception'), 'Receptionist', '2024-01-15'),
    ((SELECT user_id FROM Users WHERE username = 'dentist1'), 'Senior Dentist', '2024-02-01'),
    ((SELECT user_id FROM Users WHERE username = 'dentist2'), 'Dentist', '2024-02-15'),
    ((SELECT user_id FROM Users WHERE username = 'dentist3'), 'Junior Dentist', '2024-03-01');
    PRINT 'Đã thêm Employees';
END

-- 3. Thêm Patients
IF NOT EXISTS (SELECT 1 FROM Patients WHERE user_id = (SELECT user_id FROM Users WHERE username = 'patient1'))
BEGIN
    INSERT INTO Patients (full_name, birth_date, gender, phone, email, address, created_at, user_id) VALUES
    ('Nguyễn Văn A', '1990-05-15', 'M', '0900000006', 'patient1@email.com', '123 Đường ABC, Quận 1, TP.HCM', GETDATE(), (SELECT user_id FROM Users WHERE username = 'patient1')),
    ('Trần Thị B', '1985-08-22', 'F', '0900000007', 'patient2@email.com', '456 Đường XYZ, Quận 2, TP.HCM', GETDATE(), (SELECT user_id FROM Users WHERE username = 'patient2')),
    ('Lê Văn C', '1992-12-10', 'M', '0900000008', 'patient3@email.com', '789 Đường DEF, Quận 3, TP.HCM', GETDATE(), (SELECT user_id FROM Users WHERE username = 'patient3')),
    ('Phạm Thị D', '1988-03-25', 'F', '0900000009', 'patient4@email.com', '321 Đường GHI, Quận 4, TP.HCM', GETDATE(), (SELECT user_id FROM Users WHERE username = 'patient4')),
    ('Hoàng Văn E', '1995-07-18', 'M', '0900000010', 'patient5@email.com', '654 Đường JKL, Quận 5, TP.HCM', GETDATE(), (SELECT user_id FROM Users WHERE username = 'patient5'));
    PRINT 'Đã thêm Patients';
END

-- 4. Thêm Services (nếu chưa có)
IF NOT EXISTS (SELECT 1 FROM Services WHERE name = 'Khám răng định kỳ')
BEGIN
    INSERT INTO Services (name, description, price, duration_minutes, is_active) VALUES
    ('Khám răng định kỳ', 'Khám răng định kỳ 6 tháng/lần', 500000, 30, 1),
    ('Làm sạch răng', 'Làm sạch răng và cạo vôi răng', 400000, 45, 1),
    ('Trám răng sâu', 'Trám răng sâu bằng composite', 600000, 60, 1),
    ('Điều trị tủy răng', 'Điều trị tủy răng 1 chân', 1200000, 90, 1),
    ('Nhổ răng khôn', 'Nhổ răng khôn hàm dưới', 800000, 60, 1),
    ('Làm răng giả', 'Làm răng giả tháo lắp', 1500000, 120, 1),
    ('Niềng răng', 'Tư vấn và điều trị niềng răng', 300000, 30, 1),
    ('Thẩm mỹ răng', 'Tư vấn thẩm mỹ răng', 350000, 30, 1);
    PRINT 'Đã thêm Services';
END

-- 5. Thêm Appointments (đơn giản)
IF NOT EXISTS (SELECT 1 FROM Appointments WHERE appointment_date >= DATEADD(day, -30, GETDATE()))
BEGIN
    -- Lấy service_id đầu tiên
    DECLARE @service_id INT = (SELECT MIN(service_id) FROM Services);
    
    -- Lấy patient_id và dentist_id thực tế
    DECLARE @patient1_id INT = (SELECT patient_id FROM Patients WHERE user_id = (SELECT user_id FROM Users WHERE username = 'patient1'));
    DECLARE @patient2_id INT = (SELECT patient_id FROM Patients WHERE user_id = (SELECT user_id FROM Users WHERE username = 'patient2'));
    DECLARE @patient3_id INT = (SELECT patient_id FROM Patients WHERE user_id = (SELECT user_id FROM Users WHERE username = 'patient3'));
    DECLARE @patient4_id INT = (SELECT patient_id FROM Patients WHERE user_id = (SELECT user_id FROM Users WHERE username = 'patient4'));
    DECLARE @patient5_id INT = (SELECT patient_id FROM Patients WHERE user_id = (SELECT user_id FROM Users WHERE username = 'patient5'));
    
    DECLARE @dentist1_id INT = (SELECT user_id FROM Users WHERE username = 'dentist1');
    DECLARE @dentist2_id INT = (SELECT user_id FROM Users WHERE username = 'dentist2');
    DECLARE @dentist3_id INT = (SELECT user_id FROM Users WHERE username = 'dentist3');
    
    INSERT INTO Appointments (patient_id, dentist_id, service_id, appointment_date, status, notes, created_at, source) VALUES
    -- 7 ngày trước
    (@patient1_id, @dentist1_id, @service_id, DATEADD(day, -7, GETDATE()), 'COMPLETED', 'Khám răng định kỳ', DATEADD(day, -7, GETDATE()), 'INTERNAL'),
    (@patient2_id, @dentist2_id, @service_id, DATEADD(day, -7, GETDATE()), 'COMPLETED', 'Nhổ răng khôn', DATEADD(day, -7, GETDATE()), 'INTERNAL'),
    (@patient3_id, @dentist1_id, @service_id, DATEADD(day, -7, GETDATE()), 'COMPLETED', 'Tư vấn niềng răng', DATEADD(day, -7, GETDATE()), 'INTERNAL'),
    -- 6 ngày trước
    (@patient4_id, @dentist3_id, @service_id, DATEADD(day, -6, GETDATE()), 'COMPLETED', 'Trám răng sâu', DATEADD(day, -6, GETDATE()), 'INTERNAL'),
    (@patient5_id, @dentist2_id, @service_id, DATEADD(day, -6, GETDATE()), 'COMPLETED', 'Làm sạch răng', DATEADD(day, -6, GETDATE()), 'INTERNAL'),
    (@patient1_id, @dentist1_id, @service_id, DATEADD(day, -6, GETDATE()), 'COMPLETED', 'Kiểm tra sau điều trị', DATEADD(day, -6, GETDATE()), 'INTERNAL'),
    -- 5 ngày trước
    (@patient2_id, @dentist3_id, @service_id, DATEADD(day, -5, GETDATE()), 'COMPLETED', 'Điều trị tủy răng', DATEADD(day, -5, GETDATE()), 'INTERNAL'),
    (@patient3_id, @dentist2_id, @service_id, DATEADD(day, -5, GETDATE()), 'COMPLETED', 'Làm răng giả', DATEADD(day, -5, GETDATE()), 'INTERNAL'),
    (@patient4_id, @dentist1_id, @service_id, DATEADD(day, -5, GETDATE()), 'COMPLETED', 'Tư vấn thẩm mỹ răng', DATEADD(day, -5, GETDATE()), 'INTERNAL'),
    -- 4 ngày trước
    (@patient5_id, @dentist3_id, @service_id, DATEADD(day, -4, GETDATE()), 'COMPLETED', 'Khám răng định kỳ', DATEADD(day, -4, GETDATE()), 'INTERNAL'),
    (@patient1_id, @dentist2_id, @service_id, DATEADD(day, -4, GETDATE()), 'COMPLETED', 'Điều trị viêm nướu', DATEADD(day, -4, GETDATE()), 'INTERNAL'),
    (@patient2_id, @dentist1_id, @service_id, DATEADD(day, -4, GETDATE()), 'COMPLETED', 'Kiểm tra răng khôn', DATEADD(day, -4, GETDATE()), 'INTERNAL'),
    -- 3 ngày trước
    (@patient3_id, @dentist3_id, @service_id, DATEADD(day, -3, GETDATE()), 'COMPLETED', 'Trám răng sâu', DATEADD(day, -3, GETDATE()), 'INTERNAL'),
    (@patient4_id, @dentist2_id, @service_id, DATEADD(day, -3, GETDATE()), 'COMPLETED', 'Làm sạch răng', DATEADD(day, -3, GETDATE()), 'INTERNAL'),
    (@patient5_id, @dentist1_id, @service_id, DATEADD(day, -3, GETDATE()), 'COMPLETED', 'Tư vấn niềng răng', DATEADD(day, -3, GETDATE()), 'INTERNAL'),
    -- 2 ngày trước
    (@patient1_id, @dentist2_id, @service_id, DATEADD(day, -2, GETDATE()), 'COMPLETED', 'Điều trị tủy răng', DATEADD(day, -2, GETDATE()), 'INTERNAL'),
    (@patient2_id, @dentist3_id, @service_id, DATEADD(day, -2, GETDATE()), 'COMPLETED', 'Làm răng giả', DATEADD(day, -2, GETDATE()), 'INTERNAL'),
    (@patient3_id, @dentist1_id, @service_id, DATEADD(day, -2, GETDATE()), 'COMPLETED', 'Kiểm tra sau điều trị', DATEADD(day, -2, GETDATE()), 'INTERNAL'),
    -- Hôm qua
    (@patient4_id, @dentist1_id, @service_id, DATEADD(day, -1, GETDATE()), 'COMPLETED', 'Khám răng định kỳ', DATEADD(day, -1, GETDATE()), 'INTERNAL'),
    (@patient5_id, @dentist2_id, @service_id, DATEADD(day, -1, GETDATE()), 'COMPLETED', 'Điều trị viêm nướu', DATEADD(day, -1, GETDATE()), 'INTERNAL'),
    (@patient1_id, @dentist3_id, @service_id, DATEADD(day, -1, GETDATE()), 'COMPLETED', 'Tư vấn thẩm mỹ răng', DATEADD(day, -1, GETDATE()), 'INTERNAL'),
    -- Hôm nay
    (@patient2_id, @dentist1_id, @service_id, GETDATE(), 'SCHEDULED', 'Khám răng định kỳ', GETDATE(), 'INTERNAL'),
    (@patient3_id, @dentist2_id, @service_id, GETDATE(), 'SCHEDULED', 'Làm sạch răng', GETDATE(), 'INTERNAL'),
    (@patient4_id, @dentist3_id, @service_id, GETDATE(), 'SCHEDULED', 'Kiểm tra răng khôn', GETDATE(), 'INTERNAL');
    PRINT 'Đã thêm Appointments';
END

-- 6. Thêm Invoices (đơn giản)
IF NOT EXISTS (SELECT 1 FROM Invoices WHERE patient_id = (SELECT patient_id FROM Patients WHERE user_id = (SELECT user_id FROM Users WHERE username = 'patient1')))
BEGIN
    INSERT INTO Invoices (patient_id, appointment_id, total_amount, discount_amount, status, created_at) VALUES
    ((SELECT patient_id FROM Patients WHERE user_id = (SELECT user_id FROM Users WHERE username = 'patient1')), NULL, 500000, 0, 'PAID', DATEADD(day, -7, GETDATE())),
    ((SELECT patient_id FROM Patients WHERE user_id = (SELECT user_id FROM Users WHERE username = 'patient2')), NULL, 800000, 50000, 'PAID', DATEADD(day, -7, GETDATE())),
    ((SELECT patient_id FROM Patients WHERE user_id = (SELECT user_id FROM Users WHERE username = 'patient3')), NULL, 300000, 0, 'PAID', DATEADD(day, -7, GETDATE())),
    ((SELECT patient_id FROM Patients WHERE user_id = (SELECT user_id FROM Users WHERE username = 'patient4')), NULL, 600000, 0, 'PAID', DATEADD(day, -6, GETDATE())),
    ((SELECT patient_id FROM Patients WHERE user_id = (SELECT user_id FROM Users WHERE username = 'patient5')), NULL, 400000, 0, 'PAID', DATEADD(day, -6, GETDATE())),
    ((SELECT patient_id FROM Patients WHERE user_id = (SELECT user_id FROM Users WHERE username = 'patient1')), NULL, 200000, 0, 'PAID', DATEADD(day, -6, GETDATE())),
    ((SELECT patient_id FROM Patients WHERE user_id = (SELECT user_id FROM Users WHERE username = 'patient2')), NULL, 1200000, 100000, 'PAID', DATEADD(day, -5, GETDATE())),
    ((SELECT patient_id FROM Patients WHERE user_id = (SELECT user_id FROM Users WHERE username = 'patient3')), NULL, 1500000, 0, 'PAID', DATEADD(day, -5, GETDATE())),
    ((SELECT patient_id FROM Patients WHERE user_id = (SELECT user_id FROM Users WHERE username = 'patient4')), NULL, 350000, 0, 'PAID', DATEADD(day, -5, GETDATE())),
    ((SELECT patient_id FROM Patients WHERE user_id = (SELECT user_id FROM Users WHERE username = 'patient5')), NULL, 500000, 0, 'PAID', DATEADD(day, -4, GETDATE()));
    PRINT 'Đã thêm Invoices';
END

-- 7. Thêm Payments (đơn giản)
IF NOT EXISTS (SELECT 1 FROM Payments WHERE invoice_id = (SELECT MIN(invoice_id) FROM Invoices))
BEGIN
    INSERT INTO Payments (invoice_id, amount, method, paid_at) VALUES
    ((SELECT MIN(invoice_id) FROM Invoices), 500000, 'CASH', DATEADD(day, -7, GETDATE())),
    ((SELECT MIN(invoice_id) FROM Invoices) + 1, 750000, 'CARD', DATEADD(day, -7, GETDATE())),
    ((SELECT MIN(invoice_id) FROM Invoices) + 2, 300000, 'CASH', DATEADD(day, -7, GETDATE())),
    ((SELECT MIN(invoice_id) FROM Invoices) + 3, 600000, 'TRANSFER', DATEADD(day, -6, GETDATE())),
    ((SELECT MIN(invoice_id) FROM Invoices) + 4, 400000, 'CASH', DATEADD(day, -6, GETDATE()));
    PRINT 'Đã thêm Payments';
END

-- 8. Thêm Inventory Items
IF NOT EXISTS (SELECT 1 FROM InventoryItems WHERE name = 'Thuốc tê Lidocaine')
BEGIN
    INSERT INTO InventoryItems (name, unit, quantity, min_stock, created_at) VALUES
    ('Thuốc tê Lidocaine', 'chai', 100, 20, GETDATE()),
    ('Composite trám răng', 'hộp', 50, 10, GETDATE()),
    ('Kim tiêm nha khoa', 'hộp', 200, 50, GETDATE()),
    ('Găng tay y tế', 'hộp', 500, 100, GETDATE()),
    ('Khẩu trang y tế', 'hộp', 300, 50, GETDATE());
    PRINT 'Đã thêm Inventory Items';
END

-- 9. Thêm Stock Transactions
IF NOT EXISTS (SELECT 1 FROM StockTransactions WHERE item_id = 1)
BEGIN
    INSERT INTO StockTransactions (item_id, transaction_type, quantity, performed_by, performed_at, notes) VALUES
    (1, 'IN', 100, 1, DATEADD(day, -30, GETDATE()), 'Nhập kho ban đầu'),
    (2, 'IN', 50, 1, DATEADD(day, -30, GETDATE()), 'Nhập kho ban đầu'),
    (3, 'IN', 200, 1, DATEADD(day, -30, GETDATE()), 'Nhập kho ban đầu'),
    (4, 'IN', 500, 1, DATEADD(day, -30, GETDATE()), 'Nhập kho ban đầu'),
    (5, 'IN', 300, 1, DATEADD(day, -30, GETDATE()), 'Nhập kho ban đầu');
    PRINT 'Đã thêm Stock Transactions';
END

PRINT 'Hoàn thành thêm dữ liệu test cho dashboard!';
PRINT 'Dashboard bây giờ sẽ có dữ liệu để hiển thị.';
