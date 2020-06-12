#!/bin/bash
SPARK_REDIS_VERSION="2.5.0"

if [ -z "$1" ]; then
    echo "Output path not specify"
    exit 1
fi

echo "Downloading spark-redis connector"
sudo wget https://repo1.maven.org/maven2/com/redislabs/spark-redis_2.12/$SPARK_REDIS_VERSION/spark-redis_2.12-$SPARK_REDIS_VERSION.jar -P $1
echo "Downloaded spark-redis connector"

echo "Installing libraries"
# Install libraries
sudo pip-3.6 install -U \
  pandas                \
  mlflow                \
  boto3                 \
  s3fs                  \
  IPython

# Jupyter location in EMR: /usr/local/bin/jupyter
