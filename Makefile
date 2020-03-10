#!make
include .env
export $(shell sed 's/=.*//' .env)


.require-BACKUP_DIR:
	@if [ -z "$(BACKUP_DIR)" ]; then \
		echo "BACKUP_DIR is required"; \
		exit 2; \
	fi
	mkdir -p "$(BACKUP_DIR)"


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


mysql-start:
	docker-compose up -d mysql


mysql-logs:
	docker-compose logs -f mysql


mysql-backup: .require-BACKUP_DIR
	./mysql-backup.sh
