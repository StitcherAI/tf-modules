# Retrieve the existing storage account using the data source
data "azurerm_storage_account" "target_storage_bucket" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "principal_role_assignment" {
  principal_id         = var.stitcher_ai_service_principal_id
  role_definition_name = "Storage Blob Data Reader"
  scope                = data.azurerm_storage_account.target_storage_bucket.id

  condition_version = "2.0"

  condition = <<EOF
  (
   (
    !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND NOT SubOperationMatches{'Blob.List'})
   )
   OR 
   (
    @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:name] StringEquals '${var.storage_container_name}'
    AND
    @Resource[Microsoft.Storage/storageAccounts/blobServices/containers/blobs:path] StringStartsWith '${var.blob_path}'
   )
  )
  AND
  (
   (
    !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND SubOperationMatches{'Blob.List'})
   )
   OR 
   (
    @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:name] StringEquals '${var.storage_container_name}'
    AND
    @Request[Microsoft.Storage/storageAccounts/blobServices/containers/blobs:prefix] StringStartsWith '${var.blob_path}'
   )
  )
  EOF
}
