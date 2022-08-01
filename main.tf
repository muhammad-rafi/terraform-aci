# Cisco ACI Terraform Provider Declaration
terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = "= 0.7"
    }
  }
}

# Cisco ACI Terraform Provider Configuration
provider "aci" {
  # Cisco ACI Login Username
  username = var.aci_login.username
  # Cisco ACI Login Password
  password = var.aci_login.password
  #   # Private key path
  #   private_key = "path to private key"
  #   # Certificate Name
  #   cert_name = "user-cert"
  # Cisco ACI Login URL
  url      = var.aci_login.url
  insecure = true
}

# Define an ACI Tenant Resource.
resource "aci_tenant" "terraform_tenant" {
  name        = var.tenant
  description = "Tenant Created via Terraform"
}

# Define an ACI Tenant VRF Resource.
resource "aci_vrf" "terraform_vrf" {
  tenant_dn   = aci_tenant.terraform_tenant.id
  description = "VRF Created via Terraform"
  name        = var.vrf
}

# Define an ACI Tenant BD Resource
resource "aci_bridge_domain" "terraform_bd" {
  for_each           = var.bd_set
  tenant_dn          = aci_tenant.terraform_tenant.id
  relation_fv_rs_ctx = aci_vrf.terraform_vrf.id
  description        = "BD Created via Terraform"
  name               = each.value
}

# Define an ACI Tenant BD Subnet Resource.
resource "aci_subnet" "terraform_bd_subnet" {
  for_each    = var.bd_subnet_map
  parent_dn   = aci_bridge_domain.terraform_bd[each.key].id
  description = "Subnet Created via Terraform"
  ip          = each.value.bd_subnet
  scope       = each.value.bd_scope
}

# Define an ACI Application Profile Resource.
resource "aci_application_profile" "terraform_ap" {
  tenant_dn   = aci_tenant.terraform_tenant.id
  name        = var.ap_prof
  description = "App Profile Created via Terraform"
}

# Define an ACI Application EPG Resource.
resource "aci_application_epg" "terraform_epg" {
  for_each               = var.epgs
  application_profile_dn = aci_application_profile.terraform_ap.id
  name                   = each.value.epg
  relation_fv_rs_bd      = aci_bridge_domain.terraform_bd[each.value.bd].id
  description            = "EPG Created via Terraform"
}

# Define ACI  ACI VMM Domain
resource "aci_vmm_domain" "terraform_vmm_domain" {
  provider_profile_dn = "uni/vmmp-VMware"
  name                = "rafi-aci_terraform_lab"
}

# Associate the EPG Resources with a VMM or Physica Domain.
resource "aci_epg_to_domain" "terraform_epg_domain" {
  for_each           = var.epgs
  application_epg_dn = aci_application_epg.terraform_epg[each.key].id
  # tdn                = "uni/vmmp-VMware/dom-rafi-aci_terraform_lab"
  tdn = aci_vmm_domain.terraform_vmm_domain.id
}

# Define an ACI filter Resource.
resource "aci_filter" "terraform_filter" {
  for_each    = var.filters
  tenant_dn   = aci_tenant.terraform_tenant.id
  description = "This is filter ${each.key} created via terraform"
  name        = each.value.filter
}

# Define an ACI filter entry resource.
resource "aci_filter_entry" "terraform_filter_entry" {
  for_each    = var.filters
  filter_dn   = aci_filter.terraform_filter[each.key].id
  name        = each.value.entry
  ether_t     = each.value.ether_type
  prot        = each.value.protocol
  d_from_port = each.value.port
  d_to_port   = each.value.port
}

# Define an ACI Contract Resource.
resource "aci_contract" "terraform_contract" {
  for_each    = var.contracts
  tenant_dn   = aci_tenant.terraform_tenant.id
  name        = each.value.contract
  description = "Contract created via Terraform"
  scope       = each.value.scope
}

# Define an ACI Contract Subject Resource.
resource "aci_contract_subject" "terraform_contract_subject" {
  for_each                     = var.contracts
  contract_dn                  = aci_contract.terraform_contract[each.key].id
  name                         = each.value.subject
  relation_vz_rs_subj_filt_att = [aci_filter.terraform_filter[each.value.filter].id]
}

# Associate the EPGs with the contracts
resource "aci_epg_to_contract" "terraform_epg_contract" {
  for_each           = var.epg_contracts
  application_epg_dn = aci_application_epg.terraform_epg[each.value.epg].id
  contract_dn        = aci_contract.terraform_contract[each.value.contract].id
  contract_type      = each.value.contract_type
}
