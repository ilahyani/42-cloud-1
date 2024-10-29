all: up

up:
	@mkdir -p /tmp/data/mariadb && mkdir -p /tmp/data/wordpress && chmod 766 /tmp/data && docker compose up --build

down:
	@docker compose down

clean: down
	@docker images -q | xargs docker rmi -f
	@docker volume ls -q | xargs docker volume rm
	@rm -rf /tmp/data/wordpress/*
	@rm -rf /tmp/data/mariadb/*

re: clean all

fclean: clean
	@docker system prune -af