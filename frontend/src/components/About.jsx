import React from 'react';
import  devresume from "../assets/Dev_Resume.pdf";
import  devImage from "../assets/devops.avif";
const About = () => (
  <section id="about">
    <h2 className="section-title">About Me</h2>
    <div className="about-wrapper">
      <div className="about-image">  
        <img src={devImage} alt="Dev Jangir" />
      </div>
      <div className="about-text">
        <p>Hello! I’m <strong>Dev Jangir</strong>, a DevOps Engineer passionate about building automated, scalable, and secure systems.</p>
        <div className="about-skills">
          <h4>Key Skills:</h4>
          <ul>
            <li>DevOps & Automation</li>
            <li>AWS / Azure Cloud</li>
            <li>Docker & Kubernetes</li>
            <li>Terraform & Ansible</li>
            <li>CI/CD Pipelines</li>
            <li>Monitoring (Prometheus / Grafana)</li>
            <li>Bash & Python Scripting</li>
          </ul>
        </div>
        <a href={devresume} className="btn-download" rel="noreferrer" target="_blank">Download Resume</a>
      </div>
    </div>
  </section>
);

export default About;
