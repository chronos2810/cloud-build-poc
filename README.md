# Getting Started with Cloud Build

## Table of contents

<!-- MarkdownTOC autolink="true" -->

- [Prerequisites](#prerequisites)
- [Preparing the environment](#preparing-the-environment)
- [Creating a Sample App](#creating-a-sample-app)
- [Connecting our Github Repository to Cloud Source Repositories](#connecting-our-github-repository-to-cloud-source-repositories)
- [Creating Cloud Build Triggers](#creating-cloud-build-triggers)
- [Testing the trigger](#testing-the-trigger)

<!-- /MarkdownTOC -->

## Prerequisites

- Git
- Terraform
- Google Cloud SDK (Gcloud) 

## Preparing the environment

1. Clone this repo:

```bash
git clone https://github.com/cronos2810/cloud-build-poc
cd cloud-build-poc/project-creation
```

2. Create the GCP Project using Terraform

```bash
# Initialize Terraform
terraform init

# Generate the Build Plan
terraform plan -var-file 00-terraform.tfvars

# Apply
terraform apply -var-file 00-terraform.tfvars -auto-approve

# Save the Project ID for later use
PROJECT_ID=$(terraform output | grep -o "cloud-build-poc-......")

# Prepare the GCLOUD Environment
gcloud config set project ${PROJECT_ID}
```

## Creating a Sample App

We are going to be using the files from this repository to create a sample app, you can check the code in the following files:

- app/Dockerfile
- app/main.py

```bash
# Change the directory
cd ../app

# Build the Docker Hello World Image with Cloud Build using the PROJECT_ID variable created before
gcloud builds submit --tag gcr.io/${PROJECT_ID}/helloworld

# Once the image gets created, make the deploy in cloud run
gcloud run deploy hello-world \
  --image gcr.io/${PROJECT_ID}/helloworld \
  --platform managed \
  --allow-unauthenticated
```

We can test the app navigating to the URL displayed after using the command `gcloud run services list --platform managed`

Congratulations! We've successfully deployed a Cloud Run App using Cloud Build, next we are going to be learning how to use triggers to automatically deploy new versions of the Application using Cloud Build as CI/CD tool. 

## Connecting our Github Repository to Cloud Source Repositories

REF: https://cloud.google.com/cloud-build/docs/automating-builds/create-manage-triggers#gcloud

Now we need to mirror our Github Repository to GCP Cloud Source Repositories in order to use it with Build Triggers:

**1.** Open the Triggers page in the Google Cloud Console.

- [Open the triggers page](https://console.cloud.google.com/cloud-build/triggers?_ga=2.81884566.1637700177.1602688157-871824636.1602688157)

**2.** Select your project and click Open.  
**3.** Click Connect Repository.  
**4.** Select the repository where you've stored your source code.  
If you select GitHub (mirrored) or Bitbucket (mirrored) as your source repository, Cloud Build mirrors your repository in Cloud Source Repositories and uses the mirrored repository for all its operations.  
**5.** Click Continue.  
**6.** Authenticate to your source repository with your username and password.  
**7.** From the list of available repositories, select the desired repository, then click Connect repository.  
For external repositories, such as GitHub and Bitbucket, you must have owner-level permissions for the Cloud project with which you're working.  
**7.b.** If you see the message "The GitHub App is not installed on any of your repositories" you'll need to install it in your desired Repository using "Install Google Cloud Build"
**8.** Click "Connect Repository", once your repository it's connected click "Skip for now" in the Triggers section

## Creating Cloud Build Triggers

Now we are going to be creating our Cloud Build Trigger with using gcloud and environment variables: 

```bash
# Setting our PROJECT_ID in the cloudbuild.yaml file
sed -i "s/PROJECT_ID/$PROJECT_ID/" cloudbuild.yaml

# Setting variables for the trigger
export NAME="my-github-trigger"
export REPO_OWNER="cronos2810"
export REPO_NAME="cloud-build-poc"
export BUILD_CONFIG="cloudbuild.yaml"

# Creating the trigger using the gcloud and the master branch
gcloud beta builds triggers create github \
  --name=${NAME} \
  --repo-owner=${REPO_OWNER} \
  --repo-name=${REPO_NAME} \
  --pull-request-pattern="^master$" \
  --build-config=${BUILD_CONFIG}
```

## Testing the trigger

