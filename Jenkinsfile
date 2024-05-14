pipeline {
    agent any

    environment {
        EC2_IP = '18.175.78.222'
        DOCKER_IMAGE = 'nginx-ecommerce-site:latest'
    }

    stages {
        stage('Fetch Code') {
            steps {
                script {
                    echo "Pulling source code from Git"
                    retry(3) {
                        git branch: 'main', url: 'https://github.com/doyindevops/automating-deployment-of-an-ECommerce-website.git'
                    }
                }
            }
        }

        stage('Install Docker on EC2') {
            steps {
                script {
                    echo "Installing Docker on EC2 instance"
                    sshagent(['ubuntu']) {
                        // Copy the Docker installation script to the EC2 instance.
                        sh "scp -o StrictHostKeyChecking=no install_docker.sh ubuntu@${EC2_IP}:/home/ubuntu/"
                        // Execute the Docker installation script
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} 'bash ./install_docker.sh'"
                    }
                }
            }
        }

        stage('Build Docker Image on EC2') {
            steps {
                script {
                    echo "Building Docker image on EC2 instance"
                    sshagent(['ubuntu']) {
                        // Copy necessary files to EC2
                        sh "scp -o StrictHostKeyChecking=no Dockerfile index.html ubuntu@${EC2_IP}:/home/ubuntu/"
                        // Build Docker image on EC2
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} 'docker build -t ${DOCKER_IMAGE} /home/ubuntu/'"
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    echo "Deploying shell script to EC2 instance"
                    sshagent(['ubuntu']) {
                        // Copy the setup script securely to the remote server
                        sh "scp -o StrictHostKeyChecking=no websetup.sh ubuntu@${EC2_IP}:/home/ubuntu"
                        // Execute the setup script remotely with proper error handling
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} 'bash ./websetup.sh'"
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace post build...'
            cleanWs()
        }
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed. Check build logs for errors.'
        }
    }
}
