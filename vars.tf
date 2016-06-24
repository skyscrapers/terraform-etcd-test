variable "access_key" {
  description = "AWS access key"
}

variable "secret_key" {
  description = "AWS secret access key"
}

variable "aws_region" {
  description = "The AWS region to work in."
  default = "eu-west-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block"
  default = "10.50.0.0/16"
}


variable "vpc_subnets_cidr_block" {
  description = "subnets that are available"
  default = "10.50.0.0/24,10.50.1.0/24,10.50.2.0/24"
}

variable "public_key_sam" {
  description = "Public key sam"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD2oK1fDJSbzEP92gyafd/tUkxKwXemVy3SOUkYrpbqASeyRu23RdMMa3z28rIWAYcqovnMyoVR2Q+9QwRp0ERseWAHsKa+hJDYokuUfZ23vyLKydgzElV4ZRHiJhg/cfdvUjoVCeFtL4EhGnLLU7dU4NpTg2m8TqVvOIzD7ck0lOIGalDe9iv1oFAqbbaZtk8DFcAW/8PsryOVmF+CH79RH9VvZM0Nw6lkeEj4rtX3THMiWe6IPqKfCEU66REXYBdAySOSy4BJPZRBa2YSnOybNdf1/j9geCKhr7eS4ysKn9jvdu7OKQELPIq0/xGR5ZhOhXeNtS9XhEwxEyY4IY/T sam@sambook"
}

variable "coreos_ami" {
  default = "ami-feaa228d"
}

variable "etcd_type" {
  default = "t2.small"
}

variable "count" {
  default = "3"
}

variable "discovery_url" {
  # browse to discovery.etcd.io/new?size=3
  # and paste the value eg: https://discovery.etcd.io/4308939a4725aa9bf9ec174c2c920068
  default = ""
}
