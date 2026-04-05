```txt
.
├── 01_azure-infra
│   ├── external_location_outputs.tf
│   ├── external_location_private_endpoint.tf
│   ├── external_location_storage.tf
│   ├── external_location_variables.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── private_dns_zone_dp.tf
│   ├── providers.tf
│   ├── README.md
│   ├── terraform.tfvars.sample
│   ├── variables.tf
│   └── vnet_dp.tf
├── 02_databricks-workspace
│   ├── databricks_workspace.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── README.md
│   ├── terraform.tfvars.sample
│   └── variables.tf
├── 03_ws-after-task
│   ├── endpoint_backend.tf
│   ├── endpoint_dbfs.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── private_dns_zone_dp.tf
│   ├── providers.tf
│   ├── README.md
│   ├── terraform.tfvars.sample
│   └── variables.tf
├── 04_dbx-workspace-settings
│   ├── README.md
│   ├── task_001_account_groups.tf
│   ├── task_002_workspace_group_assignment.tf
│   ├── task_003_service_principal.tf
│   ├── task_004_service_principal_secret.tf
│   ├── task_005_sql_warehouse.tf
│   ├── task_006_ip_access_list.tf
│   ├── task_007_workspace_conf.tf
│   ├── task_008_metastore_grants.tf
│   ├── task_009_storage_credential.tf
│   ├── task_010_external_location.tf
│   ├── task_011_catalog.tf
│   ├── task_012_schema.tf
│   ├── task_013_volume.tf
│   ├── task_014_ncc.tf
│   ├── task_015_network_policy.tf
│   ├── terraform.tfvars.sample
│   ├── ws_data.tf
│   ├── ws_locals.tf
│   ├── ws_outputs.tf
│   ├── ws_providers.tf
│   └── ws_variables.tf
├── adb-with-private-link-standard
│   ├── databricks_workspace.tf
│   ├── endpoint_backend.tf
│   ├── endpoint_dbfs.tf
│   ├── external_location_outputs.tf
│   ├── external_location_private_endpoint.tf
│   ├── external_location_storage.tf
│   ├── external_location_variables.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── private_dns_zone_dp.tf
│   ├── providers.tf
│   ├── terraform.tfvars.sample
│   ├── variables.tf
│   └── vnet_dp.tf
├── dbx-workspace-settings
│   ├── task_001_account_groups.tf
│   ├── task_002_workspace_group_assignment.tf
│   ├── task_003_service_principal.tf
│   ├── task_004_service_principal_secret.tf
│   ├── task_005_sql_warehouse.tf
│   ├── task_006_ip_access_list.tf
│   ├── task_007_workspace_conf.tf
│   ├── task_008_metastore_grants.tf
│   ├── task_009_storage_credential.tf
│   ├── task_010_external_location.tf
│   ├── task_011_catalog.tf
│   ├── task_012_schema.tf
│   ├── task_013_volume.tf
│   ├── task_014_ncc.tf
│   ├── task_015_network_policy.tf
│   ├── terraform_remote_state.tf
│   ├── terraform.tfvars.sample
│   ├── ws_data.tf
│   ├── ws_outputs.tf
│   ├── ws_providers.tf
│   └── ws_variables.tf
└── README.md
```