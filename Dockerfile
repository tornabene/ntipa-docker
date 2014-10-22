# NTIPA-CONSUMER-VERSION 0.0.1
FROM      ubuntu:12.04
MAINTAINER Tindaro Tornabene <tindaro.tornabene@gmail.com>
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y dist-upgrade

RUN apt-get -y -q  install  python-software-properties software-properties-common
RUN apt-get -y install openssh-server && mkdir /var/run/sshd
RUN apt-get -y install vim git zip bzip2 fontconfig curl
RUN apt-get -y install supervisor
RUN apt-get -y install ghostscript
RUN apt-get -y install libgs-dev
RUN apt-get -y install graphicsmagick
RUN apt-get -y install graphicsmagick-imagemagick-compat
RUN apt-get -y install build-essential
RUN apt-get -y install checkinstall
RUN apt-get -y install subversion
RUN apt-get -y install autoconf automake libtool
RUN apt-get -y install libjpeg62-dev
RUN apt-get -y install libtiff5
RUN apt-get -y install tesseract-ocr-ita
RUN apt-get -y install tesseract-ocr-eng
RUN apt-get -y install libhocr0
RUN apt-get -y install ruby
RUN apt-get -y install libreoffice


# install oracle java from PPA
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get -y install oracle-java7-installer && apt-get clean

# Set oracle java as the default java
RUN update-java-alternatives -s java-7-oracle
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-7-oracle" >> ~/.bashrc

RUN cd /tmp	
RUN git clone https://github.com/dagwieers/unoconv
RUN cd unoconv/
RUN make install
RUN cd ../
RUN rm -rf unoconv/
RUN cd /opt
RUN git clone https://github.com/gkovacs/pdfocr.git
RUN cd /pdfocr
RUN ln -s /tmp/pdfocr/pdfocr.rb /usr/bin/pdfocr

RUN wget https://raw.githubusercontent.com/tornabene/ntipa-docker/master/unoconvd.sh -P /etc/init.d/
RUN chmod 755 /etc/init.d/unoconvd.sh
RUN update-rc.d  unoconvd.sh defaults
RUN service unoconvd.sh start
RUN cd /opt
RUN mkdir java
RUN mkdir devpublic
RUN cd /opt/java
RUN cd /etc/supervisor/conf.d
RUN wget https://raw.githubusercontent.com/tornabene/ntipa-docker/master/ntipaboxconsumer.conf


#CONFIG HOST
#RUN echo '10.10.130.33 mongo.ntipa.it rabbitmq.ntipa.it solr.ntipa.it  oauth.ntipa.it  manager.ntipa.it box.ntipa.it   camunda.ntipa.it   protocollo.ntipa.it' >> /etc/hosts
#RUN echo '10.10.130.14 git.ipublic.it ' >> /etc/hosts

# expose the SSHD port, and run SSHD
EXPOSE 22
CMD    /usr/sbin/sshd -D
