pipeline {
    agent any

    // Define global environment variables
    environment {
        EC2_IP = '18.132.47.75'
        DOCKER_IMAGE = 'nginx-ecommerce-site:latest'
        WORK_DIR = '/home/doyin/automating-deployment-of-an-ECommerce-website'  // Adjust as per actual directory path
    }

    stages {
        // Stage 1: Fetch Code from Git Repository
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

        // Stage 2: Install Docker on the EC2 Instance
        stage('Install Docker on EC2') {
            steps {
                script {
                    echo "Installing Docker on EC2 instance"
                    sshagent(['ec2-server']) {
                        sh "scp -o StrictHostKeyChecking=no ${WORK_DIR}/install_docker.sh ubuntu@${EC2_IP}:/home/ubuntu/"
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} 'bash /home/ubuntu/install_docker.sh'"
                    }
                }
            }
        }

        // Stage 3: Build Docker Image on EC2
        stage('Build Docker Image on EC2') {
            steps {
                script {
                    echo "Building Docker image on EC2 instance"
                    sshagent(['ec2-server']) {
                        sh "scp -o StrictHostKeyChecking=no ${WORK_DIR}/Dockerfile ${WORK_DIR}/index.html ubuntu@${EC2_IP}:/home/ubuntu/"
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} 'docker build -t ${DOCKER_IMAGE} /home/ubuntu/'"
                    }
                }
            }
        }

        // Stage 4: Deploy Web Setup Script on EC2
        stage('Deploy to EC2') {
            steps {
                script {
                    echo "Deploying web setup script to EC2 instance"
                    sshagent(['ec2-server']) {
                        sh "scp -o StrictHostKeyChecking=no ${WORK_DIR}/websetup.sh ubuntu@${EC2_IP}:/home/ubuntu/"
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} 'bash /home/ubuntu/websetup.sh'"
                    }
                }
            }
        }
    }

    // Post-build actions
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

