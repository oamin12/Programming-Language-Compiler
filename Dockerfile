FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    flex \
    bison \
    make \
    && rm -rf /var/lib/apt/lists/*

RUN apt update -y && apt install build-essential -y
WORKDIR /app

VOLUME /app

CMD ["/bin/bash"]