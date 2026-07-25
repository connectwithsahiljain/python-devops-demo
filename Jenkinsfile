pipeline{
    agent any
    stages{
        stage('Checkout'){
            steps{
                checkout scm
            }
        }
        stage('Build Docker Images'){
            steps{
                bat 'docker build -t python-devops-demo:v1 .'
            }
        }
        stage('Run Docker Container'){
            steps{
                bat 'docker rm -f python-app || exit 0'
                bat 'docker run -d -p 5000:5000 --name python-app python-devops-demo:v1'
            }
        }
    }
}