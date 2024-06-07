// pipeline {
//     agent any
//     stages {
//         stage('Build Docker Image') {
//             steps {
//                 script {
//                     sh 'docker build -t my-flask-app:${BUILD_NUMBER} .'
//                 }
//             }
//         }
//         stage('Run Docker Container') {
//             steps {
//                 script {
//                     sh 'docker run -d -p 5500:5500 --name my-flask-app my-flask-app:${BUILD_NUMBER}'
//                 }
//             }
//         }
//         stage('Security Scan') {
//             steps {
//                 script {
//                     sh 'trivy image -o trivy-report.txt my-flask-app:${BUILD_NUMBER}'
//                     archiveArtifacts artifacts: 'trivy-report.txt', fingerprint: true
//                 }
//             }
//         }
//     }
// }

pipeline {
    agent any
 
    stages {
        stage('Init') {
            steps {
                sh 'docker rm -f $(docker ps -qa) || true'
                sh 'docker network create new-network || true'
            }
        }
        stage('Build') {
            steps {
                sh 'docker build -t flask-app .'
                sh 'docker build -t mynginx -f Dockerfile.nginx .'
            }
        }
 
        stage("Security Scan") {
            steps {
                sh "trivy fs --format json -o trivy-report.json ."
            }
            post {
                always {
                    // Archive the Trivy report
                    archiveArtifacts artifacts: 'trivy-report.json', onlyIfSuccessful: true
                }
            }
        }
 
         stage('Deploy') {
            steps {
                sh 'docker run -d --name flask-app --network new-network flask-app:latest'
                sh 'docker run -d -p 80:80 --name mynginx --network new-network mynginx:latest'
            }
        }
 
        stage('Execute Tests') {
            steps {
                script {
                sh '''
                python3 -m venv .venv
                . .venv/bin/activate
                pip install -r requirements.txt
                python3 -m unittest discover -s tests .
                deactivate
                '''
                }
            }
        }
    }
}