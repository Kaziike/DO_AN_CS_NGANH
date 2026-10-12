# Đặc Tả Kỹ Thuật Module auth.js (Authentication Client)

> **File nguồn**: [public/js/auth.js](file:///c:/Users/kaziila/Downloads/DO_AN_CO_SO_NGANH/public/js/auth.js)  
> **Dung lượng**: ~160 dòng  
> **Tài liệu tham chiếu**: [JAVASCRIPT_GUIDE.md](../JAVASCRIPT_GUIDE.md) | [HTML_GUIDE.md](../HTML_GUIDE.md) | [API_AND_STORAGE.md](../API_AND_STORAGE.md)

---

## 1. Mục Đích & Trách Nhiệm Cốt Lõi

Module `auth.js` là bộ điều phối giao diện xác thực người dùng trên trang `public/login.html`. Module được đóng gói dưới dạng Singleton `AuthPage`, chịu trách nhiệm:
1. Điều khiển chuyển đổi mượt mà giữa hai biểu mẫu **Đăng Nhập** và **Đăng Ký** (hỗ trợ điều hướng qua URL Hash `#login` và `#register`).
2. Kiểm tra tính hợp lệ (Validation) của thông tin người dùng nhập: Họ tên, Email, Số điện thoại Việt Nam, Mật khẩu và Xác nhận mật khẩu.
3. Gửi yêu cầu xác thực sang các endpoint API backend (`POST /api/auth/login` và `POST /api/auth/register`).
4. Quản lý trạng thái phiên đăng nhập thông qua khóa `techstore_user` trong `localStorage`.
5. Tự động điều hướng người dùng sau khi xác thực thành công (chuyển sang `admin.html` nếu là quản trị viên, hoặc `index.html` nếu là khách hàng).

---

## 2. Các Thuộc Tính Trạng Thái (State Properties)

| Tên Thuộc Tính | Kiểu Dữ Liệu | Giá Trị Mặc Định | Ý Nghĩa & Vai Trò |
| :--- | :---: | :---: | :--- |
| `AuthPage.activeTab` | `String` | `'login'` | Tab xác thực hiện tại (`'login'` hoặc `'register'`). |
| `AuthPage.loginForm` | `HTMLElement \| null` | `null` | Tham chiếu tới thẻ `<form id="login-form">`. |
| `AuthPage.registerForm`| `HTMLElement \| null` | `null` | Tham chiếu tới thẻ `<form id="register-form">`. |

---

## 3. Chi Tiết Các Phương Thức Xử Lý

### 3.1. `AuthPage.init()`
- **Mục đích**: Khởi động trang xác thực khi tải xong DOM.
- **Quy trình thực hiện**:
  1. Kiểm tra xem người dùng đã đăng nhập chưa bằng `localStorage.getItem('techstore_user')`. Nếu đã đăng nhập, tự động chuyển hướng về trang chủ `index.html`.
  2. Đọc giá trị hash từ thanh địa chỉ trình duyệt (`window.location.hash`):
     - Nếu URL là `login.html#register`, tự động chuyển sang tab Đăng ký.
     - Ngược lại, giữ nguyên tab Đăng nhập mặc định.
  3. Gắn sự kiện click trên các nút chuyển tab `.auth-tab-btn`.
  4. Gắn sự kiện `submit` trên `#login-form` gọi `AuthPage.handleLogin(e)`.
  5. Gắn sự kiện `submit` trên `#register-form` gọi `AuthPage.handleRegister(e)`.

### 3.2. `AuthPage.switchTab(tabName)`
- **Mục đích**: Chuyển đổi qua lại giữa tab Đăng nhập và Đăng ký.
- **Tham số**: `tabName` (`'login'` hoặc `'register'`).
- **Xử lý**:
  - Gán `this.activeTab = tabName`.
  - Cập nhật URL Hash: `window.location.hash = tabName`.
  - Cập nhật class `.active` trên nút bấm tab và khung chứa form tương ứng.

### 3.3. `AuthPage.handleLogin(event)`
- **Mục đích**: Xử lý đăng nhập tài khoản.
- **Quy trình thực hiện**:
  1. `event.preventDefault()` ngăn form reload trang.
  2. Lấy giá trị Email và Mật khẩu.
  3. **Kiểm tra dữ liệu**:
     - Email không được rỗng và đúng định dạng.
     - Mật khẩu tối thiểu 6 ký tự.
  4. Gửi yêu cầu HTTP:
     ```javascript
     const res = await fetch('/api/auth/login', {
       method: 'POST',
       headers: { 'Content-Type': 'application/json' },
       body: JSON.stringify({ email, password })
     });
     ```
  5. **Xử lý kết quả**:
     - **Nếu thành công**:
       - Lưu thông tin người dùng vào `localStorage`:
         ```javascript
         localStorage.setItem('techstore_user', JSON.stringify(data.user));
         ```
       - Phân quyền điều hướng:
         - Nếu `data.user.role === 'admin'`: Chuyển hướng tới `admin.html`.
         - Nếu `data.user.role === 'customer'`: Chuyển hướng tới `index.html` (hoặc trang trước đó).
     - **Nếu thất bại**:
       - Hiển thị thông báo lỗi: "Email hoặc mật khẩu không chính xác".

### 3.4. `AuthPage.handleRegister(event)`
- **Mục đích**: Xử lý đăng ký tài khoản khách hàng mới.
- **Quy trình thực hiện**:
  1. `event.preventDefault()`.
  2. Thu thập các trường: Họ và tên, Email, Số điện thoại, Mật khẩu, Xác nhận mật khẩu.
  3. **Kiểm tra dữ liệu nghiêm ngặt**:
     - Họ tên tối thiểu 2 ký tự.
     - Số điện thoại đầu số Việt Nam hợp lệ (10 số).
     - Mật khẩu tối thiểu 6 ký tự.
     - Mật khẩu và Xác nhận mật khẩu phải trùng khớp nhau (`password === confirmPassword`).
  4. Gửi yêu cầu HTTP: `POST /api/auth/register`.
  5. **Xử lý kết quả**:
     - **Nếu thành công**:
       - Hiển thị thông báo Toast: "Đăng ký tài khoản thành công! Vui lòng đăng nhập."
       - Chuyển sang tab Đăng nhập: `AuthPage.switchTab('login')`.
       - Điền sẵn email vừa đăng ký vào ô đăng nhập.
     - **Nếu thất bại**:
       - Hiển thị thông báo: "Email này đã được sử dụng. Vui lòng chọn email khác."

### 3.5. `AuthPage.logout()`
- **Mục đích**: Đăng xuất tài khoản khỏi hệ thống (hàm này được gọi từ menu Header trên các trang khác).
- **Xử lý**:
  ```javascript
  localStorage.removeItem('techstore_user');
  window.location.href = 'index.html';
  ```
