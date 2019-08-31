# 🚨 SAR Function Alarms

Serverless Application Repository (SAR) applications that simplify common lambda alarm definitions in SAM applications. All alarms can use a pre-defined SNS topic or create a topic to be used by its alarms.

| Alarm | Description |
| ----- | ----------- |
| [function-errors](./function-errors-alarm/README.md) | Triggers when the error rate of a lambda is above a specified rate |
| [function-throttles](./function-throttles-alarm/README.md) | Triggers when the number of throttles of a lambda is greater or equal to a certain amount. |

## 👩‍💻👨‍💻 Development

These applications are built using AWS SAM. For more details on developing these applications, visit this [README](./DEVELOPING.md)

Meetup, Inc.
