variable "workload_identity_display_name" {
  description = "The display name used for the workload identity app and credential."
  type        = string
}

variable "environment_id" {
  description = "The StitcherAI customer environment id. (Provided by StitcherAI)"
  type        = string
}

variable "stitcher_ai_sa_id" {
  description = <<EOT
    The ID of the service account for the StitcherAI environment, this grants stitcher sa access to the configured resources. 
    (Provided by StitcherAI)
  EOT
  type        = string
}

variable "azuread_service_principal_owners" {
  description = <<EOT
    The owners of the service principal. For more info reference: https://learn.microsoft.com/en-us/graph/api/resources/serviceprincipal?view=graph-rest-1.0
  EOT
  type        = list(string)
  default     = null
}
