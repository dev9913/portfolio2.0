CREATE DATABASE IF NOT EXISTS portfolio_db;

CREATE USER IF NOT EXISTS 'portfolio'@'%' IDENTIFIED BY 'admin123';  -- db_user=portfolio db_password=admin123
GRANT ALL PRIVILEGES ON portfolio_db.* TO 'portfolio'@'%';
FLUSH PRIVILEGES;

USE portfolio_db;

CREATE TABLE IF NOT EXISTS messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  replied_message TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

