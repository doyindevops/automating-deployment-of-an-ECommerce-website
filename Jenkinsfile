pipeline {
    agent any

    environment {
        EC2_IP = '18.132.47.75'
        DOCKER_IMAGE = 'nginx-ecommerce-site:latest'
    }

    stages {
        stage('Prepare Environment') {
            steps {
                script {
                    echo "Preparing the EC2 environment for deployment."
                    // Ensure the Docker working directory is ready
                    sshagent(['ec2-server']) {
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} 'mkdir -p /home/ubuntu'"
                    }
                }
            }
        }

        stage('Fetch Code') {
            steps {
                script {
                    echo "Pulling source code from GitHub."
                    retry(3) {
                        git branch: 'main', url: 'https://github.com/doyindevops/automating-deployment-of-an-ECommerce-website.git'
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    echo "Deploying Docker container on EC2."
                    sshagent(['ec2-server']) {
                        // Run Docker container
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} 'docker run -d -p 80:80 ${DOCKER_IMAGE}'"
                    }
                }
            }
        }
    }

}
