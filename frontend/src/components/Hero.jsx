import React from 'react';
import devImage from '../devimg.jpeg'; 
import devresume from '../Dev_Resume.pdf'; 

const Hero = () => (
  <section id="home">
    <div className="hero-content">
      <h1>Dev Jangir</h1>
      <h2>DevOps Engineer | Cloud | Automation | CI/CD</h2>
      <p className="tagline">“I build automated, scalable, and secure systems.”</p>
      <div className="hero-buttons">
        <a href={devresume} className="btn neon">Download Resume</a>
        <a href="#contact" className="btn outline">Contact Me</a>
      </div>
    </div>
    <div className="hero-image">
      <img src= {devImage} alt="DevOps Illustration" />
    </div>
    
  </section>
);

export default Hero;
