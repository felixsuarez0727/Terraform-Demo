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