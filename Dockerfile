FROM jenkins/jenkins:latest
MAINTAINER nescirem <nescirem@gmail.com>
LABEL description="Docker base image for Fortran CI builds"

USER root

RUN apt update 
RUN apt install -y build-essential gfortran make \
    python3-pip python3-venv python-dev && \
    apt-get clean

USER jenkins
