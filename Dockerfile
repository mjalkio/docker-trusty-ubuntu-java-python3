#
# Dockerfile for Ubuntu 14.04 Trusty Tahr, Java 8, and Python 3
#
# Based on a number of Docker builds from [dockerfile](http://dockerfile.github.io/).
#
# https://github.com/dockerfile/ubuntu
# https://github.com/dockerfile/java/tree/master/oracle-java8
# https://github.com/dockerfile/python
#

# Pull base image.
FROM ubuntu:14.04

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man realpath ssh unzip vim wget && \
  rm -rf /var/lib/apt/lists/*

# Add files.
ADD root/.bashrc /root/.bashrc
ADD root/.gitconfig /root/.gitconfig
ADD root/.scripts /root/.scripts

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Install Java.
# sed commands are to update the oracle-java8-installer to the version of Java available as of 2018/01/19
# For more info: https://ubuntuforums.org/showthread.php?t=2374686&page=4&p=13731177#post13731177
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer || true && \
  cd /var/lib/dpkg/info && \
  sed -i 's|JAVA_VERSION=8u151|JAVA_VERSION=8u162|' oracle-java8-installer.* && \
  sed -i 's|PARTNER_URL=http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/|PARTNER_URL=http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/|' oracle-java8-installer.* && \
  sed -i 's|SHA256SUM_TGZ="c78200ce409367b296ec39be4427f020e2c585470c4eed01021feada576f027f"|SHA256SUM_TGZ="68ec82d47fd9c2b8eb84225b6db398a72008285fafc98631b1ff8d2229680257"|' oracle-java8-installer.* && \
  sed -i 's|J_DIR=jdk1.8.0_151|J_DIR=jdk1.8.0_162|' oracle-java8-installer.* && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install Python.
RUN \
  apt-get update && \
  apt-get install -y python python-dev && \
  rm -rf /var/lib/apt/lists/*

# Install Python 3.6
RUN \
  add-apt-repository ppa:jonathonf/python-3.6 && \
  apt-get update && \
  apt-get install -y python3.6 python3.6-dev && \
  rm -rf /var/lib/apt/lists/*

# Ubuntu 14.04 Python packages are painfully old, we want the newest pip!
RUN curl https://bootstrap.pypa.io/get-pip.py | python3.6
# Warning: make sure to run this second so that the default pip is Python 2
RUN curl https://bootstrap.pypa.io/get-pip.py | python

# Update some important packages
RUN pip3.6 install --upgrade setuptools virtualenv
# Warning: make sure to run this second so that the default virtualenv is Python 2
RUN pip install --upgrade setuptools virtualenv

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["bash"]
