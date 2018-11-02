# -----------------------------------------------------------------------------
# Continuous integration Docker image for elementaryOS Juno
# Base: ubuntu [bionic]
# -----------------------------------------------------------------------------

FROM ubuntu:bionic
MAINTAINER Ethan P <eth-p+docker@hidden.email>
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y install software-properties-common

# Sources:
COPY sources.list.d/* /etc/apt/sources.list.d/
COPY trusted.gpg.d/* /etc/apt/trusted.gpg.d/
RUN add-apt-repository -y ppa:git-core/ppa 

# Dependencies:
RUN apt-get -y install apt-utils
RUN apt-get -y upgrade

# Package Managers:
RUN apt-get -y install python3-pip

# Tooling: Version Control
RUN apt-get -y install gnupg1 gnupg2
RUN apt-get -y install git git-lfs

# Tooling: Build Systems
RUN apt-get -y install make
RUN apt-get -y install cmake
RUN apt-get -y install autoconf
RUN pip3 install meson

# Compilers:
RUN apt-get -y install gcc
RUN apt-get -y install g++
RUN apt-get -y install valac

# Libraries:
RUN apt-get -y install libgee-0.8-dev
RUN apt-get -y install libgirepository1.0-dev
RUN apt-get -y install libgtk-3-dev
RUN apt-get -y install libgranite-dev

