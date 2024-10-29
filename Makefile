all:
	docker run -it -v "$(pwd)":/cloud --env-file .env ubuntu:latest bash -c "bash /cloud/init.sh"