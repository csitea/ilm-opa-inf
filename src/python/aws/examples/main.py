import boto3
import os
import json

#from sns_basics import SnsWrapper

def main():
    ORG = os.environ["ORG"]
    APP = os.environ["APP"]
    ENV = os.environ["ENV"]
    AWS_PROFILE = f"{ORG}_{APP}_{ENV}_rcr"
    AWS_REGION  = "eu-west-1"

    os.environ["AWS_SHARED_CREDENTIALS_FILE"] = f"~/.aws/.{ORG}/credentials"

    session = boto3.Session(profile_name=AWS_PROFILE, region_name=AWS_REGION)
    sns = session.client('sns')

    # to list topics, if you need to cherry pick them
    #response = sns.list_topics()
    # Then your logic to fetch the topic ARN or visualize it
    #print(json.dumps(response, indent=4))

    TOPIC_ARN = f'arn:aws:sns:eu-west-1:768326299502:{ORG}_{APP}_{ENV}_test_topics'
    SUBSCRIPTION_ARN = f'arn:aws:sns:eu-west-1:768326299502:{ORG}_{APP}_{ENV}_test_topics:d78e3516-12c1-4591-83c3-4bd7486b9c33'

    # https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sns.html#SNS.Client.publish
    # Set MessageStructure to json if you want to send a different message for each protocol.
    # For example, using one publish action, you can send a short message to your SMS subscribers and a longer
    # message to your email subscribers. If you set MessageStructure to json , the value of the Message parameter must:
    #
    # be a syntactically valid JSON object; and
    # contain at least a top-level JSON key of "default" with a value that is a string.
    # You can define other top-level keys that define the message you want to send to a specific transport protocol (e.g., "http").

    response = sns.publish(
        TopicArn=TOPIC_ARN,
        Message='Test message',
        Subject='Some test subject',
        MessageStructure='string',
        MessageAttributes={
            'string': {
                'DataType': 'String',
                'StringValue': 'Test message',
            }
        }
    )

    print(json.dumps(response, indent=4))

if __name__ == '__main__':
    main()
