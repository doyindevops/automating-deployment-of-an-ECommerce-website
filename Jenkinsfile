pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'ecommerce-webapp:latest'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/doyindevops/automating-deployment-of-an-ECommerce-website.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${env.DOCKER_IMAGE}")
                }
            }
        }

        stage('Deploy to Webserver') {
            steps {
                sshagent(credentials: ['jenkins-ssh-key']) {
                    // Copy entire workspace, including websetup.sh, to the web server
                    sh 'scp -r . ubuntu@3.10.143.54:/opt/myapp'
                    // Run websetup.sh from within the deployment directory
                    sh 'ssh ubuntu@3.10.143.54 "bash /opt/myapp/websetup.sh"'
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            cleanWs()
        }
    }
}
