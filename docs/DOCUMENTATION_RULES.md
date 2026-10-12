# Quy Tắc Duy Trì & Cập Nhật Tài Liệu TechStore

> **Dự án**: TechStore - Website Bán Lẻ Công Nghệ  
> **Tài liệu tham chiếu**: [README.md](./README.md) | [DEVELOPMENT_GUIDE.md](./DEVELOPMENT_GUIDE.md)

---

## 1. Nguyên Tắc Cốt Lõi (Core Principles)

Tài liệu kỹ thuật chỉ có giá trị thực tế khi nó **đồng bộ 100% với mã nguồn đang chạy**. Một tài liệu sai lệch hoặc mô tả phiên bản cũ sẽ gây nguy hiểm hơn việc không có tài liệu. Do đó, mọi lập trình viên và AI Agent khi làm việc trên kho mã nguồn TechStore phải tuân thủ nghiêm ngặt nguyên tắc:

> **"Không có tính năng nào được xem là hoàn thành nếu tài liệu kỹ thuật tương ứng chưa được cập nhật."**

---

## 2. Bảng Ánh Xạ Thay Đổi Mã Nguồn & Tài Liệu Cần Cập Nhật

Khi bạn thực hiện bất kỳ thay đổi nào trong mã nguồn dự án, hãy sử dụng bảng dưới đây để xác định các file tài liệu Markdown bắt buộc phải cập nhật:

| Khi Bạn Thay Đổi / Thêm Mới Mã Nguồn... | File Tài Liệu Bắt Buộc Cập Nhật | Nội Dung Cần Sửa Đổi |
| :--- | :--- | :--- |
| **Thêm hoặc đổi tên trang HTML** (`public/*.html`) | [FILE_STRUCTURE.md](./FILE_STRUCTURE.md)<br/>[HTML_GUIDE.md](./HTML_GUIDE.md) | Bổ sung file vào cây thư mục, mô tả cấu trúc DOM, dataset `data-category` và các container kết nối JS. |
| **Thêm biến CSS, đổi màu sắc hoặc sửa layout** (`public/css/*`) | [CSS_GUIDE.md](./CSS_GUIDE.md) | Cập nhật bảng Design Tokens (`:root`), quy tắc Flexbox/Grid và các điểm ngắt Responsive. |
| **Thêm hoặc sửa hàm trong các module JS** (`public/js/*`) | [docs/modules/*.md](./modules/README.md)<br/>[JAVASCRIPT_GUIDE.md](./JAVASCRIPT_GUIDE.md) | Cập nhật danh sách hàm, tham số đầu vào, giá trị trả về, logic xử lý và các ngoại lệ. |
| **Thêm hoặc sửa Endpoint REST API** (`server/routes/api.js`) | [API_AND_STORAGE.md](./API_AND_STORAGE.md)<br/>[FEATURES.md](./FEATURES.md) | Cập nhật URL endpoint, Method, Header yêu cầu, Request Body và Response JSON mẫu. |
| **Thay đổi cấu trúc bảng cơ sở dữ liệu** (`database/*.sql`) | [API_AND_STORAGE.md](./API_AND_STORAGE.md) | Cập nhật sơ đồ Mermaid ERD và mô tả các trường mới trong bảng dữ liệu. |
| **Thay đổi luồng mua hàng hoặc cổng thanh toán** | [DATA_FLOW.md](./DATA_FLOW.md)<br/>[modules/payment-gateway.md](./modules/payment-gateway.md) | Cập nhật sơ đồ Sequence/Flowchart Mermaid mô tả đúng các bước xử lý mới. |
| **Gặp lỗi mới và tìm ra cách giải quyết** | [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) | Bổ sung mục lỗi mới: Dấu hiệu, Nguyên nhân và Các bước khắc phục cụ thể. |
| **Khắc phục xong một nợ kỹ thuật** | [TECH_DEBT.md](./TECH_DEBT.md) | Chuyển trạng thái từ Nợ kỹ thuật sang Đã giải quyết, cập nhật lộ trình. |

---

## 3. Quy Chuẩn Trình Bày Tài Liệu Markdown

1. **Ngôn ngữ**: Sử dụng tiếng Việt chuẩn mực, rõ ràng, gãy gọn. Giữ nguyên 100% tên biến, tên hàm, tên file, class CSS và các thuật ngữ kỹ thuật chuyên ngành bằng tiếng Anh (ví dụ: `App.init()`, `localStorage`, `Connection Pool`, `Responsive Breakpoints`).
2. **Liên kết tương đối**: Luôn sử dụng đường dẫn tương đối khi liên kết giữa các file tài liệu (ví dụ: `[CSS_GUIDE.md](./CSS_GUIDE.md)` hoặc `[modules/cart.md](./modules/cart.md)`), không dùng đường dẫn tuyệt đối của máy tính cá nhân.
3. **Trích dẫn mã nguồn**: Chỉ trích dẫn các đoạn code ngắn (dưới 30 dòng) làm ví dụ minh họa trực quan. Tuyệt đối không sao chép nguyên văn toàn bộ file code vào tài liệu.
4. **Sơ đồ trực quan**: Sử dụng cú pháp **Mermaid** (`graph TD`, `sequenceDiagram`, `erDiagram`) để vẽ sơ đồ. Đảm bảo cú pháp chuẩn xác để GitHub và IDE có thể render trực tiếp mà không bị lỗi.
5. **Hộp cảnh báo (GitHub Alerts)**:
   - Dùng `> [!NOTE]` cho các ghi chú mở rộng hoặc kiến thức nền tảng.
   - Dùng `> [!IMPORTANT]` cho các quy tắc bắt buộc phải tuân theo.
   - Dùng `> [!WARNING]` cho các rủi ro kỹ thuật có thể gây vỡ giao diện hoặc lỗi hệ thống.

---

## 4. Hướng Dẫn Đặc Biệt Dành Cho AI Agent

Khi một AI Assistant được giao nhiệm vụ tiếp quản, bảo trì hoặc mở rộng mã nguồn TechStore:
1. **Kiểm tra tài liệu trước**: Luôn đọc `docs/README.md` và các file liên quan trước khi tiến hành viết code để hiểu rõ các ràng buộc kiến trúc hiện có.
2. **Không phá vỡ cấu trúc Viettel Store Theme**: Mọi can thiệp CSS phải tuân thủ nghiêm ngặt bảng màu và tokens đã định nghĩa trong `docs/CSS_GUIDE.md`.
3. **Đồng bộ tài liệu sau khi sửa code**: Sau khi hoàn tất việc chỉnh sửa hoặc bổ sung mã nguồn, AI Agent có trách nhiệm tự động cập nhật lại các file tài liệu Markdown bị ảnh hưởng tương ứng.
