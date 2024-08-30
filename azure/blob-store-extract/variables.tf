variable "stitcher_ai_service_principal_id" {
  description = "Value of the service principal id created by the common ad_application module"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account containng cost data"
  type        = string
}

variable "storage_container_name" {
  description = "The name of the storage container containng cost data"
  type        = string
}

variable "blob_path" {
  description = "The path to the storage blob containng cost data"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group containing the storage account"
  type        = string
}
