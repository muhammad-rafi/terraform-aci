# Cisco ACI Login Variables.
variable "aci_login" {
  description = "Cisco ACI Login Information"
  type        = map(any)
  default = {
    username = "admin"
    password = "!v3G@!4@Y"
    url      = "https://sandboxapicdc.cisco.com"
  }
}

# ACI Tenant Variable.
variable "tenant" {
  type    = string
  default = "tenant_rafi"
}

# ACI Tenant VRF Variable.
variable "vrf" {
  type    = string
  default = "dev_vrf"
}

# # ACI Tenant BD Variable.
# variable "bd" {
#   type    = string
#   default = "dev_bd"
# }

# # ACI Tenant BD Subnet Variable.
# variable "subnet" {
#   type    = string
#   default = "10.100.101.1/24"
# }

# ACI Tenant BD set of strings Variable.
variable "bd_set" {
  type    = set(string)
  default = ["web_bd", "db_bd"]
}

# ACI Tenant Bridge Domain and Subnet Map Variables.
variable "bd_subnet_map" {
  description = "BD and subnet map"
  type = map(object({
    bd_subnet = string,
    bd_scope = set(string)
    }
    )
  )
  default = {
    "web_bd" = {
      bd_subnet = "10.100.21.1/24",
      bd_scope  = ["public"]
    },
    "db_bd" = {
      bd_subnet = "10.100.22.1/24",
      bd_scope  = ["public"]
    }
  }
}

# ACI Tenant Application Profile Variable.
variable "ap_prof" {
  type    = string
  default = "rafi_ap"
}

# ACI Tenant Application EPGs Variable.
variable "epgs" {
  description = "Create epg"
  type        = map(any)
  default = {
    web_epg = {
      epg   = "web",
      bd    = "web_bd",
      encap = "21"
    },
    db_epg = {
      epg   = "db",
      bd    = "db_bd",
      encap = "22"
    }
  }
}

# ACI Tenant Filters Variable.
variable "filters" {
  description = "Create filters with names and ports"
  type        = map(any)
  default = {
    filter_https = {
      filter     = "https",
      entry      = "https",
      protocol   = "tcp",
      port       = "443",
      ether_type = "ipv4"
    },
    filter_sql = {
      filter     = "sql",
      entry      = "sql",
      protocol   = "tcp",
      port       = "1433",
      ether_type = "ipv4"
    }
  }
}

# ACI Tenant Contract Variable.
variable "contracts" {
  description = "Create contracts with these filters"
  type        = map(any)
  default = {
    contract_web = {
      contract = "web",
      subject  = "https",
      filter   = "filter_https",
      scope    = "context"
    },
    contract_sql = {
      contract = "sql",
      subject  = "sql",
      filter   = "filter_sql",
      scope    = "context"
    }
  }
}

# ACI Tenant EPGs Binding to contracts
variable "epg_contracts" {
  description = "epg contracts"
  type        = map(any)
  default = {
    terraform_one = {
      epg           = "web_epg",
      contract      = "contract_web",
      contract_type = "provider"
    },
    terraform_two = {
      epg           = "web_epg",
      contract      = "contract_sql",
      contract_type = "consumer"
    },
    terraform_three = {
      epg           = "db_epg",
      contract      = "contract_sql",
      contract_type = "provider"
    }
  }
}