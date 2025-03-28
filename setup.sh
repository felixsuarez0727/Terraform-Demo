#!/bin/bash
# Setup script for Microsoft Fabric Terraform Project

# Create project directory
mkdir -p terraform_demo
cd terraform_demo

# Create project files
echo "Creating Terraform configuration files..."

# Create provider.tf
cat > provider.tf << 'EOF'
# We strongly recommend using the required_providers block to set the Fabric Provider source and version being used
terraform {
  required_version = ">= 1.8, < 2.0"
  required_providers {
    fabric = {
      source  = "microsoft/fabric"
      version = "0.1.0-rc.2"
    }
  }
}

# Configure the Microsoft Fabric Terraform Provider
provider "fabric" {
  # Authentication is handled through environment variables:
  # ARM_CLIENT_ID
  # ARM_CLIENT_SECRET
  # ARM_TENANT_ID
  # ARM_SUBSCRIPTION_ID
}
EOF

# Create variables.tf
cat > variables.tf << 'EOF'
variable "workspace_display_name" {
  description = "A name for the getting started workspace."
  type        = string
}

variable "notebook_display_name" {
  description = "A name for the subdirectory to store the notebook."
  type        = string
}

variable "notebook_definition_update_enabled" {
  description = "Whether to update the notebook definition."
  type        = bool
  default     = true
}

variable "notebook_definition_path" {
  description = "The path to the notebook's definition file."
  type        = string
}

variable "capacity_name" {
  description = "The name of the capacity to use."
  type        = string
}

variable "lakehouse_display_name" {
  description = "A name for the lakehouse."
  type        = string
}
EOF

# Create workspace.tf
cat > workspace.tf << 'EOF'
data "fabric_capacity" "capacity" {
  display_name = var.capacity_name
}

resource "fabric_workspace" "example_workspace" {
  display_name = var.workspace_display_name
  description  = "Getting started workspace"
  capacity_id  = data.fabric_capacity.capacity.id
}
EOF

# Create notebook.tf
cat > notebook.tf << 'EOF'
resource "fabric_notebook" "example_notebook" {
  workspace_id              = fabric_workspace.example_workspace.id
  display_name              = var.notebook_display_name
  definition_update_enabled = var.notebook_definition_update_enabled
  definition = {
    "notebook-content.ipynb" = {
      source = var.notebook_definition_path
    }
  }
}
EOF

# Create lakehouse.tf
cat > lakehouse.tf << 'EOF'
resource "fabric_lakehouse" "example_lakehouse" {
  workspace_id  = fabric_workspace.example_workspace.id
  display_name  = var.lakehouse_display_name
  description   = "Example lakehouse created through Terraform"
}
EOF

# Create outputs.tf
cat > outputs.tf << 'EOF'
output "capacity_id" {
  value = data.fabric_capacity.capacity.id
}

output "workspace_id" {
  value = fabric_workspace.example_workspace.id
}

output "notebook_id" {
  value = fabric_notebook.example_notebook.id
}

output "lakehouse_id" {
  value = fabric_lakehouse.example_lakehouse.id
}
EOF

# Create terraform.tfvars
cat > terraform.tfvars << 'EOF'
workspace_display_name = "example workspace"
notebook_display_name = "example notebook"
notebook_definition_update_enabled = true
notebook_definition_path = "notebook.ipynb"
capacity_name = "your-capacity-name" # Replace with your actual capacity name
lakehouse_display_name = "example lakehouse"
EOF

# Create sample notebook.ipynb
cat > notebook.ipynb << 'EOF'
{
  "cells": [
    {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        "# Example Microsoft Fabric Notebook\n",
        "\n",
        "This notebook demonstrates basic functionality in Microsoft Fabric."
      ]
    },
    {
      "cell_type": "code",
      "execution_count": null,
      "metadata": {},
      "source": [
        "# Simple Python code cell\n",
        "print(\"Hello from Microsoft Fabric!\")"
      ],
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        "## Working with the Lakehouse\n",
        "\n",
        "The following cells demonstrate how to interact with a Lakehouse in Microsoft Fabric."
      ]
    },
    {
      "cell_type": "code",
      "execution_count": null,
      "metadata": {},
      "source": [
        "# Import libraries\n",
        "import pyspark.sql.functions as F\n",
        "from pyspark.sql.types import StructType, StructField, StringType, IntegerType\n",
        "\n",
        "# Create a simple dataframe\n",
        "schema = StructType([\n",
        "    StructField(\"id\", IntegerType(), False),\n",
        "    StructField(\"name\", StringType(), False),\n",
        "    StructField(\"department\", StringType(), True)\n",
        "])\n",
        "\n",
        "data = [\n",
        "    (1, \"John Doe\", \"HR\"),\n",
        "    (2, \"Jane Smith\", \"Engineering\"),\n",
        "    (3, \"Robert Johnson\", \"Marketing\"),\n",
        "    (4, \"Lisa Brown\", \"Finance\")\n",
        "]\n",
        "\n",
        "df = spark.createDataFrame(data, schema)\n",
        "df.show()"
      ],
      "outputs": []
    },
    {
      "cell_type": "code",
      "execution_count": null,
      "metadata": {},
      "source": [
        "# Save data to the lakehouse\n",
        "df.write.format(\"delta\").mode(\"overwrite\").saveAsTable(\"example_table\")"
      ],
      "outputs": []
    },
    {
      "cell_type": "code",
      "execution_count": null,
      "metadata": {},
      "source": [
        "# Read data from the lakehouse\n",
        "read_df = spark.read.table(\"example_table\")\n",
        "read_df.show()"
      ],
      "outputs": []
    }
  ],
  "metadata": {
    "kernelspec": {
      "display_name": "PySpark",
      "language": "python",
      "name": "pyspark"
    },
    "language_info": {
      "codemirror_mode": {
        "name": "ipython",
        "version": 3
      },
      "file_extension": ".py",
      "mimetype": "text/x-python",
      "name": "python",
      "nbconvert_exporter": "python",
      "pygments_lexer": "ipython3",
      "version": "3.8"
    }
  },
  "nbformat": 4,
  "nbformat_minor": 2
}
EOF

# Create README.md
cat > README.md << 'EOF'
# Microsoft Fabric Terraform Project

This project allows you to provision and manage Microsoft Fabric resources locally using Terraform.

## Resources Created

- Microsoft Fabric Workspace
- Notebook
- Lakehouse

## Prerequisites

Before running this project, ensure you have:

1. **Terraform CLI** installed (version >= 1.8)
   - Download from [Terraform website](https://www.terraform.io/downloads.html)
   - Verify installation: `terraform -v`

2. **Microsoft Fabric Capacity** provisioned in Azure
   - Note the capacity name for use in the configuration

3. **Authentication configured** for Microsoft Fabric Terraform Provider
   - Create a service principal in Azure AD
   - Assign appropriate permissions
   - Set the following environment variables:

```bash
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_TENANT_ID="your-tenant-id"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
```

## Running the Project Locally

1. Update terraform.tfvars with your specific values
2. Initialize Terraform:
   terraform init
3. Plan the changes:
   terraform plan -out=plan.tfplan
4. Apply the changes:
   terraform apply plan.tfplan
5. To remove all created resources:
   terraform destroy
EOF

echo "Project setup complete! Navigate to the terraform_demo directory to get started."
echo "Remember to update terraform.tfvars with your actual capacity name before running terraform init."