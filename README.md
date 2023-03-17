# react-and-spring-data-rest

The application has a react frontend and a Spring Boot Rest API, packaged as a single module Maven application. You can build the application using maven and run it as a Spring Boot application using the flat jar generated in target (`java -jar target/*.jar`).

You can test the main API using the following curl commands (shown with its output):

---

\$ curl -v -u greg:turnquist localhost:8080/api/employees/3
{
"firstName" : "Frodo",
"lastName" : "Baggins",
"description" : "ring bearer",
"manager" : {
"name" : "greg",
"roles" : [ "ROLE_MANAGER" ]
},
"\_links" : {
"self" : {
"href" : "http://localhost:8080/api/employees/1"
}
}
}

---

To see the frontend, navigate to http://localhost:8080. You are immediately redirected to a login form. Log in as `greg/turnquist`






# Springboot App

The solution to the assessment has two parts. An infrastructure pipeline and a pipeline that deploys the app.

## infrastructure pipeline
The infrastructure pipeline simply runs a terraform config file to create the required infrastructure for the application.

It automatically setus up the terraform backend for you and all you need to provide is a secret variable within the pipeline

## Springboot App pipeline
The Springboot app pipeline is what actually deploys the application. It tests, builds and packages the application in a docker container. This is then pushed to an Azure container registry and the deployed into a kubernetes cluster created by the infrastructure pipeline. The pipeline also has a manual approval page. You would have to edit the notifier email to yours if you are creating this in your own ADO org. It also timesout after 5 minutes and the pipeline would fail if no approval is given during that time.


### Authentication

Authentication to Azure, ACR and kubernetes are all done via service connections created within the project.

To create a service connection go to the project settings and click here:




## Service Connection Example

![ScreenShot](/screenshots/example.png)


The required service connections to make the pipelines work are:

##### Service Connection ARM (assessment)
##### Service Connection Docker (docker_service_connection)
##### Service Connection Kubernetes (k8s_service_connection)


please create these service connections and ensure that they are name as provided in the brackets.
The assessment service connection is also used to provide authentication for the terraform backend creation script.
To complete this part simply create a secret in the "assessment" service principal, copy the secret and add it as a variable in the infrastructure pipeline. the variable should be named "password".

fot the docker_service_connection and k8s_service_connection you would need to add this after the infrastructure pipeline has run and provisioned all the necessary resources. After that you can create those service connections and select the specific resources as their scope.

Adhering to the principal of least privilege and ensuring that all authentication secrets are secure and hidden was achieved using service connections and not admin credentials.


## Database
The external database in use is a MySQL database in Azure. After deploying for the first time. You would need to go the database and provide the application IP address in the network ACL of the database. You can opt to provide allow acess to all IPs. But that is not adviced. I would have added this extra step via terraform, but it doesn't support it. Implementing this would be possible via script. But environments would differ and that might take a while to complete. There is also an issue with how the app was implemented. At every start up it inserts new records into the database. Hence we have duplicate records. Wanted to fix this but could not due to time constraints.


## Destroying infrastructure

I added a bash script in the root of the repo. Simply run this and sign in to your Azure account. It would simply delete all resources deployed into the resource group. 