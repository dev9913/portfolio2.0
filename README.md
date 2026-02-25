# 📂 Portfolio2.0

**Portfolio & DevOps Automation**  
A full DevOps and GitOps pipeline demonstrating modern automation practices for a portfolio application.

[GitHub Repository](https://github.com/dev9913/portfolio2.0.git)

---

## 🧠 Project Overview

This project is a **full-stack portfolio application** integrated with DevOps best practices. It demonstrates:

- Containerization with **Docker**
- Continuous Integration / Continuous Deployment using **Jenkins**
- Security scanning using **Trivy**
- Infrastructure provisioning via **Terraform**
- Configuration management using **Ansible**
- GitOps-style deployments via **Argo CD**
- Monitoring and observability with **Prometheus** & **Grafana**
- YAML automation using **yq**

This repository showcases **end-to-end deployment automation, security, and observability** for production-ready applications.

---

## 🛠 Technology Stack

| Category | Tools |
|----------|-------|
| CI/CD | Jenkins, Argo CD |
| Containers | Docker |
| Security | Trivy |
| Infrastructure as Code | Terraform, Ansible |
| YAML Automation | yq |
| Monitoring | Prometheus, Grafana |
| Orchestration | Kubernetes |
| Languages | JavaScript, HTML, CSS, Groovy, HCL |

---


## 📐 Architecture

This project uses a **DevOps & GitOps workflow**:

**GitHub → Jenkins CI/CD → Docker Registry → Kubernetes (Argo CD) → Monitoring (Prometheus & Grafana)**

### Flow:

1. **GitHub Repo** – stores application code and infrastructure manifests.  
2. **Jenkins Pipeline** – automates build, Trivy scan, and Docker image push.  
3. **Docker Registry** – stores container images for deployment.  
4. **Kubernetes Cluster** – applications deployed using **Argo CD** (GitOps).  
5. **Monitoring** – **Prometheus** collects metrics and **Grafana** visualizes dashboards.  

---

## ✨ Key Features

- Full CI/CD pipeline using Jenkins  
- Multi-stage build: checkout → build →  scan → push → deploy  
- Container image vulnerability scanning with Trivy  
- Infrastructure provisioning with Terraform  
- Configuration automation via Ansible  
- GitOps deployments using Argo CD  
- Observability dashboards via Prometheus and Grafana  
- YAML manipulation and automation with yq  

---

## 🧩 Prerequisites

- Docker & Docker Compose  
- Jenkins with required plugins  
- Terraform  
- Ansible  
- Kubernetes cluster (K3s, EKS, AKS, or similar)  
- Argo CD  
- Prometheus & Grafana  
- GitHub repository access  

---
🔌 Ports Used 
---

| Service         | Port             |
| --------------- | ---------------- |
| SSH             | 22               |
| Frontend App    | 80               |
| HTTPS           | 443              |
| Backend App     | 5000             |
| Admin App       | 5001             |
| Grafana         | 3000             |
| Prometheus      | 9090             |
| Argo CD UI      | 8080             |
| Argo CD Metrics | 8082, 8083, 8084 |

---
## ⚙ Jenkins Pipeline

The `Jenkinsfile` orchestrates the CI/CD process:

1. **Checkout**: Pull code from GitHub  
2. **Docker Build & Scan**: Build Docker images and run Trivy scans  
3. **Docker Push**: Push images to container registry  
4. **Infrastructure Setup**: Apply Terraform and Ansible for cluster provisioning  
5. **GitOps Deployment**: Apply Kubernetes manifests via Argo CD  
6. **Notifications**: Pipeline status via email .



## This project demonstrates end-to-end DevOps automation and is an excellent portfolio showcase .

 
