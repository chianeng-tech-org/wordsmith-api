pipeline {
    agent any

    stages {
        stage('Git checkout') {
            steps {
                script {
                    git branch: 'main', 'github', url: 'https://github.com/chianeng-tech-org/wordsmith-api.git'
                }
            }
        }
    }
}