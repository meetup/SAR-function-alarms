# function-errors-alarms ❌🚨

A serverless application that adds alarms based on lambda error rates to your SAM applications.

## Quick Start

To install this application for your own lambdas, add the following to your SAM template or CloudFormation template:

```yaml
  MyFirstLambda:
    Type: AWS::Serverless::Function
    Properties:
      FunctionName: MyFirstLambda
    # ...

  MySecondLambda:
    Type: AWS::Serverless::Function
    Properties:
      FunctionName: MySecondLambda
    # ...

  FunctionErrorAlarms:
    Type: AWS::Serverless::Application
    Properties:
      Location:
        ApplicationId: arn:aws:serverlessrepo:us-east-1:022247682424:applications/function-errors-alarm
        SemanticVersion: 1.0.0
      Parameters:
        FunctionName0: !Ref MyFirstLambda
        FunctionName1: !Ref MySecondLambda
        # ... up to FunctionName4
```

The snippet above will create two alarms:
- "MyFirstLambda has a high error rate"
- "MySecondLambda has a high error rate"

Whenever the failure rate for either lambda above the threshold of 3% (the default), their alarm
will trigger.

## Larger Example

The function-errors-alarm application has some flexibility built-in.
- It can use an existing SNS topic for your alarms or create one for you.
- You can control elements about the generated alarms such as threshold and evaluation periods.


```yaml
  FunctionErrorAlarms:
    Type: AWS::Serverless::Application
    Properties:
      Location:
        ApplicationId: arn:aws:serverlessrepo:us-east-1:022247682424:applications/function-errors-alarm
        SemanticVersion: 1.0.0
      Parameters:
        FunctionName0: !Ref MyFirstLambda
        FunctionName1: !Ref MySecondLambda
        # Creates a unique topic for errors. FunctionErrorAlarms will have ErrorsTopicArn in its outputs.
        ErrorTopicName: !Sub ${AWS::StackName}-errors

  # We can create an optional subscriptions to the SNS topic created by FunctionErrorAlarms
  PagerDutySubscription:
    Type: AWS::SNS::Subscription
    DependsOn: FunctionErrorAlarms
    Properties:
      Protocol: https
      Endpoint: https://events.pagerduty.com/integration/${pagerDutyIntegrationKey}/enqueue
      TopicArn: !GetAtt AlarmsApp.Outputs.ErrorsTopicArn
```

## Supported Parameters

We support adding alarms for up to five lambdas via the `FunctionName0`, `FunctionName1`, ..., `FunctionName4` parameters.

NOTE: We can't support any more than 5 at this time, due to a limitation in the number of CloudFormation
template parameters.

| Parameter | Required? | Description |
| --------- | --------- | ----------- |
| FunctionName<N> | Yes | The name of the lambda that will have alarms attached. You'll usually want `!Ref <YourLambda>` |
| ErrorsTopicArn | No | An ARN of an existing SNS topic suitable for receiving error and ok actions. |
| ErrorsTopicName | No | A name we will use to create an SNS topic to which error and ok actions are published. The topic should be unique for your account. |
| ErrorThreshold | No | The percentage of errors per EvaluationPeriod minutes before the alarm is triggered (default: 3) |
| TreatMissingData | No | Specifies how the alarm treats missing data: notBreaching (default), breaching, ignore, missing |
| EvaluationPeriods | No | The number of minutes over which data is compared to the specified threshold (default: 1). |

## Supported Outputs

| Parameter | Description |
| --------- | ----------- |
| ErrorsTopicArn | The ARN associated with the SNS topic created by the app (if an `ErrorsTopicName` was used) |