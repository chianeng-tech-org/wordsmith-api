pipeline {
    agent any
    tools{
        maven 'maven-3.9.3'
        jdk 'jdk-17'
    }

    stages {
        stage("Git Checkout") {
            steps {
                git branch: 'main', url: 'https://github.com/chianeng-tech-org/wordsmith-api.git'
            }
        }

        stage("Code compile") {
            steps {
                sh "mvn clean compile"
            }
        }

        stage("Test cases") {
            steps {
                sh "mvn test"
            }
        }

        stage("Sonar Analysis") {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectNAME=api \
                    -Dsonar.java.binaries=. \
                    -Dsonar.projectkey=api '''


                    
                    
                }
            }
        }
    }
}
