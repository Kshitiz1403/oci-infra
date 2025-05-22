# OCI Infrastructure Setup

This repository contains Terraform configurations for managing Oracle Cloud Infrastructure (OCI) resources.

## Prerequisites

1. [OCI CLI](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm) installed and configured
2. [Terraform](https://developer.hashicorp.com/terraform/downloads) (v1.0.0 or later) installed
3. An Oracle Cloud Infrastructure account
4. API keys configured for OCI

## Initial Setup

### 1. Configure OCI CLI

If you haven't configured OCI CLI yet:

```bash
oci setup config
```

Follow the prompts to configure your:
- User OCID
- Tenancy OCID
- Region
- Key file path

### 2. Create State Storage Bucket

Run the following command to create a versioned bucket for storing Terraform state:

```bash
oci os bucket create --name terraform-states --versioning Enabled --compartment-id ocid1.tenancy.oc1..aaaaaaaazmshxiol4bmgetsexq7e3bgww7jui2o6mdsg62oxpnbmz2pqvfnq
```

### 3. Initialize Terraform

```bash
terraform init
```

## Usage

1. Review the planned changes:
```bash
terraform plan
```

2. Apply the infrastructure changes:
```bash
terraform apply
```

3. To destroy the infrastructure:
```bash
terraform destroy
```

## Directory Structure

```
terraform/
├── main.tf         # Main Terraform configuration
├── variables.tf    # Variable definitions
├── outputs.tf      # Output definitions
└── README.md      # This file
```