const nodemailer = require('nodemailer');
const db = require('../db/db'); // MySQL connection

// Handle contact form submission
const handleContactForm = (req, res) => {
  const { name, email, message } = req.body;
  const errors = [];

  // Validate the input
  if (!name) errors.push('Name is required.');
  if (!email) errors.push('Email is required.');
  if (!message) errors.push('Message is required.');
  if (email && !/^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$/.test(email)) {
    errors.push('Invalid email format.');
  }

  if (errors.length > 0) {
    return res.status(400).json({ status: 'error', errors });
  }

  const date = new Date().toISOString().slice(0, 19).replace('T', ' ');

  // Save form data to DB
  const query = 'INSERT INTO messages (name, email, message, date) VALUES (?, ?, ?, ?)';
  db.query(query, [name, email, message, date], (err, result) => {
    if (err) {
      return res.status(500).json({ status: 'error', message: 'Database error' });
    }

    // Send email to admin using nodemailer
    const transporter = nodemailer.createTransport({
      service: 'gmail', // You can use other email services too like SendGrid, Mailgun, etc.
      auth: {
        user: process.env.EMAIL_USER, // Your email address
        pass: process.env.EMAIL_PASS, // Your email password
      },
    });

    const mailOptions = {
      from: process.env.EMAIL_USER, // Your email address
      to: process.env.ADMIN_EMAIL, // Admin email
      subject: `New Contact Form Message from ${name}`,
      text: `You have received a new message from ${name} (${email}):\n\n${message}`,
    };

    transporter.sendMail(mailOptions, (mailErr, info) => {
      if (mailErr) {
        console.log(mailErr);
        return res.status(500).json({ status: 'error', message: 'Email sending failed' });
      }

      console.log('Email sent: ' + info.response);

      // Return success response
      res.status(200).json({ status: 'success', message: 'Message sent successfully!' });
    });
  });
};

module.exports = { handleContactForm };
