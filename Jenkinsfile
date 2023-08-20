pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                git 'https://github.com/Sia241/DXC.git'
                bat '.\\mvnw clean compile'
            }
        }
        stage('Test') {
            steps {
                 dir('DXC') {
                    bat '.\\mvnw test'
                }
            }

            post {
                always {
                    junit '**/target/surefire-reports/TEST-*.xml'
                }
            }
        }
    }
}
