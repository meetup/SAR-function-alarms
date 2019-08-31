# Developing

## Installing Dependencies

We use jinja2 to pre-process the application template associated with the application.
This allows us to implement more complex applications from simpler templates. To install dependencies:

```bash
shell$ make install-deps
```

## Deploying All Applications

You can deploy all applications to your own AWS account using:

```bash
# Get the previous semantic version
shell$ aws serverlessrepo get-application --application-id arn:aws:serverlessrepo:us-east-1:623245082754:applications/function-throttles-alarm --query 'Version.SemanticVersion'
1.0.0 #<-- the previous version
shell$ TRAVIS_BUILD_NUMBER=<previous version + 1> AWS_PROFILE=<your-sar-aws-account> make deploy-applications
```

## Deploying just one application

Alternatively, you can deploy a single application using the following command:

```bash
shell$ AWS_PROFILE=<your-sar-aws-account> make <my-application-dir>/sar-template.packaged.yaml
```