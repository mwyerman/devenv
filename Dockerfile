FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y software-properties-common sudo
RUN add-apt-repository ppa:neovim-ppa/stable && apt-get update && apt-get install -y neovim
