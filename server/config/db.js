const mysql = require('mysql2/promise');
require('dotenv').config();

let pool = null;

/**
 * Khởi tạo kết nối cơ sở dữ liệu MySQL
 */
async function initDatabase() {
  const host = process.env.DB_HOST || 'localhost';
  const user = process.env.DB_USER || 'root';
  const password = process.env.DB_PASSWORD || '';
  const database = process.env.DB_NAME || 'techstore_db';
  const port = parseInt(process.env.DB_PORT || '3306', 10);

  console.log(`[Database] Đang kết nối MySQL tại ${host}:${port} (Database: ${database})...`);

  try {
    pool = mysql.createPool({
      host,
      user,
      password,
      database,
      port,
      waitForConnections: true,
      connectionLimit: 10,
      queueLimit: 0,
      enableKeepAlive: true,
      keepAliveInitialDelay: 0,
      decimalNumbers: true // Trả về kiểu Number cho DECIMAL (price, rating, total_amount)
    });

    // Kiểm tra kết nối thực tế
    const [result] = await pool.query('SELECT 1 + 1 AS test');
    if (!result || result[0].test !== 2) {
      throw new Error('Kiểm tra truy vấn MySQL thất bại');
    }

    console.log(`✅ [Database] Kết nối MySQL thành công tới database: '${database}' (Host: ${host}:${port})`);
    return 'mysql';
  } catch (err) {
    console.error(`❌ [Database] Không thể kết nối tới MySQL (${err.message})!`);
    console.error('Vui lòng kiểm tra lại cấu hình DB_HOST, DB_USER, DB_PASSWORD, DB_NAME, DB_PORT trong file .env');
    throw err;
  }
}

/**
 * Đảm bảo pool đã được khởi tạo
 */
function getPool() {
  if (!pool) {
    throw new Error('Cơ sở dữ liệu MySQL chưa được khởi tạo. Vui lòng gọi initDatabase() trước.');
  }
  return pool;
}

const db = {
  getMode: () => 'mysql',
  init: initDatabase,
  getPool,

  // ==========================================
  // 1. DANH MỤC SẢN PHẨM (Categories)
  // ==========================================
  async getCategories() {
    const p = getPool();
    const [rows] = await p.query('SELECT * FROM categories ORDER BY id ASC');
    return rows;
  },

  // ==========================================
  // 2. SẢN PHẨM (Products)
  // ==========================================
  async getProducts({ category, brand, minPrice, maxPrice, minRating, sort, search, featured, cpu, gpu, ram, storage, screen, feature, connection, component_type, page = 1, limit = 12 } = {}) {
    const p = getPool();
    let sql = `
      SELECT p.*, c.name as category_name, c.slug as category_slug 
      FROM products p 
      LEFT JOIN categories c ON p.category_id = c.id 
      WHERE 1=1
    `;
    let countSql = `
      SELECT COUNT(*) as total 
      FROM products p 
      LEFT JOIN categories c ON p.category_id = c.id 
      WHERE 1=1
    `;
    const params = [];
    const countParams = [];

    if (category && category !== 'all') {
      const filter = ' AND (c.slug = ? OR p.category_id = ?)';
      sql += filter;
      countSql += filter;
      params.push(category, category);
      countParams.push(category, category);
    }

    if (brand && brand !== 'all') {
      const filter = ' AND LOWER(p.brand) = LOWER(?)';
      sql += filter;
      countSql += filter;
      params.push(brand);
      countParams.push(brand);
    }

    if (minPrice) {
      const filter = ' AND p.price >= ?';
      sql += filter;
      countSql += filter;
      params.push(Number(minPrice));
      countParams.push(Number(minPrice));
    }

    if (maxPrice) {
      const filter = ' AND p.price <= ?';
      sql += filter;
      countSql += filter;
      params.push(Number(maxPrice));
      countParams.push(Number(maxPrice));
    }

    if (minRating) {
      const filter = ' AND p.rating >= ?';
      sql += filter;
      countSql += filter;
      params.push(Number(minRating));
      countParams.push(Number(minRating));
    }

    if (cpu) {
      const filter = ' AND (p.specifications LIKE ? OR p.name LIKE ?)';
      sql += filter;
      countSql += filter;
      const term = `%${cpu}%`;
      params.push(term, term);
      countParams.push(term, term);
    }

    if (gpu) {
      const filter = ' AND (p.specifications LIKE ? OR p.name LIKE ?)';
      sql += filter;
      countSql += filter;
      const term = `%${gpu}%`;
      params.push(term, term);
      countParams.push(term, term);
    }

    if (ram) {
      const filter = ' AND (p.specifications LIKE ? OR p.name LIKE ?)';
      sql += filter;
      countSql += filter;
      const term = `%${ram}%`;
      params.push(term, term);
      countParams.push(term, term);
    }

    if (storage) {
      const filter = ' AND (p.specifications LIKE ? OR p.name LIKE ?)';
      sql += filter;
      countSql += filter;
      const term = `%${storage}%`;
      params.push(term, term);
      countParams.push(term, term);
    }

    if (screen) {
      const filter = ' AND (p.specifications LIKE ? OR p.name LIKE ?)';
      sql += filter;
      countSql += filter;
      const term = `%${screen}%`;
      params.push(term, term);
      countParams.push(term, term);
    }

    if (feature) {
      const filter = ' AND (p.specifications LIKE ? OR p.name LIKE ?)';
      sql += filter;
      countSql += filter;
      const term = `%${feature}%`;
      params.push(term, term);
      countParams.push(term, term);
    }

    if (connection) {
      const filter = ' AND (p.specifications LIKE ? OR p.name LIKE ?)';
      sql += filter;
      countSql += filter;
      const term = `%${connection}%`;
      params.push(term, term);
      countParams.push(term, term);
    }

    if (component_type) {
      const filter = ' AND (p.specifications LIKE ? OR p.name LIKE ?)';
      sql += filter;
      countSql += filter;
      const term = `%${component_type}%`;
      params.push(term, term);
      countParams.push(term, term);
    }

    if (featured) {
      const filter = ' AND p.featured = 1';
      sql += filter;
      countSql += filter;
    }

    if (search) {
      const filter = ' AND (p.name LIKE ? OR p.short_description LIKE ? OR p.brand LIKE ?)';
      sql += filter;
      countSql += filter;
      const term = `%${search}%`;
      params.push(term, term, term);
      countParams.push(term, term, term);
    }

    // Sắp xếp
    if (sort === 'price-asc') sql += ' ORDER BY p.price ASC';
    else if (sort === 'price-desc') sql += ' ORDER BY p.price DESC';
    else if (sort === 'rating') sql += ' ORDER BY p.rating DESC';
    else if (sort === 'popular') sql += ' ORDER BY p.reviews_count DESC';
    else if (sort === 'sold' || sort === 'best_selling') sql += ' ORDER BY p.sold_count DESC, p.id DESC';
    else sql += ' ORDER BY p.id DESC';

    // Đếm tổng số lượng
    const [countResult] = await p.query(countSql, countParams);
    const total = Number(countResult[0].total || 0);

    // Phân trang
    const pageNum = Math.max(1, Number(page) || 1);
    const limitNum = Math.max(1, Number(limit) || 12);
    const offset = (pageNum - 1) * limitNum;
    sql += ' LIMIT ? OFFSET ?';
    params.push(limitNum, offset);

    const [rows] = await p.query(sql, params);
    const safeJsonParse = (str, fallback) => {
      if (!str) return fallback;
      if (typeof str !== 'string') return str;
      try {
        return JSON.parse(str);
      } catch (e) {
        console.warn('JSON parse warning:', e.message);
        return fallback;
      }
    };

    const products = rows.map(r => ({
      ...r,
      images: safeJsonParse(r.images, []),
      specifications: safeJsonParse(r.specifications, {})
    }));

    return {
      products,
      total,
      page: pageNum,
      limit: limitNum,
      totalPages: Math.ceil(total / limitNum)
    };
  },

  async getProductById(id) {
    const p = getPool();
    const [rows] = await p.query(`
      SELECT p.*, c.name as category_name, c.slug as category_slug 
      FROM products p 
      LEFT JOIN categories c ON p.category_id = c.id 
      WHERE p.id = ?
    `, [id]);

    if (rows.length === 0) return null;
    const r = rows[0];
    const safeJsonParse = (str, fallback) => {
      if (!str) return fallback;
      if (typeof str !== 'string') return str;
      try {
        return JSON.parse(str);
      } catch (e) {
        return fallback;
      }
    };
    return {
      ...r,
      images: safeJsonParse(r.images, []),
      specifications: safeJsonParse(r.specifications, {})
    };
  },

  async createProduct(productData) {
    const p = getPool();
    const slug = (productData.slug || productData.name || '').toLowerCase()
      .normalize('NFD').replace(/[\u0300-\u036f]/g, '')
      .replace(/[^a-z0-9]/g, '-').replace(/-+/g, '-').replace(/^-|-$/g, '') + '-' + Date.now();

    const images = Array.isArray(productData.images) ? productData.images : [productData.image_url];
    const specifications = typeof productData.specifications === 'object' ? productData.specifications : {};

    const [result] = await p.query(
      `INSERT INTO products (category_id, name, slug, brand, price, original_price, stock, rating, reviews_count, featured, image_url, images, short_description, specifications)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        Number(productData.category_id),
        productData.name,
        slug,
        productData.brand || 'Khác',
        Number(productData.price || 0),
        Number(productData.original_price || productData.price || 0),
        Number(productData.stock || 10),
        5.0,
        0,
        productData.featured ? 1 : 0,
        productData.image_url || 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80',
        JSON.stringify(images),
        productData.short_description || '',
        JSON.stringify(specifications)
      ]
    );

    return this.getProductById(result.insertId);
  },

  async updateProduct(id, updateData) {
    const p = getPool();
    const allowedFields = ['category_id', 'name', 'brand', 'price', 'original_price', 'stock', 'featured', 'image_url', 'short_description'];
    const updates = [];
    const params = [];

    for (const [key, value] of Object.entries(updateData)) {
      if (allowedFields.includes(key)) {
        updates.push(`\`${key}\` = ?`);
        params.push(value);
      } else if (key === 'specifications' || key === 'images') {
        updates.push(`\`${key}\` = ?`);
        params.push(JSON.stringify(value));
      }
    }

    if (updates.length > 0) {
      params.push(id);
      await p.query(`UPDATE products SET ${updates.join(', ')} WHERE id = ?`, params);
    }

    return this.getProductById(id);
  },

  async deleteProduct(id) {
    const p = getPool();
    const [result] = await p.query('DELETE FROM products WHERE id = ?', [id]);
    return result.affectedRows > 0;
  },

  // ==========================================
  // 3. ĐƠN HÀNG (Orders)
  // ==========================================
  async createOrder({ user_id, customer_name, customer_phone, customer_email, shipping_address, shipping_method, shipping_fee, discount_amount, total_amount, payment_method, notes, items }) {
    const p = getPool();
    const connection = await p.getConnection();

    try {
      await connection.beginTransaction();

      // 1. Kiểm tra nghiêm ngặt số lượng hàng tồn kho của từng sản phẩm trước khi tạo đơn
      for (const item of (items || [])) {
        const [prodRows] = await connection.query(
          'SELECT id, name, stock FROM products WHERE id = ? FOR UPDATE',
          [item.product_id]
        );

        if (prodRows.length === 0) {
          throw new Error(`Sản phẩm (ID: ${item.product_id}) không tồn tại trong hệ thống!`);
        }

        const product = prodRows[0];
        const reqQty = Number(item.quantity) || 1;

        if (product.stock <= 0) {
          throw new Error(`Sản phẩm "${product.name}" hiện đã hết hàng, vui lòng quay lại sau!`);
        }

        if (product.stock < reqQty) {
          throw new Error(`Sản phẩm "${product.name}" chỉ còn ${product.stock} chiếc trong kho (bạn đang đặt ${reqQty} chiếc)!`);
        }
      }

      const order_code = 'ORD-' + Math.floor(10000 + Math.random() * 90000);
      // Đơn hàng mới tạo luôn ở trạng thái 'unpaid' cho tới khi cổng thanh toán xác nhận thành công
      const payment_status = 'unpaid';
      const order_status = 'pending';
      const transaction_id = null;
      const numUserId = user_id ? Number(user_id) : null;

      const [res] = await connection.query(
        `INSERT INTO orders (user_id, order_code, customer_name, customer_phone, customer_email, shipping_address, shipping_method, shipping_fee, discount_amount, total_amount, payment_method, payment_status, order_status, transaction_id, notes)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [
          numUserId,
          order_code,
          customer_name,
          customer_phone,
          customer_email || '',
          shipping_address,
          shipping_method || 'Tiêu chuẩn',
          Number(shipping_fee || 30000),
          Number(discount_amount || 0),
          Number(total_amount),
          payment_method,
          payment_status,
          order_status,
          transaction_id,
          notes || ''
        ]
      );
      const orderId = res.insertId;

      // 2. Lưu chi tiết từng sản phẩm và trừ tồn kho chính xác
      for (const item of (items || [])) {
        const subtotal = item.subtotal || (Number(item.price) * Number(item.quantity));
        const itemName = item.variant_name ? `${item.product_name} (${item.variant_name})` : item.product_name;

        await connection.query(
          `INSERT INTO order_items (order_id, product_id, product_name, product_image, price, quantity, subtotal)
           VALUES (?, ?, ?, ?, ?, ?, ?)`,
          [
            orderId,
            item.product_id,
            itemName,
            item.product_image || '',
            Number(item.price),
            Number(item.quantity),
            subtotal
          ]
        );

        // Trừ tồn kho và cộng số lượng đã bán (sold_count) vào bảng products và biến thể
        try {
          const [specsRows] = await connection.query('SELECT specifications, stock FROM products WHERE id = ? FOR UPDATE', [item.product_id]);
          if (specsRows.length > 0) {
            let specs = typeof specsRows[0].specifications === 'string'
              ? JSON.parse(specsRows[0].specifications || '{}')
              : specsRows[0].specifications;
            let totalStock = Math.max(0, Number(specsRows[0].stock) - Number(item.quantity));
            if (specs && Array.isArray(specs.variants) && specs.variants.length > 0) {
              const vName = item.variant_name;
              let vIdx = vName ? specs.variants.findIndex(v => v.name === vName) : 0;
              if (vIdx === -1) vIdx = 0;
              if (specs.variants[vIdx]) {
                const curVStock = Number(specs.variants[vIdx].stock) || 0;
                specs.variants[vIdx].stock = Math.max(0, curVStock - Number(item.quantity));
              }
              totalStock = specs.variants.reduce((sum, v) => sum + (Number(v.stock) || 0), 0);
            }
            await connection.query(
              'UPDATE products SET stock = ?, sold_count = sold_count + ?, specifications = ? WHERE id = ?',
              [totalStock, Number(item.quantity), JSON.stringify(specs), item.product_id]
            );
          }
        } catch (errVariant) {
          console.error('Lỗi cập nhật variant stock:', errVariant);
          await connection.query(
            'UPDATE products SET stock = GREATEST(0, stock - ?), sold_count = sold_count + ? WHERE id = ?',
            [Number(item.quantity), Number(item.quantity), item.product_id]
          );
        }

        // Đồng thời nếu sản phẩm nằm trong chương trình Flash Sale, cộng dồn sold_count của Flash Sale
        await connection.query(
          'UPDATE flash_sales SET sold_count = sold_count + ? WHERE product_id = ? AND is_active = 1',
          [Number(item.quantity), item.product_id]
        );
      }

      await connection.commit();

      return {
        id: orderId,
        user_id: numUserId,
        order_code,
        customer_name,
        customer_phone,
        customer_email: customer_email || '',
        shipping_address,
        shipping_method: shipping_method || 'Tiêu chuẩn',
        shipping_fee: Number(shipping_fee || 30000),
        discount_amount: Number(discount_amount || 0),
        total_amount: Number(total_amount),
        payment_method,
        payment_status,
        order_status,
        transaction_id,
        notes: notes || '',
        created_at: new Date().toISOString(),
        items: items || []
      };
    } catch (err) {
      await connection.rollback();
      throw err;
    } finally {
      connection.release();
    }
  },

  async getOrders() {
    const p = getPool();
    const [orders] = await p.query('SELECT * FROM orders ORDER BY id DESC');
    for (const order of orders) {
      const [items] = await p.query('SELECT * FROM order_items WHERE order_id = ?', [order.id]);
      order.items = items;
    }
    return orders;
  },

  async getOrderByCode(codeOrId) {
    const p = getPool();
    const str = String(codeOrId || '').trim();
    if (!str) return null;
    const isNum = /^\d+$/.test(str);
    let orders;
    if (isNum) {
      [orders] = await p.query('SELECT * FROM orders WHERE id = ? OR UPPER(order_code) = ? OR customer_phone = ?', [Number(str), str.toUpperCase(), str]);
    } else {
      [orders] = await p.query('SELECT * FROM orders WHERE UPPER(order_code) = ? OR customer_phone = ?', [str.toUpperCase(), str]);
    }
    if (orders.length === 0) return null;
    const order = orders[0];
    const [items] = await p.query('SELECT * FROM order_items WHERE order_id = ?', [order.id]);
    order.items = items;
    return order;
  },

  async getOrdersByQuery(query) {
    const p = getPool();
    const str = String(query || '').trim();
    if (!str) return [];

    const cleaned = str.replace(/[\s.-]/g, '');
    const isNum = /^\d+$/.test(cleaned);
    let orders = [];

    if (isNum) {
      [orders] = await p.query(
        `SELECT * FROM orders 
         WHERE customer_phone = ? 
            OR REPLACE(REPLACE(customer_phone, ' ', ''), '.', '') = ? 
            OR UPPER(order_code) = ? 
            OR id = ? 
            OR user_id = ? 
         ORDER BY id DESC`,
        [str, cleaned, str.toUpperCase(), Number(cleaned), Number(cleaned)]
      );
    } else {
      [orders] = await p.query(
        `SELECT * FROM orders 
         WHERE UPPER(order_code) = ? 
            OR customer_phone = ? 
            OR customer_email = ? 
         ORDER BY id DESC`,
        [str.toUpperCase(), str, str]
      );
    }

    for (const order of orders) {
      const [items] = await p.query('SELECT * FROM order_items WHERE order_id = ?', [order.id]);
      order.items = items;
    }
    return orders;
  },

  async getUserOrders({ userId, phone, email }) {
    const p = getPool();
    const conditions = [];
    const params = [];

    if (userId) {
      conditions.push('user_id = ?');
      params.push(Number(userId));
    }
    if (phone) {
      const cleanPhone = String(phone).replace(/[\s.-]/g, '');
      conditions.push('(customer_phone = ? OR REPLACE(REPLACE(customer_phone, " ", ""), ".", "") = ?)');
      params.push(phone, cleanPhone);
    }
    if (email) {
      conditions.push('customer_email = ?');
      params.push(email);
    }

    if (conditions.length === 0) return [];

    const [orders] = await p.query(
      `SELECT * FROM orders WHERE ${conditions.join(' OR ')} ORDER BY id DESC`,
      params
    );

    for (const order of orders) {
      const [items] = await p.query('SELECT * FROM order_items WHERE order_id = ?', [order.id]);
      order.items = items;
    }
    return orders;
  },

  async updateOrderStatus(identifier, { order_status, payment_status, transaction_id }) {
    const p = getPool();
    const existingOrder = await this.getOrderByCode(identifier);

    // Xử lý hoàn trả/trừ lại số lượng đã bán và tồn kho khi đơn hàng đổi trạng thái
    if (existingOrder && existingOrder.items && existingOrder.items.length > 0) {
      if (order_status === 'cancelled' && existingOrder.order_status !== 'cancelled') {
        for (const item of existingOrder.items) {
          let vName = item.variant_name;
          if (!vName && item.product_name) {
            const match = item.product_name.match(/\(([^)]+)\)$/);
            if (match) vName = match[1];
          }

          try {
            const [specsRows] = await p.query('SELECT specifications, stock FROM products WHERE id = ?', [item.product_id]);
            if (specsRows.length > 0) {
              let specs = typeof specsRows[0].specifications === 'string'
                ? JSON.parse(specsRows[0].specifications || '{}')
                : specsRows[0].specifications;
              let totalStock = Number(specsRows[0].stock) + Number(item.quantity);
              if (specs && Array.isArray(specs.variants) && specs.variants.length > 0) {
                let vIdx = vName ? specs.variants.findIndex(v => v.name === vName) : 0;
                if (vIdx === -1) vIdx = 0;
                if (specs.variants[vIdx]) {
                  const curVStock = Number(specs.variants[vIdx].stock) || 0;
                  specs.variants[vIdx].stock = curVStock + Number(item.quantity);
                }
                totalStock = specs.variants.reduce((sum, v) => sum + (Number(v.stock) || 0), 0);
              }
              await p.query(
                'UPDATE products SET stock = ?, sold_count = GREATEST(0, sold_count - ?), specifications = ? WHERE id = ?',
                [totalStock, Number(item.quantity), JSON.stringify(specs), item.product_id]
              );
            }
          } catch (errVariant) {
            console.error('Lỗi khôi phục variant stock:', errVariant);
            await p.query(
              'UPDATE products SET stock = stock + ?, sold_count = GREATEST(0, sold_count - ?) WHERE id = ?',
              [Number(item.quantity), Number(item.quantity), item.product_id]
            );
          }

          await p.query(
            'UPDATE flash_sales SET sold_count = GREATEST(0, sold_count - ?) WHERE product_id = ? AND is_active = 1',
            [Number(item.quantity), item.product_id]
          );
        }
      } else if (existingOrder.order_status === 'cancelled' && order_status && order_status !== 'cancelled') {
        for (const item of existingOrder.items) {
          let vName = item.variant_name;
          if (!vName && item.product_name) {
            const match = item.product_name.match(/\(([^)]+)\)$/);
            if (match) vName = match[1];
          }

          try {
            const [specsRows] = await p.query('SELECT specifications, stock FROM products WHERE id = ?', [item.product_id]);
            if (specsRows.length > 0) {
              let specs = typeof specsRows[0].specifications === 'string'
                ? JSON.parse(specsRows[0].specifications || '{}')
                : specsRows[0].specifications;
              let totalStock = Math.max(0, Number(specsRows[0].stock) - Number(item.quantity));
              if (specs && Array.isArray(specs.variants) && specs.variants.length > 0) {
                let vIdx = vName ? specs.variants.findIndex(v => v.name === vName) : 0;
                if (vIdx === -1) vIdx = 0;
                if (specs.variants[vIdx]) {
                  const curVStock = Number(specs.variants[vIdx].stock) || 0;
                  specs.variants[vIdx].stock = Math.max(0, curVStock - Number(item.quantity));
                }
                totalStock = specs.variants.reduce((sum, v) => sum + (Number(v.stock) || 0), 0);
              }
              await p.query(
                'UPDATE products SET stock = ?, sold_count = sold_count + ?, specifications = ? WHERE id = ?',
                [totalStock, Number(item.quantity), JSON.stringify(specs), item.product_id]
              );
            }
          } catch (errVariant) {
            console.error('Lỗi trừ lại variant stock:', errVariant);
            await p.query(
              'UPDATE products SET stock = GREATEST(0, stock - ?), sold_count = sold_count + ? WHERE id = ?',
              [Number(item.quantity), Number(item.quantity), item.product_id]
            );
          }

          await p.query(
            'UPDATE flash_sales SET sold_count = sold_count + ? WHERE product_id = ? AND is_active = 1',
            [Number(item.quantity), item.product_id]
          );
        }
      }
    }

    const updates = [];
    const params = [];
    if (order_status) { updates.push('order_status = ?'); params.push(order_status); }
    if (payment_status) { updates.push('payment_status = ?'); params.push(payment_status); }
    if (transaction_id) { updates.push('transaction_id = ?'); params.push(transaction_id); }

    if (updates.length > 0) {
      const isNum = typeof identifier === 'number' || (typeof identifier === 'string' && /^\d+$/.test(identifier.trim()));
      if (isNum) {
        params.push(Number(identifier));
        await p.query(`UPDATE orders SET ${updates.join(', ')} WHERE id = ?`, params);
      } else {
        const code = String(identifier).trim().toUpperCase();
        params.push(code);
        await p.query(`UPDATE orders SET ${updates.join(', ')} WHERE UPPER(order_code) = ?`, params);
      }
    }
    return this.getOrderByCode(identifier);
  },

  // ==========================================
  // 4. ĐÁNH GIÁ SẢN PHẨM (Reviews) & XÁC THỰC MUA HÀNG
  // ==========================================
  
  /**
   * Kiểm tra xem tài khoản đã mua sản phẩm này chưa (dựa theo user_id, email, hoặc số điện thoại)
   */
  async checkUserPurchasedProduct(userId, userEmail, userPhone, productId) {
    const p = getPool();
    const cleanEmail = (userEmail || '').trim().toLowerCase();
    const cleanPhone = (userPhone || '').trim();
    const numUserId = userId ? Number(userId) : null;
    const numProductId = Number(productId);

    const [rows] = await p.query(
      `SELECT o.id, o.order_code, o.payment_status, o.order_status, o.created_at
       FROM orders o
       JOIN order_items oi ON o.id = oi.order_id
       WHERE oi.product_id = ?
         AND (
           (? IS NOT NULL AND o.user_id = ?)
           OR (? != '' AND LOWER(o.customer_email) = ?)
           OR (? != '' AND o.customer_phone = ?)
         )
         AND o.order_status != 'cancelled'
       ORDER BY o.id DESC
       LIMIT 1`,
      [numProductId, numUserId, numUserId, cleanEmail, cleanEmail, cleanPhone, cleanPhone]
    );

    return rows.length > 0 ? rows[0] : null;
  },

  /**
   * Lấy đánh giá hiện có của một người dùng đối với một sản phẩm
   */
  async getUserReview(productId, userId, userEmail, userPhone, userName) {
    const p = getPool();
    const numProductId = Number(productId);
    const numUserId = userId ? Number(userId) : null;
    const cleanName = (userName || '').trim();

    let query = 'SELECT * FROM reviews WHERE product_id = ? AND ';
    const params = [numProductId];

    if (numUserId) {
      query += '(user_id = ? OR user_name = ?)';
      params.push(numUserId, cleanName);
    } else {
      query += 'user_name = ?';
      params.push(cleanName);
    }
    query += ' ORDER BY id DESC LIMIT 1';

    const [rows] = await p.query(query, params);
    return rows.length > 0 ? rows[0] : null;
  },

  /**
   * Lấy toàn bộ danh sách đánh giá của sản phẩm
   */
  async getReviews(productId) {
    const p = getPool();
    const [rows] = await p.query(
      `SELECT r.*, u.avatar 
       FROM reviews r 
       LEFT JOIN users u ON r.user_id = u.id 
       WHERE r.product_id = ? 
       ORDER BY r.id DESC`,
      [Number(productId)]
    );
    return rows;
  },

  /**
   * Tạo mới hoặc cập nhật đánh giá (chỉ cho phép tài khoản đã mua, và chỉ có 1 đánh giá, cho phép cập nhật)
   */
  async saveOrUpdateReview({ product_id, user_id, user_name, user_email, user_phone, rating, comment }) {
    const p = getPool();
    const numProductId = Number(product_id);
    const numUserId = user_id ? Number(user_id) : null;
    const numRating = Math.max(1, Math.min(5, Number(rating) || 5));
    const cleanComment = (comment || '').trim();
    const cleanName = (user_name || 'Khách hàng').trim();

    // 1. Kiểm tra tài khoản đã mua sản phẩm này hay chưa
    const purchase = await this.checkUserPurchasedProduct(numUserId, user_email, user_phone, numProductId);
    if (!purchase) {
      const error = new Error('Chỉ tài khoản thật đã mua sản phẩm này tại TechStore mới được phép gửi đánh giá và chấm sao!');
      error.status = 403;
      throw error;
    }

    // 2. Kiểm tra xem người dùng đã từng đánh giá sản phẩm này chưa
    const existingReview = await this.getUserReview(numProductId, numUserId, user_email, user_phone, cleanName);

    let reviewId;
    let isUpdated = false;

    if (existingReview) {
      // Đã đánh giá -> Cho phép CẬP NHẬT chứ không tạo tiếp đánh giá thứ 2
      await p.query(
        `UPDATE reviews 
         SET rating = ?, comment = ?, user_name = ?, is_verified_buyer = 1, updated_at = NOW() 
         WHERE id = ?`,
        [numRating, cleanComment, cleanName, existingReview.id]
      );
      reviewId = existingReview.id;
      isUpdated = true;
    } else {
      // Chưa đánh giá -> Tạo đánh giá lần đầu
      const [res] = await p.query(
        `INSERT INTO reviews (product_id, user_id, user_name, rating, comment, is_verified_buyer, likes) 
         VALUES (?, ?, ?, ?, ?, 1, 0)`,
        [numProductId, numUserId, cleanName, numRating, cleanComment]
      );
      reviewId = res.insertId;
      isUpdated = false;
    }

    // 3. Tính toán lại số sao trung bình (dựa vào số sao rồi tính trung bình ra)
    const [agg] = await p.query(
      'SELECT COUNT(*) as count, AVG(rating) as avg_rating FROM reviews WHERE product_id = ?',
      [numProductId]
    );
    const count = Number(agg[0].count || 0);
    const avg = parseFloat(Number(agg[0].avg_rating || 5.0).toFixed(1));

    // Cập nhật lại vào bảng products
    await p.query(
      'UPDATE products SET rating = ?, reviews_count = ? WHERE id = ?',
      [avg, count, numProductId]
    );

    return {
      id: reviewId,
      product_id: numProductId,
      user_id: numUserId,
      user_name: cleanName,
      rating: numRating,
      comment: cleanComment,
      is_verified_buyer: 1,
      is_updated: isUpdated,
      avg_rating: avg,
      reviews_count: count,
      message: isUpdated ? 'Cập nhật đánh giá của bạn thành công!' : 'Gửi đánh giá thành công!'
    };
  },

  // ==========================================
  // 4.1 HỎI ĐÁP & THẢO LUẬN SẢN PHẨM (Q&A)
  // Dành cho người chưa mua có thể hỏi những người đã mua
  // ==========================================
  async getQuestions(productId) {
    const p = getPool();
    const numProductId = Number(productId);

    // Lấy câu hỏi chính
    const [questions] = await p.query(
      `SELECT q.*, u.avatar 
       FROM product_questions q 
       LEFT JOIN users u ON q.user_id = u.id 
       WHERE q.product_id = ? AND q.parent_id IS NULL 
       ORDER BY q.id DESC`,
      [numProductId]
    );

    // Lấy tất cả câu trả lời của sản phẩm này
    const [replies] = await p.query(
      `SELECT q.*, u.avatar 
       FROM product_questions q 
       LEFT JOIN users u ON q.user_id = u.id 
       WHERE q.product_id = ? AND q.parent_id IS NOT NULL 
       ORDER BY q.id ASC`,
      [numProductId]
    );

    const repliesMap = {};
    for (const r of replies) {
      if (!repliesMap[r.parent_id]) repliesMap[r.parent_id] = [];
      repliesMap[r.parent_id].push(r);
    }

    return questions.map(q => ({
      ...q,
      replies: repliesMap[q.id] || []
    }));
  },

  async createQuestion({ product_id, parent_id, user_id, user_name, user_email, user_phone, content, is_admin }) {
    const p = getPool();
    const numProductId = Number(product_id);
    const numParentId = parent_id ? Number(parent_id) : null;
    const numUserId = user_id ? Number(user_id) : null;
    const cleanName = (user_name || 'Khách hàng').trim();
    const cleanContent = (content || '').trim();

    // Tự động kiểm tra xem người đặt câu hỏi/trả lời này đã mua sản phẩm chưa
    const purchase = await this.checkUserPurchasedProduct(numUserId, user_email, user_phone, numProductId);
    const isBuyer = purchase ? 1 : 0;
    const isAdmin = is_admin ? 1 : 0;

    const [res] = await p.query(
      `INSERT INTO product_questions (product_id, parent_id, user_id, user_name, content, is_buyer, is_admin)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [numProductId, numParentId, numUserId, cleanName, cleanContent, isBuyer, isAdmin]
    );

    return {
      id: res.insertId,
      product_id: numProductId,
      parent_id: numParentId,
      user_id: numUserId,
      user_name: cleanName,
      content: cleanContent,
      is_buyer: isBuyer,
      is_admin: isAdmin,
      created_at: new Date().toISOString()
    };
  },

  // ==========================================
  // 5. MÃ GIẢM GIÁ (Coupons)
  // ==========================================
  async checkCoupon(code, orderValue = 0) {
    const p = getPool();
    const trimmed = (code || '').trim().toUpperCase();
    const [rows] = await p.query('SELECT * FROM coupons WHERE UPPER(code) = ? AND active = 1', [trimmed]);
    if (rows.length === 0) return null;

    const coupon = rows[0];
    if (orderValue < Number(coupon.min_order_value)) {
      return { error: `Mã ${coupon.code} chỉ áp dụng cho đơn từ ${new Intl.NumberFormat('vi-VN').format(coupon.min_order_value)}đ` };
    }

    const discount = Math.min((orderValue * Number(coupon.discount_percent)) / 100, Number(coupon.max_discount));
    return {
      code: coupon.code,
      discount_percent: Number(coupon.discount_percent),
      discount_amount: discount
    };
  },

  // ==========================================
  // 6. THỐNG KÊ CHO ADMIN (Stats)
  // ==========================================
  async getStats() {
    const p = getPool();
    const [revResult] = await p.query(
      "SELECT COALESCE(SUM(total_amount), 0) as totalRevenue FROM orders WHERE order_status != 'cancelled'"
    );
    const [orderCounts] = await p.query(`
      SELECT 
        COUNT(*) as totalOrders,
        SUM(CASE WHEN order_status = 'pending' THEN 1 ELSE 0 END) as pendingOrders,
        SUM(CASE WHEN order_status = 'completed' THEN 1 ELSE 0 END) as completedOrders
      FROM orders
    `);
    const [prodCount] = await p.query('SELECT COUNT(*) as totalProducts FROM products');
    const [reviewCount] = await p.query('SELECT COUNT(*) as totalReviews FROM reviews');

    return {
      totalRevenue: Number(revResult[0].totalRevenue || 0),
      totalOrders: Number(orderCounts[0].totalOrders || 0),
      pendingOrders: Number(orderCounts[0].pendingOrders || 0),
      completedOrders: Number(orderCounts[0].completedOrders || 0),
      totalProducts: Number(prodCount[0].totalProducts || 0),
      totalReviews: Number(reviewCount[0].totalReviews || 0),
      dbMode: 'mysql'
    };
  },

  // ==========================================
  // 7. TÀI KHOẢN & XÁC THỰC (Users)
  // ==========================================
  async findUserByEmailOrPhone(identifier) {
    const p = getPool();
    const term = (identifier || '').trim().toLowerCase();
    const [rows] = await p.query('SELECT * FROM users WHERE LOWER(email) = ? OR phone = ?', [term, term]);
    return rows.length > 0 ? rows[0] : null;
  },

  async findUserById(id) {
    const p = getPool();
    const [rows] = await p.query('SELECT id, name, email, phone, role, avatar, created_at FROM users WHERE id = ?', [id]);
    return rows.length > 0 ? rows[0] : null;
  },

  async createUser({ name, email, phone, password, role = 'user' }) {
    const p = getPool();
    const avatar = 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80';
    const [res] = await p.query(
      'INSERT INTO users (name, email, phone, password, role, avatar) VALUES (?, ?, ?, ?, ?, ?)',
      [name.trim(), (email || '').trim().toLowerCase(), (phone || '').trim(), password, role || 'user', avatar]
    );
    return this.findUserById(res.insertId);
  },

  async getUsers() {
    const p = getPool();
    const [rows] = await p.query('SELECT id, name, email, phone, role, avatar, created_at FROM users ORDER BY id DESC');
    return rows;
  },

  // ==========================================
  // 8. FLASHSALE (Flash Sales)
  // ==========================================
  async getFlashSales() {
    const p = getPool();
    const sql = `
      SELECT fs.*, 
             p.name, p.slug, p.brand, p.price,
             COALESCE(p.original_price, p.price) as original_price, 
             p.image_url, p.rating, p.reviews_count, p.stock as actual_stock
      FROM flash_sales fs
      JOIN products p ON fs.product_id = p.id
      WHERE fs.is_active = 1
      ORDER BY fs.id ASC
    `;
    const [rows] = await p.query(sql);
    return rows;
  },

  async createFlashSale({ product_id, flash_price, flash_stock = 20, sold_count = 0, end_time, is_active = 1 }) {
    const p = getPool();
    const endTimeVal = end_time || '2026-12-31 23:59:59';
    const [res] = await p.query(
      'INSERT INTO flash_sales (product_id, flash_price, flash_stock, sold_count, end_time, is_active) VALUES (?, ?, ?, ?, ?, ?)',
      [product_id, flash_price, flash_stock, sold_count, endTimeVal, is_active]
    );
    return res.insertId;
  },

  async deleteFlashSale(id) {
    const p = getPool();
    await p.query('DELETE FROM flash_sales WHERE id = ?', [id]);
    return true;
  },

  async updateFlashSale(id, data) {
    const p = getPool();
    const fields = [];
    const params = [];
    if (data.flash_price !== undefined) { fields.push('flash_price = ?'); params.push(data.flash_price); }
    if (data.flash_stock !== undefined) { fields.push('flash_stock = ?'); params.push(data.flash_stock); }
    if (data.sold_count !== undefined) { fields.push('sold_count = ?'); params.push(data.sold_count); }
    if (data.is_active !== undefined) { fields.push('is_active = ?'); params.push(data.is_active); }
    if (data.end_time !== undefined) { fields.push('end_time = ?'); params.push(data.end_time); }
    if (fields.length === 0) return false;
    params.push(id);
    await p.query(`UPDATE flash_sales SET ${fields.join(', ')} WHERE id = ?`, params);
    return true;
  }
};

module.exports = db;
