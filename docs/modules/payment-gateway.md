# Đặc Tả Kỹ Thuật Module payment-gateway.js (Cổng Thanh Toán Mô Phỏng)

> **File nguồn**: [public/js/payment-gateway.js](file:///c:/Users/kaziila/Downloads/DO_AN_CO_SO_NGANH/public/js/payment-gateway.js)  
> **Dung lượng**: ~350 dòng  
> **Tài liệu tham chiếu**: [JAVASCRIPT_GUIDE.md](../JAVASCRIPT_GUIDE.md) | [DATA_FLOW.md](../DATA_FLOW.md) | [modules/checkout.md](./checkout.md)

---

## 1. Mục Đích & Trách Nhiệm Cốt Lõi

Module `payment-gateway.js` là giải pháp mô phỏng cổng thanh toán trực tuyến (Simulated Payment Gateway) của TechStore. Module được thiết kế dưới dạng Singleton `PaymentGateway`, giải quyết yêu cầu trải nghiệm thanh toán thực tế của đồ án mà không đòi hỏi chi phí đăng ký giấy phép cổng thanh toán thương mại:
1. Hiển thị giao diện cổng thanh toán đa kênh chuyên nghiệp:
   - **VNPAY-QR**: Mã QR quét app ngân hàng hỗ trợ VietQR.
   - **Ví MoMo**: Mã QR thanh toán qua ứng dụng MoMo.
   - **Thẻ Quốc Tế (Visa / Mastercard / JCB)**: Form nhập thẻ với cơ chế mô phỏng xác thực 3D Secure.
2. Xử lý quy trình bảo mật hai lớp thông qua **Mã OTP (One-Time Password)** gửi tới số điện thoại khách hàng.
3. Điều khiển **Đồng hồ đếm ngược OTP 10:00 phút** theo chuẩn bảo mật ngân hàng.
4. Gửi yêu cầu xác thực sang máy chủ backend (`POST /api/payment/verify`) để chuyển trạng thái đơn hàng thành "Đã thanh toán" (`paid`).

---

## 2. Các Thuộc Tính Trạng Thái (State Properties)

| Tên Thuộc Tính | Kiểu Dữ Liệu | Giá Trị Mặc Định | Ý Nghĩa & Vai Trò |
| :--- | :---: | :---: | :--- |
| `PaymentGateway.modal` | `HTMLElement \| null` | `null` | Tham chiếu tới thẻ container của modal cổng thanh toán (`#payment-gateway-modal`). |
| `PaymentGateway.orderInfo` | `Object \| null` | `null` | Lưu trữ thông tin đơn hàng đang thực hiện thanh toán (`id`, `order_code`, `total_amount`, `customer_phone`). |
| `PaymentGateway.selectedMethod`| `String` | `'vnpay'` | Phương thức thanh toán trực tuyến hiện tại (`'vnpay'`, `'momo'`, hoặc `'card'`). |
| `PaymentGateway.otpCountdown` | `Number` | `600` | Số giây còn lại của mã OTP (mặc định 600 giây = 10 phút). |
| `PaymentGateway.otpTimer` | `Number \| null` | `null` | ID của bộ hẹn giờ `setInterval` điều khiển đếm ngược thời gian OTP. |
| `PaymentGateway.generatedOTP` | `String \| null` | `null` | Mã OTP 6 chữ số ngẫu nhiên được sinh ra để đối chiếu khi xác thực. |

---

## 3. Chi Tiết Các Phương Thức Xử Lý

### 3.1. `PaymentGateway.init()`
- **Mục đích**: Gắn bộ lắng nghe sự kiện chuyển tab và đóng modal.
- **Xử lý**:
  - Lắng nghe click trên các nút chọn tab phương thức: `.payment-tab-btn[data-method="..."]`.
  - Lắng nghe nút hủy giao dịch / đóng modal: Kiểm tra xác nhận từ người dùng trước khi hủy phiên thanh toán.

### 3.2. `PaymentGateway.open(orderInfo)`
- **Mục đích**: Khởi động phiên thanh toán cho một đơn hàng cụ thể.
- **Tham số**: `orderInfo` (chứa `id`, `order_code`, `total_amount`, `customer_phone`).
- **Quy trình thực hiện**:
  1. Gán `this.orderInfo = orderInfo`.
  2. Hiển thị thông tin tóm tắt trên tiêu đề modal: Mã đơn hàng `#${orderInfo.order_code}` và Số tiền cần thanh toán định dạng VNĐ.
  3. Mặc định kích hoạt tab đầu tiên: `PaymentGateway.switchMethod('vnpay')`.
  4. Mở modal và khóa cuộn trang nền.

### 3.3. `PaymentGateway.switchMethod(method)`
- **Mục đích**: Chuyển đổi qua lại giữa các hình thức thanh toán.
- **Tham số**: `method` (`'vnpay'`, `'momo'`, `'card'`).
- **Xử lý**:
  - Cập nhật class `.active` trên tab tương ứng.
  - Ẩn/hiện panel nội dung phù hợp:
    - Nếu chọn `vnpay` hoặc `momo`: Gọi `PaymentGateway.generateQRCode(method)`.
    - Nếu chọn `card`: Hiển thị form nhập thông tin thẻ quốc tế.

### 3.4. `PaymentGateway.generateQRCode(method)`
- **Mục đích**: Tạo mã QR thanh toán động cho đơn hàng.
- **Xử lý**:
  - Chuẩn bị nội dung chuyển khoản theo cú pháp: `TECHSTORE ${this.orderInfo.order_code}`.
  - Sử dụng API sinh mã QR (hoặc ảnh QR tĩnh mẫu phối hợp logo nhận diện VNPAY/MoMo) hiển thị tại khung trung tâm.
  - Hiển thị hướng dẫn: "Mở ứng dụng Ngân hàng / MoMo -> Chọn Quét QR -> Kiểm tra số tiền và xác nhận chuyển khoản".
  - Cung cấp nút bấm: "Tôi đã hoàn tất chuyển khoản".

### 3.5. `PaymentGateway.requestOTP()`
- **Mục đích**: Bắt đầu bước xác thực mã OTP bảo mật.
- **Logic thực hiện**:
  1. Sinh mã OTP 6 số ngẫu nhiên:
     ```javascript
     this.generatedOTP = Math.floor(100000 + Math.random() * 900000).toString();
     ```
  2. Hiển thị thông báo Toast nổi trên màn hình (và in ra console server) để người thử nghiệm quan sát:
     `"Mã OTP xác thực của bạn là: [123456]. Có hiệu lực trong 10 phút."`
  3. Chuyển giao diện modal sang **Màn hình Nhập Mã OTP**.
  4. Đặt lại biến `this.otpCountdown = 600` và gọi `this.startOTPTimer()`.

### 3.6. `PaymentGateway.startOTPTimer()`
- **Mục đích**: Điều khiển đồng hồ đếm ngược 10 phút.
- **Logic thực hiện**:
  - Xóa timer cũ nếu đang chạy: `clearInterval(this.otpTimer)`.
  - Khởi động `setInterval` mỗi 1.000ms:
    - `this.otpCountdown--`
    - Tính phút và giây:
      ```javascript
      const minutes = String(Math.floor(this.otpCountdown / 60)).padStart(2, '0');
      const seconds = String(this.otpCountdown % 60).padStart(2, '0');
      document.getElementById('otp-timer-display').textContent = `${minutes}:${seconds}`;
      ```
    - Nếu `this.otpCountdown <= 0`:
      - `clearInterval(this.otpTimer)`
      - Hiển thị thông báo "Mã OTP đã hết hiệu lực".
      - Vô hiệu hóa nút xác thực, kích hoạt nút "Gửi lại mã OTP".

### 3.7. `PaymentGateway.verifyPayment(enteredOTP)`
- **Mục đích**: Gửi yêu cầu xác thực OTP sang máy chủ.
- **Quy trình thực hiện**:
  1. Kiểm tra mã nhập: Nếu `enteredOTP.length !== 6`, cảnh báo nhập đủ 6 chữ số.
  2. Gửi request:
     ```javascript
     const res = await fetch('/api/payment/verify', {
       method: 'POST',
       headers: { 'Content-Type': 'application/json' },
       body: JSON.stringify({
         order_id: this.orderInfo.id,
         otp: enteredOTP
       })
     });
     ```
  3. **Nếu thành công**:
     - `clearInterval(this.otpTimer)`.
     - Xóa sạch giỏ hàng: `Cart.clearCart()`.
     - Chuyển giao diện modal sang **Màn hình Thanh Toán Thành Công** (Icon tích xanh lớn, thông báo trừ tiền thành công, mã giao dịch ngân hàng và nút "Về trang chủ").
  4. **Nếu thất bại**:
     - Hiển thị Toast lỗi "Mã OTP không chính xác hoặc đã hết hạn".
     - Xóa trống ô nhập để khách hàng nhập lại.

### 3.8. `PaymentGateway.close()`
- **Mục đích**: Dọn dẹp tài nguyên và đóng modal.
- **Xử lý**:
  - Hủy bộ đếm ngược: `clearInterval(this.otpTimer)`.
  - Reset các biến trạng thái về `null`.
  - Bỏ class `.show` trên modal và mở lại cuộn trang nền.
