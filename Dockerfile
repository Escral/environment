FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    apt-get install sudo

FROM base AS user
#ARG TAGS
#RUN addgroup --gid 1000 alexander
#RUN useradd -m -s /bin/bash -u 1000 -g 1000 alexander && chown -R alexander:alexander /home/alexander
#RUN usermod -aG sudo alexander
#USER alexander

ENV HOME=/home/alexander
ENV USER=alexander

ARG TAGS
RUN addgroup --gid 1000 alexander
RUN adduser --home /home/alexander --gecos alexander --uid 1000 --gid 1000 --disabled-password alexander
RUN usermod -aG sudo alexander
USER root
WORKDIR /home/alexander

FROM user
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]

