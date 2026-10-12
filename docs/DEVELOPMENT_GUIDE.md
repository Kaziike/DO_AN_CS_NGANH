# Hướng Dẫn Phát Triển & Mở Rộng Dự Án TechStore

> **Dự án**: TechStore - Website Bán Lẻ Công Nghệ  
> **Tài liệu tham chiếu**: [ARCHITECTURE.md](./ARCHITECTURE.md) | [HTML_GUIDE.md](./HTML_GUIDE.md) | [CSS_GUIDE.md](./CSS_GUIDE.md) | [JAVASCRIPT_GUIDE.md](./JAVASCRIPT_GUIDE.md)

---

## 1. Quy Trình Thêm Một Trang Ngành Hàng Mới

Giả sử bạn cần bổ sung ngành hàng **Máy Ảnh & Thiết Bị Quay Phim (`camera.html`)** vào TechStore. Hãy làm theo 4 bước chuẩn hóa sau:

### Bước 1: Bổ sung danh mục vào Cơ sở dữ liệu
Chèn danh mục mới vào bảng `categories`:
```sql
INSERT INTO categories (name, slug, description) 
VALUES ('Máy Ảnh & Quay Phim', 'camera', 'Máy ảnh cơ, máy ảnh không gương lật và ống kính chuyên nghiệp');
```

### Bước 2: Tạo file HTML từ khuôn mẫu (Template)
Sao chép cấu trúc từ một trang hiện có (ví dụ: `public/laptop.html`) thành `public/camera.html`:
1. Mở `public/camera.html` và chỉnh sửa thẻ `<body>`:
   ```html
   <body data-category="camera">
   ```
2. Cập nhật thẻ `<title>`: `Máy Ảnh Chính Hãng - Giá Rẻ | TechStore`.
3. Cập nhật đường dẫn Breadcrumb trên trang: `Trang chủ / Máy Ảnh & Quay Phim`.

### Bước 3: Cập nhật Menu Điều Hướng Chung
Mở tất cả các file HTML hiện có (`index.html`, `smartphone.html`, `laptop.html`,...) và bổ sung liên kết vào thẻ `<nav class="main-nav">`:
```html
<a href="camera.html" class="nav-item">
  <i class="fa-solid fa-camera"></i> Máy Ảnh
</a>
```
*(Trên file `camera.html`, thêm class `.active` cho thẻ liên kết này)*.

### Bước 4: Tùy biến bộ lọc Accordion trong `.filter-sidebar`
Thay thế các tiêu chí phần cứng cũ (CPU, RAM) bằng các tiêu chí đặc trưng của máy ảnh:
```html
<div class="accordion-item active">
  <div class="accordion-header">
    <span>Loại Máy Ảnh</span>
    <i class="fa-solid fa-chevron-down"></i>
  </div>
  <div class="accordion-content">
    <label class="filter-checkbox">
      <input type="checkbox" name="camera_type" value="mirrorless"> Mirrorless
    </label>
    <label class="filter-checkbox">
      <input type="checkbox" name="camera_type" value="dslr"> DSLR
    </label>
  </div>
</div>
```

---

## 2. Hướng Dẫn Thêm Tiêu Chí Lọc Thuộc Tính Mới

Ví dụ: Bạn muốn thêm tiêu chí lọc **"Tần số quét màn hình" (120Hz, 144Hz, 240Hz)** vào trang `laptop.html`:

### Bước 1: Đảm bảo dữ liệu sản phẩm trong DB có thuộc tính này
Kiểm tra cột `specifications` (dạng JSON) của sản phẩm trong bảng `products`:
```json
{
  "cpu": "Intel Core i7-13700H",
  "ram": "16GB",
  "refresh_rate": "144Hz"
}
```

### Bước 2: Bổ sung khối Checkbox vào HTML (`public/laptop.html`)
```html
<div class="accordion-item">
  <div class="accordion-header">
    <span>Tần Số Quét</span>
    <i class="fa-solid fa-chevron-down"></i>
  </div>
  <div class="accordion-content">
    <label class="filter-checkbox">
      <input type="checkbox" name="refresh_rate" value="120Hz"> 120Hz
    </label>
    <label class="filter-checkbox">
      <input type="checkbox" name="refresh_rate" value="144Hz"> 144Hz
    </label>
    <label class="filter-checkbox">
      <input type="checkbox" name="refresh_rate" value="240Hz"> 240Hz
    </label>
  </div>
</div>
```

### Bước 3: Cập nhật hàm so khớp trong `public/js/app.js`
Tìm đến hàm `filterProducts(products, filters)` trong đối tượng `App` và bổ sung điều kiện lọc:
```javascript
// Kiểm tra tần số quét màn hình
if (filters.refresh_rate && filters.refresh_rate.length > 0) {
  matched = matched && product.specifications?.refresh_rate && 
    filters.refresh_rate.includes(product.specifications.refresh_rate);
}
```

---

## 3. Quy Chuẩn Viết Code (Coding Standards)

Để dự án duy trì tính nhất quán và dễ bảo trì, mọi lập trình viên và AI tiếp quản cần tuân thủ các quy chuẩn sau:

### 3.1. Quy chuẩn HTML
1. **Sử dụng thẻ ngữ nghĩa**: Dùng `<header>`, `<nav>`, `<main>`, `<section>`, `<aside>`, `<footer>`. Tránh lạm dụng thẻ `<div>` vô nghĩa.
2. **Thuộc tính khả năng tiếp cận (Accessibility)**: Mọi thẻ `<img>` bắt buộc có `alt` mô tả nội dung ảnh. Các nút chỉ có biểu tượng icon phải có `aria-label`.
3. **ID và Class**: Đặt tên class theo chuẩn BEM đơn giản hóa hoặc dạng kebab-case rõ nghĩa (`.product-card`, `.accordion-header`, `.btn-primary`). Tuyệt đối không đặt tên class mang tính tạm bợ như `.div1`, `.box2`.

### 3.2. Quy chuẩn CSS
1. **Sử dụng Design Tokens**: Luôn tham chiếu biến CSS từ `:root` (`var(--primary)`, `var(--radius-md)`). Tuyệt đối không tự ý viết các mã màu Hex hoặc pixel tùy tiện nằm ngoài hệ thống.
2. **Tuân thủ Viettel Store Theme**: Mọi nút bấm quan trọng (CTA) đều dùng màu đỏ thương hiệu (`#ee0033`). Tránh dùng các màu tương phản kỳ dị (như tím neon, xanh neon) phá vỡ nhận diện thương hiệu.
3. **Hiệu năng chuyển động**: Chỉ animate các thuộc tính `transform` và `opacity`. Tránh animate `margin`, `top/left`, `width`, `height`.

### 3.3. Quy chuẩn JavaScript
1. **Mô hình Singleton**: Không khai báo biến tự do ở phạm vi toàn cục (`window.*`). Đưa tất cả biến và hàm vào bên trong namespace của đối tượng tương ứng (`App`, `Cart`, `Checkout`,...).
2. **Bắt lỗi bất đồng bộ**: Mọi lệnh `fetch()` hoặc `await` bắt buộc phải nằm trong khối `try...catch` và có thông báo lỗi cho người dùng bằng `App.showToast()`.
3. **Bất biến dữ liệu (Immutability)**: Khi xử lý mảng sản phẩm hoặc giỏ hàng, ưu tiên sử dụng `map()`, `filter()`, `reduce()`, hoặc Spread Operator (`[...items]`) thay vì đột biến trực tiếp đối tượng gốc.

---

## 4. Checklist Kiểm Thử Trước Khi Bàn Giao (Release Checklist)

Trước khi commit mã nguồn hoặc đẩy lên môi trường báo cáo, hãy thực hiện kiểm tra các tiêu chí sau:

- [ ] **Khởi động Server**: Chạy `npm start` không xuất hiện lỗi kết nối MySQL hay cổng bị chiếm dụng.
- [ ] **Kiểm tra 9 trang HTML**: Mở lần lượt từng trang, kiểm tra thanh Menu Header, Footer và hiển thị dữ liệu sản phẩm.
- [ ] **Kiểm tra Giỏ hàng**: Thêm 2 món hàng có biến thể khác nhau -> Kiểm tra số lượng badge trên Header -> Mở drawer giỏ hàng -> Tăng/giảm số lượng -> Xóa món hàng. F5 trang xem giỏ hàng có giữ nguyên không.
- [ ] **Kiểm tra Mã giảm giá**: Nhập thử mã `TECH10` -> Kiểm tra tiền giảm giá hiển thị đúng và tổng thanh toán trừ chính xác.
- [ ] **Kiểm tra Luồng Đặt hàng (COD)**: Điền thông tin người nhận -> Nhấn đặt hàng -> Kiểm tra mã đơn hàng hiển thị -> Kiểm tra bản ghi trong bảng `orders` của MySQL.
- [ ] **Kiểm tra Tra cứu đơn hàng**: Nhập số điện thoại vừa đặt hàng vào popup Tra cứu -> Kiểm tra đơn hàng có xuất hiện đúng thông tin không.
- [ ] **Kiểm tra Responsive**: Mở DevTools (F12) chuyển sang chế độ Mobile (iPhone 12 / Galaxy S20) xem giao diện có bị tràn ngang không.
