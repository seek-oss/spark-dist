MAKEFLAGS += --warn-undefined-variables
.DEFAULT_GOAL := help

## display this help message
help:
	@awk '/^##.*$$/,/^[~\/\.a-zA-Z_-]+:/' $(MAKEFILE_LIST) | awk '!(NR%2){print $$0p}{p=$$0}' | awk 'BEGIN {FS = ":.*?##"}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | sort

venv:
	pipenv sync

## build and install virtual env with s3a jars
install: venv
	./gradlew jars
	rm `pipenv --venv`/lib/python3.7/site-packages/pyspark/jars/*
	cp jars/* `pipenv --venv`/lib/python3.7/site-packages/pyspark/jars/

## pyspark
pyspark:
	pipenv run pyspark --driver-java-options "-Dspark.hadoop.fs.s3a.aws.credentials.provider=com.amazonaws.auth.profile.ProfileCredentialsProvider"

## spark-shell
spark-shell:
	pipenv run spark-shell --driver-java-options "-Dspark.hadoop.fs.s3a.aws.credentials.provider=com.amazonaws.auth.profile.ProfileCredentialsProvider"
