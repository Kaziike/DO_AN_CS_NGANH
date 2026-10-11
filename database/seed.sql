SELECT `categories`.`id`,
    `categories`.`name`,
    `categories`.`slug`,
    `categories`.`icon`,
    `categories`.`description`,
    `categories`.`created_at`
FROM `techstore_db`.`categories`;
-- ==========================================================
-- DỮ LIỆU MẪU BAN ĐẦU (SEED DATA) CHO TECHSTORE
-- ==========================================================

USE `techstore_db`;

-- Xóa dữ liệu cũ nếu có
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE `order_items`;
TRUNCATE TABLE `orders`;
TRUNCATE TABLE `reviews`;
TRUNCATE TABLE `products`;
TRUNCATE TABLE `categories`;
TRUNCATE TABLE `coupons`;
TRUNCATE TABLE `users`;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Chèn Tài khoản Người dùng mẫu
INSERT INTO `users` (`id`, `name`, `email`, `phone`, `password`, `role`) VALUES
(1, 'Quản trị viên', 'admin@techstore.vn', '0988888888', 'admin', 'admin'),
(2, 'Nguyễn Văn A', 'khachhang@gmail.com', '0912345678', '123', 'user');

-- 2. Chèn Danh mục
INSERT INTO `categories` (`id`, `name`, `slug`, `icon`, `description`) VALUES
(1, 'Laptop & Máy tính', 'laptop', 'laptop', 'Laptop văn phòng, Gaming, đồ họa cao cấp từ Apple, Dell, Asus, Lenovo'),
(2, 'Điện thoại thông minh', 'smartphone', 'mobile', 'Smartphone flagship, cận cao cấp từ Apple, Samsung, Xiaomi'),
(3, 'Máy tính bảng (Tablet)', 'tablet', 'tablet', 'iPad, Galaxy Tab phục vụ học tập, giải trí và sáng tạo nội dung'),
(4, 'Âm thanh & Tai nghe', 'audio', 'headphones', 'Tai nghe True Wireless, chống ồn chủ động, loa Bluetooth Sony, Apple, Marshall'),
(5, 'Gaming Gear & Phụ kiện', 'gaming-gear', 'gamepad', 'Bàn phím cơ, chuột công thái học, tai nghe gaming Logitech, Razer, Keychron'),
(6, 'Đồng hồ thông minh', 'smartwatch', 'watch', 'Apple Watch, Samsung Galaxy Watch theo dõi sức khỏe và thể thao đỉnh cao'),
(7, 'Đồng hồ trẻ em', 'smartwacth-kid', 'wkid', 'Viettel Protect Your Child');

-- 3. Chèn Mã giảm giá
INSERT INTO `coupons` (`id`, `code`, `discount_percent`, `max_discount`, `min_order_value`, `active`) VALUES
(1, 'TECH10', 10, 500000, 1000000, 1),
(2, 'FREESHIP', 100, 50000, 500000, 1),
(3, 'SUPERTECH', 15, 1000000, 5000000, 1),
(4, 'CHAOBANMOI', 5, 200000, 500000, 1);

-- 3. Chèn Sản phẩm công nghệ
INSERT INTO `products` (`id`, `category_id`, `name`, `slug`, `brand`, `price`, `original_price`, `stock`, `rating`, `reviews_count`, `featured`, `image_url`, `images`, `short_description`, `specifications`) VALUES
(1, 1, 'MacBook Pro 14 M3 Pro (18GB / 512GB)', 'macbook-pro-14-m3-pro', 'Apple', 48990000, 53990000, 25, 0, 0, 1, 
 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80',
 '["https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80", "https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?auto=format&fit=crop&w=800&q=80"]',
 'Hiệu năng đỉnh cao cùng chip M3 Pro kiến trúc 3nm, màn hình Liquid Retina XDR 120Hz sắc nét bậc nhất.',
 '{"CPU": "Apple M3 Pro 11-core CPU", "GPU": "14-core GPU", "RAM": "18GB Unified Memory", "Ổ cứng": "512GB SSD NVMe", "Màn hình": "14.2 inch Liquid Retina XDR (3024 x 1964) 120Hz ProMotion", "Trọng lượng": "1.61 kg", "Pin": "Lên đến 18 giờ"}'),

(2, 1, 'Asus ROG Zephyrus G16 OLED (Intel Core Ultra 9 / RTX 4070)', 'asus-rog-zephyrus-g16', 'Asus', 61990000, 66990000, 12, 0, 0, 1,
 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80',
 '["https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=800&q=80", "https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80"]',
 'Laptop gaming mỏng nhẹ cao cấp khung nhôm CNC, màn hình OLED 2.5K 240Hz đạt chuẩn màu đồ họa.',
 '{"CPU": "Intel Core Ultra 9 185H", "GPU": "NVIDIA GeForce RTX 4070 8GB GDDR6", "RAM": "32GB LPDDR5X 7467MHz", "Ổ cứng": "1TB SSD PCIe 4.0 NVMe", "Màn hình": "16 inch ROG Nebula OLED 2.5K 240Hz 0.2ms", "Trọng lượng": "1.85 kg", "Pin": "90WHrs"}'),

(3, 1, 'Dell XPS 13 9340 (Intel Core Ultra 7 / 16GB / 512GB)', 'dell-xps-13-9340', 'Dell', 41500000, 44990000, 18, 0, 0, 0,
 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80',
 '["https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80"]',
 'Thiết kế tương lai tối giản với thanh cảm ứng điện dung, touchpad tàng hình kính liền mạch.',
 '{"CPU": "Intel Core Ultra 7 155H", "GPU": "Intel Arc Graphics", "RAM": "16GB LPDDR5x 7467MHz", "Ổ cứng": "512GB PCIe 4.0 SSD", "Màn hình": "13.4 inch FHD+ InfinityEdge 120Hz", "Trọng lượng": "1.19 kg", "Pin": "55Wh"}'),

(4, 2, 'iPhone 15 Pro Max 256GB Titan Tự Nhiên', 'iphone-15-pro-max-256gb', 'Apple', 29490000, 34990000, 45, 0, 0, 1,
 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=800&q=80',
 '["https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=800&q=80"]',
 'Khung viền Titan chuẩn hàng không vũ trụ siêu nhẹ, chip A17 Pro mạnh mẽ cùng camera tiềm vọng zoom quang 5x.',
 '{"Màn hình": "6.7 inch Super Retina XDR OLED 120Hz ProMotion", "Chip": "Apple A17 Pro (3nm)", "RAM": "8GB", "Bộ nhớ trong": "256GB", "Camera sau": "Chính 48MP, Siêu rộng 12MP, Tele 5x 12MP", "Pin": "4422 mAh, Sạc nhanh Type-C"}'),

(5, 2, 'Samsung Galaxy S24 Ultra 5G (12GB / 256GB)', 'samsung-galaxy-s24-ultra', 'Samsung', 26990000, 31990000, 38, 0, 0, 1,
 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80',
 '["https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=800&q=80"]',
 'Quyền năng Galaxy AI tiên phong, màn hình phẳng chống chói Gorilla Armor, kèm bút S-Pen quyền năng.',
 '{"Màn hình": "6.8 inch Dynamic AMOLED 2X QHD+ 120Hz (2600 nits)", "Chip": "Snapdragon 8 Gen 3 for Galaxy", "RAM": "12GB", "Bộ nhớ trong": "256GB", "Camera": "200MP + 50MP (5x) + 12MP + 10MP", "Pin": "5000 mAh, Sạc nhanh 45W"}'),

(6, 2, 'Xiaomi 14 Ultra (16GB / 512GB) Ống kính Leica', 'xiaomi-14-ultra-5g', 'Xiaomi', 27990000, 32990000, 20, 0, 0, 0,
 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80',
 '["https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80"]',
 'Cụm 4 camera Leica 50MP cảm biến 1-inch biến thiên khẩu độ, mang lại trải nghiệm nhiếp ảnh chuyên nghiệp.',
 '{"Màn hình": "6.73 inch LTPO AMOLED WQHD+ 120Hz (3000 nits)", "Chip": "Snapdragon 8 Gen 3", "RAM": "16GB", "Bộ nhớ trong": "512GB UFS 4.0", "Camera": "Quad 50MP Leica Vario-Summilux", "Pin": "5000 mAh, Sạc siêu nhanh 90W"}'),

(7, 3, 'iPad Pro 11 inch M4 Ultra Retina (Wi-Fi 256GB)', 'ipad-pro-11-m4', 'Apple', 27990000, 29990000, 25, 0, 0, 1,
 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80',
 '["https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80"]',
 'Thiết kế mỏng kỷ lục 5.3mm, trang bị chip Apple M4 thế hệ mới và màn hình Ultra Retina XDR OLED kép.',
 '{"Màn hình": "11 inch Tandem OLED Ultra Retina XDR 120Hz", "Chip": "Apple M4 (9-core CPU, 10-core GPU)", "RAM": "8GB Unified", "Bộ nhớ": "256GB", "Độ mỏng": "5.3 mm siêu nhẹ 444g"}'),

(8, 3, 'Samsung Galaxy Tab S9 Ultra (Wi-Fi 12GB / 256GB)', 'samsung-galaxy-tab-s9-ultra', 'Samsung', 22490000, 26990000, 15, 0, 0, 0,
 'https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80',
 '["https://images.unsplash.com/photo-1561154464-82e9adf32764?auto=format&fit=crop&w=800&q=80"]',
 'Màn hình khổng lồ 14.6 inch Dynamic AMOLED 2X, chuẩn kháng nước IP68 đầu tiên trên tablet cao cấp.',
 '{"Màn hình": "14.6 inch Dynamic AMOLED 2X 120Hz HDR10+", "Chip": "Snapdragon 8 Gen 2 for Galaxy", "RAM": "12GB", "Bộ nhớ": "256GB (hỗ trợ thẻ MicroSD 1TB)", "Pin": "11200 mAh"}'),

(9, 4, 'Tai nghe chống ồn Sony WH-1000XM5', 'sony-wh-1000xm5', 'Sony', 7490000, 8990000, 40, 0, 0, 1,
 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80',
 '["https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80"]',
 'Khử tiếng ồn đỉnh cao hàng đầu thế giới với 2 bộ xử lý và 8 micro, chất âm chuẩn Hi-Res Audio không dây.',
 '{"Công nghệ": "Chống ồn chủ động ANC V1 + QN1", "Driver": "30mm màng sợi carbon tổng hợp", "Thời lượng pin": "30 giờ (bật ANC), sạc nhanh 3 phút nghe 3 giờ", "Kết nối": "Bluetooth 5.2, LDAC, DSEE Extreme"}'),

(10, 4, 'Tai nghe Apple AirPods Pro (Gen 2) USB-C', 'airpods-pro-gen-2-usbc', 'Apple', 5690000, 6290000, 60, 0, 0, 1,
 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80',
 '["https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=800&q=80"]',
 'Chip H2 nâng tầm chống ồn chủ động gấp 2 lần, âm thanh thích ứng Adaptive Audio và cổng sạc USB-C tiện lợi.',
 '{"Chip": "Apple H2", "Chống ồn": "Active Noise Cancellation gấp 2 lần + Xuyên âm", "Pin": "6 giờ liên tục, 30 giờ kèm hộp sạc", "Kháng nước": "IP54 chống bụi nước"}'),

(11, 4, 'Loa Bluetooth Marshall Stanmore III', 'marshall-stanmore-iii', 'Marshall', 8990000, 10290000, 18, 0, 0, 0,
 'https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80',
 '["https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80"]',
 'Âm thanh tràn ngập không gian gia đình mang âm sắc cổ điển huyền thoại, kết nối Bluetooth 5.2 và AUX.',
 '{"Công suất": "80W (1 Woofer 50W + 2 Tweeter 15W)", "Dải tần": "45Hz - 20000Hz", "Kết nối": "Bluetooth 5.2, AUX 3.5mm, RCA", "Trọng lượng": "4.25 kg"}'),

(12, 5, 'Bàn phím cơ không dây Keychron K8 Pro QMK/VIA', 'keychron-k8-pro', 'Keychron', 2390000, 2790000, 35, 0, 0, 1,
 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80',
 '["https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80"]',
 'Bàn phím cơ Layout TKL 87 phím, switch Gateron G Pro hotswap, mạch xuôi LED RGB hỗ trợ macOS và Windows.',
 '{"Layout": "Tenkeyless 87 phím", "Switch": "Gateron G Pro Hotswap (Red/Brown/Blue)", "Kết nối": "Bluetooth 5.1 và Type-C có dây", "Keycap": "OSA PBT Double-shot", "Pin": "4000mAh lên đến 300 giờ"}'),

(13, 5, 'Chuột công thái học Logitech MX Master 3S', 'logitech-mx-master-3s', 'Logitech', 2190000, 2490000, 50, 0, 0, 1,
 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80',
 '["https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=800&q=80"]',
 'Cảm biến 8000 DPI theo dõi trên mọi bề mặt kể cả kính, cuộn siêu tốc MagSpeed 1000 dòng/giây và click siêu êm.',
 '{"Cảm biến": "Darkfield 8000 DPI", "Nút bấm": "Quiet Clicks giảm 90% tiếng ồn", "Kết nối": "Logi Bolt và Bluetooth (kết nối cùng lúc 3 thiết bị)", "Pin": "Sạc đầy dùng 70 ngày"}'),

(14, 5, 'Chuột gaming không dây Razer DeathAdder V3 Pro', 'razer-deathadder-v3-pro', 'Razer', 2990000, 3690000, 22, 0, 0, 0,
 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80',
 '["https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=800&q=80"]',
 'Trọng lượng siêu nhẹ chỉ 63g, cảm biến quang học Focus Pro 30K DPI cực chuẩn cho game thủ eSports.',
 '{"Cảm biến": "Focus Pro 30K Optical Sensor", "Tốc độ": "750 IPS / Gia tốc 70G", "Switch": "Optical Mouse Switches Gen-3 (90 triệu lần nhấn)", "Trọng lượng": "63g siêu nhẹ", "Pin": "90 giờ"}'),

(15, 6, 'Apple Watch Ultra 2 GPS + Cellular 49mm', 'apple-watch-ultra-2', 'Apple', 19990000, 21990000, 16, 0, 0, 1,
 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80',
 '["https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=800&q=80"]',
 'Vỏ Titan bền bỉ chuẩn quân đội, màn hình sáng kỷ lục 3000 nits, định vị GPS kép chính xác cao cho dân thám hiểm.',
 '{"Màn hình": "49mm Always-On Retina LTPO OLED 3000 nits", "Chip": "Apple S9 SiP (hỗ trợ thao tác chạm đúp Double Tap)", "Chất liệu": "Titanium cấp hàng không", "Chống nước": "WR100 (lặn sâu 40m)", "Pin": "36 giờ sử dụng bình thường, 72 giờ chế độ tiết kiệm"}'),

(16, 6, 'Samsung Galaxy Watch 6 Classic 47mm LTE', 'samsung-galaxy-watch-6-classic', 'Samsung', 7990000, 9490000, 20, 0, 0, 0,
 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80',
 '["https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80"]',
 'Vòng xoay bezel vật lý đặc trưng, cảm biến phân tích thành phần cơ thể BIA và theo dõi giấc ngủ chuyên sâu.',
 '{"Màn hình": "1.5 inch Super AMOLED kính Sapphire", "Chip": "Exynos W930 Dual Core 1.4GHz", "Chống nước": "5ATM + IP68 / MIL-STD-810H", "Tính năng": "Đo ECG, Huyết áp, Thành phần cơ thể BIA"}');

-- 4. Chèn Đánh giá mẫu
INSERT INTO `reviews` (`product_id`, `user_name`, `rating`, `comment`, `is_verified_buyer`, `likes`) VALUES
(1, 'Trần Minh Khang', 5, 'Máy chạy cực kỳ êm và mát, mở 50 tab Chrome kèm render video 4K Final Cut mà pin vẫn trụ thoải mái cả ngày. Xứng đáng đồng tiền!', 1, 14),
(1, 'Lê Hoàng Nam', 5, 'Màn hình XDR của Apple thì khỏi bàn, màu đen sâu như OLED. Bàn phím gõ nảy và loa nghe to hơn cả loa bluetooth mini.', 1, 8),
(4, 'Nguyễn Thu Trang', 5, 'Màu Titan Tự Nhiên bên ngoài nhìn sang chảnh cực kỳ. Trọng lượng nhẹ hơn hẳn con 14 Pro Max trước đây mình dùng.', 1, 25),
(5, 'Đỗ Văn Hưng', 5, 'Bút S-Pen tiện lợi trong công việc, tính năng khoanh vùng tìm kiếm bằng AI cực nhạy. Camera zoom 10x vẫn rất nét.', 1, 19),
(9, 'Vũ Thanh Tùng', 5, 'Khử tiếng ồn đỉnh của chóp, đeo lên xe bus hay quán cafe là dường như tách biệt hoàn toàn với thế giới ồn ào. Đệm tai êm ái.', 1, 31),
(12, 'Phạm Anh Quân', 5, 'Gõ đầm tay, âm thanh thock nhẹ rất cuốn. Kết nối 1 lúc giữa Macbook và PC qua phím tắt cực mượt. Rất ưng ý!', 1, 12);
