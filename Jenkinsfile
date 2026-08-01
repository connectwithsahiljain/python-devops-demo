pipeline{
    agent any
    environment {
        IMAGE_NAME = 'connectiwthsahiljain/python-devops-demo'
        IMAGE_TAG = "${BUILD_NUMBER}"
        INSTANCE_ID = 'i-041fa070ccc7f0804'
        AWS_REGION = 'us-east-1'
    }

    stages{
        stage('Checkout'){
            steps{
                checkout scm
            }
        }
        stage('Check AWS CLI'){
            steps{
                bat 'aws --version'
            }
        }
        stage('Build Docker Images'){
            steps{
                bat '"C:\\Users\\sahiljain77\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" build -t python-devops-demo:v1 .'
            }
        }
        // stage('Run Docker Container'){
        //     steps{
        //         bat '"C:\\Users\\sahiljain77\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" rm -f python-app || exit 0'
        //         bat '"C:\\Users\\sahiljain77\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" run -d -p 5000:5000 --name python-app python-devops-demo:v1'
        //     }
        // }
        stage('Docker Login'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]){
                    bat """ echo %DOCKER_PASSWORD% | "C:\\Users\\sahiljain77\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" login -u %DOCKER_USERNAME% -p %DOCKER_PASSWORD%"""
                }
            }
        }
        stage('Tag Image'){
            steps{
                bat '"C:\\Users\\sahiljain77\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" tag python-devops-demo:v1 %IMAGE_NAME%:%IMAGE_TAG%'
            }
        }
        stage('Push Image'){
            steps{
                bat '"C:\\Users\\sahiljain77\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" push %IMAGE_NAME%:%IMAGE_TAG%'
            }
        }
        stage('Deploy to EC2'){
            steps{
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]){
                    bat 'aws ec2 describe-instances --instance-ids %INSTANCE_ID% --region %AWS_REGION%'
                    powershell """
                        \$tmpFile = Join-Path \$env:TEMP 'ssm-input-${env.BUILD_NUMBER}.json'
                        @{
                            Targets      = @(@{ Key = 'instanceIds'; Values = @('${env.INSTANCE_ID}') })
                            DocumentName = 'AWS-RunShellScript'
                            Comment      = 'Deploy Docker Image'
                            Parameters   = @{
                                commands = @(
                                    'docker pull ${env.IMAGE_NAME}:${env.IMAGE_TAG}',
                                    'docker stop python-app || true',
                                    'docker rm python-app || true',
                                    'docker run -d -p 5000:5000 --name python-app ${env.IMAGE_NAME}:${env.IMAGE_TAG}'
                                )
                            }
                        } | ConvertTo-Json -Depth 5 | Out-File -FilePath \$tmpFile -Encoding utf8
                        aws ssm send-command --region '${env.AWS_REGION}' --cli-input-json "file://\$tmpFile"
                        Remove-Item \$tmpFile -ErrorAction SilentlyContinue
                    """
                }
            }
        }
    }
}
