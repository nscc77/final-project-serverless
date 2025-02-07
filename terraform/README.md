# Serverless Memo Application - Deployment Guide

## Overview

This application is a serverless memo application deployed on AWS using Terraform, Route53, Api Gateway, Dynamodb, S3, Cognito, Lambda, and CloudFront. The deployment is fully automated via CI/CD and follow this structured order:

1. **Backend Deployment** - Checks if the ECR repository exists, creates it if not, builds the Docker image, and pushes it to ECR.
2. **Terraform Provisioning** - Deploys all necessary AWS infrastructure, including Cognito, Lambda functions, API Gateway, S3 static bucket, DynamoDB, and CloudFront.
3. **Frontend Deployment** - Builds the frontend application and deploys it to an S3 static bucket.

---

## Prerequisites

Before starting the deployment, ensure you have the following:

- **CI/CD Execution Role** - A role with permissions to deploy the infrastructure and application.
- **S3 Bucket for Remote State Files** - Used for storing Terraform state.
- **DynamoDB for State Locking** - Prevents concurrent Terraform operations.
- **GitHub Actions Secrets & Variables** - Needed for CI/CD execution (see the GitHub Actions section below).

---

## Deployment Steps

### 1. Backend Deployment

The backend deployment is fully automated using GitHub Actions and AWS services. The workflow follows these steps:

1. **Triggered by Changes** - The pipeline runs when changes are pushed to the `backend/` directory in the `main` branch or manually triggered.
2. **Clone Repository** - Uses `actions/checkout@v4` to clone the repository.
3. **AWS Authentication** - Uses `aws-actions/configure-aws-credentials@v4` to set up AWS credentials.
4. **Check and Create ECR Repository** - Ensures the ECR repository exists before proceeding.
5. **Build Docker Image** - Uses Docker to build the backend image.
6. **Push Image to ECR** - Tags and pushes the Docker image to AWS ECR.

---

### 2. Terraform Infrastructure Deployment

Terraform provisions all required AWS services.

#### **Terraform Directory Structure:**

```plaintext
terraform/
│── api-module/           # Manages API Gateway and Lambda functions
│   ├── main.tf           # Defines API Gateway and Lambda configuration
│   ├── outputs.tf        # Outputs Lambda invoke URL and API Gateway details
│   ├── variables.tf      # Input variables for API module
│
│── cognito-module/       # Manages Cognito authentication
│   ├── main.tf           # Configures Cognito User Pool and User Pool Client
│   ├── outputs.tf        # Outputs Cognito User Pool ID and Client ID
│   ├── variables.tf      # Input variables for Cognito settings
│
│── cloudfront-route53-module/ # Configures CloudFront and Route 53
│   ├── main.tf           # CloudFront distribution and Route 53 setup
│   ├── outputs.tf        # Outputs CloudFront distribution URL
│   ├── variables.tf      # Input variables for CloudFront and Route 53
│
│── dynamodb-module/      # Provisioning for DynamoDB storage
│   ├── main.tf           # Creates DynamoDB table for storing application data
│   ├── outputs.tf        # Outputs table name and ARN
│   ├── variables.tf      # Configurable parameters for table setup
│
│── s3-module/            # S3 bucket configuration
│   ├── main.tf           # S3 bucket for frontend hosting and logging
│   ├── outputs.tf        # Outputs S3 bucket name
│   ├── variables.tf      # Configurable parameters for S3
│
│── iam-module/           # IAM roles and policies for the application
│   ├── main.tf           # IAM roles for Lambda, API Gateway, and CI/CD
│   ├── outputs.tf        # Outputs IAM role ARNs
│   ├── variables.tf      # Configurable parameters for IAM policies
│
│── root-module/
│   │── main.tf               # Root Terraform configuration
│   │── providers.tf          # Setting up AWS providers and S3 remote statefile
│   │── outputs.tf            # Aggregates all Terraform module outputs
│   │── variables.tf          # Global variables for Terraform setup
```

---

### 3. Frontend Deployment

The frontend deployment is handled automatically via GitHub Actions with the following workflow:

1. **Triggered by Changes** - The pipeline runs when changes are pushed to the `frontend/` directory in the `main` branch or manually triggered.
2. **Clone Repository** - Uses `actions/checkout@v4` to fetch the latest frontend code.
3. **AWS Authentication** - Uses `aws-actions/configure-aws-credentials@v4` to authenticate with AWS.
4. **Install Dependencies** - Runs `npm install` to install frontend dependencies.
5. **Build Frontend** - Uses `npm run build` to create the production-ready frontend.
6. **Upload to S3** - Syncs the built frontend to the S3 bucket hosting the static site.
7. **Invalidate CloudFront Cache** - Ensures new frontend changes are available by invalidating CloudFront cache.

This setup ensures that frontend changes are automatically deployed and accessible with minimal downtime.

---

## GitHub Actions CI/CD

The deployment is automated using GitHub Actions. Ensure the following environment variables are set in **GitHub Secrets**:

### Environment Variables

| Variable           | Description               |
| ------------------ | ------------------------- |
| AWS\_REGION        | AWS region for deployment |
| DOMAIN\_NAME       | Application domain name   |
| HOSTED\_ZONE\_NAME | Route 53 hosted zone name |

### GitHub Secrets

| Secret Name                  | Description                                |
| ---------------------------- | ------------------------------------------ |
| CLOUDFRONT\_DISTRIBUTION\_ID | CloudFront distribution ID                 |
| S3\_BUCKET\_STATEFILE        | S3 bucket name for storing Terraform state |
| ECR\_REPO\_NAME              | Name of the ECR repository                 |
| IAM\_ROLE                    | IAM role for CI/CD execution               |
| STATEFILE\_DYNAMODB\_TABLE   | DynamoDB table for Terraform state locking |
| STATE\_FILE\_KEY             | Key used to store Terraform state in S3    |
| VITE\_BACKEND\_API\_URL      | API Gateway invoke URL for the frontend    |
| VITE\_USER\_POOL\_CLIENT\_ID | Cognito User Pool client ID                |
| VITE\_USER\_POOL\_ID         | Cognito User Pool ID                       |

---

## Conclusion

This deployment guide ensures a smooth CI/CD workflow for the **Serverless Memo Application** using automated GitHub Actions and Terraform provisioning. Make sure all needed Terraform outputs are correctly updated in GitHub Environments!

