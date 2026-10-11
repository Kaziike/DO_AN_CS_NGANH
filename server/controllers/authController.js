const db = require('../config/db');

// Đăng ký tài khoản mới
exports.register = async (req, res) => {
  try {
    const { name, email, phone, password } = req.body;

    if (!name || (!email && !phone) || !password) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng điền đầy đủ họ tên, số điện thoại hoặc email, và mật khẩu.'
      });
    }

    if (password.length < 3) {
      return res.status(400).json({
        success: false,
        message: 'Mật khẩu phải có độ dài tối thiểu 3 ký tự.'
      });
    }

    // Kiểm tra xem email hoặc số điện thoại đã tồn tại chưa
    if (email) {
      const existingEmail = await db.findUserByEmailOrPhone(email);
      if (existingEmail) {
        return res.status(400).json({
          success: false,
          message: `Email "${email}" đã được đăng ký trên hệ thống. Vui lòng đăng nhập hoặc sử dụng email khác.`
        });
      }
    }

    if (phone) {
      const existingPhone = await db.findUserByEmailOrPhone(phone);
      if (existingPhone) {
        return res.status(400).json({
          success: false,
          message: `Số điện thoại "${phone}" đã được đăng ký trên hệ thống. Vui lòng đăng nhập.`
        });
      }
    }

    // Tạo người dùng mới
    const newUser = await db.createUser({
      name,
      email: email || '',
      phone: phone || '',
      password,
      role: 'user'
    });

    res.status(201).json({
      success: true,
      message: 'Đăng ký tài khoản thành công! Bạn có thể mua sắm và theo dõi đơn hàng ngay bây giờ.',
      data: newUser
    });
  } catch (error) {
    console.error('Error in register:', error);
    res.status(500).json({ success: false, message: 'Lỗi máy chủ khi đăng ký', error: error.message });
  }
};

// Đăng nhập
exports.login = async (req, res) => {
  try {
    const { identifier, password } = req.body; // identifier có thể là email hoặc phone

    if (!identifier || !password) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập Email / Số điện thoại và Mật khẩu.'
      });
    }

    const user = await db.findUserByEmailOrPhone(identifier);
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Tài khoản không tồn tại trên hệ thống. Vui lòng kiểm tra lại hoặc Đăng ký.'
      });
    }

    // So sánh mật khẩu (plain text hoặc đơn giản cho đồ án)
    if (user.password !== password) {
      return res.status(401).json({
        success: false,
        message: 'Mật khẩu không chính xác. Vui lòng thử lại.'
      });
    }

    const { password: pwd, ...safeUser } = user;

    res.json({
      success: true,
      message: `Chào mừng ${safeUser.name} đã đăng nhập thành công!`,
      data: safeUser
    });
  } catch (error) {
    console.error('Error in login:', error);
    res.status(500).json({ success: false, message: 'Lỗi máy chủ khi đăng nhập', error: error.message });
  }
};

// Lấy thông tin tài khoản hiện tại
exports.getMe = async (req, res) => {
  try {
    const userId = req.query.id;
    if (!userId) {
      return res.status(400).json({ success: false, message: 'Thiếu mã người dùng' });
    }
    const user = await db.findUserById(userId);
    if (!user) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy thông tin tài khoản' });
    }
    res.json({ success: true, data: user });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Lỗi lấy thông tin', error: error.message });
  }
};
