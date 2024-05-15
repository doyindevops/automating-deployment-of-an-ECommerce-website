pipeline {
    agent any

    environment {
        EC2_IP = '18.132.47.75'
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

        // Assuming Docker is already installed or handled externally
        // Uncomment and adjust if Docker needs to be installed dynamically
        // stage('Install Docker on EC2') {
        //     steps {
        //         script {
        //             echo "Installing Docker on EC2 instance"
        //             sshagent(['ec2-server']) {
        //                 sh "scp -o StrictHostKeyChecking=no install_docker.sh ubuntu@${EC2_IP}:/home/ubuntu/"
        //                 sh "ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} 'bash ./install_docker.sh'"
        //             }
        //         }
        //     }
        // }

        stage('Build Docker Image on EC2') {
            steps {
                script {
                    echo "Building Docker image on EC2 instance"
                    sshagent(['ec2-server']) {
                        // Ensure the directory exists and is ready for the Docker build
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} 'mkdir -p /home/ubuntu/automating-deployment-of-an-ECommerce-website/'"
                        // Copy necessary files to EC2
                        sh "scp -o StrictHostKeyChecking=no index.html Dockerfile ubuntu@${EC2_IP}:/home/ubuntu/automating-deployment-of-an-ECommerce-website/"
                        // Build Docker image in EC2
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} 'docker build -t ${DOCKER_IMAGE} /home/ubuntu/automating-deployment-of-an-ECommerce-website'"
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    echo "Deploying shell script to EC2 instance"
                    sshagent(['ec2-server']) {
                        // Copy the setup script securely to the remote server
                        sh "scp -o StrictHostKeyChecking=no websetup.sh ubuntu@${EC2_IP}:/home/ubuntu/"
                        // Execute the setup script remotely
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
