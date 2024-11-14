# run in the following order:
# prd -> all -> dev -> tst
# Gandhi Registrar
#   |
#   +-- Forward flok.fi to Google Cloud DNS
#        |
#        +-- flk-all-all (flok.fi zone)
#             |
#             +-- ilm-opa-prd (mmp.flok.fi zone)
#                  |
#                  +-- ilm-opa-dev (dev.mmp.flok.fi zone)
#                  +-- ilm-opa-tst (tst.mmp.flok.fi zone)
# requires also
# gcloud config set project ${var.org}-${var.app}-prd
# gcloud projects add-iam-policy-binding ${var.org}-${var.app}-prd   --member="serviceAccount:${var.service_account_email}"   --role="roles/dns.admin"

# ilm-opa-prd@ilm-opa-prd.iam.gserviceaccount.com
# ${var.org}-${var.app}-prd@${var.org}-${var.app}-prd.iam.gserviceaccount.com
#
# run the following script manually before divesting the DNS zone
# /opt/str/ilm-opa/ilm-opa-inf/src/bash/scripts/remove-org-app-prd-dns-zone.sh

# Creating GCP DNS sub zone for production ${var.fqn_web_app_subdomain}
resource "google_dns_managed_zone" "application_subzone_prd" {
  count       = var.env == "prd" ? 1 : 0
  provider    = google.prd
  name        = var.prd_zone_name
  dns_name    = "${var.fqn_web_app_subdomain}."
  description = "Subzone for ${var.fqn_web_app_subdomain}"
}


# START ::: Delegating prd to the "all"  ${var.tld_domain}

resource "google_dns_record_set" "delegate_doc_to_tld_zone" {
  count        = var.env == "prd" ? 1 : 0
  provider     = google.all
  name         = "${var.fqn_web_app_subdomain}."
  type         = "NS"
  ttl          = 21600
  managed_zone = var.tld_zone_name
  rrdatas      = google_dns_managed_zone.application_subzone_prd[0].name_servers
}
# STOP ::: Delegating ${var.fqn_web_app_subdomain} to the production subzone


# START ::: email configuration

resource "google_dns_record_set" "spf_record_prd" {
  count        = var.env == "prd" ? 1 : 0
  name         = "${var.fqn_web_app_subdomain}."
  type         = "TXT"
  ttl          = 300  # Time-to-live value
  managed_zone = "${var.org}-${var.app}-${var.env}-subzone"
  rrdatas      = ["v=spf1 include:_spf.google.com ~all"]
  depends_on   = [google_dns_managed_zone.application_subzone_prd]
}

# STOP  ::: email configuration


  # dns:
  #   domain: *domain # flok.fi
  #   wpb_fqdn: &wpb_fqdn mmp.flok.fi
  #   tld_domain: &tld_domain flok.fi
  #   env_subdomain: &env_subdomain doc
  #   fqn_env_subdomain: &fqn_env_subdomain mmp.flok.fi
  #   fqn_web_app_subdomain: &fqn_web_app_subdomain "mmp.flok.fi"
  #   tld_zone_name: &tld_zone_name "flok-fi-zone"
  #   prd_zone_name: &prd_zone_name "ilm-opa-prd-subzone"

  # gcp:
  #   GOOGLE_APPLICATION_CREDENTIALS: &google_application_credentials ~/.gcp/.str/key-ilm-opa-prd.json
  #   state_bucket: &state_bucket ilm-opa-prd-tf-state
  #   gcp_region: "europe-north1"
  #   gcp_project: "ilm-opa-prd"
  #   gcp_zone: "europe-north1-a"
  #   gcp_sa_email: &gcp_sa_email "ilm-opa-prd@ilm-opa-prd.iam.gserviceaccount.com"

  # steps:

  #   008-gcp-subzones: # ilm-opa-prd
  #     gcp_subzone_domain: *tld_domain
  #     gcp_subzone_name: "ilm-opa-prd-subzone"
  #     fqn_web_app_subdomain: *fqn_web_app_subdomain
  #     fqn_env_subdomain: *fqn_env_subdomain
  #     tld_zone_name: *tld_zone_name
  #     prd_zone_name: *prd_zone_name
  #     gcp_sa_email: *gcp_sa_email
