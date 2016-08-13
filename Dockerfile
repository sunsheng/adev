FROM debian:latest
MAINTAINER lysu <sulifx@gmail.com>

RUN apt-get update && apt-get -y install \
  build-essential \
  git \
  python \
  wget \
  rsync \
  xz-utils \
  llvm \
  clang \
  vim && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ENV CC=clang
ENV CXX=clang++

