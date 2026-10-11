# TechStore - Website Thương Mại Điện Tử Sản Phẩm Công Nghệ
> **Đồ Án Cơ Sở Ngành - Chuyên Ngành Công Nghệ Thông Tin / Thương Mại Điện Tử**

Hệ thống Website Thương Mại Điện Tử quy mô nhỏ chuyên kinh doanh các sản phẩm công nghệ cao cấp (Laptop, Smartphone, Tablet, Âm thanh, Gaming Gear, Smartwatch) được xây dựng theo kiến trúc Full-Stack chuẩn RESTful API, giao diện Cyber Tech hiện đại và tích hợp cổng thanh toán trực tuyến mô phỏng thực tế.

---

## 🌟 Tính Năng Nổi Bật

### 1. Phía Người Dùng (Khách Hàng)
- **Danh mục & Bộ lọc đa tiêu chí**:
  - Lọc sản phẩm theo danh mục: Laptop & Máy tính, Smartphone, Tablet, Âm thanh, Gaming Gear, Smartwatch.
  - Lọc theo thương hiệu: Apple, Asus, Dell, Samsung, Sony, Logitech, Razer, Keychron, Xiaomi,...
  - Lọc theo mức giá (Dưới 5tr, 5 - 15tr, 15 - 30tr, Trên 30tr).
  - Sắp xếp: Mới nhất, Giá tăng dần, Giá giảm dần, Đánh giá cao nhất, Bán chạy nhất.
  - Tìm kiếm thời gian thực (Live search tức thời).
- **Chi tiết sản phẩm & Đánh giá**:
  - Bộ sưu tập ảnh sản phẩm, bảng thông số kỹ thuật (CPU, RAM, Màn hình, Pin,...).
  - Đánh giá sao (1-5 sao), gửi nhận xét, hiển thị huy hiệu "Đã mua tại cửa hàng".
- **Giỏ hàng & Đặt hàng**:
  - Giỏ hàng trượt (Flyout Drawer), tăng/giảm số lượng, xóa sản phẩm, tính toán tự động.
  - Áp dụng mã giảm giá voucher (`TECH10`, `FREESHIP`, `SUPERTECH`).
  - Biểu mẫu thanh toán chi tiết: Họ tên, SĐT, Email, địa chỉ nhận hàng, phương thức vận chuyển.
- **Cổng thanh toán mô phỏng (Simulated Payment Gateways)**:
  - **Cổng VNPAY-QR**: Tạo mã QR động, đồng hồ đếm ngược 10 phút, nhập mã OTP `123456` xác nhận thanh toán.
  - **Cổng Ví MoMo**: Giao diện quét QR MoMo Sandbox, xác thực thanh toán tức thì.
  - **Thẻ Quốc Tế (Visa/Mastercard)**: Mô phỏng thẻ chip 3D Secure, xác nhận mã OTP bảo mật.
  - **COD**: Thanh toán tiền mặt khi nhận hàng.
- **Tra cứu đơn hàng trực tuyến**:
  - Tra cứu tiến trình đơn hàng bằng **Mã đơn** (VD: `ORD-98241`) hoặc **Số điện thoại**.
  - Thanh tiến trình trực quan: `Đặt hàng` ➔ `Đã duyệt` ➔ `Đang giao` ➔ `Thành công`.
- **Giao diện hiện đại**:
  - Chuyển đổi Dark/Light mode linh hoạt.
  - Thiết kế theo phong cách Cyber Tech, hiệu ứng kính mờ (Glassmorphism), viền Neon phát sáng, micro-animations mượt mà.

### 2. Phía Quản Trị Viên (Admin Portal - `/admin.html`)
- **Thống kê doanh thu & KPI**: Tổng doanh thu (VNĐ), tổng số đơn hàng, số lượng sản phẩm, số lượng đánh giá.
- **Quản lý đơn hàng**:
  - Xem danh sách đơn hàng mới nhất kèm chi tiết khách hàng và giỏ hàng.
  - Lọc đơn theo trạng thái: Chờ xử lý (`pending`), Đã xác nhận (`confirmed`), Đang giao (`shipping`), Hoàn thành (`completed`), Đã hủy (`cancelled`).
  - Cập nhật trạng thái đơn hàng và trạng thái thanh toán (`unpaid`, `paid`, `refunded`).
- **Quản lý kho sản phẩm (CRUD)**:
  - Thêm mới sản phẩm với đầy đủ ảnh URL, giá gốc, giá khuyến mãi, hãng, danh mục, thông số kỹ thuật JSON.
  - Chỉnh sửa thông tin, giá bán, số lượng tồn kho.
  - Xóa sản phẩm khỏi hệ thống.
  - Tìm kiếm sản phẩm theo tên/hãng.

---

## 🛠️ Công Nghệ Sử Dụng

- **Frontend**: HTML5 Semantic, CSS3 hiện đại (CSS Variables, Glassmorphism, Responsive Grid/Flexbox), Vanilla JavaScript ES6+ (Module architecture, LocalStorage, Reactive Store).
- **Backend**: Node.js, Express.js (REST API, CORS, Body-parser, Async/Await).
- **Cơ sở dữ liệu**: MySQL (kết nối trực tiếp qua `mysql2/promise` connection pool với hỗ trợ giao dịch ACID, chỉ mục tối ưu).
---

## 📁 Cấu Trúc Thư Mục Dự Án

```text
DO_AN_CO_SO_NGANH/
├── database/
│   ├── schema.sql              # Cấu trúc CSDL MySQL (bảng, khóa ngoại, chỉ mục)
│   └── seed.sql                # Dữ liệu mẫu ban đầu (sản phẩm, danh mục, người dùng, mã giảm giá)
├── server/
│   ├── config/
│   │   └── db.js               # Kết nối CSDL MySQL thuần túy (Connection Pool, Transactions)
│   ├── controllers/
│   │   ├── productController.js # Xử lý sản phẩm & danh mục
│   │   ├── orderController.js   # Xử lý đơn hàng, tra cứu & voucher
│   │   ├── reviewController.js  # Xử lý đánh giá sao & bình luận
│   │   └── paymentController.js # Xử lý khởi tạo & xác thực thanh toán mô phỏng
│   ├── routes/
│   │   └── api.js              # Khai báo các đường dẫn REST API
│   └── server.js               # Khởi chạy Express server
├── public/
│   ├── index.html              # Trang chủ khách hàng & giỏ hàng & tra cứu
│   ├── admin.html              # Bảng điều khiển quản trị (Admin Dashboard)
│   ├── css/
│   │   ├── style.css           # Giao diện Cyber Tech chính & Dark/Light mode
│   │   ├── admin.css           # Giao diện quản trị hiện đại
│   │   └── payment.css         # Giao diện cổng thanh toán mô phỏng VNPay / MoMo / Thẻ
│   └── js/
│       ├── cart.js             # Quản lý giỏ hàng & LocalStorage
│       ├── payment-gateway.js  # Điều khiển modal cổng thanh toán mô phỏng
│       ├── checkout.js         # Xử lý đặt hàng & hóa đơn
│       ├── app.js              # Ứng dụng chính (lọc, tìm kiếm, modal sản phẩm, tra cứu)
│       └── admin.js            # Quản trị đơn hàng & kho sản phẩm
├── .env.example                # Cấu hình biến môi trường mẫu
├── .env                        # File biến môi trường
├── package.json
└── README.md                   # Hướng dẫn chi tiết
```

---

## 🚀 Hướng Dẫn Cài Đặt & Khởi Chạy

### 1. Yêu cầu môi trường
- Đã cài đặt [Node.js](https://nodejs.org/) (khuyến nghị phiên bản 18+ hoặc mới nhất).
- (Tùy chọn) MySQL Server hoặc XAMPP / MySQL Workbench nếu muốn chạy trực tiếp trên CSDL MySQL.

### 2. Cài đặt các gói phụ thuộc
Mở Terminal/PowerShell tại thư mục dự án và chạy:
```powershell
npm.cmd install
```

### 3. Cấu hình Cơ sở dữ liệu MySQL (Tùy chọn)
1. Mở **MySQL Workbench** hoặc **phpMyAdmin**.
2. Mở file [database/schema.sql](file:///c:/Users/kaziila/Downloads/DO_AN_CO_SO_NGANH/database/schema.sql) và nhấn **Execute (Chạy)** để tạo database `techstore_db` cùng các bảng.
3. Mở tiếp file [database/seed.sql](file:///c:/Users/kaziila/Downloads/DO_AN_CO_SO_NGANH/database/seed.sql) và chạy để nạp dữ liệu mẫu ban đầu.
4. Cấu hình thông tin kết nối trong file `.env`:
```env
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=techstore_db
DB_PORT=3306
```

*(Lưu ý: Nếu không cấu hình MySQL, hệ thống sẽ tự động chạy chế độ dự phòng sẵn sàng 100% dữ liệu để bạn kiểm thử ngay lập tức).*

### 4. Khởi chạy máy chủ
```powershell
node server/server.js
```

### 5. Truy cập hệ thống trên trình duyệt
- **Trang mua sắm khách hàng**: [http://localhost:3000](http://localhost:3000)
- **Trang quản trị Admin**: [http://localhost:3000/admin.html](http://localhost:3000/admin.html)

---

## 💳 Kịch Bản Kiểm Thử Cổng Thanh Toán Mô Phỏng

1. Trên trang chủ, bấm **"Thêm vào giỏ"** một vài sản phẩm (VD: *MacBook Pro M3*, *Sony WH-1000XM5*).
2. Mở **Giỏ hàng**, nhập mã giảm giá `TECH10` hoặc `FREESHIP` và bấm **"Áp dụng"**.
3. Bấm **"Tiến hành đặt hàng"**, điền thông tin người nhận hàng.
4. Chọn phương thức thanh toán **"Cổng VNPAY-QR"** hoặc **"Ví MoMo Sandbox"** hoặc **"Thẻ Quốc Tế"**.
5. Bấm **"Đặt hàng ngay"** ➔ Màn hình cổng thanh toán mô phỏng xuất hiện với mã QR sống động cùng đồng hồ đếm ngược.
6. Bấm nút **"Điền OTP Test"** (mã mặc định `123456`) ➔ Bấm **"Xác nhận thanh toán"**.
7. Hệ thống cập nhật trạng thái đơn thành **Đã thanh toán**, hiển thị thông báo thành công kèm hóa đơn điện tử và mã đơn hàng (VD: `ORD-98241`).
8. Bạn có thể bấm nút **"Tra cứu đơn hàng"** trên thanh Header, nhập mã đơn vừa nhận để xem trạng thái đơn hàng theo thời gian thực!
9. Vào trang **Quản trị Admin** ([http://localhost:3000/admin.html](http://localhost:3000/admin.html)) để duyệt đơn sang `shipping` hoặc `completed`.

---

## 📋 Danh Sách RESTful API

| Phương thức | Đường dẫn API | Chức năng |
|---|---|---|
| `GET` | `/api/products` | Lấy danh sách sản phẩm (có lọc category, brand, giá, sắp xếp, tìm kiếm, phân trang) |
| `GET` | `/api/products/:id` | Lấy thông tin chi tiết của 1 sản phẩm |
| `POST` | `/api/products` | [Admin] Thêm sản phẩm mới vào kho |
| `PUT` | `/api/products/:id` | [Admin] Cập nhật thông tin sản phẩm |
| `DELETE` | `/api/products/:id` | [Admin] Xóa sản phẩm |
| `GET` | `/api/categories` | Lấy danh sách danh mục sản phẩm |
| `POST` | `/api/orders` | Tạo đơn hàng mới |
| `GET` | `/api/orders` | [Admin] Lấy toàn bộ danh sách đơn hàng |
| `GET` | `/api/orders/track/:code` | Tra cứu đơn hàng theo Mã đơn hoặc Số điện thoại |
| `PATCH` | `/api/orders/:id/status` | [Admin] Cập nhật trạng thái đơn và thanh toán |
| `POST` | `/api/coupons/validate` | Kiểm tra và áp dụng mã giảm giá voucher |
| `GET` | `/api/products/:id/reviews` | Lấy danh sách đánh giá của sản phẩm |
| `POST` | `/api/reviews` | Gửi đánh giá sao và nhận xét mới |
| `POST` | `/api/payment/init` | Khởi tạo phiên thanh toán giả lập |
| `POST` | `/api/payment/verify` | Xác thực mã OTP và cập nhật thanh toán đơn hàng |
| `GET` | `/api/stats` | [Admin] Lấy dữ liệu thống kê tổng doanh thu, đơn hàng, sản phẩm |

---
**Chúc các bạn hoàn thành xuất sắc buổi bảo vệ Đồ án Cơ sở ngành!**
