all:
	docker run -it -v "$(PWD)":/cloud --env-file .env --name ubuntu ubuntu:latest bash /cloud/init.sh

destroy:
	docker start -i ubuntu bash /cloud/destroy.sh

clean:
	docker rm -f ubuntu
