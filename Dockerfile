# Dockerfile for psiturk container
FROM debian:jessie
MAINTAINER Matteo Visconti dOC <mvdoc.gr@dartmouth.edu>

RUN apt-get update && apt-get install -y \
	python-dev \
	libncurses-dev \
	python-pip \
	python-mysqldb \
	python-mysqldb-dbg \
	python-sqlalchemy \
	libmysqlclient-dev

RUN rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip
RUN pip install --upgrade \
setuptools \
requests \
mysql-python \
psiturk 

# Use an adhoc user to avoid using root
RUN groupadd -r psiturk && \
useradd -r -g psiturk psiturk

USER psiturk

WORKDIR /psiturk

# set up psiturk to use the .psiturkconfig in /psiturk
ENV PSITURK_GLOBAL_CONFIG_LOCATION=/psiturk/

EXPOSE 22362
