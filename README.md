# Cisco ACI Programmability with Terraform

## Introduction
I have created this repository to practice Terrafrom with ACI for my DevNet Expert exam, Therefore, this repo is using the same versions for Terraform and ACI provider which are mentioned in DevNet Expert [Equipment and Software list](https://learningnetwork.cisco.com/s/article/devnet-expert-equipment-and-software-list).


```bash
Terraform 1.0
    CiscoDevNet/aci v0.7
```

You can find the Terraform ACI provider documentation [here](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs).

## Download Terraform
Check out the this [link](https://www.terraform.io/downloads) to download and install the Terraform on different operating systems.

## Usage 

Clone this repository 

```bash
$ git clone git@github.com:muhammad-rafi/terraform-aci.git
```

The four main Terraform commands you will need to run after you change the variable as you require

- terraform init - Initialize your Terraform directory to be able to execute your plan. Terraform downloads all defined providers in your main.tf file.

- terraform plan - Analyze your main.tf file and compare it to the state file terraform.tfstate (if it exists) to determine what part of the plan must be deployed, updated, or destroyed.

- terraform apply - Apply the changes described by the plan command to the third-party systems and update the terraform.tfstate file with the current configuration state for the resources described in the plan.

- terraform destroy - Remove or "unconfigure" all the resources previously deployed. Terraform tracks those resources by using the state file terraform.tfstate.

- terraform fmt --recursive - To format all the terraform .tf files recursively.

You may also use `-auto-approve` flag with `terraform apply` or `terraform destroy` if you know exactly what are you doing as it will not prompt to answer 'Yes or No' to make changes.

## Task - Provision Following Resources via Terraform

- ACI Tenant - 'tenant_rafi'
- ACI Tenant VRF - 'dev_vrf'
- ACI Tenant Bridge Domain - 'web_bd & db_bd'
- ACI Tenant Bridge Domain Subnets - '10.100.21.1/24 & 10.100.22.1/24'
- ACI Tenant Application Profile - 'ap_prof
- ACI Tenant Endpoint Groups (EPGs) - 'web_epg & db_epg'
- ACI Tenant Filters and Contracts to allow traffic (https & sql) between EPGs.

## Terraform ACI resources used 

- aci_tenant
- aci_vrf
- aci_bridge_domain
- aci_subnet
- aci_application_profile
- aci_application_epg
- aci_vmm_domain
- aci_filter
- aci_filter_entry
- aci_contract
- aci_contract_subject

work in progress for L3out ...

## References
[Muhammad Rafi](https://www.linkedin.com/in/muhammad-rafi-0a37a248/)

## References

[Cisco ACI terraform provider documentation](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs)

[ACI Programmability](https://developer.cisco.com/learning/tracks/aci-programmability/)

[ACI Programmability - Introduction to ACI and Terraform](https://developer.cisco.com/learning/tracks/aci-programmability/terraform-aci-intro/)

