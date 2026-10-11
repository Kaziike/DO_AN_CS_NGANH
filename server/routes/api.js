const express = require('express');
const router = express.Router();

const productController = require('../controllers/productController');
const orderController = require('../controllers/orderController');
const reviewController = require('../controllers/reviewController');
const paymentController = require('../controllers/paymentController');
const authController = require('../controllers/authController');
const db = require('../config/db');

// Middleware kiểm tra quyền Quản trị viên
const requireAdmin = (req, res, next) => {
  const role = req.headers['x-user-role'];
  if (role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: 'Từ chối truy cập! Chức năng này chỉ dành riêng cho tài khoản Quản Trị Viên (Admin).'
    });
  }
  next();
};

// --- AUTH ROUTES ---
router.post('/auth/register', authController.register);
router.post('/auth/login', authController.login);
router.get('/auth/me', authController.getMe);

// --- PRODUCT ROUTES ---
router.get('/products', productController.getProducts);
router.get('/products/:id', productController.getProductById);
router.post('/products', requireAdmin, productController.createProduct);
router.put('/products/:id', requireAdmin, productController.updateProduct);
router.delete('/products/:id', requireAdmin, productController.deleteProduct);

// --- FLASHSALE ROUTES ---
router.get('/flash-sales', productController.getFlashSales);
router.post('/flash-sales', requireAdmin, productController.createFlashSale);
router.delete('/flash-sales/:id', requireAdmin, productController.deleteFlashSale);

// --- CATEGORY ROUTES ---
router.get('/categories', productController.getCategories);

// --- ORDER ROUTES ---
router.post('/orders', orderController.createOrder);
router.get('/orders', requireAdmin, orderController.getOrders);
router.get('/orders/track/:code', orderController.trackOrder);
router.patch('/orders/:id/status', requireAdmin, orderController.updateOrderStatus);

// --- COUPON ROUTES ---
router.post('/coupons/validate', orderController.validateCoupon);

// --- REVIEW ROUTES ---
router.get('/products/:productId/reviews', reviewController.getReviewsByProductId);
router.get('/products/:productId/review-permission', reviewController.getReviewPermission);
router.post('/reviews', reviewController.createOrUpdateReview);

// --- Q&A / THẢO LUẬN & HỎI ĐÁP ROUTES ---
router.get('/products/:productId/questions', reviewController.getQuestions);
router.post('/products/:productId/questions', reviewController.createQuestion);

// --- PAYMENT SIMULATION ROUTES ---
router.post('/payment/init', paymentController.initPayment);
router.post('/payment/verify', paymentController.verifyPayment);

// --- SYSTEM & STATS ROUTES ---
router.get('/stats', requireAdmin, async (req, res) => {
  try {
    const stats = await db.getStats();
    res.json({ success: true, data: stats });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi lấy thống kê', error: error.message });
  }
});

module.exports = router;
