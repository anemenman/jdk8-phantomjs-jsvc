# Pull base image.
FROM ubuntu:16.04

# openjdk 8
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jdk && \
    ln -s java-8-openjdk-amd64  /usr/lib/jvm/default-jvm

# phantomjs
RUN apt-get -qq update && \
    apt-get -qqy install \
    build-essential \
    chrpath \
    wget \
    libssl-dev \
    libxft-dev \
    libfreetype6-dev \
    libfreetype6 \
    libfontconfig1-dev \
    libfontconfig1
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
    tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/ && \
    ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/

# install jsvc to start process as a daemon
RUN apt-get update && \
    apt-get install jsvc -y && \
    apt-get clean all && \
    rm -rf /phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
    rm -rf /var/lib/apt/lists/*

#
# add user
#RUN useradd -ms /bin/bash aa
# Create the home directory for the new app user.
RUN mkdir -p /home/aa

# Create an app user so our program doesn't run as root.
RUN groupadd -r aa && \
    useradd -r -g aa -d /home/aa -s /sbin/nologin -c "Docker image user" aa

# Set the home directory to our app user's home.
ENV HOME=/home/aa
