const mysql = require("mysql2/promise");

const pool = mysql.createPool({
  host: process.env.DB_HOST ,
  user: process.env.DB_USER ,
  password: process.env.DB_PASSWORD ,
  database: process.env.DB_NAME ,
  waitForConnections: true,
  connectionLimit: 10,
});

async function waitForDB(retries = 10) {
  while (retries) {
    try {
      await pool.query("SELECT 1");
      console.log(" MySQL connected");
      return;
    } catch (err) {
      console.log(" Waiting for DB...");
      await new Promise(r => setTimeout(r, 3000));
      retries--;
    }
  }
  throw new Error("DB not available");
}

module.exports = { pool, waitForDB };

