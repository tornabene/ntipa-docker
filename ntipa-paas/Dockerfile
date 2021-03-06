# DOCKER-VERSION 0.7.1
FROM      ubuntu:14.04
MAINTAINER Tindaro Tornabene <tindaro.tornabene@gmail.com>

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get -y update

# install python-software-properties (so you can do add-apt-repository)
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-software-properties software-properties-common

# install SSH server so we can connect multiple times to the container
RUN apt-get -y install openssh-server && mkdir /var/run/sshd

# install oracle java from PPA
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get -y install oracle-java7-installer && apt-get clean

# Set oracle java as the default java
RUN update-java-alternatives -s java-7-oracle
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-7-oracle" >> ~/.bashrc

# install utilities
RUN apt-get -y install vim git sudo zip bzip2 fontconfig curl

# install maven
RUN apt-get -y install maven

# install node.js from PPA
RUN add-apt-repository ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get -y install nodejs

# install yeoman
RUN npm install -g yo

# install JHipster
RUN npm install -g generator-jhipster@1.4.0

# configure the "ntipa" and "root" users
RUN echo 'root:ntipa' |chpasswd
RUN groupadd ntipa && useradd ntipa -s /bin/bash -m -g ntipa -G ntipa && adduser ntipa sudo
RUN echo 'ntipa:ntipa' |chpasswd

# install the sample app to download all Maven dependencies
RUN cd /home/ntipa && \
    wget https://github.com/jhipster/jhipster-sample-app/archive/v1.4.0.zip && \
    unzip v1.4.0.zip && \
    rm v1.4.0.zip
RUN cd /home/ntipa/jhipster-sample-app-1.4.0 && npm install
RUN cd /home && chown -R ntipa:ntipa /home/ntipa
RUN cd /home/ntipa/jhipster-sample-app-1.4.0 && sudo -u jhipster mvn dependency:go-offline

# expose the working directory, the Tomcat port, the Grunt server port, the SSHD port, and run SSHD
VOLUME ["/ntipa"]
EXPOSE 8080
EXPOSE 9000
EXPOSE 22
CMD    /usr/sbin/sshd -D
