FROM jenkins/jenkins:latest

COPY plugins.txt /usr/share/jenkins/additional-plugins.txt
RUN install-plugins.sh < /usr/share/jenkins/additional-plugins.txt
USER root
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io