#!/usr/bin/env perl
use strict ; use warnings ;
#  aws organizations list-accounts | jq -r '[.Accounts[]|{"id":.Id,"name":.Name}]|map({id,name}) |
#  (first | keys_unsorted) as $keys | map([to_entries[] | .value]) as $rows | $keys,$rows[] |
#  @csv'|column -t -s","|sort -k 2|grep 'dev\|stg\|prd'

my $aws_accounts_ids = {
    "051524627353" => "nvs-dev-nba-idy"
  , "444967485231" => "nvs-dev-nba-log"
  , "899230519635" => "nvs-dev-nba-rcr"
  , "429071056537" => "nvs-prd-nba-idy"
  , "402786979574" => "nvs-prd-nba-log"
  , "179722557689" => "nvs-prd-nba-rcr"
  , "271430792140" => "nvs-stg-nba-idy"
  , "049148279038" => "nvs-stg-nba-log"
  , "626177158758" => "nvs-stg-nba-rcr"
  , "531001109862" => "spe-dev-scs-idy"
  , "829648558864" => "spe-dev-scs-log"
  , "413511547732" => "spe-dev-scs-rcr"
  , "505297678394" => "spe-prd-scs-idy"
  , "799433195190" => "spe-prd-scs-log"
  , "677479485307" => "spe-prd-scs-rcr"
  , "560553506129" => "spe-stg-scs-idy"
  , "229372113024" => "spe-stg-scs-log"
  , "802817439665" => "spe-stg-scs-rcr"
};

# generate this list by
# aws organizations list-accounts | jq -r '[.Accounts[]|{"id":.Id,"name":.Name}]|map({id,name}) |
# (first | keys_unsorted) as $keys | map([to_entries[] | .value]) as $rows | $keys,$rows[] |
# @csv'|column -t -s","|sort -k 2|grep 'dev\|stg\|prd' | perl -ne '@_ = split(  );print ("$_[1] =>
# $_[1] \n,")'
#
my $aws_accounts_titles = {
    "051524627353" => "nvs-dev-nba-idy"
  , "444967485231" => "nvs-dev-nba-log"
  , "899230519635" => "nvs-dev-nba-rcr"
  , "429071056537" => "nvs-prd-nba-idy"
  , "402786979574" => "nvs-prd-nba-log"
  , "179722557689" => "nvs-prd-nba-rcr"
  , "271430792140" => "nvs-stg-nba-idy"
  , "049148279038" => "nvs-stg-nba-log"
  , "626177158758" => "nvs-stg-nba-rcr"
  , "531001109862" => "spe-dev-scs-idy"
  , "829648558864" => "spe-dev-scs-log"
  , "413511547732" => "spe-dev-scs-rcr"
  , "505297678394" => "spe-prd-scs-idy"
  , "799433195190" => "spe-prd-scs-log"
  , "677479485307" => "spe-prd-scs-rcr"
  , "560553506129" => "spe-stg-scs-idy"
  , "229372113024" => "spe-stg-scs-log"
  , "802817439665" => "spe-stg-scs-rcr"
};

my $iam_group_roles = {
	 "dev-RolAccAdm"   => "dev-RolAccAdm"
	,"stg-RolAccAdm"   => "stg-RolAccAdm"
	,"prd-RolAccAdm"   => "prd-RolAccAdm"
};

my $html = '<html><title> SPE AWS SWITCH ROLES LINKS LIST </title>' ;
my $table = '<table><tr><th>aws-acc-id</th></tr>' ;
for my $iam_group( sort keys( %$iam_group_roles)) {
  for my $acc_key ( sort keys( %$aws_accounts_ids )) {
    my $trow = '<tr><td>' ;
    print "acc-id : $acc_key -> acc-id: $aws_accounts_ids->{$acc_key} ,";
    print "acc-id : $acc_key -> acc-title: $aws_accounts_titles->{$acc_key} \n";
    my $iam_role = $iam_group_roles->{$iam_group} ;
    my $acc_title = $aws_accounts_titles->{$acc_key};
    my $title = $aws_accounts_ids->{$acc_key} ;
    my $acc_id = $acc_key;
    my $lnk = "https://signin.aws.amazon.com/switchrole?account=$acc_id&roleName=$iam_role&displayName=$title";
    #<A HREF="https://signin.aws.amazon.com/switchrole?
    # account=386351740899&roleName=OrganizationAccountAdminAccess&displayName=common_ADMIN">common_ADMIN</A>

    $trow .= '<a href="' . $lnk . '" title="' . $title . '" >' . $title . '</a>' ;
    $trow .= '</td></tr>' ;
    $trow .= '</tr>' ;

    # todo: verify those combinations
    my $env = substr($aws_accounts_titles->{$acc_key} , 4,3);
    print "env: $env \n" ;
    print "env: " . substr($iam_role,0,3) . "\n";
    if ($env eq substr($iam_role,0,3)) {
      $table .= $trow ;
    }
    #if ( substr($iam_role, -3) eq substr($acc_key,0,3) );
  }
}
$table .= '</table>' ;

my $fle = 'aws-roles-list-switch.html';
open(my $fh, '>', $fle) or die "Could not open file '$fle' $!";
print $fh $table ;
close $fh;
