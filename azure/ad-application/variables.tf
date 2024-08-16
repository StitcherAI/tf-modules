variable "environment_id" {
  description = "The StitcherAI environment id. (Provided by StitcherAI)"
  type        = string
}

variable "stitcher_ai_sa_id" {
  description = <<EOT
    The ID of the service account for the StitcherAI environment, this grants stitcher sa access to the configured resources. 
    (Provided by StitcherAI)
  EOT
  type = string
}
