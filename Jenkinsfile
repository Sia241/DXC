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
                        bat "mvn clean package sonar:sonar \
                           -Dsonar.projectKey=DXC-Stage \
                           -Dsonar.projectName='DXC-Stage' \
                           -Dsonar.host.url=http://localhost:9000 \
                           -Dsonar.token=sqp_09ed54f3b88a1e77835283b8686b4f328c41c19b"
                       }
          }
     }
 }
}