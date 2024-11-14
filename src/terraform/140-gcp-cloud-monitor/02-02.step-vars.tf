variable "sender_email" {
  description = "The sender email address for alerts"
  type        = string
}

variable "recipient_email" {
  description = "The recipient email address for alerts"
  type        = string
}

variable "smtp_server" {
  description = "The SMTP server for sending emails"
  type        = string
}

variable "smtp_port" {
  description = "The SMTP port for sending emails"
  type        = number
  default     = 587
}

variable "smtp_username" {
  description = "The SMTP username for authentication"
  type        = string
}

variable "project_number" {
  description = "The GCP project number"
  type        = string
  default = "0"
}

variable "kbdx_db_key_file_name" {
  type = string
  description = "The name of the key file to open the kbdx database"
}

variable cron_schedule {
  description = "The cron schedule for the Cloud Scheduler job"
  type        = string
  default     = "0 * * * *"
}
