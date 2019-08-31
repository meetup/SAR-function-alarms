# This assumes you've created an S3 bucket on your account in the format of `sam-artifacts-[accountId]-[region]
REGION=us-east-1
SAM_BUCKET=sam-artifacts-$(shell aws sts get-caller-identity --query 'Account' --output text)-$(REGION)

template_inputs = $(wildcard function-errors-alarm/*.yaml.j2) \
	$(wildcard function-throttles-alarm/*.yaml.j2)
templates = $(template_inputs:.yaml.j2=.yaml)
applications = $(templates:.yaml=.packaged.yaml)

%.yaml: %.yaml.j2
	cat template-input.json | .venv/bin/jinja2 --format json $< > $@

%.packaged.yaml: %.yaml
	@echo "*** publishing $(<)"
	sam package \
		--template-file $< \
		--s3-bucket $(SAM_BUCKET) \
		--output-template-file $@
	sam publish \
		--template $@ \
		--region $(REGION)

deploy-applications: $(applications)
	@echo "Finished deploying SAR applications."

.PHONY: install-deps
install-deps:
	virtualenv --no-site-packages --python=python3 .venv
	.venv/bin/pip install -r requirements.txt

.PHONY: clean
clean:
	rm -f $(templates)



