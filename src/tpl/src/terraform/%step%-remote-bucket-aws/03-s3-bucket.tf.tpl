{% set step = STEP or "" %}

{%- if steps[step]["state_bucket"] is defined and steps[step]["state_bucket"] != "" %}
  {%- set state_bucket = steps[step]["state_bucket"] %}
  {%- set bucket_name = steps[step]["state_bucket"] %}
{%- else %}
  {%- set state_bucket = ORG + '-' + APP + '-' + ENV + '.' + step + '-remote-bucket.terraform-state' %}
  {%- set bucket_name = ORG + '-' + APP + '-' + ENV + '.' + step + '-remote-bucket.terraform-state' %}
{%- endif %}

{% set bucket_name = bucket_name.replace(ORG,'${var.org}') %}
{% set bucket_name = bucket_name.replace(APP,'${var.app}') %}
{% set bucket_name = bucket_name.replace(ENV,'${var.env}') %}



module "state_bucket" {
  source  = "../modules/state-bucket-aws"
  bucket_name = "{{ bucket_name }}"
  dynamo_name = "tf-lock-${var.org}-${var.app}-${var.env}-{{ STEP }}"
}
