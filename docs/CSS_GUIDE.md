# Hướng Dẫn Hệ Thống CSS Dự Án TechStore

> **Dự án**: TechStore - Website Bán Lẻ Công Nghệ  
> **Tài liệu tham chiếu**: [HTML_GUIDE.md](./HTML_GUIDE.md) | [ARCHITECTURE.md](./ARCHITECTURE.md)

---

## 1. Triết Lý Thiết Kế & Nhận Diện Thương Hiệu

Hệ thống giao diện của TechStore được xây dựng dựa trên phong cách **Viettel Store Theme** — chuẩn mực thiết kế thương mại điện tử bán lẻ thiết bị số hàng đầu tại Việt Nam:
- **Tông màu chủ đạo**: Sắc đỏ thương hiệu rực rỡ (`#ee0033` / `#c81b1b`) đại diện cho sự năng động, công nghệ và các chương trình khuyến mãi kích cầu mua sắm.
- **Nền tảng màu sắc**: Tông nền xám nhạt (`#f4f5f8`) kết hợp các khối thẻ màu trắng tinh khôi (`#ffffff`) giúp các sản phẩm công nghệ (điện thoại, laptop, phụ kiện) nổi bật tối đa.
- **Typography hiện đại**: Sử dụng phông chữ Google Fonts **Inter** chuẩn quốc tế, mang lại độ sắc nét cao, dễ đọc trên mọi kích thước màn hình từ điện thoại tới màn hình 4K.
- **Biểu tượng đồng bộ**: Thư viện Font Awesome 6 hiển thị sắc nét các biểu tượng điều hướng, xếp hạng sao và thao tác giỏ hàng.

> [!IMPORTANT]
> **Lưu ý nhận diện**: Dự án **không** sử dụng phong cách Dark Mode, Cyberpunk hay Neon. Mọi định kiểu giao diện đều hướng đến sự tin cậy, sáng sủa, thanh lịch và thân thiện với người tiêu dùng Việt Nam.

---

## 2. Hệ Thống File CSS Trong Dự Án

Hệ thống CSS được phân tách thành 3 stylesheet độc lập phục vụ các ngữ cảnh riêng biệt:

| Tên File | Dung lượng | Phạm vi áp dụng | Mô tả chức năng |
| :--- | :--- | :--- | :--- |
| `public/css/style.css` | ~4.220 dòng | Toàn bộ trang người dùng | Chứa toàn bộ CSS Reset, Tokens, Typography, Header, Navigation, Product Cards, Sidebar Accordion Filter, Modals, Drawer giỏ hàng, Banner Slider, Flash Sale, và Responsive. |
| `public/css/admin.css` | ~313 dòng | `admin.html` | Định kiểu riêng cho trang quản trị: Sidebar điều hướng màu tối, các thẻ thống kê KPI, bảng dữ liệu (Data Tables), huy hiệu trạng thái đơn hàng (Badges) và modal thêm sửa sản phẩm. |
| `public/css/payment.css` | ~345 dòng | Modal thanh toán | Định kiểu cho giao diện cổng thanh toán mô phỏng: Khung chuyển tab VNPAY/MoMo/Thẻ, khung hiển thị mã QR có logo ngân hàng, form thẻ 3D Secure, và hộp đếm ngược mã OTP. |

---

## 3. Hệ Thống Biến CSS (Design Tokens)

Tất cả các giá trị cốt lõi được định nghĩa tập trung tại khối `:root` ở đầu file `public/css/style.css`:

```css
:root {
  /* Bảng màu nhận diện thương hiệu Viettel Store */
  --primary: #ee0033;
  --primary-dark: #c81b1b;
  --primary-light: #fff0f2;
  --primary-hover: #d6002e;

  /* Màu bổ trợ & Trạng thái */
  --secondary: #008848;       /* Xanh lá: Xác nhận thành công, còn hàng */
  --accent: #ff9800;          /* Vàng cam: Cảnh báo, flash sale, sao đánh giá */
  --danger: #dc3545;          /* Đỏ cảnh báo: Hủy đơn, hết hàng */
  --info: #007bff;            /* Xanh dương: Thông tin, liên kết */

  /* Nền và Bề mặt */
  --bg-body: #f4f5f8;         /* Màu nền trang web xám dịu */
  --bg-card: #ffffff;         /* Màu nền thẻ sản phẩm, panel trắng */
  --bg-hover: #f8f9fa;        /* Màu nền hover nhẹ */

  /* Màu chữ (Typography) */
  --text-primary: #1f2937;    /* Màu chữ chính đen than */
  --text-secondary: #4b5563;  /* Màu chữ phụ xám trung tính */
  --text-muted: #9ca3af;      /* Màu chữ mờ xám nhạt */
  --text-white: #ffffff;

  /* Đường viền & Phân cách */
  --border-color: #e5e7eb;
  --border-light: #f3f4f6;

  /* Đổ bóng (Box Shadow Tokens) */
  --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.08);
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
  --shadow-card: 0 2px 8px rgba(0, 0, 0, 0.06);
  --shadow-hover: 0 8px 24px rgba(238, 0, 51, 0.15);

  /* Bán kính bo góc (Border Radius) */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-xl: 16px;
  --radius-full: 9999px;

  /* Tốc độ hiệu ứng (Transitions) */
  --transition-fast: 0.15s ease;
  --transition-normal: 0.25s ease;
  --transition-slow: 0.35s ease;
}
```

---

## 4. Kỹ Thuật Bố Cục Cốt Lõi (Layout Techniques)

### 4.1. Lưới Sản Phẩm Linh Hoạt (CSS Grid Auto-Fill)
Khu vực hiển thị danh sách sản phẩm (`#product-grid`) sử dụng CSS Grid hiện đại kết hợp hàm `minmax()` giúp tự động dàn số lượng cột phù hợp với độ phân giải màn hình mà không cần nhiều media queries:

```css
.product-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(230px, 1fr));
  gap: 16px;
  padding: 16px 0;
}
```

### 4.2. Khung Bố Cục Trang Danh Mục 2 Cột
Các trang ngành hàng kết hợp Flexbox giữa Sidebar và Nội dung chính:
```css
.category-container {
  display: flex;
  gap: 24px;
  align-items: flex-start;
  max-width: 1240px;
  margin: 0 auto;
  padding: 20px 16px;
}

.filter-sidebar {
  width: 260px;
  flex-shrink: 0;
  background: var(--bg-card);
  border-radius: var(--radius-md);
  border: 1px solid var(--border-color);
  box-shadow: var(--shadow-sm);
  position: sticky;
  top: 90px; /* Ghim sidebar khi cuộn trang */
}

.category-content {
  flex-grow: 1;
  min-width: 0; /* Chống vỡ layout Flexbox */
}
```

### 4.3. Thẻ Sản Phẩm Tự Căn Chân (Equal Height Flex Card)
Mỗi thẻ `.product-card` được thiết kế dưới dạng Flexbox cột. Đoạn nút mua hàng luôn được đẩy xuống đáy thẻ nhờ quy tắc `margin-top: auto`:
```css
.product-card {
  display: flex;
  flex-direction: column;
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  padding: 12px;
  transition: transform var(--transition-normal), box-shadow var(--transition-normal);
  position: relative;
}

.product-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-hover);
  border-color: rgba(238, 0, 51, 0.3);
}

.product-card .card-footer {
  margin-top: auto; /* Đảm bảo nút mua hàng luôn thẳng hàng ngang */
  padding-top: 10px;
}
```

---

## 5. Các Thành Phần Giao Diện Đặc Trưng (Key Components)

### 5.1. Bộ Lọc Thuộc Tính Accordion (`.accordion-item`)
- Tiêu đề Accordion (`.accordion-header`): Chứa icon mũi tên xoay chuyển 180 độ khi mở (`transform: rotate(180deg)`).
- Nội dung Accordion (`.accordion-content`): Sử dụng hiệu ứng chuyển động mượt mà khi đóng mở.
- Checkbox tùy biến: Thay thế ô vuông mặc định của trình duyệt bằng thiết kế viền đỏ tinh tế khi chọn (`:checked`).

### 5.2. Khối Flash Sale Gradient Rực Lửa (`#flash-sale-section`)
- Sử dụng dải màu gradient đỏ rực:
  ```css
  background: linear-gradient(135deg, #ee0033 0%, #ff3838 50%, #c81b1b 100%);
  ```
- Đồng hồ đếm ngược (`.fs-timer-box`): Các ô số nền đen tuyền bo góc, số màu trắng đậm nét hiển thị thời gian giây, phút, giờ.
- Thanh tiến độ hàng đã bán (`.fs-sold-bar`):
  ```css
  .fs-sold-progress {
    height: 14px;
    border-radius: var(--radius-full);
    background: #ffcdd2;
    overflow: hidden;
    position: relative;
  }
  .fs-sold-fill {
    height: 100%;
    background: linear-gradient(90deg, #ff9800, #ee0033);
    border-radius: var(--radius-full);
    transition: width 0.6s cubic-bezier(0.4, 0, 0.2, 1);
  }
  ```

### 5.3. Nút Cuộn Trang Kèm Vòng Tròn Tiến Độ SVG (`#back-to-top`)
Nút điều khiển nổi ở góc dưới bên phải màn hình:
- Chứa thẻ `<svg>` vẽ vòng tròn với thuộc tính `stroke-dasharray` và `stroke-dashoffset`.
- Khi người dùng cuộn trang từ trên xuống dưới, đoạn mã JS trong `app.js` sẽ cập nhật tỷ lệ phần trăm cuộn trang vào `stroke-dashoffset`, biến vòng tròn viền đỏ chạy tròn đều quanh nút mũi tên.

---

## 6. Quy Tắc Responsive & Điểm Ngắt (Breakpoints)

Hệ thống CSS áp dụng phương pháp đáp ứng đa màn hình với các điểm ngắt tiêu chuẩn:

| Breakpoint | Phạm vi áp dụng | Điều chỉnh giao diện chính |
| :--- | :--- | :--- |
| **Desktop lớn** | `> 1200px` | Khung nội dung tối đa 1240px căn giữa, lưới sản phẩm 4-5 cột, hiển thị toàn bộ chi tiết lọc. |
| **Desktop / Laptop** | `992px - 1199px` | Lưới sản phẩm 3-4 cột, khoảng cách các khối co nhỏ nhẹ từ 24px xuống 16px. |
| **Tablet** | `768px - 991px` | Sidebar bộ lọc chuyển sang dạng nút bấm mở trượt (Off-canvas Drawer), lưới sản phẩm 2-3 cột, thanh menu ngang cho phép cuộn ngang (overflow-x: auto). |
| **Mobile** | `< 768px` | Lưới sản phẩm cố định 2 cột nhỏ gọn, thanh tìm kiếm hiển thị full chiều ngang, ẩn bớt text ở hotline/tra cứu đơn, drawer giỏ hàng mở full 100% chiều rộng màn hình. |

---

## 7. Hướng Dẫn Mở Rộng & Chỉnh Sửa Style An Toàn

1. **Tuyệt đối không sửa trực tiếp mã màu mã Hex rời rạc**: Luôn sử dụng biến `var(--primary)`, `var(--bg-body)` thay vì gõ cứng `#ee0033` hay `#f4f5f8`.
2. **Tránh xung đột Z-Index**:
   - `z-index: 100`: Thẻ sản phẩm hover, badges.
   - `z-index: 500`: Sidebar filter sticky.
   - `z-index: 1000`: Header chính.
   - `z-index: 2000`: Back-to-top & Floating Contact Widget.
   - `z-index: 9999`: Toàn bộ các Backdrop Modal và Drawer giỏ hàng.
3. **Thêm hiệu ứng hoạt họa (Animation)**: Luôn tận dụng các thuộc tính có tăng tốc phần cứng (`transform`, `opacity`) thay vì thay đổi `width`, `height`, hoặc `top/left` để tránh hiện tượng giật khung hình (layout thrashing).
