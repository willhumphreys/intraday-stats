#!/usr/bin/env bash

#!/usr/bin/env bash
set -e

echo "Download data"

mkdir -p data

aws s3 cp https://s3.amazonaws.com/mochi-data2/EURUSD.csv data

echo "Execute the stats"

java -Dfile.encoding=UTF-8 -jar intraday-stats.jar

echo "Execute the R script"

Rscript plotFrequency.r

now=$(date +%F_%T)

aws s3 sync sentiment-plots s3://sentiment-plots/${now}
aws s3 sync sentiment-csv s3://sentiment-plots/${now}

aws s3 rm --recursive s3://sentiment-plots/current

aws s3 sync sentiment-plots s3://sentiment-plots/current
aws s3 sync sentiment-csv/* s3://sentiment-plots/current

exit 0