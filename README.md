Please follow the live for an explanation of this project.

This Project uses a cask flask application to implement a CI/CD pipeline.

The infrastructure added.

Dockerfile: Containerizes the flask application with it's Python requirements.

Kubernetes.tf: Creates the kubernetes cluster and deployment to be implemented on Kind.

Jenkinsfile: This is the CI/CD pipeline. For this project Jenkins is running in a Docker container and deploying the application to a Linux computer running a Kubernetes using Kind, Docker, Terraform...

Steps not visible in the Jenkinsfile involve:
1. Setting up credentials in Jenkins for GitHub, DockerHub and SSH.
2. Installing Kind and creating a cluster.
