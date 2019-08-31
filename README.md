# 🚨 SAR Function Alarms

Serverless Application Repository (SAR) applications that simplify common lambda alarm definitions in SAM applications. All alarms can use a pre-defined SNS topic or create a topic to be used by its alarms.

| Alarm | Description |
| ----- | ----------- |
| [function-errors](./function-errors-alarm/README.md) | Triggers when the error rate of a lambda is above a specified rate |
| [function-throttles](./function-throttles-alarm/README.md) | Triggers when the number of throttles of a lambda is greater or equal to a certain amount. |

## Examples

The [examples](./examples) directory contains working example applications that use each of the SAR Function Alarms applications. To deploy any of these samples, do the following:

```bash
shell$ cd examples/<example>
shell$ make deploy-app
```

AWS SAM requires a bucket to deploy your SAM applications. The examples expect that you have a bucket under your account in the following format: `sam-artifacts-[accountId]-[region]`. You can change the deployment bucket, by overriding it on the command line:

```bash
shell$ SAM_BUCKET=<your bucket> make deploy-app
```

## 👩‍💻👨‍💻 Development

These applications are built using AWS SAM. For more details on developing these applications, visit this [README](./DEVELOPING.md)

Meetup, Inc.
