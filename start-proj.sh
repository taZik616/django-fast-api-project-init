#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

read -p "Введите название проекта: " project_name
read -p "Введите будующий домен сайта: " domain
read -p "Пользователь для быстрого деплоя на сервер ubuntu(по умолчанию: root): " ssh_user
ssh_user=${ssh_user:-root}
read -p "Хост сервера(например 94.144.233.94): " ssh_host
read -p "Пароль для соединения по ssh: " ssh_password
read -p "Директория размещения проекта(по умолчанию: /root/main-django-app): " ssh_project_path
ssh_project_path=${ssh_project_path:-/root/main-django-app}

mkdir "$project_name"

cd "$project_name"

mkdir app

cd app

django-admin startproject settings
mv ./settings/* ./
mv ./settings/settings/* ./settings/

rm -r ./settings/settings

python3 manage.py startapp api

cd ..

make -f "$SCRIPT_DIR/Makefile" generate-docker project_name="$project_name" domain="$domain" script_dir="$SCRIPT_DIR"
make -f "$SCRIPT_DIR/Makefile" create-env ssh_user="$ssh_user" ssh_host="$ssh_host" ssh_password="$ssh_password" ssh_project_path="$ssh_project_path" script_dir="$SCRIPT_DIR"
make -f "$SCRIPT_DIR/Makefile" setup-django-code script_dir="$SCRIPT_DIR" host="$ssh_host" domain="$domain"

echo "Проект $project_name создан."

SSH_PROJECT_PATH=/root/receipt-app