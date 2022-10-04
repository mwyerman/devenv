FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

ENV \
    UID="1000" \
    GID="1000" \
    UNAME="dev" \
    GNAME="dev" 

RUN apt-get update && apt-get install -y software-properties-common sudo git gcc g++ curl unzip tar gzip
RUN add-apt-repository ppa:neovim-ppa/stable && apt-get update && apt-get install -y neovim

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash

RUN addgroup --gid "${GID}" "${GNAME}" \
    && adduser --disabled-password -gid "${GID}" --uid "${UID}" -shell "/bin/bash" "${UNAME}" \
    && echo "${UNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers 


USER dev

RUN git clone https://github.com/mwyerman/neovim-configs.git /home/dev/.config/nvim

RUN cd /home/dev && LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[0-35.]+') \
    && curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
    && sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit && sudo chown -R dev:dev /home/dev/.config && mkdir /home/dev/.config/lazygit && rm /home/dev/lazygit.tar.gz

RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    /home/dev/.local/share/nvim/site/pack/packer/start/packer.nvim
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
RUN nvim --headless -c 'TSInstallSync maintained' -c q
RUN nvim --headless -c 'LspInstall --sync bashls clangd cmake dockerls jsonls sumneko_lua prosemd_lsp powershell_es pylsp yamlls' -c q
