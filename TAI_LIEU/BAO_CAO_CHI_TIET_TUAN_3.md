# BÁO CÁO CHI TIẾT KỸ THUẬT - TUẦN 3
## PHÁT TRIỂN NỀN TẢNG BACKEND NODE.JS, EXPRESS & HỆ THỐNG RESTFUL API CƠ BẢN

> **Đề tài**: XÂY DỰNG WEBSITE THƯƠNG MẠI ĐIỆN TỬ SẢN PHẨM CÔNG NGHỆ (TECHSTORE) TÍCH HỢP CỔNG THANH TOÁN TRỰC TUYẾN  
> **Thời gian thực hiện**: 26/10/2026 – 01/11/2026 (Tuần 3)  
> **Thư mục dự án**: `C:\Users\kaziila\Downloads\Project\DO_AN_CO_SO_NGANH`  
> **File biểu mẫu tiến độ**: [3_MAU_BAO CAO TIEN DO 2026.doc](file:///C:/Users/kaziila/Downloads/Project/DO_AN_CO_SO_NGANH/TAI_LIEU/3_MAU_BAO%20CAO%20TIEN%20DO%202026.doc)

---

## 1. MỤC TIÊU & NHIỆM VỤ CỦA TUẦN 3

Căn cứ theo Đề cương chi tiết đã được Giảng viên hướng dẫn phê duyệt, nhiệm vụ trọng tâm của Tuần 3 bao gồm:
1. **Khởi tạo kiến trúc dự án Backend**: Thiết lập môi trường thực thi Node.js, framework Express.js theo chuẩn phân tầng (Layered MVC Architecture).
2. **Cấu hình kết nối Cơ sở dữ liệu (Database Layer)**:
   - Cấu hình MySQL Connection Pool thông qua thư viện `mysql2/promise`.
   - Đọc các biến môi trường cấu hình linh hoạt từ file `.env` qua thư viện `dotenv`.
   - Xây dựng cơ chế chịu lỗi dự phòng **Fallback Mock Data** giúp máy chủ luôn sẵn sàng phục vụ dữ liệu kể cả khi kết nối CSDL gặp sự cố.
3. **Phát triển các RESTful API Sản phẩm & Danh mục**:
   - `GET /api/categories`: Lấy toàn bộ danh mục ngành hàng.
   - `GET /api/products`: Truy vấn danh sách sản phẩm với hỗ trợ tìm kiếm từ khóa, phân trang, sắp xếp và bộ lọc đa tiêu chí (danh mục, thương hiệu, khoảng giá, và các thuộc tính phần cứng JSON).
   - `GET /api/products/:id`: Lấy chi tiết thông số kỹ thuật, hình ảnh gallery, đánh giá và biến thể của từng sản phẩm.
   - Các API quản trị CRUD sản phẩm: `POST /api/products`, `PUT /api/products/:id`, `DELETE /api/products/:id` có middleware bảo vệ `requireAdmin`.
4. **Phát triển API Mã giảm giá (Coupons)**:
   - `POST /api/coupons/validate`: Xác thực mã giảm giá, kiểm tra điều kiện áp dụng và tính toán số tiền giảm giá.
5. **Kiểm thử API bằng Postman**:
   - Xây dựng bộ test collections kiểm thử các trường hợp dữ liệu hợp lệ và biên lỗi (200 OK, 201 Created, 400 Bad Request, 404 Not Found).

---

## 2. KIẾN TRÚC & CẤU TRÚC PHÂN TẦNG BACKEND

Mã nguồn Backend được tổ chức khoa học trong thư mục `server/` theo mô hình phân tách trách nhiệm (Separation of Concerns):

```text
server/
├── server.js                 # Điểm khởi chạy ứng dụng Express (Entry Point)
├── config/
│   └── db.js                 # Connection Pool, Data Access Layer & Mock Fallback
├── routes/
│   └── api.js                # Định tuyến RESTful API & Middleware phân quyền
└── controllers/
    ├── productController.js  # Nghiệp vụ xử lý Danh mục, Sản phẩm, Flash Sale
    ├── orderController.js    # Nghiệp vụ Xử lý Đơn hàng & Coupon Validation
    ├── reviewController.js   # Nghiệp vụ Đánh giá sao & Hỏi đáp Q&A
    ├── paymentController.js  # Nghiệp vụ Cổng thanh toán mô phỏng
    └── authController.js     # Nghiệp vụ Đăng ký & Đăng nhập
```

---

## 3. CHI TIẾT TRIỂN KHAI KỸ THUẬT

### 3.1. Điểm Khởi Chạy Server (`server/server.js`)
File `server.js` đóng vai trò trung tâm điều phối toàn bộ vòng đời của ứng dụng Express:
- **Cấu hình Middlewares cốt lõi**:
  - `cors()`: Cho phép gọi API an toàn giữa các origin khác nhau.
  - `express.json()` & `express.urlencoded({ extended: true })`: Phân tích tự động nội dung HTTP Request Body dạng JSON và Form Data.
  - Phục vụ tĩnh tài nguyên Client (`public/`) với tùy chọn `{ extensions: ['html'] }` giúp người dùng truy cập trực tiếp các đường dẫn thân thiện (ví dụ: `/laptop` thay vì phải gõ `/laptop.html`).
- **Gắn API Router**: Toàn bộ các endpoints được định tuyến qua tiền tố chuẩn `/api`.
- **Khởi động an toàn**: Hàm `startServer()` khởi tạo kết nối CSDL trước khi mở cổng lắng nghe HTTP (Port 3000), bảo đảm không có request nào phục vụ trong trạng thái CSDL chưa sẵn sàng.

```javascript
// Trích xuất cấu hình khởi chạy trong server/server.js
async function startServer() {
  try {
    await db.init();
    app.listen(PORT, () => {
      console.log(`TECHSTORE SERVER ĐANG CHẠY TẠI: http://localhost:${PORT}`);
    });
  } catch (err) {
    console.error('Lỗi khởi động server:', err.message);
    process.exit(1);
  }
}
startServer();
```

---

### 3.2. Cấu Hình MySQL Connection Pool & Chịu Lỗi Dự Phòng (`server/config/db.js`)
Thay vì tạo mới một kết nối cho mỗi request gây tốn tài nguyên và dễ nghẽn (Connection Exhaustion), hệ thống sử dụng **Connection Pool** từ thư viện `mysql2/promise`:
- `connectionLimit: 10`: Giới hạn tối đa 10 kết nối đồng thời trong pool.
- `enableKeepAlive: true`: Duy trì kết nối sống, tránh bị máy chủ MySQL ngắt kết nối khi nhàn rỗi.
- `decimalNumbers: true`: Tự động ép kiểu các trường giá trị `DECIMAL` (như `price`, `rating_avg`) sang số JavaScript (`Number`) thay vì chuỗi (`String`), loại bỏ lỗi sai lệch phép tính tổng tiền.
- **Cơ chế Fallback Mock Data**: Khi `db.init()` phát hiện không thể kết nối tới MySQL Server, hệ thống chuyển sang chế độ dự phòng trong bộ nhớ (In-memory Mock Mode) với dữ liệu mẫu phong phú. Nhờ đó, bài thuyết trình hoặc quá trình kiểm thử giao diện không bao giờ gặp lỗi sập trang.

---

### 3.3. Phân Hệ RESTful API Sản Phẩm & Danh Mục (`productController.js`)

#### A. API Lấy Danh Mục (`GET /api/categories`)
- **Mục đích**: Cung cấp danh sách các phân loại ngành hàng công nghệ: Điện thoại, Laptop, Tablet, Smartwatch, Âm thanh, Gaming Gear, Thiết bị máy tính.
- **Mã phản hồi**: `200 OK`
- **Cấu trúc JSON trả về**:
  ```json
  {
    "success": true,
    "data": [
      { "id": 1, "name": "Điện thoại", "slug": "smartphone", "icon": "fa-mobile-screen" },
      { "id": 2, "name": "Laptop", "slug": "laptop", "icon": "fa-laptop" },
      { "id": 7, "name": "Thiết bị máy tính", "slug": "components", "icon": "fa-microchip" }
    ]
  }
  ```

#### B. API Truy Vấn & Bộ Lọc Sản Phẩm Đa Chiều (`GET /api/products`)
Hỗ trợ cơ chế lọc động cực kỳ linh hoạt (Dynamic Query Builder) với các tham số:
- `category`: Lọc theo slug danh mục ngành hàng.
- `brand`: Lọc theo thương hiệu sản phẩm (Apple, Asus, Dell, Samsung, Sony,...).
- `minPrice`, `maxPrice`: Khoảng giá tìm kiếm.
- `search`: Từ khóa tìm kiếm theo tên hoặc mô tả sản phẩm.
- `sort`: Tiêu chí sắp xếp (`price-asc`, `price-desc`, `newest`, `popular`).
- `cpu`, `gpu`, `ram`, `storage`, `screen`: Lọc theo các thông số phần cứng lưu trong cột JSON `specifications`.
- `page`, `limit`: Phân trang kết quả.

```javascript
// Minh họa xử lý lọc động trong Data Access Layer
const conditions = [];
const params = [];

if (category) {
  conditions.push('c.slug = ?');
  params.push(category);
}
if (brand) {
  conditions.push('p.brand = ?');
  params.push(brand);
}
if (minPrice) {
  conditions.push('p.price >= ?');
  params.push(Number(minPrice));
}
if (maxPrice) {
  conditions.push('p.price <= ?');
  params.push(Number(maxPrice));
}
if (search) {
  conditions.push('(p.name LIKE ? OR p.brand LIKE ?)');
  params.push(`%${search}%`, `%${search}%`);
}
```

#### C. API Lấy Chi Tiết Sản Phẩm (`GET /api/products/:id`)
Trả về đầy đủ thông số kỹ thuật dạng JSON, danh sách ảnh trong gallery, số sao đánh giá trung bình và các biến thể dung lượng/màu sắc.

---

### 3.4. Phân Hệ API Mã Giảm Giá (`orderController.validateCoupon`)
- **Endpoint**: `POST /api/coupons/validate`
- **Request Body**:
  ```json
  {
    "code": "TECH10",
    "order_value": 15000000
  }
  ```
- **Quy trình kiểm tra nghiệp vụ**:
  1. Kiểm tra mã tồn tại trong bảng `coupons`.
  2. Kiểm tra ngày hết hạn (`expiry_date >= NOW()`).
  3. Kiểm tra số lần sử dụng còn lại (`used_count < usage_limit`).
  4. Kiểm tra điều kiện giá trị đơn hàng tối thiểu (`order_value >= min_order_value`).
  5. Tính toán số tiền chiết khấu (theo phần trăm có áp dụng trần `max_discount` hoặc số tiền cố định).
- **Response Success (200 OK)**:
  ```json
  {
    "success": true,
    "message": "Áp dụng thành công giảm 10%!",
    "data": {
      "code": "TECH10",
      "discount_percent": 10,
      "discount_amount": 500000,
      "final_amount": 14500000
    }
  }
  ```

---

## 4. BẢNG KẾT QUẢ KIỂM THỬ POSTMAN (TEST CASES)

| STT | Endpoint | Method | Dữ Liệu Đầu Vào (Payload / Query) | Kết Quả Mong Đợi | Kết Quả Thực Tế | Trạng Thái |
| :---: | :--- | :---: | :--- | :--- | :--- | :---: |
| **TC01** | `/api/categories` | `GET` | Không tham số | Trả về 7 danh mục sản phẩm, mã `200 OK` | `200 OK`, mảng 7 phần tử | **ĐẠT (PASS)** |
| **TC02** | `/api/products` | `GET` | `?category=laptop&limit=4` | Trả về tối đa 4 laptop, mã `200 OK` | `200 OK`, đúng 4 laptop | **ĐẠT (PASS)** |
| **TC03** | `/api/products` | `GET` | `?search=iphone&minPrice=20000000` | Lọc đúng iPhone giá trên 20 triệu | `200 OK`, đúng điều kiện | **ĐẠT (PASS)** |
| **TC04** | `/api/products/1` | `GET` | `:id = 1` | Chi tiết sản phẩm ID 1 kèm `specifications` | `200 OK`, JSON chi tiết | **ĐẠT (PASS)** |
| **TC05** | `/api/products/9999`| `GET` | `:id = 9999` (ID không tồn tại) | Báo lỗi 404 Không tìm thấy sản phẩm | `404 Not Found` | **ĐẠT (PASS)** |
| **TC06** | `/api/coupons/validate` | `POST` | `{"code":"TECH10", "order_value":15000000}` | Giảm 10% tối đa 500.000đ, mã `200 OK` | `200 OK`, giảm 500.000đ | **ĐẠT (PASS)** |
| **TC07** | `/api/coupons/validate` | `POST` | `{"code":"TECH10", "order_value":500000}` | Báo lỗi chưa đạt đơn tối thiểu 2.000.000đ | `400 Bad Request` | **ĐẠT (PASS)** |
| **TC08** | `/api/coupons/validate` | `POST` | `{"code":"SAIMA"}` | Báo lỗi mã không tồn tại hoặc hết hạn | `404 Not Found` | **ĐẠT (PASS)** |
| **TC09** | `/api/products` | `POST` | Thiếu header `x-user-role: admin` | Chặn truy cập 403 Forbidden | `403 Forbidden` | **ĐẠT (PASS)** |

---

## 5. TỔNG KẾT & KẾ HOẠCH TUẦN 4

- **Đánh giá tiến độ Tuần 3**: Hoàn thành **100%** khối lượng công việc theo đúng Đề cương chi tiết đã cam kết. Nền tảng Backend Node.js & Express.js vận hành ổn định, cấu trúc thư mục rõ ràng, hệ thống RESTful API Sản phẩm, Danh mục và Voucher đáp ứng chuẩn nghiệp vụ bán lẻ công nghệ.
- **Kế hoạch tiếp theo (Tuần 4: 02/11/2026 – 08/11/2026)**:
  1. Phát triển phân hệ RESTful API Đơn hàng (`/api/orders`), cài đặt cơ chế giao dịch CSDL (MySQL Transactions: `BEGIN`, `COMMIT`, `ROLLBACK`) để đảm bảo tính toàn vẹn dữ liệu ACID khi trừ tồn kho và tạo hóa đơn.
  2. Xây dựng API tra cứu tiến trình đơn hàng (`/api/orders/track/:code`).
  3. Xây dựng API Đánh giá sao (`/api/reviews`) và Hỏi đáp đa cấp (`/api/questions`).
  4. Xây dựng API Thống kê số liệu doanh thu (`/api/stats`) phục vụ Dashboard Admin.
