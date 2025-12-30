const mysql = require('mysql2');
const dotenv = require('dotenv');

dotenv.config();

const pool = mysql.createPool({
  host: process.env.DB_HOST ,
  user: process.env.DB_USER ,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,  // You can adjust this based on your requirements
  queueLimit: 0
});

// Automatically create the table if it doesn't exist
const createTableQuery = `
  CREATE TABLE IF NOT EXISTS messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    replied_message TEXT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    date DATE 
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
`;

pool.query(createTableQuery, (err, results) => {
  if (err) {
    console.error('Error creating table:', err);
  } else {
    console.log('Messages table ensured.');
  }
});

module.exports = pool;

