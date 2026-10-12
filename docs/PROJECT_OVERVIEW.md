# Tổng Quan Dự Án TechStore

> **Dự án**: TechStore - Website Thương Mại Điện Tử Bán Lẻ Thiết Bị Công Nghệ  
> **Cấp độ đồ án**: Đồ Án Cơ Sở Ngành  
> **Tài liệu tham chiếu**: [README.md](./README.md) | [ARCHITECTURE.md](./ARCHITECTURE.md)

---

## 1. Giới Thiệu & Mục Đích Dự Án

**TechStore** là một ứng dụng web thương mại điện tử hoàn chỉnh theo mô hình B2C (Business-to-Consumer), chuyên cung cấp các sản phẩm công nghệ cao cấp bao gồm: Điện thoại thông minh (Smartphones), Máy tính xách tay (Laptops), Máy tính bảng (Tablets), Đồng hồ thông minh (Smartwatches), Thiết bị âm thanh (Audio), và Phụ kiện Gaming (Gaming Gear).

Dự án được xây dựng với mục tiêu:
1. Mô phỏng trải nghiệm mua sắm thực tế của các hệ thống bán lẻ hàng đầu tại Việt Nam (lấy cảm hứng từ phong cách giao diện và nhận diện thương hiệu của Viettel Store: tông màu Đỏ tươi `#ee0033` kết hợp nền Trắng tinh gọn).
2. Xây dựng hệ thống lọc phần cứng chuyên sâu (CPU, GPU, RAM, Ổ cứng, Tần số quét,...) giúp người dùng dễ dàng tìm kiếm sản phẩm phù hợp với nhu cầu kỹ thuật.
3. Cung cấp quy trình khép kín từ xem sản phẩm, đánh giá, hỏi đáp, áp mã giảm giá, đặt hàng COD đến mô phỏng cổng thanh toán trực tuyến (VNPAY, MoMo, Thẻ quốc tế với mã OTP bảo mật).
4. Cung cấp giao diện quản trị viên (Admin Dashboard) để quản lý danh mục sản phẩm, đơn hàng và sự kiện Flash Sale.

---

## 2. Công Nghệ & Thư Viện Sử Dụng

Dự án được phát triển theo định hướng **Clean Architecture & Vanilla-First** nhằm nắm vững bản chất hoạt động của web mà không bị phụ thuộc vào các framework frontend phức tạp:

| Thành phần | Công nghệ / Thư viện | Phiên bản | Vai trò & Mục đích |
| :--- | :--- | :--- | :--- |
| **Runtime Backend** | Node.js | v18.x / v20.x | Nền tảng thực thi JavaScript phía máy chủ |
| **Web Framework** | Express.js | `^4.19.2` | Định tuyến RESTful API, quản lý middleware và static serving |
| **Cơ sở dữ liệu** | MySQL | 8.0+ | Lưu trữ dữ liệu quan hệ (InnoDB, hỗ trợ ACID Transactions) |
| **Database Driver** | `mysql2` | `^3.9.7` | Kết nối MySQL với hỗ trợ Promise API & Connection Pooling |
| **Cấu hình môi trường** | `dotenv` | `^16.4.5` | Đọc các biến cấu hình từ file `.env` |
| **CORS Middleware** | `cors` | `^2.8.5` | Cho phép các yêu cầu HTTP Cross-Origin khi cần thiết |
| **Frontend Markup** | HTML5 | Chuẩn W3C | Cấu trúc ngữ nghĩa (`<header>`, `<nav>`, `<main>`, `<section>`, `<aside>`) |
| **Frontend Styling** | Vanilla CSS3 | W3C Standard | Hệ thống biến CSS (Tokens), Grid, Flexbox, Animation, Media Queries |
| **Frontend Scripting** | Vanilla ES6+ | ECMAScript 2020+ | Hướng đối tượng dạng Singleton, DOM manipulation, Async/Await |
| **Bộ Icon** | Font Awesome Free | 6.5.1 CDN | Hiển thị biểu tượng tương tác và nút bấm |
| **Phông chữ** | Google Fonts (Inter) | 300 - 800 | Phông chữ hiện đại, tối ưu khả năng đọc trên màn hình kỹ thuật số |

---

## 3. Hướng Dẫn Cài Đặt & Khởi Chạy

### 3.1. Yêu Cầu Môi Trường
- **Node.js**: Phiên bản 18.0.0 trở lên.
- **MySQL Server**: Phiên bản 8.0 trở lên (khuyên dùng MySQL Workbench hoặc XAMPP/Laragon).
- **Trình duyệt web**: Chrome, Edge, Firefox hoặc Safari phiên bản mới.

### 3.2. Các Bước Cài Đặt

#### Bước 1: Cài đặt các gói phụ thuộc
Tại thư mục gốc của dự án, mở terminal/command prompt và thực thi:
```bash
npm install
```

#### Bước 2: Thiết lập cơ sở dữ liệu MySQL
1. Khởi động dịch vụ MySQL.
2. Mở công cụ quản trị MySQL (MySQL Workbench hoặc phpMyAdmin) và tạo cơ sở dữ liệu:
   ```sql
   CREATE DATABASE techstore_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
3. Nạp cấu trúc bảng và dữ liệu mẫu:
   - Thực thi file `database/schema.sql` (tạo các bảng `categories`, `products`, `orders`, `order_items`, `reviews`, `product_questions`, `coupons`, `users`, `flash_sales`).
   - Thực thi file `database/seed2.sql` (hoặc `seed2.sql` ở thư mục gốc) để nạp toàn bộ danh mục sản phẩm và dữ liệu mẫu phong phú.

#### Bước 3: Cấu hình biến môi trường (`.env`)
Tạo file `.env` tại thư mục gốc (hoặc sao chép từ `.env.example`) với nội dung:
```env
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=techstore_db
DB_PORT=3306
```
*(Thay thế `your_mysql_password` bằng mật khẩu tài khoản MySQL của bạn)*.

#### Bước 4: Khởi chạy máy chủ
Chạy lệnh khởi động ứng dụng:
```bash
npm start
```
Hoặc:
```bash
node server/server.js
```

Sau khi khởi chạy thành công, console sẽ hiển thị:
```
Server is running on port 3000
Database connected successfully
```

#### Bước 5: Truy cập ứng dụng
Mở trình duyệt và truy cập các địa chỉ:
- **Trang chủ người dùng**: `http://localhost:3000` hoặc `http://localhost:3000/index.html`
- **Trang ngành hàng**: `http://localhost:3000/laptop.html`, `http://localhost:3000/smartphone.html`, ...
- **Trang đăng nhập / đăng ký**: `http://localhost:3000/login.html`
- **Trang quản trị (Admin Dashboard)**: `http://localhost:3000/admin.html`

---

## 4. Các Chức Năng Chính Của Hệ Thống

### 4.1. Phía Khách Hàng (Client-Side)
1. **Duyệt Danh Mục Chuyên Biệt**: Trang chủ tổng hợp và 6 trang ngành hàng độc lập (`smartphone.html`, `laptop.html`, `tablet.html`, `smartwatch.html`, `audio.html`, `gaming-gear.html`).
2. **Bộ Lọc Đa Tiêu Chí Dạng Accordion**: Lọc sản phẩm theo Thương hiệu, Mức giá và các đặc tả phần cứng chi tiết (CPU, GPU, RAM, Ổ cứng, Kích thước màn hình, Tần số quét, Kiểu kết nối,...).
3. **Tìm Kiếm Tức Thời (Live Search)**: Tìm kiếm sản phẩm theo tên hoặc hãng với cơ chế highlight từ khóa và gợi ý kết quả ngay tại ô tìm kiếm.
4. **Sự Kiện Flash Sale Động**: Đồng hồ đếm ngược thời gian thực, thanh tiến độ số lượng đã bán (`sold_count` / `stock_quantity`), giá sốc giới hạn.
5. **Xem Chi Tiết & Biến Thể Sản Phẩm**: Modal chi tiết hiển thị hình ảnh, thông số kỹ thuật đầy đủ, chọn màu sắc/dung lượng, kiểm tra tình trạng tồn kho.
6. **Đánh Giá & Hỏi Đáp (Reviews & Q&A)**: Hệ thống chấm sao (1-5 sao), gửi bình luận đánh giá, gửi câu hỏi thắc mắc và hệ thống trả lời phân cấp.
7. **Giỏ Hàng Reactive**: Cập nhật số lượng tức thì, tính toán tổng tiền, kiểm tra giới hạn tồn kho, tự động lưu trữ vào `localStorage`.
8. **Mã Giảm Giá (Coupon System)**: Hỗ trợ kiểm tra và áp dụng mã voucher (`TECH10`, `FREESHIP`, `SUPERTECH`, `CHAOBANMOI`) với logic giảm theo phần trăm hoặc số tiền cố định.
9. **Quy Trình Đặt Hàng & Thanh Toán Mô Phỏng**:
   - Thanh toán khi nhận hàng (COD).
   - Cổng thanh toán trực tuyến mô phỏng VNPAY (QR Code), Ví MoMo (QR Code), và Thẻ tín dụng/ghi nợ quốc tế Visa/Mastercard (kèm quy trình xác thực mã OTP gửi về điện thoại với đồng hồ đếm ngược 10 phút).
10. **Tra Cứu Đơn Hàng Đa Kênh**: Khách hàng có thể tra cứu lịch sử mua hàng theo Mã đơn hàng (`#ORD-...`), Số điện thoại hoặc Email mà không bắt buộc phải đăng nhập. Nếu đã đăng nhập, hệ thống tự động tải danh sách "Đơn hàng của tôi".

### 4.2. Phía Quản Trị Viên (Admin-Side)
1. **Dashboard Thống Kê**: Tổng quan số lượng đơn hàng, doanh thu và sản phẩm.
2. **Quản Lý Đơn Hàng**: Xem danh sách toàn bộ đơn hàng, lọc theo trạng thái (`pending`, `confirmed`, `shipping`, `completed`, `cancelled`), xem chi tiết từng món hàng và cập nhật trạng thái đơn hàng.
3. **Quản Lý Sản Phẩm**: Thêm sản phẩm mới, chỉnh sửa thông tin kỹ thuật, cập nhật giá bán, hình ảnh và số lượng tồn kho.
4. **Quản Lý Flash Sale**: Kích hoạt sự kiện giảm giá, thiết lập giá Flash Sale và thời gian kết thúc.

---

## 5. Trạng Thái Hiện Tại Của Dự Án

- **Độ hoàn thiện**: Đạt 95% yêu cầu của một Đồ án Cơ sở ngành Thương mại điện tử. Toàn bộ các tương tác UI/UX, bộ lọc, giỏ hàng, đặt hàng, thanh toán mô phỏng và trang quản trị đều hoạt động ổn định.
- **Dữ liệu**: Cơ sở dữ liệu mẫu (`seed2.sql`) cung cấp hàng chục sản phẩm chân thực kèm hình ảnh CDN chất lượng cao từ Viettel Store, FPT Shop và CellphoneS.
- **Cơ chế chịu lỗi (Fault-Tolerance)**: File cấu hình DB (`server/config/db.js`) được trang bị sẵn cơ chế mock data dự phòng, giúp giao diện vẫn có thể duyệt sản phẩm mẫu ngay cả khi máy tính người dùng chưa cài đặt hoặc cấu hình sai MySQL.

---

## 6. Những Giới Hạn Đã Biết (Known Limitations)

1. **Cơ chế Xác thực (Auth)**: Hiện tại mật khẩu người dùng đang được so sánh trực tiếp (plain-text) trong cơ sở dữ liệu mẫu phục vụ mục đích kiểm thử nhanh của đồ án; chưa băm bằng `bcrypt`.
2. **Ủy quyền Quản trị (Admin Authorization)**: Quyền admin ở backend hiện xác thực qua header `x-user-role: admin` do frontend gửi kèm thay vì kiểm tra JWT Token có chữ ký số bí mật.
3. **Cổng thanh toán**: Các phương thức VNPAY, MoMo và Thẻ tín dụng hoạt động dưới dạng mô phỏng giao diện và logic xác thực OTP; chưa ký hợp đồng tích hợp Merchant API thực tế với các ngân hàng/ví điện tử.

*(Các giới hạn này được phân tích chi tiết kèm lộ trình khắc phục trong tài liệu [TECH_DEBT.md](./TECH_DEBT.md))*.
