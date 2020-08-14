FROM jenkins/jenkins:2.204.6

COPY plugins.txt /usr/share/jenkins/additional-plugins.txt
RUN install-plugins.sh < /usr/share/jenkins/additional-plugins.txt