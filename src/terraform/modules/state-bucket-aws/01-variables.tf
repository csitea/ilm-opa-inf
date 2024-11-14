variable "bucket_name" {
    type = string
    description = "name of state bucket"
}

variable "dynamo_name" {
    type = string
    description = "name of dynamoDB table for state lock"
}

variable "kms_deletion_window" {
    type = number
    description = "KMS deletion window from 7 to 30 days available"
    default = 7
}