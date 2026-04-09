# 🚀 DevSecOps CI/CD Pipeline with Jenkins, Docker, Trivy & AWS EKS

## 📌 Project Overview

This project demonstrates a **production-ready DevSecOps pipeline** using Jenkins.
It automates the complete workflow from **code build → security scanning → Docker image creation → deployment to AWS EKS**.

---

## 🧰 Tech Stack

* **CI/CD Tool:** Jenkins
* **Build Tool:** Maven
* **Language:** Java
* **Containerization:** Docker
* **Security Scanning:** Trivy
* **Code Quality:** SonarQube
* **Orchestration:** Kubernetes (AWS EKS)
* **Notifications:** Slack
* **Cloud:** AWS

---

## 🔄 Pipeline Workflow

```
Code → Build → Test → SonarQube → Trivy FS Scan
     → Docker Build → Trivy Image Scan
     → Docker Push → Deploy to AWS EKS → Slack Notification
```

---

## ⚙️ Features

✔ Automated CI/CD pipeline using Jenkins
✔ Code quality analysis with SonarQube
✔ Vulnerability scanning using Trivy (FS + Image)
✔ Docker image build & push to DockerHub
✔ Deployment to AWS EKS (Kubernetes)
✔ Slack notifications for build status
✔ Secure credential management in Jenkins

---

## 📂 Project Structure

```
.
├── src/                         # Application source code
├── Dockerfile                   # Docker build file
├── Jenkinsfile                  # CI/CD pipeline definition
├── pom.xml                      # Maven configuration
├── k8s_deployment_service.yaml # Kubernetes deployment & service
├── kube-scan.yaml               # Kubernetes security scan config
├── README.md                    # Project documentation
```

---

## 🚀 Setup Instructions

### 1️⃣ Prerequisites

* Jenkins installed
* Docker installed
* AWS CLI configured
* kubectl installed
* Trivy installed
* SonarQube server setup

---

### 2️⃣ Jenkins Configuration

* Add tools:

  * JDK 17
  * Maven 3.9
* Configure:

  * SonarQube server (`sonarserver`)
  * Docker credentials (`docker-cred`)
  * AWS credentials (`aws-cred`)
  * Slack integration

---

### 3️⃣ Run Pipeline

* Create a Jenkins pipeline job
* Add your GitHub repository
* Run the pipeline

---

## 🔐 Security (DevSecOps)

* **Trivy FS Scan:** Detects vulnerable dependencies
* **Trivy Image Scan:** Detects OS/package vulnerabilities
* **Quality Gate:** Ensures code quality before deployment

---

## 📦 Deployment

* Uses AWS EKS for Kubernetes deployment
* Dynamically updates Docker image using:

  ```
  kubectl set image deployment/devsecops devsecops=<image:tag>
  ```

---

## 🔔 Notifications

* Slack alerts for:

  * ✅ Success (Green)
  * ❌ Failure (Red)

---

## 🏆 Key Highlights

* End-to-end CI/CD automation
* Integrated DevSecOps practices
* Production-ready pipeline design
* Real-world cloud deployment (AWS EKS)

---

## 📸 Optional Enhancements

* Helm charts for deployment
* ArgoCD (GitOps)
* Multi-environment (Dev / Stage / Prod)
* Blue-Green or Canary deployment

---

## 👤 Author

**Tawfeeq Ahmed**

---

## ⭐ If you like this project

Give it a ⭐ on GitHub and share!

---

