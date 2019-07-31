# Developing

We use jinja2 to pre-process the application template associated with the application.
This allows us to support multiple lambdas in a way that's compatible with SAR.

NOTE: We previously tried to support multiple lambdas using CloudFormation transformations.
SAR applications currently only allow the AWS serverless transform; additional transformations
are rejected by `sam publish`.

## Installing

```bash
shell$ make install-deps
```

## Deploying

To deploy a new version, increment the `semantic-version` in the Makefile and
then run:

```
shell$ AWS_PROFILE=developer_platform_tools-engineer make publish-sar
```