FROM ubuntu:20.04

RUN apt-get update \
  && apt-get install -y git vim zsh curl sudo \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root

ENV SHELL /bin/zsh

CMD ["zsh"]
