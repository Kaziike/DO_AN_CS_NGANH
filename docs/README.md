# Tài Liệu Kỹ Thuật Dự Án TechStore

> **Dự án**: Website Thương Mại Điện Tử Bán Lẻ Công Nghệ TechStore (Đồ Án Cơ Sở Ngành)  
> **Phiên bản tài liệu**: 1.0.0  
> **Ngày lập**: 12/10/2026  
> **Đối tượng sử dụng**: Lập trình viên Fullstack, Senior Developer, Đội ngũ bảo trì và AI Agent tiếp quản dự án.

---

## 1. Giới Thiệu Hệ Thống Tài Liệu

Hệ thống tài liệu này được xây dựng dựa trên việc phân tích mã nguồn thực tế của toàn bộ dự án **TechStore**. Mục tiêu của bộ tài liệu là cung cấp cái nhìn toàn diện, chính xác và có thể tra cứu nhanh chóng về kiến trúc hệ thống, cấu trúc thư mục, giao diện người dùng, logic JavaScript, cơ sở dữ liệu và quy trình bảo trì/mở rộng mà không làm gián đoạn hay phá vỡ các chức năng đang hoạt động.

Tất cả các mô tả trong tài liệu đều phản ánh **chính xác hiện trạng mã nguồn**, phân biệt rõ giữa tính năng đã hoàn thiện, tính năng hoạt động ở mức mô phỏng (mock/simulation) và các nợ kỹ thuật cần xử lý.

---

## 2. Mục Lục Toàn Bộ Hệ Thống Tài Liệu

Hệ thống tài liệu được phân chia thành các chủ đề chuyên sâu sau:

### Tài Liệu Tổng Quan & Kiến Trúc
1. [Tổng Quan Dự Án (PROJECT_OVERVIEW.md)](./PROJECT_OVERVIEW.md)  
   *Mục đích, công nghệ, cách thiết lập & khởi chạy, trạng thái hiện tại và các lưu ý quan trọng.*
2. [Kiến Trúc Hệ Thống (ARCHITECTURE.md)](./ARCHITECTURE.md)  
   *Sơ đồ kiến trúc Client - Server - Database, nguyên lý luồng dữ liệu, trạng thái Reactive và mô hình điều phối.*
3. [Cấu Trúc Thư Mục & File (FILE_STRUCTURE.md)](./FILE_STRUCTURE.md)  
   *Sơ đồ cây thư mục thực tế, vai trò cụ thể của từng file mã nguồn, stylesheet, script và database.*
4. [Ma Trận Tính Năng (FEATURES.md)](./FEATURES.md)  
   *Bảng theo dõi toàn bộ chức năng, trạng thái triển khai (Đã xong / Mô phỏng / Chưa hoàn thiện), file liên quan và lưu ý khi sửa đổi.*
5. [Luồng Dữ Liệu & Tương Tác (DATA_FLOW.md)](./DATA_FLOW.md)  
   *Sơ đồ Mermaid chi tiết về luồng Mua hàng - Giỏ hàng - Đặt hàng - Thanh toán OTP - Quản trị Admin.*

### Tài Liệu Chi Tiết Frontend & Giao Diện
6. [Hướng Dẫn & Cấu Trúc HTML (HTML_GUIDE.md)](./HTML_GUIDE.md)  
   *Phân tích 9 trang HTML (`index.html`, 6 trang danh mục chuyên biệt, `login.html`, `admin.html`), DOM layout, `data-category` và các container kết nối JS.*
7. [Hướng Dẫn Hệ Thống CSS (CSS_GUIDE.md)](./CSS_GUIDE.md)  
   *Viettel Store Theme (Đỏ `#ee0033` - Trắng), hệ màu, typography Inter, kỹ thuật Flexbox/Grid, Responsive breakpoints và quy tắc mở rộng CSS.*

### Tài Liệu Chi Tiết JavaScript & Logic
8. [Hướng Dẫn Kiến Trúc JavaScript (JAVASCRIPT_GUIDE.md)](./JAVASCRIPT_GUIDE.md)  
   *Tổng quan các Singletons/Modules frontend, cách các module chia sẻ dữ liệu và lắng nghe sự kiện.*
9. [Đặc Tả Chi Tiết Từng Module JavaScript](./modules/README.md):
   - [Module app.js (App Singleton & UI Controller)](./modules/app.md) - *2530 dòng: Bộ lọc Accordion đa tầng, Flash Sale, Live Search, Product Modal, Reviews & Q&A, Tra cứu đơn hàng.*
   - [Module cart.js (Cart Service & State Storage)](./modules/cart.md) - *Quản lý giỏ hàng Reactive, LocalStorage `techstore_cart_v1`, tính toán giảm giá voucher.*
   - [Module checkout.js (Checkout Workflow)](./modules/checkout.md) - *Modal đặt hàng, validation form thông tin người nhận, tính phí giao hàng và gửi đơn.*
   - [Module payment-gateway.js (Cổng Thanh Toán Mô Phỏng)](./modules/payment-gateway.md) - *Mô phỏng VNPay-QR, MoMo, Thẻ Visa/Mastercard, cơ chế đếm ngược OTP 10 phút.*
   - [Module auth.js (Authentication Client)](./modules/auth.md) - *Đăng nhập, đăng ký, đồng bộ phiên với `localStorage.techstore_user`.*
   - [Module admin.js (Trang Quản Trị CRUD)](./modules/admin.md) - *Quản lý Đơn hàng, Sản phẩm, Flash Sale, bộ lọc trạng thái và phân quyền Admin.*

### Tài Liệu Backend, Lưu Trữ & Vận Hành
10. [Đặc Tả REST API & Cơ Chế Lưu Trữ (API_AND_STORAGE.md)](./API_AND_STORAGE.md)  
    *Chi tiết toàn bộ Endpoints (Request/Response), Schema MySQL 8.0 (9 bảng dữ liệu) và cấu trúc LocalStorage keys.*
11. [Hướng Dẫn Phát Triển & Mở Rộng (DEVELOPMENT_GUIDE.md)](./DEVELOPMENT_GUIDE.md)  
    *Quy trình thêm trang mới, thêm tiêu chí lọc thuộc tính, tích hợp cổng thanh toán thực tế và checklist kiểm thử.*
12. [Chẩn Đoán & Khắc Phục Sự Cố (TROUBLESHOOTING.md)](./TROUBLESHOOTING.md)  
    *Xử lý lỗi kết nối MySQL, xung đột Port 3000, lỗi đồng bộ giỏ hàng, lỗi filter không ra sản phẩm.*
13. [Nợ Kỹ Thuật & Đề Xuất Cải Tiến (TECH_DEBT.md)](./TECH_DEBT.md)  
    *Phân tích các rủi ro bảo mật (Password hash, Token JWT, Admin header spoofing), tối ưu hiệu năng và kế hoạch nâng cấp.*
14. [Quy Tắc Duy Trì Tài Liệu (DOCUMENTATION_RULES.md)](./DOCUMENTATION_RULES.md)  
    *Hướng dẫn cho lập trình viên và AI agent cách cập nhật tài liệu khi thay đổi mã nguồn trong tương lai.*

---

## 3. Bản Đồ Điều Hướng Nhanh Theo Nhu Cầu

| Bạn cần làm gì? | Hãy xem tài liệu này đầu tiên |
| :--- | :--- |
| **Cài đặt và chạy ứng dụng từ đầu** | [PROJECT_OVERVIEW.md](./PROJECT_OVERVIEW.md) & [DEVELOPMENT_GUIDE.md](./DEVELOPMENT_GUIDE.md) |
| **Hiểu luồng mua hàng và thanh toán** | [DATA_FLOW.md](./DATA_FLOW.md) & [modules/checkout.md](./modules/checkout.md) |
| **Sửa giao diện, đổi màu hoặc responsive** | [CSS_GUIDE.md](./CSS_GUIDE.md) & [HTML_GUIDE.md](./HTML_GUIDE.md) |
| **Thêm danh mục hoặc thuộc tính bộ lọc mới** | [modules/app.md](./modules/app.md) & [DEVELOPMENT_GUIDE.md](./DEVELOPMENT_GUIDE.md) |
| **Tích hợp API thực tế hoặc sửa Database** | [API_AND_STORAGE.md](./API_AND_STORAGE.md) |
| **Khắc phục lỗi server không khởi động / không hiện data** | [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) |
| **Đánh giá rủi ro bảo mật & tối ưu mã nguồn** | [TECH_DEBT.md](./TECH_DEBT.md) |

---

## 4. Cam Kết Toàn Vẹn Mã Nguồn

> [!IMPORTANT]
> Toàn bộ quá trình tạo lập hệ thống tài liệu này tuân thủ nguyên tắc:
> 1. **Tuyệt đối không can thiệp, sửa đổi, định dạng lại hay xóa bỏ** bất kỳ file mã nguồn logic, stylesheet, markup hay database nào của dự án.
> 2. Tài liệu được biên soạn dựa trên việc đọc trực tiếp từng dòng code thực tế, đảm bảo độ chuẩn xác 100% với hiện trạng dự án.
