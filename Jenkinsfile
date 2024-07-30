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
        stage('Checkout') {
            steps {
                script {
                    echo 'Getting the source code....'
                    checkout([$class: 'GitSCM',
                              branches: [[name: 'origin/HEAD']],
                              doGenerateSubmoduleConfigurations: false,
                              extensions: [[$class: 'CleanBeforeCheckout']],
                              submoduleCfg: [],
                              userRemoteConfigs: [[url: 'https://github.com/amarthakur0/nodejs-api-template', credentialsId: 'github-credentials']]
                    ])
                }
                
            }
        }
    }
}