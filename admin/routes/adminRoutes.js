const express = require("express");
const router = express.Router();
const controller = require("../controllers/adminController");
const { isAuthenticated } = require("../middleware/auth");

router.get("/", controller.showLogin);
router.post("/login", controller.login);
router.get("/dashboard", isAuthenticated, controller.dashboard);
router.post("/delete", isAuthenticated, controller.deleteMessage);
router.get("/logout", controller.logout);

module.exports = router;

