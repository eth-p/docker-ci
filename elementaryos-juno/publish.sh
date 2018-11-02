#!/usr/bin/env bash
docker build -t ethp/ci-elementaryos:juno . &&\
docker push ethp/ci-elementaryos:juno

docker build -t ethp/ci-elementaryos:juno.x86_64 . &&\
docker push ethp/ci-elementaryos:juno.x86_64

