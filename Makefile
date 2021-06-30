#!make
include .env
export $(shell sed 's/=".*//"' .env)


CURRENT_DATE_STR = $(shell date +%Y-%m-%d_%H-%M)
CURRENT_BACKUP_DIR_PREFIX = $(BACKUP_DIR)/$(CURRENT_DATE_STR)


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
	docker-compose -f docker-compose.build.yml -f docker-compose.yml build


stop: nc-stop mysql-stop


start: nc-start


logs:
	docker-compose logs -f


pull:
	docker-compose pull


nc-stop:
	docker-compose stop nextcloud-rpi


nc-start:
	docker-compose up -d nextcloud-rpi


nc-logs:
	docker-compose logs -f nextcloud-rpi


nc-first-install: nc-start
	./nc-first-install.sh


nc-set-prefix:
	./run-occ.sh config:system:set overwritewebroot --value /nextcloud


nc-docker-push:
	docker push ${IMAGE_NAME}:${IMAGE_TAG}


nc-data-backup:
	sudo rm -rf "$(CURRENT_BACKUP_DIR_PREFIX)-nc-data"
	sudo cp -r --preserve "$(NC_DATA)" "$(CURRENT_BACKUP_DIR_PREFIX)-nc-data"


nc-html-backup:
	sudo rm -rf "$(CURRENT_BACKUP_DIR_PREFIX)-nc-html"
	sudo cp -r --preserve "$(NC_HTML_DATA)" "$(CURRENT_BACKUP_DIR_PREFIX)-nc-html"


mysql-stop:
	docker-compose stop mysql


mysql-start:
	docker-compose up -d mysql


mysql-logs:
	docker-compose logs -f mysql


mysql-exec:
	./mysql-exec.sh


mysql-backup: .require-BACKUP_DIR
	./mysql-backup.sh

