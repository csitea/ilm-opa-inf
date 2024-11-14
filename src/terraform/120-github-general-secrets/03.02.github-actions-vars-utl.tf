# ORG, APP and PROJ in github actions vars


# START ::: ORG, APP and PROJ in GitHub Actions variables for the inf repository
resource "github_actions_variable" "org_as_variable_utl" {
  count           = var.env == "dev" ? 1 : 0
  repository      = "${var.org}-${var.app}-utl"
  variable_name   = "ORG"
  value           = "${var.org}"
}

resource "github_actions_variable" "app_as_variable_utl" {
  count           = var.env == "dev" ? 1 : 0
  repository      = "${var.org}-${var.app}-utl"
  variable_name   = "APP"
  value           = "${var.app}"
}

resource "github_actions_variable" "proj_as_variable_utl" {
  count           = var.env == "dev" ? 1 : 0
  repository      = "${var.org}-${var.app}-utl"
  variable_name   = "PROJ"
  value           = "${var.org}-${var.app}-utl"
}
# STOP  ::: ORG, APP and PROJ in GitHub Actions variables for the inf repository
