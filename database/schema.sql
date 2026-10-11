-- ==========================================================
-- HỆ THỐNG CƠ SỞ DỮ LIỆU TECHSTORE (ĐỒ ÁN CƠ SỞ NGÀNH)
-- MySQL 8.0+ Compatible Schema
-- ==========================================================

CREATE DATABASE IF NOT EXISTS `techstore_db` 
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `techstore_db`;

-- 1. Bảng Danh mục sản phẩm (categories)
CREATE TABLE IF NOT EXISTS `categories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `slug` VARCHAR(100) NOT NULL UNIQUE,
    `icon` VARCHAR(50) DEFAULT 'laptop',
    `description` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Bảng Sản phẩm công nghệ (products)
CREATE TABLE IF NOT EXISTS `products` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_id` INT NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `slug` VARCHAR(255) NOT NULL UNIQUE,
    `brand` VARCHAR(100) NOT NULL,
    `price` DECIMAL(15, 0) NOT NULL,
    `original_price` DECIMAL(15, 0) NOT NULL,
    `stock` INT NOT NULL DEFAULT 50,
    `sold_count` INT NOT NULL DEFAULT 0,
    `rating` DECIMAL(2, 1) DEFAULT 5.0,
    `reviews_count` INT DEFAULT 0,
    `featured` TINYINT(1) DEFAULT 0,
    `image_url` VARCHAR(500) NOT NULL,
    `images` TEXT, -- JSON array of image URLs
    `short_description` VARCHAR(500),
    `specifications` TEXT, -- JSON key-value pairs (CPU, RAM, ROM,...)
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Bảng Đơn hàng (orders)
CREATE TABLE IF NOT EXISTS `orders` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT DEFAULT NULL,
    `order_code` VARCHAR(50) NOT NULL UNIQUE,
    `customer_name` VARCHAR(150) NOT NULL,
    `customer_phone` VARCHAR(20) NOT NULL,
    `customer_email` VARCHAR(150),
    `shipping_address` VARCHAR(500) NOT NULL,
    `shipping_method` VARCHAR(100) DEFAULT 'standard',
    `shipping_fee` DECIMAL(15, 0) DEFAULT 30000,
    `discount_amount` DECIMAL(15, 0) DEFAULT 0,
    `total_amount` DECIMAL(15, 0) NOT NULL,
    `payment_method` VARCHAR(50) NOT NULL, -- 'cod', 'vnpay', 'momo', 'credit_card'
    `payment_status` VARCHAR(50) DEFAULT 'unpaid', -- 'unpaid', 'paid', 'refunded'
    `order_status` VARCHAR(50) DEFAULT 'pending', -- 'pending', 'confirmed', 'shipping', 'completed', 'cancelled'
    `transaction_id` VARCHAR(100) DEFAULT NULL,
    `notes` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Bảng Chi tiết đơn hàng (order_items)
CREATE TABLE IF NOT EXISTS `order_items` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `order_id` INT NOT NULL,
    `product_id` INT NOT NULL,
    `product_name` VARCHAR(255) NOT NULL,
    `product_image` VARCHAR(500),
    `price` DECIMAL(15, 0) NOT NULL,
    `quantity` INT NOT NULL DEFAULT 1,
    `subtotal` DECIMAL(15, 0) NOT NULL,
    CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_order_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Bảng Đánh giá & Bình luận (reviews)
CREATE TABLE IF NOT EXISTS `reviews` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `product_id` INT NOT NULL,
    `user_id` INT DEFAULT NULL,
    `user_name` VARCHAR(100) NOT NULL,
    `rating` INT NOT NULL CHECK (`rating` BETWEEN 1 AND 5),
    `comment` TEXT NOT NULL,
    `is_verified_buyer` TINYINT(1) DEFAULT 1,
    `likes` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_reviews_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_reviews_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5.1 Bảng Hỏi & Đáp Thảo luận sản phẩm (product_questions)
CREATE TABLE IF NOT EXISTS `product_questions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `product_id` INT NOT NULL,
    `parent_id` INT NULL DEFAULT NULL,
    `user_id` INT NULL,
    `user_name` VARCHAR(150) NOT NULL,
    `content` TEXT NOT NULL,
    `is_buyer` TINYINT(1) DEFAULT 0,
    `is_admin` TINYINT(1) DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_questions_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_questions_parent` FOREIGN KEY (`parent_id`) REFERENCES `product_questions` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_questions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Bảng Mã giảm giá (coupons)
CREATE TABLE IF NOT EXISTS `coupons` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(50) NOT NULL UNIQUE,
    `discount_percent` INT DEFAULT 0,
    `max_discount` DECIMAL(15, 0) DEFAULT 0,
    `min_order_value` DECIMAL(15, 0) DEFAULT 0,
    `active` TINYINT(1) DEFAULT 1,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. Bảng Người dùng & Tài khoản (users)
CREATE TABLE IF NOT EXISTS `users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(150) NOT NULL,
    `email` VARCHAR(150) UNIQUE,
    `phone` VARCHAR(20) UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `role` VARCHAR(20) DEFAULT 'user', -- 'user' hoặc 'admin'
    `avatar` VARCHAR(500) DEFAULT 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. Bảng Flash Sale (flash_sales)
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

-- Tạo Indexes để tối ưu tốc độ truy vấn
CREATE INDEX `idx_products_category` ON `products` (`category_id`);
CREATE INDEX `idx_products_brand` ON `products` (`brand`);
CREATE INDEX `idx_products_price` ON `products` (`price`);
CREATE INDEX `idx_products_sold` ON `products` (`sold_count`);
CREATE INDEX `idx_flash_sales_active` ON `flash_sales` (`is_active`, `end_time`);
CREATE INDEX `idx_orders_code` ON `orders` (`order_code`);
CREATE INDEX `idx_orders_phone` ON `orders` (`customer_phone`);
CREATE INDEX `idx_users_email` ON `users` (`email`);
CREATE INDEX `idx_users_phone` ON `users` (`phone`);
