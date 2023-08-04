pipeline {
    agent any
    tools{
        maven 'maven-3'
    }

    stages {
        stage("Git Checkout") {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/chianeng-tech-org/wordsmith-api.git'
            }
        }
    
        stage("Code compile") {
            tools{
                jdk 'jdk-17'
            }
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
                    sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.0.2155:sonar -Dsonar.projectKey=wordsmith-api'
                } 
            }
        } 

        stage('Build') {
            tools{
                jdk 'jdk-17'
            }
            steps {
               sh "mvn clean install"
            }
        }
    }
}