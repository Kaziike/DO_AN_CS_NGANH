# Nợ Kỹ Thuật & Đề Xuất Cải Tiến TechStore (Technical Debt)

> **Dự án**: TechStore - Website Bán Lẻ Công Nghệ  
> **Tài liệu tham chiếu**: [ARCHITECTURE.md](./ARCHITECTURE.md) | [API_AND_STORAGE.md](./API_AND_STORAGE.md)

---

## 1. Phân Tích Nợ Kỹ Thuật Hiện Tại (Current Technical Debt)

Dự án TechStore hiện tại hoàn thành xuất sắc các mục tiêu nghiệp vụ của một Đồ án Cơ sở ngành (giao diện đẹp mắt theo chuẩn Viettel Store, đầy đủ tính năng giỏ hàng, đặt hàng, lọc phần cứng, thanh toán mô phỏng và quản trị). Tuy nhiên, để đưa hệ thống vào vận hành thương mại thực tế, tồn tại một số nợ kỹ thuật cần được ghi nhận và khắc phục:

---

### 1.1. Nợ Kỹ Thuật Về Bảo Mật & Xác Thực (Security & Auth Debt)

#### A. Mật Khẩu Lưu Trữ Dạng Plain-Text
- **Hiện trạng**: Trong bảng `users` và controller `server/controllers/authController.js`, mật khẩu người dùng được lưu trữ và so sánh trực tiếp dưới dạng văn bản gốc (plain-text).
- **Rủi ro**: Nếu cơ sở dữ liệu bị lộ, toàn bộ thông tin đăng nhập của người dùng sẽ bị rò rỉ.
- **Giải pháp**:
  - Tích hợp thư viện `bcryptjs` hoặc `argon2`.
  - Băm mật khẩu khi đăng ký: `await bcrypt.hash(password, 10)`.
  - Đối chiếu khi đăng nhập: `await bcrypt.compare(password, user.password)`.

#### B. Phân Quyền Quản Trị Dựa Trên Header Giả Lập (`x-user-role`)
- **Hiện trạng**: Middleware `requireAdmin` tại `server/routes/api.js` chỉ kiểm tra giá trị của HTTP Header `x-user-role: admin` do trình duyệt gửi lên. Đồng thời ở phía client, quyền admin được đọc từ `localStorage.techstore_user.role`.
- **Rủi ro**: Bất kỳ người dùng nào có kiến thức kỹ thuật đều có thể sử dụng Postman hoặc sửa `localStorage` để gọi các API nhạy cảm (xóa sản phẩm, duyệt đơn hàng).
- **Giải pháp**:
  - Áp dụng cơ chế **JSON Web Token (JWT)** có chữ ký bí mật từ máy chủ (`process.env.JWT_SECRET`).
  - Lưu JWT Token trong `HttpOnly, Secure Cookie` để chống tấn công XSS đánh cắp phiên.
  - Middleware phía server giải mã token để xác thực quyền hạn thực sự của tài khoản từ cơ sở dữ liệu.

---

### 1.2. Nợ Kỹ Thuật Về Kiến Trúc Mã Nguồn (Codebase Architecture Debt)

#### A. File `public/js/app.js` Quá Lớn (Monolithic Client Controller)
- **Hiện trạng**: File `app.js` chứa hơn 2.530 dòng code, gánh vác quá nhiều trọng trách: Hero slider, đếm ngược flash sale, bộ lọc accordion, live search, product modal, reviews, q&a, tra cứu đơn hàng, widget cuộn trang.
- **Rủi ro**: Khó bảo trì, nguy cơ xung đột khi nhiều lập trình viên cùng chỉnh sửa, khó viết Unit Test độc lập.
- **Giải pháp**:
  - Chia nhỏ đối tượng `App` thành các Sub-modules sử dụng chuẩn **ES6 Modules (`import`/`export`)**:
    - `modules/ui/slider.js`: Quản lý Hero banner slider.
    - `modules/ui/filters.js`: Quản lý logic bộ lọc accordion.
    - `modules/ui/search.js`: Quản lý live search dropdown.
    - `modules/ui/product-modal.js`: Quản lý hiển thị chi tiết sản phẩm.
    - `modules/ui/reviews.js`: Quản lý đánh giá và hỏi đáp.
    - `modules/ui/tracker.js`: Quản lý tra cứu đơn hàng.

#### B. File `public/css/style.css` Hơn 4.200 Dòng Đơn Lẻ
- **Hiện trạng**: Toàn bộ phong cách của 7 trang web đều dồn vào một file duy nhất.
- **Rủi ro**: Kích thước tải ban đầu lớn, khó định vị các selector bị ghi đè (specificity conflicts).
- **Giải pháp**: Tách stylesheet thành các file nhỏ theo cấu trúc thư mục rõ ràng:
  - `css/base/` (reset, typography, variables).
  - `css/components/` (header, footer, card, modal, button).
  - `css/pages/` (home, category, checkout).
  - Sử dụng `@import` hoặc nạp có chọn lọc theo trang.

---

### 1.3. Nợ Kỹ Thuật Về Hiệu Năng & Cơ Sở Dữ Liệu (Performance Debt)

#### A. Đánh Chỉ Mục (Database Indexing)
- **Hiện trạng**: Các trường thường xuyên tìm kiếm như `customer_phone`, `customer_email`, `order_code` trong bảng `orders` chưa được đánh chỉ mục B-Tree Index.
- **Rủi ro**: Khi số lượng đơn hàng tăng lên hàng chục ngàn bản ghi, việc tra cứu đơn hàng sẽ bị chậm đáng kể (Full Table Scan).
- **Giải pháp**: Bổ sung chỉ mục:
  ```sql
  ALTER TABLE orders ADD INDEX idx_phone (customer_phone);
  ALTER TABLE orders ADD INDEX idx_email (customer_email);
  ALTER TABLE products ADD INDEX idx_category_brand (category_id, brand);
  ```

#### B. Tối Ưu Hình Ảnh (Image Optimization)
- **Hiện trạng**: Nhiều sản phẩm sử dụng ảnh gốc có kích thước lớn từ CDN, chưa áp dụng chuẩn nén WebP/AVIF và thuộc tính `loading="lazy"`.
- **Giải pháp**: Bổ sung `loading="lazy"` trên toàn bộ các thẻ `<img>` thuộc danh sách sản phẩm và chuyển đổi sang định dạng WebP để tăng điểm Google PageSpeed Insights.

---

## 2. Lộ Trình Cải Tiến (Improvement Roadmap)

| Mức Độ Ưu Tiên | Hạng Mục Cải Tiến | Thời Gian Dự Kiến | Kết Quả Đạt Được |
| :---: | :--- | :---: | :--- |
| 🔴 **Ưu Tiên 1 (Cao)** | Mã hóa mật khẩu bằng `bcryptjs` | 1 - 2 ngày | Loại bỏ rủi ro rò rỉ thông tin người dùng trong DB |
| 🔴 **Ưu Tiên 1 (Cao)** | Triển khai JWT Token xác thực Admin | 2 - 3 ngày | Bảo vệ toàn diện các API quản trị khỏi bị can thiệp trái phép |
| 🟡 **Ưu Tiên 2 (Trung bình)** | Tách nhỏ `app.js` thành ES6 Modules | 3 - 5 ngày | Cấu trúc code module hóa, dễ bảo trì và mở rộng |
| 🟡 **Ưu Tiên 2 (Trung bình)** | Thêm Database Indexes cho đơn hàng | 1 ngày | Tăng tốc độ truy vấn tra cứu đơn hàng gấp 10 lần |
| 🟢 **Ưu Tiên 3 (Thấp)** | Tích hợp VNPAY Sandbox thật | 3 - 5 ngày | Chuyển đổi từ cổng mô phỏng sang thanh toán trực tuyến thực |
| 🟢 **Ưu Tiên 3 (Thấp)** | Tối ưu hình ảnh WebP & Lazy loading | 2 ngày | Giảm 60% băng thông tải trang ban đầu |
