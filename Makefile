MAKEFLAGS += --warn-undefined-variables
.DEFAULT_GOAL := help

## display this help message
help:
	@awk '/^##.*$$/,/^[~\/\.a-zA-Z_-]+:/' $(MAKEFILE_LIST) | awk '!(NR%2){print $$0p}{p=$$0}' | awk 'BEGIN {FS = ":.*?##"}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | sort

venv = ~/.virtualenvs/spark-dist
python := $(venv)/bin/python

$(venv): requirements.txt
	$(if $(value VIRTUAL_ENV),$(error Cannot create a virtualenv when running in a virtualenv. Please deactivate the current virtual env $(VIRTUAL_ENV)),)
	python3 -m venv --clear $(venv) && $(venv)/bin/pip install -r requirements.txt

## set up python virtual env and install requirements
venv: $(venv)

## build and install virtual env with s3a jars
install: $(venv)
	./gradlew jars
	rm -rf $(venv)/lib/*/site-packages/pyspark/jars
	mv jars $(venv)/lib/*/site-packages/pyspark/

## pyspark
pyspark:
	source $(venv)/bin/activate && \
	pyspark --driver-java-options "-Dspark.hadoop.fs.s3a.aws.credentials.provider=com.amazonaws.auth.profile.ProfileCredentialsProvider"

## spark-shell
spark-shell:
	source $(venv)/bin/activate && \
	spark-shell --driver-java-options "-Dspark.hadoop.fs.s3a.aws.credentials.provider=com.amazonaws.auth.profile.ProfileCredentialsProvider"
