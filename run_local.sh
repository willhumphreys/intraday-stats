#!/usr/bin/env bash
set -e
PROPERTY_FILE=~/.aws/credentials

source ./get_property.sh

echo "Build the jar"
gradle clean build shadowjar

echo "# Reading secret access key from $PROPERTY_FILE"
SECRET_KEY=$(getProperty "aws_secret_access_key")

docker build -t intraday-stats .

#Leaves the container running so you can log in: docker exec -it container_name /bin/bash
#docker run -t -d -e AWS_ACCESS_KEY_ID=AKIAJDQCQTRC7LRFASJQ -e AWS_SECRET_ACCESS_KEY=${SECRET_KEY} sentiment

docker run -e AWS_ACCESS_KEY_ID=AKIAJDQCQTRC7LRFASJQ -e AWS_SECRET_ACCESS_KEY=${SECRET_KEY}  intraday-stats