# Đặc Tả Kỹ Thuật Module checkout.js (Checkout Workflow)

> **File nguồn**: [public/js/checkout.js](file:///c:/Users/kaziila/Downloads/DO_AN_CO_SO_NGANH/public/js/checkout.js)  
> **Dung lượng**: ~190 dòng  
> **Tài liệu tham chiếu**: [JAVASCRIPT_GUIDE.md](../JAVASCRIPT_GUIDE.md) | [DATA_FLOW.md](../DATA_FLOW.md) | [modules/cart.md](./cart.md) | [modules/payment-gateway.md](./payment-gateway.md)

---

## 1. Mục Đích & Trách Nhiệm Cốt Lõi

Module `checkout.js` đóng vai trò bộ điều hướng quy trình đặt hàng (Order & Checkout Workflow) của TechStore. Module được tổ chức dưới dạng Singleton `Checkout`, chịu trách nhiệm:
1. Quản lý việc hiển thị và đóng mở **Modal Đặt Hàng** (`#checkout-modal`).
2. Tự động điền thông tin khách hàng nếu người dùng đã đăng nhập trước đó (`localStorage.techstore_user`).
3. Kiểm tra tính hợp lệ (Form Validation) của các thông tin nhận hàng: Họ tên, Số điện thoại Việt Nam, Email và Địa chỉ chi tiết.
4. Tính toán phí vận chuyển dựa trên tổng giá trị đơn hàng hoặc mã voucher miễn phí vận chuyển.
5. Gửi yêu cầu tạo đơn hàng sang máy chủ thông qua API `POST /api/orders`.
6. Điều phối hành vi sau khi tạo đơn:
   - Nếu chọn **Thanh toán khi nhận hàng (COD)**: Xóa giỏ hàng và hiển thị popup Đặt hàng thành công.
   - Nếu chọn **Thanh toán trực tuyến (Online)**: Giữ thông tin đơn và chuyển giao điều khiển cho module `PaymentGateway`.

---

## 2. Các Thuộc Tính Trạng Thái (State Properties)

| Tên Thuộc Tính | Kiểu Dữ Liệu | Giá Trị Mặc Định | Ý Nghĩa & Vai Trò |
| :--- | :---: | :---: | :--- |
| `Checkout.modal` | `HTMLElement \| null` | `null` | Tham chiếu tới thẻ container của modal đặt hàng (`#checkout-modal`). |
| `Checkout.form` | `HTMLElement \| null` | `null` | Tham chiếu tới thẻ `<form id="checkout-form">`. |
| `Checkout.shippingFee` | `Number` | `30000` | Mức phí giao hàng mặc định (30.000đ). Sẽ bằng `0đ` nếu đơn hàng trên 5.000.000đ hoặc áp mã `FREESHIP`. |
| `Checkout.currentOrder`| `Object \| null` | `null` | Dữ liệu phản hồi của đơn hàng vừa tạo sau khi gọi API thành công. |

---

## 3. Chi Tiết Các Phương Thức Xử Lý

### 3.1. `Checkout.init()`
- **Mục đích**: Gắn các bộ lắng nghe sự kiện khi ứng dụng khởi chạy.
- **Xử lý**:
  - Gắn sự kiện click vào nút "Tiến hành đặt hàng" (`#checkout-btn`) trong drawer giỏ hàng để gọi `Checkout.open()`.
  - Gắn sự kiện click vào nút đóng modal (`#close-checkout-btn`) và lớp phủ mờ (`.modal-backdrop`).
  - Gắn sự kiện `submit` trên form `#checkout-form` gọi `Checkout.submitOrder(event)`.

### 3.2. `Checkout.open()`
- **Mục đích**: Chuẩn bị dữ liệu và mở modal đặt hàng.
- **Quy trình thực hiện**:
  1. Kiểm tra giỏ hàng: Gọi `Cart.getSummary()`. Nếu `totalItems === 0`, hiển thị Toast cảnh báo "Giỏ hàng đang trống, vui lòng chọn sản phẩm" và dừng thực thi.
  2. Đọc thông tin người dùng từ `localStorage.getItem('techstore_user')`. Nếu đã đăng nhập, tự động điền Họ tên, Số điện thoại và Email vào các ô input tương ứng.
  3. Tính toán phí vận chuyển:
     - Nếu `summary.subtotal >= 5000000` hoặc mã coupon là `'FREESHIP'`: `Checkout.shippingFee = 0`.
     - Ngược lại: `Checkout.shippingFee = 30000`.
  4. Cập nhật bảng tổng kết chi phí trong modal: Tạm tính, Phí vận chuyển, Giảm giá voucher và Tổng thanh toán cuối cùng (`summary.finalTotal + Checkout.shippingFee`).
  5. Thêm class `.show` vào `#checkout-modal` và khóa cuộn trang nền.

### 3.3. `Checkout.validateForm(data)`
- **Mục đích**: Kiểm tra dữ liệu đầu vào người dùng nhập trước khi gửi API.
- **Các quy tắc kiểm tra nghiêm ngặt**:
  1. **Họ và tên**: Không được để trống, độ dài tối thiểu từ 2 ký tự.
  2. **Số điện thoại**: Phải là đầu số nhà mạng Việt Nam hợp lệ (10 chữ số):
     ```javascript
     const phoneRegex = /^(03|05|07|08|09)\d{8}$/;
     ```
  3. **Địa chỉ giao hàng**: Bắt buộc nhập đầy đủ (Số nhà, tên đường, phường/xã, quận/huyện), tối thiểu 10 ký tự.
  4. **Email**: Không bắt buộc, nhưng nếu người dùng có nhập thì phải đúng định dạng email chuẩn (`/^[^\s@]+@[^\s@]+\.[^\s@]+$/`).
- **Giá trị trả về**: Trả về `true` nếu hợp lệ; nếu không hợp lệ thì hiển thị Toast cảnh báo lỗi tương ứng và trả về `false`.

### 3.4. `Checkout.submitOrder(event)`
- **Mục đích**: Xử lý gửi đơn hàng lên máy chủ.
- **Quy trình thực hiện**:
  1. `event.preventDefault()` ngăn form tải lại trang.
  2. Thu thập dữ liệu từ các trường trong form.
  3. Gọi `Checkout.validateForm()`. Nếu không hợp lệ, dừng quy trình.
  4. Thu thập danh sách sản phẩm từ `Cart.items` thành mảng payload:
     ```javascript
     const items = Cart.items.map(item => ({
       product_id: item.id,
       variant: item.variant,
       price: item.price,
       quantity: item.quantity
     }));
     ```
  5. Hiển thị trạng thái đang xử lý (vô hiệu hóa nút đặt hàng, hiện icon xoay loading).
  6. Gửi yêu cầu HTTP: `POST /api/orders` với payload đầy đủ.
  7. **Phân nhánh xử lý theo phương thức thanh toán**:
     - **Nhánh COD (`payment_method === 'cod'`)**:
       - Xóa sạch giỏ hàng: `Cart.clearCart()`.
       - Đóng modal đặt hàng.
       - Mở popup "Đặt Hàng Thành Công!" hiển thị mã đơn `#ORD-XXXX`, tổng tiền và lời cảm ơn.
     - **Nhánh Trực Tuyến (`payment_method === 'online'`)**:
       - Đóng modal đặt hàng.
       - Lưu thông tin đơn vào `Checkout.currentOrder`.
       - Kích hoạt cổng thanh toán: `PaymentGateway.open(Checkout.currentOrder)`.
