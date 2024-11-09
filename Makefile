all:
	docker run -it -v "$(PWD)":/cloud --env-file .env --name ubuntu ubuntu:latest bash /cloud/init.sh

clean:
	docker rm -f ubuntu

destroy: clean
	docker run -it -v "$(PWD)":/cloud --env-file .env --name ubuntu ubuntu:latest bash /cloud/destroy.sh

re: clean all