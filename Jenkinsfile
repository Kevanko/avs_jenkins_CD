pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/Kevanko/avs_jenkins_CD.git'
        APP_IMAGE = 'rgr2-app:latest'
        DOCKER_COMPOSE_FILE = '../docker-compose.yml'
        UID = '1000' 
        GID = '1000'
    
    }

    stages {
        stage('Checkout Second Repo') {
            steps {
                git branch: 'main', url: "${REPO_URL}"
            }
        }

        stage('Build and Deploy using Docker Compose') {
            steps {
                script {
                    def changes = sh(script: "git diff --stat", returnStdout: true).trim()

                    if (changes) {
                        echo "Изменения в репозитории обнаружены."
                    } else {
                        echo "Изменений нет, процесс сборки пропущен."
                        currentBuild.result = 'SUCCESS'
                        return
                    }
                
                    
                        sh "docker compose  build"                       
                        sh "docker compose  up -d app"
                    }
                }
            }
        }
    }
