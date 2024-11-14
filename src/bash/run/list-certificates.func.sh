#!/bin/bash
do_list_certificates() {

  # todo:create generic function
  aws acm list-certificates | jq -r '.CertificateSummaryList[]|select(.DomainName|contains("*.spectralengines.com"))'

}
