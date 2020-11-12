.PHONY: check test format-check format mypy

# Set the GCP project ID:
# export GCP_PROJECT=<project-id>
GCP_REGION = europe-west3
GCP_BUCKET = green-walking-placedata

check: format-check mypy test

test:
	@echo ">>> unit test"
	python -m unittest discover -p '*_test.py'

format-check:
	@echo ">>> black format check"
	black --check --target-version py38 --line-length 132 greenwalking/ *.py

format:
	@echo ">>> black format"
	black --target-version py38 --line-length 132 greenwalking/ *.py

mypy:
	@echo ">>> mypy type check"
	mypy --config-file mypy.ini greenwalking/ *.py

dataflow-run:
	#@echo ">>> Compile and upload a Dataflow template"
	python placedata.py \
		--runner DataflowRunner \
		--project $(GCP_PROJECT) \
		--region $(GCP_REGION) \
		--staging_location gs://$(GCP_BUCKET)/staging \
		--temp_location gs://$(GCP_BUCKET)/temp \
		--setup_file ./setup.py \
		--max_num_workers 5 \

	#--template_location gs://$(GCP_BUCKET)/template/placedata \
	#@echo "Upload the metadata file of the pipeline next to the template"
	#gsutil cp placedata_metadata gs://$(GCP_BUCKET)/templates/
