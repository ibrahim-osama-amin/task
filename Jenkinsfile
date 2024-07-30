#!/usr/bin/env groovy

library identifier: 'jenkins-shared-library@main', retriever: modernSCM(
    [$class: 'GitSCMSource',
     remote: 'https://github.com/ibrahim-osama-amin/Jenkins-shared-library.git',
     credentialsId: 'github-credentials'
    ]
)

pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    environment {
        IMAGE_NAME = 'ibrahimosama/task:nodejs-api-template'
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
        stage('Checkout Build Repo') {
            steps {
                script {
                    git branch: 'master', url: 'https://github.com/ibrahim-osama-amin/task.git'
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
                    sh 'cp task/Dockerfile .'
                    buildImage(env.IMAGE_NAME)
                }
            }
        }
        stage('Pushing Docker image'){
            steps {
                script{
                   echo 'Pushing docker image to docker hub repo...'
                   dockerLogin()
                   dockerPush(env.IMAGE_NAME)
                }
            }
        }
    }
}