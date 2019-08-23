FROM jenkins/jenkins:latest
MAINTAINER nescirem <nescirem@gmail.com>
LABEL description="Docker base image for Fortran CI builds"

USER root

RUN apt update && apt install -y \
    build-essential gfortran makedepf90 \
    python3-pip python3-venv python-dev && \
    rm -rf /var/lib/apt/lists/*
RUN pip3 --no-cache-dir install ford FoBiS.py pygooglechart

USER jenkins
