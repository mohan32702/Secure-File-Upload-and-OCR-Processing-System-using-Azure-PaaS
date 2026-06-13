# Secure-File-Upload-and-OCR-Processing-System-using-Azure-PaaS

Secure File Upload and OCR Processing System using Azure PaaS with Private Networking
📌 Overview
This project demonstrates how to build a secure, cloud‑native file upload and text extraction pipeline using Azure PaaS services. It is implemented in two phases:

Phase 1: Public Implementation — Deploy a Python Flask web app to Azure App Service, integrate with Blob Storage, and process uploaded files using Azure Functions + Cognitive Services (OCR).

Phase 2: Private Networking Implementation — Harden the architecture by enabling VNet integration, creating Private Endpoints, and disabling public access to enforce Zero Trust networking.

This project is ideal for learning Azure DevOps practices, secure PaaS deployments, and event‑driven serverless architectures.

Architecture
Phase 1 (Public)
Web App — Python Flask app deployed on Azure App Service.

Blob Storage — Files uploaded via the web app are stored in a container (uploads).

Function App — Blob Trigger detects new uploads.

Cognitive Services (OCR) — Extracts text from uploaded images/PDFs.

Table Storage — Stores extracted text for retrieval.

Phase 2 (Private Networking)
Virtual Network (VNet) — Created with three subnets:

Hybrid subnet (Private Endpoints)

Function App subnet (delegated)

Web App subnet (delegated)

Private Endpoints — Configured for Web App, Function App, Blob Storage, Table Storage, and Cognitive Services.

Private DNS Zones — Ensured private IP resolution (privatelink.azurewebsites.net, privatelink.blob.core.windows.net, etc.).

Access Restrictions — Disabled public access for all services.

Validation — Verified DNS resolution with nslookup and tested end‑to‑end upload → OCR → Table Storage privately.

Implementation Steps
Phase 1
Create App Service (Python 3.10, Linux).

Create Blob Storage + container (uploads).

Configure environment variable BLOB_CONNECTION_STRING.

Deploy Flask app to App Service.

Create Function App with Blob Trigger.

Provision Cognitive Services (Computer Vision).

Store OCR results in Table Storage.

Phase 2
Create VNet + subnets (delegated for App Service and Function App).

Enable VNet integration for App Service and Function App.

Disable public access for all services.

Create Private Endpoints for App Service, Function App, Blob, Table, and Cognitive Services.

Configure Private DNS zones.

Validate with nslookup and test end‑to‑end workflow.

