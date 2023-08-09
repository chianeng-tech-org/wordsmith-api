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

        stage("Quality Gate"){
            steps{
                script{
                    timeout(time: 5, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }

        stage('Artifact Build') {
            tools{
                jdk 'jdk-17'
            }
            steps {
               sh "mvn clean install"
            }
        }

        stage('Docker Build & Tag Image') {
           steps {
                script{
                    dir("${WORKSPACE}"){
                        sh "ls -l"
                        sh "docker build -t 637678941185.dkr.ecr.us-east-1.amazonaws.com/chianeng-wordsmith-api:1.0-SNAPSHOT ."
                    } 
                }
            } 
        }

        stage('Docker Push To ECR') {
           steps{
                script{
                    withAWS([credentials:'aws-cred',region:'']){
                        sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 637678941185.dkr.ecr.us-east-1.amazonaws.com"
                        sh "docker push 637678941185.dkr.ecr.us-east-1.amazonaws.com/chianeng-wordsmith-api:1.0-SNAPSHOT"
                    } 
                } 
            }

        }
        post{
        failure{
                withAWS([credentials:'aws-creds',region:'us-east-1']){
                    sh"aws sns publish --topic-arn arn:aws:sns:us-east-1:637678941185:jenkins-notification --message 'Build failed for component ${name} Build URl: ${BUILD_URL}' --subject 'Build Status'"
                }
            }
        }
    }
}
