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



       /* stage('Send Email Notification') {
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
        }*/

        stage("Build & Push Docker Image") {
                steps {
                    script {
                        echo "Workspace: ${workspace}"

                        // Set the DOCKER_BUILDKIT environment variable to "0" to disable Docker Buildkit
                        withEnv(["DOCKER_BUILDKIT=0"]) {
                            // Delete the entire workspace to ensure a clean environment
                            deleteDir()

                            // Copy project files into the Jenkins workspace
                            bat 'xcopy /s C:\\Users\\hp\\Desktop\\DXC\\stage .'

                            // Build the Docker image using the Dockerfile in the 'stage' directory
                            bat 'docker build -t myapp_dxc_test -f C:\\Users\\hp\\Desktop\\DXC\\stage\\Dockerfile .'

                            // Tag the Docker image
                            bat 'docker tag myapp_dxc_test:latest assiya24/myapp_dxc_test:latest'

                            // Log in to the Docker registry using Docker credentials (replace 'docker-credential-id')
                            // This step assumes you have configured Docker credentials in Jenkins
                            // Make sure to replace 'docker-credential-id' with the actual credential ID
                            bat 'docker login -u assiya24 -p dckr_pat_wsh0Gwat4UVKmd9Bh5sr7mDXwPk'

                            // Push the Docker image to a Docker registry (replace with your registry and image name)
                            bat 'docker push assiya24/myapp_dxc_test:latest'

                            // Log out from Docker registry
                            bat 'docker logout'
                        }
                    }
                }
            }


      /* stage("Deploy to Kubernetes") {
                steps {
                    script {
                        // Apply your Kubernetes Deployment YAML file
                        bat "kubectl apply -f C:\\Users\\hp\\Desktop\\DXC\\stage\\deployment.yaml"
                    }
                }
            }*/
    }
}
