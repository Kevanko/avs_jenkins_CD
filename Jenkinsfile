pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'jenkins_avs-jenkins:latest'
        DOCKER_CONTAINER_NAME = 'jenkins'
        DOCKER_PORT = '80:80'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Kevanko/avs_jenkins_CD.git'
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Остановка и удаление только контейнера docker-dind, если он существует
                    sh '''
                        if docker ps -a --filter "name=docker-dind" -q; then
                            echo "Removing existing docker-dind container..."
                            docker rm -f docker-dind || true
                        fi
                    '''

                    // Запуск контейнеров через docker-compose
                    sh 'docker compose -f docker-compose.yml up -d docker'

                    // Проверка состояния контейнеров
                    sh 'docker ps -a'
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished'
        }
        success {
            echo ':)'
        }
        failure {
            echo ':('
        }
    }
}