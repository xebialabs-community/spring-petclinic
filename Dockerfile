FROM openjdk:8-jre
MAINTAINER "amohleji@digital.ai"
ADD target/petclinic.jar /usr/local
WORKDIR /usr/local
CMD ["java" , "-jar","petclinic.jar" ]