const db = require('../config/db');

// 1. Lấy danh sách đánh giá của sản phẩm
exports.getReviewsByProductId = async (req, res) => {
  try {
    const { productId } = req.params;
    const reviews = await db.getReviews(productId);
    res.json({ success: true, data: reviews });
  } catch (error) {
    console.error('Error in getReviewsByProductId:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi lấy đánh giá', error: error.message });
  }
};

// 2. Kiểm tra quyền đánh giá của tài khoản (đã mua chưa? đã từng đánh giá chưa?)
exports.getReviewPermission = async (req, res) => {
  try {
    const { productId } = req.params;
    const { userId, email, phone, userName } = req.query;

    const purchase = await db.checkUserPurchasedProduct(userId, email, phone, productId);
    const existingReview = await db.getUserReview(productId, userId, email, phone, userName);

    res.json({
      success: true,
      data: {
        hasPurchased: !!purchase,
        hasReviewed: !!existingReview,
        existingReview: existingReview || null,
        purchaseInfo: purchase ? {
          order_code: purchase.order_code,
          created_at: purchase.created_at
        } : null
      }
    });
  } catch (error) {
    console.error('Error in getReviewPermission:', error);
    res.status(500).json({ success: false, message: 'Lỗi kiểm tra quyền đánh giá', error: error.message });
  }
};

// 3. Gửi mới hoặc cập nhật đánh giá (Chỉ tài khoản đã mua mới được gửi)
exports.createOrUpdateReview = async (req, res) => {
  try {
    const { product_id, user_id, user_name, user_email, user_phone, rating, comment } = req.body;

    if (!product_id || !rating || !comment) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng cung cấp đầy đủ số sao đánh giá và nội dung nhận xét!'
      });
    }

    const result = await db.saveOrUpdateReview({
      product_id,
      user_id,
      user_name,
      user_email,
      user_phone,
      rating: parseInt(rating, 10),
      comment
    });

    res.status(200).json({
      success: true,
      message: result.message,
      data: result
    });
  } catch (error) {
    console.error('Error in createOrUpdateReview:', error);
    const status = error.status || 500;
    res.status(status).json({
      success: false,
      message: error.message || 'Lỗi khi lưu đánh giá',
      error: error.message
    });
  }
};

// 4. Lấy danh sách hỏi đáp thảo luận về sản phẩm (Q&A)
exports.getQuestions = async (req, res) => {
  try {
    const { productId } = req.params;
    const questions = await db.getQuestions(productId);
    res.json({ success: true, data: questions });
  } catch (error) {
    console.error('Error in getQuestions:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi tải danh sách hỏi đáp', error: error.message });
  }
};

// 5. Đăng câu hỏi mới hoặc gửi câu trả lời
exports.createQuestion = async (req, res) => {
  try {
    const { productId } = req.params;
    const { parent_id, user_id, user_name, user_email, user_phone, content, is_admin } = req.body;

    if (!content || !content.trim()) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập nội dung câu hỏi hoặc câu trả lời!'
      });
    }

    const question = await db.createQuestion({
      product_id: productId,
      parent_id: parent_id || null,
      user_id: user_id || null,
      user_name: user_name || 'Khách hàng',
      user_email: user_email || '',
      user_phone: user_phone || '',
      content: content.trim(),
      is_admin: is_admin ? 1 : 0
    });

    res.status(201).json({
      success: true,
      message: parent_id ? 'Đã gửi câu trả lời thành công!' : 'Đã đăng câu hỏi thành công!',
      data: question
    });
  } catch (error) {
    console.error('Error in createQuestion:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi gửi câu hỏi/trả lời', error: error.message });
  }
};
