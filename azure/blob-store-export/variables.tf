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
  description = "The blob path prefix the write access is scoped to. Provide a prefix WITH a trailing '*' (export matches by StringLike), e.g. \"exports/*\"."
  type        = string

  validation {
    condition     = endswith(var.blob_path, "*")
    error_message = "blob_path must end with '*' to indicate a prefix"
  }
}

variable "resource_group_name" {
  description = "The name of the resource group containing the storage account"
  type        = string
}
