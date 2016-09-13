FROM centos:7
MAINTAINER lysu <sulifx@gmail.com>

# OpenSSH is required to run MPI applications
RUN yum update &&  yum install -y epel-release
RUN yum install -y \
    man \
    cmake \
    git \
    clang \
    vim \
    emacs \
    unzip \
    valgrind \
    net-tools \
    doxygen \
    tmux \
    cscope \
    make \
    gcc \
    gcc-c++ \
    openssl-devel \
    gdb \
    zsh \
    ctags \
    xdg-utils \
    python-setuptools \
    rubygems \
    fontconfig \
    psmisc \
    tcpdump \
    autoconf \
    boost-devel \
    openmpi-devel \
    python-devel \
    libxml2-devel \
    glib2-devel \
    gsl-devel \
    curl-devel \
    python-pip \
    ack \
 && yum clean all

RUN update-alternatives --install /usr/bin/clang   clang   /usr/bin/clang 999 \
 && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++ 999 \
 && update-alternatives --install /usr/bin/cc  cc  /usr/bin/clang 999 \
 && update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 999


RUN git clone git://github.com/amix/vimrc.git ~/.vim_runtime \
    && sh ~/.vim_runtime/install_awesome_vimrc.sh

RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && chsh -s /bin/zsh

RUN git clone https://github.com/Valloric/YouCompleteMe ~/.vim_runtime/sources_non_forked/YouCompleteMe

RUN cd ~/.vim_runtime/sources_non_forked/YouCompleteMe && git submodule update --init --recursive && ./install.sh --clang-completer

ENV CC="clang" CXX="clang++"

RUN git clone https://github.com/rhysd/vim-clang-format.git ~/.vim_runtime/sources_non_forked/vim-clang-format

ADD my_configs.vim /root/.vim_runtime/my_configs.vim
ADD ycm_extra_conf.py /root/.ycm_extra_conf.py
ADD tmux.conf /root/.tmux.conf
ENV TERM=xterm-256color
