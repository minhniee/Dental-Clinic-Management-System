# 🔧 Hướng Dẫn Test Chức Năng Lịch Làm Việc

## 📋 **Bước 1: Chuẩn bị Database**

### 1.1. Tạo database và users
```sql
-- Chạy file này trước
db.txt
```

### 1.2. Tạo sample users
```sql
-- Chạy file này để tạo users
sample_employees_data.sql
```

### 1.3. Tạo test schedule data
```sql
-- Chạy file này để tạo dữ liệu lịch làm việc
simple_test_schedule.sql
```

### 1.4. Debug dữ liệu (tùy chọn)
```sql
-- Chạy file này để kiểm tra dữ liệu
debug_schedule_data.sql
```

## 📋 **Bước 2: Test Các Chức Năng**

### 2.1. Test Quản Lý Nhân Viên
- URL: `http://localhost:8080/dental_clinic_management_system/admin/employees`
- Kiểm tra: Danh sách nhân viên hiển thị đúng
- Kiểm tra: Thống kê số lượng nhân viên

### 2.2. Test Phân Công Lịch Làm Việc
- URL: `http://localhost:8080/dental_clinic_management_system/admin/schedules`
- Kiểm tra: Form phân công hoạt động
- Kiểm tra: Preview hiển thị đúng trạng thái (MỚI/TRÙNG/KHÓA)

### 2.3. Test Lịch Tuần
- URL: `http://localhost:8080/dental_clinic_management_system/admin/weekly-schedule`
- Kiểm tra: Bảng lịch tuần hiển thị dữ liệu
- Kiểm tra: Navigation tuần trước/sau

## 🔍 **Debug Logs**

Khi test, kiểm tra logs trong console để xem:
- Số lượng employees được tìm thấy
- Số lượng schedules được tìm thấy
- Chi tiết từng employee và schedule
- Quá trình tạo ma trận lịch làm việc

## 🚨 **Các Vấn Đề Có Thể Gặp**

### Vấn đề 1: Không có dữ liệu lịch
- **Nguyên nhân**: User IDs không đúng
- **Giải pháp**: Chạy `debug_schedule_data.sql` để kiểm tra

### Vấn đề 2: Preview hiển thị "0 nhân viên"
- **Nguyên nhân**: Logic tạo previewData có vấn đề
- **Giải pháp**: Kiểm tra logs trong console

### Vấn đề 3: Weekly schedule trống
- **Nguyên nhân**: Logic tạo ma trận có vấn đề
- **Giải pháp**: Kiểm tra logs và database

## ✅ **Kết Quả Mong Đợi**

1. **Employee Management**: Hiển thị danh sách nhân viên với thống kê
2. **Schedule Management**: Form phân công hoạt động, preview hiển thị đúng
3. **Weekly Schedule**: Bảng lịch tuần hiển thị dữ liệu với màu sắc phân biệt ca
4. **Schedule Result**: Hiển thị kết quả phân công với số liệu chính xác
