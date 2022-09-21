FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

ENV \
    UID="1000" \
    GID="1000" \
    UNAME="neovim" \
    GNAME="neovim" 

RUN apt-get update && apt-get install -y software-properties-common sudo
RUN add-apt-repository ppa:neovim-ppa/stable && apt-get update && apt-get install -y neovim

RUN addgroup --gid "${GID}" "${GNAME}" \
    && adduser --disabled-password -gid "${GID}" --uid "${UID}" -shell "/bin/bash" "${UNAME}" \
    && echo "${UNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers 

USER neovim
