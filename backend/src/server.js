const express = require('express');
const mysql = require('mysql2');
const multer = require('multer');
const cors = require('cors');
const path = require('path');
const db = require('./db/db'); // or relative path to your db file
const nodemailer = require('nodemailer');

const app = express();

app.use(cors({
    origin: 'http://localhost:3000'
}));



// Middleware to parse JSON and URL-encoded data
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Multer setup for form-data (without file uploads)
const upload = multer();

// Serve HTML contact form
app.get('/contact', (req, res) => {
    res.sendFile(path.join(__dirname, 'contact.html'));
});

// Handle form submission
app.post('/contact', upload.none(), (req, res) => {
  const { name, email, message } = req.body;
  const errors = [];

  // Validate input fields
  if (!name) errors.push('Name is required.');
  if (!email) errors.push('Email is required.');
  if (!message) errors.push('Message is required.');
  if (email && !/^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$/.test(email)) {
    errors.push('Invalid email format.');
  }

  if (errors.length > 0) {
    return res.status(400).json({ status: 'error', errors });
  }

  // Save form data to the database (immediate response)
  const date = new Date().toISOString().slice(0, 19).replace('T', ' ');
  const query = 'INSERT INTO messages (name, email, message) VALUES (?, ?, ?)';

//  db.execute(query, [name, email, message], (err, result) => {
    db.query(query, [name, email, message], (err, result) => {
    if (err) {
      console.error('Database Error:', err);
      return res.status(500).json({ status: 'error', message: 'Database error' });
    }

    res.status(200).json({ status: 'success', message: 'Message sent successfully!' });

        // // Send email asynchronously after redirect
        // const transporter = nodemailer.createTransport({
        //     service: 'gmail',
        //     auth: {
        //         user: process.env.EMAIL_USER,
        //         pass: process.env.EMAIL_PASS,
        //     },
        // });

        // const mailOptions = {
        //     from: process.env.EMAIL_USER,
        //     to: process.env.ADMIN_EMAIL,
        //     subject: `New Contact Form Message from ${name}`,
        //     text: `You have received a new message from ${name} (${email}):\n\n${message}`,
        // };

        // transporter.sendMail(mailOptions, (err, info) => {
        //     if (err) {
        //         console.log(err);
        //     } else {
        //         console.log('Email sent: ' + info.response);
        //     }
        // });
    });
});

// OK
app.get('/contact', (req, res) => {
     res.sendFile(path.join(__dirname, 'contact.html'));  
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
