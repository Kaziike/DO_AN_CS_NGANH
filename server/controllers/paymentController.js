const db = require('../config/db');

// Khởi tạo phiên thanh toán giả lập
exports.initPayment = async (req, res) => {
  try {
    const { order_id, order_code, amount, method, customer_name, customer_phone } = req.body;

    if (!amount || !method) {
      return res.status(400).json({ success: false, message: 'Thiếu thông tin số tiền hoặc phương thức thanh toán' });
    }

    const transaction_ref = `TXN_${Date.now()}_${Math.floor(Math.random() * 1000)}`;

    let paymentData = {
      order_id,
      order_code,
      amount: Number(amount),
      method,
      transaction_ref,
      status: 'pending',
      created_at: new Date().toISOString()
    };

    if (method === 'vnpay') {
      paymentData.gateway_name = 'VNPAY-QR';
      paymentData.qr_url = `https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=00020101021238540010A00000072701240006970407011009123456780208QRIBFTTA5303704540${amount}5802VN62180814${order_code || 'TECH'}6304`;
      paymentData.demo_otp = '123456';
      paymentData.expires_in = 600; // 10 phút
    } else if (method === 'momo') {
      paymentData.gateway_name = 'MoMo Smart Payment';
      paymentData.qr_url = `https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=2|99|0912345678|${encodeURIComponent(customer_name || 'Khach Hang')}|user@momo.vn|0|0|${amount}|${order_code || 'TECH'}|transfer_myqr`;
      paymentData.demo_otp = '654321';
      paymentData.expires_in = 600;
    } else if (method === 'credit_card') {
      paymentData.gateway_name = 'Visa / Mastercard / JCB Gateway';
      paymentData.demo_otp = '888888';
      paymentData.requires_3d_secure = true;
    }

    res.json({
      success: true,
      message: 'Khởi tạo cổng thanh toán thành công',
      data: paymentData
    });
  } catch (error) {
    console.error('Error in initPayment:', error);
    res.status(500).json({ success: false, message: 'Lỗi khởi tạo cổng thanh toán', error: error.message });
  }
};

// Xác thực thanh toán giả lập
exports.verifyPayment = async (req, res) => {
  try {
    const { order_id, order_code, method, otp, card_number, status } = req.body;

    // Giả lập từ chối nếu status gửi lên là 'cancel'
    if (status === 'cancel') {
      const targetIdentifier = order_id || order_code;
      if (targetIdentifier) {
        await db.updateOrderStatus(targetIdentifier, {
          payment_status: 'unpaid',
          order_status: 'pending'
        });
      }
      return res.json({
        success: false,
        cancelled: true,
        message: 'Giao dịch đã bị người dùng hủy bỏ.'
      });
    }

    // Kiểm tra OTP giả lập (chấp nhận 6 số, hoặc nếu không truyền thì tự động hợp lệ để test)
    const validOtp = (otp && otp.trim().length === 6) ? otp.trim() : '123456';

    const transaction_id = `${(method || 'PAY').toUpperCase()}_${Date.now()}`;
    const targetIdentifier = order_id || order_code;

    // Cập nhật trạng thái đơn hàng sang 'paid' và 'confirmed'
    let updatedOrder = null;
    if (targetIdentifier) {
      updatedOrder = await db.updateOrderStatus(targetIdentifier, {
        payment_status: 'paid',
        order_status: 'confirmed',
        transaction_id
      });
    }

    res.json({
      success: true,
      message: 'Thanh toán thành công! Đơn hàng của bạn đã được xác nhận thanh toán.',
      data: {
        order_id: updatedOrder ? updatedOrder.id : order_id,
        order_code: updatedOrder ? updatedOrder.order_code : order_code,
        transaction_id,
        paid_at: new Date().toISOString(),
        payment_status: 'paid',
        order_status: 'confirmed'
      }
    });
  } catch (error) {
    console.error('Error in verifyPayment:', error);
    res.status(500).json({ success: false, message: 'Lỗi xác thực thanh toán: ' + error.message, error: error.message });
  }
};
