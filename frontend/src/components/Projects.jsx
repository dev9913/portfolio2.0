import React from 'react';

const Projects = () => (
  <section id="projects">
    <h2 className="section-title">Projects</h2>
    <div className="project-grid">
      <div className="project-card">
        <h3>CI/CD Pipeline using GitHub Actions</h3>
        <p>Automated deployment pipeline with build, test, security checks, and rollout steps.</p>
        <span className="tools">GitHub Actions • Docker • Linux  </span>
        <a href="https://github.com/dev9913/GithubAction-project" className="project-btn" target="_blank" rel="noopener noreferrer">  GitHub</a>
      </div>
      <div className="project-card">
        <h3>Kubernetes Deployment for Microservices</h3>
        <p>Deployed containerized services with autoscaling, monitoring, and service mesh.</p>
        <span className="tools">K8s • Helm • Prometheus  </span>
        <a href="https://github.com/dev9913/Proshop" className="project-btn" target="_blank" rel="noopener noreferrer">  GitHub</a>
      </div>
      <div className="project-card">
        <h3>Infrastructure-as-Code with Terraform</h3>
        <p>Provisioned cloud infrastructure with reusable modules & automated pipelines.</p>
        <span className="tools">Terraform • AWS • Git  </span>
        <a href="https://github.com/dev9913/Terraform-aws" className="project-btn" target="_blank" rel="noopener noreferrer">  GitHub</a>
      </div>
      <div className="project-card">
        <h3>Dockerized Web App</h3>
        <p>Containerized and optimized application for smooth deployment across environments.</p>
        <span className="tools">Docker • Nginx • GitHub Actions  </span>
        <a href="https://github.com/dev9913/Mood-App-React" className="project-btn" target="_blank" rel="noopener noreferrer">  GitHub</a>
      </div>
      <div className="project-card">
        <h3>Monitoring Stack with Prometheus + Grafana  </h3>
        <p>End-to-end monitoring platform with custom dashboards and alerting.</p>
        <span className="tools">Prometheus • Grafana • Alertmanager  </span>
        <a href="https://github.com/dev9913/Proshop" className="project-btn" target="_blank" rel="noopener noreferrer">  GitHub</a>
      </div>
    </div>
  </section>
);

export default Projects;
