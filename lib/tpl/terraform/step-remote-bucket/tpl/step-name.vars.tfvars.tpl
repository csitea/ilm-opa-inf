{%- if steps["step-name"] %}
org                                                = "{{ ORG }}"
app                                                = "{{ APP }}"
env                                                = "{{ ENV }}"
shared_credentials_files                           = "{{ aws["AWS_SHARED_CREDENTIALS_FILE"] }}"
shared_config_files                                = "{{ aws["AWS_CONFIG_FILE"] }}"

{%- for key, value in steps["step-name"].items() %}
{%- set key_length = 50 - (key | length) %}
{%- if key == "AWS_PROFILE" %}
profile {{ "=" | indent( 43, True) }} {{ value | tojson}}
{%- elif key == "AWS_REGION" %}
region {{ "=" | indent( 44, True) }} {{ value | tojson}}
{%- else %}
{{ key }} {{ "=" | indent( key_length, True) }} {{ value | tojson}}
{%- endif %}
{%- endfor %}

{%- else %}
# This file is empty because there is no configuration block for this step in  
# Running this step will cause terraform to error before init.
{%- endif %}
