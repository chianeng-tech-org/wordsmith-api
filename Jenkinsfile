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
            tools{
                jdk "jdk-11" //name of jdk @tools
            }
            environment {
                SCANNER_HOME= tool 'sonar-scanner' // name of sonar scanner @tools
            }
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=wordsmith-api \
                    -Dsonar.java.binaries=. \
                    -Dsonar.projectkey=Devops-CICD '''
                }
                
            }
        }
    }
}
