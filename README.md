# 🚀 React Application Deployment with CI/CD and Monitoring

## 📎 Submission Details

- **GitHub Repo URL:** [https://github.com/SriSatyaPothala/Final-Project-1](https://github.com/SriSatyaPothala/Final-Project-1)
- **Deployed App URL:** [http://3.109.203.128:80](http://3.109.203.128:80)
- **Docker Image Names:**
  - **Public Repo:** `srisatyap/dev:devbuild-21`
  - **Private Repo:** `srisatyap/prod:prodbuild-22`
- ✅ *All output screenshots are present in the `Output_Screenshots` folder inside the GitHub repository.*

---

## 🌐 Project Overview

This project outlines the architecture, deployment, and monitoring configuration for a React single-page application (SPA) hosted on an AWS EC2 instance. The core goal is to integrate **Docker**, **Jenkins** (CI/CD), **Prometheus**, and **Grafana** for robust application management and observability.

---

## 🛠️ Key Technologies Used

- **React JS**: Front-end framework
- **Docker**: For containerizing the application
- **Jenkins**: CI/CD automation
- **AWS EC2**: Hosting the Jenkins server and the application
- **Prometheus**: Time-series database and alert monitoring
- **Grafana**: Visualization dashboards
- **Blackbox Exporter**: Endpoint probing tool
- **Alertmanager**: Alert routing and notifications

---

## 🎯 Project Goals

- Containerize the application using Docker and Dockerfile
- Push Docker images to:
  - Public Docker Hub Repo: `srisatyap/dev`
  - Private Docker Hub Repo: `srisatyap/prod`
-  Use Jenkins for CI/CD with custom `build.sh` and `deploy.sh` scripts
-  Deploy application on AWS EC2 t2.micro instance
-  Enable real-time monitoring with Prometheus and Grafana
-  Configure alerts with Alertmanager for application downtime

---

## ☁️ AWS Environment

- Launch **2 EC2 Instances**:
  - 1 for Jenkins Server
  - 1 for Application Deployment
- Configure **security groups**
- Install Docker and Docker Compose on both servers

---

## 🔗 GitHub Configuration

- Create a webhook to trigger Jenkins pipeline:
  http://<JENKINS_EC2_PUBLIC_IP>:8080/github-webhook/

---

## 🐳 Docker Setup

- Create a Docker Hub account
- Repositories:
- **Public**: `srisatyap/dev`
- **Private**: `srisatyap/prod`
- Create a `Dockerfile` to run the React app inside **Nginx**

---

## ⚙️ Jenkins CI/CD

### Installation

- sudo apt update -y
- sudo apt install -y docker.io
- sudo usermod -aG docker jenkins
- sudo systemctl enable jenkins
- sudo systemctl start jenkins
---
- Plugins to Install
  - Pipeline
  - Docker pipeline
  - SSH Agent
  - Credentials Plugin
  - Github Webhook Trigger
- Credentials Configuration
  - Docker Hub: Username and Password
  - EC2: SSH Username with Private Key
  - GitHub: Username and Password (for private repositories)
- Jenkinsfile
  - Create a Declarative pipeline here by writing all the stages needed for the development docker images and production docker images and deploying the application to EC2.
  - The pipeline runs on any available agent and stages are run based on what branch the push or merge is happend in the github.
  - If the push is happend on dev branch, stage with name Docker Image build and push to dev repository runs and pushes the docker image to docker hub public repository srisatyap/dev by running the build.sh script
  - If the merge is happened on main branch from dev, then docker image is build and push to prod repository runs and pushes the docker image to docker hub private repository srisatyap/prod by running the build.sh script
  - Besides, when the branch is main stage with name Deploy the application to Server runs and deploys the application to the EC2 production server by pulling the image from the private repository by running the deploy.sh script.
- Pipeline Job Setup 
  - Access Jenkins dashboard
  - Create a new item → select Pipeline Job Name it: Final-React-1
  - Configure pipeline:
     - Pipeline script from SCM
     - SCM: Git → Enter repo URL → select credentials
     - Branches to build: main, dev
     - Script path: Jenkinsfile
     - Build Trigger: GitHub hook trigger for GitSCM polling
✅ Now any push to the dev branch or merge to main automatically builds and deploys the application.
---
📁 Shell Scripts
  - build.sh: Builds and pushes the Docker image to Docker Hub
  - deploy.sh: Pulls and runs the Docker image on the EC2 production instance
  - These scripts are invoked inside the Jenkins pipeline.
---
 📈 Monitoring Setup
  - Create a monitoring folder inside EC2
  - Create a docker-compose.yml file to launch prometheus, grafana, blackbox exporter and alert manager containers.
  - Create a monitoring-net network 
  - Create prometheus and alertmanager folders inside monitoring folder
  - Create prometheus.yml file and alert.rules.yml inside prometheus folder
  - Create alertmanager.yml inside the alert manager folder.
  - Run docker-compose up -d to run the containers
  - Make sure to open the ports 9090 for prometheus, 3000 for grafana, 9115 for blackbox exporter and 9093 for alert manager
---
📦WORKFLOW
  - Github Push or Merge --> trigger Jenkins Build
  - Build and push the image to dockerhub
  - Deploy to EC2
  - React App Running
  - Blackbox health check
  - Prometheus metrics scraping
  - Grafana Visualization
  - Alert Manager Email Alerts
---