resource "fabric_lakehouse" "example_lakehouse" {
  workspace_id  = fabric_workspace.example_workspace.id
  display_name  = var.lakehouse_display_name
  description   = "Example lakehouse created through Terraform"
}