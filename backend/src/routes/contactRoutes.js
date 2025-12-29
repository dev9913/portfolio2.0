const express = require('express');
const router = express.Router();
const contactController = require('../controllers/contactController');

// POST route to handle contact form submission
router.post('/contact', contactController.handleContactForm);

module.exports = router;
