const  { pool }  = require("../config/db");

exports.showLogin = (req, res) => {
  res.render("login", { error: null });
};

exports.login = (req, res) => {
  if (req.body.password === process.env.ADMIN_PASSWORD) {
    req.session.logged_in = true;
    return res.redirect("/admin/dashboard");
  }
  res.render("login", { error: "Invalid password" });
};

exports.dashboard = async (req, res) => {
  try {
    const [rows] = await pool.query(
      "SELECT * FROM messages ORDER BY created_at DESC"
    );

    // Format date properly (India timezone)
    const formattedMessages = rows.map((msg) => ({
      ...msg,
      formatted_date: new Date(msg.created_at).toLocaleString("en-IN", {
        timeZone: "Asia/Kolkata",
        year: "numeric",
        month: "short",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit",
      }),
    }));

    res.render("dashboard", { messages: formattedMessages });

  } catch (err) {
    console.error("Dashboard Error:", err.message);
    res.status(500).send("Database error");
  }
};


exports.deleteMessage = async (req, res) => {
  await pool.query("DELETE FROM messages WHERE id = ?", [
    req.body.message_id,
  ]);
  res.redirect("/admin/dashboard");
};

exports.logout = (req, res) => {
  req.session.destroy(() => {
    res.redirect("/admin");
  });
};

