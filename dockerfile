FROM jenkins/jenkins:2.479.2-jdk17

# Переход к root пользователю для установки зависимостей
USER root

# Обновление и установка зависимостей для Docker
RUN apt-get update && apt-get install -y lsb-release

# Установка ключа GPG для Docker
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg

# Добавление репозитория Docker в список источников APT
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Обновление репозиториев и установка Docker CLI
RUN apt-get update && apt-get install -y docker-ce-cli

# Установка Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Добавление пользователя Jenkins в группу Docker для возможности запускать Docker
RUN groupadd -g 999 docker && usermod -aG docker jenkins

# Возврат к пользователю Jenkins для выполнения команд Jenkins
USER jenkins

# Установка плагинов Jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
