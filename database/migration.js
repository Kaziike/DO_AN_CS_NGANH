const mysql = require('mysql2/promise');
require('dotenv').config();

async function runMigration() {
  const host = process.env.DB_HOST || 'localhost';
  const user = process.env.DB_USER || 'root';
  const password = process.env.DB_PASSWORD || '123456';
  const database = process.env.DB_NAME || 'techstore_db';
  const port = parseInt(process.env.DB_PORT || '3306', 10);

  const conn = await mysql.createConnection({ host, user, password, database, port });
  console.log('Connected to MySQL for migration...');

  // 1. Check orders.user_id
  const [orderCols] = await conn.query('DESCRIBE orders');
  if (!orderCols.some(c => c.Field === 'user_id')) {
    console.log('Adding user_id to orders table...');
    await conn.query('ALTER TABLE orders ADD COLUMN user_id INT NULL AFTER id');
  }

  // 2. Check reviews.user_id and updated_at
  const [reviewCols] = await conn.query('DESCRIBE reviews');
  if (!reviewCols.some(c => c.Field === 'user_id')) {
    console.log('Adding user_id to reviews table...');
    await conn.query('ALTER TABLE reviews ADD COLUMN user_id INT NULL AFTER product_id');
  }
  if (!reviewCols.some(c => c.Field === 'updated_at')) {
    console.log('Adding updated_at to reviews table...');
    await conn.query('ALTER TABLE reviews ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP');
  }

  // 3. Create product_questions table
  console.log('Ensuring product_questions table exists...');
  await conn.query(`
    CREATE TABLE IF NOT EXISTS product_questions (
      id INT AUTO_INCREMENT PRIMARY KEY,
      product_id INT NOT NULL,
      parent_id INT NULL DEFAULT NULL,
      user_id INT NULL,
      user_name VARCHAR(150) NOT NULL,
      content TEXT NOT NULL,
      is_buyer TINYINT(1) DEFAULT 0,
      is_admin TINYINT(1) DEFAULT 0,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      INDEX idx_product (product_id),
      INDEX idx_parent (parent_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  `);

  console.log('✅ Migration successfully executed!');
  await conn.end();
}

runMigration().catch(err => {
  console.error('Migration failed:', err);
  process.exit(1);
});
