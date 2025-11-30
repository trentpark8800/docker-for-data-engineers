from pyspark.sql import SparkSession

logFile = "/opt/spark/work-dir/docker-for-data-engineers/README.md"  # Should be some file on your system
spark = SparkSession.builder.appName("SimpleApp").getOrCreate()
spark.sparkContext.setLogLevel("WARN")
logData = spark.read.text(logFile).cache()

numAs = logData.filter(logData.value.contains('a')).count()
numBs = logData.filter(logData.value.contains('d')).count()

print("--------------------------------")
print("Lines with a: %i, lines with d: %i" % (numAs, numBs))

spark.stop()
print("--------------------------------")