pipeline {
    agent any

    stages {
        stage('Build and Test') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        // Run tests, SonarQube analysis, etc., for the 'dev' branch
                    } else if (env.BRANCH_NAME == 'test') {
                        // Run tests, SonarQube analysis, etc., for the 'test' branch
                    } else if (env.BRANCH_NAME == 'prod') {
                        // Run tests, SonarQube analysis, etc., for the 'prod' branch
                    }
                }
            }
        }

        stage('Docker Build') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                script {
                    docker.build("my-app:${env.BRANCH_NAME}")
                }
            }
        }

        stage('Deploy to Kubernetes') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                // Use kubectl or Kubernetes CLI to deploy the Docker image to the specific namespace/environment
                sh "kubectl apply -f kubernetes/${env.BRANCH_NAME}-deployment.yaml"
            }
        }
    }
}
