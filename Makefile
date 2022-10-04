PHONY: all build run

build: Dockerfile
	docker build -t mwyerman:devenv .
	docker image prune -f

run:
	docker run -it --rm mwyerman:devenv

edit:
	docker start -i nvimconfedit 2>/dev/null || docker run --name nvimconfedit -it --workdir /home/dev/.config/nvim mwyerman:devenv 2>/dev/null
