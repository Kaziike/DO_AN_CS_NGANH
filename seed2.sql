-- ==========================================================
-- DỮ LIỆU MẪU ĐẦY ĐỦ SEED 2 (7 DANH MỤC X 20 SẢN PHẨM = 140 SẢN PHẨM)
-- Tích hợp nhiều phân loại (Variants) & thư viện ảnh bổ sung (Demo Images)
-- ==========================================================

USE `techstore_db`;

-- Đảm bảo cấu trúc cột sold_count và bảng flash_sales
CREATE TABLE IF NOT EXISTS `flash_sales` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `product_id` INT NOT NULL,
  `flash_price` DECIMAL(15, 0) NOT NULL,
  `flash_stock` INT NOT NULL DEFAULT 20,
  `sold_count` INT NOT NULL DEFAULT 0,
  `start_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end_time` DATETIME NOT NULL,
  `is_active` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `fk_flash_sales_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE `order_items`;
TRUNCATE TABLE `orders`;
TRUNCATE TABLE `reviews`;
TRUNCATE TABLE `product_questions`;
TRUNCATE TABLE `flash_sales`;
TRUNCATE TABLE `products`;
TRUNCATE TABLE `categories`;
TRUNCATE TABLE `coupons`;
TRUNCATE TABLE `users`;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. TÀI KHOẢN NGƯỜI DÙNG
INSERT INTO `users` (`id`, `name`, `email`, `phone`, `password`, `role`) VALUES
(1, 'Quản trị viên', 'admin@techstore.vn', '0988888888', 'admin', 'admin'),
(2, 'Nguyễn Văn A', 'khachhang@gmail.com', '0912345678', '123', 'user');

-- 2. DANH MỤC SẢN PHẨM
INSERT INTO `categories` (`id`, `name`, `slug`, `icon`, `description`) VALUES
(1, 'Laptop & Máy tính', 'laptop', 'laptop', 'Laptop văn phòng, Gaming, đồ họa cao cấp từ Apple, Dell, Asus, Lenovo, HP'),
(2, 'Điện thoại thông minh', 'smartphone', 'mobile', 'Smartphone flagship, cận cao cấp từ Apple, Samsung, Xiaomi, OPPO'),
(3, 'Máy tính bảng (Tablet)', 'tablet', 'tablet', 'iPad, Galaxy Tab phục vụ học tập, giải trí và sáng tạo nội dung'),
(4, 'Âm thanh & Tai nghe', 'audio', 'headphones', 'Tai nghe True Wireless, chống ồn chủ động, loa Bluetooth Sony, Apple, Marshall, JBL'),
(5, 'Gaming Gear & Phụ kiện', 'gaming-gear', 'gamepad', 'Bàn phím cơ, chuột công thái học, tai nghe gaming Logitech, Razer, Keychron'),
(6, 'Đồng hồ thông minh', 'smartwatch', 'watch', 'Apple Watch, Samsung Galaxy Watch, Garmin theo dõi sức khỏe và thể thao đỉnh cao'),
(7, 'Đồng hồ trẻ em', 'smartwacth-kid', 'wkid', 'Đồng hồ thông minh định vị trẻ em an toàn, gọi video call, chống nước Viettel, Wonlex, Masstel');

-- 3. MÃ GIẢM GIÁ
INSERT INTO `coupons` (`id`, `code`, `discount_percent`, `max_discount`, `min_order_value`, `active`) VALUES
(1, 'TECH10', 10, 500000, 1000000, 1),
(2, 'FREESHIP', 100, 50000, 500000, 1),
(3, 'SUPERTECH', 15, 1000000, 5000000, 1),
(4, 'CHAOBANMOI', 5, 200000, 500000, 1);

-- ==========================================================
-- 4. DANH SÁCH SẢN PHẨM THEO TỪNG DANH MỤC (20 SẢN PHẨM / DANH MỤC)
-- ==========================================================

-- ----------------------------------------------------------
-- 4.1. DANH MỤC 1: LAPTOP & MÁY TÍNH (20 SẢN PHẨM)
-- ----------------------------------------------------------
INSERT INTO `products` (
  `id`, `category_id`, `name`, `slug`, `brand`, 
  `price`, `original_price`, `stock`, `sold_count`, `rating`, `reviews_count`, `featured`, 
  `image_url`, 
  `images`, 
  `short_description`, 
  `specifications`
) VALUES
(
  1, 1, 'MacBook Pro 14 M3 Pro (18GB / 512GB)', 'macbook-pro-14-m3-pro', 'Apple', 48990000, 53990000, 25, 1280, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80"]',
  'Hiệu năng đỉnh cao cùng chip M3 Pro kiến trúc 3nm, màn hình Liquid Retina XDR 120Hz sắc nét bậc nhất.',
  '{"CPU":"Apple M3 Pro 11-core CPU","GPU":"14-core GPU","RAM":"18GB Unified Memory","Ổ cứng":"512GB SSD NVMe","Màn hình":"14.2 inch Liquid Retina XDR 120Hz ProMotion","Pin":"18 giờ","Trọng lượng":"1.61 kg","variants":[{"name":"18GB / 512GB - Xám Không Gian","price":48990000,"original_price":53990000,"stock":15,"image":"https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80"},{"name":"36GB / 1TB - Bạc Ánh Sao","price":59990000,"original_price":64990000,"stock":10,"image":"https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80"]}'
),
(
  2, 1, 'MacBook Pro 16 M3 Max (36GB / 1TB)', 'macbook-pro-16-m3-max', 'Apple', 87990000, 94990000, 12, 119, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80"]',
  'Quái vật đồ họa với chip M3 Max 14-core CPU, 30-core GPU, màn hình 16.2 inch XDR 120Hz đỉnh cao cho chuyên gia render.',
  '{"CPU":"Apple M3 Max 14-core CPU","GPU":"30-core GPU","RAM":"36GB Unified Memory","Ổ cứng":"1TB SSD NVMe","Màn hình":"16.2 inch Liquid Retina XDR 120Hz","Pin":"22 giờ","Trọng lượng":"2.16 kg","variants":[{"name":"36GB / 1TB - Đen Không Gian","price":87990000,"original_price":94990000,"stock":8,"image":"https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?auto=format&fit=crop&w=800&q=80"},{"name":"48GB / 1TB - Bạc","price":99990000,"original_price":108990000,"stock":4,"image":"https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80"]}'
),
(
  3, 1, 'MacBook Air 13 M3 (16GB / 512GB)', 'macbook-air-13-m3', 'Apple', 31990000, 34990000, 35, 710, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80"]',
  'Siêu mỏng nhẹ chỉ 1.24kg, thời lượng pin 18 giờ liên tục, hỗ trợ xuất 2 màn hình ngoài cùng chip M3 thế hệ mới.',
  '{"CPU":"Apple M3 8-core CPU","GPU":"10-core GPU","RAM":"16GB Unified Memory","Ổ cứng":"512GB SSD NVMe","Màn hình":"13.6 inch Liquid Retina","Pin":"18 giờ","Trọng lượng":"1.24 kg","variants":[{"name":"16GB / 512GB - Xanh Đen Midnight","price":31990000,"original_price":34990000,"stock":20,"image":"https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80"},{"name":"16GB / 512GB - Vàng Ánh Kim Starlight","price":31990000,"original_price":34990000,"stock":15,"image":"https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80"]}'
),
(
  4, 1, 'MacBook Air 15 M3 (16GB / 512GB)', 'macbook-air-15-m3', 'Apple', 36990000, 39990000, 28, 193, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?auto=format&fit=crop&w=800&q=80"]',
  'Không gian hiển thị rộng rãi 15.3 inch Liquid Retina trong thân hình siêu mỏng 11.5mm với âm thanh 6 loa vòm Spatial Audio.',
  '{"CPU":"Apple M3 8-core CPU","GPU":"10-core GPU","RAM":"16GB Unified Memory","Ổ cứng":"512GB SSD NVMe","Màn hình":"15.3 inch Liquid Retina 500 nits","Pin":"18 giờ","Trọng lượng":"1.51 kg","variants":[{"name":"16GB / 512GB - Xám Bạc","price":36990000,"original_price":39990000,"stock":18,"image":"https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80"},{"name":"24GB / 512GB - Midnight","price":42990000,"original_price":45990000,"stock":10,"image":"https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?auto=format&fit=crop&w=800&q=80"]}'
),
(
  5, 1, 'Asus ROG Zephyrus G16 OLED (Intel Core Ultra 9 / RTX 4070)', 'asus-rog-zephyrus-g16', 'Asus', 61990000, 66990000, 18, 230, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80"]',
  'Laptop gaming mỏng nhẹ cao cấp khung nhôm CNC, màn hình ROG Nebula OLED 2.5K 240Hz đạt chuẩn màu đồ họa 100% DCI-P3.',
  '{"CPU":"Intel Core Ultra 9 185H","GPU":"NVIDIA GeForce RTX 4070 8GB GDDR6","RAM":"32GB LPDDR5X 7467MHz","Ổ cứng":"1TB SSD PCIe 4.0 NVMe","Màn hình":"16 inch ROG Nebula OLED 2.5K 240Hz 0.2ms","Pin":"90WHrs","Trọng lượng":"1.85 kg","variants":[{"name":"Ultra 9 / 32GB RAM / RTX 4070 - Xám Eclipse","price":61990000,"original_price":66990000,"stock":12,"image":"https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80"},{"name":"Ultra 9 / 32GB RAM / RTX 4080 - Trắng Platinum","price":74990000,"original_price":79990000,"stock":6,"image":"https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80"]}'
),
(
  6, 1, 'Asus TUF Gaming A15 (AMD Ryzen 7 7735HS / RTX 4060)', 'asus-tuf-gaming-a15', 'Asus', 27990000, 31990000, 30, 267, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80"]',
  'Độ bền chuẩn quân đội MIL-STD-810H, bàn phím RGB 1 vùng, tản nhiệt Arc Flow Fans kép tối ưu cho game thủ cày cuốc.',
  '{"CPU":"AMD Ryzen 7 7735HS 8 nhân 16 luồng","GPU":"NVIDIA GeForce RTX 4060 8GB GDDR6","RAM":"16GB DDR5 4800MHz","Ổ cứng":"512GB SSD NVMe","Màn hình":"15.6 inch FHD 144Hz 100% sRGB","Pin":"90Wh","Trọng lượng":"2.2 kg","variants":[{"name":"16GB / 512GB - Jaeger Gray","price":27990000,"original_price":31990000,"stock":20,"image":"https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80"},{"name":"32GB / 1TB - Jaeger Gray","price":31990000,"original_price":35990000,"stock":10,"image":"https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80"]}'
),
(
  7, 1, 'Asus Zenbook 14 OLED (Intel Core Ultra 7 155H)', 'asus-zenbook-14-oled', 'Asus', 32990000, 35990000, 22, 304, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1585060544812-6b45742d762f?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1585060544812-6b45742d762f?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=80"]',
  'Trọng lượng chỉ 1.2kg, màn hình Lumina OLED 3K 120Hz siêu nét, tích hợp NPU Intel AI Boost tăng tốc xử lý tác vụ thông minh.',
  '{"CPU":"Intel Core Ultra 7 155H","GPU":"Intel Arc Graphics","RAM":"32GB LPDDR5X","Ổ cứng":"1TB SSD NVMe","Màn hình":"14 inch 3K OLED 120Hz 100% DCI-P3","Pin":"75Wh","Trọng lượng":"1.2 kg","variants":[{"name":"Ultra 7 / 32GB / 1TB - Xanh Ponder","price":32990000,"original_price":35990000,"stock":15,"image":"https://images.unsplash.com/photo-1585060544812-6b45742d762f?auto=format&fit=crop&w=800&q=80"},{"name":"Ultra 5 / 16GB / 512GB - Xám Foggy","price":26990000,"original_price":29990000,"stock":7,"image":"https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1585060544812-6b45742d762f?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=80"]}'
),
(
  8, 1, 'Dell XPS 13 9340 (Intel Core Ultra 7 / 16GB / 512GB)', 'dell-xps-13-9340', 'Dell', 41500000, 44990000, 18, 341, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=80"]',
  'Thiết kế tương lai tối giản với thanh cảm ứng điện dung, touchpad tàng hình kính liền mạch và viền màn hình siêu mỏng InfinityEdge.',
  '{"CPU":"Intel Core Ultra 7 155H","GPU":"Intel Arc Graphics","RAM":"16GB LPDDR5x 7467MHz","Ổ cứng":"512GB PCIe 4.0 SSD","Màn hình":"13.4 inch FHD+ InfinityEdge 120Hz","Pin":"55Wh","Trọng lượng":"1.19 kg","variants":[{"name":"Ultra 7 / 16GB RAM / 512GB SSD - Platinum","price":41500000,"original_price":44990000,"stock":12,"image":"https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80"},{"name":"Ultra 7 / 32GB RAM / 1TB SSD - Graphite","price":49990000,"original_price":54990000,"stock":6,"image":"https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=80"]}'
),
(
  9, 1, 'Dell XPS 16 9640 (Intel Core Ultra 9 / RTX 4070)', 'dell-xps-16-9640', 'Dell', 79990000, 85990000, 10, 378, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1531297484001-80022131f5a1?auto=format&fit=crop&w=800&q=80"]',
  'Đỉnh cao máy trạm mỏng nhẹ di động, màn hình cảm ứng 16.3 inch 4K+ OLED, vỏ nhôm CNC nguyên khối kết hợp kính cường lực Gorilla Glass 3.',
  '{"CPU":"Intel Core Ultra 9 185H","GPU":"NVIDIA GeForce RTX 4070 8GB GDDR6","RAM":"32GB LPDDR5x","Ổ cứng":"1TB SSD NVMe","Màn hình":"16.3 inch 4K+ OLED Touch 90Hz","Pin":"99.5Wh","Trọng lượng":"2.13 kg","variants":[{"name":"Ultra 9 / 32GB / 1TB - Platinum","price":79990000,"original_price":85990000,"stock":6,"image":"https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80"},{"name":"Ultra 9 / 64GB / 2TB - Graphite","price":92990000,"original_price":99990000,"stock":4,"image":"https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1531297484001-80022131f5a1?auto=format&fit=crop&w=800&q=80"]}'
),
(
  10, 1, 'Dell Inspiron 14 Plus (Intel Core Ultra 7 / RTX 4050)', 'dell-inspiron-14-plus', 'Dell', 29990000, 33990000, 25, 65, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1585060544812-6b45742d762f?auto=format&fit=crop&w=800&q=80"]',
  'Sự cân bằng hoàn hảo giữa đồ họa rời mạnh mẽ và thiết kế thanh lịch, trang bị màn hình 2.2K chống chói ComfortView Plus.',
  '{"CPU":"Intel Core Ultra 7 155H","GPU":"NVIDIA GeForce RTX 4050 6GB GDDR6","RAM":"16GB LPDDR5x","Ổ cứng":"1TB SSD NVMe","Màn hình":"14.0 inch 2.2K 16:10 300 nits","Pin":"64Wh","Trọng lượng":"1.6 kg","variants":[{"name":"16GB / 1TB / RTX 4050 - Xanh Ice Blue","price":29990000,"original_price":33990000,"stock":25,"image":"https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1585060544812-6b45742d762f?auto=format&fit=crop&w=800&q=80"]}'
),
(
  11, 1, 'Lenovo Legion Pro 7i (Intel Core i9-14900HX / RTX 4080)', 'lenovo-legion-pro-7i', 'Lenovo', 72990000, 78990000, 14, 102, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1531297484001-80022131f5a1?auto=format&fit=crop&w=800&q=80"]',
  'Hệ thống tản nhiệt buồng hơi Legion Coldfront Vapor, chip AI chuyên dụng Lenovo LA-2Q tối ưu hóa FPS trong từng khung hình game.',
  '{"CPU":"Intel Core i9-14900HX 24 nhân 32 luồng","GPU":"NVIDIA GeForce RTX 4080 12GB GDDR6","RAM":"32GB DDR5 5600MHz","Ổ cứng":"1TB SSD NVMe Gen 4","Màn hình":"16 inch WQXGA 240Hz 500 nits HDR 400","Pin":"99.9Wh","Trọng lượng":"2.6 kg","variants":[{"name":"i9 / 32GB RAM / RTX 4080 - Onyx Grey","price":72990000,"original_price":78990000,"stock":9,"image":"https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80"},{"name":"i9 / 64GB RAM / RTX 4090 - Onyx Grey","price":89990000,"original_price":95990000,"stock":5,"image":"https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1531297484001-80022131f5a1?auto=format&fit=crop&w=800&q=80"]}'
),
(
  12, 1, 'Lenovo ThinkPad X1 Carbon Gen 12 (Ultra 7 155U)', 'lenovo-thinkpad-x1-carbon-gen-12', 'Lenovo', 54990000, 59990000, 16, 139, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80"]',
  'Biểu tượng doanh nhân đỉnh cao với bàn phím huyền thoại, vỏ sợi carbon tái chế siêu nhẹ 1.09kg, đạt tiêu chuẩn bảo mật doanh nghiệp Intel vPro.',
  '{"CPU":"Intel Core Ultra 7 155U","GPU":"Intel Graphics","RAM":"32GB LPDDR5X","Ổ cứng":"1TB SSD NVMe","Màn hình":"14 inch 2.8K OLED 120Hz chống chói","Pin":"57Wh","Trọng lượng":"1.09 kg","variants":[{"name":"Ultra 7 / 32GB / 1TB - Deep Black","price":54990000,"original_price":59990000,"stock":16,"image":"https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80"]}'
),
(
  13, 1, 'Lenovo Yoga Slim 7x Copilot+ (Snapdragon X Elite)', 'lenovo-yoga-slim-7x', 'Lenovo', 34990000, 37990000, 20, 176, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1585060544812-6b45742d762f?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1585060544812-6b45742d762f?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1531297484001-80022131f5a1?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=80"]',
  'Kỷ nguyên AI PC với vi xử lý Snapdragon X Elite 45 TOPS NPU, thời lượng pin ấn tượng lên tới 24 giờ cùng màn hình PureSight OLED 3K 90Hz.',
  '{"CPU":"Qualcomm Snapdragon X Elite X1E-78-100","GPU":"Qualcomm Adreno GPU","RAM":"16GB LPDDR5X 8448MHz","Ổ cứng":"512GB SSD NVMe","Màn hình":"14.5 inch 3K OLED 90Hz 1000 nits HDR","Pin":"70Wh","Trọng lượng":"1.28 kg","variants":[{"name":"16GB / 512GB - Xanh Cosmic Blue","price":34990000,"original_price":37990000,"stock":12,"image":"https://images.unsplash.com/photo-1585060544812-6b45742d762f?auto=format&fit=crop&w=800&q=80"},{"name":"32GB / 1TB - Xanh Cosmic Blue","price":39990000,"original_price":43990000,"stock":8,"image":"https://images.unsplash.com/photo-1531297484001-80022131f5a1?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1585060544812-6b45742d762f?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1531297484001-80022131f5a1?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=80"]}'
),
(
  14, 1, 'HP Spectre x360 14 (Intel Core Ultra 7 155H)', 'hp-spectre-x360-14', 'HP', 39990000, 43990000, 17, 213, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80"]',
  'Laptop 2-in-1 xoay gập 360 độ hoàn mỹ, camera AI 9MP góc rộng tự động canh chỉnh khuôn mặt, bút cảm ứng HP Rechargeable MPP2.0 Tilt Pen đi kèm.',
  '{"CPU":"Intel Core Ultra 7 155H","GPU":"Intel Arc Graphics","RAM":"16GB LPDDR5X","Ổ cứng":"1TB SSD NVMe","Màn hình":"14 inch 2.8K OLED Touch 120Hz","Pin":"68Wh","Trọng lượng":"1.44 kg","variants":[{"name":"16GB / 1TB - Xanh Đêm Nightfall Black","price":39990000,"original_price":43990000,"stock":10,"image":"https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80"},{"name":"32GB / 1TB - Bạc Slate Blue","price":44990000,"original_price":48990000,"stock":7,"image":"https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80"]}'
),
(
  15, 1, 'HP Omen Transcend 14 (Intel Core Ultra 7 / RTX 4060)', 'hp-omen-transcend-14', 'HP', 44990000, 48990000, 15, 250, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80"]',
  'Laptop gaming 14 inch mỏng nhẹ nhất thế giới từ HP, màn hình OLED 2.8K 120Hz, bàn phím RGB pudding tỏa sáng lung linh.',
  '{"CPU":"Intel Core Ultra 7 155H","GPU":"NVIDIA GeForce RTX 4060 8GB GDDR6","RAM":"16GB LPDDR5X","Ổ cứng":"1TB SSD NVMe","Màn hình":"14 inch 2.8K OLED 120Hz 0.2ms","Pin":"71Wh","Trọng lượng":"1.63 kg","variants":[{"name":"16GB / 1TB - Trắng Ceramic White","price":44990000,"original_price":48990000,"stock":8,"image":"https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80"},{"name":"32GB / 1TB - Đen Shadow Black","price":49990000,"original_price":53990000,"stock":7,"image":"https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80"]}'
),
(
  16, 1, 'Acer Predator Helios 16 (Intel Core i9-14900HX / RTX 4070)', 'acer-predator-helios-16', 'Acer', 54990000, 59990000, 19, 287, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1531297484001-80022131f5a1?auto=format&fit=crop&w=800&q=80"]',
  'Công nghệ quạt tản nhiệt kim loại 3D AeroBlade thế hệ thứ 5, keo tản nhiệt kim loại lỏng Liquid Metal tối đa hiệu năng ép xung.',
  '{"CPU":"Intel Core i9-14900HX","GPU":"NVIDIA GeForce RTX 4070 8GB GDDR6","RAM":"32GB DDR5 5600MHz","Ổ cứng":"1TB SSD NVMe","Màn hình":"16 inch WQXGA Mini LED 250Hz 1000 nits","Pin":"90Wh","Trọng lượng":"2.6 kg","variants":[{"name":"32GB / 1TB / RTX 4070 - Đen Abyssal Black","price":54990000,"original_price":59990000,"stock":19,"image":"https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1531297484001-80022131f5a1?auto=format&fit=crop&w=800&q=80"]}'
),
(
  17, 1, 'Acer Swift Go 14 OLED (Intel Core Ultra 7 155H)', 'acer-swift-go-14-oled', 'Acer', 23990000, 26990000, 27, 324, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1585060544812-6b45742d762f?auto=format&fit=crop&w=800&q=80"]',
  'Giá thành dễ tiếp cận nhất phân khúc AI PC, màn hình 2.8K OLED 90Hz rực rỡ, thời lượng pin bền bỉ trong thiết kế nhôm nguyên khối.',
  '{"CPU":"Intel Core Ultra 7 155H","GPU":"Intel Arc Graphics","RAM":"16GB LPDDR5X","Ổ cứng":"512GB SSD NVMe","Màn hình":"14 inch 2.8K OLED 90Hz 100% DCI-P3","Pin":"65Wh","Trọng lượng":"1.32 kg","variants":[{"name":"16GB / 512GB - Bạc Pure Silver","price":23990000,"original_price":26990000,"stock":17,"image":"https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80"},{"name":"16GB / 1TB - Bạc Pure Silver","price":25990000,"original_price":28990000,"stock":10,"image":"https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1585060544812-6b45742d762f?auto=format&fit=crop&w=800&q=80"]}'
),
(
  18, 1, 'MSI Raider GE78 HX (Intel Core i9-14900HX / RTX 4080)', 'msi-raider-ge78-hx', 'MSI', 79990000, 86990000, 11, 361, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1531297484001-80022131f5a1?auto=format&fit=crop&w=800&q=80"]',
  'Dải đèn ma trận ánh sáng Matrix Light Bar cực chất, hệ thống âm thanh 6 loa Dynaudio và màn hình 17 inch QHD+ 240Hz siêu mượt.',
  '{"CPU":"Intel Core i9-14900HX","GPU":"NVIDIA GeForce RTX 4080 12GB GDDR6","RAM":"32GB DDR5","Ổ cứng":"2TB SSD NVMe PCIe Gen 5","Màn hình":"17 inch QHD+ 240Hz 100% DCI-P3","Pin":"99.9Wh","Trọng lượng":"3.1 kg","variants":[{"name":"32GB / 2TB / RTX 4080 - Đen Core Black","price":79990000,"original_price":86990000,"stock":11,"image":"https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1531297484001-80022131f5a1?auto=format&fit=crop&w=800&q=80"]}'
),
(
  19, 1, 'LG Gram 17 SuperSlim (Intel Core Ultra 7 155H)', 'lg-gram-17-superslim', 'LG', 42990000, 46990000, 16, 48, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80"]',
  'Kỷ lục mỏng nhẹ cho màn hình 17 inch với trọng lượng chỉ 1.35kg, màn hình WQXGA IPS chống lóa cùng pin 77Wh cho ngày dài năng động.',
  '{"CPU":"Intel Core Ultra 7 155H","GPU":"Intel Arc Graphics","RAM":"16GB LPDDR5X","Ổ cứng":"512GB SSD NVMe","Màn hình":"17.0 inch WQXGA (2560x1600) IPS 99% DCI-P3","Pin":"77Wh","Trọng lượng":"1.35 kg","variants":[{"name":"16GB / 512GB - Đen Than Charcoal","price":42990000,"original_price":46990000,"stock":10,"image":"https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80"},{"name":"32GB / 1TB - Đen Than Charcoal","price":48990000,"original_price":52990000,"stock":6,"image":"https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80"]}'
),
(
  20, 1, 'Microsoft Surface Laptop 7 Copilot+ (Snapdragon X Elite)', 'surface-laptop-7', 'Microsoft', 35990000, 38990000, 20, 85, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80"]',
  'Thiết kế nhôm Anodized tinh xảo, viền màn hình PixelSense Flow cảm ứng 120Hz mỏng thanh thoát, tối ưu hóa phần mềm Windows 11 AI.',
  '{"CPU":"Qualcomm Snapdragon X Elite 12-core","GPU":"Adreno GPU","RAM":"16GB LPDDR5X","Ổ cứng":"512GB Gen 4 SSD","Màn hình":"13.8 inch PixelSense Touch 120Hz Dolby Vision","Pin":"20 giờ","Trọng lượng":"1.34 kg","variants":[{"name":"16GB / 512GB - Bạch Kim Platinum","price":35990000,"original_price":38990000,"stock":12,"image":"https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=80"},{"name":"32GB / 1TB - Đen Mờ Black","price":46990000,"original_price":49990000,"stock":8,"image":"https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80"]}'
);

-- ----------------------------------------------------------
-- 4.2. DANH MỤC 2: ĐIỆN THOẠI THÔNG MINH (20 SẢN PHẨM)
-- ----------------------------------------------------------
INSERT INTO `products` (
  `id`, `category_id`, `name`, `slug`, `brand`, 
  `price`, `original_price`, `stock`, `sold_count`, `rating`, `reviews_count`, `featured`, 
  `image_url`, 
  `images`, 
  `short_description`, 
  `specifications`
) VALUES
(
  21, 2, 'iPhone 16 Pro Max 256GB Titan Sa Mạc', 'iphone-16-pro-max-256gb', 'Apple', 34990000, 37990000, 50, 1520, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1565849904461-04a58ad377e0?auto=format&fit=crop&w=800&q=80"]',
  'Nút Điều khiển Camera (Camera Control) mới, chip Apple A18 Pro 3nm mạnh nhất thế giới cùng viền màn hình mỏng nhất lịch sử Apple.',
  '{"Màn hình":"6.9 inch Super Retina XDR OLED 120Hz ProMotion","Chip":"Apple A18 Pro (3nm)","RAM":"8GB","Bộ nhớ trong":"256GB","Camera sau":"Chính 48MP Fusion, Siêu rộng 48MP, Tele 5x 12MP","Pin":"4685 mAh, Sạc nhanh MagSafe 25W","variants":[{"name":"256GB - Titan Sa Mạc (Desert Titanium)","price":34990000,"original_price":37990000,"stock":25,"image":"https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=800&q=80"},{"name":"512GB - Titan Tự Nhiên","price":40990000,"original_price":43990000,"stock":15,"image":"https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=800&q=80"},{"name":"1TB - Titan Đen","price":46990000,"original_price":49990000,"stock":10,"image":"https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1565849904461-04a58ad377e0?auto=format&fit=crop&w=800&q=80"]}'
),
(
  22, 2, 'iPhone 16 Pro 128GB Titan Tự Nhiên', 'iphone-16-pro-128gb', 'Apple', 28990000, 31990000, 40, 159, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1565849904461-04a58ad377e0?auto=format&fit=crop&w=800&q=80"]',
  'Kích thước nhỏ gọn 6.3 inch trong lòng bàn tay, ống kính tele zoom quang 5x kế thừa từ Pro Max, quay video 4K 120fps Dolby Vision.',
  '{"Màn hình":"6.3 inch Super Retina XDR OLED 120Hz ProMotion","Chip":"Apple A18 Pro","RAM":"8GB","Bộ nhớ trong":"128GB","Camera sau":"48MP + 48MP + 12MP (Zoom 5x)","Pin":"3582 mAh","variants":[{"name":"128GB - Titan Tự Nhiên","price":28990000,"original_price":31990000,"stock":20,"image":"https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=800&q=80"},{"name":"256GB - Titan Trắng","price":31990000,"original_price":34990000,"stock":20,"image":"https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1565849904461-04a58ad377e0?auto=format&fit=crop&w=800&q=80"]}'
),
(
  23, 2, 'iPhone 16 Plus 128GB Xanh Mòng Két', 'iphone-16-plus-128gb', 'Apple', 25990000, 27990000, 30, 196, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1565849904461-04a58ad377e0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=800&q=80"]',
  'Pin bền bỉ vượt trội, màn hình lớn 6.7 inch, chip Apple A18 hỗ trợ hệ sinh thái trí tuệ nhân tạo Apple Intelligence toàn diện.',
  '{"Màn hình":"6.7 inch Super Retina XDR OLED","Chip":"Apple A18","RAM":"8GB","Bộ nhớ trong":"128GB","Camera sau":"Chính 48MP 2-in-1, Siêu rộng 12MP Macro","Pin":"4674 mAh","variants":[{"name":"128GB - Xanh Mòng Két (Teal)","price":25990000,"original_price":27990000,"stock":15,"image":"https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=800&q=80"},{"name":"256GB - Hồng (Pink)","price":28990000,"original_price":30990000,"stock":15,"image":"https://images.unsplash.com/photo-1565849904461-04a58ad377e0?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1565849904461-04a58ad377e0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=800&q=80"]}'
),
(
  24, 2, 'iPhone 15 Pro Max 256GB Titan Tự Nhiên', 'iphone-15-pro-max-256gb', 'Apple', 29490000, 34990000, 45, 233, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=800&q=80"]',
  'Khung viền Titan chuẩn hàng không vũ trụ siêu nhẹ, chip A17 Pro mạnh mẽ cùng camera tiềm vọng zoom quang 5x sắc nét.',
  '{"Màn hình":"6.7 inch Super Retina XDR OLED 120Hz ProMotion","Chip":"Apple A17 Pro (3nm)","RAM":"8GB","Bộ nhớ trong":"256GB","Camera sau":"Chính 48MP, Siêu rộng 12MP, Tele 5x 12MP","Pin":"4422 mAh, Sạc nhanh Type-C","variants":[{"name":"256GB - Titan Tự Nhiên","price":29490000,"original_price":34990000,"stock":25,"image":"https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=800&q=80"},{"name":"512GB - Titan Xanh","price":34990000,"original_price":39990000,"stock":20,"image":"https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=800&q=80"]}'
),
(
  25, 2, 'iPhone 15 128GB Hồng Pastel', 'iphone-15-128gb', 'Apple', 19490000, 22990000, 50, 270, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1565849904461-04a58ad377e0?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1565849904461-04a58ad377e0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=800&q=80"]',
  'Mặt lưng kính pha màu nhám sang trọng, cổng sạc chuẩn USB-C quốc dân và tính năng Dynamic Island linh hoạt.',
  '{"Màn hình":"6.1 inch Super Retina XDR OLED 2000 nits","Chip":"Apple A16 Bionic","RAM":"6GB","Bộ nhớ trong":"128GB","Camera sau":"Chính 48MP, Siêu rộng 12MP","Pin":"3349 mAh","variants":[{"name":"128GB - Hồng Pastel","price":19490000,"original_price":22990000,"stock":25,"image":"https://images.unsplash.com/photo-1565849904461-04a58ad377e0?auto=format&fit=crop&w=800&q=80"},{"name":"128GB - Xanh Dương Nhạt","price":19490000,"original_price":22990000,"stock":25,"image":"https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1565849904461-04a58ad377e0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=800&q=80"]}'
),
(
  26, 2, 'Samsung Galaxy S24 Ultra 5G (12GB / 256GB)', 'samsung-galaxy-s24-ultra', 'Samsung', 26990000, 31990000, 38, 1150, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80"]',
  'Quyền năng Galaxy AI tiên phong, màn hình phẳng chống chói Gorilla Armor đỉnh nhất, kèm bút S-Pen quyền năng bên trong thân máy.',
  '{"Màn hình":"6.8 inch Dynamic AMOLED 2X QHD+ 120Hz (2600 nits)","Chip":"Snapdragon 8 Gen 3 for Galaxy","RAM":"12GB","Bộ nhớ trong":"256GB","Camera":"200MP + 50MP (5x) + 12MP + 10MP","Pin":"5000 mAh, Sạc nhanh 45W","variants":[{"name":"12GB / 256GB - Xám Titan","price":26990000,"original_price":31990000,"stock":20,"image":"https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80"},{"name":"12GB / 512GB - Đen Titan","price":30990000,"original_price":35990000,"stock":18,"image":"https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80"]}'
),
(
  27, 2, 'Samsung Galaxy S24 Plus 5G (12GB / 256GB)', 'samsung-galaxy-s24-plus', 'Samsung', 21990000, 25990000, 32, 344, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80"]',
  'Màn hình nâng cấp độ phân giải 2K+ siêu nét, viền hợp kim Armor Aluminum cứng cáp cùng viên pin khủng 4900mAh.',
  '{"Màn hình":"6.7 inch Dynamic AMOLED 2X QHD+ 120Hz","Chip":"Exynos 2400 Deca-Core","RAM":"12GB","Bộ nhớ trong":"256GB","Camera":"50MP + 12MP + 10MP (Zoom 3x)","Pin":"4900 mAh, Sạc nhanh 45W","variants":[{"name":"12GB / 256GB - Tím Cobalt","price":21990000,"original_price":25990000,"stock":18,"image":"https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80"},{"name":"12GB / 512GB - Vàng Amber","price":24990000,"original_price":28990000,"stock":14,"image":"https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80"]}'
),
(
  28, 2, 'Samsung Galaxy S24 5G (8GB / 256GB)', 'samsung-galaxy-s24', 'Samsung', 17990000, 21990000, 35, 381, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80"]',
  'Thiết kế nhỏ gọn 6.2 inch cực kỳ tinh tế, trang bị trọn bộ trợ lý thông minh Galaxy AI dịch cuộc gọi trực tiếp thời gian thực.',
  '{"Màn hình":"6.2 inch Dynamic AMOLED 2X FHD+ 120Hz","Chip":"Exynos 2400","RAM":"8GB","Bộ nhớ trong":"256GB","Camera":"50MP + 12MP + 10MP","Pin":"4000 mAh","variants":[{"name":"8GB / 256GB - Đen Onyx","price":17990000,"original_price":21990000,"stock":20,"image":"https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80"},{"name":"8GB / 256GB - Xám Marble","price":17990000,"original_price":21990000,"stock":15,"image":"https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80"]}'
),
(
  29, 2, 'Samsung Galaxy Z Fold5 5G (12GB / 256GB)', 'samsung-galaxy-z-fold5', 'Samsung', 29990000, 40990000, 20, 68, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80"]',
  'Bản lề Flex kép gập không khe hở, mở rộng không gian đa nhiệm 7.6 inch như máy tính bảng cá nhân bỏ vừa túi quần.',
  '{"Màn hình trong":"7.6 inch Dynamic AMOLED 2X 120Hz","Màn hình ngoài":"6.2 inch","Chip":"Snapdragon 8 Gen 2 for Galaxy","RAM":"12GB","Bộ nhớ trong":"256GB","Pin":"4400 mAh, Chống nước IPX8","variants":[{"name":"12GB / 256GB - Xanh Icy Blue","price":29990000,"original_price":40990000,"stock":12,"image":"https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80"},{"name":"12GB / 512GB - Đen Phantom","price":33990000,"original_price":44990000,"stock":8,"image":"https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80"]}'
),
(
  30, 2, 'Samsung Galaxy Z Flip5 5G (8GB / 256GB)', 'samsung-galaxy-z-flip5', 'Samsung', 16990000, 25990000, 28, 105, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1533228876829-65c94e7b5025?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80"]',
  'Màn hình ngoài Flex Window 3.4 inch độc đáo trả lời tin nhắn xem youtube không cần mở máy, thiết kế gập hộp phấn thời thượng.',
  '{"Màn hình chính":"6.7 inch Dynamic AMOLED 2X 120Hz","Màn hình ngoài":"3.4 inch Super AMOLED","Chip":"Snapdragon 8 Gen 2 for Galaxy","RAM":"8GB","Bộ nhớ trong":"256GB","Pin":"3700 mAh","variants":[{"name":"8GB / 256GB - Xanh Mint","price":16990000,"original_price":25990000,"stock":18,"image":"https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80"},{"name":"8GB / 512GB - Tím Lavender","price":19990000,"original_price":28990000,"stock":10,"image":"https://images.unsplash.com/photo-1533228876829-65c94e7b5025?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1533228876829-65c94e7b5025?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80"]}'
),
(
  31, 2, 'Samsung Galaxy A55 5G (8GB / 128GB)', 'samsung-galaxy-a55-5g', 'Samsung', 9490000, 10490000, 60, 142, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80"]',
  'Khung viền kim loại lần đầu xuất hiện trên dòng A, bảo mật phần cứng chuẩn quân đội Samsung Knox Vault và kháng nước IP67.',
  '{"Màn hình":"6.6 inch Super AMOLED 120Hz Vision Booster","Chip":"Exynos 1480 GPU AMD RDNA2","RAM":"8GB","Bộ nhớ trong":"128GB","Camera":"50MP OIS + 12MP + 5MP","Pin":"5000 mAh","variants":[{"name":"8GB / 128GB - Xanh Iceblue","price":9490000,"original_price":10490000,"stock":35,"image":"https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80"},{"name":"8GB / 256GB - Xanh Navy","price":10490000,"original_price":11490000,"stock":25,"image":"https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80"]}'
),
(
  32, 2, 'Xiaomi 14 Ultra (16GB / 512GB) Ống kính Leica', 'xiaomi-14-ultra-5g', 'Xiaomi', 27990000, 32990000, 22, 179, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80"]',
  'Cụm 4 camera Leica 50MP cảm biến 1-inch biến thiên khẩu độ f/1.63 - f/4.0 vô cấp, mang lại trải nghiệm nhiếp ảnh chuyên nghiệp.',
  '{"Màn hình":"6.73 inch LTPO AMOLED WQHD+ 120Hz (3000 nits)","Chip":"Snapdragon 8 Gen 3","RAM":"16GB","Bộ nhớ trong":"512GB UFS 4.0","Camera":"Quad 50MP Leica Vario-Summilux","Pin":"5000 mAh, Sạc siêu nhanh 90W","variants":[{"name":"16GB / 512GB - Da Sinh Học Đen","price":27990000,"original_price":32990000,"stock":12,"image":"https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80"},{"name":"16GB / 512GB - Da Sinh Học Trắng","price":27990000,"original_price":32990000,"stock":10,"image":"https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80"]}'
),
(
  33, 2, 'Xiaomi 14 5G (12GB / 256GB)', 'xiaomi-14-5g', 'Xiaomi', 18990000, 22990000, 30, 216, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80"]',
  'Flagship kích thước vàng 6.36 inch viền siêu mỏng 1.61mm, sạc có dây 90W sạc đầy 100% pin chỉ trong 31 phút.',
  '{"Màn hình":"6.36 inch LTPO OLED 120Hz 3000 nits","Chip":"Snapdragon 8 Gen 3","RAM":"12GB","Bộ nhớ trong":"256GB","Camera":"Triple 50MP Leica","Pin":"4610 mAh, Sạc nhanh 90W","variants":[{"name":"12GB / 256GB - Xanh Ngọc Bích","price":18990000,"original_price":22990000,"stock":18,"image":"https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80"},{"name":"12GB / 512GB - Đen Cổ Điển","price":21490000,"original_price":24990000,"stock":12,"image":"https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80"]}'
),
(
  34, 2, 'Xiaomi 13T Pro 5G (12GB / 512GB)', 'xiaomi-13t-pro-5g', 'Xiaomi', 14490000, 16990000, 26, 253, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1533228876829-65c94e7b5025?auto=format&fit=crop&w=800&q=80"]',
  'Kháng nước chuẩn IP68, sạc siêu tốc HyperCharge 120W và cụm camera ống kính Leica đẳng cấp trong tầm giá cận cao cấp.',
  '{"Màn hình":"6.67 inch CrystalRes AMOLED 144Hz","Chip":"MediaTek Dimensity 9200+","RAM":"12GB","Bộ nhớ trong":"512GB","Camera":"50MP Leica + 50MP Tele + 12MP","Pin":"5000 mAh, Sạc 120W","variants":[{"name":"12GB / 512GB - Xanh Đồng Cỏ Alpine Blue","price":14490000,"original_price":16990000,"stock":26,"image":"https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1533228876829-65c94e7b5025?auto=format&fit=crop&w=800&q=80"]}'
),
(
  35, 2, 'Redmi Note 13 Pro+ 5G (8GB / 256GB)', 'redmi-note-13-pro-plus', 'Xiaomi', 9990000, 10990000, 45, 290, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1533228876829-65c94e7b5025?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80"]',
  'Màn hình cong tràn cạnh AMOLED 1.5K 120Hz, camera siêu nét 200MP chống rung OIS và chuẩn kháng bụi nước IP68 bền bỉ.',
  '{"Màn hình":"6.67 inch Curved AMOLED 120Hz","Chip":"MediaTek Dimensity 7200-Ultra","RAM":"8GB","Bộ nhớ trong":"256GB","Camera":"200MP Samsung ISOCELL HP3","Pin":"5000 mAh, Sạc 120W","variants":[{"name":"8GB / 256GB - Tím Cực Quang","price":9990000,"original_price":10990000,"stock":25,"image":"https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80"},{"name":"12GB / 512GB - Đen Huyền Bí","price":11490000,"original_price":12490000,"stock":20,"image":"https://images.unsplash.com/photo-1533228876829-65c94e7b5025?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1533228876829-65c94e7b5025?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80"]}'
),
(
  36, 2, 'OPPO Find X7 Ultra (16GB / 512GB)', 'oppo-find-x7-ultra', 'OPPO', 25990000, 29990000, 18, 327, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1533228876829-65c94e7b5025?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1533228876829-65c94e7b5025?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80"]',
  'Smartphone đầu tiên trên thế giới trang bị cụm 2 camera tele tiềm vọng cảm biến lớn phối hợp tinh chỉnh màu sắc Hasselblad.',
  '{"Màn hình":"6.82 inch LTPO AMOLED 120Hz 4500 nits","Chip":"Snapdragon 8 Gen 3","RAM":"16GB","Bộ nhớ trong":"512GB","Camera":"Quad 50MP Hasselblad Dual Periscope","Pin":"5000 mAh, Sạc 100W","variants":[{"name":"16GB / 512GB - Nâu Da Đại Dương","price":25990000,"original_price":29990000,"stock":18,"image":"https://images.unsplash.com/photo-1533228876829-65c94e7b5025?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1533228876829-65c94e7b5025?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80"]}'
),
(
  37, 2, 'OPPO Reno11 Pro 5G (12GB / 512GB)', 'oppo-reno11-pro-5g', 'OPPO', 14990000, 16990000, 32, 364, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1567581935884-3349723552ca?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1567581935884-3349723552ca?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1533228876829-65c94e7b5025?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80"]',
  'Chuyên gia chân dung với camera tele chân dung 32MP cảm biến Sony IMX709, thiết kế mặt lưng họa tiết ngọc trai chuyển sắc.',
  '{"Màn hình":"6.7 inch 3D Curved AMOLED 120Hz","Chip":"MediaTek Dimensity 8200","RAM":"12GB","Bộ nhớ trong":"512GB","Camera":"50MP OIS + 32MP Tele + 8MP","Pin":"4600 mAh, Sạc 80W","variants":[{"name":"12GB / 512GB - Trắng Ngọc Trai","price":14990000,"original_price":16990000,"stock":20,"image":"https://images.unsplash.com/photo-1567581935884-3349723552ca?auto=format&fit=crop&w=800&q=80"},{"name":"12GB / 512GB - Xám Hoa Cương","price":14990000,"original_price":16990000,"stock":12,"image":"https://images.unsplash.com/photo-1533228876829-65c94e7b5025?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1567581935884-3349723552ca?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1533228876829-65c94e7b5025?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80"]}'
),
(
  38, 2, 'Vivo X100 Pro 5G (16GB / 512GB)', 'vivo-x100-pro-5g', 'Vivo', 23990000, 27990000, 16, 51, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1567581935884-3349723552ca?auto=format&fit=crop&w=800&q=80"]',
  'Ống kính ZEISS APO đạt chuẩn chứng nhận viễn vọng, cảm biến chính 1-inch Sony IMX989 kết hợp chip xử lý hình ảnh Vivo V3 chuyên sâu.',
  '{"Màn hình":"6.78 inch LTPO AMOLED 120Hz 3000 nits","Chip":"MediaTek Dimensity 9300","RAM":"16GB","Bộ nhớ trong":"512GB","Camera":"50MP 1-inch + 50MP ZEISS APO + 50MP","Pin":"5400 mAh, Sạc 100W","variants":[{"name":"16GB / 512GB - Cam Sunset","price":23990000,"original_price":27990000,"stock":10,"image":"https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80"},{"name":"16GB / 512GB - Xanh Dương Ánh Sao","price":23990000,"original_price":27990000,"stock":6,"image":"https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1567581935884-3349723552ca?auto=format&fit=crop&w=800&q=80"]}'
),
(
  39, 2, 'Google Pixel 8 Pro (12GB / 128GB)', 'google-pixel-8-pro', 'Google', 19990000, 24990000, 22, 88, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80"]',
  'Trải nghiệm Android thuần khiết cập nhật 7 năm, tính năng ma thuật Magic Editor, Best Take và cảm biến nhiệt độ độc quyền.',
  '{"Màn hình":"6.7 inch LTPO OLED Super Actua 120Hz (2400 nits)","Chip":"Google Tensor G3","RAM":"12GB","Bộ nhớ trong":"128GB","Camera":"50MP + 48MP Siêu rộng + 48MP Tele 5x","Pin":"5050 mAh","variants":[{"name":"12GB / 128GB - Xanh Vịnh Bay","price":19990000,"original_price":24990000,"stock":14,"image":"https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80"},{"name":"12GB / 256GB - Đen Obsidian","price":22490000,"original_price":26990000,"stock":8,"image":"https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=800&q=80"]}'
),
(
  40, 2, 'ASUS ROG Phone 8 Pro (16GB / 512GB)', 'asus-rog-phone-8-pro', 'Asus', 29990000, 33990000, 15, 125, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1565849904461-04a58ad377e0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80"]',
  'Màn hình ma trận LED AniMe Vision mặt lưng, màn hình AMOLED 165Hz, nút siêu âm AirTrigger cùng tản nhiệt buồng hơi tối thượng.',
  '{"Màn hình":"6.78 inch LTPO AMOLED 165Hz 2500 nits","Chip":"Snapdragon 8 Gen 3","RAM":"16GB LPDDR5X","Bộ nhớ trong":"512GB UFS 4.0","Camera":"50MP OIS Gimbal + 32MP Tele 3x + 13MP","Pin":"5500 mAh, Sạc 65W","variants":[{"name":"16GB / 512GB - Đen Phantom Black","price":29990000,"original_price":33990000,"stock":15,"image":"https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1565849904461-04a58ad377e0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80"]}'
);

-- ----------------------------------------------------------
-- 4.3. DANH MỤC 3: MÁY TÍNH BẢNG (TABLET) (20 SẢN PHẨM)
-- ----------------------------------------------------------
INSERT INTO `products` (
  `id`, `category_id`, `name`, `slug`, `brand`, 
  `price`, `original_price`, `stock`, `sold_count`, `rating`, `reviews_count`, `featured`, 
  `image_url`, 
  `images`, 
  `short_description`, 
  `specifications`
) VALUES
(
  41, 3, 'iPad Pro 11 inch M4 Ultra Retina (Wi-Fi 256GB)', 'ipad-pro-11-m4', 'Apple', 27990000, 29990000, 25, 980, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80"]',
  'Thiết kế mỏng kỷ lục 5.3mm, trang bị chip Apple M4 thế hệ mới và màn hình Ultra Retina XDR Tandem OLED kép đỉnh cao.',
  '{"Màn hình":"11 inch Tandem OLED Ultra Retina XDR 120Hz ProMotion","Chip":"Apple M4 (9-core CPU, 10-core GPU)","RAM":"8GB Unified","Bộ nhớ trong":"256GB","Trọng lượng":"444g siêu nhẹ","Pin":"10 giờ lướt web","variants":[{"name":"Wi-Fi 256GB - Đen Không Gian Space Black","price":27990000,"original_price":29990000,"stock":15,"image":"https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80"},{"name":"Wi-Fi 512GB - Bạc Silver","price":33990000,"original_price":35990000,"stock":10,"image":"https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80"]}'
),
(
  42, 3, 'iPad Pro 13 inch M4 Ultra Retina (Wi-Fi 256GB)', 'ipad-pro-13-m4', 'Apple', 36990000, 39990000, 20, 199, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1585792180666-f7547c6a28c5?auto=format&fit=crop&w=800&q=80"]',
  'Chiếc iPad mỏng nhất từ trước đến nay của Apple chỉ 5.1mm, không gian làm việc rộng rãi 13 inch tương thích Apple Pencil Pro.',
  '{"Màn hình":"13 inch Tandem OLED Ultra Retina XDR 120Hz 1600 nits","Chip":"Apple M4","RAM":"8GB Unified","Bộ nhớ trong":"256GB","Độ mỏng":"5.1 mm","Trọng lượng":"579g","variants":[{"name":"Wi-Fi 256GB - Space Black","price":36990000,"original_price":39990000,"stock":12,"image":"https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80"},{"name":"Wi-Fi + 5G 512GB - Silver","price":47990000,"original_price":50990000,"stock":8,"image":"https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1585792180666-f7547c6a28c5?auto=format&fit=crop&w=800&q=80"]}'
),
(
  43, 3, 'iPad Air 11 inch M2 (Wi-Fi 128GB)', 'ipad-air-11-m2', 'Apple', 16490000, 17990000, 35, 236, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1585792180666-f7547c6a28c5?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80"]',
  'Hiệu năng mạnh mẽ từ chip M2, camera trước Ultra Wide 12MP chuyển sang cạnh ngang tối ưu cho các cuộc gọi video call.',
  '{"Màn hình":"11 inch Liquid Retina IPS True Tone","Chip":"Apple M2 8-core CPU","RAM":"8GB","Bộ nhớ trong":"128GB","Camera":"Sau 12MP, Trước 12MP Center Stage","Pin":"28.93 Wh","variants":[{"name":"Wi-Fi 128GB - Xanh Dương Blue","price":16490000,"original_price":17990000,"stock":20,"image":"https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80"},{"name":"Wi-Fi 256GB - Tím Purple","price":19490000,"original_price":20990000,"stock":15,"image":"https://images.unsplash.com/photo-1585792180666-f7547c6a28c5?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1585792180666-f7547c6a28c5?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80"]}'
),
(
  44, 3, 'iPad Air 13 inch M2 (Wi-Fi 128GB)', 'ipad-air-13-m2', 'Apple', 21990000, 23990000, 25, 273, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80"]',
  'Lần đầu tiên dòng iPad Air có tùy chọn kích thước lớn 13 inch, âm trầm tăng cường gấp đôi mang lại trải nghiệm xem phim giải trí đã mắt.',
  '{"Màn hình":"13 inch Liquid Retina 600 nits","Chip":"Apple M2","RAM":"8GB","Bộ nhớ trong":"128GB","Loa":"Stereo kép âm trầm gấp đôi","Pin":"36.59 Wh","variants":[{"name":"Wi-Fi 128GB - Ánh Sao Starlight","price":21990000,"original_price":23990000,"stock":15,"image":"https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80"},{"name":"Wi-Fi 256GB - Xám Không Gian","price":24990000,"original_price":26990000,"stock":10,"image":"https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80"]}'
),
(
  45, 3, 'iPad mini 6 (Wi-Fi 64GB)', 'ipad-mini-6-64gb', 'Apple', 12490000, 13990000, 30, 310, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1585792180666-f7547c6a28c5?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1585792180666-f7547c6a28c5?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80"]',
  'Thiết kế siêu nhỏ gọn 8.3 inch viền đều, hỗ trợ Apple Pencil 2 hít nam châm cạnh hông, cổng USB-C sạc nhanh tiện lợi.',
  '{"Màn hình":"8.3 inch Liquid Retina True Tone","Chip":"Apple A15 Bionic","RAM":"4GB","Bộ nhớ trong":"64GB","Trọng lượng":"293g","Pin":"19.3 Wh","variants":[{"name":"Wi-Fi 64GB - Tím Khói","price":12490000,"original_price":13990000,"stock":18,"image":"https://images.unsplash.com/photo-1585792180666-f7547c6a28c5?auto=format&fit=crop&w=800&q=80"},{"name":"Wi-Fi 256GB - Ánh Sao","price":16490000,"original_price":17990000,"stock":12,"image":"https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1585792180666-f7547c6a28c5?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80"]}'
),
(
  46, 3, 'iPad Gen 10 10.9 inch (Wi-Fi 64GB)', 'ipad-gen-10-64gb', 'Apple', 9490000, 10990000, 50, 347, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80"]',
  'Thiết kế vuông vức tràn viền hiện đại 4 màu sắc trẻ trung, Touch ID tích hợp nút nguồn và cổng Type-C tốc độ cao.',
  '{"Màn hình":"10.9 inch Liquid Retina IPS","Chip":"Apple A14 Bionic","RAM":"4GB","Bộ nhớ trong":"64GB","Camera":"Trước 12MP Ultra Wide cạnh ngang","Pin":"28.6 Wh","variants":[{"name":"Wi-Fi 64GB - Xanh Blue","price":9490000,"original_price":10990000,"stock":30,"image":"https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80"},{"name":"Wi-Fi 64GB - Vàng Yellow","price":9490000,"original_price":10990000,"stock":20,"image":"https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80"]}'
),
(
  47, 3, 'iPad Gen 9 10.2 inch (Wi-Fi 64GB)', 'ipad-gen-9-64gb', 'Apple', 6990000, 7990000, 40, 384, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80"]',
  'Máy tính bảng quốc dân giá tốt nhất của Apple phục vụ học online, học sinh sinh viên, hỗ trợ bút Apple Pencil 1.',
  '{"Màn hình":"10.2 inch Retina IPS True Tone","Chip":"Apple A13 Bionic","RAM":"3GB","Bộ nhớ trong":"64GB","Camera":"Trước 12MP Ultra Wide Center Stage","Pin":"32.4 Wh","variants":[{"name":"Wi-Fi 64GB - Bạc Silver","price":6990000,"original_price":7990000,"stock":25,"image":"https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80"},{"name":"Wi-Fi 64GB - Xám Space Gray","price":6990000,"original_price":7990000,"stock":15,"image":"https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80"]}'
),
(
  48, 3, 'Samsung Galaxy Tab S9 Ultra (Wi-Fi 12GB / 256GB)', 'samsung-galaxy-tab-s9-ultra', 'Samsung', 22490000, 26990000, 15, 71, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80"]',
  'Màn hình khổng lồ 14.6 inch Dynamic AMOLED 2X, chuẩn kháng nước IP68 đầu tiên trên tablet cao cấp, kèm bút S-Pen chống nước theo máy.',
  '{"Màn hình":"14.6 inch Dynamic AMOLED 2X 120Hz HDR10+","Chip":"Snapdragon 8 Gen 2 for Galaxy","RAM":"12GB","Bộ nhớ trong":"256GB (khe thẻ 1TB)","Pin":"11200 mAh, Sạc 45W","Kháng nước":"IP68","variants":[{"name":"Wi-Fi 12GB / 256GB - Đen Phong Cách","price":22490000,"original_price":26990000,"stock":9,"image":"https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80"},{"name":"5G 12GB / 512GB - Đen Phong Cách","price":27990000,"original_price":32990000,"stock":6,"image":"https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80"]}'
),
(
  49, 3, 'Samsung Galaxy Tab S9+ (Wi-Fi 12GB / 256GB)', 'samsung-galaxy-tab-s9-plus', 'Samsung', 18990000, 22990000, 20, 108, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80"]',
  'Kích cỡ hoàn hảo 12.4 inch Dynamic AMOLED 2X 120Hz rực rỡ, cụm loa 4 chiều tinh chỉnh bởi AKG với công nghệ Dolby Atmos.',
  '{"Màn hình":"12.4 inch Dynamic AMOLED 2X 120Hz","Chip":"Snapdragon 8 Gen 2 for Galaxy","RAM":"12GB","Bộ nhớ trong":"256GB","Pin":"10090 mAh, Sạc 45W","Trọng lượng":"581g","variants":[{"name":"Wi-Fi 12GB / 256GB - Kem Be","price":18990000,"original_price":22990000,"stock":12,"image":"https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80"},{"name":"5G 12GB / 256GB - Xám Graphite","price":21990000,"original_price":25990000,"stock":8,"image":"https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80"]}'
),
(
  50, 3, 'Samsung Galaxy Tab S9 FE (Wi-Fi 6GB / 128GB)', 'samsung-galaxy-tab-s9-fe', 'Samsung', 9490000, 11990000, 35, 145, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1585792180666-f7547c6a28c5?auto=format&fit=crop&w=800&q=80"]',
  'Tablet kháng nước IP68 giá tốt nhất, kèm bút S Pen thỏa sức vẽ vời sáng tạo, màn hình 90Hz mượt mà tích hợp Vision Booster.',
  '{"Màn hình":"10.9 inch IPS LCD 90Hz WQXGA","Chip":"Exynos 1380 8 nhân","RAM":"6GB","Bộ nhớ trong":"128GB","Pin":"8000 mAh","Kháng nước":"IP68 cả máy và bút","variants":[{"name":"Wi-Fi 6GB / 128GB - Xanh Nhiệt Đới","price":9490000,"original_price":11990000,"stock":20,"image":"https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80"},{"name":"5G 6GB / 128GB - Xám Tự Tin","price":11990000,"original_price":13990000,"stock":15,"image":"https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1585792180666-f7547c6a28c5?auto=format&fit=crop&w=800&q=80"]}'
),
(
  51, 3, 'Samsung Galaxy Tab S9 FE+ (Wi-Fi 8GB / 128GB)', 'samsung-galaxy-tab-s9-fe-plus', 'Samsung', 12490000, 14990000, 25, 182, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80"]',
  'Không gian hiển thị nâng lên 12.4 inch, viên pin khủng 10090mAh đáp ứng trọn vẹn 18-20 giờ làm việc và học tập liên tục.',
  '{"Màn hình":"12.4 inch WQXGA 90Hz","Chip":"Exynos 1380","RAM":"8GB","Bộ nhớ trong":"128GB","Pin":"10090 mAh, Sạc 45W","Bút":"S-Pen đi kèm hộp","variants":[{"name":"Wi-Fi 8GB / 128GB - Bạc","price":12490000,"original_price":14990000,"stock":15,"image":"https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80"},{"name":"5G 8GB / 128GB - Xám","price":14990000,"original_price":16990000,"stock":10,"image":"https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80"]}'
),
(
  52, 3, 'Samsung Galaxy Tab A9+ (Wi-Fi 4GB / 64GB)', 'samsung-galaxy-tab-a9-plus', 'Samsung', 4990000, 5990000, 45, 219, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80"]',
  'Giải trí gia đình đỉnh cao với màn hình lớn 11 inch 90Hz, hệ thống 4 loa vòm Dolby Atmos và giao diện Samsung DeX tiện ích.',
  '{"Màn hình":"11.0 inch TFT LCD 90Hz WUXGA","Chip":"Snapdragon 695 5G","RAM":"4GB","Bộ nhớ trong":"64GB","Loa":"Quad Speakers Dolby Atmos","Pin":"7040 mAh","variants":[{"name":"Wi-Fi 4GB / 64GB - Bạc","price":4990000,"original_price":5990000,"stock":25,"image":"https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80"},{"name":"5G 4GB / 64GB - Đen Graphite","price":6490000,"original_price":7490000,"stock":20,"image":"https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80"]}'
),
(
  53, 3, 'Xiaomi Pad 6S Pro 12.4 (8GB / 256GB)', 'xiaomi-pad-6s-pro', 'Xiaomi', 13990000, 15990000, 24, 256, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1512499617640-c74ae3a79d37?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1512499617640-c74ae3a79d37?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80"]',
  'Màn hình 3K tỷ lệ 3:2 chuẩn văn phòng, tần số quét 144Hz siêu mượt, chip Snapdragon 8 Gen 2 cùng sạc siêu nhanh HyperCharge 120W.',
  '{"Màn hình":"12.4 inch 3K (3048x2032) 144Hz 3:2 Dolby Vision","Chip":"Snapdragon 8 Gen 2","RAM":"8GB","Bộ nhớ trong":"256GB","Pin":"10000 mAh, Sạc nhanh 120W","Loa":"6 loa âm thanh nổi","variants":[{"name":"8GB / 256GB - Đen Graphite","price":13990000,"original_price":15990000,"stock":14,"image":"https://images.unsplash.com/photo-1512499617640-c74ae3a79d37?auto=format&fit=crop&w=800&q=80"},{"name":"12GB / 512GB - Đen Graphite","price":16490000,"original_price":18490000,"stock":10,"image":"https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1512499617640-c74ae3a79d37?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80"]}'
),
(
  54, 3, 'Xiaomi Pad 6 (8GB / 128GB)', 'xiaomi-pad-6-128gb', 'Xiaomi', 7990000, 9490000, 35, 293, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80"]',
  'Khung nhôm nguyên khối siêu mỏng 6.51mm, màn hình 2.8K 144Hz HDR10, chip Snapdragon 870 cân mượt mọi tựa game mobile.',
  '{"Màn hình":"11 inch 2.8K 144Hz 1 tỷ màu","Chip":"Snapdragon 870","RAM":"8GB","Bộ nhớ trong":"128GB","Pin":"8840 mAh, Sạc 33W","Trọng lượng":"490g","variants":[{"name":"8GB / 128GB - Vàng Champagne","price":7990000,"original_price":9490000,"stock":20,"image":"https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80"},{"name":"8GB / 256GB - Xám sương mù","price":8990000,"original_price":10490000,"stock":15,"image":"https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80"]}'
),
(
  55, 3, 'Lenovo Legion Y700 Gen 2 (12GB / 256GB)', 'lenovo-legion-y700-gen-2', 'Lenovo', 9990000, 11990000, 22, 330, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1585792180666-f7547c6a28c5?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1585792180666-f7547c6a28c5?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1512499617640-c74ae3a79d37?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80"]',
  'Ông vua máy tính bảng gaming nhỏ gọn 8.8 inch 144Hz, 2 cổng USB-C tiện lợi vừa sạc bypass vừa cắm phụ kiện khi chơi game.',
  '{"Màn hình":"8.8 inch 2.5K 144Hz 500 nits","Chip":"Snapdragon 8+ Gen 1","RAM":"12GB LPDDR5X","Bộ nhớ trong":"256GB","Pin":"6550 mAh, Sạc 45W","Cổng kết nối":"2 cổng USB Type-C","variants":[{"name":"12GB / 256GB - Xám Bão Storm Grey","price":9990000,"original_price":11990000,"stock":14,"image":"https://images.unsplash.com/photo-1585792180666-f7547c6a28c5?auto=format&fit=crop&w=800&q=80"},{"name":"16GB / 512GB - Xám Bão","price":11990000,"original_price":13990000,"stock":8,"image":"https://images.unsplash.com/photo-1512499617640-c74ae3a79d37?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1585792180666-f7547c6a28c5?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1512499617640-c74ae3a79d37?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80"]}'
),
(
  56, 3, 'Lenovo Tab P12 (8GB / 128GB) Kèm Bút', 'lenovo-tab-p12', 'Lenovo', 8490000, 9990000, 28, 367, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1555774698-0b77e0d5fac6?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1555774698-0b77e0d5fac6?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80"]',
  'Màn hình khổng lồ 12.7 inch 3K sắc nét, tặng sẵn bút cảm ứng Lenovo Tab Pen Plus phục vụ ghi chú học tập chuyên sâu.',
  '{"Màn hình":"12.7 inch 3K LTPS LCD 60Hz","Chip":"MediaTek Dimensity 7050","RAM":"8GB","Bộ nhớ trong":"128GB (khe thẻ 1TB)","Loa":"4 loa JBL Dolby Atmos","Pin":"10200 mAh","variants":[{"name":"8GB / 128GB - Xám Storm Grey","price":8490000,"original_price":9990000,"stock":28,"image":"https://images.unsplash.com/photo-1555774698-0b77e0d5fac6?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1555774698-0b77e0d5fac6?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80"]}'
),
(
  57, 3, 'Microsoft Surface Pro 11 Copilot+ (Snapdragon X Plus)', 'surface-pro-11', 'Microsoft', 29990000, 33990000, 18, 54, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1512499617640-c74ae3a79d37?auto=format&fit=crop&w=800&q=80"]',
  'Sự kết hợp thần thánh giữa tablet và laptop, chân đế Kickstand linh hoạt 165 độ, tích hợp NPU 45 TOPS thế hệ mới.',
  '{"Màn hình":"13.0 inch PixelSense Flow LCD 120Hz","Chip":"Qualcomm Snapdragon X Plus","RAM":"16GB LPDDR5x","Bộ nhớ trong":"256GB SSD","Pin":"Lên đến 14 giờ","Trọng lượng":"895g","variants":[{"name":"LCD 16GB / 256GB - Platinum","price":29990000,"original_price":33990000,"stock":10,"image":"https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80"},{"name":"OLED 16GB / 512GB - Sapphire Xanh","price":39990000,"original_price":43990000,"stock":8,"image":"https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1512499617640-c74ae3a79d37?auto=format&fit=crop&w=800&q=80"]}'
),
(
  58, 3, 'Microsoft Surface Pro 9 (Intel Core i5-1235U / 8GB / 256GB)', 'surface-pro-9', 'Microsoft', 22990000, 25990000, 20, 91, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80"]',
  'Hiệu năng Intel Core i5 chuẩn laptop trong hình hài tablet thanh mảnh, 2 cổng Thunderbolt 4 kết nối eGPU và màn hình ngoài 4K.',
  '{"Màn hình":"13 inch PixelSense 120Hz cảm ứng 10 điểm","Chip":"Intel Core i5-1235U","RAM":"8GB LPDDR5","Bộ nhớ trong":"256GB SSD","Cổng":"2x Thunderbolt 4 Type-C","Pin":"47.7Wh","variants":[{"name":"i5 / 8GB / 256GB - Platinum","price":22990000,"original_price":25990000,"stock":12,"image":"https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80"},{"name":"i5 / 16GB / 256GB - Forest Xanh Lá","price":26990000,"original_price":29990000,"stock":8,"image":"https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1589739900266-43b2843f4c12?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80"]}'
),
(
  59, 3, 'OnePlus Pad 2 (12GB / 256GB)', 'oneplus-pad-2', 'OnePlus', 14990000, 16990000, 17, 128, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1585792180666-f7547c6a28c5?auto=format&fit=crop&w=800&q=80"]',
  'Màn hình tỷ lệ đọc sách 7:5 3K 144Hz, trang bị vi xử lý đầu bảng Snapdragon 8 Gen 3 cùng hệ thống 6 loa âm thanh không gian nổi bật.',
  '{"Màn hình":"12.1 inch 3K (3000x2120) 144Hz 7:5","Chip":"Snapdragon 8 Gen 3","RAM":"12GB LPDDR5X","Bộ nhớ trong":"256GB UFS 3.1","Pin":"9510 mAh, Sạc 67W","variants":[{"name":"12GB / 256GB - Xám Nimbus Gray","price":14990000,"original_price":16990000,"stock":17,"image":"https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1527690787497-6a56e9c9ff4c?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1585792180666-f7547c6a28c5?auto=format&fit=crop&w=800&q=80"]}'
),
(
  60, 3, 'Huawei MatePad Pro 13.2 (12GB / 256GB)', 'huawei-matepad-pro-13-2', 'Huawei', 21990000, 24990000, 15, 165, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1512499617640-c74ae3a79d37?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1512499617640-c74ae3a79d37?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1555774698-0b77e0d5fac6?auto=format&fit=crop&w=800&q=80"]',
  'Viền màn hình mỏng nhất thế giới 3.4mm với tỷ lệ màn hình 94%, công nghệ bút M-Pencil NearLink 10.000 mức lực nhấn siêu nhạy.',
  '{"Màn hình":"13.2 inch Flexible OLED 144Hz 1000 nits","Chip":"Kirin 9000S","RAM":"12GB","Bộ nhớ trong":"256GB","Trọng lượng":"580g mỏng 5.5mm","Pin":"10100 mAh, Sạc 88W","variants":[{"name":"12GB / 256GB - Đen Golden Black","price":21990000,"original_price":24990000,"stock":15,"image":"https://images.unsplash.com/photo-1512499617640-c74ae3a79d37?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1512499617640-c74ae3a79d37?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1555774698-0b77e0d5fac6?auto=format&fit=crop&w=800&q=80"]}'
);

-- ----------------------------------------------------------
-- 4.4. DANH MỤC 4: ÂM THANH & TAI NGHE (20 SẢN PHẨM)
-- ----------------------------------------------------------
INSERT INTO `products` (
  `id`, `category_id`, `name`, `slug`, `brand`, 
  `price`, `original_price`, `stock`, `sold_count`, `rating`, `reviews_count`, `featured`, 
  `image_url`, 
  `images`, 
  `short_description`, 
  `specifications`
) VALUES
(
  61, 4, 'Tai nghe chống ồn Sony WH-1000XM5', 'sony-wh-1000xm5', 'Sony', 7490000, 8990000, 40, 890, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80"]',
  'Khử tiếng ồn đỉnh cao hàng đầu thế giới với 2 bộ xử lý và 8 micro, chất âm chuẩn Hi-Res Audio không dây.',
  '{"Loại":"Tai nghe chụp tai Over-ear","Công nghệ":"Chống ồn chủ động ANC V1 + QN1","Driver":"30mm màng sợi carbon tổng hợp","Thời lượng pin":"30 giờ (bật ANC), sạc 3 phút nghe 3 giờ","Kết nối":"Bluetooth 5.2, LDAC, DSEE Extreme","variants":[{"name":"Màu Đen Black","price":7490000,"original_price":8990000,"stock":20,"image":"https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Bạc Silver","price":7490000,"original_price":8990000,"stock":15,"image":"https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Xanh Khói Smoky Pink","price":7990000,"original_price":9290000,"stock":5,"image":"https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80"]}'
),
(
  62, 4, 'Tai nghe Sony WF-1000XM5 True Wireless', 'sony-wf-1000xm5', 'Sony', 5990000, 6990000, 35, 239, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80"]',
  'Bộ xử lý chống ồn tích hợp V2 và QN2e mới, củ loa Dynamic Driver X 8.4mm tái tạo giọng hát trong trẻo và âm trầm sâu lắng.',
  '{"Loại":"Tai nghe nhét tai In-ear TWS","Chống ồn":"Dual Processor ANC","Pin":"8 giờ (bật ANC) + 16 giờ hộp sạc","Kháng nước":"IPX4","Codec":"LDAC, LC3, AAC, SBC","variants":[{"name":"Màu Đen Bóng","price":5990000,"original_price":6990000,"stock":20,"image":"https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Bạc Bạch Kim","price":5990000,"original_price":6990000,"stock":15,"image":"https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80"]}'
),
(
  63, 4, 'Tai nghe Sony WH-CH720N Chống Ồn', 'sony-wh-ch720n', 'Sony', 2490000, 2990000, 45, 276, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80"]',
  'Trọng lượng nhẹ nhất trong phân khúc tai nghe chống ồn của Sony chỉ 192g, trang bị chip V1 cao cấp và pin khủng 35 giờ.',
  '{"Loại":"Tai nghe chụp tai Over-ear","Chip":"Integrated Processor V1","Pin":"35 giờ bật chống ồn, 50 giờ tắt","Trọng lượng":"192g siêu nhẹ","variants":[{"name":"Màu Đen","price":2490000,"original_price":2990000,"stock":25,"image":"https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Xanh Dương","price":2490000,"original_price":2990000,"stock":20,"image":"https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80"]}'
),
(
  64, 4, 'Tai nghe Apple AirPods Pro (Gen 2) USB-C', 'airpods-pro-gen-2-usbc', 'Apple', 5690000, 6290000, 60, 313, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=800&q=80"]',
  'Chip H2 nâng tầm chống ồn chủ động gấp 2 lần, âm thanh thích ứng Adaptive Audio và cổng sạc USB-C tiện lợi.',
  '{"Loại":"Tai nghe nhét tai True Wireless","Chip":"Apple H2","Chống ồn":"ANC gấp 2 lần + Xuyên âm thông minh","Pin":"6 giờ liên tục, 30 giờ kèm hộp sạc","Kháng nước":"IP54 chống bụi nước","variants":[{"name":"Bản Hộp sạc MagSafe USB-C Trắng","price":5690000,"original_price":6290000,"stock":60,"image":"https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=800&q=80"]}'
),
(
  65, 4, 'Tai nghe Apple AirPods Max (USB-C 2024)', 'apple-airpods-max-usbc', 'Apple', 13490000, 14990000, 20, 350, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80"]',
  'Khung thép không gỉ bọc đệm lưới thoáng khí, âm thanh vòm không gian Spatial Audio theo dõi chuyển động đầu cùng cổng sạc USB-C mới.',
  '{"Loại":"Tai nghe chụp tai Over-ear","Chip":"2 chip Apple H1","Chất liệu":"Nhôm Anodized + Thép không gỉ","Chống ồn":"Active Noise Cancellation cao cấp","Pin":"20 giờ nghe liên tục","variants":[{"name":"Màu Midnight Đen","price":13490000,"original_price":14990000,"stock":7,"image":"https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Ánh Sao Starlight","price":13490000,"original_price":14990000,"stock":7,"image":"https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Cam Orange","price":13490000,"original_price":14990000,"stock":6,"image":"https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80"]}'
),
(
  66, 4, 'Tai nghe Apple AirPods 3 Hộp Sạc MagSafe', 'apple-airpods-3', 'Apple', 4290000, 4990000, 40, 387, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=800&q=80"]',
  'Thiết kế dạng Earbuds đeo êm ái thoáng khí không bí tai, cảm biến lực chạm trên thân tai và hỗ trợ sạc không dây MagSafe.',
  '{"Loại":"Tai nghe Earbuds True Wireless","Âm thanh":"Spatial Audio theo dõi đầu","Pin":"6 giờ (tổng 30 giờ)","Kháng nước":"IPX4","variants":[{"name":"Hộp Sạc MagSafe Trắng","price":4290000,"original_price":4990000,"stock":40,"image":"https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=800&q=80"]}'
),
(
  67, 4, 'Loa Bluetooth Marshall Stanmore III', 'marshall-stanmore-iii', 'Marshall', 8990000, 10290000, 18, 74, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80"]',
  'Âm thanh tràn ngập không gian gia đình mang âm sắc cổ điển huyền thoại, kết nối Bluetooth 5.2 và AUX 3.5mm.',
  '{"Công suất":"80W (1 Woofer 50W + 2 Tweeter 15W)","Dải tần":"45Hz - 20000Hz","Kết nối":"Bluetooth 5.2, AUX 3.5mm, RCA","Trọng lượng":"4.25 kg","Nguồn điện":"Cắm điện trực tiếp","variants":[{"name":"Màu Đen Viền Vàng Black","price":8990000,"original_price":10290000,"stock":10,"image":"https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Kem Vintage Cream","price":9290000,"original_price":10590000,"stock":8,"image":"https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80"]}'
),
(
  68, 4, 'Loa Bluetooth Marshall Acton III', 'marshall-acton-iii', 'Marshall', 6490000, 7490000, 25, 111, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80"]',
  'Kích thước nhỏ gọn để bàn làm việc, công suất 60W âm bass uy lực, các núm vặn cơ học mạ đồng điều chỉnh Bass/Treble mượt mà.',
  '{"Công suất":"60W","Dải tần":"45Hz - 20000Hz","Kết nối":"Bluetooth 5.2, Cổng 3.5mm","Trọng lượng":"2.85 kg","variants":[{"name":"Màu Đen Black","price":6490000,"original_price":7490000,"stock":15,"image":"https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Nâu Nâu Cổ Điển Brown","price":6690000,"original_price":7690000,"stock":10,"image":"https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80"]}'
),
(
  69, 4, 'Loa Bluetooth Di Động Marshall Emberton II', 'marshall-emberton-ii', 'Marshall', 3890000, 4590000, 35, 148, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80"]',
  'Công nghệ âm thanh đa hướng True Stereophonic 360 độ, chuẩn kháng nước bụi IP67 và thời lượng pin hơn 30 giờ di động.',
  '{"Công suất":"20W (2 loa full-range 10W)","Pin":"30+ giờ chơi nhạc, sạc 3 giờ","Kháng nước":"IP67 chuẩn quân sự","Trọng lượng":"700g siêu nhỏ gọn","variants":[{"name":"Black and Brass (Đen vàng)","price":3890000,"original_price":4590000,"stock":22,"image":"https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80"},{"name":"Cream (Màu Kem)","price":3990000,"original_price":4690000,"stock":13,"image":"https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80"]}'
),
(
  70, 4, 'Tai nghe Bose QuietComfort Ultra Headphones', 'bose-qc-ultra-headphones', 'Bose', 8990000, 10490000, 20, 185, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1524678606370-a47ad25cb82a?auto=format&fit=crop&w=800&q=80"]',
  'Công nghệ âm thanh Bose Immersive Audio sống động, đệm tai da tổng hợp êm ái hàng đầu cho các chuyến bay đường dài.',
  '{"Loại":"Tai nghe chụp tai Over-ear ANC","Chế độ":"Quiet Mode, Aware Mode, Immersion Mode","Pin":"24 giờ liên tục","Codec":"Qualcomm aptX Adaptive, AAC","variants":[{"name":"Màu Đen Black","price":8990000,"original_price":10490000,"stock":12,"image":"https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Trắng Khói White Smoke","price":8990000,"original_price":10490000,"stock":8,"image":"https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1524678606370-a47ad25cb82a?auto=format&fit=crop&w=800&q=80"]}'
),
(
  71, 4, 'Tai nghe Bose QuietComfort Ultra Earbuds', 'bose-qc-ultra-earbuds', 'Bose', 6990000, 7990000, 24, 222, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80"]',
  'Khử tiếng ồn thế giới số 1 được các chuyên gia âm thanh công nhận, công nghệ CustomTune tự động đo ống tai để tối ưu hóa âm sắc.',
  '{"Loại":"Tai nghe nhét tai TWS","Tính năng":"CustomTune + Chống ồn chủ động đẳng cấp","Pin":"6 giờ (tổng 24 giờ)","Kháng nước":"IPX4","variants":[{"name":"Màu Đen","price":6990000,"original_price":7990000,"stock":14,"image":"https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Trắng Khói","price":6990000,"original_price":7990000,"stock":10,"image":"https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80"]}'
),
(
  72, 4, 'Loa Bluetooth JBL Boombox 3', 'jbl-boombox-3', 'JBL', 10990000, 12990000, 15, 259, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80"]',
  'Âm trầm JBL Original Pro Sound quái vật với loa siêu trầm Subwoofer trung tâm, thời gian phát nhạc 24 giờ tích hợp cổng sạc dự phòng.',
  '{"Công suất":"180W (chế độ cắm điện AC) / 136W (pin)","Pin":"24 giờ chơi nhạc","Kháng nước":"IP67 chống nước và bụi","Trọng lượng":"6.7 kg có tay cầm kim loại","variants":[{"name":"Màu Đen Mạnh Mẽ","price":10990000,"original_price":12990000,"stock":10,"image":"https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Rằn Ri Camo Squad","price":11290000,"original_price":13290000,"stock":5,"image":"https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80"]}'
),
(
  73, 4, 'Loa Bluetooth JBL Charge 5', 'jbl-charge-5', 'JBL', 3490000, 3990000, 40, 296, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1524678606370-a47ad25cb82a?auto=format&fit=crop&w=800&q=80"]',
  'Củ loa dạng đường đua racetrack driver riêng biệt và loa tweeter độc lập, kiêm pin sạc dự phòng cho điện thoại trong mọi chuyến đi.',
  '{"Công suất":"40W RMS","Pin":"20 giờ phát nhạc (7500 mAh)","Kháng nước":"IP67 chống nước bụi bặm","Tính năng":"PartyBoost kết nối hàng trăm loa","variants":[{"name":"Màu Đen Black","price":3490000,"original_price":3990000,"stock":20,"image":"https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Xanh Dương Blue","price":3490000,"original_price":3990000,"stock":20,"image":"https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1524678606370-a47ad25cb82a?auto=format&fit=crop&w=800&q=80"]}'
),
(
  74, 4, 'Loa Bluetooth JBL Flip 6', 'jbl-flip-6', 'JBL', 2590000, 2990000, 50, 333, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1524678606370-a47ad25cb82a?auto=format&fit=crop&w=800&q=80"]',
  'Thiết kế hình trụ tròn cầm vừa tay, 2 màng cộng hưởng thụ động kép dập bass cực căng theo từng giai điệu.',
  '{"Công suất":"30W (20W Woofer + 10W Tweeter)","Pin":"12 giờ","Kháng nước":"IP67","Trọng lượng":"550g","variants":[{"name":"Màu Đỏ Năng Động","price":2590000,"original_price":2990000,"stock":25,"image":"https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Đen Cá Tính","price":2590000,"original_price":2990000,"stock":25,"image":"https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1524678606370-a47ad25cb82a?auto=format&fit=crop&w=800&q=80"]}'
),
(
  75, 4, 'Tai nghe Sennheiser Momentum 4 Wireless', 'sennheiser-momentum-4', 'Sennheiser', 8490000, 9990000, 18, 370, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1524678606370-a47ad25cb82a?auto=format&fit=crop&w=800&q=80"]',
  'Thời lượng pin kỷ lục thế giới lên tới 60 giờ nghe liên tục, củ loa 42mm audiophile truyền tải âm thanh chuẩn phòng thu nước Đức.',
  '{"Loại":"Tai nghe chụp tai Over-ear","Driver":"42mm Transducer Audiophile-grade","Thời lượng pin":"60 giờ (bật ANC)","Codec":"aptX Adaptive, AAC, SBC","variants":[{"name":"Màu Đen Viền Đồng","price":8490000,"original_price":9990000,"stock":10,"image":"https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Trắng Kem White","price":8490000,"original_price":9990000,"stock":8,"image":"https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1524678606370-a47ad25cb82a?auto=format&fit=crop&w=800&q=80"]}'
),
(
  76, 4, 'Tai nghe Sennheiser Momentum True Wireless 4', 'sennheiser-mtw4', 'Sennheiser', 7490000, 8490000, 20, 57, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80"]',
  'Hỗ trợ công nghệ âm thanh tương lai Auracast và LE Audio, hệ thống chống ồn Hybrid thích ứng thông minh và Bluetooth 5.4 mới nhất.',
  '{"Loại":"Tai nghe In-ear TWS","Công nghệ":"Snapdragon Sound, aptX Lossless","Pin":"7.5 giờ (tổng 30 giờ)","Bluetooth":"5.4 thế hệ mới","variants":[{"name":"Màu Bạc Đồng Metallic Silver","price":7490000,"original_price":8490000,"stock":12,"image":"https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Đen Graphit Black Copper","price":7490000,"original_price":8490000,"stock":8,"image":"https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1608156639585-b3a032ef9689?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80"]}'
),
(
  77, 4, 'Loa Harman Kardon Aura Studio 4', 'harman-kardon-aura-studio-4', 'Harman Kardon', 6290000, 6990000, 22, 94, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80"]',
  'Thiết kế vòm kính trong suốt mang tính biểu tượng với ánh sáng họa tiết kim cương chuyển động 5 chủ đề theo nhịp điệu bài hát.',
  '{"Công suất":"130W (100W Subwoofer + 6 x 5W)","Âm thanh":"360 độ đa hướng","Ánh sáng":"Đèn LED kim cương 5 chế độ nhịp điệu","Trọng lượng":"3.6 kg","variants":[{"name":"Bản Đen Vòm Kính Pha Lê","price":6290000,"original_price":6990000,"stock":22,"image":"https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80"]}'
),
(
  78, 4, 'Loa Bang & Olufsen Beosound Explore', 'bo-beosound-explore', 'B&O', 5490000, 6290000, 16, 131, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1524678606370-a47ad25cb82a?auto=format&fit=crop&w=800&q=80"]',
  'Gia công từ nhôm Anodized chống xước loại II chuẩn thám hiểm Đan Mạch, móc khóa carabiner chuyên dụng gắn ba lô leo núi.',
  '{"Công suất":"60W (2x30W Class D)","Kháng nước":"IP67 chống ngập nước 1m","Pin":"27 giờ sử dụng","Trọng lượng":"631g","variants":[{"name":"Màu Xanh Đậm Navy","price":5490000,"original_price":6290000,"stock":10,"image":"https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Xanh Rêu Grey Mist","price":5490000,"original_price":6290000,"stock":6,"image":"https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1524678606370-a47ad25cb82a?auto=format&fit=crop&w=800&q=80"]}'
),
(
  79, 4, 'Tai nghe Audio-Technica ATH-M50xBT2', 'audio-technica-ath-m50xbt2', 'Audio-Technica', 4990000, 5690000, 25, 168, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1524678606370-a47ad25cb82a?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1524678606370-a47ad25cb82a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80"]',
  'Huyền thoại phòng thu Nhật Bản nay nâng cấp Bluetooth, củ loa 45mm khẩu độ lớn tái hiện dải tần chính xác tuyệt đối.',
  '{"Loại":"Tai nghe kiểm âm Monitor không dây","Driver":"45mm nam châm đất hiếm","Thời lượng pin":"50 giờ","Codec":"LDAC, AAC, SBC","Micro":"Dual Mic Beamforming","variants":[{"name":"Màu Đen Studio Black","price":4990000,"original_price":5690000,"stock":17,"image":"https://images.unsplash.com/photo-1524678606370-a47ad25cb82a?auto=format&fit=crop&w=800&q=80"},{"name":"Bản Giới Hạn Màu Cam Ice Blue","price":5290000,"original_price":5990000,"stock":8,"image":"https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1524678606370-a47ad25cb82a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80"]}'
),
(
  80, 4, 'Tai nghe Shure AONIC 50 Gen 2', 'shure-aonic-50-gen-2', 'Shure', 8990000, 9990000, 14, 205, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1524678606370-a47ad25cb82a?auto=format&fit=crop&w=800&q=80"]',
  'Âm thanh không gian Spatial Audio đa chiều với 3 chế độ Cinema/Music/Podcast, chip giải mã DAC USB hỗ trợ nhạc lossless 32-bit/384kHz.',
  '{"Loại":"Tai nghe chụp tai Audiophile ANC","Driver":"50mm màng sinh học","Công nghệ":"Spatial Audio + USB-C DAC Lossless","Pin":"45 giờ","variants":[{"name":"Màu Đen Sang Trọng","price":8990000,"original_price":9990000,"stock":14,"image":"https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1524678606370-a47ad25cb82a?auto=format&fit=crop&w=800&q=80"]}'
);

-- ----------------------------------------------------------
-- 4.5. DANH MỤC 5: GAMING GEAR & PHỤ KIỆN (20 SẢN PHẨM)
-- ----------------------------------------------------------
INSERT INTO `products` (
  `id`, `category_id`, `name`, `slug`, `brand`, 
  `price`, `original_price`, `stock`, `sold_count`, `rating`, `reviews_count`, `featured`, 
  `image_url`, 
  `images`, 
  `short_description`, 
  `specifications`
) VALUES
(
  81, 5, 'Bàn phím cơ không dây Keychron K8 Pro QMK/VIA', 'keychron-k8-pro', 'Keychron', 2390000, 2790000, 35, 760, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]',
  'Bàn phím cơ Layout TKL 87 phím, switch Gateron G Pro hotswap, mạch xuôi LED RGB hỗ trợ tùy biến phím qua QMK/VIA.',
  '{"Phân loại":"Bàn phím cơ không dây","Layout":"Tenkeyless 87 phím","Switch":"Gateron G Pro Hotswap (Red/Brown/Blue)","Kết nối":"Bluetooth 5.1 và Type-C có dây","Keycap":"OSA PBT Double-shot","Pin":"4000mAh dùng 300 giờ","variants":[{"name":"Khung Nhôm / RGB / Red Switch (Gõ êm)","price":2390000,"original_price":2790000,"stock":15,"image":"https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80"},{"name":"Khung Nhôm / RGB / Brown Switch (Gõ nảy)","price":2390000,"original_price":2790000,"stock":20,"image":"https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]}'
),
(
  82, 5, 'Bàn phím cơ nhôm CNC Keychron Q1 Pro Wireless', 'keychron-q1-pro', 'Keychron', 4690000, 5290000, 20, 279, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]',
  'Vỏ nhôm nguyên khối cắt CNC anodized cao cấp, cấu trúc Double-Gasket êm tai, núm xoay đa năng kim loại và kết nối không dây.',
  '{"Phân loại":"Bàn phím cơ cao cấp Custom","Layout":"75% (81 phím + Núm xoay)","Chất liệu":"Nhôm CNC 6063","Cấu trúc":"Double-Gasket Mount","Trọng lượng":"1.74 kg đầm chắc","variants":[{"name":"Carbon Black / Banana Switch","price":4690000,"original_price":5290000,"stock":12,"image":"https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80"},{"name":"Silver Grey / Red Switch","price":4690000,"original_price":5290000,"stock":8,"image":"https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]}'
),
(
  83, 5, 'Bàn phím cơ Keychron V1 Max 2.4GHz / Bluetooth', 'keychron-v1-max', 'Keychron', 2190000, 2590000, 30, 316, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]',
  'Hỗ trợ kết nối Receiver 2.4GHz độ trễ 1ms cho game thủ, đệm tiêu âm acoustic foam và gasket mount cho tiếng gõ trầm ấm.',
  '{"Phân loại":"Bàn phím cơ","Layout":"75% gọn gàng","Kết nối":"2.4GHz + Bluetooth 5.1 + Dây Type-C","Tính năng":"Hotswap mạch xuôi 5-pin","variants":[{"name":"Đen Mờ / Gateron Jupiter Red","price":2190000,"original_price":2590000,"stock":15,"image":"https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80"},{"name":"Đen Mờ / Gateron Jupiter Brown","price":2190000,"original_price":2590000,"stock":15,"image":"https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]}'
),
(
  84, 5, 'Chuột công thái học Logitech MX Master 3S', 'logitech-mx-master-3s', 'Logitech', 2190000, 2490000, 50, 353, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80"]',
  'Cảm biến Darkfield 8000 DPI theo dõi trên mọi bề mặt kể cả kính, cuộn siêu tốc MagSpeed 1000 dòng/giây và click siêu êm.',
  '{"Phân loại":"Chuột công thái học văn phòng","Cảm biến":"Darkfield 8000 DPI","Nút bấm":"Quiet Clicks giảm 90% tiếng ồn","Kết nối":"Logi Bolt và Bluetooth (3 thiết bị)","Pin":"Sạc đầy dùng 70 ngày","variants":[{"name":"Màu Đen Than Graphite","price":2190000,"original_price":2490000,"stock":30,"image":"https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Xám Nhạt Pale Grey","price":2190000,"original_price":2490000,"stock":20,"image":"https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80"]}'
),
(
  85, 5, 'Chuột gaming không dây Logitech G Pro X Superlight 2', 'g-pro-x-superlight-2', 'Logitech', 3490000, 3990000, 30, 390, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80"]',
  'Trọng lượng siêu nhẹ chỉ 60g, switch lai quang-cơ LIGHTFORCE phản hồi chớp nhoáng, cảm biến HERO 2 32.000 DPI đỉnh cao thi đấu eSports.',
  '{"Phân loại":"Chuột Gaming siêu nhẹ","Trọng lượng":"60g","Cảm biến":"HERO 2 (32000 DPI, 500 IPS, 40G)","Polling Rate":"4000Hz (qua bản cập nhật)","Pin":"95 giờ","variants":[{"name":"Màu Trắng White","price":3490000,"original_price":3990000,"stock":15,"image":"https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Đen Black","price":3490000,"original_price":3990000,"stock":10,"image":"https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Hồng Magenta","price":3590000,"original_price":4090000,"stock":5,"image":"https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80"]}'
),
(
  86, 5, 'Chuột gaming Logitech G502 X PLUS Wireless RGB', 'logitech-g502-x-plus', 'Logitech', 3290000, 3890000, 25, 77, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80"]',
  'Huyền thoại G502 tái sinh với switch lai LIGHTFORCE, con lăn vô cực siêu tốc 2 chế độ và dải đèn RGB 8 vùng phát sáng theo hiệu ứng.',
  '{"Phân loại":"Chuột Gaming đa nút","Cảm biến":"HERO 25K","Nút bấm":"13 nút lập trình macro","Pin":"130 giờ tắt đèn, 37 giờ bật RGB","variants":[{"name":"Màu Đen","price":3290000,"original_price":3890000,"stock":15,"image":"https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Trắng","price":3290000,"original_price":3890000,"stock":10,"image":"https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80"]}'
),
(
  87, 5, 'Bàn phím cơ Logitech G915 LIGHTSPEED Wireless', 'logitech-g915-lightspeed', 'Logitech', 4490000, 5290000, 18, 114, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]',
  'Thiết kế Low-profile mỏng thanh thoát khung hợp kim nhôm máy bay, công nghệ LIGHTSPEED 1ms siêu nhanh cho game thủ chuyên nghiệp.',
  '{"Phân loại":"Bàn phím cơ Low-profile","Switch":"GL Tactile / GL Linear Low Profile","Kết nối":"LIGHTSPEED 1ms và Bluetooth","Độ dày":"Chỉ 22mm","variants":[{"name":"Fullsize / GL Tactile - Carbon","price":4490000,"original_price":5290000,"stock":18,"image":"https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]}'
),
(
  88, 5, 'Chuột gaming không dây Razer DeathAdder V3 Pro', 'razer-deathadder-v3-pro', 'Razer', 2990000, 3690000, 22, 151, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80"]',
  'Trọng lượng siêu nhẹ chỉ 63g chuẩn công thái học thuận tay phải, cảm biến quang học Focus Pro 30K DPI cực chuẩn.',
  '{"Phân loại":"Chuột Gaming công thái học","Cảm biến":"Focus Pro 30K Optical Sensor","Switch":"Optical Gen-3 (90 triệu lần nhấn)","Trọng lượng":"63g siêu nhẹ","Pin":"90 giờ","variants":[{"name":"Màu Đen Black","price":2990000,"original_price":3690000,"stock":12,"image":"https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Trắng White","price":2990000,"original_price":3690000,"stock":10,"image":"https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80"]}'
),
(
  89, 5, 'Chuột gaming Razer Viper V3 Pro Không Dây 8000Hz', 'razer-viper-v3-pro', 'Razer', 3890000, 4390000, 20, 188, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80"]',
  'Đi kèm HyperPolling Wireless Dongle hỗ trợ tần số gửi tín hiệu thực 8000Hz, trọng lượng 54g tối ưu cho game thủ bắn súng FPS Valorant/CS2.',
  '{"Phân loại":"Chuột Gaming đối xứng","Polling Rate":"8000Hz True Wireless","Trọng lượng":"54g","Cảm biến":"Focus Pro 35K Gen-2","Pin":"95 giờ","variants":[{"name":"Màu Trắng White","price":3890000,"original_price":4390000,"stock":10,"image":"https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Đen Black","price":3890000,"original_price":4390000,"stock":10,"image":"https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80"]}'
),
(
  90, 5, 'Bàn phím cơ Razer BlackWidow V4 Pro', 'razer-blackwidow-v4-pro', 'Razer', 5490000, 6190000, 15, 225, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]',
  'Núm xoay Razer Command Dial đa năng, dải đèn LED Underglow phát sáng 3 mặt quanh bàn phím và đệm kê tay nam châm da êm ái.',
  '{"Phân loại":"Bàn phím cơ Fullsize Gaming","Switch":"Razer Green Clicky / Yellow Linear","Polling Rate":"8000Hz HyperPolling","Đèn nền":"Razer Chroma RGB từng phím + Underglow","variants":[{"name":"Green Switch (Gõ tiếng đanh)","price":5490000,"original_price":6190000,"stock":8,"image":"https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80"},{"name":"Yellow Switch (Gõ mượt im lặng)","price":5490000,"original_price":6190000,"stock":7,"image":"https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]}'
),
(
  91, 5, 'Tai nghe gaming không dây Razer BlackShark V2 Pro (2023)', 'razer-blackshark-v2-pro-2023', 'Razer', 4490000, 5190000, 24, 262, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1600080972464-8e5f35f63d08?auto=format&fit=crop&w=800&q=80"]',
  'Micro Razer HyperClear Super Wideband chất lượng phát thanh chuyên nghiệp, màng loa TriForce Titanium 50mm định vị tiếng bước chân chuẩn xác.',
  '{"Phân loại":"Tai nghe Gaming Esports","Driver":"TriForce Titanium 50mm","Micro":"HyperClear Super Wideband tháo rời","Pin":"70 giờ chơi game liên tục","variants":[{"name":"Màu Đen Black","price":4490000,"original_price":5190000,"stock":14,"image":"https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Trắng White","price":4490000,"original_price":5190000,"stock":10,"image":"https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1600080972464-8e5f35f63d08?auto=format&fit=crop&w=800&q=80"]}'
),
(
  92, 5, 'Bàn phím cơ ASUS ROG Azoth Wireless 75%', 'asus-rog-azoth', 'Asus', 5990000, 6790000, 16, 299, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]',
  'Màn hình OLED 2 inch hiển thị thông số CPU/GPU và ảnh động GIF, cấu trúc đệm silicon gasket 3 lớp cùng bộ kit tra dầu lube switch đi kèm hộp.',
  '{"Phân loại":"Bàn phím cơ cao cấp 75%","Màn hình":"OLED 2 inch tích hợp núm gạt 3 chiều","Switch":"ROG NX Hotswap prelube","Kết nối":"SpeedNova 2.4GHz + BT + Dây","Pin":"Hơn 2000 giờ tắt OLED","variants":[{"name":"ROG NX Snow Switch (Linear êm)","price":5990000,"original_price":6790000,"stock":10,"image":"https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80"},{"name":"ROG NX Storm Switch (Clicky)","price":5990000,"original_price":6790000,"stock":6,"image":"https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]}'
),
(
  93, 5, 'Chuột gaming ASUS ROG Harpe Ace Aim Lab Edition', 'asus-rog-harpe-ace', 'Asus', 2990000, 3590000, 20, 336, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80"]',
  'Hợp tác phát triển cùng các chuyên gia Aim Lab, vỏ làm từ chất liệu nylon sinh học siêu nhẹ 54g tối ưu vẩy chuột phản xạ.',
  '{"Phân loại":"Chuột Gaming bắn súng FPS","Trọng lượng":"54g siêu nhẹ","Cảm biến":"ROG AimPoint 36.000 DPI","Kết nối":"ROG SpeedNova Wireless","variants":[{"name":"Màu Đen Black","price":2990000,"original_price":3590000,"stock":12,"image":"https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Trắng Moonlight White","price":2990000,"original_price":3590000,"stock":8,"image":"https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80"]}'
),
(
  94, 5, 'Bàn phím cơ SteelSeries Apex Pro TKL Wireless (2023)', 'steelseries-apex-pro-tkl-wireless', 'SteelSeries', 5990000, 6890000, 15, 373, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]',
  'Switch từ tính OmniPoint 2.0 cảm ứng lực từ trường Hall Effect, cho phép tùy chỉnh điểm nhận phím siêu nhạy từ 0.2mm đến 3.8mm và tính năng Rapid Trigger.',
  '{"Phân loại":"Bàn phím từ tính Rapid Trigger","Switch":"OmniPoint 2.0 Adjustable Hall Effect","Màn hình":"OLED Smart Display góc trên","Khung":"Nhôm Series 5000 chuẩn hàng không","variants":[{"name":"Bản Không Dây Wireless TKL Đen","price":5990000,"original_price":6890000,"stock":15,"image":"https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]}'
),
(
  95, 5, 'Chuột gaming SteelSeries Aerox 3 Wireless', 'steelseries-aerox-3-wireless', 'SteelSeries', 1890000, 2490000, 30, 60, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80"]',
  'Thiết kế tổ ong thoáng khí siêu nhẹ 68g, công nghệ AquaBarrier kháng nước bụi chuẩn IP54 bảo vệ mạch điện an toàn.',
  '{"Phân loại":"Chuột Gaming tổ ong","Trọng lượng":"68g","Kháng nước":"IP54 AquaBarrier","Pin":"200 giờ sử dụng","Cảm biến":"TrueMove Air","variants":[{"name":"Màu Đen Onyx","price":1890000,"original_price":2490000,"stock":18,"image":"https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Trắng Snow","price":1890000,"original_price":2490000,"stock":12,"image":"https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80"]}'
),
(
  96, 5, 'Bàn phím cơ Corsair K70 RGB PRO', 'corsair-k70-rgb-pro', 'Corsair', 3490000, 4190000, 22, 97, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]',
  'Công nghệ siêu xử lý CORSAIR AXON truyền tín hiệu tốc độ 8.000Hz, công tắc Tournament Switch chuyên dụng thi đấu eSports chuyên nghiệp.',
  '{"Phân loại":"Bàn phím cơ Fullsize có dây","Switch":"Cherry MX Red / Speed Silver","Tốc độ":"AXON Hyper-Processing 8000Hz","Khung":"Nhôm phay xước","variants":[{"name":"Cherry MX Red Switch","price":3490000,"original_price":4190000,"stock":12,"image":"https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80"},{"name":"Cherry MX Speed Silver Switch","price":3590000,"original_price":4290000,"stock":10,"image":"https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]}'
),
(
  97, 5, 'Chuột gaming Corsair Dark Core RGB PRO SE', 'corsair-dark-core-rgb-pro-se', 'Corsair', 2390000, 2890000, 25, 134, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80"]',
  'Hỗ trợ sạc không dây chuẩn Qi tiện lợi, kết nối SLIPSTREAM WIRELESS dưới 1ms cùng 8 nút bấm gán macro tùy biến thoải mái.',
  '{"Phân loại":"Chuột Gaming đa dụng","Cảm biến":"PixArt PAW3392 18.000 DPI","Sạc":"Hỗ trợ sạc không dây Qi + Type-C","Pin":"50 giờ","variants":[{"name":"Màu Đen Black","price":2390000,"original_price":2890000,"stock":25,"image":"https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80"]}'
),
(
  98, 5, 'Tai nghe gaming không dây HyperX Cloud III Wireless', 'hyperx-cloud-iii-wireless', 'HyperX', 3690000, 4390000, 28, 171, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1600080972464-8e5f35f63d08?auto=format&fit=crop&w=800&q=80"]',
  'Huyền thoại êm ái với đệm tai mút hoạt tính bọc da cao cấp, thời lượng pin kinh ngạc lên đến 120 giờ chỉ với một lần sạc đầy.',
  '{"Phân loại":"Tai nghe Gaming không dây","Pin":"Khủng 120 giờ","Màng loa":"53mm góc nghiêng tái tạo âm thanh vòm DTS:X","Khung":"Kim loại bền bỉ","variants":[{"name":"Màu Đen Đỏ Black/Red","price":3690000,"original_price":4390000,"stock":18,"image":"https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Đen Tuyền Black","price":3690000,"original_price":4390000,"stock":10,"image":"https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1600080972464-8e5f35f63d08?auto=format&fit=crop&w=800&q=80"]}'
),
(
  99, 5, 'Tay cầm không dây Sony DualSense Edge Wireless', 'sony-dualsense-edge', 'Sony', 4990000, 5490000, 16, 208, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]',
  'Tay cầm chuyên nghiệp cao cấp cho game thủ PS5 và PC, cần analog có thể tháo rời thay thế độc lập, nút bấm phía sau gán lại tức thì.',
  '{"Phân loại":"Tay cầm chơi game Pro Controller","Tính năng":"Haptic Feedback, Adaptive Triggers, Khóa hành trình cò trigger","Cần Analog":"Mô-đun tháo rời thay thế","variants":[{"name":"Bản Đen Trắng Kèm Hộp Đựng Vali Chống Sốc","price":4990000,"original_price":5490000,"stock":16,"image":"https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]}'
),
(
  100, 5, 'Bộ điều khiển Elgato Stream Deck MK.2', 'elgato-stream-deck-mk2', 'Elgato', 3490000, 3990000, 25, 245, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]',
  '15 phím LCD tùy biến hình ảnh động không giới hạn, kích hoạt hành động phát trực tiếp, điều khiển OBS, âm thanh chỉ với một nút bấm.',
  '{"Phân loại":"Bàn điều khiển Streamer / Sáng tạo nội dung","Phím bấm":"15 phím LCD tương tác màu sắc","Kết nối":"Cáp rời Type-C sang Type-A","Chân đế":"Góc nghiêng 45 độ","variants":[{"name":"Màu Đen Black","price":3490000,"original_price":3990000,"stock":15,"image":"https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Trắng White","price":3490000,"original_price":3990000,"stock":10,"image":"https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=800&q=80"]}'
);

-- ----------------------------------------------------------
-- 4.6. DANH MỤC 6: ĐỒNG HỒ THÔNG MINH (20 SẢN PHẨM)
-- ----------------------------------------------------------
INSERT INTO `products` (
  `id`, `category_id`, `name`, `slug`, `brand`, 
  `price`, `original_price`, `stock`, `sold_count`, `rating`, `reviews_count`, `featured`, 
  `image_url`, 
  `images`, 
  `short_description`, 
  `specifications`
) VALUES
(
  101, 6, 'Apple Watch Ultra 2 GPS + Cellular 49mm', 'apple-watch-ultra-2', 'Apple', 19990000, 21990000, 20, 820, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]',
  'Vỏ Titan bền bỉ chuẩn quân đội, màn hình sáng kỷ lục 3000 nits, định vị GPS tần số kép chính xác cao cho dân thám hiểm và chạy marathon.',
  '{"Màn hình":"49mm Always-On Retina LTPO OLED 3000 nits","Chip":"Apple S9 SiP (thao tác chạm đúp Double Tap)","Chất liệu":"Titanium cấp hàng không","Chống nước":"WR100 (lặn sâu 40m tiêu chuẩn EN13319)","Pin":"36 giờ (tiết kiệm 72 giờ)","variants":[{"name":"Dây Vải Trail Loop - Cam/Xám","price":19990000,"original_price":21990000,"stock":10,"image":"https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"},{"name":"Dây Cao Su Ocean Band - Xanh Dương","price":19990000,"original_price":21990000,"stock":6,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"},{"name":"Dây Dệt Alpine Loop - Xanh Rêu","price":19990000,"original_price":21990000,"stock":4,"image":"https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]}'
),
(
  102, 6, 'Apple Watch Series 9 GPS 45mm Viền Nhôm', 'apple-watch-s9-45mm', 'Apple', 10490000, 11990000, 35, 319, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"]',
  'Chip Apple S9 siêu mượt, màn hình sáng gấp 2 lần Series 8 lên đến 2000 nits, cử chỉ chạm đúp Double Tap trả lời cuộc gọi rảnh tay.',
  '{"Màn hình":"45mm Retina OLED Always-On 2000 nits","Chip":"Apple S9 SiP 64-bit 4 nhân Neural Engine","Tính năng":"Đo điện tâm đồ ECG, SpO2, Cảm biến nhiệt độ","Pin":"18 giờ (tiết kiệm 36 giờ)","variants":[{"name":"Màu Đen Midnight - Dây Thể Thao M/L","price":10490000,"original_price":11990000,"stock":20,"image":"https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Ánh Sao Starlight - Dây Thể Thao S/M","price":10490000,"original_price":11990000,"stock":15,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"]}'
),
(
  103, 6, 'Apple Watch Series 9 GPS 41mm Viền Nhôm', 'apple-watch-s9-41mm', 'Apple', 9490000, 10990000, 30, 356, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"]',
  'Kích cỡ 41mm thanh lịch vừa vặn cổ tay nữ giới, theo dõi chu kỳ rụng trứng chuyên sâu và phát hiện va chạm xe hơi khẩn cấp SOS.',
  '{"Màn hình":"41mm Retina OLED 2000 nits","Chip":"Apple S9 SiP","Kháng nước":"WR50 (bơi lội 50m)","Tính năng":"Chạm đúp Double Tap, Siri trên thiết bị","variants":[{"name":"Màu Hồng Pink - Dây Thể Thao","price":9490000,"original_price":10990000,"stock":18,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Bạc Silver - Dây Thể Thao","price":9490000,"original_price":10990000,"stock":12,"image":"https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"]}'
),
(
  104, 6, 'Apple Watch SE 2023 GPS 44mm Viền Nhôm', 'apple-watch-se-44mm', 'Apple', 6890000, 7690000, 40, 393, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"]',
  'Lựa chọn thông minh cho người mới làm quen Apple Watch, đầy đủ tính năng theo dõi sức khỏe, cảnh báo té ngã và hỗ trợ tập luyện thể thao.',
  '{"Màn hình":"44mm Retina OLED 1000 nits","Chip":"Apple S8 SiP","Mặt lưng":"Vật liệu composite nylon tái chế","Chống nước":"50m","variants":[{"name":"Màu Đen Midnight","price":6890000,"original_price":7690000,"stock":25,"image":"https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Bạc Silver","price":6890000,"original_price":7690000,"stock":15,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"]}'
),
(
  105, 6, 'Apple Watch SE 2023 GPS 40mm Viền Nhôm', 'apple-watch-se-40mm', 'Apple', 5990000, 6690000, 45, 80, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"]',
  'Chiếc Apple Watch giá mềm nhất, kích cỡ 40mm thanh mảnh nhẹ nhàng, bảo vệ bạn cả ngày với tính năng nhịp tim bất thường.',
  '{"Màn hình":"40mm Retina OLED","Chip":"Apple S8 SiP","Tính năng":"Theo dõi giấc ngủ, phát hiện va chạm","Pin":"18 giờ","variants":[{"name":"Màu Ánh Sao Starlight","price":5990000,"original_price":6690000,"stock":25,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Đen Midnight","price":5990000,"original_price":6690000,"stock":20,"image":"https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"]}'
),
(
  106, 6, 'Samsung Galaxy Watch 6 Classic 47mm LTE', 'samsung-galaxy-watch-6-classic', 'Samsung', 7990000, 9490000, 25, 117, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]',
  'Vòng xoay bezel vật lý đặc trưng lịch lãm, kết nối eSIM độc lập nghe gọi không cần điện thoại, đo điện tâm đồ ECG và huyết áp.',
  '{"Màn hình":"1.5 inch Super AMOLED kính Sapphire","Chip":"Exynos W930 Dual Core 1.4GHz","Kết nối":"4G LTE eSIM độc lập + GPS","Chống nước":"5ATM + IP68 / MIL-STD-810H","Tính năng":"Đo ECG, Huyết áp, BIA","variants":[{"name":"47mm LTE - Màu Đen Black","price":7990000,"original_price":9490000,"stock":15,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"},{"name":"47mm LTE - Màu Bạc Silver","price":7990000,"original_price":9490000,"stock":10,"image":"https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]}'
),
(
  107, 6, 'Samsung Galaxy Watch 6 Classic 43mm Bluetooth', 'galaxy-watch-6-classic-43mm', 'Samsung', 6490000, 7990000, 22, 154, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80"]',
  'Kích cỡ 43mm phù hợp đa số kích thước cổ tay, viền xoay cơ khí cổ điển và huấn luyện viên theo dõi giấc ngủ cá nhân hóa.',
  '{"Màn hình":"1.3 inch Super AMOLED kính Sapphire chống xước","Chip":"Exynos W930","RAM":"2GB","Bộ nhớ trong":"16GB","Pin":"300 mAh, Sạc không dây nhanh","variants":[{"name":"43mm Bluetooth - Màu Đen","price":6490000,"original_price":7990000,"stock":12,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"},{"name":"43mm Bluetooth - Màu Bạc","price":6490000,"original_price":7990000,"stock":10,"image":"https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80"]}'
),
(
  108, 6, 'Samsung Galaxy Watch 6 44mm Bluetooth', 'galaxy-watch-6-44mm', 'Samsung', 5490000, 6990000, 30, 191, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"]',
  'Viền màn hình vát mỏng hơn 20%, diện tích hiển thị tăng 20% so với thế hệ trước, theo dõi 95+ chế độ tập luyện thể dục thể thao.',
  '{"Màn hình":"1.5 inch Super AMOLED 2000 nits kính Sapphire","Chất liệu":"Nhôm Armor Aluminum","Cảm biến":"BioActive 3 trong 1 (Quang học + Điện tim + BIA)","Pin":"425 mAh","variants":[{"name":"44mm - Màu Xám Graphite","price":5490000,"original_price":6990000,"stock":18,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"},{"name":"44mm - Màu Bạc Silver","price":5490000,"original_price":6990000,"stock":12,"image":"https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"]}'
),
(
  109, 6, 'Samsung Galaxy Watch 6 40mm Bluetooth', 'galaxy-watch-6-40mm', 'Samsung', 4790000, 5990000, 35, 228, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"]',
  'Thiết kế tối giản siêu nhẹ chỉ 28.7g, thay dây nhanh chỉ với 1 nút bấm One-Click thông minh, nhiều mặt đồng hồ cá tính.',
  '{"Màn hình":"1.3 inch Super AMOLED kính Sapphire","Trọng lượng":"28.7g","Chống nước":"5ATM + IP68","Tính năng":"Theo dõi chu kỳ, Phân tích thành phần mỡ cơ BIA","variants":[{"name":"40mm - Màu Vàng Gold Kem","price":4790000,"original_price":5990000,"stock":20,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"40mm - Màu Xám Graphite","price":4790000,"original_price":5990000,"stock":15,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"]}'
),
(
  110, 6, 'Samsung Galaxy Watch 5 Pro 45mm Titan', 'galaxy-watch-5-pro', 'Samsung', 6990000, 11990000, 20, 265, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80"]',
  'Viên pin khổng lồ 590mAh dùng liên tục 3 ngày, khung vỏ Titanium bền bỉ, tính năng dẫn đường Track Back quay lại điểm xuất phát bằng GPS.',
  '{"Màn hình":"1.4 inch Super AMOLED Kính Sapphire siêu cứng","Chất liệu":"Titanium nguyên khối","Pin":"590 mAh (lên đến 80 giờ)","Tính năng":"Chỉ đường ngã rẽ GPX, Track Back","variants":[{"name":"45mm Titan Đen - Dây Khóa Từ Tính D-Buckle","price":6990000,"original_price":11990000,"stock":12,"image":"https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"},{"name":"45mm Titan Xám - Dây Khóa D-Buckle","price":6990000,"original_price":11990000,"stock":8,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80"]}'
),
(
  111, 6, 'Garmin Fenix 7 Pro Sapphire Solar 47mm', 'garmin-fenix-7-pro-solar', 'Garmin', 21490000, 23990000, 15, 302, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"]',
  'Sạc pin bằng năng lượng mặt trời Power Sapphire, đèn pin LED tích hợp trên thân đồng hồ, bản đồ địa hình Topo đa lục địa chi tiết.',
  '{"Màn hình":"1.3 inch MIP chống chói sạc năng lượng mặt trời","Chất liệu":"Titan viền DLC + Kính Sapphire","Pin":"22 ngày chế độ thông minh (nhờ mặt trời)","Đèn pin":"Tích hợp đèn LED đa chế độ","Chống nước":"10 ATM (100m)","variants":[{"name":"Titan Phủ Carbon Đen DLC - Dây Silicon","price":21490000,"original_price":23990000,"stock":15,"image":"https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"]}'
),
(
  112, 6, 'Garmin Epix Pro (Gen 2) Sapphire 47mm', 'garmin-epix-pro-gen-2', 'Garmin', 23990000, 26990000, 12, 339, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"]',
  'Màn hình AMOLED rực rỡ sắc nét kết hợp độ bền chuẩn quân sự Hoa Kỳ, cảm biến nhịp tim Elevate Gen 5 đo cực kỳ chuẩn xác.',
  '{"Màn hình":"1.3 inch AMOLED 416 x 416 pixels Kính Sapphire","Khung viền":"Titanium","Pin":"16 ngày (6 ngày Always-on)","Tính năng":"Đo điểm leo dốc Hill Score, Độ bền Endurance Score","variants":[{"name":"Titan Xám Carbon - Kèm Đèn Pin LED","price":23990000,"original_price":26990000,"stock":12,"image":"https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"]}'
),
(
  113, 6, 'Garmin Forerunner 965 AMOLED', 'garmin-forerunner-965', 'Garmin', 15490000, 16990000, 22, 376, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80"]',
  'Chiếc đồng hồ 3 môn phối hợp (Triathlon) đỉnh cao cho chân chạy bộ chuyên nghiệp, màn hình AMOLED 1.4 inch cùng bản đồ màu dẫn đường.',
  '{"Màn hình":"1.4 inch AMOLED cảm ứng Kính Gorilla Glass DX","Khung viền":"Titanium siêu nhẹ","Trọng lượng":"53g","Pin":"23 ngày chế độ đồng hồ, 31 giờ GPS","Chỉ số":"Động lực học chạy bộ, Tải luyện tập cấp tính","variants":[{"name":"Màu Đen Viền Titan Xám","price":15490000,"original_price":16990000,"stock":12,"image":"https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Vàng Amp Yellow Nổi Bật","price":15490000,"original_price":16990000,"stock":10,"image":"https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80"]}'
),
(
  114, 6, 'Garmin Forerunner 265 Music 46mm', 'garmin-forerunner-265', 'Garmin', 10990000, 11990000, 25, 63, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]',
  'Màn hình AMOLED cảm ứng sắc nét, đề xuất bài tập chạy hàng ngày cá nhân hóa, đo lường mức độ sẵn sàng luyện tập Training Readiness.',
  '{"Màn hình":"1.3 inch AMOLED Always-On","Tính năng":"Bộ nhớ lưu nhạc Spotify ngoại tuyến","Pin":"13 ngày","Trọng lượng":"47g siêu nhẹ","variants":[{"name":"Màu Đen Dây Xám","price":10990000,"original_price":11990000,"stock":15,"image":"https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Trắng Dây Xanh Aqua","price":10990000,"original_price":11990000,"stock":10,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]}'
),
(
  115, 6, 'Garmin Venu 3 GPS Chăm Sóc Sức Khỏe', 'garmin-venu-3', 'Garmin', 11990000, 12990000, 20, 100, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"]',
  'Tích hợp loa ngoài và micro đàm thoại cuộc gọi trực tiếp, tính năng Huấn luyện viên giấc ngủ Sleep Coach và phát hiện giấc ngủ ngắn Nap.',
  '{"Màn hình":"1.4 inch AMOLED rực rỡ","Đàm thoại":"Loa ngoài + Micro nghe gọi","Pin":"14 ngày","Tính năng":"Chế độ người dùng xe lăn Wheelchair Mode, Body Battery","variants":[{"name":"Venu 3 45mm - Màu Đen","price":11990000,"original_price":12990000,"stock":12,"image":"https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"},{"name":"Venu 3S 41mm - Màu Trắng Vàng French Gray","price":11990000,"original_price":12990000,"stock":8,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"]}'
),
(
  116, 6, 'Huawei Watch GT 4 46mm Dây Da Nâu', 'huawei-watch-gt-4-46mm', 'Huawei', 5490000, 6490000, 35, 137, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]',
  'Thiết kế góc cạnh hình học Bát giác bát phong độc nhất vô nhị, thời lượng pin trâu bò lên đến 14 ngày, theo dõi lượng calo Stay Fit.',
  '{"Màn hình":"1.43 inch AMOLED 466 x 466 pixels","Chất liệu":"Thép không gỉ + Dây da thật cao cấp","Pin":"Lên đến 14 ngày (sử dụng thông thường 8 ngày)","Chống nước":"5 ATM","variants":[{"name":"46mm - Dây Da Nâu Cổ Điển","price":5490000,"original_price":6490000,"stock":20,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"},{"name":"46mm - Dây Thép Không Gỉ Bạc","price":6990000,"original_price":7990000,"stock":15,"image":"https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]}'
),
(
  117, 6, 'Huawei Watch GT 4 41mm Mặt Tròn Thanh Lịch', 'huawei-watch-gt-4-41mm', 'Huawei', 4990000, 5990000, 30, 174, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"]',
  'Mặt đồng hồ tròn mạ vàng quý phái tựa như món trang sức xa xỉ, quản lý sức khỏe phụ nữ thông minh và phân tích hô hấp khi ngủ.',
  '{"Màn hình":"1.32 inch AMOLED","Thiết kế":"Khuyên dây dạng vòng nhẫn ngọc trai","Pin":"7 ngày","Trọng lượng":"37g mỏng nhẹ","variants":[{"name":"41mm - Dây Da Trắng","price":4990000,"original_price":5990000,"stock":18,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"41mm - Dây Kim Loại Milanese Vàng","price":6490000,"original_price":7490000,"stock":12,"image":"https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"]}'
),
(
  118, 6, 'Huawei Watch Ultimate Titan Thám Hiểm Lặn', 'huawei-watch-ultimate', 'Huawei', 16990000, 19990000, 12, 211, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80"]',
  'Chất liệu kim loại lỏng gốc Zirconium siêu cứng bền gấp 4.5 lần titan, chuẩn lặn kỹ thuật chuyên nghiệp sâu 100m chuẩn ISO 22810.',
  '{"Khung vỏ":"Kim loại lỏng gốc Zirconium + Viền gốm Nanotech","Kính":"Sapphire nhân tạo","Kháng nước":"10 ATM (lặn sâu 100m với 4 chế độ lặn)","Pin":"14 ngày","variants":[{"name":"Bản Voyage Xanh Đại Dương Dây Titan","price":16990000,"original_price":19990000,"stock":12,"image":"https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80"]}'
),
(
  119, 6, 'Amazfit GTR 4 Khung Nhôm Nguyên Khối', 'amazfit-gtr-4', 'Amazfit', 4190000, 4990000, 32, 248, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"]',
  'Ăng-ten GPS phân cực tròn băng tần kép đầu tiên, nhận diện bài tập thể hình thông minh và pin bền bỉ 14 ngày sử dụng bình thường.',
  '{"Màn hình":"1.43 inch HD AMOLED chống chói","GPS":"Băng tần kép 6 hệ thống định vị vệ tinh","Pin":"14 ngày (475 mAh)","Chế độ thể thao":"150+ môn thể thao","variants":[{"name":"Màu Đen Siêu Tốc Superspeed Black","price":4190000,"original_price":4990000,"stock":20,"image":"https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Nâu Da Vintage Brown","price":4490000,"original_price":5290000,"stock":12,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"]}'
),
(
  120, 6, 'Suunto 9 Peak Pro Titanium', 'suunto-9-peak-pro-titanium', 'Suunto', 13990000, 15990000, 15, 285, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"]',
  'Chế tác thủ công tại Phần Lan với 100% năng lượng tái tạo, độ mỏng siêu kỷ lục 10.8mm và pin GPS kéo dài 40 giờ liên tục.',
  '{"Chất liệu":"Titanium cấp 5 + Kính Sapphire","Độ dày":"10.8 mm siêu mỏng","Trọng lượng":"55g","Pin":"21 ngày đồng hồ, 40 giờ GPS hiệu năng cao","variants":[{"name":"Titanium Slate Black (Đen)","price":13990000,"original_price":15990000,"stock":15,"image":"https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"]}'
);

-- ----------------------------------------------------------
-- 4.7. DANH MỤC 7: ĐỒNG HỒ TRẺ EM (20 SẢN PHẨM)
-- ----------------------------------------------------------
INSERT INTO `products` (
  `id`, `category_id`, `name`, `slug`, `brand`, 
  `price`, `original_price`, `stock`, `sold_count`, `rating`, `reviews_count`, `featured`, 
  `image_url`, 
  `images`, 
  `short_description`, 
  `specifications`
) VALUES
(
  121, 7, 'Đồng hồ thông minh định vị Viettel MyKID 4G V2', 'viettel-mykid-4g-v2', 'Viettel', 1490000, 1790000, 50, 322, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]',
  'Sản phẩm chính hãng độc quyền từ Tập đoàn Viettel, định vị 3 trong 1 (GPS, LBS, Wifi) cực kỳ chính xác và gọi Video Call sắc nét.',
  '{"Màn hình":"1.4 inch cảm ứng màu sắc nét","Định vị":"3 chip GPS + LBS + Wifi","Tính năng":"Gọi Video Call 4G, Vùng an toàn, Nút SOS khẩn cấp","Kháng nước":"IP68 chống ngập nước an toàn khi rửa tay đi mưa","Pin":"Dùng 2-3 ngày","variants":[{"name":"Màu Xanh Năng Động (Bé trai)","price":1490000,"original_price":1790000,"stock":25,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Hồng Dễ Thương (Bé gái)","price":1490000,"original_price":1790000,"stock":25,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]}'
),
(
  122, 7, 'Đồng hồ định vị Viettel Kiddy 2 Touch', 'viettel-kiddy-2-touch', 'Viettel', 1290000, 1590000, 40, 359, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"]',
  'Giao diện tiếng Việt đơn giản cho trẻ nhỏ, chặn số lạ không có trong danh bạ, cài đặt chế độ lớp học không làm phiền bé học bài.',
  '{"Màn hình":"1.3 inch cảm ứng điện dung","Sim":"Nano Sim 4G Viettel","Tính năng":"Gọi thoại 2 chiều, Nghe lén giám sát môi trường xung quanh, Gửi tin nhắn thoại","Pin":"Pin dung lượng cao 500mAh","variants":[{"name":"Màu Xanh Dương","price":1290000,"original_price":1590000,"stock":20,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Hồng Pastel","price":1290000,"original_price":1590000,"stock":20,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"]}'
),
(
  123, 7, 'Đồng hồ định vị Viettel Kiddy Plus 4G', 'viettel-kiddy-plus-4g', 'Viettel', 1690000, 1990000, 35, 46, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"]',
  'Bản nâng cấp cao cấp với camera trước góc rộng 2MP, chụp ảnh từ xa bí mật và tự động ghi lại lịch sử hành trình bé di chuyển trong 3 tháng.',
  '{"Màn hình":"1.44 inch IPS màu","Camera":"2.0 MP hỗ trợ chụp ảnh lén từ xa qua App bố mẹ","Tính năng":"Hàng rào điện tử cảnh báo khi bé rời trường học","Pin":"680mAh dùng 3-4 ngày","variants":[{"name":"Màu Xanh Đậm","price":1690000,"original_price":1990000,"stock":20,"image":"https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Hồng Kẹo","price":1690000,"original_price":1990000,"stock":15,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"]}'
),
(
  124, 7, 'Đồng hồ thông minh trẻ em Wonlex KT24S 4G Video Call', 'wonlex-kt24s-4g', 'Wonlex', 1350000, 1650000, 45, 83, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"]',
  'Thương hiệu đồng hồ trẻ em bán chạy hàng đầu, hỗ trợ Video Call HD cực nét qua Wifi/4G, dây đeo silicon kháng khuẩn an toàn da tay bé.',
  '{"Màn hình":"1.4 inch OGS chống lóa","Định vị":"GPS + AGPS + LBS + Wifi đa kênh","Kháng nước":"IP67","Trọng lượng":"50g siêu nhẹ","Tính năng":"Gọi SOS 3 số khẩn cấp liên hoàn","variants":[{"name":"Màu Xanh Biển","price":1350000,"original_price":1650000,"stock":25,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Hồng Phấn","price":1350000,"original_price":1650000,"stock":20,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"]}'
),
(
  125, 7, 'Đồng hồ thông minh trẻ em Wonlex KT15 4G Chống nước', 'wonlex-kt15-4g', 'Wonlex', 1450000, 1750000, 35, 120, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"]',
  'Khả năng kháng nước chuẩn IP67 cho bé thoải mái nghịch nước bơi lội nông, chế độ thể thao đếm bước chân rèn luyện sức khỏe.',
  '{"Màn hình":"1.4 inch cảm ứng điện dung","Chống nước":"IP67 chuẩn quốc tế","Pin":"680 mAh","Camera":"0.3 MP","variants":[{"name":"Màu Đen Phối Đỏ","price":1450000,"original_price":1750000,"stock":18,"image":"https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Xanh Ngọc","price":1450000,"original_price":1750000,"stock":17,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"]}'
),
(
  126, 7, 'Đồng hồ định vị trẻ em Wonlex CT11 4G Rung chuông', 'wonlex-ct11-4g', 'Wonlex', 1250000, 1550000, 30, 157, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"]',
  'Tính năng rung chuông báo thông minh khi có cuộc gọi đến, giúp bé không bỏ lỡ điện thoại của bố mẹ ngay cả khi đang vui chơi ồn ào.',
  '{"Màn hình":"1.4 inch IPS","Rung":"Có mô-tơ rung vật lý độc lập","Kết nối":"4G VoLTE đàm thoại âm thanh trong trẻo","Pin":"650 mAh","variants":[{"name":"Màu Xanh Lá","price":1250000,"original_price":1550000,"stock":15,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Hồng Tím","price":1250000,"original_price":1550000,"stock":15,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"]}'
),
(
  127, 7, 'Đồng hồ thông minh trẻ em Wonlex KT17 4G', 'wonlex-kt17-4g', 'Wonlex', 1550000, 1890000, 25, 194, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"]',
  'Thân máy siêu mỏng chỉ 12.7mm, viền bo tròn mềm mại không cấn tay, cảm biến tháo rời thông báo ngay khi bé tháo đồng hồ.',
  '{"Màn hình":"1.4 inch IPS màu","Độ mỏng":"12.7 mm","Tính năng":"Cảnh báo tháo đồng hồ, Khóa máy từ xa","Pin":"700 mAh","variants":[{"name":"Màu Đen Thể Thao","price":1550000,"original_price":1890000,"stock":13,"image":"https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Hồng Công Chúa","price":1550000,"original_price":1890000,"stock":12,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"]}'
),
(
  128, 7, 'Đồng hồ định vị trẻ em Masstel Smart Hero 20 4G', 'masstel-smart-hero-20', 'Masstel', 1590000, 1890000, 40, 231, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"]',
  'Hàng chính hãng bảo hành 12 tháng tại các trung tâm trên toàn quốc, camera HD 2MP sắc nét, hỗ trợ kết nối mạng 4G mọi nhà mạng.',
  '{"Màn hình":"1.4 inch TFT 240x240","Camera":"2.0 MP quay video call HD","Pin":"720 mAh thời lượng pin 72 giờ","Định vị":"GPS/LBS/Wifi chuẩn xác","variants":[{"name":"Màu Xanh Dương Năng Động","price":1590000,"original_price":1890000,"stock":20,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Cam Đậm Nổi Bật","price":1590000,"original_price":1890000,"stock":20,"image":"https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"]}'
),
(
  129, 7, 'Đồng hồ định vị trẻ em Masstel Smart Hero 10', 'masstel-smart-hero-10', 'Masstel', 1190000, 1390000, 35, 268, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]',
  'Mức giá phổ thông dễ tiếp cận cho mọi gia đình, tích hợp trò chơi toán học rèn luyện trí tuệ, danh bạ quản lý 15 số người thân.',
  '{"Màn hình":"1.4 inch cảm ứng màu","Pin":"600 mAh","Tính năng":"Nghe gọi 2 chiều, SOS khẩn cấp, Game toán học","Sim":"Micro Sim 4G","variants":[{"name":"Màu Xanh Da Trời","price":1190000,"original_price":1390000,"stock":20,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Hồng Dâu","price":1190000,"original_price":1390000,"stock":15,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]}'
),
(
  130, 7, 'Đồng hồ định vị Masstel Dream Hero 4G', 'masstel-dream-hero-4g', 'Masstel', 1790000, 2090000, 30, 305, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"]',
  'Thiết kế cao cấp khung viền kim loại bảo vệ màn hình chống va đập rơi vỡ, đạt chứng nhận an toàn sóng từ cho não bộ trẻ nhỏ.',
  '{"Màn hình":"1.4 inch IPS kính cường lực 2.5D","Kháng nước":"IP68","Pin":"800 mAh khủng","Định vị":"GPS thời gian thực","variants":[{"name":"Màu Xanh Vũ Trụ","price":1790000,"original_price":2090000,"stock":15,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Tím Ngân Hà","price":1790000,"original_price":2090000,"stock":15,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"]}'
),
(
  131, 7, 'Đồng hồ thông minh trẻ em Kidcare S8 4G', 'kidcare-s8-4g', 'Kidcare', 2190000, 2590000, 28, 342, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]',
  'Camera kép trước và cạnh hông xoay góc 90 độ, giúp bố mẹ dễ dàng quan sát toàn diện môi trường quanh con từ xa trên điện thoại.',
  '{"Màn hình":"1.4 inch TFT màu sắc sống động","Camera":"Camera kép 2MP xoay góc linh hoạt","Tính năng":"Video Call 4G kép, Định vị LBS/GPS/Wifi","Pin":"850 mAh","variants":[{"name":"Màu Xanh Biển Sâu","price":2190000,"original_price":2590000,"stock":14,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Đen Hồng Nổi Bật","price":2190000,"original_price":2590000,"stock":14,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]}'
),
(
  132, 7, 'Đồng hồ thông minh trẻ em Kidcare S6 4G', 'kidcare-s6-4g', 'Kidcare', 1690000, 1990000, 32, 379, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"]',
  'Định vị chuẩn xác với sai số dưới 10m ở khu vực thoáng đãng, cảnh báo ngay khi pin yếu dưới 20% về điện thoại phụ huynh.',
  '{"Màn hình":"1.3 inch cảm ứng mượt mà","Pin":"700 mAh","Kháng nước":"IP67 an toàn dưới trời mưa","Tính năng":"Nhắn tin thoại bí mật","variants":[{"name":"Màu Xanh Dương","price":1690000,"original_price":1990000,"stock":16,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Hồng","price":1690000,"original_price":1990000,"stock":16,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"]}'
),
(
  133, 7, 'Đồng hồ thông minh trẻ em Kidcare Sight Plus', 'kidcare-sight-plus', 'Kidcare', 1490000, 1790000, 30, 66, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"]',
  'Giao diện hình thú cưng hoạt hình ngộ nghĩnh, tính năng thưởng sao điểm tích lũy khích lệ tinh thần học tập và làm việc nhà của bé.',
  '{"Màn hình":"1.4 inch màu","Tính năng":"Tặng sao khen thưởng, Báo thức học bài, Đếm bước đi","Pin":"650 mAh","variants":[{"name":"Màu Vàng Chanh Trẻ Trung","price":1490000,"original_price":1790000,"stock":15,"image":"https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Xanh Dương","price":1490000,"original_price":1790000,"stock":15,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"]}'
),
(
  134, 7, 'Đồng hồ định vị trẻ em Huawei Watch Kids 4 Pro', 'huawei-watch-kids-4-pro', 'Huawei', 2990000, 3490000, 20, 103, 5.0, 12, 1,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"]',
  'Đỉnh cao công nghệ đồng hồ trẻ em: Camera HD 5MP góc siêu rộng 85 độ, đèn LED an toàn ban đêm nhấp nháy khi bé băng qua đường.',
  '{"Màn hình":"1.41 inch AMOLED sắc nét bảo vệ mắt","Camera":"5.0 MP góc siêu rộng 85°","Chống nước":"50 mét chuẩn bơi lội (5 ATM)","Đèn LED":"Đèn an toàn ban đêm","Sạc":"Sạc nhanh 20 phút dùng cả ngày","variants":[{"name":"Màu Xanh Đại Dương Deep Blue","price":2990000,"original_price":3490000,"stock":10,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Hồng Ánh Hồng Pink","price":2990000,"original_price":3490000,"stock":10,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=800&q=80"]}'
),
(
  135, 7, 'Đồng hồ trẻ em Oaxis myFirst Fone R1s 4G', 'oaxis-myfirst-fone-r1s', 'myFirst', 3190000, 3690000, 18, 140, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]',
  'Thương hiệu Singapore cao cấp tích hợp máy nghe nhạc MP3 8GB lưu 1500 bài hát, theo dõi nhịp tim thông minh và loa ngoài siêu to.',
  '{"Màn hình":"1.3 inch TFT tròn cổ điển","Bộ nhớ trong":"8GB lưu nhạc nghe qua loa hoặc tai nghe","Cảm biến":"Cảm biến đo nhịp tim liên tục","Kháng nước":"IPX8","variants":[{"name":"Màu Xanh Navy Space","price":3190000,"original_price":3690000,"stock":9,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Kẹo Bông Gòn Cotton Candy","price":3190000,"original_price":3690000,"stock":9,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]}'
),
(
  136, 7, 'Đồng hồ trẻ em Oaxis myFirst Fone S3', 'oaxis-myfirst-fone-s3', 'myFirst', 2590000, 2990000, 22, 177, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"]',
  'Màn hình vuông cảm ứng điện dung 1.4 inch, hỗ trợ cuộc gọi nhóm Video Call gia đình kết nối đồng thời cả bố mẹ và ông bà.',
  '{"Màn hình":"1.4 inch IPS","Tính năng":"Cuộc gọi nhóm Group Call 4G, Chế độ lớp học","Pin":"650 mAh","Trọng lượng":"48g","variants":[{"name":"Màu Xanh Băng Giá","price":2590000,"original_price":2990000,"stock":12,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Tím Pastel","price":2590000,"original_price":2990000,"stock":10,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"]}'
),
(
  137, 7, 'Đồng hồ định vị trẻ em Tuxedo TX-G4C Video Call', 'tuxedo-tx-g4c', 'Tuxedo', 1150000, 1390000, 35, 214, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]',
  'Phần mềm thuần Việt bảo mật máy chủ đặt tại Việt Nam cho tốc độ định vị tức thì, chặn tuyệt đối cuộc gọi lạ làm phiền.',
  '{"Màn hình":"1.4 inch cảm ứng màu","Kết nối":"4G LTE tốc độ cao","Định vị":"Wifi/GPS/LBS","Pin":"600 mAh","variants":[{"name":"Màu Xanh Đậm","price":1150000,"original_price":1390000,"stock":18,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Hồng Sen","price":1150000,"original_price":1390000,"stock":17,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]}'
),
(
  138, 7, 'Đồng hồ trẻ em Tuxedo TX-K9 4G Pin Khủng', 'tuxedo-tx-k9', 'Tuxedo', 1390000, 1690000, 26, 251, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"]',
  'Trang bị viên pin 850mAh cho thời gian chờ lên tới 5-6 ngày, tích hợp đèn pin trợ sáng ban đêm hữu ích cho bé.',
  '{"Màn hình":"1.44 inch IPS","Pin":"850 mAh thời lượng pin 5 ngày","Tính năng":"Đèn pin chiếu sáng, Video Call, SOS","Kháng nước":"IP67","variants":[{"name":"Màu Đen Viền Xanh","price":1390000,"original_price":1690000,"stock":13,"image":"https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Đen Viền Hồng","price":1390000,"original_price":1690000,"stock":13,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"]}'
),
(
  139, 7, 'Đồng hồ định vị thông minh Y95 4G GPS LBS', 'dong-ho-y95-4g', 'OEM', 890000, 1190000, 50, 288, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"]',
  'Giá rẻ quốc dân, đầy đủ tính năng thiết yếu: gọi thoại 4G, định vị vị trí, gọi khẩn cấp SOS và máy tính bỏ túi mini.',
  '{"Màn hình":"1.3 inch cảm ứng","Sim":"Nano Sim 4G","Định vị":"LBS + Wifi + GPS","Pin":"450 mAh","variants":[{"name":"Màu Xanh","price":890000,"original_price":1190000,"stock":25,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Hồng","price":890000,"original_price":1190000,"stock":25,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"]}'
),
(
  140, 7, 'Đồng hồ định vị thông minh A36E 4G Chống nước IP67', 'dong-ho-a36e-4g', 'OEM', 950000, 1250000, 45, 325, 5.0, 12, 0,
  'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
  '["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]',
  'Kháng nước chuẩn IP67 an toàn cho các bé hiếu động, cài đặt lịch biểu thời khóa biểu nhắc nhở giờ đi học hàng ngày.',
  '{"Màn hình":"1.4 inch HD","Kháng nước":"IP67","Tính năng":"Định vị bản đồ thời gian thực, Gọi SOS, Tin nhắn thoại","Pin":"600 mAh","variants":[{"name":"Màu Xanh Năng Động","price":950000,"original_price":1250000,"stock":25,"image":"https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80"},{"name":"Màu Hồng Xinh Xắn","price":950000,"original_price":1250000,"stock":20,"image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"}],"demo_images":["https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80","https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80"]}'
);

-- 5. ĐÁNH GIÁ MẪU
INSERT INTO `reviews` (`product_id`, `user_name`, `rating`, `comment`, `is_verified_buyer`, `likes`) VALUES
(1, 'Trần Minh Khang', 5, 'Máy chạy cực kỳ êm và mát, mở 50 tab Chrome kèm render video 4K Final Cut mà pin vẫn trụ thoải mái cả ngày. Xứng đáng đồng tiền!', 1, 14),
(1, 'Lê Hoàng Nam', 5, 'Màn hình XDR của Apple thì khỏi bàn, màu đen sâu như OLED. Bàn phím gõ nảy và loa nghe to hơn cả loa bluetooth mini.', 1, 8),
(5, 'Nguyễn Anh Tuấn', 5, 'Khung nhôm CNC siêu sang chảnh, màn hình OLED 240Hz màu đẹp không tì vết. Chơi Cyberpunk 2077 bật DLSS mượt mà trên 100 FPS.', 1, 21),
(8, 'Vũ Đình Trọng', 5, 'Thiết kế tối giản đi trước thời đại, touchpad tàng hình dùng quen rất sướng tay. Máy nhỏ gọn nhét vừa cặp xách đi làm.', 1, 16),
(21, 'Nguyễn Thu Trang', 5, 'Màu Titan Sa Mạc bên ngoài đẹp xuất sắc, nút Camera Control bấm chụp rất tiện lợi. Camera zoom 5x chụp concert nét căng.', 1, 35),
(26, 'Đỗ Văn Hưng', 5, 'Bút S-Pen tiện lợi trong công việc, tính năng khoanh vùng tìm kiếm bằng AI cực nhạy. Camera zoom 10x vẫn rất nét.', 1, 19),
(41, 'Hoàng Nhật Minh', 5, 'Chip M4 mạnh khủng khiếp, màn hình Tandem OLED hiển thị màu đen tuyệt đối. Máy siêu mỏng nhẹ cầm như tờ tạp chí.', 1, 28),
(48, 'Bùi Tiến Dũng', 5, 'Màn 14.6 inch xem phim và vẽ vời cực đã, hỗ trợ Samsung DeX thay thế hoàn toàn laptop khi đi công tác nhẹ nhàng.', 1, 15),
(61, 'Vũ Thanh Tùng', 5, 'Khử tiếng ồn đỉnh của chóp, đeo lên xe bus hay quán cafe là dường như tách biệt hoàn toàn với thế giới ồn ào. Đệm tai êm ái.', 1, 31),
(64, 'Nguyễn Quỳnh Anh', 5, 'Chống ồn thông minh tự giảm âm lượng khi mình nói chuyện rất tiện, âm bass sâu chắc nịch, kết nối iPhone siêu nhanh.', 1, 22),
(81, 'Phạm Anh Quân', 5, 'Gõ đầm tay, âm thanh thock nhẹ rất cuốn. Kết nối 1 lúc giữa Macbook và PC qua phím tắt cực mượt. Rất ưng ý!', 1, 12),
(84, 'Lê Quốc Bảo', 5, 'Chuột công thái học số 1 thế giới, con lăn cuộn vô cực lướt bảng tính Excel ngàn dòng siêu tốc. Đỡ hẳn đau cổ tay.', 1, 40),
(101, 'Trần Văn Đức', 5, 'Pin cực kỳ trâu bò dùng hơn 3 ngày thoải mái, màn hình sáng rõ dưới trời nắng gắt. Đi phượt trekking có GPS tần số kép an tâm.', 1, 18),
(106, 'Phan Hải Đăng', 5, 'Viền xoay vật lý xoay tách tách cực kỳ thỏa mãn, đo điện tâm đồ và huyết áp tiện lợi cho bố mẹ lớn tuổi theo dõi sức khỏe.', 1, 24),
(121, 'Chị Mai Hoa', 5, 'Đồng hồ Viettel định vị rất chuẩn xác đến từng số nhà, gọi video call rõ nét không bị giật lag. Bố mẹ yên tâm hơn khi con đi học.', 1, 29),
(124, 'Anh Hoàng Long', 5, 'Bé nhà mình rất thích màu xanh, pin dùng được 2 ngày. Có chế độ lớp học không lo bé bấm nghịch trong giờ học của cô giáo.', 1, 17);

-- 6. FLASHSALE SẢN PHẨM (LƯU TRỮ VÀ QUẢN LÝ TRÊN SQL)
INSERT INTO `flash_sales` (`id`, `product_id`, `flash_price`, `flash_stock`, `sold_count`, `start_time`, `end_time`, `is_active`) VALUES
(1, 21, 31990000, 20, 14, NOW(), '2026-12-31 23:59:59', 1),
(2, 1, 44990000, 15, 11, NOW(), '2026-12-31 23:59:59', 1),
(3, 26, 26990000, 25, 18, NOW(), '2026-12-31 23:59:59', 1),
(4, 61, 6290000, 30, 26, NOW(), '2026-12-31 23:59:59', 1),
(5, 41, 26490000, 15, 9, NOW(), '2026-12-31 23:59:59', 1),
(6, 101, 18990000, 18, 12, NOW(), '2026-12-31 23:59:59', 1),
(7, 81, 4190000, 20, 15, NOW(), '2026-12-31 23:59:59', 1),
(8, 64, 5190000, 40, 32, NOW(), '2026-12-31 23:59:59', 1);

