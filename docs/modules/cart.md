# Đặc Tả Kỹ Thuật Module cart.js (Cart Service)

> **File nguồn**: [public/js/cart.js](file:///c:/Users/kaziila/Downloads/DO_AN_CO_SO_NGANH/public/js/cart.js)  
> **Dung lượng**: ~220 dòng  
> **Tài liệu tham chiếu**: [JAVASCRIPT_GUIDE.md](../JAVASCRIPT_GUIDE.md) | [DATA_FLOW.md](../DATA_FLOW.md) | [API_AND_STORAGE.md](../API_AND_STORAGE.md)

---

## 1. Mục Đích & Trách Nhiệm Cốt Lõi

Module `cart.js` là dịch vụ quản lý trạng thái giỏ hàng (Reactive State Service) của TechStore. Module được tổ chức dưới dạng Singleton `Cart`, chịu trách nhiệm:
1. Quản lý danh sách các mặt hàng người dùng đã chọn mua kèm theo các biến thể (Màu sắc, Dung lượng bộ nhớ).
2. Tự động đồng bộ hóa trạng thái giỏ hàng vào trình duyệt thông qua `localStorage` (`techstore_cart_v1`).
3. Quản lý việc áp dụng và tính toán tiền giảm giá từ mã voucher khuyến mãi (`techstore_applied_coupon`).
4. Triển khai mô hình **Observer/Pub-Sub** thông qua phương thức `onChange()` giúp các thành phần giao diện (Badge trên header, Drawer giỏ hàng, Modal thanh toán) tự động cập nhật ngay khi trạng thái thay đổi mà không cần tải lại trang.

---

## 2. Các Thuộc Tính Trạng Thái (State Properties)

| Tên Thuộc Tính | Kiểu Dữ Liệu | Giá Trị Mặc Định | Ý Nghĩa & Vai Trò |
| :--- | :---: | :---: | :--- |
| `Cart.items` | `Array` | `[]` | Mảng chứa danh sách các mặt hàng hiện có trong giỏ hàng. |
| `Cart.coupon` | `Object \| null` | `null` | Đối tượng lưu thông tin mã giảm giá đang kích hoạt hoặc `null` nếu chưa áp dụng. |
| `Cart.listeners` | `Array` | `[]` | Mảng lưu trữ danh sách các hàm callback lắng nghe sự thay đổi của giỏ hàng. |
| `Cart.STORAGE_KEY` | `String` | `'techstore_cart_v1'` | Tên khóa lưu trữ danh sách mặt hàng trong `localStorage`. |
| `Cart.COUPON_KEY` | `String` | `'techstore_applied_coupon'` | Tên khóa lưu trữ mã voucher trong `localStorage`. |

---

## 3. Cấu Trúc Phần Tử Trong Mảng `Cart.items`

Mỗi mặt hàng trong giỏ hàng là một đối tượng có cấu trúc chuẩn như sau:

```javascript
{
  cart_key: "1_Titan Tu Nhien_256GB", // Khóa định danh duy nhất của mặt hàng kèm biến thể
  id: 1,                              // ID sản phẩm trong bảng products
  name: "iPhone 15 Pro Max",          // Tên sản phẩm
  slug: "iphone-15-pro-max",          // Đường dẫn định danh sản phẩm
  price: 29490000,                    // Giá bán hiện tại (VNĐ)
  original_price: 34990000,           // Giá gốc trước khi giảm (VNĐ)
  image: "https://cdn.viettelstore.vn/...", // Link ảnh đại diện
  variant: "Titan Tự Nhiên - 256GB",  // Chuỗi mô tả biến thể đã chọn
  color: "Titan Tự Nhiên",            // Màu sắc đã chọn
  storage: "256GB",                   // Dung lượng bộ nhớ đã chọn
  quantity: 2,                        // Số lượng khách chọn mua
  max_stock: 45                       // Số lượng tồn kho tối đa có thể mua
}
```

---

## 4. Chi Tiết Các Phương Thức & Hàm Xử Lý

### 4.1. `Cart.init()`
- **Mục đích**: Khởi động service giỏ hàng khi trang web được tải.
- **Xử lý**:
  1. Đọc dữ liệu từ `localStorage` thông qua `Cart.loadFromStorage()`.
  2. Kích hoạt `Cart.notify()` lần đầu tiên để cập nhật UI ngay lập tức.

### 4.2. `Cart.onChange(callback)`
- **Mục đích**: Cho phép các thành phần giao diện đăng ký nhận thông báo mỗi khi giỏ hàng thay đổi.
- **Tham số**: `callback` (hàm nhận vào đối tượng tóm tắt `summary`).
- **Ví dụ sử dụng trong `app.js`**:
  ```javascript
  Cart.onChange((summary) => {
    document.getElementById('cart-count').textContent = summary.totalItems;
    document.getElementById('cart-total').textContent = App.formatCurrency(summary.finalTotal);
  });
  ```

### 4.3. `Cart.generateCartKey(productId, variant)`
- **Mục đích**: Sinh khóa duy nhất cho từng món hàng để phân biệt các biến thể khác nhau của cùng một sản phẩm.
- **Quy tắc**: `${productId}_${variant ? variant.trim().replace(/\s+/g, '_') : 'default'}`.

### 4.4. `Cart.addItem(product, variant = '', quantity = 1)`
- **Mục đích**: Thêm một món hàng vào giỏ.
- **Tham số**:
  - `product`: Đối tượng sản phẩm lấy từ API hoặc danh sách `App.products`.
  - `variant`: Chuỗi mô tả biến thể đã chọn (Màu sắc / Dung lượng).
  - `quantity`: Số lượng muốn thêm (mặc định là `1`).
- **Logic xử lý**:
  1. Sinh `cart_key` tương ứng.
  2. Tìm kiếm món hàng trong `Cart.items` bằng `cart_key`.
  3. Nếu món hàng đã tồn tại:
     - Kiểm tra tồn kho: `newQty = existingItem.quantity + quantity`.
     - Nếu `newQty > existingItem.max_stock`, giới hạn bằng `max_stock` và hiển thị cảnh báo.
     - Cập nhật: `existingItem.quantity = newQty`.
  4. Nếu là món hàng mới:
     - Đẩy đối tượng mới vào mảng `Cart.items`.
  5. Gọi `Cart.notify()`.

### 4.5. `Cart.updateQuantity(cartKey, quantity)`
- **Mục đích**: Tăng, giảm hoặc sửa trực tiếp số lượng của một món hàng trong giỏ.
- **Logic xử lý**:
  - Nếu `quantity <= 0`, gọi `Cart.removeItem(cartKey)`.
  - Nếu `quantity > item.max_stock`, gán bằng `item.max_stock` và thông báo vượt quá tồn kho.
  - Ngược lại, gán `item.quantity = quantity` và gọi `Cart.notify()`.

### 4.6. `Cart.removeItem(cartKey)`
- **Mục đích**: Xóa bỏ hoàn toàn một món hàng khỏi giỏ.
- **Logic xử lý**: Lọc mảng: `Cart.items = Cart.items.filter(item => item.cart_key !== cartKey)`. Sau đó gọi `Cart.notify()`.

### 4.7. `Cart.clearCart()`
- **Mục đích**: Xóa sạch giỏ hàng (thường được gọi sau khi đặt hàng thành công).
- **Logic xử lý**:
  - `Cart.items = []`
  - `Cart.coupon = null`
  - Xóa dữ liệu trong `localStorage` và gọi `Cart.notify()`.

### 4.8. `Cart.applyCoupon(code)`
- **Mục đích**: Kiểm tra và áp dụng mã voucher giảm giá.
- **Tham số**: `code` (chuỗi mã voucher, ví dụ: `'TECH10'`).
- **Logic xử lý**:
  1. Chuyển chuỗi thành chữ hoa: `code = code.trim().toUpperCase()`.
  2. Gửi yêu cầu xác thực sang máy chủ: `POST /api/coupons/validate` (hoặc đối chiếu với danh mục mã hợp lệ cục bộ khi ở chế độ offline).
  3. Kiểm tra điều kiện đơn hàng tối thiểu (`min_order_value`).
  4. Nếu thỏa mãn: Lưu đối tượng voucher vào `Cart.coupon`, lưu vào `localStorage` và gọi `Cart.notify()`.
  5. Nếu không thỏa mãn: Trả về lỗi chi tiết.

### 4.9. `Cart.getSummary()`
- **Mục đích**: Tính toán và trả về toàn bộ các số liệu tổng hợp của giỏ hàng.
- **Giá trị trả về (`Object`)**:
  - `totalItems`: Tổng số lượng sản phẩm (cộng dồn `quantity`).
  - `subtotal`: Tổng tiền tạm tính trước giảm giá (tính theo giá bán khuyến mãi).
  - `originalTotal`: Tổng tiền tính theo giá gốc (để tính số tiền tiết kiệm được).
  - `discountAmount`: Số tiền được giảm từ voucher khuyến mãi.
  - `savingsAmount`: Tổng tiền tiết kiệm được so với giá gốc.
  - `finalTotal`: Số tiền thanh toán cuối cùng sau khi đã trừ giảm giá (`Math.max(0, subtotal - discountAmount)`).
