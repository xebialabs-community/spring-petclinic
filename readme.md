# Kubernetes Deployment with Digital.ai Deploy and Release

## Introduction
This project is built to showcase Deployment of container applications in kubernetes using Digital.ai Deploy and Release. The core Application being used for showcase is Spring Boot Based Spring-Petclinic Application. The project performs the following
* Use Jenkins pipeline DSL to build the spring-petclinic and then push it to dockerhub.
* Also during the build, it creates a Deploy Package using [XL command line](https://docs.xebialabs.com/v.9.7/release/how-to/install-the-xl-cli#get-started) and publishes the package into Deploy
* Deploy is setup with environments pointing to Kubernetes for Docker Desktop and Google Kubernetes Engine.
* Deploy can then be used to publish the application with both the environment with Docker Desktop using HSQLDB and GKE using mysql
* Release template flow can then be showcased to chain the whole process togther wit Build, Deploy, Verify and TearDown.

## Setup

Perform the following steps for the setup  
1. Verify your local docker setup is functional. Also enable Kubernetes for Docker Desktop on your machine.
2. Go inside folder ``` demo-setup ```
3. Run ``` docker-compose up --build ``` to build and start instances for Deploy, Release, Jenkins and socat  
4. Verify if everything is running fine using a browser  
* **Deploy** : ``` http://localhost:4516 , u/p : admin/admin ```
* **Release** : ``` http://localhost:5516, u/p : admin/admin ```
* **Jenkins** : ``` http://localhost:8080, u/p : admin/admin ```
5. Now go inside folder xl-setup
6. Rename ``` secrets.xlvals.example ``` to ``` secrets.xlvals```. Update the settings for Endpoint url, caCertificate, client tls Certificate, tls key for GKE and Kubernetes for Docker Desktop
7. Make sure you have the latest [XL command line](https://docs.xebialabs.com/v.9.7/release/how-to/install-the-xl-cli#get-started)  installed 
8. Now run this command ``` xl apply -f setup.yaml ```. This will create infrastructure endpoints, environment and applicationm configuration in Deploy and Template configurations in Release

## Key Components
* **/demo-setup** - This folder contains the setup to configure Jenkins, Deploy and Release using docker-compose. Jenkins is setup using configuration-as-code
* **/demo-setup/xl-setup** - This folder contains the yaml files using by XL Command line to create all the CIs in deploy and release
* **/xl-as-code** - This contains container-demo.yaml that is responsible for creating Deploy's Deployment Package dynamically through jenkins build
* **/xl-as-code/artifacts** - This contains the actual kubernetes yamls files that create the application. Some of the file have placeholders in them that will get replaced through Deploy's dictionary entries during deployment. Those values may need to be replaced if you want to run the file directly with kubectl
* **Dockerfile** - This is used to package springboot application into docker image
* **Jenkinsfile** - This is used to generate jenkins pipeline with DSL code

## Execution

1. Login inside jenkins and  run petclinic-demo job. This job will build code, build a docker image, publish to dockerhub with your credentials, use xl command line to build and publish Deployment package with kubernetes yamls
2. To individually run deployments, login inside Deploy and perform deployment with 
* Application - Container-demo/<latest package>
* Environment/dev/localk8s
* Environment/qa/gke
3. This first deployment will create a namespace in k8s and also add a new CI in the environment for that namespace. 
4. The second deployment of the same package will now attach all deployables to the new namespace component and trigger deployment
5. Now open Release and go inside container-demo folder
6. You can run a new release from the **container release ** template that will do the above step 1-4 and after manual verification, also do a teardown of the deployments.
 
## Observations
* Notice that Deploy tags cause mysql to be only deployed in qa environment and not in dev
* configmap and secrets are being populated by placeholder replacement capturing values from deploy dictionaries 

# Original Project Readme

## Spring PetClinic Sample Application [![Build Status](https://travis-ci.org/spring-projects/spring-petclinic.png?branch=main)](https://travis-ci.org/spring-projects/spring-petclinic/)

## Understanding the Spring Petclinic application with a few diagrams
<a href="https://speakerdeck.com/michaelisvy/spring-petclinic-sample-application">See the presentation here</a>

## Running petclinic locally
Petclinic is a [Spring Boot](https://spring.io/guides/gs/spring-boot) application built using [Maven](https://spring.io/guides/gs/maven/). You can build a jar file and run it from the command line:


```
git clone https://github.com/spring-projects/spring-petclinic.git
cd spring-petclinic
./mvnw package
java -jar target/*.jar
```

You can then access petclinic here: http://localhost:8080/

<img width="1042" alt="petclinic-screenshot" src="https://cloud.githubusercontent.com/assets/838318/19727082/2aee6d6c-9b8e-11e6-81fe-e889a5ddfded.png">

Or you can run it from Maven directly using the Spring Boot Maven plugin. If you do this it will pick up changes that you make in the project immediately (changes to Java source files require a compile as well - most people use an IDE for this):

```
./mvnw spring-boot:run
```

## In case you find a bug/suggested improvement for Spring Petclinic
Our issue tracker is available here: https://github.com/spring-projects/spring-petclinic/issues


## Database configuration

In its default configuration, Petclinic uses an in-memory database (H2) which
gets populated at startup with data. The h2 console is automatically exposed at `http://localhost:8080/h2-console`
and it is possible to inspect the content of the database using the `jdbc:h2:mem:testdb` url.
 
A similar setup is provided for MySql in case a persistent database configuration is needed. Note that whenever the database type is changed, the app needs to be run with a different profile: `spring.profiles.active=mysql` for MySql.

You could start MySql locally with whatever installer works for your OS, or with docker:

```
docker run -e MYSQL_USER=petclinic -e MYSQL_PASSWORD=petclinic -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=petclinic -p 3306:3306 mysql:5.7.8
```

Further documentation is provided [here](https://github.com/spring-projects/spring-petclinic/blob/main/src/main/resources/db/mysql/petclinic_db_setup_mysql.txt).

## Working with Petclinic in your IDE

### Prerequisites
The following items should be installed in your system:
* Java 8 or newer.
* git command line tool (https://help.github.com/articles/set-up-git)
* Your preferred IDE 
  * Eclipse with the m2e plugin. Note: when m2e is available, there is an m2 icon in `Help -> About` dialog. If m2e is
  not there, just follow the install process here: https://www.eclipse.org/m2e/
  * [Spring Tools Suite](https://spring.io/tools) (STS)
  * IntelliJ IDEA
  * [VS Code](https://code.visualstudio.com)

### Steps:

1) On the command line
    ```
    git clone https://github.com/spring-projects/spring-petclinic.git
    ```
2) Inside Eclipse or STS
    ```
    File -> Import -> Maven -> Existing Maven project
    ```

    Then either build on the command line `./mvnw generate-resources` or using the Eclipse launcher (right click on project and `Run As -> Maven install`) to generate the css. Run the application main method by right clicking on it and choosing `Run As -> Java Application`.

3) Inside IntelliJ IDEA
    In the main menu, choose `File -> Open` and select the Petclinic [pom.xml](pom.xml). Click on the `Open` button.

    CSS files are generated from the Maven build. You can either build them on the command line `./mvnw generate-resources` or right click on the `spring-petclinic` project then `Maven -> Generates sources and Update Folders`.

    A run configuration named `PetClinicApplication` should have been created for you if you're using a recent Ultimate version. Otherwise, run the application by right clicking on the `PetClinicApplication` main class and choosing `Run 'PetClinicApplication'`.

4) Navigate to Petclinic

    Visit [http://localhost:8080](http://localhost:8080) in your browser.


## Looking for something in particular?

|Spring Boot Configuration | Class or Java property files  |
|--------------------------|---|
|The Main Class | [PetClinicApplication](https://github.com/spring-projects/spring-petclinic/blob/main/src/main/java/org/springframework/samples/petclinic/PetClinicApplication.java) |
|Properties Files | [application.properties](https://github.com/spring-projects/spring-petclinic/blob/main/src/main/resources) |
|Caching | [CacheConfiguration](https://github.com/spring-projects/spring-petclinic/blob/main/src/main/java/org/springframework/samples/petclinic/system/CacheConfiguration.java) |

## Interesting Spring Petclinic branches and forks

The Spring Petclinic "main" branch in the [spring-projects](https://github.com/spring-projects/spring-petclinic)
GitHub org is the "canonical" implementation, currently based on Spring Boot and Thymeleaf. There are
[quite a few forks](https://spring-petclinic.github.io/docs/forks.html) in a special GitHub org
[spring-petclinic](https://github.com/spring-petclinic). If you have a special interest in a different technology stack
that could be used to implement the Pet Clinic then please join the community there.


## Interaction with other open source projects

One of the best parts about working on the Spring Petclinic application is that we have the opportunity to work in direct contact with many Open Source projects. We found some bugs/suggested improvements on various topics such as Spring, Spring Data, Bean Validation and even Eclipse! In many cases, they've been fixed/implemented in just a few days.
Here is a list of them:

| Name | Issue |
|------|-------|
| Spring JDBC: simplify usage of NamedParameterJdbcTemplate | [SPR-10256](https://jira.springsource.org/browse/SPR-10256) and [SPR-10257](https://jira.springsource.org/browse/SPR-10257) |
| Bean Validation / Hibernate Validator: simplify Maven dependencies and backward compatibility |[HV-790](https://hibernate.atlassian.net/browse/HV-790) and [HV-792](https://hibernate.atlassian.net/browse/HV-792) |
| Spring Data: provide more flexibility when working with JPQL queries | [DATAJPA-292](https://jira.springsource.org/browse/DATAJPA-292) |


# Contributing

The [issue tracker](https://github.com/spring-projects/spring-petclinic/issues) is the preferred channel for bug reports, features requests and submitting pull requests.

For pull requests, editor preferences are available in the [editor config](.editorconfig) for easy use in common text editors. Read more and download plugins at <https://editorconfig.org>. If you have not previously done so, please fill out and submit the [Contributor License Agreement](https://cla.pivotal.io/sign/spring).

# License

The Spring PetClinic sample application is released under version 2.0 of the [Apache License](https://www.apache.org/licenses/LICENSE-2.0).

[spring-petclinic]: https://github.com/spring-projects/spring-petclinic
[spring-framework-petclinic]: https://github.com/spring-petclinic/spring-framework-petclinic
[spring-petclinic-angularjs]: https://github.com/spring-petclinic/spring-petclinic-angularjs 
[javaconfig branch]: https://github.com/spring-petclinic/spring-framework-petclinic/tree/javaconfig
[spring-petclinic-angular]: https://github.com/spring-petclinic/spring-petclinic-angular
[spring-petclinic-microservices]: https://github.com/spring-petclinic/spring-petclinic-microservices
[spring-petclinic-reactjs]: https://github.com/spring-petclinic/spring-petclinic-reactjs
[spring-petclinic-graphql]: https://github.com/spring-petclinic/spring-petclinic-graphql
[spring-petclinic-kotlin]: https://github.com/spring-petclinic/spring-petclinic-kotlin
[spring-petclinic-rest]: https://github.com/spring-petclinic/spring-petclinic-rest
