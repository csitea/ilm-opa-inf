#!/bin/bash

do_list_load_balancers_listeners_and_targets() {

  do_require_var ORG "${ORG:-}"
  do_require_var ENV "${ENV:-}"
  do_require_var APP "${APP:-}"
  export AWS_PROFILE=$ORG'_'$APP'_'$ENV'_rcr'

  #Retrieve all load balancer ARNs
  #lb_arns=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].LoadBalancerArn' --output json)
  lb_arns=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].LoadBalancerArn' --output text)
  #aws elbv2 describe-load-balancers --query 'LoadBalancers[*].LoadBalancerArn' --output json | jq -r '.[]'|perl -ne 's|\s|\\n|g;print'

  #lb_arn_array=($(perl -e 'my $string = $ARGV[0]; my @tokens = split("\s+", $string); print join("\n", @tokens);' "$lb_arns"))

  # Split the load balancer ARNs by whitespace delimiter
  IFS=' ' read -ra lb_arns <<<"$lb_arns"

  #Iterate over each load balancer ARN
  #while IFS=' ' read -r lb_arn ; do
  for lb_arn in "${lb_arns[@]}"; do

    echo "Load Balancer ARN: $lb_arn"
    lb_arn=$(echo $lb_arn | xargs)
    # # Retrieve all listeners for the current load balancer
    # listeners=$(aws elbv2 describe-listeners --load-balancer-arn "$lb_arn" --query 'Listeners[*].ListenerArn' --output text)

    # # Check if listeners are empty
    # if [[ -z "$listeners" ]]; then
    #     echo "  No listeners found."
    # else
    #     # Split the listener ARNs by whitespace delimiter
    #     IFS=' ' read -ra listener_arn_array <<< "$listeners"

    #     # Iterate over each listener
    #     for listener_arn in "${listener_arn_array[@]}"; do
    #         echo "  Listener ARN: $listener_arn"

    #         # Retrieve all targets for the current listener
    #         targets=$(aws elbv2 describe-target-groups --listener-arn "$listener_arn" --query 'TargetGroups[*].TargetGroupArn' --output text)

    #         # Check if targets are empty
    #         if [[ -z "$targets" ]]; then
    #             echo "    No targets found."
    #         else
    #             # Split the target ARNs by whitespace delimiter
    #             IFS=' ' read -ra target_arn_array <<< "$targets"

    #             # Iterate over each target
    #             for target_arn in "${target_arn_array[@]}"; do
    #                 echo "    Target ARN: $target_arn"
    #             done
    #         fi
    #     done
    # fi

  done
  #< <(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].LoadBalancerArn' --output text|perl -ne 's|\s+|\n\r|g;print')
}
