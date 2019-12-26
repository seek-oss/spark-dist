import io.findify.s3mock.S3Mock
import org.apache.spark.SparkConf
import org.apache.spark.sql.SparkSession
import org.scalatest.{BeforeAndAfterAll, FunSuite, Matchers}

class SparkTest extends FunSuite with BeforeAndAfterAll with Matchers {

  val s3Mock = S3Mock(port = 5000, dir = "src/test/")
  s3Mock.start

  val conf =
    new SparkConf()
      .setMaster("local[*]")
      .setAppName("test")
      .set("spark.ui.enabled", "false")
      .set("spark.driver.host", "localhost")
      // s3 uris will use s3a
      .set("spark.hadoop.fs.s3.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
      // use the mocked s3
      .set("spark.hadoop.fs.s3a.endpoint", "http://127.0.0.1:5000")
      // mock out aws credentials
      .set("spark.hadoop.fs.s3a.aws.credentials.provider", "org.apache.hadoop.fs.s3a.AnonymousAWSCredentialsProvider")

  val spark = SparkSession
    .builder()
    .config(conf)
    .getOrCreate()

  test("read from s3") {
    val df = spark.read.csv("s3://resources/iris.csv")
    assert(df.count == 151)
  }

  override def afterAll() {
    spark.close()
    s3Mock.shutdown
  }

}