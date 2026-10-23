# BÁO CÁO TIẾN ĐỘ THỰC TẬP ĐỒ ÁN CƠ SỞ NGÀNH

> **Đề tài**: XÂY DỰNG WEBSITE THƯƠNG MẠI ĐIỆN TỬ SẢN PHẨM CÔNG NGHỆ (TECHSTORE) TÍCH HỢP CỔNG THANH TOÁN TRỰC TUYẾN  
> **Thời gian báo cáo**: Từ ngày 12/10/2026 đến ngày 25/10/2026 (Tuần 1 & Tuần 2)  
> **Đơn vị đào tạo**: Khoa Công Nghệ Thông Tin – Trường Kỹ Thuật và Công Nghệ  
> **File biểu mẫu chính thức**: [3_MAU_BAO CAO TIEN DO 2026.doc](file:///c:/Users/kaziila/Downloads/DO_AN_CO_SO_NGANH/TAI_LIEU/3_MAU_BAO%20CAO%20TIEN%20DO%202026.doc)

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

## 2. KẾ HOẠCH THỰC HIỆN THEO ĐỀ CƯƠNG CHI TIẾT (12/10/2026 - 25/10/2026)

| Tuần | Thời gian | Nội dung, công việc thực hiện | Kết quả dự kiến |
| :---: | :---: | :--- | :--- |
| **1** | **12/10/2026 -<br/>18/10/2026** | Khảo sát thực tế hệ thống TMĐT bán lẻ công nghệ (chuẩn Viettel Store); xác định mục tiêu, phạm vi và công nghệ của đề tài; lập đề cương chi tiết. | Bản Đề cương chi tiết hoàn chỉnh được GVHD phê duyệt. |
| **2** | **19/10/2026 -<br/>25/10/2026** | Phân tích yêu cầu hệ thống; xây dựng sơ đồ Use Case; thiết kế mô hình cơ sở dữ liệu quan hệ (ERD) chuẩn 3NF trên MySQL (8 bảng dữ liệu); viết script `schema.sql` và chuẩn bị dữ liệu mẫu `seed.sql`. | Tài liệu đặc tả yêu cầu; Sơ đồ Use Case; Sơ đồ ERD; CSDL `techstore_db` được khởi tạo trên MySQL với dữ liệu mẫu phong phú. |

---

## 3. TIẾN ĐỘ THỰC HIỆN ĐỀ TÀI THỰC TẾ

| Tuần | Thời gian | Công việc theo kế hoạch | Kết quả thực hiện thực tế | Kế hoạch tiếp theo |
| :---: | :---: | :--- | :--- | :--- |
| **1** | **12/10/2026 -<br/>18/10/2026** | Khảo sát thực tế hệ thống TMĐT bán lẻ công nghệ (chuẩn Viettel Store); xác định mục tiêu, phạm vi và công nghệ của đề tài; lập đề cương chi tiết. | - **Hoàn thành 100% công việc** theo đúng tiến độ kế hoạch đề ra.<br/>- Đã khảo sát thực tế mô hình nghiệp vụ bán lẻ công nghệ, luồng trải nghiệm khách hàng và nhận diện thương hiệu Viettel Store (tông màu Đỏ - Trắng hiện đại, danh mục đa tầng, thanh điều hướng ghim, giỏ hàng trượt).<br/>- Xác định rõ kiến trúc kỹ thuật: Backend Node.js & Express.js (RESTful API), CSDL quan hệ MySQL 8.0 (ACID transactions), Frontend Vanilla HTML5/CSS3/JavaScript ES6+; cơ chế mô phỏng cổng thanh toán trực tuyến (VNPAY-QR, Ví MoMo, Thẻ quốc tế với xác thực OTP).<br/>- Hoàn thành bản Đề cương chi tiết đồ án cơ sở ngành và được Giảng viên hướng dẫn duyệt, ký thông qua. | Tiến hành phân tích yêu cầu hệ thống, xây dựng sơ đồ Use Case và thiết kế mô hình CSDL quan hệ cho hệ thống TechStore (Tuần 2). |
| **2** | **19/10/2026 -<br/>25/10/2026** | Phân tích yêu cầu hệ thống; xây dựng sơ đồ Use Case; thiết kế mô hình cơ sở dữ liệu quan hệ (ERD) chuẩn 3NF trên MySQL (8 bảng dữ liệu); viết script `schema.sql` và chuẩn bị dữ liệu mẫu `seed.sql`. | - **Hoàn thành 100% công việc** theo đúng tiến độ kế hoạch đề ra.<br/>- Hoàn thiện tài liệu đặc tả yêu cầu chức năng (phía Khách hàng: xem danh mục, lọc phần cứng, live search, giỏ hàng, đặt hàng, mã voucher, thanh toán trực tuyến mô phỏng, tra cứu đơn hàng, đánh giá/hỏi đáp; phía Quản trị viên: thống kê KPI doanh thu, quản lý đơn hàng, CRUD kho sản phẩm) và yêu cầu phi chức năng (bảo mật, hiệu năng, responsive UI).<br/>- Xây dựng hoàn chỉnh sơ đồ Ca sử dụng (Use Case Diagram) tổng quát và các sơ đồ phân rã chức năng chi tiết.<br/>- Thiết kế mô hình CSDL quan hệ thực thể (ERD) đạt chuẩn dạng chuẩn 3 (3NF) gồm 8 bảng dữ liệu: `categories`, `products`, `orders`, `order_items`, `reviews`, `product_questions`, `coupons`, `users` (kèm bảng `flash_sales` và các chỉ mục Indexes tối ưu hóa truy vấn).<br/>- Viết file script `database/schema.sql` và khởi tạo thành công CSDL `techstore_db` trên MySQL Server 8.0; nạp dữ liệu mẫu phong phú từ `database/seed2.sql` với đầy đủ thông số kỹ thuật (`specifications` JSON) cho các nhóm thiết bị số. | Khởi tạo kiến trúc dự án Backend Node.js & Express.js; cấu hình MySQL Connection Pool và xây dựng các RESTful API phân hệ Sản phẩm, Danh mục, Mã giảm giá (Tuần 3: 26/10/2026 - 01/11/2026). |

---

## 4. KHÓ KHĂN VÀ ĐỀ XUẤT

### 4.1. Khó khăn:
1. **Đặc thù dữ liệu sản phẩm công nghệ**: Các dòng sản phẩm (Laptop, Smartphone, Tablet, Smartwatch, Âm thanh, Gaming Gear) có thông số kỹ thuật (`specifications`) rất đa dạng và phức tạp (CPU, RAM, ROM, Card đồ họa, Tần số quét, Kích thước màn hình,...). Ban đầu gặp khó khăn trong việc thiết kế bảng dữ liệu nếu dùng các cột cố định vì sẽ sinh ra nhiều trường giá trị NULL và khó mở rộng khi bổ sung ngành hàng mới.
2. **Khối lượng dữ liệu mẫu lớn**: Dữ liệu sản phẩm, hình ảnh minh họa, thông số kỹ thuật, giá cả và chương trình khuyến mãi tương đối nhiều, cần thời gian thu thập và chuẩn hóa dữ liệu sát với các hệ thống bán lẻ thực tế.

### 4.2. Đề xuất & Giải pháp đã thực hiện:
1. **Giải pháp CSDL tối ưu**: Đã áp dụng giải pháp lưu trữ thông số kỹ thuật linh hoạt bằng kiểu dữ liệu JSON (cột `specifications`) trên MySQL 8.0 kết hợp với các cột định danh quan trọng có đánh chỉ mục (Index) như `category_id`, `brand`, `price` để vừa đảm bảo tính linh hoạt cho từng ngành hàng, vừa tối ưu hóa tốc độ truy vấn và lọc thuộc tính.
2. **Kế hoạch tiếp theo**: Tiếp tục bám sát tiến độ đề cương chi tiết đã được GVHD phê duyệt; chuẩn bị sẵn môi trường phát triển Backend và tham khảo ý kiến GVHD về thiết kế giao dịch CSDL (Transaction) khi đặt hàng nhằm đảm bảo tính toàn vẹn ACID trong tuần tiếp theo.

---

## 5. XÁC NHẬN VÀ CHỮ KÝ

*Vĩnh Long, ngày 25 tháng 10 năm 2026*

**Sinh viên thực hiện**  
*(Ký, họ và tên)*
