# Getting Started with Cloud Build

## Table of contents

<!-- MarkdownTOC autolink="true" -->

- [Prerequisites](#prerequisites)
- [Preparing the environment](#preparing-the-environment)
- [Creating a Sample App](#creating-a-sample-app)

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
terraform init
terraform plan -var-file 00-terraform.tfvars
terraform apply -var-file 00-terraform.tfvars -auto-approve
```

## Creating a Sample App

```bash
cd ..
```