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
                              timeout(time: 5, unit: 'MINUTES') {
                                  def qg = waitForQualityGate()
                                  if (qg.status != 'OK') {
                                      error "Pipeline aborted due to quality gate failure: ${qg.status}"
                                  }
                              }
                          }
                      }
                  }


       stage("Build & Push Docker Image") {
                  steps {
                      script {
                          // Build the Docker image
                          bat 'docker build -t my-app-DXC-PROD .'

                          // Push the Docker image to a Docker registry (replace with your registry and image name)
                          bat 'docker push assiya24/my-app-DXC-PROD:latest'
                      }
                  }
              }


}
}