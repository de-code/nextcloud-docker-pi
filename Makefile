#!make
include .env
export $(shell sed 's/=.*//' .env)


CURRENT_DATE_STR = $(shell date +%F)
CURRENT_BACKUP_DIR = $(BACKUP_DIR)/$(CURRENT_DATE_STR)

CURRENT_MYSQL_BACKUP_FILE = $(CURRENT_BACKUP_DIR)/nextcloud-mysql-backup.sql


.require-BACKUP_DIR:
	@if [ -z "$(BACKUP_DIR)" ]; then \
		echo "BACKUP_DIR is required"; \
		exit 2; \
	fi
	mkdir -p "$(BACKUP_DIR)"


.require-CURRENT_BACKUP_DIR: .require-BACKUP_DIR
	@if [ -z "$(CURRENT_BACKUP_DIR)" ]; then \
		echo "CURRENT_BACKUP_DIR is required"; \
		exit 2; \
	fi
	echo "CURRENT_BACKUP_DIR=$(CURRENT_BACKUP_DIR)"
	mkdir -p "$(CURRENT_BACKUP_DIR)"


download-qemu-static:
	./download-qemu-static.sh


register-qemu-static:
	docker run --rm --privileged multiarch/qemu-user-static:register --reset


build:
	docker-compose build


nc-start:
	docker-compose up -d nextcloud-rpi


nc-logs:
	docker-compose logs -f nextcloud-rpi


nc-first-install:
	./nc-first-install.sh


nc-set-prefix:
	./run-occ.sh config:system:set overwritewebroot --value /nextcloud


start-mysql:
	docker-compose up -d mysql


backup-mysql: .require-CURRENT_BACKUP_DIR
	@echo "CURRENT_BACKUP_DIR=$(CURRENT_BACKUP_DIR)"
	docker-compose exec mysql \
		mysqldump --single-transaction -h localhost \
		--user=$(MYSQL_USER) \
		--password=$(MYSQL_PASSWORD) \
		--port=3306 \
		--databases \
		$(MYSQL_DATABASE) \
		| tee $(CURRENT_MYSQL_BACKUP_FILE)
