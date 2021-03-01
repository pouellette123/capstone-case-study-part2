pipeline {
    agent any
    triggers {
        pollSCM '* * * * *'
    }
    environment {
        APP_REPO_NAME = "capstone-case-study-part2"
        APP_HOME = "$JENKINS_HOME/workspace/capstone-part2/capstone-case-study-part2/$APP_REPO_NAME"
        DOCKER_HUB_REPO = "pouellette123/flask-app-c2"
        CONTAINER_NAME = "flask-app-c2-cont"
    }
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Clean Up') {
            steps {
                sh 'rm -rf $APP_HOME'
            }
        }
        stage('Git Clone Repository') {
            steps {
                sh 'git clone https://github.com/pouellette123/$APP_REPO_NAME'
            }
        }
        stage('Build the Docker Image') {
            steps {
                sh 'docker image build -t $DOCKER_HUB_REPO:latest $APP_HOME/flask-app/'
                sh 'docker image tag $DOCKER_HUB_REPO:latest $DOCKER_HUB_REPO:$BUILD_NUMBER'
            }
        }
        stage('Run the Container') {
            steps {
                sh 'if (docker ps | grep $CONTAINER_NAME); then docker stop $CONTAINER_NAME;fi'
                sh 'if (docker image ls | grep $CONTAINER_NAME); then docker rm $CONTAINER_NAME;fi'
                sh 'docker run --name $CONTAINER_NAME -d -p 8079:8079 $DOCKER_HUB_REPO:$BUILD_NUMBER'
            }
        }
        stage('Test the Container') {
            steps {
                // test with a curl
                sh 'curl -s --head  --request GET  10.0.0.143:8079 | grep 200'
                // stop the container, don't want port confilct 
                sh 'if (docker ps | grep $CONTAINER_NAME); then docker stop $CONTAINER_NAME;fi'
            }
        }
        stage('Push the Image to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USER1', passwordVariable: 'PASS1')]) {
                    sh 'docker login -u "$USER1" -p "$PASS1"'
                }
                //  Pushing Image to Repository
                sh 'docker push $DOCKER_HUB_REPO:$BUILD_NUMBER'
                sh 'docker push $DOCKER_HUB_REPO:latest'
//                echo "Image built and pushed to repository"
            }
        }
        stage('Deploy with Terraform to Kubernetes Cluster') {
            steps {
                // Initialize Terraform
                sh 'terraform init'
                // Apply Terraform
                sh 'terraform apply -auto-approve'
                sh 'sudo -u pouellet kubectl set image deployment/scalable-flask-app flask-capp-c2=${DOCKER_HUB_REPO}:${BUILD_NUMBER}'
            }
        }
    }
}
