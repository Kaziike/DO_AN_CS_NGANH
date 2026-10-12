# Chẩn Đoán & Khắc Phục Sự Cố TechStore (Troubleshooting)

> **Dự án**: TechStore - Website Bán Lẻ Công Nghệ  
> **Tài liệu tham chiếu**: [PROJECT_OVERVIEW.md](./PROJECT_OVERVIEW.md) | [DEVELOPMENT_GUIDE.md](./DEVELOPMENT_GUIDE.md)

---

## 1. Sự Cố Phía Máy Chủ & Cơ Sở Dữ Liệu

### 1.1. Lỗi Kết Nối Cơ Sở Dữ Liệu (`ER_ACCESS_DENIED_ERROR` hoặc `ECONNREFUSED`)
- **Dấu hiệu**: Khi chạy `npm start`, console hiển thị:
  ```text
  Database connection failed: connect ECONNREFUSED 127.0.0.1:3306
  [Server] Fallback to in-memory mock mode.
  ```
- **Nguyên nhân**:
  1. Dịch vụ MySQL Server trên máy tính chưa được khởi động.
  2. Mật khẩu tài khoản `root` hoặc tên cơ sở dữ liệu trong file `.env` không chính xác.
  3. Cổng MySQL của bạn khác cổng mặc định `3306` (ví dụ: Laragon hoặc XAMPP dùng cổng `3307`).
- **Cách khắc phục**:
  1. Mở tiện ích quản lý dịch vụ Windows (`services.msc`), tìm dịch vụ `MySQL80` (hoặc `MySQL`) và nhấn **Start**.
  2. Mở file `.env` tại thư mục gốc của dự án và kiểm tra lại thông số:
     ```env
     DB_HOST=localhost
     DB_USER=root
     DB_PASSWORD=nhap_dung_mat_khau_cua_ban
     DB_NAME=techstore_db
     DB_PORT=3306
     ```
  3. Mở MySQL Workbench kết nối thử bằng đúng tài khoản/mật khẩu trên để xác minh.

---

### 1.2. Lỗi Cổng Mạng Bị Chiếm Dụng (`EADDRINUSE: :::3000`)
- **Dấu hiệu**: Console báo lỗi:
  ```text
  Error: listen EADDRINUSE: address already in use :::3000
  ```
- **Nguyên nhân**: Một tiến trình Node.js trước đó chưa được tắt hoàn toàn hoặc có ứng dụng khác đang sử dụng cổng `3000`.
- **Cách khắc phục**:
  - **Cách 1 (Khuyên dùng)**: Mở PowerShell và tắt tiến trình đang chiếm cổng:
    ```powershell
    Get-Process -Id (Get-NetTCPConnection -LocalPort 3000).OwningProcess | Stop-Process -Force
    ```
  - **Cách 2**: Đổi sang cổng khác trong file `.env`:
    ```env
    PORT=3001
    ```
    Sau đó khởi động lại bằng `npm start`.

---

### 1.3. Cơ Sở Dữ Liệu Rỗng Không Có Dữ Liệu Sản Phẩm
- **Dấu hiệu**: Trang web mở được nhưng các danh mục đều hiển thị "Không tìm thấy sản phẩm nào".
- **Nguyên nhân**: Bạn mới chỉ chạy file `schema.sql` (tạo khung bảng) mà chưa import dữ liệu mẫu từ `seed2.sql`.
- **Cách khắc phục**:
  1. Mở MySQL Workbench hoặc phpMyAdmin.
  2. Chọn database `techstore_db`.
  3. Mở file `database/seed2.sql` (hoặc `seed2.sql` ở thư mục gốc) và nhấn **Execute (Run)** để nạp toàn bộ danh mục, sản phẩm và khuyến mãi.

---

## 2. Sự Cố Phía Trình Duyệt & Giao Diện (Client-Side)

### 2.1. Lỗi Giỏ Hàng Bị Lỗi Không Cập Nhật Số Lượng
- **Dấu hiệu**: Thao tác bấm nút "Thêm vào giỏ" không thấy badge Header nhảy số, hoặc mở drawer giỏ hàng bị trắng trang.
- **Nguyên nhân**: Chuỗi JSON lưu trong `localStorage.techstore_cart_v1` bị hỏng cú pháp (do can thiệp thủ công hoặc phiên bản cũ xung đột cấu trúc).
- **Cách khắc phục**:
  1. Trên trình duyệt, nhấn phím `F12` để mở DevTools.
  2. Chuyển sang tab **Application** (hoặc **Storage**) -> Chọn **Local Storage** -> `http://localhost:3000`.
  3. Nhấp chuột phải vào khóa `techstore_cart_v1` và chọn **Delete**.
  4. F5 lại trang web để hệ thống tự khởi tạo lại giỏ hàng rỗng.

---

### 2.2. Lỗi Tích Chọn Bộ Lọc Accordion Nhưng Không Ra Sản Phẩm
- **Dấu hiệu**: Khi tích vào checkbox CPU "Intel Core i7" thì danh sách sản phẩm hiển thị trống trơn dù biết chắc chắn có laptop Core i7.
- **Nguyên nhân**: Có sự không đồng nhất giữa giá trị thuộc tính `value` của thẻ `<input checkbox>` trong file HTML với chuỗi lưu trong cột `specifications` (dạng JSON) của bảng `products`.
- **Cách khắc phục**:
  1. Mở DevTools Console, gõ lệnh:
     ```javascript
     console.log(App.products[0].specifications);
     ```
  2. Xem trường CPU lưu chính xác là chuỗi gì (ví dụ: `Intel Core i7-13700H` hay `Core i7`).
  3. Cập nhật lại điều kiện so khớp trong hàm `App.filterProducts()` (sử dụng hàm kiểm tra chứa chuỗi con `.toLowerCase().includes(...)` thay vì so sánh tuyệt đối `===`).

---

### 2.3. Bị Chặn Truy Cập Trang Quản Trị (`admin.html`)
- **Dấu hiệu**: Khi truy cập `http://localhost:3000/admin.html`, trang lập tức bị chuyển hướng về `login.html`.
- **Nguyên nhân**: Module `admin.js` kiểm tra quyền quản trị viên qua `localStorage.techstore_user`. Nếu chưa đăng nhập hoặc trường `role` không phải là `'admin'`, bạn sẽ bị từ chối truy cập.
- **Cách khắc phục**:
  - **Cách 1**: Truy cập `login.html` và đăng nhập bằng tài khoản Admin mẫu:
    - **Email**: `admin@techstore.vn`
    - **Mật khẩu**: `admin123`
  - **Cách 2 (Dành cho nhà phát triển kiểm thử nhanh)**: Mở DevTools Console và gõ lệnh kích hoạt quyền admin tạm thời:
    ```javascript
    localStorage.setItem('techstore_user', JSON.stringify({
      id: 1,
      name: "Quản Trị Viên",
      email: "admin@techstore.vn",
      role: "admin"
    }));
    location.reload();
    ```

---

### 2.4. Không Nhận Được Mã OTP Khi Thử Nghiệm Thanh Toán Online
- **Dấu hiệu**: Khách hàng chọn phương thức VNPAY/MoMo hoặc Thẻ, chuyển sang màn hình OTP nhưng không thấy mã gửi về điện thoại thực.
- **Nguyên nhân**: Đây là cổng thanh toán mô phỏng phục vụ đồ án (không sử dụng SMS Gateway có tính phí dịch vụ viễn thông).
- **Cách khắc phục**:
  1. Mã OTP 6 chữ số ngẫu nhiên được hiển thị trực tiếp trên thanh thông báo **Toast Notification** ở góc trên màn hình để người thử nghiệm quan sát.
  2. Ngoài ra, mã OTP cũng được in ra cửa sổ **Console của Node.js Server** phục vụ mục đích kiểm tra và chấm điểm đồ án.
