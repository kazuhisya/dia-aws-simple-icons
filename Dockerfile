FROM centos:7
MAINTAINER Kazuhisa Hara <kazuhisya@gmail.com>

RUN yum install -y ImageMagick ruby make unzip
COPY / /dia-aws-simple-icons
WORKDIR /dia-aws-simple-icons

RUN ./build.sh
