pipeline {
    agent any

    stages {
        stage('Git checkout') {
            steps {
                sh git branch: 'main', changelog: false, poll: false, url: 'https://github.com/chianeng-tech-org/wordsmith-api.git'
            }
        }
    }
}