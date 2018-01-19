#
# Dockerfile for Ubuntu 14.04 Trusty Tahr, Java 8, and Python 3
#
# Really just combining two dockerfile images
# http://dockerfile.github.io/
#
# Python installation command taken from:
# https://github.com/dockerfile/python

# Pull base image.
FROM dockerfile/java:oracle-java8

# Install Python.
RUN \
  apt-get update && \
  apt-get install -y python python-dev python-pip python-virtualenv && \
  rm -rf /var/lib/apt/lists/*
