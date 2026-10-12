# Thư Mục Tài Liệu Các Module JavaScript TechStore

> **Dự án**: TechStore - Website Bán Lẻ Công Nghệ  
> **Tài liệu tham chiếu**: [JAVASCRIPT_GUIDE.md](../JAVASCRIPT_GUIDE.md) | [ARCHITECTURE.md](../ARCHITECTURE.md)

---

## 1. Giới Thiệu

Thư mục `docs/modules/` chứa các tài liệu đặc tả kỹ thuật chi tiết ở cấp độ mã nguồn (Source-level Documentation) cho từng file JavaScript phía máy khách (Client-Side) của dự án TechStore.

Mỗi tài liệu trong thư mục này phân tích sâu:
- Mục đích và trách nhiệm của module.
- Danh sách các thuộc tính trạng thái (State Properties).
- Chi tiết từng phương thức/hàm: Tham số đầu vào, giá trị trả về, xử lý nghiệp vụ và các trường hợp ngoại lệ.
- Các sự kiện DOM được lắng nghe (Event Listeners).
- Tương tác với API backend và lưu trữ `localStorage`.
- Mối liên hệ phụ thuộc với các module khác.

---

## 2. Danh Mục Các Module

| Tên Module / File | Vai Trò Chính | Dung Lượng | Liên Kết Tài Liệu |
| :--- | :--- | :---: | :--- |
| **`app.js`** | Bộ điều phối giao diện trung tâm, bộ lọc accordion, live search, chi tiết sản phẩm modal, reviews, q&a, tra cứu đơn hàng | 2.530 dòng | [Xem chi tiết: app.md](./app.md) |
| **`cart.js`** | Quản lý giỏ hàng Reactive, lưu trữ `localStorage`, tính toán mã voucher và phát sự kiện cập nhật UI | ~220 dòng | [Xem chi tiết: cart.md](./cart.md) |
| **`checkout.js`** | Điều hướng modal đặt hàng, kiểm tra form thông tin giao hàng, tính phí vận chuyển và gửi đơn hàng COD/Online | ~190 dòng | [Xem chi tiết: checkout.md](./checkout.md) |
| **`payment-gateway.js`** | Cổng thanh toán trực tuyến mô phỏng VNPAY, MoMo, Visa/Mastercard và xác thực mã OTP 10 phút | ~350 dòng | [Xem chi tiết: payment-gateway.md](./payment-gateway.md) |
| **`auth.js`** | Quản lý form đăng nhập, đăng ký tài khoản và lưu phiên người dùng trên `login.html` | ~160 dòng | [Xem chi tiết: auth.md](./auth.md) |
| **`admin.js`** | Quản lý bảng điều khiển quản trị viên: KPI doanh thu, duyệt trạng thái đơn hàng, CRUD sản phẩm và Flash Sale | ~480 dòng | [Xem chi tiết: admin.md](./admin.md) |
