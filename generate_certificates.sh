#!/bin/bash
mkdir -p certs

# Генерация SSL-сертификатов для Nginx
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout certs/privkey.pem \
  -out certs/fullchain.pem \
  -subj "/C=US/ST=Local/L=Local/O=Local/OU=Dev/CN=localhost"

# Удалить старый Java Keystore, если существует
if [ -f certs/jenkins.jks ]; then
  rm certs/jenkins.jks
fi

# Создание Java Keystore для Jenkins
openssl pkcs12 -export -in certs/fullchain.pem -inkey certs/privkey.pem \
  -out certs/jenkins.p12 -name jenkins -password pass:password

keytool -importkeystore -deststorepass password -destkeypass password \
  -destkeystore certs/jenkins.jks -srckeystore certs/jenkins.p12 -srcstoretype PKCS12 -srcstorepass password \
  -alias jenkins

# Установка правильных прав доступа
chmod 600 certs/privkey.pem certs/fullchain.pem certs/jenkins.jks
