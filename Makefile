ARGS = $(filter-out $@,$(MAKECMDGOALS))
MAKEFLAGS += --silent

list:
	sh -c "echo; $(MAKE) -p no_targets__ | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | grep -v 'Makefile'| sort"

#############################
# Create new project
#############################

create:
	bash bin/create-project.sh $(ARGS)

#############################
# Docker machine states
#############################

up:
	docker-compose up -d

start:
	docker start dev_mariadb

start-bpn:
	docker start dev_postgres && docker-compose up -d bpn

start-sigfox:
	docker start dev_postgis dev_redis && docker-compose up -d sigfox

start-rajamart:
	docker start dev_mariadb && docker-compose up -d rajamart

start-rajamart:
	docker start dev_mariadb && docker-compose up -d agregator

start-pms:
	docker start dev_mariadb dev_mysql && docker-compose up -d pms

start-bpn_queue:
	docker start dev_mariadb dev_redis dev_postgres && docker-compose up -d bpn_queue

stop:
	docker stop dev_mariadb dev_postgres && docker-compose stop

stop-bpn:
	docker stop dev_postgres && docker-compose stop bpn

stop-sigfox:
	docker stop dev_postgis dev_redis && docker-compose stop sigfox

stop-rajamart:
	docker stop dev_mariadb && docker-compose stop rajamart

stop-agregator:
	docker stop dev_mariadb && docker-compose stop agregator

stop-pms:
	docker stop dev_mariadb dev_mysql && docker-compose stop pms

stop-bpn_queue:
	docker stop dev_mariadb dev_redis dev_postgres && docker-compose stop bpn_queue

state:
	docker-compose ps

rebuild:
	docker-compose stop
	docker-compose pull
	docker-compose rm --force app
	docker-compose build --no-cache --pull
	docker-compose up -d --force-recreate

#############################
# MySQL
#############################

mysql-backup:
	bash ./bin/backup.sh mysql

mysql-restore:
	bash ./bin/restore.sh mysql

#############################
# Solr
#############################

solr-backup:
	bash ./bin/backup.sh solr

solr-restore:
	bash ./bin/restore.sh solr

#############################
# General
#############################

backup:  mysql-backup  solr-backup
restore: mysql-restore solr-restore

build:
	bash bin/build.sh

mysql:
	bash bin/db.sh $(ARGS)

bash: shell

shell:
	docker-compose exec --user application app /bin/bash

root:
	docker-compose exec --user root app /bin/bash

service:
	bash bin/start.sh $(ARGS)
#############################
# Argument fix workaround
#############################
%:
	@:
