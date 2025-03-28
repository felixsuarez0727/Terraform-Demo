resource "fabric_notebook" "example_notebook" {
  workspace_id              = fabric_workspace.example_workspace.id
  display_name              = var.notebook_display_name
  definition_update_enabled = var.notebook_definition_update_enabled
  definition = {
    "notebook-content.ipynb" = {
      source = var.notebook_definition_path
      format = "ipynb"  
    }
  }
}