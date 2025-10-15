# **🚀 End-to-End CI/CD Pipeline for Node.js App Deployment on EKS using GitHub Actions**  

---

![CI/CD Pipeline](https://drive.google.com/file/d/18nvSt6brl7BnWmsl_e2h7Vq0KnBH4YHB/view?usp=sharing)  

## **📌 Table of Contents**  

- [**🚀 End-to-End CI/CD Pipeline for Node.js App Deployment on EKS using GitHub Actions**](#-end-to-end-cicd-pipeline-for-nodejs-app-deployment-on-eks-using-github-actions)
  - [**📌 Table of Contents**](#-table-of-contents)
  - [**📂 Overview**](#-overview)
  - [**📂 Repository Structure**](#-repository-structure)
  - [**🔧 Design Choices**](#-design-choices)
  - [**🔧 Prerequisites**](#-prerequisites)
  - [**⚙️ CI/CD Workflow**](#️-cicd-workflow)
    - [**🔨 Build Job**](#-build-job)
    - [**🚀 Deployment Job**](#-deployment-job)
  - [**🏗️ Infrastructure Details**](#️-infrastructure-details)
  - [**📦 Application Deployment Strategy**](#-application-deployment-strategy)
  - [**🔄 GitOps Principles**](#-gitops-principles)
  - [**🔒 Security Best Practices**](#-security-best-practices)
  - [**📢 Notifications \& Alerts**](#-notifications--alerts)
  - [**📊 Monitoring \& Logging**](#-monitoring--logging)
  - [**📜 Contributing**](#-contributing)
  - [**⭐ Support \& Author**](#-support--author)
  - [**⭐ Hit the Star!**](#-hit-the-star)
  - [🛠️ **Author \& Community**](#️-author--community)
  - [📧 **Let's Connect!**](#-lets-connect)
  - [📢 **Stay Updated!**](#-stay-updated)

---

## **📂 Overview**

This project demonstrates a fully automated deployment pipeline for a simple Node.js "Hello World" web application using modern DevOps practices.

Key highlights:

Infrastructure as Code (Terraform) provisions a managed Kubernetes cluster on AWS.

Containerization (Docker) packages the Node.js app into a lightweight, scalable container.

Deployment using Kubernetes manifests managed via Helm or Kustomize.

CI/CD pipeline (GitHub Actions) automates building, testing, pushing, and deploying updates whenever code is pushed to the main branch.

Public accessibility through a LoadBalancer or Ingress configured in the cluster.

Security is enhanced by integrating code quality checks with Lint and Trivy container image vulnerability scanning in the CI/CD pipeline. This ensures all images are automatically scanned for vulnerabilities before deployment.

This approach ensures reproducible, scalable, and efficient application deployment, showcasing core DevOps principles: automation, container orchestration, infrastructure as code, and security integration.

## **📂 Repository Structure**  

The repository is structured for **modularity and maintainability**:

```tree
📂 root  
├── 📂 .github/workflows/      # GitHub Actions CI/CD workflows
│   ├── ci-cd.yaml             # Continuous Integration pipeline
│   └── observability.yaml     # trigger this pipeline after Continuous Deployment for setting Prometheus & Grafana
│
├── 📂 app                     # Application source code  
│   ├── app.py                 # hello world ( node.js )  
│   ├── Dockerfile             # Optimized Dockerfile for Node.js app   
│   └── package.json           # Project dependencies and scripts    
│  
├── 📂 kustomize               # Kubernetes manifests managed with Kustomize  
│   ├── 📂 base                # Base configurations common for all environments  
│   │   ├── deployment.yaml    # Enhanced deployment with health checks & security  
│   │   ├── ingress.yaml       # Ingress configuration for routing traffic  
│   │   ├── kustomization.yaml # Kustomize configuration file  
│   │   └── service.yaml           # Kubernetes Service definition  
│   │  
│   ├── 📂 overlays            # Environment-specific configurations  
│   │   ├── 📂 dev             # Dev environment-specific Kustomize configs  
│   │   │   ├── deploy-dev.yaml        # Dev-specific deployment file  
│   │   │   ├── ingress-dev.yaml       # Dev-specific ingress settings  
│   │   │   ├── kustomization.yaml     # Kustomize configuration for Dev  
│   │   │   └── svc-dev.yaml           # Dev-specific service settings  
│   │   │  
│   │   ├── 📂 prod            # Production environment-specific Kustomize configs  
│   │   │   ├── deploy-prod.yaml       # Production-specific deployment file  
│   │   │   ├── ingress-prod.yaml      # Production-specific ingress settings  
│   │   │   ├── kustomization.yaml     # Kustomize configuration for Prod  
│   │   │   └── svc-prod.yaml          # Production-specific service settings  
│   │   │  
│   │   └── 📂 staging         # Staging environment-specific Kustomize configs  
│   │       ├── deploy-staging.yaml    # Staging-specific deployment file  
│   │       ├── ingress-staging.yaml   # Staging-specific ingress settings  
│   │       ├── kustomization.yaml     # Kustomize configuration for Staging  
│   │       └── svc-staging.yaml       # Staging-specific service settings
|   |
|   |  
│   📂 terraform-aws-eks-clusterr        # Root Terraform project
│   |
|   ├── 📂modules/                         # Reusable Terraform modules
|   │   ├── 📂eks/                         # EKS cluster module
|   │   │   ├── main.tf                  # EKS cluster resource
|   │   │   ├── variables.tf             # Module input variables
|   │   │   ├── outputs.tf               # Module outputs
|   │   │   └── README.md                # Module-specific documentation (optional)
|   │   │
|   │   ├── 📂iam-eks/                     # IAM roles & policies for EKS
|   │   │   ├── main.tf
|   │   │   ├── variables.tf
|   │   │   └── outputs.tf
|   │   │
|   │   ├── 📂ingress-controller/          # NGINX Ingress controller module
|   │   │   ├── main.tf
|   │   │   ├── variables.tf
|   │   │   └── outputs.tf
|   │   │
|   │   └── 📂vpc/                         # VPC, subnets, and networking module
|   │       ├── main.tf
|   │       ├── variables.tf
|   │       └── outputs.tf
|   │
|   ├── main.tf                           # Root-level Terraform file calling modules
|   ├── outputs.tf                        # Root-level outputs (e.g., cluster endpoint)
|   ├── provider.tf                        # AWS provider configuration
|   ├── terraform.tf                       # Backend configuration for state
|   └── variables.tf                       # Root-level input variables
| 
│  
├── .gitignore                 # Comprehensive gitignore file  
├── README.md                  # Project documentation and setup guide  
└── VERSION                    # Tracks application versioning (Semantic Versioning)  
```
'''
## **Design Choices**

Infrastructure as Code (IaC)
Terraform provisions the Kubernetes cluster and related cloud infrastructure, ensuring consistent, version-controlled environment setup.

Containerization (Docker & DockerHUB)
Docker packages the Node.js application into a lightweight, efficient container image optimized for deployment and scalability.

Deployment Management
Kustomize templates Kubernetes manifests, providing flexible configuration management and simplifying multi-environment deployments.

CI/CD Pipeline
GitHub Actions orchestrates the full build-test-deploy workflow, triggered on every push to the main branch. GitHub secrets are used for secure credentials management.

Security Integration
Lint performs automated code quality and basic security analysis.
Trivy scans container images for vulnerabilities, enforcing container security before deployment.

---


---

## **🚀 Recent Improvements**  

This project has been enhanced with the following improvements:

### **🔧 Application Enhancements**
- ✅ **Enhanced Error Handling** - Better error responses and graceful shutdown
- ✅ **Health Check Endpoints** - `/health` endpoint for monitoring
- ✅ **API Endpoints** - RESTful API at `/api/calculate` for programmatic access
- ✅ **CORS Support** - Cross-origin resource sharing enabled
- ✅ **Improved UI** - Better styling and user experience
- ✅ **Graceful Shutdown** - Proper signal handling for container orchestration

### **🐳 Docker & Security Improvements**
- ✅ **Multi-stage Docker Build** - Optimized image size and security
- ✅ **Non-root User** - Enhanced security with proper user permissions
- ✅ **Health Checks** - Built-in container health monitoring
- ✅ **Signal Handling** - Proper process management with dumb-init

### **☸️ Kubernetes Enhancements**
- ✅ **Liveness & Readiness Probes** - Better container health monitoring
- ✅ **Security Context** - Enhanced security with non-root execution
- ✅ **Resource Management** - Proper CPU and memory limits
- ✅ **Rolling Updates** - Zero-downtime deployments

### **🔄 CI/CD Pipeline**
- ✅ **GitHub Actions Workflows** - Automated CI/CD with security scanning
- ✅ **Multi-Node Testing** - Testing across Node.js 18.x and 20.x
- ✅ **Security Scanning** - Trivy vulnerability scanning
- ✅ **Code Quality** - ESLint integration and coverage reporting

### **🛠️ Development Tools**
- ✅ **Docker Compose** - Local development environment
- ✅ **ESLint Configuration** - Code quality and consistency
- ✅ **Comprehensive .gitignore** - Proper version control
- ✅ **Nginx Configuration** - Local reverse proxy setup

---

## **🔧 Prerequisites**  

Before you proceed, ensure you have the following installed:  

- 🛠 **Node.js (>=18.x)**  
- 🐳 **Docker & Docker Compose**  
- 🏗️ **Terraform (>=1.0)**  
- ☸ **kubectl (latest version)**  
- 🎭 **Kustomize**  
- ☁ **AWS CLI & eksctl**  
- ⚙️ **GitHub Actions configured**  
- 🔑 **AWS IAM permissions to manage EKS**  

---

## **🏃‍♂️ Quick Start (Local Development)**  

### **Option 1: Docker Compose (Recommended)**
```bash
# Clone the repository
git clone https://github.com/NotHarshhaa/CI-CD_EKS-GitHub_Actions.git
cd CI-CD_EKS-GitHub_Actions

# Start the application with Docker Compose
docker-compose up --build

# Access the application
# Web UI: http://localhost:80
# Health Check: http://localhost:80/health
# API: POST http://localhost:80/api/calculate
```

### **Option 2: Local Node.js Development**
```bash
# Navigate to app directory
cd app

# Install dependencies
npm install

# Run in development mode
npm run dev

# Run tests
npm test

# Run linting
npm run lint
```

---

## **⚙️ CI/CD Workflow**  

The **CI/CD pipeline** automates the entire deployment process using **GitHub Actions**.  

### **🔨 Build Job**  

1️⃣ **Set Up the Environment**  

- Install **Node.js dependencies** using `npm install`.  
- Lint the code to ensure quality standards.  

2️⃣ **Run Tests**  

- Execute **unit tests** with `npm test`.  
- Generate test reports for visibility.  

3️⃣ **Version Management**  

- Uses **Semantic Versioning** (`major.minor.patch`).  
- Auto-increments the version based on commit messages.  

4️⃣ **Build & Push Docker Image**  

- **Builds a Docker image** of the application.  
- Pushes it to **Amazon Elastic Container Registry (ECR)**.  

---

### **🚀 Deployment Job**  

1️⃣ **Terraform Setup**  

- Initializes Terraform with `terraform init`.  
- Ensures correct **state management**.  

2️⃣ **Infrastructure Provisioning**  

- Executes `terraform plan` and `terraform apply`.  
- Deploys EKS clusters, networking, and storage.  

3️⃣ **Kubernetes Configuration**  

- Configures `kubectl` to interact with the cluster.  
- Applies `Kustomize` overlays for environment-specific settings.  

4️⃣ **Ingress Controller Setup**  

- Uses **Helm** to install **NGINX Ingress**.  

5️⃣ **Application Deployment**  

- Deploys the latest **Docker image** to Kubernetes.  
- Exposes the service via **Ingress and Load Balancer**.  

---

## **🏗️ Infrastructure Details**  

| Environment | Instance Type | Replica Count |
|-------------|--------------|---------------|
| **Dev**     | `t3.small`    | 1             |
| **Staging** | `t3.medium`   | 3             |
| **Prod**    | `t3.large`    | 3             |

✅ **DNS Automation via Cloudflare**  

- Environment-specific subdomains:  
  - `dev.example.com`  
  - `staging.example.com`  
  - `prod.example.com`  

---

## **📦 Application Deployment Strategy**  

This project supports **multiple deployment strategies**:  

✅ **Rolling Updates** – Default strategy, ensuring zero downtime.  
✅ **Blue-Green Deployment** – Used in production environments.  
✅ **Canary Deployments** – Gradual rollout for safe updates.  

---

## **🔄 GitOps Principles**  

✔ **Git as the Source of Truth**  
✔ **Declarative Infrastructure** (Terraform & Kubernetes)  
✔ **Automated Deployments via GitHub Actions**  

Every infrastructure change must be made via a **Git commit**.  

---

## **🔒 Security Best Practices**  

🔐 **Secrets Management**  

- Uses **AWS Secrets Manager** & GitHub Actions **encrypted secrets**.  

🛡 **Container Security**  

- Uses **Trivy** and **Docker Bench Security** for vulnerability scanning.  

🚧 **IAM & Least Privilege**  

- Uses **AWS IAM roles** with restricted access.  

---

## **📢 Notifications & Alerts**  

🔔 **Slack & Email Notifications**  

- **CI/CD Job Updates** – Pipeline status alerts.  
- **DNS Updates** – Cloudflare integration for alerts.  

📡 **Monitoring & Logging**  

- **AWS CloudWatch** for logs & metrics.  
- **Prometheus & Grafana** for observability.  

---

## **📊 Monitoring & Logging**  

✅ **Application Logs** – Aggregated using **Fluent Bit**.  
✅ **Infrastructure Logs** – Stored in **AWS CloudWatch Logs**.  
✅ **Metrics Monitoring** – Tracked using **Prometheus & Grafana**.  

---

## **📜 Contributing**  

Want to contribute? Here’s how:  

1. **Fork the repository** & create a new branch.  
2. Make your changes and **commit with a descriptive message**.  
3. Open a **Pull Request (PR)** for review.  

---

## **⭐ Support & Author**  

## **⭐ Hit the Star!**  

If you find this repository helpful and plan to use it for learning, please consider giving it a star ⭐. Your support motivates me to keep improving and adding more valuable content! 🚀  

---

## 🛠️ **Author & Community**  

This project is crafted with passion by **[Harshhaa](https://github.com/NotHarshhaa)** 💡.  

I’d love to hear your feedback! Feel free to open an issue, suggest improvements, or just drop by for a discussion. Let’s build a strong DevOps community together!  

---

## 📧 **Let's Connect!**  

Stay connected and explore more DevOps content with me:  

[![LinkedIn](https://img.shields.io/badge/LinkedIn-%230077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/harshhaa-vardhan-reddy)  [![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/NotHarshhaa)  [![Telegram](https://img.shields.io/badge/Telegram-26A5E4?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/prodevopsguy)  [![Dev.to](https://img.shields.io/badge/Dev.to-0A0A0A?style=for-the-badge&logo=dev.to&logoColor=white)](https://dev.to/notharshhaa)  [![Hashnode](https://img.shields.io/badge/Hashnode-2962FF?style=for-the-badge&logo=hashnode&logoColor=white)](https://hashnode.com/@prodevopsguy)  

---

## 📢 **Stay Updated!**  

Want to stay up to date with the latest DevOps trends, best practices, and project updates? Follow me on my blogs and social channels!  

![Follow Me](https://imgur.com/2j7GSPs.png)
