PHONY: all build run

build: Dockerfile
	docker build -t mwyerman:devenv .
	docker image prune -f

run:
	docker run -it --rm mwyerman:devenv

edit:
	docker run -it --rm --mount type=bind,source="$(CURDIR)/neovim-configs",target="/home/dev/.config/nvim" --workdir /home/dev/.config/nvim mwyerman:devenv
