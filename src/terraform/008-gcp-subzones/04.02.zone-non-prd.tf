# run in the following order:
# all -> gandhi manual-set -> prd -> dev -> tst
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

# Creating GCP DNS zone for non-production ${var.fqn_env_subdomain}
# Creating GCP DNS zone for non-production ${var.fqn_env_subdomain}


# Non-production DNS subzone creation (works for both dev and tst environments)
resource "google_dns_managed_zone" "application_subzone_non_prod" {
  count       = var.env != "prd" ? 1 : 0
  name        = var.gcp_subzone_name
  dns_name    = "${var.fqn_env_subdomain}."  # e.g., dev.mmp.flok.fi or tst.mmp.flok.fi
  description = "Subzone for ${var.env}.${var.fqn_web_app_subdomain}"  # e.g., dev.mmp.flok.fi
  provider    = google
}

data "google_dns_managed_zone" "google_dns_managed_zone_prd" {
  count      = var.env != "prd" ? 1 : 0
  provider   = google.prd
  name       = var.prd_zone_name
  depends_on = [ google_dns_managed_zone.application_subzone_non_prod ]
}

output "prd_name_servers" {
  value = data.google_dns_managed_zone.google_dns_managed_zone_prd[0].name_servers
}


# DNS delegation from non-production (dev/tst) to the production zone
resource "google_dns_record_set" "delegate_non_prd_to_prd_zone" {
  count        = var.env != "prd" ? 1 : 0
  provider     = google.prd
  name         = "${var.fqn_env_subdomain}."  # e.g., dev.mmp.flok.fi or tst.mmp.flok.fi
  type         = "NS"
  ttl          = 21600
  managed_zone = var.prd_zone_name
  rrdatas      = google_dns_managed_zone.application_subzone_non_prod[0].name_servers  # Use the name servers of the prod zone
  depends_on   = [google_dns_managed_zone.application_subzone_non_prod]
}


# # STOP ::: Delegating non-production subzone to the production zone

# # START ::: email configuration
# resource "google_dns_record_set" "spf_record_non_prd" {
#   count        = var.env != "prd" ? 1 : 0
#   name         = "${var.fqn_env_subdomain}."
#   type         = "TXT"
#   ttl          = 300  # Time-to-live value
#   managed_zone = "${var.org}-${var.app}-${var.env}"
#   rrdatas      = ["v=spf1 include:_spf.google.com ~all"]

#   depends_on   = [google_dns_managed_zone.application_subzone_non_prod]
# }


# STOP  ::: email configuration



  # dns:
  #   domain: *domain # flok.fi
  #   wpb_fqdn: &wpb_fqdn str.mpp.dev.flok.fi
  #   tld_domain: &tld_domain flok.fi
  #   env_subdomain: &env_subdomain str.mpp.dev
  #   fqn_env_subdomain: &fqn_env_subdomain dev.mmp.flok.fi
  #   fqn_web_app_subdomain: &fqn_web_app_subdomain "mmp.flok.fi"
  #   tld_zone_name: &tld_zone_name "flok-fi-zone"
  #   prd_zone_name: &prd_zone_name "ilm-opa-prd-subzone"


  # steps:

  #   008-gcp-subzones: # ilm-opa-dev
  #     gcp_subzone_domain: *tld_domain
  #     gcp_subzone_name: "ilm-opa-dev-subzone"
  #     fqn_web_app_subdomain: *fqn_web_app_subdomain
  #     fqn_env_subdomain: *fqn_env_subdomain
  #     prd_zone_name: *prd_zone_name
  #     tld_zone_name: *tld_zone_name