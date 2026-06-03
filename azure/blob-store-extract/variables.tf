variable "stitcher_ai_service_principal_id" {
  description = "Value of the service principal id created by the common ad_application module"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account the access is scoped to"
  type        = string
}

variable "storage_container_name" {
  description = "The name of the storage container the access is scoped to"
  type        = string
}

variable "blob_path" {
  description = "The blob path prefix the read access is scoped to. Provide a bare prefix WITHOUT a trailing '*' (extract matches by StringStartsWith), e.g. \"cost/\"."
  type        = string

  validation {
    condition     = !endswith(var.blob_path, "*")
    error_message = "blob_path must NOT end with '*' for extract (it is matched as a literal prefix via StringStartsWith)."
  }
}

variable "resource_group_name" {
  description = "The name of the resource group containing the storage account"
  type        = string
}
