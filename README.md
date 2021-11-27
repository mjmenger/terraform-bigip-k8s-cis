<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_postbuild-config-as3"></a> [postbuild-config-as3](#module\_postbuild-config-as3) | github.com/mjmenger/terraform-bigip-postbuild-config//as3 | v0.5.1 |
| <a name="module_postbuild-config-do"></a> [postbuild-config-do](#module\_postbuild-config-do) | github.com/mjmenger/terraform-bigip-postbuild-config//do | v0.5.1 |

## Resources

| Name | Type |
|------|------|
| [null_resource.cis_init](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [external_external.tunnelmac](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bigip_default_gateway_address"></a> [bigip\_default\_gateway\_address](#input\_bigip\_default\_gateway\_address) | n/a | `any` | n/a | yes |
| <a name="input_bigip_external_address"></a> [bigip\_external\_address](#input\_bigip\_external\_address) | n/a | `any` | n/a | yes |
| <a name="input_bigip_internal_gateway_address"></a> [bigip\_internal\_gateway\_address](#input\_bigip\_internal\_gateway\_address) | n/a | `any` | n/a | yes |
| <a name="input_bigip_k8s_partition"></a> [bigip\_k8s\_partition](#input\_bigip\_k8s\_partition) | n/a | `any` | n/a | yes |
| <a name="input_bigip_management_address"></a> [bigip\_management\_address](#input\_bigip\_management\_address) | n/a | `any` | n/a | yes |
| <a name="input_bigip_password"></a> [bigip\_password](#input\_bigip\_password) | n/a | `any` | n/a | yes |
| <a name="input_bigip_private_address"></a> [bigip\_private\_address](#input\_bigip\_private\_address) | n/a | `any` | n/a | yes |
| <a name="input_bigip_tunnel_name"></a> [bigip\_tunnel\_name](#input\_bigip\_tunnel\_name) | n/a | `any` | n/a | yes |
| <a name="input_bigip_tunnel_overlay_address"></a> [bigip\_tunnel\_overlay\_address](#input\_bigip\_tunnel\_overlay\_address) | variable bigip\_tunnel\_mac{} | `any` | n/a | yes |
| <a name="input_bigip_username"></a> [bigip\_username](#input\_bigip\_username) | n/a | `any` | n/a | yes |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | n/a | `any` | n/a | yes |
| <a name="input_infra_private_key"></a> [infra\_private\_key](#input\_infra\_private\_key) | n/a | `any` | n/a | yes |
| <a name="input_infra_private_key_path"></a> [infra\_private\_key\_path](#input\_infra\_private\_key\_path) | n/a | `any` | n/a | yes |
| <a name="input_k8s_controller_address"></a> [k8s\_controller\_address](#input\_k8s\_controller\_address) | n/a | `any` | n/a | yes |
| <a name="input_k8s_controller_username"></a> [k8s\_controller\_username](#input\_k8s\_controller\_username) | n/a | `any` | n/a | yes |
| <a name="input_k8s_podsubnet"></a> [k8s\_podsubnet](#input\_k8s\_podsubnet) | n/a | `any` | n/a | yes |
| <a name="input_nameserver"></a> [nameserver](#input\_nameserver) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tunnelmac"></a> [tunnelmac](#output\_tunnelmac) | n/a |
<!-- END_TF_DOCS -->