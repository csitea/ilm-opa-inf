.PHONY: do-authenticate-aws-mfa ## @-> authenticate MFA with AWS and prints credentials file
do-authenticate-aws-mfa: demand_var-ENV demand_var-ORG demand_var-APP demand_var-AWS_SHARED_CREDENTIALS_FILE demand_var-AWS_PROFILE
	  python3 src/python/aws-credentials/aws-credentials.py mfa --account ${AWS_PROFILE}

.PHONY: aws-get-sess-token ## @-> authenticate MFA with AWS and modify credentials file automagically
aws-get-sess-token: demand_var-ORG demand_var-APP demand_var-ENV
	python3 sub/sess-token-getter/src/python/scripts/aws-utils.py --authenticate

.PHONY: aws-get-roles ## @-> print roles which the user is allowed to assume
aws-get-roles: demand_var-ORG demand_var-APP demand_var-ENV
	python3 sub/sess-token-getter/src/python/scripts/aws-utils.py --get-roles