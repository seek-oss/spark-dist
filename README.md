# Spark with S3

This distribution of Spark bundles [hadoop-aws 3.1](https://hadoop.apache.org/docs/r3.1.0/hadoop-aws/tools/hadoop-aws/index.html).
This provides S3 access with the ability to use any AWSCredentialsProvider, STS temporary credentials 
and other newer features.

## Rationale

Common practice is to use hadoop-aws 2.7.3 as follows: 

```
pyspark --packages "org.apache.hadoop:hadoop-aws:2.7.3" --driver-java-options "-Dspark.hadoop.fs.s3.impl=org.apache.hadoop.fs.s3a.S3AFileSystem"
```
However later versions of hadoop-aws cannot be used this way without errors. 
This distribution uses gradle to resolve a correct set of newer hadoop-aws dependencies that work with Spark.  

Later versions of hadoop-aws contain the following new features:
* [2.8 release line](http://hadoop.apache.org/docs/r2.8.0/index.html) contains S3A improvements to 
support any AWSCredentialsProvider
* [2.9 release line](http://hadoop.apache.org/docs/r2.9.0/index.html) contains 
[S3Guard](http://hadoop.apache.org/docs/r2.9.0/hadoop-aws/tools/hadoop-aws/s3guard.html) which provides 
consistency and metadata caching for S3A via a backing DynamoDB metadata store.
* [3.1 release line](http://hadoop.apache.org/docs/r3.1.0/index.html) incorporates HADOOP-13786 which 
contains optimised job committers including the Netflix staging committers (Directory and Partitioned) 
and the Magic committers. See [committers](https://github.com/apache/hadoop/blob/branch-3.1/hadoop-tools/hadoop-aws/src/site/markdown/tools/hadoop-aws/committers.md) and [committer architecture](https://github.com/apache/hadoop/blob/trunk/hadoop-tools/hadoop-aws/src/site/markdown/tools/hadoop-aws/committer_architecture.md).
S3A metrics can now be monitored through Hadoop's metrics2 framework, see [Metrics](https://hadoop.apache.org/docs/r3.1.0/hadoop-aws/tools/hadoop-aws/index.html#Metrics). The is configured via `hadoop-metrics2.properties`.


## Install

To install the virtualenv containing pyspark with s3a jars:
```bash
make install
```

## Usage
 
Start pyspark using profile credentials (including any STS temporary credentials):
```bash
make pyspark
```
or
```bash
make spark-shell
```
You can then use s3, eg:
```python
s = spark.read.parquet("s3://...")
```

## Publish

TODO

