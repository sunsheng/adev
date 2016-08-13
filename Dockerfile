FROM ubuntu:16.04
MAINTAINER lysu <sulifx@gmail.com>

# OpenSSH is required to run MPI applications
RUN apt-get update &&  apt-get install  -y \
    build-essential \
    cmake \
    curl \
    git \
    libboost-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-regex-dev \
    libboost-system-dev \
    libboost-thread-dev \
    libopenmpi-dev \
    openmpi-bin \
    openmpi-common  \
    openssh-client \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN cd /tmp \
 && curl https://www.samba.org/ftp/ccache/ccache-3.2.5.tar.xz | tar xJ \
 && cd ccache-3.2.5 \
 && ./configure \
 && make \
 && make install \
 && cd \
 && rm -r /tmp/ccache-3.2.5

ENV CCACHE_DIR=/ccache

RUN apt-get update &&  apt-get install  -y \
    clang-3.7 \
    libomp-dev \
    vim \
    emacs \
    netcat \
    unzip \
    valgrind \
    net-tools \
    doxygen \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/clang   clang   /usr/bin/clang-3.7 999 \
 && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.7 999 \
 && update-alternatives --install /usr/bin/cc  cc  /usr/bin/clang-3.7 999 \
 && update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-3.7 999

ENV CC="ccache clang" CXX="ccache clang++"

RUN git clone git://github.com/amix/vimrc.git ~/.vim_runtime \
    sh ~/.vim_runtime/install_basic_vimrc.sh

RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    chsh -s /bin/zsh
