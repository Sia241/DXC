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

          stage("build & SonarQube analysis") {
                     agent any
                     steps {
                       withSonarQubeEnv('SonarScanner') {
                        bat "mvn clean package sonar:sonar -Dsonar.projectName='DXC-Stage"
                       }
          }
     }
          stage("Quality Gate") {
              steps {
                  script {
                      def qualityGate = waitForQualityGate()
                      if (qualityGate.status != 'OK') {
                          error "Quality Gate failed: ${qualityGate.status}"
                      }
                  }
              }
          }


           stage('Build and Push Docker Image') {
                     steps {
                         script {
                             docker.withRegistry('https://index.docker.io/v1/', DOCKER_HUB_CREDENTIALS) {
                                 // Build and push the Docker image to Docker Hub
                                 def customImage = docker.build(DOCKER_IMAGE_TAG, "-f Dockerfile .")
                                 customImage.push()
                             }
                         }
                     }
                 }

}
}