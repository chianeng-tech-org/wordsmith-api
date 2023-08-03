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
                    sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.0.2155:sonar -Dsonar.projectKey=wordsmith-api'
                } 
            }
        }
        stage('Artifact Build') {
           steps {
                sh "mvn clean install"
            } 
       }
       
        stage('Trivy image scan') {
           steps {
                sh "trivy chianeng/wordsmith-api-img:latest"
            } 
        }
        stage('Build, Tag and Push to ECR') {
           steps {
             withEnv (["AWS_ACCESS_KEY_ID=${env.AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY}", "AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION}"])
                sh "docker login -u AWS -p $(aws ecr-public get-login-password --region us-east-1) public.ecr.aws/v5c6t0p8"
                sh "docker build -t chianeng/wordsmith-api-img ."
                sh "docker tag chianeng/wordsmith-api-img:latest public.ecr.aws/v5c6t0p8/chianeng/wordsmith-api-img""$BUILD_ID"""
                sh "docker push public.ecr.aws/v5c6t0p8/chianeng/wordsmith-api-img:""$BUILD_ID"""
            } 
        }

    }
}