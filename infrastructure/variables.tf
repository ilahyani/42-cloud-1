variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}
