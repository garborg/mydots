FROM debian:latest

RUN apt-get update && apt-get install -y \
  build-essential git curl

ENV hm /
ENV inst /usr/local

#
# utils
#

RUN apt-get install -y \
  silversearcher-ag \
  python3-pip

# TODO: add the fzf flags
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ${hm}/.fzf \
  && ${hm}/.fzf/install
# --key-bindings --completion --no-update-rc

# ripgrep
RUN  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.8.1/ripgrep_0.8.1_amd64.deb \
  && dpkg -i ripgrep_0.8.1_amd64.deb \
  && rm ripgrep_0.8.1_amd64.deb

#
# vim
#

# look particularly gui-y
 # libgnome2-dev libgnomeui-dev \
 # libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
RUN  apt-get install -y \
  libncurses5-dev \
  libcairo2-dev libx11-dev libxpm-dev libxt-dev \
  python3-dev
  # python-dev \
  # ruby-dev lua5.1 lua5.1-dev libperl-dev

RUN git clone https://github.com/vim/vim ${inst}/vim \
  && cd ${inst}/vim \
  && ./configure \
     --with-features=big \
     --enable-multibyte \
     --enable-terminal \
     --enable-fail-if-missing \
     --enable-python3interp \
     --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
     --disable-gui \
     --disable-netbeans \
  && make install

# --enable-luainterp \
# --with-luajit \

# check for ['channel', 'job', 'terminal', 'timers', 'python3', etc.]


#
# html
#

RUN apt-get install -y tidy

#
# javascript
#

# nvm | https://github.com/creationix/nvm
# RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
# RUN . ${hm}/.nvm/nvm.sh \
#     && nvm install node
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash - \
  && apt-get install -y nodejs
RUN npm install -g npm@latest

RUN npm install -g \
  javascript-typescript-langserver \
  prettier \
  js-beautify \
  eslint

#
# python
#

RUN pip3 install \
  yapf \
  mypy \
  jedi \
  flake8 \
  pylint

#
# dots
#

# adhoc/nameless/unmapped users get '/' for a $HOME
# i.e. without: RUN echo "sean:x:1001:1001:Sean Garborg,,,:/home/sean:/bin/bash" >> /etc/passwd

COPY ./dots/* ${hm}

#
# vim packages
#

# ctags
RUN  apt-get install -y \
  autoconf
RUN cd ${inst} \
  && git clone https://github.com/universal-ctags/ctags.git \
  && cd ctags \
  &&  ./autogen.sh \
  &&  ./configure # --prefix=/where/you/want # defaults to /usr/local \
  && make \
  && sudo make install

# RUN vim -esNu ${hm}/.vimrc +PlugInstall +qa

WORKDIR /usr/src

ENTRYPOINT ["bash"]
