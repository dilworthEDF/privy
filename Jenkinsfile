pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t my-flask-app:${BUILD_NUMBER} .'
                }
            }
        }
        stage('Run Docker Container') {
            steps {
                script {
                    sh 'docker run -d -p 5500:5500 --name my-flask-app my-flask-app:${BUILD_NUMBER}'
                }
            }
        }
        stage('Security Scan') {
            steps {
                script {
                    sh 'trivy image -o trivy-report.txt my-flask-app:${BUILD_NUMBER}'
                    archiveArtifacts artifacts: 'trivy-report.txt', fingerprint: true
                }
            }
        }
    }
}