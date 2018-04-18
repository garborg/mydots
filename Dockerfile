FROM debian:buster

RUN apt-get update && apt-get install -y \
  bash-completion build-essential curl git man

ENV hm /
ENV inst /usr/local

WORKDIR $hm

#
# utils
#

RUN apt-get install -y \
  silversearcher-ag \
  python3-pip

RUN git clone --depth 1 https://github.com/junegunn/fzf.git ${hm}/.fzf \
  && HOME=${hm} ${hm}/.fzf/install --all --no-update-rc

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
     --with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
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
  prettier
  # \
  # js-beautify \
  # eslint
  # https://prettier.io/docs/en/eslint.html
  # https://github.com/prettier/prettier-eslint

#
# python
#

RUN pip3 install \
  black \
  isort \
  mypy \
  jedi \
  pyflakes \
  pylint

#
# vim package deps
#

# ctags
RUN  apt-get install -y \
  autoconf
# &&  ./configure # --prefix=/where/you/want # defaults to /usr/local \
RUN cd ${inst} \
  && git clone https://github.com/universal-ctags/ctags.git \
  && cd ctags \
  &&  ./autogen.sh \
  &&  ./configure \
  && make \
  && make install

#
# dots
#

RUN npm install -g \
  eslint-config-react-app

# adhoc/nameless/unmapped users get '/' for a $HOME
# i.e. without: RUN echo "sean:x:1001:1001:Sean Garborg,,,:/home/sean:/bin/bash" >> /etc/passwd

COPY ./ ${hm}/mydots/
RUN cd ${hm}/mydots && HOME=${hm} ./linkdots.sh

#
# vim packages
#

RUN ls -al ${hm}
RUN HOME=${hm} vim -eNu ${hm}/.vimrc +PlugInstall +qa

WORKDIR /usr/src

ENTRYPOINT ["bash"]
