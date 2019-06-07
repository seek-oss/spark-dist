# Spark dist

The purpose of this Spark distribution is to allow accessing S3 with AWS SAML authentication.

S3 support is provided by S3A from [hadoop-aws](https://hadoop.apache.org/docs/r3.1.0/hadoop-aws/tools/hadoop-aws/index.html).
To read from S3 using S3A, use the URI prefix `s3a`, eg: ```spark.read.parquet("s3a://big-bucket/big-data/")```

## Install

To install the virtualenv containing pyspark with s3a jars:
```bash
make install
```

## Using temporary credentials
 
Start spark with the `ProfileCredentialsProvider`, eg:
```bash
make run pyspark
```
or
```bash
make run spark-shell
```
You can this use s3a, eg:
```python
s = spark.read.parquet("s3a://...")
```

## Publish

TODO

