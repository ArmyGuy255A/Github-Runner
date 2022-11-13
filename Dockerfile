#Derived from: https://dev.to/pwd9000/create-a-docker-based-self-hosted-github-runner-linux-container-48dh
#Author: Marcel L
#Author Email: pwd9000@hotmail.co.uk
#Modified by Phil Dieppa
#Modification Email: pdieppa3@gatech.edu

# base image
# FROM alpine:latest
FROM ubuntu:20.04

#input GitHub runner version argument
ARG RUNNER_VERSION
ARG MAVEN_VERSION
ENV DEBIAN_FRONTEND=noninteractive

LABEL Author="Phil Dieppa"
LABEL Email="pdieppa3@gatech.edu"
LABEL GitHub="https://github.gatech.edu/pdieppa3"
LABEL BaseImage="ubuntu:20.04"
LABEL RunnerVersion=${RUNNER_VERSION}
LABEL MavenVersion=${MAVEN_VERSION}
LABEL JDKVersion=17

# update the base packages + add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y && useradd -m docker

RUN apt-get install -y --no-install-recommends \
    curl nodejs wget unzip vim git azure-cli jq build-essential openjdk-17-jdk libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip

# cd into the user directory, download and unzip the github actions runner
# Note: this runner needs to be consistent/compatible with the Enterprise Github server
RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

#Install maven
RUN curl -O -L https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && tar xzf ./apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt \
    && ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven \
    && rm ./apache*

#Setup maven
ADD scripts/maven.sh /etc/profile.d/maven.sh

RUN chmod +x /etc/profile.d/maven.sh \
    && . /etc/profile.d/maven.sh

# install some additional dependencies
RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

# add over the start.sh script
ADD scripts/start.sh start.sh

# make the script executable
RUN chmod +x start.sh

# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

# set the entrypoint to the start.sh script
# ENTRYPOINT ["./start.sh"]
ENTRYPOINT ["/bin/sh"]