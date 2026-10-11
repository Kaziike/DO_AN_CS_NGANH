const db = require('../config/db');

// Lấy danh sách sản phẩm (có lọc, tìm kiếm, phân trang)
exports.getProducts = async (req, res) => {
  try {
    const { category, brand, minPrice, maxPrice, minRating, sort, search, featured, cpu, gpu, ram, storage, screen, feature, connection, page, limit } = req.query;
    const result = await db.getProducts({
      category,
      brand,
      minPrice,
      maxPrice,
      minRating,
      sort,
      search,
      featured: featured === 'true' || featured === '1',
      cpu,
      gpu,
      ram,
      storage,
      screen,
      feature,
      connection,
      page: page || 1,
      limit: limit || 12
    });
    res.json({ success: true, data: result });
  } catch (error) {
    console.error('Error in getProducts:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi lấy danh sách sản phẩm', error: error.message });
  }
};

// Lấy chi tiết sản phẩm theo ID
exports.getProductById = async (req, res) => {
  try {
    const product = await db.getProductById(req.params.id);
    if (!product) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy sản phẩm' });
    }
    res.json({ success: true, data: product });
  } catch (error) {
    console.error('Error in getProductById:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi lấy chi tiết sản phẩm', error: error.message });
  }
};

// Lấy danh mục sản phẩm
exports.getCategories = async (req, res) => {
  try {
    const categories = await db.getCategories();
    res.json({ success: true, data: categories });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi khi lấy danh mục', error: error.message });
  }
};

// Admin: Thêm sản phẩm mới
exports.createProduct = async (req, res) => {
  try {
    const { name, category_id, brand, price, original_price, stock, image_url, short_description, specifications } = req.body;
    if (!name || !price) {
      return res.status(400).json({ success: false, message: 'Tên và giá sản phẩm là bắt buộc' });
    }
    const product = await db.createProduct(req.body);
    res.status(201).json({ success: true, message: 'Thêm sản phẩm thành công', data: product });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi khi thêm sản phẩm', error: error.message });
  }
};

// Admin: Cập nhật sản phẩm
exports.updateProduct = async (req, res) => {
  try {
    const updated = await db.updateProduct(req.params.id, req.body);
    if (!updated) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy sản phẩm để cập nhật' });
    }
    res.json({ success: true, message: 'Cập nhật sản phẩm thành công', data: updated });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi khi cập nhật sản phẩm', error: error.message });
  }
};

// Admin: Xóa sản phẩm
exports.deleteProduct = async (req, res) => {
  try {
    await db.deleteProduct(req.params.id);
    res.json({ success: true, message: 'Xóa sản phẩm thành công' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi khi xóa sản phẩm', error: error.message });
  }
};

// --- FLASHSALE CONTROLLER ---
// Lấy danh sách Flash Sale đang hoạt động
exports.getFlashSales = async (req, res) => {
  try {
    const flashSales = await db.getFlashSales();
    res.json({ success: true, data: flashSales });
  } catch (error) {
    console.error('Error in getFlashSales:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi tải danh sách Flash Sale', error: error.message });
  }
};

// Admin: Tạo mới Flash Sale
exports.createFlashSale = async (req, res) => {
  try {
    const { product_id, flash_price, flash_stock, sold_count, end_time } = req.body;
    if (!product_id || !flash_price) {
      return res.status(400).json({ success: false, message: 'Vui lòng chọn sản phẩm và nhập giá Flash Sale' });
    }
    const id = await db.createFlashSale({ product_id, flash_price, flash_stock, sold_count, end_time });
    res.status(201).json({ success: true, message: 'Thêm sản phẩm vào Flash Sale thành công', data: { id } });
  } catch (error) {
    console.error('Error in createFlashSale:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi thêm Flash Sale', error: error.message });
  }
};

// Admin: Xóa Flash Sale
exports.deleteFlashSale = async (req, res) => {
  try {
    await db.deleteFlashSale(req.params.id);
    res.json({ success: true, message: 'Đã xóa sản phẩm khỏi Flash Sale' });
  } catch (error) {
    console.error('Error in deleteFlashSale:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi xóa Flash Sale', error: error.message });
  }
};
