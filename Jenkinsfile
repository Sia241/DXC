pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        DOCKER_IMAGE_TAG = "assiya24/DXC-Internship-TEST:latest"
    }

    stages {
        stage('Build') {
            steps {
                git 'https://github.com/Sia241/DXC.git'
                bat '.\\mvnw clean compile'
            }
        }
        stage('Test') {
            steps {
                bat '.\\mvnw test'
            }

            post {
                always {
                    junit '**/target/surefire-reports/TEST-*.xml'
                }
            }
        }

        stage("SonarQube Analysis") {
            agent any
            steps {
                withSonarQubeEnv('SonarScanner') {
                    bat "mvn clean package sonar:sonar -Dsonar.projectName='DXC-Stage'"
                }
            }
        }

        stage("Quality Gate") {
            steps {
                script {
                    timeout(time: 5, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }



        stage('Send Email Notification') {
            steps {
                script {
                    def junitResults = currentBuild.rawBuild.getTestResultAction()

                    emailext body: """
                        <h2>Test Results</h2>
                        <p>JUnit Test Results: <a href='${JENKINS_URL}${BUILD_URL}testReport'>Click here</a></p>
                        <h2>SonarQube Report</h2>
                        <p>SonarQube Dashboard: <a href='http://localhost:9000/dashboard?id=DXC-Stage'>Click here</a></p>
                    """,
                    subject: "DXC-Stage Pipeline: Test Results and SonarQube Report",
                    to: "assiyasiwar@gmail.com",
                    mimeType: 'text/html'
                }
            }
        }

    }
}
