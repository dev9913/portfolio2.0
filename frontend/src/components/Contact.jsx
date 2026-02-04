import React, { useState } from 'react';
import githubIcon from "../assets/github.png";
import linkedinIcon from "../assets/linkedin.png";
import twitterIcon from "../assets/twitter.png";
import instagramIcon from "../assets/instagram.png";


const Contact = () => {
  const [status, setStatus] = useState({ type: '', message: '' });

  const handleSubmit = async (e) => {
    e.preventDefault();
    setStatus({ type: '', message: '' });

    const API_URL = '/api/contact';
    const formData = new FormData(e.target);

    try {
      const res = await fetch(`${API_URL}`, {
        method: 'POST',
        body: formData,
      });
      const data = await res.json();

      if (res.ok) {
        setStatus({
          type: 'success',
          message: data.message ?? 'Message sent successfully!',
        });
        e.target.reset();
        setTimeout(() => setStatus({ type: '', message: '' }), 3000);
      } else {
        setStatus({
          type: 'error',
          message: data.errors ? data.errors.join(', ') : 'Failed to send message.',
        });
        setTimeout(() => setStatus({ type: '', message: '' }), 3000);
      }
    } catch (err) {
      setStatus({ type: 'error', message: 'An error occurred. Try again.' });
      setTimeout(() => setStatus({ type: '', message: '' }), 3000);
    }
  };

  return (
    <section id="contact">
      <h2 className="contact-title">Contact Me</h2>

      {status.message && (
        <div className={`status-message ${status.type}`}>
          {status.message}
        </div>
      )}

      <div className="contact-grid">
        {/* Form */}
        <form className="contact-form" onSubmit={handleSubmit}>
          <input type="text" name="name" placeholder="Your Name" required />
          <input type="email" name="email" placeholder="Your Email" required />
          <textarea name="message" placeholder="Your Message" rows="6" required></textarea>
          <button type="submit" className="btn-submit">Send Message</button>
        </form>

        {/* Contact Info */}
        <div className="contact-info">
          <h3>Get in Touch</h3>
          <ul className="info-list">
            <li><strong>Email:</strong> <a href="mailto:devjangig@gmail.com">devjangig@gmail.com</a></li>
            <li><strong>Phone:</strong> <a href="tel:+91 1234567890">+91 1234567890</a></li>
            <li><strong>GitHub:</strong> <a href="https://github.com/dev9913" target="_blank" rel="noreferrer">github.com/dev9913</a></li>
            <li><strong>LinkedIn:</strong> <a href="https://www.linkedin.com/in/dev-jangir-a7a8692b9" target="_blank" rel="noreferrer">linkedin.com/in/dev-jangir</a></li>
          </ul>

          <div className="social-icons">
            <a href="https://github.com/dev9913" target="_blank" rel="noreferrer"><img src={githubIcon} alt="GitHub" /></a>
            <a href="https://www.linkedin.com/in/dev-jangir-a7a8692b9" target="_blank" rel="noreferrer"><img src={linkedinIcon} alt="LinkedIn" /></a>
            <a href="https://twitter.com/" target="_blank" rel="noreferrer"><img src={twitterIcon} alt="Twitter" /></a>
            <a href="https://instagram.com/" target="_blank" rel="noreferrer"><img src={instagramIcon} alt="Instagram" /></a>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Contact;

