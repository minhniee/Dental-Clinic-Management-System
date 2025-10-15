# 🏥 Hệ Thống Quản Lý Phòng Khám Nha Khoa - Nghiệp Vụ Admin & Manager

## 📋 Tổng Quan Hệ Thống

Hệ thống quản lý phòng khám nha khoa được thiết kế để hỗ trợ quản lý toàn diện các hoạt động của phòng khám, với trọng tâm vào quản lý người dùng, phân quyền và phân công lịch làm việc.

---

## 👨‍💼 Nghiệp Vụ Dành Cho Administrator

### 🔐 1. Quản Lý Người Dùng & Phân Quyền

#### 1.1 Quản Lý Vai Trò (Role Management)
- **Mục đích**: Định nghĩa và quản lý các vai trò trong hệ thống
- **Tính năng**:
  - Tạo mới vai trò (Administrator, ClinicManager, Dentist, Receptionist, Patient)
  - Cập nhật thông tin vai trò
  - Xem danh sách tất cả vai trò
  - Phân quyền truy cập theo vai trò

#### 1.2 Quản Lý Tài Khoản Người Dùng (User Management)
- **Mục đích**: Quản lý tài khoản của tất cả người dùng trong hệ thống
- **Tính năng**:
  - Tạo tài khoản mới cho nhân viên
  - Cập nhật thông tin cá nhân (họ tên, email, số điện thoại)
  - Gán/đổi vai trò cho người dùng
  - Kích hoạt/vô hiệu hóa tài khoản
  - Xem lịch sử tạo tài khoản
  - Tìm kiếm và lọc người dùng theo vai trò

#### 1.3 Phân Quyền Truy Cập
- **Mục đích**: Kiểm soát quyền truy cập các chức năng theo vai trò
- **Cơ chế**:
  - **Administrator**: Toàn quyền truy cập tất cả chức năng
  - **ClinicManager**: Quản lý lịch làm việc, xem báo cáo
  - **Dentist**: Xem lịch cá nhân, quản lý bệnh nhân
  - **Receptionist**: Quản lý lịch hẹn, tiếp tân
  - **Patient**: Đặt lịch hẹn, xem lịch sử

---

## 👥 Nghiệp Vụ Dành Cho Manager

### 📅 2. Quản Lý Nhân Viên & Lịch Làm Việc

#### 2.1 Quản Lý Nhân Viên (Employee Management)
- **Mục đích**: Quản lý thông tin nhân viên và phân công công việc
- **Tính năng**:
  - Xem danh sách tất cả nhân viên (Bác sĩ, Lễ tân, Y tá, Quản lý)
  - Lọc nhân viên theo loại (Dentist, Receptionist, Nurse, ClinicManager)
  - Xem thông tin chi tiết từng nhân viên
  - Quản lý lịch làm việc cá nhân cho từng nhân viên
  - Xem lịch làm việc tổng thể của tất cả nhân viên

#### 2.2 Phân Công Lịch Làm Việc (Schedule Assignment)

##### 2.2.1 Phân Công Cho Một Nhân Viên
- **Quy trình**:
  1. Chọn nhân viên cần phân công
  2. Chọn tuần làm việc (từ thứ 2 đến chủ nhật)
  3. Chọn các ngày trong tuần cần làm việc
  4. Chọn ca làm việc:
     - **Ca Sáng**: 7:00-12:00
     - **Ca Chiều**: 13:00-18:00  
     - **Ca Tối**: 19:00-22:00
     - **Cả Ngày**: 7:00-18:00
  5. Chọn phòng làm việc
  6. Thêm ghi chú (tùy chọn)
  7. Xem trước lịch phân công
  8. Xác nhận và lưu

##### 2.2.2 Phân Công Cho Nhiều Nhân Viên
- **Quy trình**:
  1. Chọn loại nhân viên (Dentist, Receptionist, etc.)
  2. Chọn nhiều nhân viên cùng lúc
  3. Chọn tuần làm việc
  4. Chọn các ngày trong tuần
  5. Chọn ca làm việc chung
  6. Chọn phòng làm việc
  7. Xem trước lịch phân công cho tất cả nhân viên
  8. Chọn chế độ lưu:
     - **ONLYNEW**: Chỉ thêm ca mới, bỏ qua ca đã có
     - **UPSERT**: Ghi đè ca cũ, thêm ca mới
  9. Xác nhận và lưu

#### 2.3 Xem Lịch Làm Việc

##### 2.3.1 Lịch Tuần Tổng Thể
- **Mục đích**: Xem tổng quan lịch làm việc của tất cả nhân viên trong tuần
- **Tính năng**:
  - Hiển thị lưới 7 ngày (Thứ 2 - Chủ Nhật)
  - Mỗi nhân viên một hàng
  - Màu sắc phân biệt ca làm việc:
    - 🟢 **Xanh lá**: Ca Sáng
    - 🟡 **Vàng**: Ca Chiều
    - 🟣 **Tím**: Ca Tối
    - 🔵 **Xanh dương**: Cả Ngày
  - Hiển thị giờ làm việc (7:00-12:00)
  - Hiển thị phòng làm việc
  - Navigation tuần trước/sau
  - Responsive design cho mobile

##### 2.3.2 Lịch Cá Nhân Nhân Viên
- **Mục đích**: Xem chi tiết lịch làm việc của một nhân viên cụ thể
- **Tính năng**:
  - Hiển thị thông tin nhân viên (tên, vai trò)
  - Lịch 7 ngày với các ca đã được phân công
  - Màu sắc phân biệt ca làm việc
  - Hiển thị giờ, phòng, trạng thái
  - Navigation tuần trước/sau
  - Actions: Phân công mới, Quản lý nhân viên, Lịch tổng thể

---

## 🎨 Giao Diện & Trải Nghiệm Người Dùng

### 📱 Responsive Design
- **Desktop**: Layout đầy đủ với sidebar navigation
- **Tablet**: Layout tối ưu cho màn hình vừa
- **Mobile**: Layout dọc, dễ sử dụng trên điện thoại

### 🎯 Tính Năng UI/UX
- **Color Coding**: Màu sắc phân biệt ca làm việc
- **Hover Effects**: Hiệu ứng khi di chuột
- **Loading States**: Thông báo khi xử lý
- **Error Handling**: Xử lý lỗi thân thiện
- **Form Validation**: Kiểm tra dữ liệu đầu vào

---

## 🔧 Công Nghệ & Kiến Trúc

### 🏗️ Kiến Trúc Hệ Thống
- **Backend**: Java Servlet + JSP
- **Database**: SQL Server với indexes tối ưu
- **Frontend**: HTML5 + CSS3 + JavaScript
- **Build Tool**: Maven
- **Server**: Apache Tomcat

### 📊 Database Schema
- **Users & Roles**: Quản lý người dùng và phân quyền
- **Employees**: Thông tin nhân viên
- **DoctorSchedules**: Lịch làm việc chi tiết
- **Indexes**: Tối ưu hiệu suất truy vấn
- **Constraints**: Đảm bảo tính toàn vẹn dữ liệu

### ⚡ Performance Optimizations
- **Unique Indexes**: Tránh trùng lặp lịch làm việc
- **Composite Indexes**: Tăng tốc truy vấn theo ngày/ca
- **Check Constraints**: Đảm bảo dữ liệu hợp lệ
- **Responsive Queries**: Tối ưu cho mobile

---

## 📋 Quy Trình Nghiệp Vụ Chi Tiết

### 🔄 Quy Trình Phân Công Lịch Làm Việc

#### Phase A - Nhập Thông Tin Phân Công
1. **Admin/Manager** truy cập trang "Phân Công Lịch"
2. Chọn loại nhân viên (Dentist, Receptionist, etc.)
3. Chọn nhân viên (một hoặc nhiều)
4. Nhập thông tin:
   - Tuần làm việc (ngày bắt đầu - kết thúc)
   - Các ngày trong tuần cần làm việc
   - Ca làm việc (Sáng/Chiều/Tối/Cả ngày)
   - Phòng làm việc
   - Ghi chú (tùy chọn)
5. Click "Xem Trước"

#### Phase B - Xem Trước & Xác Nhận
1. **Hệ thống** hiển thị ma trận lịch làm việc:
   - Hàng: Danh sách nhân viên
   - Cột: 7 ngày trong tuần
   - Ô: Ca làm việc với màu sắc phân biệt
2. **Màu sắc trạng thái**:
   - 🟢 **Xanh lá**: Ca mới (sẽ thêm)
   - 🟠 **Cam**: Ca đã có (sẽ ghi đè nếu chọn UPSERT)
   - 🔴 **Đỏ**: Ca bị khóa (không thể thay đổi)
3. **Admin/Manager** chọn chế độ lưu:
   - **ONLYNEW**: Chỉ thêm ca mới
   - **UPSERT**: Ghi đè ca cũ + thêm ca mới
4. Click "Phân Công Cho Tất Cả"

#### Phase C - Lưu & Xác Nhận
1. **Hệ thống** thực hiện transaction:
   - Kiểm tra ràng buộc dữ liệu
   - Thêm/cập nhật lịch làm việc
   - Ghi log hoạt động
2. **Hiển thị kết quả**:
   - Số ca đã thêm thành công
   - Số ca bị bỏ qua (đã có)
   - Số ca bị khóa (không thể thay đổi)
   - Thời gian hoàn thành

---

## 🚀 Hướng Dẫn Sử Dụng

### 👨‍💼 Cho Administrator
1. **Truy cập**: `http://localhost:8080/dental_clinic_management_system/admin/dashboard`
2. **Quản lý người dùng**: Click "Người Dùng" → Tạo/cập nhật tài khoản
3. **Quản lý vai trò**: Click "Vai Trò" → Tạo/cập nhật vai trò
4. **Quản lý nhân viên**: Click "Nhân Viên" → Xem danh sách nhân viên
5. **Phân công lịch**: Click "Phân Công Lịch" → Tạo lịch làm việc
6. **Xem lịch tuần**: Click "Lịch Tuần" → Xem tổng quan lịch làm việc

### 👥 Cho Manager
1. **Truy cập**: `http://localhost:8080/dental_clinic_management_system/admin/dashboard`
2. **Xem nhân viên**: Click "Nhân Viên" → Xem danh sách và thông tin
3. **Phân công lịch**: 
   - Chọn nhân viên → "📅 Phân Công Lịch Làm Việc"
   - Hoặc click "Phân Công Lịch" → Phân công cho nhiều nhân viên
4. **Xem lịch cá nhân**: Click "👁️ Xem Lịch Làm Việc" trên từng nhân viên
5. **Xem lịch tổng thể**: Click "Lịch Tuần" → Xem tất cả lịch làm việc

---

## 📊 Báo Cáo & Thống Kê

### 📈 Dashboard Administrator
- **Tổng số người dùng** theo vai trò
- **Số nhân viên đang hoạt động**
- **Số bác sĩ** và **nhân viên khác**
- **Quick actions** cho các chức năng chính

### 📅 Dashboard Manager
- **Lịch làm việc tuần hiện tại**
- **Thống kê phân công** theo nhân viên
- **Tình trạng phòng** và **ca làm việc**
- **Navigation** giữa các tuần

---

## 🔒 Bảo Mật & Phân Quyền

### 🛡️ Kiểm Soát Truy Cập
- **Session Management**: Kiểm tra đăng nhập
- **Role-based Access**: Phân quyền theo vai trò
- **Input Validation**: Kiểm tra dữ liệu đầu vào
- **SQL Injection Protection**: Bảo vệ khỏi tấn công SQL

### 🔐 Quyền Hạn Chi Tiết
- **Administrator**: Toàn quyền hệ thống
- **ClinicManager**: Quản lý lịch làm việc, xem báo cáo
- **Dentist**: Xem lịch cá nhân, quản lý bệnh nhân
- **Receptionist**: Quản lý lịch hẹn, tiếp tân

---

## 🎯 Lợi Ích Nghiệp Vụ

### ✅ Cho Administrator
- **Quản lý tập trung**: Tất cả người dùng và quyền hạn
- **Kiểm soát truy cập**: Phân quyền chi tiết
- **Theo dõi hoạt động**: Log và audit trail
- **Bảo mật cao**: Kiểm soát toàn bộ hệ thống

### ✅ Cho Manager
- **Phân công hiệu quả**: Lịch làm việc linh hoạt
- **Tổng quan rõ ràng**: Xem tất cả lịch làm việc
- **Tối ưu nguồn lực**: Phân bổ nhân viên hợp lý
- **Giảm xung đột**: Tránh trùng lịch làm việc

### ✅ Cho Hệ Thống
- **Hiệu suất cao**: Indexes và tối ưu database
- **Ổn định**: Xử lý lỗi và validation
- **Mở rộng**: Kiến trúc modular
- **Bảo trì**: Code clean và documentation

---

## 📞 Hỗ Trợ & Liên Hệ

### 🆘 Khi Gặp Vấn Đề
1. **Kiểm tra log**: Xem console browser và server logs
2. **Kiểm tra database**: Đảm bảo kết nối và dữ liệu
3. **Restart server**: Khởi động lại Tomcat
4. **Clear cache**: Xóa cache browser

### 📧 Thông Tin Liên Hệ
- **Developer**: AI Assistant
- **Project**: Dental Clinic Management System
- **Version**: MVP 1.0
- **Last Updated**: October 2025

---

*Tài liệu này mô tả đầy đủ các nghiệp vụ đã được phát triển cho Administrator và Manager trong hệ thống quản lý phòng khám nha khoa.*
