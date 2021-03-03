pipeline {
    agent any
    triggers {
        pollSCM '* * * * *'
    }
    environment {
        APP_REPO_NAME = "capstone-case-study-part2"
        BASE_HOME = "$JENKINS_HOME/workspace/capstone-part2/"
        APP_HOME = "$JENKINS_HOME/workspace/capstone-part2/$APP_REPO_NAME"
        DOCKER_HUB_REPO = "pouellette123/flask-app-c2"
        CONTAINER_NAME = "flask-app-c2-cont"
    }
    options {
        skipStagesAfterUnstable()
    }
    stages {
        //stage ('Git Checkout') {
            //checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/pouellette123/capstone-case-study-part2']]])
        //} 
        stage('Clean Up and use previous terraform state files') {
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
                sh 'if (docker ps -a | grep $CONTAINER_NAME); then docker stop $CONTAINER_NAME; docker rm $CONTAINER_NAME;fi'
                //sh 'if (docker image ls | grep $CONTAINER_NAME); then docker rm $CONTAINER_NAME;fi'
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
                // Check if kind, option 1, or AWS, option 2 and move to appropriate directory
                // Initialize Terraform and redeploy app and/or service changes
                sh 'if (ls "$APP_REPO_NAME".clone); then cd $BASE_HOME; cp -rn "$APP_REPO_NAME".clone/* $APP_REPO_NAME/;fi'
                sh 'if (cat $APP_HOME/provision-kubernetes-cluster/config-option.txt | grep "1"); then cd $APP_HOME/deploy-kubernetes/kind; terraform init; terraform apply -auto-approve;fi'
                sh 'if (cat $APP_HOME/provision-kubernetes-cluster/config-option.txt | grep "2"); then cd $APP_HOME/deploy-kubernetes/aws; terraform init; terraform apply -auto-approve;fi'
                // update image
                sh 'sleep 20'
                sh 'kubectl set image deployment/flask-app-deployment flask-app-c2=${DOCKER_HUP_REPO}:${BUILD_NUMBER}'
                sh 'cd $BASE_HOME; mv $APP_REPO_NAME "$APP_REPO_NAME".clone'

            }
        }
    }
}
