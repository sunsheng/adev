FROM debian:latest
MAINTAINER lysu <sulifx@gmail.com>

RUN apt-get update && apt-get -y install \
  build-essential \
  git \
  python \
  wget \
  rsync \
  xz-utils \
  vim && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Build and install CMake from source.
WORKDIR /usr/src
RUN git clone https://github.com/Kitware/CMake.git CMake && \
  cd CMake && \
  git checkout v3.4.0
RUN mkdir CMake-build
WORKDIR /usr/src/CMake-build
RUN /usr/src/CMake/bootstrap \
    --parallel=$(nproc) \
    --prefix=/usr && \
  make -j$(nproc) install && \
  rm -rf *
WORKDIR /usr/src

# Install LLVM, see http://llvm.org/docs/CMake.html
RUN wget http://llvm.org/releases/3.7.0/llvm-3.7.0.src.tar.xz
RUN tar -Jxf llvm-3.7.0.src.tar.xz
RUN mkdir build-llvm
WORKDIR /usr/src/build-llvm
RUN cmake ../llvm-3.7.0.src -DCMAKE_BUILD_TYPE=Release
RUN make -j$(nproc) install && make clean

# Clang
WORKDIR /usr/src
RUN wget http://llvm.org/releases/3.7.0/cfe-3.7.0.src.tar.xz
RUN tar -Jxf cfe-3.7.0.src.tar.xz
RUN mkdir build-cfe
WORKDIR /usr/src/build-cfe
RUN cmake ../cfe-3.7.0.src -DCMAKE_BUILD_TYPE=Release -DLLVM_CONFIG_PATH=/usr/local/bin/llvm-config
RUN make -j$(nproc) install && make clean

ENV CC=clang
ENV CXX=clang++

# Compiler-rt
WORKDIR /usr/src
RUN wget http://llvm.org/releases/3.7.0/compiler-rt-3.7.0.src.tar.xz
RUN tar -Jxf compiler-rt-3.7.0.src.tar.xz
RUN mkdir build-compiler-rt
WORKDIR /usr/src/build-compiler-rt
RUN cmake ../compiler-rt-3.7.0.src -DCMAKE_BUILD_TYPE=Release -DLLVM_CONFIG_PATH=/usr/local/bin/llvm-config
RUN make -j$(nproc) install && make clean

RUN mkdir /usr/local/lib/clang/3.7.0/lib
RUN ln -s /usr/local/lib/linux /usr/local/lib/clang/3.7.0/lib/linux

WORKDIR /usr/src

ENTRYPOINT[ "bash" ]
