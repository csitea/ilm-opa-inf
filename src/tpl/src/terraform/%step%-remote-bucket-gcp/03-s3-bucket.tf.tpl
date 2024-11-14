{% set step = STEP or "" %}

{%- if steps[step]["state_bucket"] is defined and steps[step]["state_bucket"] != "" %}
  {%- set state_bucket = steps[step]["state_bucket"] %}
  {%- set bucket_name = steps[step]["state_bucket"] %}
  {%- set keyring_name = steps[step]["keyring_name"] %}
{%- else %}
  {%- set state_bucket = ORG + '-' + APP + '-' + ENV + '.' + step + '-remote-bucket.tfstate' %}
  {%- set bucket_name = ORG + '-' + APP + '-' + ENV + '.' + step + '-remote-bucket.tfstate' %}
  {%- set keyring_name = ORG + '-' + APP + '-' + ENV + '-' + step %}
{%- endif %}

{%- set bucket_name = bucket_name.replace(ORG,'${var.org}') -%}
{%- set bucket_name = bucket_name.replace(APP,'${var.app}') -%}
{%- set bucket_name = bucket_name.replace(ENV,'${var.env}') -%}
{%- set keyring_name = bucket_name.replace(ORG,'${var.org}') -%}
{%- set keyring_name = bucket_name.replace(APP,'${var.app}') -%}
{%- set keyring_name = bucket_name.replace(ENV,'${var.env}') -%}



module "state_bucket" {
  source  = "../modules/state-bucket-gcp"
  bucket_name = try(var.bucket_name, "{{ bucket_name }}")
  #keyring_name = "{{ keyring_name }}"
}
