# **🚀 End-to-End CI/CD Pipeline for Hello World Node.js App Deployment on EKS using GitHub Actions**  

---

![GitHub Actions](https://img.shields.io/github/actions/workflow/status/NaveenKumar-0/Devops-HRGF-task/ci-cd.yaml?branch=main)
![License](https://img.shields.io/badge/license-MIT-green)
![Terraform](https://img.shields.io/badge/IaC-Terraform-blue)
![Kubernetes](https://img.shields.io/badge/Deployed_on-EKS-orange)


![CI/CD Pipeline](doc/images/Ctznv2m%20-%20Imgur.jpg)

## **📌 Table of Contents**  

- [**🚀 End-to-End CI/CD Pipeline for Node.js App Deployment on EKS using GitHub Actions**](#-end-to-end-cicd-pipeline-for-nodejs-app-deployment-on-eks-using-github-actions)
  - [**📌 Table of Contents**](#-table-of-contents)
  - [**📂 Overview**](#-overview)
  - [**📂 Repository Structure**](#-repository-structure)
  - [**Design Choices**](#-design-choices)
  - [**🔧 Prerequisites**](#-prerequisites)
  - [**⚙️ CI/CD Workflow**](#️-cicd-workflow)
     - [**🔨 Build Job**](#-build-job)
     - [**🚀 Deployment Job**](#-deployment-job)
  - [**📦 Run Iac code \& cicd pipeline**](#-run-iac-code--cicd-pipeline)
  - [**🔄 GitOps Principles**](#-gitops-principles)
  - [**🔒 Security Best Practices**](#-security-best-practices)
  - [**📢 Notifications \& Alerts**](#-notifications--alerts)
  - [**📊 Monitoring \& Logging**](#-monitoring--logging)
  - [📢 **APPLICATION URL**](#-application-url)


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
---
## **Design Choices**

```tree
Cloud Provider (AWS)
--> AWS is the chosen cloud platform due to its robust managed services and scalability.
--> Components such as EKS (Elastic Kubernetes Service), IAM, VPC, and Load Balancers provide a reliable and production-ready infrastructure foundation.

Infrastructure as Code (IaC)
--> Terraform is used to provision and manage AWS infrastructure resources such as VPC, EKS cluster, and node groups using a modular structure.
--> This ensures reusability, version control, and environment consistency across development, staging, and production.

Containerization (Docker & Docker Hub)
--> The Node.js application is containerized using Docker, enabling isolated, reproducible builds.
--> Built images are pushed to Docker Hub for centralized image management and faster deployments.

Deployment Management (Kustomize + Kubernetes)
--> Kustomize manages Kubernetes manifests to simplify configuration across multiple environments (dev, staging, prod).
--> It enables dynamic customization like changing namespaces, image tags, or environment variables without duplicating YAML files.

Ingress Controller (NGINX)
--> The NGINX Ingress Controller manages external access to services within the Kubernetes cluster.

Ingress provides:
- Host-based and path-based routing
- SSL/TLS termination
- Centralized traffic management
- Unlike a standard Load Balancer, which only routes traffic based on IP/port, Ingress allows fine-grained URL routing — e.g.:
- This setup makes it efficient to expose multiple services through a single load balancer endpoint.

CI/CD Pipeline (GitHub Actions)
--> GitHub Actions automates the entire workflow — build, test, security scan, and deployment — triggered on each push to the main branch.
--> GitHub Secrets securely store credentials (AWS keys, Docker tokens, Slack webhook, etc.).

--> Slack Integration is added to send real-time build and deployment notifications.

Security Integration
--> Lint performs automated code quality checks to maintain clean and secure codebases.
--> Trivy scans container images for known vulnerabilities before deployment, enforcing secure delivery practices.

```
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


### **🔨 Build Job**
---

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
---

### **🚀 Deployment Job**
---

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
---

## **📊 Observability Job**
---

- Deploys monitoring and logging stack using a separate workflow (`observability.yaml`).  
- Ensures AWS credentials and EKS cluster details are passed as secrets.  

---
---

### **💡 Notes**
- Secrets like `DOCKER_USERNAME`, `AWS_ACCESS_KEY_ID`, and `SLACK_WEBHOOK` must be stored in GitHub Actions secrets.  
- The pipeline is triggered automatically on **push to `main` branch**.  
- Image paths and workflow references assume relative paths in the repository.  
---  
---

## **📦 Run Iac code & cicd pipeline** 

Folk the repo -> https://github.com/NaveenKumar-0/Devops-HRGF-task <- into github account


```bash
#update distro packages ( apt or yum or dnf)

# configure aws
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws configure

# install terraform (if not installed) ( ref for ubuntu - https://github.com/NaveenKumar-0/installlation-scripts.git -> ubuntu-terraform.sh )

# Clone the repository
git clone https://github.com/{{githubusername}}/Devops-HRGF-task.git
cd Devops-HRGF-task/terraform-aws-eks-clusterr

# Initialize Terraform
terraform init 

# Review the execution plan:
terraform plan

# Apply the Terraform configuration:
terraform apply --auto-approve

cd ~/Devops-HRGF-task/
```
This will create AWS resources like VPC, EKS cluster, IAM roles, and worker nodes.

After completion, note the EKS cluster name and region for CI/CD.

---

**Trigger the CI/CD Pipeline**

```bash

#npm installaion
apt install npm -y

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl

#change the version
sed -i 's/"version": "3.0.0"/"version": "4.0.0"/' app/package.json && sed -i 's/3.0.0/4.0.0/' VERSION

#regenerate with updated version
cd ~/Devops-HRGF-task/app
npm install 

```

and then 
```bash
cd ~/Devops-HRGF-task/

git init
git branch hot-fix
git checkout hot-fix
git add
git commit -m "version 4.0.0 is ready"
git remote add origin https://github.com/{{githubusername}}/Devops-HRGF-task.git
git push origin hot-fix
git tag origin v4.0.0
git push origin hot-fix

```

On GitHub, open a PR from hot-fix → main.

Review the changes, then merge into main.

The pipeline is automatically triggered on push to main branch.

**Ensure the following GitHub Secrets are set:**

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

**SLACK INTEGRATION**

```bash
1️⃣ Create a Slack App & Incoming Webhook

# Go to 👉 https://api.slack.com/apps  --> Click “Create New App” → “From scratch”
#Name your app (e.g., GitHub-CICD-Notifier)
#Choose your workspace
#In the left sidebar, click “Incoming Webhooks”
#Enable “Activate Incoming Webhooks”
#Click “Add New Webhook to Workspace”
#Choose a channel → Click “Allow”
#Copy the generated Webhook URL
```
Go to Settings → Secrets and variables → Actions ->  Click New repository secret -> Name it: SLACK_WEBHOOK_URL -> Paste your Slack webhook URL.
  

📡 **Monitoring & Logging**  

- **Prometheus & Grafana** for observability.  
---

## **📊 Monitoring & Logging**  

✅ **Metrics Monitoring** – Tracked using **Prometheus & Grafana**. 
```bash
#before accessing, go to aws console -> edit the inbound security group of the cluster nodes -> allow 30800 & 30900
#at the end of pipleline completion, will get how to access prometheus and grafana like shown below:
#Worker node public IPs:
43.205.216.31
13.201.99.166
Access Grafana at http://<NODE_IP>:30800
Access Prometheus at http://<NODE_IP>:30900
Replace <NODE_IP> with any of the above public IPs.
```
---
  

## **📢 APPLICATION URL**

o	A link to the live, publicly accessible URL of the deployed application

🌐 **Live URL:** http://a2976e10833364f3188473663ff1287e-1882963728.ap-south-1.elb.amazonaws.com


---

