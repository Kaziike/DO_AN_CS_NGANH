# Đặc Tả Kỹ Thuật Module admin.js (Admin Dashboard)

> **File nguồn**: [public/js/admin.js](file:///c:/Users/kaziila/Downloads/DO_AN_CO_SO_NGANH/public/js/admin.js)  
> **Dung lượng**: ~480 dòng  
> **Tài liệu tham chiếu**: [JAVASCRIPT_GUIDE.md](../JAVASCRIPT_GUIDE.md) | [HTML_GUIDE.md](../HTML_GUIDE.md) | [API_AND_STORAGE.md](../API_AND_STORAGE.md)

---

## 1. Mục Đích & Trách Nhiệm Cốt Lõi

Module `admin.js` là bộ điều khiển giao diện trang quản trị viên (`public/admin.html`). Module được tổ chức dưới dạng Singleton `Admin`, chịu trách nhiệm:
1. Xác thực quyền hạn quản trị viên phía client (`role === 'admin'`) và tự động chặn truy cập trái phép.
2. Thiết lập tiêu đề bảo mật `x-user-role: admin` cho tất cả các yêu cầu HTTP gọi tới API quản trị backend.
3. Tải và hiển thị các số liệu thống kê tổng quan (Dashboard KPI): Doanh thu bán hàng, Tổng số đơn, Số sản phẩm, Đơn hàng đang chờ xử lý.
4. Quản lý danh sách đơn hàng toàn diện: Lọc theo trạng thái, xem chi tiết từng món hàng và cập nhật quy trình giao hàng (`pending` -> `confirmed` -> `shipping` -> `completed` -> `cancelled`).
5. Quản lý danh mục sản phẩm (CRUD): Thêm sản phẩm mới, cập nhật thông số kỹ thuật/giá bán/tồn kho và xóa sản phẩm.
6. Quản lý các sự kiện giảm giá sốc Flash Sale.

---

## 2. Các Thuộc Tính Trạng Thái (State Properties)

| Tên Thuộc Tính | Kiểu Dữ Liệu | Giá Trị Mặc Định | Ý Nghĩa & Vai Trò |
| :--- | :---: | :---: | :--- |
| `Admin.currentTab` | `String` | `'dashboard'` | Tab quản trị hiện tại (`'dashboard'`, `'orders'`, `'products'`, `'flashsales'`). |
| `Admin.orders` | `Array` | `[]` | Mảng chứa toàn bộ dữ liệu đơn hàng tải về từ máy chủ. |
| `Admin.products` | `Array` | `[]` | Mảng chứa toàn bộ danh sách sản phẩm phục vụ quản lý kho. |
| `Admin.stats` | `Object \| null` | `null` | Dữ liệu thống kê doanh thu và số lượng từ API `/api/stats`. |
| `Admin.orderStatusFilter`| `String` | `'all'` | Tiêu chí lọc trạng thái đơn hàng trên bảng (`'all'`, `'pending'`, `'confirmed'`,...). |

---

## 3. Chi Tiết Các Phương Thức Xử Lý

### 3.1. `Admin.init()`
- **Mục đích**: Khởi động trang quản trị và kiểm tra phân quyền.
- **Quy trình thực hiện**:
  1. Kiểm tra quyền Admin:
     ```javascript
     const user = JSON.parse(localStorage.getItem('techstore_user') || '{}');
     if (!user || user.role !== 'admin') {
       alert('Bạn không có quyền truy cập trang quản trị!');
       window.location.href = 'login.html';
       return;
     }
     ```
  2. Hiển thị tên quản trị viên trên thanh Header Admin.
  3. Gắn sự kiện click chuyển tab trên thanh Sidebar (`.admin-nav-item`).
  4. Gắn sự kiện đăng xuất cho `#admin-logout-btn` (xóa session và chuyển về trang chủ).
  5. Gọi `Admin.loadDashboardStats()` để nạp số liệu KPI ban đầu.

### 3.2. `Admin.loadDashboardStats()`
- **Mục đích**: Tải số liệu thống kê doanh số từ backend.
- **Xử lý**:
  - Gửi request:
    ```javascript
    const res = await fetch('/api/stats', {
      headers: { 'x-user-role': 'admin' }
    });
    ```
  - Cập nhật các thẻ KPI trên màn hình:
    - **Tổng doanh thu**: Định dạng tiền tệ VNĐ (ví dụ: `1.425.800.000đ`).
    - **Tổng số đơn hàng**: Số lượng bản ghi trong bảng `orders`.
    - **Tổng số sản phẩm**: Số lượng bản ghi trong bảng `products`.
    - **Đơn chờ duyệt**: Số lượng đơn có trạng thái `status === 'pending'`.

### 3.3. `Admin.loadOrders()` & `Admin.renderOrdersTable()`
- **Mục đích**: Quản lý danh sách đơn hàng của khách hàng.
- **Quy trình thực hiện**:
  1. Gửi `GET /api/orders` với header `x-user-role: admin`.
  2. Gán kết quả vào `Admin.orders`.
  3. Lọc danh sách theo `Admin.orderStatusFilter`.
  4. Render bảng HTML (`<table>`):
     - Mã đơn hàng (`#ORD-XXXX`).
     - Tên khách hàng & Số điện thoại.
     - Ngày giờ đặt hàng.
     - Tổng tiền đơn hàng.
     - Phương thức thanh toán (COD / VNPAY / MoMo / Visa).
     - **Huy hiệu trạng thái (Status Badge)**:
       - `pending` (Chờ xử lý): Màu Vàng cam.
       - `confirmed` (Đã xác nhận): Màu Xanh dương nhạt.
       - `shipping` (Đang giao hàng): Màu Xanh dương đậm.
       - `completed` (Hoàn thành): Màu Xanh lá.
       - `cancelled` (Đã hủy): Màu Đỏ.
     - Nút hành động: "Xem chi tiết" và "Cập nhật trạng thái".

### 3.4. `Admin.updateOrderStatus(orderId, newStatus)`
- **Mục đích**: Cập nhật trạng thái xử lý đơn hàng.
- **Xử lý**:
  - Gửi request:
    ```javascript
    const res = await fetch(`/api/orders/${orderId}/status`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'x-user-role': 'admin'
      },
      body: JSON.stringify({ status: newStatus })
    });
    ```
  - Nếu thành công: Cập nhật lại trạng thái trong mảng `Admin.orders`, vẽ lại bảng và hiển thị Toast thông báo.

### 3.5. `Admin.loadProducts()` & `Admin.renderProductsTable()`
- **Mục đích**: Hiển thị danh sách sản phẩm phục vụ quản lý kho hàng.
- **Xử lý**:
  - Gửi `GET /api/products`.
  - Render bảng sản phẩm: Ảnh thu nhỏ, Tên sản phẩm, Danh mục, Hãng, Giá bán, Tồn kho (`stock_quantity`), Số lượng đã bán (`sold_count`).
  - Nút "Sửa": Mở modal điền sẵn dữ liệu cũ để cập nhật.
  - Nút "Xóa": Hiển thị hộp thoại xác nhận `confirm()` trước khi gửi `DELETE /api/products/:id`.

### 3.6. `Admin.saveProduct(event)`
- **Mục đích**: Lưu sản phẩm khi thêm mới hoặc chỉnh sửa.
- **Xử lý**:
  - Lấy dữ liệu từ form `#product-form-modal`.
  - Nếu là Thêm mới: Gửi `POST /api/products` (Header `x-user-role: admin`).
  - Nếu là Chỉnh sửa: Gửi `PUT /api/products/:id` (Header `x-user-role: admin`).
  - Đóng modal, tải lại danh sách sản phẩm và thông báo thành công.

### 3.7. `Admin.loadFlashSales()` & `Admin.manageFlashSale()`
- **Mục đích**: Quản lý sự kiện Flash Sale giảm giá có thời hạn.
- **Xử lý**:
  - Gọi `GET /api/flash-sales`.
  - Hiển thị danh sách sản phẩm đang nằm trong Flash Sale, giá giảm sốc và thời gian kết thúc.
  - Cho phép quản trị viên thêm sản phẩm vào sự kiện (`POST /api/flash-sales`) hoặc gỡ bỏ sản phẩm khỏi sự kiện (`DELETE /api/flash-sales/:id`).
