# avs_jenkins_CD

Jenkins-based CI/CD lab environment with Docker, Nginx, HTTPS certificates, and deployment automation.

## Overview

This repository contains infrastructure files for building a training CI/CD environment. It combines Jenkins pipelines, container orchestration, reverse proxy configuration, and local certificate generation.

## Structure

- `docker-compose.yml` - service orchestration
- `Jenkinsfile` - pipeline definition
- `nginx` - reverse proxy configuration
- `certs` - certificate-related assets
- `generate_certificates.sh` - local certificate bootstrap

## Stack

Docker, Jenkins, Nginx, shell scripts.

## Notes

This project was created as part of coursework and infrastructure labs.

