#curl -s -X GET -H "Authorization: token $TQA_ALL_ALL_ZERO_TIER_TOKEN" \
#  https://api.zerotier.com/api/v1/network | jq -r '.[] | {id: .id, name: .config.name}'

## a09acf023317ba3a - the test network
#curl -s -X GET -H "Authorization: token $TQA_ALL_ALL_ZERO_TIER_TOKEN" \
#  https://api.zerotier.com/api/v1/network/a09acf023317ba3a | jq -r '.'
#
## c7c8172af1ad06e - the production network
#curl -s -X GET -H "Authorization: token $TQA_ALL_ALL_ZERO_TIER_TOKEN" \
#  https://api.zerotier.com/api/v1/network/c7c8172af1ad06e5 | jq -r '.'


# a09acf023317ba3a - the test network members
curl -s -X GET -H "Authorization: token $TQA_ALL_ALL_ZERO_TIER_TOKEN" \
  https://api.zerotier.com/api/v1/network/a09acf023317ba3a/member | jq -r '.'

# c7c8172af1ad06e - the production network members
#curl -s -X GET -H "Authorization: token $TQA_ALL_ALL_ZERO_TIER_TOKEN" \
#j  https://api.zerotier.com/api/v1/network/c7c8172af1ad06e5/member | jq -r '.'
