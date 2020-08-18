node {
   def mvnHome
   def appimage
   stage('Preparation') { // for display purposes
      // Get some code from a GitHub repository
      git branch: 'main',
            url: 'https://github.com/amitmohleji/spring-petclinic.git'
      // Get the Maven tool.
      // ** NOTE: This 'M3' Maven tool must be configured
      // **       in the global configuration.           
      mvnHome = tool 'maven3'
   }    
   stage('Build') {
        sh "${mvnHome}/bin/mvn clean package -DskipTests=true -Dcheckstyle.skip"
   }
   stage('Update K8s.yaml'){
       sh "sed -i 's/{{BUILD_NUMBER}}/$BUILD_NUMBER/g' xl-as-code/artifacts/app.yaml"
       sh "sed -i 's/{{dockerhubuser}}/$dockerhubuser/g' xl-as-code/artifacts/app.yaml"
   }
   stage('Build Docker Image') {
       appimage = docker.build("{{dockerhubuser}}/appz:$BUILD_NUMBER")
   }
   stage('Push Image to Registry(dockerhub)') {
       docker.withRegistry("", "cred") {
           appimage.push("$BUILD_NUMBER")
       }
   }
   stage('Publish'){
       sh "wget -O xl https://dist.xebialabs.com/public/xl-cli/9.7.2/linux-amd64/xl"
       sh "chmod 777 xl"
       sh "./xl apply --xl-deploy-url http://xld:4516 -f xl-as-code/container-demo.yaml --values BUILD_NUMBER=$BUILD_NUMBER"
   }
        
}
