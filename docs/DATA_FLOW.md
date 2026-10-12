# Luồng Hoạt Động & Dữ Liệu Dự Án TechStore

> **Dự án**: TechStore - Website Bán Lẻ Công Nghệ  
> **Tài liệu tham chiếu**: [ARCHITECTURE.md](./ARCHITECTURE.md) | [JAVASCRIPT_GUIDE.md](./JAVASCRIPT_GUIDE.md) | [API_AND_STORAGE.md](./API_AND_STORAGE.md)

---

## 1. Luồng Duyệt & Lọc Sản Phẩm (Browsing & Multi-Filter Flow)

Khi người dùng duyệt các trang ngành hàng (ví dụ: `laptop.html`), hệ thống xử lý luồng dữ liệu 2 tầng: tầng nạp dữ liệu từ máy chủ và tầng lọc tức thời tại trình duyệt:

```mermaid
sequenceDiagram
    autonumber
    actor User as Khách hàng
    participant Page as laptop.html
    participant App as App (app.js)
    participant API as /api/products
    participant DB as MySQL DB

    User->>Page: Mở trang Laptop
    Page->>App: DOMContentLoaded -> App.init()
    App->>API: GET /api/products?category=laptop
    API->>DB: Truy vấn sản phẩm theo category_id
    DB-->>API: Trả về 20+ bản ghi sản phẩm
    API-->>App: Trả về JSON mảng sản phẩm
    App->>App: Lưu mảng gốc vào App.products
    App->>Page: Render danh sách vào #product-grid

    User->>Page: Tích chọn checkbox filter (Hãng: Asus, CPU: Core i7, RAM: 16GB)
    Page->>App: Kích hoạt sự kiện 'change' (App.bindFilters)
    App->>App: Thu thập bộ lọc được chọn thành đối tượng filterState
    App->>App: Duyệt lọc trên App.products (Kiểm tra specifications JSON)
    App->>Page: Cập nhật lại HTML của #product-grid (Không cần gọi lại API)
```

---

## 2. Luồng Giỏ Hàng & Mã Giảm Giá (Cart & Coupon Flow)

Giỏ hàng được quản lý bởi `Cart` với cơ chế Reactive State, tự động đồng bộ hóa vào `localStorage`:

```mermaid
sequenceDiagram
    autonumber
    actor User as Khách hàng
    participant UI as Giao diện Thẻ Sản Phẩm
    participant Cart as Cart (cart.js)
    participant Storage as LocalStorage (techstore_cart_v1)
    participant Header as Header Badge & Drawer

    User->>UI: Nhấn "Thêm vào giỏ" (hoặc chọn Màu/Dung lượng trong Modal)
    UI->>Cart: Cart.addItem(product, variant, 1)
    Cart->>Cart: Sinh cart_key = `${product.id}_${color}_${storage}`
    alt Sản phẩm đã có trong giỏ
        Cart->>Cart: Tăng quantity += 1
    else Chưa có trong giỏ
        Cart->>Cart: Thêm phần tử mới vào Cart.items
    end
    Cart->>Storage: Lưu JSON chuỗi mới vào 'techstore_cart_v1'
    Cart->>Header: Kích hoạt listeners (Cart.notify)
    Header->>Header: Cập nhật số lượng trên #cart-count
    Header->>Header: Vẽ lại danh sách món hàng trong #cart-modal

    User->>Header: Nhập mã voucher "TECH10" và nhấn "Áp dụng"
    Header->>Cart: Cart.applyCoupon("TECH10")
    Cart->>Cart: Kiểm tra danh sách hợp lệ & tính tiền giảm (10% tối đa 500k)
    Cart->>Storage: Lưu mã vào 'techstore_applied_coupon'
    Cart->>Header: Kích hoạt Cart.notify() -> Cập nhật tổng thanh toán #cart-total
```

---

## 3. Luồng Đặt Hàng & Thanh Toán (Order & Payment Workflow)

Đây là quy trình nghiệp vụ quan trọng nhất của hệ thống, hỗ trợ 2 nhánh thanh toán:

```mermaid
graph TD
    Start["Khách nhấn 'Tiến hành đặt hàng'"] --> OpenModal["Mở Checkout Modal"]
    OpenModal --> FillForm["Điền: Tên, SĐT, Email, Địa chỉ giao hàng"]
    FillForm --> ChooseMethod{"Lựa chọn phương thức thanh toán?"}

    ChooseMethod -- "Thanh toán khi nhận hàng (COD)" --> SubmitCOD["Gửi POST /api/orders\n(payment_method: 'cod')"]
    SubmitCOD --> BackendTX["Backend: Bắt đầu MySQL Transaction\n- Khóa & kiểm tra tồn kho\n- Trừ stock_quantity, tăng sold_count\n- Chèn orders & order_items"]
    BackendTX -- Thành công --> ClearCart1["Xóa LocalStorage Giỏ hàng"]
    ClearCart1 --> ShowSuccess1["Hiển thị màn hình Đặt hàng Thành công\n(Kèm mã #ORD-XXXXX)"]

    ChooseMethod -- "Thanh toán Trực tuyến (Online)" --> SubmitOnline["Gửi POST /api/orders\n(payment_status: 'pending')"]
    SubmitOnline --> OpenGateway["Khởi tạo PaymentGateway.open(orderInfo)"]
    OpenGateway --> SelectOnlineTab{"Chọn cổng thanh toán"}

    SelectOnlineTab -- "VNPAY-QR / Ví MoMo" --> ShowQR["Tạo mã QR thanh toán động\n+ Hướng dẫn quét app ngân hàng"]
    SelectOnlineTab -- "Thẻ Quốc Tế (Visa/Master)" --> CardForm["Nhập Số thẻ, Ngày hết hạn, CVV"]

    ShowQR --> ClickPaid["Khách bấm 'Tôi đã chuyển khoản'"]
    CardForm --> ClickPay["Khách bấm 'Thanh toán ngay'"]

    ClickPaid & ClickPay --> SendOTP["Server sinh mã OTP ngẫu nhiên (6 số)\nvà gửi về số điện thoại khách hàng"]
    SendOTP --> ShowOTPModal["Hiển thị Hộp thoại Xác thực OTP\n(Đồng hồ đếm ngược 10:00 phút)"]

    ShowOTPModal --> EnterOTP["Khách nhập mã OTP 6 số"]
    EnterOTP --> VerifyAPI["Gửi POST /api/payment/verify"]
    VerifyAPI --> CheckOTP{"Mã OTP có khớp\nvà chưa hết hạn?"}

    CheckOTP -- Không khớp / Hết hạn --> ShowError["Báo lỗi OTP không chính xác\nCho phép gửi lại OTP"]
    CheckOTP -- Khớp --> ConfirmOrder["Cập nhật trạng thái đơn: 'confirmed'\nTrạng thái thanh toán: 'paid'"]
    ConfirmOrder --> ClearCart2["Xóa LocalStorage Giỏ hàng"]
    ClearCart2 --> ShowSuccess2["Hiển thị màn hình Thanh toán Thành công!"]
```

---

## 4. Luồng Tra Cứu Đơn Hàng Đa Kênh (Order Tracking Flow)

TechStore cho phép khách hàng tra cứu tiến độ đơn hàng linh hoạt theo nhiều hình thức:

```mermaid
sequenceDiagram
    autonumber
    actor User as Khách hàng
    participant Modal as #order-tracking-modal
    participant App as App.bindOrderTracking()
    participant API as /api/orders/track
    participant DB as MySQL DB

    User->>Modal: Bấm nút "Tra cứu đơn hàng" trên Header
    Modal->>Modal: Mở popup tra cứu
    User->>Modal: Nhập thông tin: Mã đơn (#ORD-2601) hoặc Số ĐT (0987654321)
    Modal->>App: Gửi yêu cầu tìm kiếm
    App->>API: GET /api/orders/track?query=0987654321
    API->>DB: Truy vấn bảng orders WHERE id = ? OR customer_phone = ? OR customer_email = ?
    DB-->>API: Trả về danh sách đơn hàng kèm chi tiết món hàng
    API-->>App: Trả về JSON mảng các đơn hàng
    App->>Modal: Render danh sách thẻ đơn hàng (#tracking-results):
    Note over Modal: Hiển thị: Trạng thái (Chờ xác nhận / Đang giao),<br/>Địa chỉ giao hàng, Tổng tiền, Danh sách sản phẩm
```

---

## 5. Luồng Đánh Giá & Hỏi Đáp Sản Phẩm (Reviews & Q&A Flow)

```mermaid
sequenceDiagram
    autonumber
    actor User as Khách hàng
    participant Modal as #product-modal (Tab Reviews)
    participant App as App.js
    participant API as /api/reviews
    participant DB as MySQL DB

    User->>Modal: Mở xem chi tiết sản phẩm ID = 12
    App->>API: GET /api/reviews/product/12
    API->>DB: SELECT * FROM reviews WHERE product_id = 12
    DB-->>API: Trả về danh sách đánh giá
    API-->>App: JSON mảng đánh giá
    App->>Modal: Hiển thị danh sách sao và nhận xét

    User->>Modal: Chọn 5 sao, điền họ tên, nhận xét và bấm "Gửi đánh giá"
    Modal->>App: Thu thập dữ liệu form
    App->>API: POST /api/reviews (product_id, rating, comment, author_name)
    API->>DB: INSERT INTO reviews (...) VALUES (...)
    DB-->>API: Ghi nhận thành công
    API-->>App: { success: true, message: "Đánh giá của bạn đã được ghi nhận" }
    App->>Modal: Vẽ thêm đánh giá mới vào đầu danh sách
    App->>App: Hiển thị thông báo Toast thành công
```

---

## 6. Luồng Quản Trị Viên (Admin Operations Flow)

Bảng điều khiển quản trị viên (`admin.html`) tương tác với các API có kiểm soát quyền truy cập:

```mermaid
sequenceDiagram
    autonumber
    actor Admin as Quản trị viên
    participant Page as admin.html
    participant AdminJS as admin.js
    participant API as /api/orders & /api/products
    participant DB as MySQL DB

    Admin->>Page: Truy cập admin.html
    Page->>AdminJS: Admin.init()
    AdminJS->>AdminJS: Kiểm tra localStorage.techstore_user
    Note over AdminJS: Nếu chưa đăng nhập hoặc role !== 'admin'<br/>-> Chuyển hướng về login.html

    AdminJS->>API: GET /api/stats (Header: x-user-role: admin)
    AdminJS->>API: GET /api/orders (Header: x-user-role: admin)
    API->>DB: Thống kê doanh thu, đơn hàng, sản phẩm
    DB-->>API: Trả về dữ liệu
    API-->>AdminJS: Trả về JSON
    AdminJS->>Page: Render bảng KPI và Bảng danh sách đơn hàng

    Admin->>Page: Chọn đơn hàng #ORD-101 -> Đổi trạng thái sang "shipping" (Đang giao)
    Page->>AdminJS: Admin.updateOrderStatus(101, 'shipping')
    AdminJS->>API: PUT /api/orders/101/status (body: { status: 'shipping' }, header: x-user-role: admin)
    API->>DB: UPDATE orders SET status = 'shipping' WHERE id = 101
    DB-->>API: Cập nhật thành công
    API-->>AdminJS: { success: true }
    AdminJS->>Page: Cập nhật màu Badge trên bảng đơn hàng sang màu Xanh dương
```
