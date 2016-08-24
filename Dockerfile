# Dockerfile for psiturk container
FROM debian:jessie
MAINTAINER Matteo Visconti dOC <mvdoc.gr@dartmouth.edu>

RUN apt-get update && apt-get install -y \
	python-dev \
	python-pip

RUN rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip
RUN pip install --upgrade \
setuptools \
requests \
psiturk

EXPOSE 22362

CMD cd /root; \
	HOME=/root psiturk-setup-example; \
	cd psiturk-example; \
psiturk
