SAM_BUCKET=sam-artifacts-$(shell aws sts get-caller-identity --query 'Account' --output text)-us-east-1

clean:
	rm -f packaged-sam-template.yaml

package-app:
	sam package \
		--template-file sam-template.yaml \
		--s3-bucket $(SAM_BUCKET) \
		--output-template-file packaged-sam-template.yaml

deploy-app: package-app
	aws cloudformation deploy \
		--template packaged-sam-template.yaml \
		--stack-name sample-throttles-alarm-app \
		--capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND
