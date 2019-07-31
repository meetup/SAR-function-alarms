# lambda-alarms

This application adds succinctly defined CloudWatch alarms to your AWS lambda applications.

Monitoring error rates of our lambdas (`# Errors / # Invocations`) is an effective way
to determine if something is broken. Monitoring error rates works well for both lambdas
that run frequently or infrequently. As long as our evaluation period is large or small
enough, we can gain insight into when our lambdas are failing more than they should be.

A first pass at monitoring error rates might involve creating an alarm that calculates
`AWS/Lambda::Errors` / `AWS/Lambda::Invocations`. Though this can work, this calculation
only captures errors that directly failed the lambda. If an error were instead logged via
structured logging by mistake, we wouldn't know it was happening by default.

A better approach then is to _also_ included the number of logged errors in our error rate:
```
(AWS/Lambda::Errors + LoggedErrors) / AWS/Lambda::Invocations
```

Defining an alarm in CloudFormation that monitors error rates this way is quite verbose (over 70 lines)
and quite repetitive. This application aims make error rate alarm creation succinct
and flexible. The Quick Start below provides a simple example.

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

  AlarmsApp:
    Type: AWS::Serverless::Application
    Properties:
      Location:
        ApplicationId: arn:aws:serverlessrepo:us-east-1:501935917622:applications/lambda-alarms
        SemanticVersion: 1.0.25
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

The alarms app can create an SNS topic for errors for you. You can then reference
the created topic's ARN in your template, for instance if you want to add a
subscription to that topic. In the example below, we post the alarm status to
a pager duty endpoint for our service.

```
  AlarmsApp:
    Type: AWS::Serverless::Application
    Properties:
      Location:
        ApplicationId: arn:aws:serverlessrepo:us-east-1:501935917622:applications/lambda-alarms
        SemanticVersion: 1.0.25
      Parameters:
        FunctionName0: !Ref MyFirstLambda
        FunctionName1: !Ref MySecondLambda
        # Creates a unique topic for errors. AlarmsApp will have ErrorsTopicArn in its outputs.
        ErrorTopicName: !Sub ${AWS::StackName}-errors

  # We can create an optional subscriptions to the SNS topic created by AlarmsApp
  PagerDutySubscription:
    Type: AWS::SNS::Subscription
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
| LogGroupName<N> | No | Specify a log group name for the `Nth` lambda, if that lambda has an  **externally created** log group. If your application is new, there's not need to define this property. |
| Stage | No | The stage associated with the parent stack. This is useful if you deploy more than one stage of your stack. (default: Prod) |
| ErrorsTopicArn | No | An ARN of an existing SNS topic suitable for receiving error and ok actions. |
| ErrorsTopicName | No | A name we will use to create an SNS topic to which error and ok actions are published. The topic should be unique for your account. |
| ErrorThreshold | No | The percentage of errors per EvaluationPeriod minutes before the alarm is triggered (default: 3) |
| TreatMissingData | No | Specifies how the alarm treats missing data: notBreaching (default), breaching, ignore, missing |
| EvaluationPeriods | No | The number of minutes over which data is compared to the specified threshold (default: 1). |

## Supported Outputs

| Parameter | Description |
| --------- | ----------- |
| ErrorsTopicArn | The ARN associated with the SNS topic created by the app (if an `ErrorsTopicName` was used) |