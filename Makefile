generate-docker:
	sed "s/{project_name}/$(project_name)/g" $(script_dir)/docker-compose.yml > docker-compose.yml
	sed "s/{project_name}/$(project_name)/g" $(script_dir)/docker-compose-server.yml > docker-compose-server.yml
	sed "s/{project_name}/$(project_name)/g" $(script_dir)/Dockerfile > Dockerfile
	mkdir -p conf
	sed "s/{domain}/$(domain)/g" $(script_dir)/nginx.conf > conf/nginx.conf
	cp -R $(script_dir)/root/ .

DB_PASSWORD := $(shell openssl rand -base64 12 | tr -dc 'A-Za-z0-9')
# Тут нужно быть осторожным с комментариями, они создаются через '#' и ниже это мешало
DJANGO_SECRET_KEY := $(shell openssl rand -base64 36 | tr -dc 'a-zA-Z0-9!@^&_+')

.PHONY: create-env
create-env:
	@echo "# DB" > .env
	@echo "DJANGO_DB_NAME=db_v1" >> .env
	@echo "DJANGO_DB_USER=root" >> .env
	@echo "DJANGO_DB_PASSWORD=$(DB_PASSWORD)" >> .env
	@echo "DJANGO_DB_HOST=db" >> .env
	@echo "DJANGO_DB_PORT=5432" >> .env
	@echo "" >> .env
	@echo "# For fast deploy" >> .env
	@echo "SSH_USER=$(ssh_user)" >> .env
	@echo "SSH_PASSWORD=$(ssh_password)" >> .env
	@echo "SSH_HOST=$(ssh_host)" >> .env
	@echo "SSH_PROJECT_PATH=$(ssh_project_path)" >> .env

	@echo "# Default superuser" > app/.env
	@echo "SUPERUSER_USERNAME=admin@gmail.com" >> app/.env
	@echo "SUPERUSER_PASSWORD=superuser-666" >> app/.env
	@echo "" >> app/.env
	@echo "# DJANGO" >> app/.env
	@echo "DJANGO_SECRET_KEY='$(DJANGO_SECRET_KEY)'" >> app/.env
	@echo "DJANGO_DEBUG=True" >> app/.env
	@echo "DJANGO_CACHE_URL=memcached://memcached:11211" >> app/.env
	@echo "DJANGO_DB_URL=postgres://root:$(DB_PASSWORD)@db:5432/db_v1" >> app/.env
	@echo "" >> app/.env
	@echo "# Other" >> app/.env

setup-django-code:
	rm -rf app/settings/__init__.py
	rm -rf app/settings/urls.py
	cp -r $(script_dir)/app-settings/* app/settings/
	cp $(script_dir)/reqs.txt app/

	rm -rf app/api/admin.py
	rm -rf app/api/models.py
	cp -r $(script_dir)/api/ app/api/
	
	sed -e "s/{host}/$(host)/g" -e "s/{domain}/$(domain)/g" $(script_dir)/settings.py > app/settings/settings.py