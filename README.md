# Capstone Case Study Part 2
[link to project description](https://docs.google.com/document/d/1J5rvYyM-EjEq1GFcrTuVrwn6q1INIp6U6J1MS3OhOJM/edit)

This Project uses a flask application to implement a CI/CD pipeline.

The infrastructure added.

Dockerfile: Containerizes the flask application with it's Python requirements.

Kubernetes.tf: Creates the kubernetes cluster and deployment to be implemented on Kind.

Jenkinsfile: This is the CI/CD pipeline. For this project Jenkins is running in a Docker container and deploying the application to a Linux computer running a Kubernetes using Kind, Docker, Terraform...

Steps not visible in the Jenkinsfile involve:
1. Setting up credentials in Jenkins for GitHub and DockerHub.
2. Installing Kind and creating a cluster.


