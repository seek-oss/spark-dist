MAKEFLAGS += --warn-undefined-variables
.DEFAULT_GOAL := help

## display this help message
help:
	@awk '/^##.*$$/,/^[~\/\.a-zA-Z_-]+:/' $(MAKEFILE_LIST) | awk '!(NR%2){print $$0p}{p=$$0}' | awk 'BEGIN {FS = ":.*?##"}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | sort

## build and install virtual env with s3a jars
install:
	rm -rf venv; \
	virtualenv venv; \
	source ./venv/bin/activate; \
	pip install -r requirements.txt; \
	./gradlew jars; \
	rm -rf venv/lib/python3.7/site-packages/pyspark/jars; \
	mv jars venv/lib/python3.7/site-packages/pyspark/

## pyspark
pyspark:
	source ./venv/bin/activate; \
	pyspark --driver-java-options "-Dspark.hadoop.fs.s3a.aws.credentials.provider=com.amazonaws.auth.profile.ProfileCredentialsProvider"

## spark-shell
spark-shell:
	source ./venv/bin/activate; \
	spark-shell --driver-java-options "-Dspark.hadoop.fs.s3a.aws.credentials.provider=com.amazonaws.auth.profile.ProfileCredentialsProvider"
