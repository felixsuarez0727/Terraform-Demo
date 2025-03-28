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

## Project Structure

```
terraform_demo/
├── provider.tf           # Terraform provider configuration
├── variables.tf          # Input variables definition
├── workspace.tf          # Fabric workspace configuration
├── notebook.tf           # Fabric notebook configuration
├── lakehouse.tf          # Fabric lakehouse configuration
├── outputs.tf            # Output variables definition
├── terraform.tfvars      # Variable values
├── notebook.ipynb        # Sample notebook definition
└── README.md             # Project documentation
```

## Configuration

Before running the project, update the `terraform.tfvars` file with your specific values:

```hcl
workspace_display_name = "example workspace"
notebook_display_name = "example notebook"
notebook_definition_update_enabled = true
notebook_definition_path = "notebook.ipynb"
capacity_name = "your-capacity-name"  # Replace with your actual capacity name
lakehouse_display_name = "example lakehouse"
```

## Running the Project Locally

1. Clone this repository or copy all files to a new directory
2. Navigate to the project directory
3. Initialize Terraform:

```bash
terraform init
```

4. Plan the changes:

```bash
terraform plan -out=plan.tfplan
```

5. Apply the changes:

```bash
terraform apply plan.tfplan
```

6. After applying, Terraform will output the IDs of the created resources

## Cleaning Up

To remove all created resources:

```bash
terraform destroy
```

## Troubleshooting

If you encounter any issues:

1. Verify your authentication credentials
2. Ensure your Fabric Capacity is properly provisioned
3. Check the capacity name in your `terraform.tfvars` file
4. Refer to the [Troubleshooting guide](https://learn.microsoft.com/en-us/fabric/developer/terraform/fabric-terraform-troubleshooting) in the official documentation
