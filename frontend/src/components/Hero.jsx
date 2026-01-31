import  devresume from "../assets/Dev_Resume.pdf";
import  devImage from "../assets/devimg.jpeg";
import React from "react";

const Hero = () => {
  return (
    <section id="hero">
      <div className="hero-content">
        <h1>Dev Jangir</h1>
        <h2>DevOps Engineer | Cloud | Automation | CI/CD</h2>
        <p class="tagline">“I build automated, scalable, and secure systems.”</p>

        <div className="hero-buttons">
          <a href={devresume} class="btn neon">Download Resume</a>  
          <a href="#projects" className="btn neon">View Projects</a>
          <a href="#contact" className="btn outline">Contact Me</a>
        </div>
      </div>

      <div className="hero-image">
        <img src={devImage}  alt="Hero" />
      </div>
    </section>
  );
};

export default Hero;
