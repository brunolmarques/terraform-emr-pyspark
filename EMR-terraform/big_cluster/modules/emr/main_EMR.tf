resource "aws_emr_cluster" "emr" {
  name                              = "${var.name}"
  release_label                     = "emr-5.29.0"
  applications                      = ["Hadoop", "Hive", "Spark", "Livy"]
  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true
  service_role                      = "EMR_DefaultRole"
  log_uri                           = "s3://gympass-bi-model-training-data/AWS_logs/EMR"
  ebs_root_volume_size              = "12"

  ec2_attributes {
    key_name                          = "${var.key_name}"
    subnet_id                         = "${var.subnet_id}"
    emr_managed_master_security_group = "${data.aws_security_group.master.id}"
    emr_managed_slave_security_group  = "${data.aws_security_group.slave.id}"
    instance_profile                  = "${var.instance_profile}"
    service_access_security_group     = "${data.aws_security_group.service_access.id}"
  }

  tags = {
    name                   = "${var.name}"
    service                = "spark-cluster"
    terraform              = "true"
    env                    = "bi"
    area                   = "machine-learning"
  }

  bootstrap_action {
      path = "s3://gympass-ml-bootstrap-scripts/scripts/emr_bootstrap.sh"
      name = "DownloadSparkRedis"
      args = ["/usr/lib/spark/jars/"]
      }

  instance_group {
              name                   = "MasterInstanceGroup"
              instance_role          = "MASTER"
              instance_type          = "m5.16xlarge"
              instance_count         = "1"

              ebs_config {
                size                 = "512"
                type                 = "gp2"
                volumes_per_instance = 1
                }
            }
  instance_group {
              name                   = "CoreInstanceGroup"
              instance_role          = "CORE"
              instance_type          = "m5.16xlarge"
              instance_count         = "20"

              ebs_config {
                size                 = "256"
                type                 = "gp2"
                volumes_per_instance = 1
                }
            }

  configurations_json = <<EOF
    [
    {
     "Classification": "yarn-site",
     "Properties": {
       "yarn.nodemanager.vmem-check-enabled": "false",
       "yarn.nodemanager.pmem-check-enabled": "false"
       }
    },
    {
     "Classification": "spark",
     "Properties": {
       "maximizeResourceAllocation": "false"
       }
    },
    {
     "Classification": "mapred-site",
     "Properties": {
       "mapreduce.map.output.compress": "true"
       }
    },
    {
       "Classification": "hadoop-env",
       "Configurations": [{
         "Classification": "export",
         "Configurations": [],
         "Properties": {
           "JAVA_HOME": "/usr/lib/jvm/java-1.8.0"
         }
       }],
       "Properties": {}
     },
     {
       "Classification": "spark-env",
       "Configurations": [{
         "Classification": "export",
         "Properties": {
           "JAVA_HOME": "/usr/lib/jvm/java-1.8.0"
         }
       }],
       "Properties": {}
    },
    {
    "Classification": "spark-defaults",
    "Properties": {
      "spark.pyspark.python": "python3",
      "spark.pyspark.virtualenv.enabled": "true",
      "spark.pyspark.virtualenv.type":"native",
      "spark.pyspark.virtualenv.bin.path":"/usr/bin/virtualenv",
      "spark.driver.memory":"19200M",
      "spark.driver.cores": "5",
      "spark.executor.memory":"19200M",
      "spark.executor.cores": "5",
      "spark.yarn.executor.memoryOverhead": "2200M",
      "spark.executor.instances": "239",
      "spark.default.parallelism": "2390",
      "spark.sql.shuffle.partitions": "2390",
      "maximizeResourceAllocation": "true",
      "spark.network.timeout": "800s",
      "spark.executor.heartbeatInterval": "60s",
      "spark.yarn.scheduler.reporterThread.maxFailures": "5",
      "spark.executor.extraJavaOptions": "-XX:+UseG1GC -XX:+UnlockDiagnosticVMOptions -XX:+G1SummarizeConcMark -XX:InitiatingHeapOccupancyPercent=35 -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:OnOutOfMemoryError='kill -9 %p'",
      "spark.driver.extraJavaOptions": "-XX:+UseG1GC -XX:+UnlockDiagnosticVMOptions -XX:+G1SummarizeConcMark -XX:InitiatingHeapOccupancyPercent=35 -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:OnOutOfMemoryError='kill -9 %p'",
      "spark.executor.extraJavaOptions": "-XX:+UseG1GC -XX:InitiatingHeapOccupancyPercent=35 -XX:ConcGCThreads=12",
      "spark.memory.fraction": "0.70",
      "spark.memory.storageFraction": "0.40",
      "spark.storage.level": "MEMORY_AND_DISK_SER",
      "spark.rdd.compress": "true",
      "spark.shuffle.compress": "true",
      "spark.shuffle.spill.compress": "true",
      "spark.serializer": "org.apache.spark.serializer.KryoSerializer",
      "spark.dynamicAllocation.enabled": "false",
      "spark.sql.parquet.fs.optimized.committer.optimization-enabled": "true",
      }
    }
  ]
  EOF

}
