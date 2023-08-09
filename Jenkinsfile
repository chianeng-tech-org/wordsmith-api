def tag
def name = "wordsmith-api"
def registry = "637678941185.dkr.ecr.us-east-1.amazonaws.com"
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
                script{
                    tag = getComponentTag()
                    sh "mvn clean install"
                }
            }
        }

        stage('Docker Build & Tag Image') {
           steps {
                script{
                    dir("${WORKSPACE}"){
                        sh "ls -l"
                        sh "docker build -t ${registry}/${name}:${tag} ."
                    } 
                }
            } 
        }

        stage('Docker Push To ECR') {
           steps{
                script{
                    withAWS([credentials:'aws-cred',region:'us-east-1']){
                        sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${registry}"
                        sh "docker push ${registry}/${name}:${tag}"
                    } 
                } 
            }

        }
    }
    post{
        failure{
                withAWS([credentials:'aws-cred',region:'us-east-1']){
                    sh"aws sns publish --topic-arn arn:aws:sns:us-east-1:637678941185:jenkins-notification --message 'Build failed for component ${name} Build URl: ${BUILD_URL}' --subject 'Build Status'"
                }
            }
    }
}
void getComponentTag(){
    def pom = readMavenPom file: 'pom.xml'
        version = pom.version
        println version
    def branch = "${BRANCH_NAME}"
        println branch
        branch = branch.replaceAll("/","-")
        println branch
    def buildNumber = "${BUILD_NUMBER}"
        println buildNumber
    def tag
        if(branch == "develop"){
            tag = "${version}-rc-${buildNumber}"
        } else if(branch == "main"){
            tag = "${version}-${buildNumber}"
        } else{
            tag = "${version}-${branch}.${buildNumber}"
        }
        return tag
}     

