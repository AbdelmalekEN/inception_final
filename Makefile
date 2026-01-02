all: up

up:
	mkdir -p /home/$(USER)/data/wordpress /home/$(USER)/data/database
	docker compose -f srcs/docker-compose.yml up -d --build

down:
	docker compose -f srcs/docker-compose.yml down

re: down up

clean:
	docker system prune -a --force
	sudo rm -rf /home/$(USER)/data/*