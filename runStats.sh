#!/usr/bin/env bash
set -e

echo "Download data"

mkdir -p data
mkdir -p results/data
mkdir -p results/graphs

aws s3 cp s3://mochi-data2/EURUSDShort.csv data/EURUSD.csv

echo "Execute the stats"

java -Dfile.encoding=UTF-8 -jar intraday-stats.jar --hour 21 -d 2 -s EURUSD

echo "Execute the R script"

Rscript plotFrequency.r EURUSD 2 21

aws s3 rm --recursive s3://intraday-plots/current/EURUSD
aws s3 sync results s3://intraday-plots/current/EURUSD

exit 0