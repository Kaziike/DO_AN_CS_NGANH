# Đặc Tả Kỹ Thuật Module app.js (UI Controller)

> **File nguồn**: [public/js/app.js](file:///c:/Users/kaziila/Downloads/DO_AN_CO_SO_NGANH/public/js/app.js)  
> **Dung lượng**: ~2.530 dòng  
> **Tài liệu tham chiếu**: [JAVASCRIPT_GUIDE.md](../JAVASCRIPT_GUIDE.md) | [HTML_GUIDE.md](../HTML_GUIDE.md) | [DATA_FLOW.md](../DATA_FLOW.md)

---

## 1. Mục Đích & Trách Nhiệm Cốt Lõi

Module `app.js` là bộ điều phối giao diện trung tâm (Main UI Controller) của TechStore. Module này được đóng gói dưới dạng đối tượng Singleton `App`, chịu trách nhiệm:
1. Nhận diện ngữ cảnh trang hiện tại thông qua `document.body.dataset.category`.
2. Khởi tạo và điều khiển các thành phần giao diện động: Hero Banner Slider, Đồng hồ đếm ngược Flash Sale, Nút cuộn trang kèm vòng tròn SVG.
3. Tải dữ liệu sản phẩm từ API và điều khiển hệ thống **Bộ Lọc Đa Tiêu Chí Dạng Accordion** (lọc theo Hãng, Mức giá, CPU, RAM, Ổ cứng, Màn hình,...).
4. Điều khiển tính năng **Tìm Kiếm Tức Thời (Live Search)** với kỹ thuật Debounce và Highlight từ khóa.
5. Quản lý vòng đời **Modal Chi Tiết Sản Phẩm**: Thư viện ảnh thu nhỏ, bảng thông số kỹ thuật, bộ chọn màu sắc/dung lượng, hệ thống Đánh giá 5 sao và Hỏi đáp Q&A.
6. Quản lý tính năng **Tra Cứu Đơn Hàng Đa Kênh** và tiện ích thông báo **Toast Notification**.

---

## 2. Các Thuộc Tính Trạng Thái (State Properties)

| Tên Thuộc Tính | Kiểu Dữ Liệu | Ý Nghĩa & Vai Trò |
| :--- | :---: | :--- |
| `App.products` | `Array` | Mảng chứa toàn bộ dữ liệu sản phẩm thô tải về từ API cho trang hiện tại. |
| `App.filteredProducts` | `Array` | Mảng sản phẩm sau khi đã áp dụng các tiêu chí lọc accordion và tìm kiếm. |
| `App.pageCategory` | `String` | Slug danh mục của trang hiện tại (lấy từ `document.body.dataset.category`, ví dụ: `'laptop'`, `'smartphone'`). Nếu ở trang chủ, giá trị là rỗng. |
| `App.currentProduct` | `Object \| null` | Bản ghi chi tiết của sản phẩm đang mở trong Modal chi tiết (`#product-modal`). |
| `App.activeFilters` | `Object` | Đối tượng lưu trữ các tiêu chí lọc đang được tích chọn (ví dụ: `{ brand: ['asus'], cpu: ['core-i7'], price: ['15-25m'] }`). |
| `App.currentSort` | `String` | Tiêu chí sắp xếp sản phẩm hiện tại (`'newest'`, `'price-asc'`, `'price-desc'`, `'popular'`). |
| `App.searchDebounceTimer`| `Number \| null` | ID bộ hẹn giờ debounce cho thanh tìm kiếm (trì hoãn 300ms chống spam gọi API). |
| `App.heroSliderTimer` | `Number \| null` | ID bộ hẹn giờ tự động lướt banner Hero Slider trên trang chủ (mỗi 5000ms). |
| `App.flashSaleTimer` | `Number \| null` | ID bộ đếm ngược `setInterval` cập nhật đồng hồ Flash Sale mỗi giây. |

---

## 3. Các Phương Thức Khởi Tạo & Giao Diện Chung

### 3.1. `App.init()`
- **Mục đích**: Điểm vào chính của ứng dụng, được kích hoạt khi sự kiện `DOMContentLoaded` phát ra.
- **Quy trình thực hiện**:
  1. Đọc thuộc tính `document.body.dataset.category` và gán vào `App.pageCategory`.
  2. Gọi `App.initHeader()` để đồng bộ thông tin tài khoản và badge giỏ hàng.
  3. Gọi `App.initFloatingWidgets()` để kích hoạt nút Back-to-top và nút hỗ trợ.
  4. Gọi `App.bindSearch()` và `App.bindOrderTracking()` để gắn sự kiện tìm kiếm và tra cứu đơn.
  5. Nếu là trang chủ: Gọi `App.initHeroSlider()`, `App.initFlashSale()`, và tải các showcase ngành hàng.
  6. Nếu là trang ngành hàng: Gọi `App.initAccordionFilters()` và gọi `App.loadProducts()` để tải dữ liệu.

### 3.2. `App.initHeader()`
- Kiểm tra `localStorage.getItem('techstore_user')`. Nếu có, thay thế nút "Đăng nhập" bằng tên người dùng và dropdown tài khoản (kèm mục "Đơn hàng của tôi" và "Đăng xuất").
- Gắn callback `Cart.onChange()` để tự động cập nhật số lượng badge `#cart-count`.
- Gắn sự kiện click vào `#cart-btn` để mở drawer giỏ hàng `#cart-modal`.

### 3.3. `App.initHeroSlider()`
- Khởi tạo thanh trượt banner tự động trên `index.html`.
- Xử lý chuyển slide bằng việc thay đổi class `.active` trên các slide và chấm dots.
- Tạm dừng tự động trượt khi người dùng di chuột (`mouseenter`) vào khung slider và tiếp tục khi chuột rời đi (`mouseleave`).

### 3.4. `App.initFlashSale()`
- Gọi API `GET /api/flash-sales` để lấy danh sách sản phẩm giảm giá sốc và mốc thời gian kết thúc `end_time`.
- Khởi động `setInterval` mỗi 1.000ms:
  - Tính khoảng chênh lệch thời gian `timeLeft = endTime - now`.
  - Tách thành giờ, phút, giây và gán vào các thẻ `#fs-hours`, `#fs-minutes`, `#fs-seconds`.
  - Nếu `timeLeft <= 0`, hủy interval và hiển thị nhãn "Sự kiện kết thúc".
- Render các thẻ sản phẩm Flash Sale kèm thanh tiến độ:
  $$\text{Tỷ lệ đã bán} = \left(\frac{\text{sold\_count}}{\text{stock\_quantity}}\right) \times 100\%$$

### 3.5. `App.initFloatingWidgets()`
- Lắng nghe sự kiện `window.addEventListener('scroll')`.
- Tính toán tỷ lệ cuộn màn hình:
  $$\text{scrollPercentage} = \frac{\text{window.scrollY}}{\text{document.body.scrollHeight} - \text{window.innerHeight}}$$
- Cập nhật thuộc tính SVG `strokeDashoffset` trên nút `#back-to-top` để tạo hiệu ứng vòng viền đỏ chạy tròn theo tiến độ cuộn trang.
- Ẩn nút khi ở đỉnh trang và hiện mượt mà khi cuộn xuống quá 300px.

---

## 4. Các Phương Thức Bộ Lọc & Tìm Kiếm

### 4.1. `App.loadProducts(category = this.pageCategory)`
- **Mục đích**: Tải danh sách sản phẩm từ máy chủ.
- **Tham số**: `category` (chuỗi slug danh mục).
- **Xử lý**:
  - Gửi request: `fetch('/api/products?category=' + encodeURIComponent(category))`.
  - Nhận JSON và gán vào `App.products` và `App.filteredProducts`.
  - Gọi `App.renderProducts(App.filteredProducts)` để vẽ giao diện.

### 4.2. `App.initAccordionFilters()`
- Lắng nghe sự kiện click trên các tiêu đề `.accordion-header`.
- Bật/tắt class `.active` trên thẻ cha `.accordion-item`, xoay biểu tượng mũi tên chevron 180 độ.

### 4.3. `App.bindFilters()`
- Lắng nghe sự kiện `change` trên toàn bộ các thẻ `<input type="checkbox">` trong `.filter-sidebar`.
- Thu thập tất cả các checkbox đang được chọn thành đối tượng `App.activeFilters`.
- Gọi hàm `App.filterProducts()`.

### 4.4. `App.filterProducts()`
- **Quy trình lọc dữ liệu client**:
  Duyệt qua từng sản phẩm trong `App.products` và kiểm tra các điều kiện:
  1. **Thương hiệu**: `App.activeFilters.brand.includes(product.brand.toLowerCase())`.
  2. **Khoảng giá**: Đối chiếu `product.price` với các mốc giá đã chọn (Dưới 10 triệu, 10 - 20 triệu, Trên 20 triệu,...).
  3. **Thông số phần cứng**: Kiểm tra trường `product.specifications` (CPU, RAM, Ổ cứng, Kích thước màn hình,...).
- Gán kết quả vào `App.filteredProducts`, áp dụng tiêu chí sắp xếp hiện tại và gọi `App.renderProducts()`.

### 4.5. `App.bindSearch()`
- Lắng nghe sự kiện `input` trên thẻ `#search-input`.
- Áp dụng kỹ thuật Debounce:
  ```javascript
  clearTimeout(this.searchDebounceTimer);
  this.searchDebounceTimer = setTimeout(() => {
    this.handleLiveSearch(query);
  }, 300);
  ```
- Khi người dùng gõ từ 2 ký tự trở lên:
  - Lọc nhanh các sản phẩm khớp với từ khóa trong tên hoặc thông số.
  - Sử dụng hàm `App.highlightMatch(text, query)` để bọc từ khóa tìm kiếm trong thẻ `<mark>`.
  - Hiển thị danh sách kết quả xổ xuống tại `#search-results`.

---

## 5. Các Phương Thức Modal Chi Tiết Sản Phẩm

### 5.1. `App.openProductModal(productId)`
- **Mục đích**: Mở popup chi tiết sản phẩm toàn màn hình.
- **Quy trình**:
  1. Tìm sản phẩm theo `productId` từ `App.products` hoặc gọi `GET /api/products/:id`.
  2. Lưu đối tượng vào `App.currentProduct`.
  3. Render thư viện ảnh: Ảnh chính và danh sách thumbnail. Nhấp vào thumbnail sẽ đổi ảnh chính.
  4. Render các nút chọn biến thể (Màu sắc, Dung lượng) kèm sự kiện click đổi giá tương ứng.
  5. Render bảng thông số kỹ thuật chi tiết (`.specs-table`).
  6. Tải danh sách đánh giá (`App.loadReviews(productId)`) và danh sách câu hỏi Q&A (`App.loadQuestions(productId)`).
  7. Thêm class `.show` vào `#product-modal` và khóa cuộn trang nền (`document.body.style.overflow = 'hidden'`).

### 5.2. `App.loadReviews(productId)` & `App.submitReview()`
- Gửi yêu cầu `GET /api/reviews/product/:id` để lấy danh sách nhận xét.
- Tính điểm trung bình sao và vẽ biểu đồ thanh phần trăm đánh giá.
- Xử lý gửi biểu mẫu đánh giá: Kiểm tra số sao chọn (1-5), nội dung bình luận, gửi `POST /api/reviews` và cập nhật danh sách ngay lập tức.

### 5.3. `App.loadQuestions(productId)` & `App.submitQuestion()`
- Tải cây câu hỏi & câu trả lời (Q&A phân cấp).
- Cho phép khách hàng gửi câu hỏi mới hoặc trả lời câu hỏi của người khác.

---

## 6. Các Phương Thức Tra Cứu Đơn Hàng & Tiện Ích

### 6.1. `App.bindOrderTracking()`
- Gắn sự kiện click vào nút "Tra cứu đơn hàng" trên Header để mở `#order-tracking-modal`.
- Lắng nghe sự kiện submit form tra cứu: Lấy giá trị mã đơn hoặc SĐT từ ô nhập, gọi `GET /api/orders/track?query=...`.
- Render danh sách thẻ đơn hàng kèm trạng thái (Chờ duyệt, Đang giao, Đã giao,...), ngày tạo, địa chỉ và tổng tiền.

### 6.2. `App.showToast(message, type = 'info')`
- Tạo hoặc tái sử dụng container `#toast-container` ở góc trên bên phải màn hình.
- Sinh thẻ HTML thông báo với màu sắc tương ứng (`success`: xanh lá, `error`: đỏ, `warning`: vàng cam, `info`: xanh dương).
- Tự động biến mất sau 3.000ms với hiệu ứng trượt mượt mà.
