# **🚀 End-to-End CI/CD Pipeline for Hello World Node.js App Deployment on EKS using GitHub Actions**  

---

![CI/CD Pipeline](doc/images/Ctznv2m%20-%20Imgur.jpg)

## **📌 Table of Contents**  

- [**🚀 End-to-End CI/CD Pipeline for Node.js App Deployment on EKS using GitHub Actions**](#-end-to-end-cicd-pipeline-for-nodejs-app-deployment-on-eks-using-github-actions)
  - [**📌 Table of Contents**](#-table-of-contents)
  - [**📂 Overview**](#-overview)
  - [**📂 Repository Structure**](#-repository-structure)
  - [**Design Choices**](#-design-choices)
  - [**🔧 Prerequisites**](#-prerequisites)
  - [**⚙️ CI/CD Workflow**](#️-cicd-workflow)
  - [**🔨 CI Job – Build, Test & Scan**](#-ci-job-build-test-scan)
  - [**🚀 CD Job – Deploy to Kubernetes**](#-cd-job-deploy-to-kubernetes)
  - [**💻 How to Run the IaC and CI/CD Pipeline**](#-how-to-run-the-iac-and-ci/cd-pipeline)
  - [**🔄 GitOps Principles**](#-gitops-principles)
  - [**🔒 Security Best Practices**](#-security-best-practices)
  - [**📢 Notifications \& Alerts**](#-notifications--alerts)
  - [**📊 Monitoring \& Logging**](#-monitoring--logging)

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
├── doc/images                 # images
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

## **🔧 Prerequisites**  

Before you proceed, ensure you have the following installed:  

- 🛠 **Node.js (>=18.x)**  
- 🐳 **Docker**  
- 🏗️ **Terraform (>=1.0)**  
- ☸ **kubectl (latest version)**  
- 🎭 **Kustomize**  
- ☁ **AWS CLI**  
- ⚙️ **GitHub Actions configured**  
- 🔑 **AWS IAM permissions to manage EKS**  

---

---

## **⚙️ CI/CD Workflow**

The **CI/CD pipeline** automates the build, test, security scan, Docker image push, deployment to EKS, and observability stack setup using **GitHub Actions**.

---

## **⚙️ Workflow Overview**

The pipeline has **three main jobs**:

1️⃣ **Continuous Integration (CI)** – Build, test, and push Docker image.  
2️⃣ **Continuous Deployment (CD)** – Deploy application to Kubernetes (EKS).  
3️⃣ **Observability Stack** – Deploy monitoring and logging using a separate workflow.  

---

## **🔨 CI Job – Build, Test & Scan**

1️⃣ **Checkout Code**  

- Uses `actions/checkout@v4` to clone the repo.  

2️⃣ **Setup Node.js**  

- Installs **Node.js 18** using `actions/setup-node@v3`.  
- Installs app dependencies using `npm install`.  
- Runs linting with `npm run lint`.  

3️⃣ **Run Tests**  

- Executes unit tests with `npm test`.  
- Generates test reports for visibility.  

4️⃣ **Version Management**  

- Reads version from `VERSION` file.  
- Sets semantic versioning tag (`vX.Y.Z`) for Docker image.  

5️⃣ **Build & Push Docker Image**  

- Builds Docker image for the application.  
- Tags image with version and `latest`.  
- Scans image with **Trivy** for vulnerabilities.  
- Logs in to **DockerHub** and pushes image.  

---

## **🚀 CD Job – Deploy to Kubernetes**

1️⃣ **Checkout Code**  

- Needed for Kubernetes manifests.  

2️⃣ **Install Tools**  

- Installs `kubectl` and ensures AWS CLI is available.  

3️⃣ **Update kubeconfig**  

- Configures `kubectl` for the target EKS cluster.  

4️⃣ **Deploy Application**  

- Sets image tag from CI output.  
- Applies manifests using **Kustomize**.  
- Verifies deployment with `kubectl rollout status`.  

5️⃣ **Smoke Tests**  

- Fetches ELB hostname from ingress.  
- Performs simple HTTP request to confirm service is accessible.  

6️⃣ **Slack Notifications**  

- Sends deployment success/failure notifications using `action-slack@v3`.  

---

## **📊 Observability Job**

- Deploys monitoring and logging stack using a separate workflow (`observability.yaml`).  
- Ensures AWS credentials and EKS cluster details are passed as secrets.  

---

### **💡 Notes**

- Secrets like `DOCKER_USERNAME`, `AWS_ACCESS_KEY_ID`, and `SLACK_WEBHOOK` must be stored in GitHub Actions secrets.  
- The pipeline is triggered automatically on **push to `main` branch**.  
- Image paths and workflow references assume relative paths in the repository.  

 

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

## **💻 How to Run the IaC and CI/CD Pipeline**  

```bash
# configure aws
aws configure

# install terraform (if not installed)

# Clone the repository
git clone https://github.com/NaveenKumar-0/Devops-HRGF-task.git
cd Devops-HRGF-task/terraform-aws-eks-clusterr

# Initialize Terraform
terraform init 

# Review the execution plan:
terraform plan

# Apply the Terraform configuration:
terraform apply --auto-approve
```
This will create AWS resources like VPC, EKS cluster, IAM roles, and worker nodes.

After completion, note the EKS cluster name and region for CI/CD.

---

**Trigger the CI/CD Pipeline**

The pipeline is automatically triggered on push to main branch.

Ensure the following GitHub Secrets are set:

```bash
DOCKER_USERNAME / DOCKER_PASSWORD
AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY
AWS_REGION / EKS_CLUSTER_NAME
SLACK_WEBHOOK
```

## **🔄 GitOps Principles**  

✔ **Git as the Source of Truth**  
✔ **Declarative Infrastructure** (Terraform & Kubernetes)  
✔ **Automated Deployments via GitHub Actions**  

Every infrastructure change must be made via a **Git commit**.  

---

## **🔒 Security Best Practices**  

🔐 **Secrets Management**  

- Uses GitHub Actions **encrypted secrets**.  

🛡 **Container Security**  

- Uses **Trivy** for vulnerability scanning.  

🚧 **IAM & Least Privilege**  

- Uses **AWS IAM roles** with restricted access.  

---

## **📢 Notifications & Alerts**  

🔔 **Slack & Email Notifications**  

- **CI/CD Job Updates** – Pipeline status alerts.  

📡 **Monitoring & Logging**  

- **Prometheus & Grafana** for observability.  

---

## **📊 Monitoring & Logging**  

✅ **Metrics Monitoring** – Tracked using **Prometheus & Grafana**. 
