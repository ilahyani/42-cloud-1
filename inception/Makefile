all: up

up:
	@mkdir -p ./data/mariadb && mkdir -p ./data/wordpress && docker compose up --build -d

down:
	@docker compose down

clean: down
	@docker volume ls -q | xargs docker volume rm
	@rm -rf ./data

re: clean all

fclean: clean
	@docker system prune -af