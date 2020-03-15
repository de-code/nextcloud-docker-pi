#!make
include .env
export $(shell sed 's/=.*//' .env)


.require-BACKUP_DIR:
	@if [ -z "$(BACKUP_DIR)" ]; then \
		echo "BACKUP_DIR is required"; \
		exit 2; \
	fi
	mkdir -p "$(BACKUP_DIR)"


nc-clone-docker:
	@if [ ! -d ".temp/nextcloud-docker" ]; then \
		git clone "$(NC_GIT_REPO)" .temp/nextcloud-docker; \
	fi
	cd .temp/nextcloud-docker && git checkout "$(NC_GIT_TAG)" && git pull


nc-prepare-docker-config:
	mkdir -p "$(NC_VERSION)/apache"
	cp -R .temp/nextcloud-docker/$(NC_VERSION)/apache/* "$(NC_VERSION)/apache"
	sed -i -r 's/FROM (.*)/ARG base_image=\1\nFROM $${base_image}/g' "$(NC_VERSION)/apache/Dockerfile"
	head -5 "$(NC_VERSION)/apache/Dockerfile"


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


nc-docker-push:
	docker push ${IMAGE_NAME}:${IMAGE_TAG}


mysql-start:
	docker-compose up -d mysql


mysql-logs:
	docker-compose logs -f mysql


mysql-backup: .require-BACKUP_DIR
	./mysql-backup.sh
