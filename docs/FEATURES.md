# Ma Trận Tính Năng Hệ Thống TechStore

> **Dự án**: TechStore - Website Bán Lẻ Công Nghệ  
> **Tài liệu tham chiếu**: [PROJECT_OVERVIEW.md](./PROJECT_OVERVIEW.md) | [DATA_FLOW.md](./DATA_FLOW.md) | [API_AND_STORAGE.md](./API_AND_STORAGE.md)

---

## 1. Bảng Tổng Hợp Trạng Thái Tính Năng

Hệ thống tính năng của TechStore được phân loại theo 3 trạng thái thực tế:
- **Đã hoàn thiện (Done)**: Hoạt động đầy đủ từ giao diện, JavaScript đến API và cơ sở dữ liệu MySQL.
- **Mô phỏng (Simulation)**: Giao diện và logic nghiệp vụ hoạt động hoàn chỉnh ở môi trường đồ án (có sinh mã, đếm ngược, xác thực giả lập), chưa tích hợp cổng thanh toán ngân hàng thực tế.
- **Đang phát triển (Planned)**: Tính năng định hướng nâng cấp trong tương lai.

---

## 2. Ma Trận Chi Tiết Toàn Bộ Tính Năng

| STT | Tên Chức Năng | File Liên Quan | Logic Chính | Đầu Vào / Đầu Ra | Trạng Thái | Lưu Ý Khi Chỉnh Sửa |
| :---: | :--- | :--- | :--- | :--- | :---: | :--- |
| **1** | **Duyệt Danh Mục Chuyên Biệt** | `*.html`, `app.js`, `productController.js`, `db.js` | Nhận diện trang bằng `document.body.dataset.category`, gọi `GET /api/products?category=...`, render lưới sản phẩm. | **Vào**: category slug<br/>**Ra**: Danh sách sản phẩm HTML | **Đã hoàn thiện** | Đảm bảo giá trị `data-category` trên thẻ `<body>` khớp chính xác với slug trong bảng `categories`. |
| **2** | **Bộ Lọc Phần Cứng Accordion** | `*.html`, `style.css`, `app.js` | Lắng nghe `change` trên checkbox bộ lọc, gom thành mảng tiêu chí, lọc dữ liệu mảng `App.products` theo thông số JSON `specifications`. | **Vào**: Checkbox tiêu chí<br/>**Ra**: Lưới sản phẩm đã lọc | **Đã hoàn thiện** | Cấu trúc thuộc tính trong `specifications` JSON của sản phẩm phải khớp với `name` của input checkbox. |
| **3** | **Tìm Kiếm Tức Thời (Live Search)** | `app.js`, `style.css`, `productController.js` | Debounce 300ms khi gõ vào `#search-input`, gọi API search hoặc lọc client, highlight từ khóa tìm kiếm, hiển thị dropdown gợi ý. | **Vào**: Chuỗi ký tự từ khóa<br/>**Ra**: Dropdown danh sách gợi ý | **Đã hoàn thiện** | Kiểm tra hàm escape HTML khi highlight từ khóa để tránh lỗi XSS. |
| **4** | **Sự Kiện Flash Sale Động** | `index.html`, `app.js`, `productController.js`, `db.js` | `setInterval` đếm ngược thời gian kết thúc (giờ, phút, giây), tính tỷ lệ phần trăm thanh tiến độ `sold_count / stock_quantity`. | **Vào**: Bảng `flash_sales`<br/>**Ra**: Đồng hồ đếm ngược & thanh tiến độ | **Đã hoàn thiện** | Khi `end_time` đã qua, kiểm tra logic ẩn khối hoặc hiển thị thông báo "Sự kiện kết thúc". |
| **5** | **Xem Chi Tiết & Biến Thể Sản Phẩm** | `app.js`, `style.css`, `productController.js` | Mở `#product-modal`, hiển thị gallery ảnh thu nhỏ, bảng thông số kỹ thuật, chọn màu sắc/dung lượng để cập nhật giá tương ứng. | **Vào**: `product.id`<br/>**Ra**: Modal chi tiết với dữ liệu động | **Đã hoàn thiện** | Đảm bảo nút "Thêm vào giỏ" trong modal lấy đúng biến thể đang chọn thay vì biến thể mặc định. |
| **6** | **Giỏ Hàng Reactive & LocalStorage** | `cart.js`, `style.css` | Quản lý mảng `Cart.items`, tính tổng tiền, lưu vào `localStorage.techstore_cart_v1`, kích hoạt listeners `Cart.notify()`. | **Vào**: Product, Variant, Quantity<br/>**Ra**: State giỏ hàng & badge header | **Đã hoàn thiện** | Khóa `cart_key` phải là tổ hợp duy nhất của `id` + `color` + `storage` để tránh ghi đè sai biến thể. |
| **7** | **Hệ Thống Mã Giảm Giá (Voucher)** | `cart.js`, `orderController.js`, `db.js` | Kiểm tra mã voucher (`TECH10`, `FREESHIP`), đối chiếu điều kiện đơn hàng tối thiểu, trừ tiền theo % hoặc giá trị cố định. | **Vào**: Mã code & Tổng tiền<br/>**Ra**: Số tiền được giảm | **Đã hoàn thiện** | Cần kiểm tra giới hạn giảm tối đa (`max_discount`) khi mã có dạng giảm theo phần trăm. |
| **8** | **Đặt Hàng Thanh Toán Khi Nhận (COD)** | `checkout.js`, `orderController.js`, `db.js` | Validate form khách hàng, gửi `POST /api/orders`, bắt đầu MySQL Transaction: kiểm tra tồn kho, trừ kho, lưu `orders` và `order_items`. | **Vào**: Thông tin nhận hàng, giỏ hàng<br/>**Ra**: Mã đơn hàng `#ORD-XXXX` | **Đã hoàn thiện** | Không được bỏ qua bước trừ số lượng tồn kho `stock_quantity` trong MySQL. |
| **9** | **Cổng Thanh Toán Trực Tuyến Mô Phỏng** | `payment-gateway.js`, `payment.css`, `paymentController.js` | Sinh mã QR VNPAY/MoMo, form thẻ ngân hàng, đếm ngược OTP 10 phút, gửi verify sang server để chuyển đơn thành "paid". | **Vào**: Đơn hàng, Mã OTP 6 số<br/>**Ra**: Xác nhận thanh toán thành công | **Mô phỏng** | Hiện tại mã OTP được tạo ngẫu nhiên và in vào log/thông báo màn hình để kiểm thử đồ án. |
| **10** | **Tra Cứu Đơn Hàng Đa Kênh** | `app.js`, `orderController.js`, `db.js` | Tìm kiếm theo Mã đơn, SĐT hoặc Email khách hàng. Tự động lấy "Đơn hàng của tôi" nếu tài khoản đã đăng nhập. | **Vào**: Mã đơn / SĐT / Email<br/>**Ra**: Danh sách thẻ chi tiết đơn hàng | **Đã hoàn thiện** | Truy vấn SQL sử dụng `LIKE` hoặc so khớp chính xác có đánh chỉ mục trên cột `customer_phone`. |
| **11** | **Đánh Giá Sao & Bình Luận Hỏi Đáp** | `app.js`, `reviewController.js`, `db.js` | Khách chấm 1-5 sao, viết nhận xét. Gửi câu hỏi Q&A và hỗ trợ phản hồi phân cấp từ admin. | **Vào**: Số sao, Nội dung đánh giá<br/>**Ra**: Danh sách review hiển thị trên modal | **Đã hoàn thiện** | Tính toán lại điểm trung bình `rating_avg` trong bảng `products` sau khi có review mới. |
| **12** | **Xác Thực Người Dùng (Auth)** | `login.html`, `auth.js`, `authController.js` | Đăng ký tài khoản mới, đăng nhập email/mật khẩu, lưu thông tin vào `localStorage.techstore_user`. | **Vào**: Email, Mật khẩu<br/>**Ra**: Thông tin phiên người dùng | **Đã hoàn thiện** | Mật khẩu hiện lưu dạng văn bản gốc cho đồ án, cần nâng cấp băm `bcrypt` khi lên production. |
| **13** | **Dashboard Quản Trị Viên (Admin)** | `admin.html`, `admin.css`, `admin.js`, `api.js` | Thống kê doanh thu, duyệt trạng thái đơn hàng (`pending` -> `confirmed` -> `shipping` -> `completed`), thêm/sửa sản phẩm. | **Vào**: Header `x-user-role: admin`<br/>**Ra**: Bảng điều khiển quản trị | **Đã hoàn thiện** | Kiểm tra quyền admin cả ở Client (`localStorage`) lẫn Server (`requireAdmin` middleware). |
| **14** | **Nút Cuộn Trang Với Vòng Tròn SVG** | `app.js`, `style.css` | Tính toán tỷ lệ cuộn trang `window.scrollY / scrollHeight`, cập nhật `strokeDashoffset` của vòng tròn SVG bao quanh nút. | **Vào**: Sự kiện scroll màn hình<br/>**Ra**: Vòng viền đỏ chạy quanh nút | **Đã hoàn thiện** | Kiểm tra tương thích thuộc tính SVG trên trình duyệt Safari di động. |
