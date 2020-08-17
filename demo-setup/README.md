### Setup

Perform the following steps for the setup  
1. Verify your local docker setup is functional. Also either install minishift either locally or get an openshift cloud setup.
2. Go inside folder ``` demo-setup ```
3. Run ``` docker-compose up --build ``` to build and start instances for Deploy, Release, Jenkins and socat  
4. Verify if everything is running fine using a browser  
* Deploy : ``` http://localhost:4516 , u/p : admin/admin ```
* Release : ``` http://localhost:5516, u/p : admin/admin ```
* Jenkins : ``` http://localhost:8080, u/p : admin/admin ```
5. Now go inside folder xl-setup
6. Rename ``` secrets.xlvals.example ``` to ``` secrets.xlvals```. Update the settings for GKE  endpoint url, caCertificate, client tls Certificate, tls key for GKE and token/url for openshift
7. Make sure you have the latest [XL command line](https://docs.xebialabs.com/v.9.7/release/how-to/install-the-xl-cli#get-started)  installed 
8. Now run this command ``` xl apply -f setup.yaml ```. This will create infrastructure endpoints, environment and application name in Deploy.

### Execution
