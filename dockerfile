# Используем официальный образ Jenkins с JDK 11
FROM jenkins/jenkins:lts-jdk11

# Сменим пользователя на root для установки зависимостей
USER root

# Обновление списка пакетов и установка зависимостей для Docker
RUN apt-get update && apt-get install -y \
    lsb-release \
    curl \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Добавление репозитория Docker и установка Docker CLI
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | tee /usr/share/keyrings/docker-archive-keyring.asc
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

# Создаем группу docker и добавляем пользователя Jenkins в эту группу
RUN groupadd -g 999 docker && usermod -aG docker jenkins

# Устанавливаем необходимые плагины для Jenkins
RUN jenkins-plugin-cli --plugins \
    "blueocean" \
    "docker-workflow" \
    "git" \
    "pipeline-model-definition" \
    "workflow-aggregator" \
    "docker-credential-helper"

# Вернемся к пользователю Jenkins для работы
USER jenkins

# Установим переменные окружения для работы с Docker и Jenkins
ENV DOCKER_HOST="unix:///var/run/docker.sock"

# Настроим рабочую директорию Jenkins
WORKDIR /var/jenkins_home

# Запускаем Jenkins
CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]
