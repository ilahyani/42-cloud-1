all:
	docker run -it -v "$(PWD)":/cloud --env-file .env --name ubuntu ubuntu:latest bash /cloud/init.sh

stop:
	docker stop ubuntu

clean:
	docker rm -f ubuntu
