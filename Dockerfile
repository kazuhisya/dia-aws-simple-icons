FROM centos:7
MAINTAINER Kazuhisa Hara <kazuhisya@gmail.com>

RUN yum install -y ImageMagick ruby make unzip
COPY / /dia-aws-simple-icons
WORKDIR /dia-aws-simple-icons

RUN ./build.sh
RUN mv .outputs dia-aws-simple-icons-`date +"%Y%m%d"` && \
    tar zcvf dia-aws-simple-icons-`date +"%Y%m%d"`.tar.gz dia-aws-simple-icons-`date +"%Y%m%d"` && \
    mkdir dist && mv dia-aws-simple-icons-`date +"%Y%m%d"`.tar.gz dist
