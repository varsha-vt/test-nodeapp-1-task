pipeline{
    agent {label 'worker'}
    options{
        buildDiscarder(logRotator(daysToKeepStr: '7'))
        disableConcurrentBuilds()
    }
    stages{
        stage('Git Pull'){
            steps{
                checkout scm
            }
        }
        stage('Docker build and Push'){
            steps{
                sh 'echo "Building the docker image"'
                sh 'aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 270335494562.dkr.ecr.us-east-1.amazonaws.com'
                sh 'sudo docker build -t 270335494562.dkr.ecr.us-east-1.amazonaws.com/demovt:v${BUILD_NUMBER} .'
                sh 'echo "Pushing the docker image"'
                sh 'docker push 270335494562.dkr.ecr.us-east-1.amazonaws.com/demovt:v${BUILD_NUMBER}'
            }
        }
    }
}
