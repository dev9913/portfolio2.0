import React, { useState } from 'react';
import githubIcon from "../assets/github.png";
import linkedinIcon from "../assets/linkedin.png";
import twitterIcon from "../assets/twitter.png";
import  instagramIcon from "../assets/instagram.png";


const Contact = () => {

  const [status, setStatus] = useState({ type: '', message: '' });

  const handleSubmit = async (e) => {
    e.preventDefault();
    setStatus({ type: '', message: '' });

    const API_URL = 'http://portfolio.local'; // Your backend URL
    const formData = new FormData(e.target);

    try {
       const res = await fetch(`${API_URL}/api/contact`, {
         method: 'POST',
          body: formData,
       });
      const data = await res.json();  // Get the JSON response from the server

      // Check if the response was successful
      if (res.ok) {
        setStatus({
          type: 'success',
          message: data.message ?? 'Thank you for your message. We will get back to you shortly!',  // Use backend message
        });
        e.target.reset();  // Reset form fields after submission

        // Reset the message after 2 seconds
        setTimeout(() => {
          setStatus({ type: '', message: '' });
        }, 2000);  // 2 seconds delay
      } else {
        setStatus({
          type: 'error',
          message: data.errors ? data.errors.join(', ') : 'Failed to send message.',
        });
        
        // Reset the error message after 2 seconds
        setTimeout(() => {
          setStatus({ type: '', message: '' });
        }, 2000);  // 2 seconds delay
      }
    } catch (err) {
      console.error('Submission Error:', err);
      setStatus({ type: 'error', message: 'An error occurred. Please try again.' });

      // Reset the error message after 2 seconds
      setTimeout(() => {
        setStatus({ type: '', message: '' });
      }, 2000);  // 2 seconds delay
    }
  };

  return (
    <section id="contact">
      <h2 className="section-title">Contact Me</h2>

      {/* Display success or error messages */}
      {status.message && (
        <div
          style={{
             backgroundColor: status.type === 'success' ? '#4CAF50' : '#F44336',
             color: 'white',
             padding: '15px',
             borderRadius: '8px',
             marginBottom: '20px',
             fontWeight: 'bold',
             textAlign: 'center',
             maxWidth: '500px',
             margin: '20px auto',
             transition: 'all 0.3s ease',
           }}
        >
          {status.message}
        </div>
      )}

      <div className="contact-wrapper">
        <div className="contact-form">
          <form id="contact-form" onSubmit={handleSubmit}>
            <input type="text" name="name" placeholder="Your Name" required />
            <input type="email" name="email" placeholder="Your Email" required />
            <textarea name="message" placeholder="Your Message" rows="6" required></textarea>
            <button type="submit" className="btn-submit">Send Message</button>
          </form>
        </div>
        <div className="contact-info">
          <h3>Get in Touch</h3>
          <ul>
            <li><strong>Email:</strong> <a href="mailto:devjangig@gmail.com">devjangig@gmail.com</a></li>
            <li><strong>Phone:</strong> <a href="tel:+911234567890">+91 1234567890</a></li>
            <li><strong>GitHub:</strong> <a href="https://github.com/dev9913" target="_blank" rel="noopener noreferrer">github.com/dev9913</a></li>
            <li><strong>LinkedIn:</strong> <a href="https://www.linkedin.com/in/dev-jangir-a7a8692b9" target="_blank" rel="noopener noreferrer">linkedin.com/in/dev-jangir</a></li>
          </ul>
           <div className="social-links">
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
