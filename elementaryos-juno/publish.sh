#!/usr/bin/env bash
docker build -t ethp/ci-elementaryos:juno . &&\
docker push ethp/ci-elementaryos:juno

