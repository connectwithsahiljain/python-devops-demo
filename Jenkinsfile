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
                bat '"C:\\Users\\sahiljain77\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" build -t python-devops-demo:v1 .'
            }
        }
        stage('Run Docker Container'){
            steps{
                bat '"C:\\Users\\sahiljain77\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" rm -f python-app || exit 0'
                bat '"C:\\Users\\sahiljain77\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" run -d -p 5000:5000 --name python-app python-devops-demo:v1'
            }
        }
    }
}