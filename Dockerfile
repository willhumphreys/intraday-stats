FROM amazonlinux:2
MAINTAINER WillHumphreys

RUN yum  update -y
RUN yum  install -y java-1.8.0
RUN yum  remove -y java-1.7.0-openjdk
RUN yum  install -y wget

RUN yum update amazon-linux-extras
RUN amazon-linux-extras install R3.4

RUN yum -y install libcurl-devel gcc-gfortran python

RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

#RUN alternatives --set gcc /usr/bin/gcc64

RUN Rscript -e "install.packages(c('ggplot2', 'dplyr'), repos='http://cran.us.r-project.org')"

COPY plotFrequency.r plotFrequency.r
COPY runStats.sh runStats.sh

RUN chmod +x runStats.sh

COPY "build/libs/intraday-stats-1.0-all.jar" intraday-stats.jar

ENTRYPOINT ["./runStats.sh"]
