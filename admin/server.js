const express = require("express");
const session = require("express-session");
const path = require("path");
const adminRoutes = require("./routes/adminRoutes");
const { waitForDB, pool } = require("./config/db");

const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.use("/admin", express.static(path.join(__dirname, "public")));

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

app.use(
  session({
    secret: process.env.ADMIN_PASSWORD || "admin",
    resave: false,
    saveUninitialized: false,
  })
);

app.use("/admin", adminRoutes);

app.get("/", (req, res) => {
  res.redirect("/admin");
});

const PORT = 5001;

async function start() {
  await waitForDB();
  app.listen(PORT, () => {
    console.log(`Admin running on port ${PORT}`);
  });
}

start();

