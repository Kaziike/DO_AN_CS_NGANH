const db = require('../config/db');

// Tạo đơn hàng mới
exports.createOrder = async (req, res) => {
  try {
    const {
      user_id,
      customer_name,
      customer_phone,
      customer_email,
      shipping_address,
      shipping_method,
      shipping_fee,
      discount_amount,
      total_amount,
      payment_method,
      notes,
      items
    } = req.body;

    if (!customer_name || !customer_phone || !shipping_address) {
      return res.status(400).json({ success: false, message: 'Vui lòng điền đủ tên, số điện thoại và địa chỉ giao hàng' });
    }

    if (!items || !items.length) {
      return res.status(400).json({ success: false, message: 'Giỏ hàng đang trống' });
    }

    const order = await db.createOrder({
      user_id: user_id || null,
      customer_name,
      customer_phone,
      customer_email,
      shipping_address,
      shipping_method,
      shipping_fee,
      discount_amount,
      total_amount,
      payment_method,
      notes,
      items
    });

    res.status(201).json({
      success: true,
      message: 'Đặt hàng thành công!',
      data: order
    });
  } catch (error) {
    console.error('Error in createOrder:', error);
    res.status(400).json({ success: false, message: error.message || 'Lỗi khi tạo đơn hàng' });
  }
};

// Lấy danh sách tất cả đơn hàng (cho Admin)
exports.getOrders = async (req, res) => {
  try {
    const orders = await db.getOrders();
    res.json({ success: true, data: orders });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi khi lấy danh sách đơn hàng', error: error.message });
  }
};

// Tra cứu đơn hàng theo Mã đơn hoặc Số điện thoại
exports.trackOrder = async (req, res) => {
  try {
    const { code } = req.params;
    const order = await db.getOrderByCode(code);
    if (!order) {
      return res.status(404).json({
        success: false,
        message: `Không tìm thấy đơn hàng với mã hoặc số điện thoại: "${code}". Vui lòng kiểm tra lại.`
      });
    }
    res.json({ success: true, data: order });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi khi tra cứu đơn hàng', error: error.message });
  }
};

// Cập nhật trạng thái đơn hàng (cho Admin)
exports.updateOrderStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { order_status, payment_status } = req.body;
    const updated = await db.updateOrderStatus(id, { order_status, payment_status });
    if (!updated) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy đơn hàng để cập nhật' });
    }
    res.json({ success: true, message: 'Cập nhật trạng thái đơn hàng thành công', data: updated });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi khi cập nhật trạng thái', error: error.message });
  }
};

// Kiểm tra mã giảm giá
exports.validateCoupon = async (req, res) => {
  try {
    const { code, order_value } = req.body;
    if (!code) {
      return res.status(400).json({ success: false, message: 'Vui lòng nhập mã giảm giá' });
    }
    const result = await db.checkCoupon(code, Number(order_value || 0));
    if (!result) {
      return res.status(404).json({ success: false, message: 'Mã giảm giá không tồn tại hoặc đã hết hạn' });
    }
    if (result.error) {
      return res.status(400).json({ success: false, message: result.error });
    }
    res.json({
      success: true,
      message: `Áp dụng thành công giảm ${result.discount_percent}%!`,
      data: result
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi khi kiểm tra mã giảm giá', error: error.message });
  }
};
