FROM debian:latest
MAINTAINER lysu <sulifx@gmail.com>

RUN apt-get update && apt-get -y install \
  build-essential \
  git \
  python \
  wget \
  rsync \
  xz-utils \
  llvm-3.8.1 \
  clang-3.8.1 \
  vim && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ENV CC=clang
ENV CXX=clang++

# Compiler-rt
WORKDIR /usr/src
RUN wget http://llvm.org/releases/3.8.1/compiler-rt-3.8.1.src.tar.xz
RUN tar -Jxf compiler-rt-3.8.1.src.tar.xz
RUN mkdir build-compiler-rt
WORKDIR /usr/src/build-compiler-rt
RUN cmake ../compiler-rt-3.8.1.src -DCMAKE_BUILD_TYPE=Release -DLLVM_CONFIG_PATH=/usr/local/bin/llvm-config
RUN make -j$(nproc) install && make clean

RUN mkdir /usr/local/lib/clang/3.8.1/lib
RUN ln -s /usr/local/lib/linux /usr/local/lib/clang/3.8.1/lib/linux

