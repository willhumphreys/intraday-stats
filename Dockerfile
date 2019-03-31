FROM amazonlinux
MAINTAINER WillHumphreys

RUN yum  update -y
RUN yum  install -y java-1.8.0
RUN yum  remove -y java-1.7.0-openjdk
RUN yum  install -y wget
RUN yum install -y R
RUN yum -y install libcurl-devel gcc-gfortran python

RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

RUN alternatives --set gcc /usr/bin/gcc64

RUN Rscript -e "install.packages(c('ggplot2'), repos='http://cran.us.r-project.org')"

COPY plotFrequency.r plotFrequency.r
COPY pullSentimentAndExecuteGraphs.sh pullSentimentAndExecuteGraphs.sh

RUN chmod +x pullSentimentAndExecuteGraphs.sh

COPY "build/libs/sentiment-1.5-all.jar" sentiment.jar

ENTRYPOINT ["./pullSentimentAndExecuteGraphs.sh"]
