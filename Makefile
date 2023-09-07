.DEFAULT_GOAL := init

VERSION ?= v1
PROJECT_ENV ?= development

init:
	@read -p "Choose an environment (d=development, p=production): " choice; \
        if [ "$$choice" = "p" ]; then \
                PROJECT_ENV=production; \
        fi; \
	@read -p "Enter the version (default: $(VERSION), e.g., v1, v2, v3): " input; \
	if [ ! -z "$$input" ]; then \
		VERSION=$$input; \
	fi; \
	mkdir -p volume/$(VERSION)/db; \
	mkdir -p volume/$(VERSION)/wp; \
	mkdir -p apps/$(VERSION)
	if [ "$$ENV" = "development" ]; then \
		echo "현재 환경 - 개발"; \
	else \
		echo "현재 환경 - 프로덕션"; \
		rm docker-compose.yaml \
		mv docker-compose.prod.yaml docker-compose.yaml \
		echo '# 프로덕션버전 \n# 참고 https://github.com/beeclover/wordpress-docker/blob/main/docker-compose.prod.yaml' | cat - docker-compose.yaml > temp && mv temp docker-compose.yaml
	fi

clean:
	rm -r apps volume

p:
	@read -p "Enter the version (default: $(VERSION), e.g., v1, v2, v3): " input; \
	if [ ! -z "$$input" ]; then \
		VERSION=$$input; \
	fi; \
	sudo chown -R 33:33 apps/theme volume/$(VERSION)/wp && sudo chmod -R 775 apps/theme volume/$(VERSION)/wp

php_env:
	@read -p "Enter the version (default: $(VERSION), e.g., v1, v2, v3): " input; \
	if [ ! -z "$$input" ]; then \
		VERSION=$$input; \
	fi; \
	echo "\nphp_value upload_max_filesize 512M" >> volume/$(VERSION)/wp/.htaccess; \
	echo "php_value post_max_size 512M" >> volume/$(VERSION)/wp/.htaccess; \
	echo "php_value memory_limit 256M" >> volume/$(VERSION)/wp/.htaccess; \
	echo "php_value max_execution_time 300" >> volume/$(VERSION)/wp/.htaccess; \
	echo "php_value max_input_time 300" >> volume/$(VERSION)/wp/.htaccess
