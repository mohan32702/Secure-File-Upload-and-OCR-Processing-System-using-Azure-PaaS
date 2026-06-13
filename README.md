Secure File Upload and OCR Processing System using Azure PaaS with Private Networking
📌 Overview
This project demonstrates how to build a secure, cloud native file upload and text extraction pipeline using Azure PaaS services. It is implemented in two phases:
<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/cc340ce8-5c49-4c3f-af2e-dbc9fa6b6f9a" />

•	Phase 1: Public Implementation — Deploy a Python Flask web app to Azure App Service, integrate with Blob Storage, and process uploaded files using Azure Functions + Cognitive Services (OCR).
•	Phase 2: Private Networking Implementation — Harden the architecture by enabling VNet integration, creating Private Endpoints, and disabling public access to enforce Zero Trust networking.
This project is ideal for learning Azure DevOps practices, secure PaaS deployments, and event driven serverless architectures.

🏗️ Architecture

Phase 1 (Public)
•	Web App — Python Flask app deployed on Azure App Service.
•	Blob Storage — Files uploaded via the web app are stored in a container (uploads).
•	Function App — Blob Trigger detects new uploads.
•	Cognitive Services (OCR) — Extracts text from uploaded images/PDFs.
•	Table Storage — Stores extracted text for retrieval.

Phase 2 (Private Networking)
•	Virtual Network (VNet) — Created with three subnets: Hybrid (Private Endpoints), Function App subnet (delegated), Web App subnet (delegated).
•	Private Endpoints — Configured for Web App, Function App, Blob Storage, Table Storage, and Cognitive Services.
•	Private DNS Zones — Ensured private IP resolution (privatelink.azurewebsites.net, privatelink.blob.core.windows.net, etc.).
•	Access Restrictions — Disabled public access for all services.
•	Validation — Verified DNS resolution with nslookup and tested end to end upload → OCR → Table Storage privately.

⚙️ Implementation Steps

Phase 1
•	Create App Service (Python 3.10, Linux).
•	Create Blob Storage + container (uploads).
•	Configure environment variable BLOB_CONNECTION_STRING.
•	Deploy Flask app to App Service.
•	Create Function App with Blob Trigger.
•	Provision Cognitive Services (Computer Vision).
•	Store OCR results in Table Storage.

Phase 2
•	Create VNet + delegated subnets.
•	Enable VNet integration for App Service and Function App.
•	Disable public access for all services.
•	Create Private Endpoints for App Service, Function App, Blob, Table, and Cognitive Services.
•	Configure Private DNS zones.
•	Validate with nslookup and test end to end workflow.

🚀 CI/CD Pipelines

Infra CI/CD (Terraform)

This pipeline automates infrastructure deployment using Terraform:
1.	Trigger — Runs on master branch using self hosted agent (Azure VM SH Pool).
2.	Dev Deploy — Initializes Terraform, validates, plans, and applies infra in Dev (dev.tfstate).
3.	Prod Plan — Prepares a plan for Prod (prod.tfstate) and saves it as an artifact.
4.	Prod Approval — Manual validation step before Prod deployment.
5.	Prod Apply — Downloads the approved plan and applies it safely to Prod.

Web App CI/CD (App Deployment)

This pipeline automates application deployment:
1.	Trigger & Pool — Runs on WeAppDeploy branch using self hosted agent (WebAppDeploy).
2.	Variables — Defines reusable values (appName, resourceGroup).
3.	Build Stage — Installs dependencies, creates venv, packages app into app.zip, publishes artifact.
4.	Deploy Staging — Deploys artifact to staging slot using AzureWebApp@1.
5.	Deploy Prod — Requires manual approval, then swaps staging slot into production with AzureAppServiceManage
