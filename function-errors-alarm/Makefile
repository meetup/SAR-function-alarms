SAM_BUCKET=sam-artifacts-$(shell aws sts get-caller-identity --query 'Account' --output text)-us-east-1

clean:
	rm -f packaged-sar-template.yaml

install-deps:
	virtualenv --no-site-packages --python=python3 .venv
	.venv/bin/pip install -r requirements.txt

generate-sar-template:
	cat template-input.json | .venv/bin/jinja2 --format json sar-template.yaml.j2 > sar-template.yaml

package-sar: generate-sar-template
	sam package \
		--template-file sar-template.yaml \
		--s3-bucket $(SAM_BUCKET) \
		--output-template-file packaged-sar-template.yaml

publish-sar: package-sar
	sam publish \
		--template packaged-sar-template.yaml \
		--region us-east-1 \
		--semantic-version 1.0.0
