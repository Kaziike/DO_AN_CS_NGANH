const express = require('express');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const db = require('./config/db');
const apiRoutes = require('./routes/api');

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Phục vụ tệp tĩnh trong thư mục public (tự động khớp .html nếu không có phần mở rộng)
app.use(express.static(path.join(__dirname, '..', 'public'), { extensions: ['html'] }));

// Gắn API Routes
app.use('/api', apiRoutes);

// Fallback trang chủ cho SPA/Static
app.get('*', (req, res, next) => {
  if (req.path.startsWith('/api')) {
    return next();
  }
  res.sendFile(path.join(__dirname, '..', 'public', 'index.html'));
});

// Khởi động server
async function startServer() {
  try {
    // Khởi tạo kết nối MySQL duy nhất
    await db.init();
    
    app.listen(PORT, () => {
      console.log('==================================================');
      console.log(`🚀 TECHSTORE SERVER ĐANG CHẠY TẠI: http://localhost:${PORT}`);
      console.log(`📦 Bảng điều khiển Quản trị: http://localhost:${PORT}/admin.html`);
      console.log(`💾 Cơ sở dữ liệu: [MySQL - techstore_db]`);
      console.log('==================================================');
    });
  } catch (err) {
    console.error('❌ Lỗi khởi động server: Không thể kết nối cơ sở dữ liệu MySQL!', err.message);
    process.exit(1);
  }
}

startServer();
