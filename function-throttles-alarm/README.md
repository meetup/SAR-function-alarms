# function-throttles-alarms 🛑🚨

A serverless application that adds alarms based on lambda throttles to your SAM applications.

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
        ApplicationId: arn:aws:serverlessrepo:us-east-1:623245082754:applications/function-throttles-alarm
        SemanticVersion: 1.0.0
      Parameters:
        FunctionName0: !Ref MyFirstLambda
        FunctionName1: !Ref MySecondLambda
        # ... up to FunctionName4
```

The snippet above will create two alarms:
- "MyFirstLambda was throttled >= 1 time(s) in the last 1 minute(s)"
- "MySecondLambda was throttled >= 1 time(s) in the last 1 minute(s)"

Whenever the number of throttles for either lambda at or above the threshold of 1 (the default), their associated alarm will trigger.

## Larger Example

The function-throttles-alarm application has some flexibility built-in:
- It can use an existing SNS topic for your alarms or create one for you.
- You can control elements about the generated alarms such as threshold and evaluation periods.

```yaml
  FunctionThrottleAlarms:
    Type: AWS::Serverless::Application
    Properties:
      Location:
        ApplicationId: arn:aws:serverlessrepo:us-east-1:623245082754:applications/function-throttles-alarm
        SemanticVersion: 1.0.0
      Parameters:
        FunctionName0: !Ref MyFirstLambda
        FunctionName1: !Ref MySecondLambda
        # Creates a unique topic for errors. FunctionThrottleAlarms will have ErrorsTopicArn in its outputs.
        ErrorsTopicName: !Sub ${AWS::StackName}-errors

  # We can create an optional subscriptions to the SNS topic created by FunctionThrottleAlarms
  PagerDutySubscription:
    Type: AWS::SNS::Subscription
    DependsOn: FunctionErrorAlarms
    Properties:
      Protocol: https
      Endpoint: https://events.pagerduty.com/integration/${pagerDutyIntegrationKey}/enqueue
      TopicArn: !GetAtt AlarmsApp.Outputs.ErrorsTopicArn
```

## Supported Parameters

We support adding alarms for up to eight lambdas via the `FunctionName0`, `FunctionName1`, ..., `FunctionName4` parameters.

NOTE: We can't support any more than 8 at this time, due to a limitation in the number of CloudFormation
template parameters.

| Parameter | Required? | Description |
| --------- | --------- | ----------- |
| FunctionName<N> | Yes | The name of the lambda that will have alarms attached. You'll usually want `!Ref <YourLambda>` |
| ErrorsTopicArn | No | An ARN of an existing SNS topic suitable for receiving error and ok actions. |
| ErrorsTopicName | No | A name we will use to create an SNS topic to which error and ok actions are published. The topic should be unique for your account. |
| ErrorThreshold | No | The number of throttles per EvaluationPeriod minutes before the alarm is triggered (default: 1) |
| TreatMissingData | No | Specifies how the alarm treats missing data: notBreaching (default), breaching, ignore, missing |
| EvaluationPeriods | No | The number of minutes over which data is compared to the specified threshold (default: 1). |

## Supported Outputs

| Parameter | Description |
| --------- | ----------- |
| ErrorsTopicArn | The ARN associated with the SNS topic created by the app (if an `ErrorsTopicName` was used) |