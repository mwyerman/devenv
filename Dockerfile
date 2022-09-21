FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

ENV \
    UID="1000" \
    GID="1000" \
    UNAME="neovim" \
    GNAME="neovim" 

RUN apt-get update && apt-get install -y software-properties-common sudo git
RUN add-apt-repository ppa:neovim-ppa/stable && apt-get update && apt-get install -y neovim

RUN addgroup --gid "${GID}" "${GNAME}" \
    && adduser --disabled-password -gid "${GID}" --uid "${UID}" -shell "/bin/bash" "${UNAME}" \
    && echo "${UNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers 

COPY --chown=neovim neovim-configs /home/neovim/.config/nvim

USER neovim

RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    /home/neovim/.local/share/nvim/site/pack/packer/start/packer.nvim
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
