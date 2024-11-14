#!/bin/bash
## Postgre update v10.17 -> v11.11
do_upgrade_postgres_to_v11() {
  # Setup environment
  do_set_env_vars_for_aws_account_master $ENV_TYPE

  export DB_GROUP_NAME="rds-pg-v111"
  export DB_GROUP_FAMILY="postgres11"
  export DB_DESCRIPTION="The postgres postgres 11 version db parameter group"
  export DB_INSTANCE_IDENTIFIER=postgres-prod
  export DB_ENGINE_VERSION=11.11

  # db backup on demand
  # do_create_all_db_snapshots

  # create new db group
  aws rds describe-db-parameter-groups --region $AWS_REGION --profile $AWS_PROFILE | jq '.'
  aws rds create-db-parameter-group --region $AWS_REGION --profile $AWS_PROFILE \
    --db-parameter-group-name $DB_GROUP_NAME --db-parameter-group-family $DB_GROUP_FAMILY \
    --description "$DB_DESCRIPTION"
  aws rds describe-db-parameter-groups --region $AWS_REGION --profile $AWS_PROFILE | jq '.'

  # upgrade the rds db
  aws rds describe-db-instances --region $AWS_REGION --profile $AWS_PROFILE | jq '.'
  aws rds modify-db-instance --region $AWS_REGION --profile $AWS_PROFILE \
    --db-instance-identifier $DB_INSTANCE_IDENTIFIER --engine-version $DB_ENGINE_VERSION \
    --db-parameter-group-name $DB_GROUP_NAME --allow-major-version-upgrade --apply-immediately

  # Steps 4 to 7 will be made after last version upgrade

}
