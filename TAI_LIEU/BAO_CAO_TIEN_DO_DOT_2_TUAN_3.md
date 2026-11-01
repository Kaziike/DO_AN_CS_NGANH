# BÁO CÁO TIẾN ĐỘ THỰC TẬP ĐỒ ÁN CƠ SỞ NGÀNH - TUẦN 3

> **Đề tài**: XÂY DỰNG WEBSITE THƯƠNG MẠI ĐIỆN TỬ SẢN PHẨM CÔNG NGHỆ (TECHSTORE) TÍCH HỢP CỔNG THANH TOÁN TRỰC TUYẾN  
> **Thời gian báo cáo**: Từ ngày 26/10/2026 đến ngày 01/11/2026 (Tuần 3 - Đợt 2)  
> **Đơn vị đào tạo**: Khoa Công Nghệ Thông Tin – Trường Kỹ Thuật và Công Nghệ  
> **File biểu mẫu chính thức**: 
> - [3_MAU_BAO CAO TIEN DO 2026.doc](file:///C:/Users/kaziila/Downloads/Project/DO_AN_CO_SO_NGANH/TAI_LIEU/3_MAU_BAO%20CAO%20TIEN%20DO%202026.doc) *(Bản lũy kế Tuần 1, 2, 3)*  
> - [3_MAU_BAO CAO TIEN DO 2026_TUAN_3_RIENG.doc](file:///C:/Users/kaziila/Downloads/Project/DO_AN_CO_SO_NGANH/TAI_LIEU/3_MAU_BAO%20CAO%20TIEN%20DO%202026_TUAN_3_RIENG.doc) *(Bản riêng Tuần 3)*

---

## 1. THÔNG TIN CHUNG

- **Tên đề tài**: **XÂY DỰNG WEBSITE THƯƠNG MẠI ĐIỆN TỬ SẢN PHẨM CÔNG NGHỆ (TECHSTORE) TÍCH HỢP CỔNG THANH TOÁN TRỰC TUYẾN**
- **Sinh viên thực hiện**:
  - Họ và tên: ............................................................................
  - MSSV: ....................................................................................
  - Điện thoại: ...........................................................................
  - Email: ...................................................................................
  - Mã lớp: .................................................................................
- **Giảng viên hướng dẫn**:
  - Họ và tên: ............................................................................
  - Học hàm, học vị: .................................................................

---

## 2. KẾ HOẠCH THỰC HIỆN THEO ĐỀ CƯƠNG CHI TIẾT

| Tuần | Thời gian | Nội dung, công việc thực hiện | Kết quả dự kiến |
| :---: | :---: | :--- | :--- |
| **1** | **12/10/2026 -<br/>18/10/2026** | Khảo sát thực tế hệ thống TMĐT bán lẻ công nghệ (chuẩn Viettel Store); xác định mục tiêu, phạm vi và công nghệ của đề tài; lập đề cương chi tiết. | Bản Đề cương chi tiết hoàn chỉnh được GVHD phê duyệt. |
| **2** | **19/10/2026 -<br/>25/10/2026** | Phân tích yêu cầu hệ thống; xây dựng sơ đồ Use Case; thiết kế mô hình cơ sở dữ liệu quan hệ (ERD) chuẩn 3NF trên MySQL (8 bảng dữ liệu); viết script `schema.sql` và chuẩn bị dữ liệu mẫu `seed.sql`. | Tài liệu đặc tả yêu cầu; Sơ đồ Use Case; Sơ đồ ERD; CSDL `techstore_db` được khởi tạo trên MySQL với dữ liệu mẫu phong phú. |
| **3** | **26/10/2026 -<br/>01/11/2026** | Khởi tạo kiến trúc Backend Node.js & Express.js; cấu hình MySQL Connection Pool và chế độ Fallback Mock Data dự phòng; phát triển các RESTful API Sản phẩm & Danh mục (/api/products, /api/categories), mã giảm giá (/api/coupons/validate). | Nền tảng Backend hoạt động ổn định; hoàn thành và kiểm thử thành công các API sản phẩm, danh mục, voucher bằng Postman. |

---

## 3. TIẾN ĐỘ THỰC HIỆN ĐỀ TÀI THỰC TẾ

| Tuần | Thời gian | Công việc theo kế hoạch | Kết quả thực hiện thực tế | Kế hoạch tiếp theo |
| :---: | :---: | :--- | :--- | :--- |
| **1** | **12/10/2026 -<br/>18/10/2026** | Khảo sát thực tế hệ thống TMĐT bán lẻ công nghệ (chuẩn Viettel Store); xác định mục tiêu, phạm vi và công nghệ của đề tài; lập đề cương chi tiết. | - **Hoàn thành 100% công việc** theo đúng tiến độ kế hoạch đề ra.<br/>- Đã khảo sát thực tế mô hình nghiệp vụ bán lẻ công nghệ, luồng trải nghiệm khách hàng và nhận diện thương hiệu Viettel Store (tông màu Đỏ - Trắng hiện đại, danh mục đa tầng, thanh điều hướng ghim, giỏ hàng trượt).<br/>- Xác định rõ kiến trúc kỹ thuật: Backend Node.js & Express.js (RESTful API), CSDL quan hệ MySQL 8.0 (ACID transactions), Frontend Vanilla HTML5/CSS3/JavaScript ES6+; cơ chế mô phỏng cổng thanh toán trực tuyến (VNPAY-QR, Ví MoMo, Thẻ quốc tế với xác thực OTP).<br/>- Hoàn thành bản Đề cương chi tiết đồ án cơ sở ngành và được Giảng viên hướng dẫn duyệt, ký thông qua. | Tiến hành phân tích yêu cầu hệ thống, xây dựng sơ đồ Use Case và thiết kế mô hình CSDL quan hệ cho hệ thống TechStore (Tuần 2). |
| **2** | **19/10/2026 -<br/>25/10/2026** | Phân tích yêu cầu hệ thống; xây dựng sơ đồ Use Case; thiết kế mô hình cơ sở dữ liệu quan hệ (ERD) chuẩn 3NF trên MySQL (8 bảng dữ liệu); viết script `schema.sql` và chuẩn bị dữ liệu mẫu `seed.sql`. | - **Hoàn thành 100% công việc** theo đúng tiến độ kế hoạch đề ra.<br/>- Hoàn thiện tài liệu đặc tả yêu cầu chức năng (phía Khách hàng và Quản trị viên) và yêu cầu phi chức năng (bảo mật, hiệu năng, responsive UI).<br/>- Xây dựng hoàn chỉnh sơ đồ Ca sử dụng (Use Case Diagram) tổng quát và các sơ đồ phân rã chức năng chi tiết.<br/>- Thiết kế mô hình CSDL quan hệ thực thể (ERD) đạt chuẩn dạng chuẩn 3 (3NF) gồm 8 bảng dữ liệu: `categories`, `products`, `orders`, `order_items`, `reviews`, `product_questions`, `coupons`, `users` (kèm bảng `flash_sales` và các chỉ mục Indexes tối ưu hóa truy vấn).<br/>- Viết file script `database/schema.sql` và khởi tạo thành công CSDL `techstore_db` trên MySQL Server 8.0; nạp dữ liệu mẫu phong phú từ `database/seed2.sql` với đầy đủ thông số kỹ thuật (`specifications` JSON) cho các nhóm thiết bị số. | Khởi tạo kiến trúc dự án Backend Node.js & Express.js; cấu hình MySQL Connection Pool và xây dựng các RESTful API phân hệ Sản phẩm, Danh mục, Mã giảm giá (Tuần 3: 26/10/2026 - 01/11/2026). |
| **3** | **26/10/2026 -<br/>01/11/2026** | Khởi tạo kiến trúc Backend Node.js & Express.js; cấu hình MySQL Connection Pool và chế độ Fallback Mock Data dự phòng; phát triển các RESTful API Sản phẩm & Danh mục (/api/products, /api/categories), mã giảm giá (/api/coupons/validate). | - **Hoàn thành 100% công việc** theo đúng tiến độ kế hoạch đề ra.<br/>- Khởi tạo hoàn chỉnh cấu trúc dự án Backend Node.js & Express.js chuẩn phân tầng MVC (`server.js`, `config/db.js`, `routes/api.js`, `controllers/productController.js`, `orderController.js`) tích hợp middleware `cors`, `express.json`, `urlencoded` và `dotenv`.<br/>- Cấu hình thành công kết nối CSDL MySQL 8.0 sử dụng Connection Pool với thư viện `mysql2/promise` (`connectionLimit: 10`, `enableKeepAlive: true`, `decimalNumbers: true`), đảm bảo tái sử dụng kết nối và tối ưu hiệu năng; xây dựng cơ chế Fallback Mock Data dự phòng đảm bảo tính sẵn sàng cao khi CSDL mất kết nối.<br/>- Phát triển và hoàn thiện các RESTful API phân hệ Sản phẩm & Danh mục: `GET /api/categories` (lấy danh mục thiết bị), `GET /api/products` (truy vấn lọc nâng cao đa tiêu chí theo brand, giá, danh mục, thông số phần cứng JSON cpu/ram/storage/screen, live search từ khóa, phân trang và sắp xếp), `GET /api/products/:id` (chi tiết sản phẩm kèm gallery và biến thể); cùng các API quản trị CRUD sản phẩm có middleware `requireAdmin` bảo vệ.<br/>- Phát triển hoàn thiện API Mã giảm giá: `POST /api/coupons/validate` (kiểm tra tính hợp lệ của voucher, đối chiếu điều kiện đơn hàng tối thiểu và tính mức chiết khấu chính xác theo % hoặc tiền mặt).<br/>- Thực hiện kiểm thử toàn bộ các API endpoint bằng Postman: kiểm thử thành công các mã phản hồi HTTP (`200 OK`, `201 Created`, `400 Bad Request`, `404 Not Found`) và dữ liệu JSON chuẩn mực, thời gian phản hồi nhanh (< 50ms). | Phát triển các RESTful API phân hệ Đơn hàng (/api/orders), tra cứu đơn hàng (/api/orders/track), cài đặt giao dịch CSDL (Transaction: Begin, Commit, Rollback); API Đánh giá sao & Hỏi đáp (/api/reviews, /api/questions); API Thống kê số liệu (/api/stats) (Tuần 4: 02/11/2026 - 08/11/2026). |

---

## 4. KHÓ KHĂN VÀ ĐỀ XUẤT

### 4.1. Khó khăn:
1. **Xây dựng câu truy vấn động đa tiêu chí (Dynamic Query Builder)**: Trong quá trình phát triển API lấy danh sách sản phẩm (`/api/products`), việc kết hợp đồng thời nhiều tiêu chí lọc phức tạp (lọc theo danh mục, khoảng giá, thương hiệu, sắp xếp, tìm kiếm từ khóa và các thuộc tính lưu trong trường JSON `specifications` như CPU, RAM, Ổ cứng, GPU) đòi hỏi xử lý logic ghép nối câu lệnh `WHERE` cẩn thận để không làm suy giảm tốc độ truy vấn.
2. **Nghiệp vụ kiểm tra mã giảm giá (Coupon Validation)**: Có nhiều ràng buộc điều kiện (hạn sử dụng, tổng tiền đơn hàng tối thiểu, mức giảm tối đa) cần xử lý chặt chẽ ở tầng Backend nhằm tránh gian lận khuyến mãi.

### 4.2. Đề xuất & Giải pháp đã thực hiện:
1. **Truy vấn tham số hóa an toàn**: Đã áp dụng kỹ thuật Parameterized Query (truy vấn tham số hóa với dấu hỏi chấm `?`) trong `mysql2/promise` để đảm bảo an toàn tuyệt đối chống tấn công SQL Injection; đồng thời tối ưu hóa các chỉ mục (Indexes) trên các cột thường xuyên lọc như `category_id`, `brand`, `price`.
2. **Module hóa Controller & Middleware**: Đã tổ chức module hóa các hàm xử lý API trong thư mục `controllers/` và cấu hình middleware `requireAdmin` độc lập; chuẩn bị sẵn sàng cấu trúc dữ liệu để tuần 4 triển khai các API xử lý giao dịch đơn hàng (Database Transactions đảm bảo ACID).

---

## 5. XÁC NHẬN VÀ CHỮ KÝ

*Vĩnh Long, ngày 01 tháng 11 năm 2026*

**Sinh viên thực hiện**  
*(Ký, họ và tên)*
