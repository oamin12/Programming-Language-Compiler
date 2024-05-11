FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    flex \
    bison \
    make \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . /app

RUN yacc -d parser.y
RUN lex lexical.l
RUN cc lex.yy.c y.tab.c -o compiler.out
CMD ["/bin/bash"]