variable "service_groups" {
  type        = map(set(string))
  description = "A map from unique logical service group names (which will be used in the generated role names) to sets of AWS service identifiers, like \"ec2.amazonaws.com\"."
}

variable "role_name_prefix" {
  type    = string
  default = ""
}

variable "role_path" {
  type        = string
  default     = "/"
  description = "Optional path in which to place the IAM roles."
}

variable "tags" {
  type        = map(string)
  description = "Map of AWS tags to assign to all of the IAM roles."
  default     = {}
}

variable "service_group_tag_key" {
  type        = string
  description = "If set, an additional tag of this name will be added to each IAM role, with the value set to the role's service group name. If this key is also present in the \"tags\" variable, the service name overrides that given value."
  default     = null
}

variable "role_max_session_duration" {
  type        = number
  description = "Maximum session duration for all of the roles, in sections."
  default     = 3600
}
