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

      stage("Send Email") {
                 steps {
                     script {
                         def junitAttachments = '**/target/surefire-reports/TEST-*.xml'
                         def sonarAttachments = '**/target/sonar/*.html'

                         emailext(
                             subject: "Build Results for DXC-Internship",
                             body: "The JUnits build and SonarQube analysis have completed.",
                             to: 'assiyasiwar@gmail.com',
                             attachmentsPattern: junitAttachments + ' ' + sonarAttachments
                         )
                     }
                 }
 }
}
}