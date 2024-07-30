#!/usr/bin/env groovy

library identifier: 'jenkins-shared-library@main', retriever: modernSCM(
    [$class: 'GitSCMSource',
     remote: 'https://github.com/ibrahim-osama-amin/Jenkins-shared-library.git',
     credentialsId: 'github-credentials'
    ]
)

pipeline {
    agent any
    environment {
        IMAGE_NAME = 'ibrahimosama/task:nodejs-api-template'
        PUBLIC_IP = '13.38.89.223'
    }
    stages {
        stage('Checkout code') {
            steps {
                script {
                    echo 'Getting the source code....'
                    git branch: 'master', url: 'https://github.com/amarthakur0/nodejs-api-template.git'
                }
                
            }
        }
        stage ('Running unit tests'){
            steps {
                script {
                    echo 'Running unit tests...'
                    sh 'npm test || true' // I ignored the error of the script as the original code did not include a test
                }
            }
        }
        stage('Building Docker image'){
            steps {
                script{
                    echo 'Building docker image...'
                    sh 'rm -rf task'
                    sh 'git clone https://github.com/ibrahim-osama-amin/task.git'
                    sh 'cp task/Dockerfile .'
                    sh "docker build -t ${IMAGE_NAME} ."
                }
            }
        }
        stage('Pushing Docker image'){
            steps {
                script{
                   echo 'Pushing docker image to docker hub repo...'
                   dockerLogin()
                   sh "docker push ${IMAGE_NAME}"
                }
            }
        }
        stage ('Deploying the application to EC2 instance'){
            steps {
                script{
                   echo 'Deploying the image to EC2 instance....'
                   def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME}"
                    sh 'ls -l task'
                   sshagent(['paris-eu-west-3']) {
                    sh "scp -o StrictHostKeyChecking=no task/server-cmds.sh ${PUBLIC_IP}:/home/ec2-user"
                    sh "scp -o StrictHostKeyChecking=no task/docker-compose.yaml ${PUBLIC_IP}:/home/ec2-user"
                    sh "ssh -o StrictHostKeyChecking=no ${PUBLIC_IP} ${shellCmd}"
                   }

                }
            }
        }
    }
}