# -----------------------------------------------------------------------------
# Continuous integration Docker image for elementaryOS Juno
# Base:   ubuntu     [bionic]
# Distro: elementary [juno]
# -----------------------------------------------------------------------------
# ubuntu:
# The base distro.
# -----------------------------------------------------------------------------
FROM ubuntu:bionic as ubuntu
ENV DEBIAN_FRONTEND=noninteractive

# Update:
RUN apt-get -y update
RUN apt-get -y upgrade

# Packages:
RUN apt-get -y install apt-utils
RUN apt-get -y install software-properties-common

# Cleanup:
RUN apt-get -y autoremove
RUN apt-get -y clean

# -----------------------------------------------------------------------------
# elementaryos:
# Sources, packages, and patches specific to elementaryOS.
# -----------------------------------------------------------------------------
FROM ubuntu as elementaryos
ENV DEBIAN_FRONTEND=noninteractive

# Sources:
COPY sources.list.d/* /etc/apt/sources.list.d/
COPY trusted.gpg.d/* /etc/apt/trusted.gpg.d/

# Update:
RUN apt-get -y update
RUN apt-get -y upgrade

# Cleanup:
RUN apt-get -y autoremove
RUN apt-get -y clean

# -----------------------------------------------------------------------------
# base:
# Tools used to build this image.
# -----------------------------------------------------------------------------
FROM elementaryos as base

# Install package managers:
RUN apt-get -y update
RUN apt-get -y install coreutils
RUN apt-get -y install python3-pip

# Copy install scripts:
RUN mkdir -p "/install/list"
RUN mkdir -p "/install/tool"
RUN touch "/install/list/.null"
RUN mkdir -p "/var/cache/apt/archives"
RUN mkdir -p "/var/cache/pip3/archives"
RUN touch "/var/cache/apt/archives/.null"
RUN touch "/var/cache/pip3/archives/.null"

COPY tools/apt  /install/tool/
COPY tools/pip3 /install/tool/

# -----------------------------------------------------------------------------
# download_compilers:
# Compilers.
# -----------------------------------------------------------------------------
FROM base as download_compilers

RUN /install/tool/apt gcc
RUN /install/tool/apt g++
RUN /install/tool/apt valac

# -----------------------------------------------------------------------------
# download_buildsystems:
# Build systems.
# -----------------------------------------------------------------------------
FROM base as download_buildsystems
ENV DEBIAN_FRONTEND=noninteractive

RUN /install/tool/apt make
RUN /install/tool/apt cmake
RUN /install/tool/apt autoconf
RUN /install/tool/pip3 meson
RUN /install/tool/pip3 ninja

# -----------------------------------------------------------------------------
# download_devtools:
# Developer tools.
# -----------------------------------------------------------------------------
FROM base as download_devtools

RUN add-apt-repository -y ppa:git-core/ppa 
RUN apt-get -y update

# Packages:
RUN /install/tool/apt gnupg1
RUN /install/tool/apt gnupg2
RUN /install/tool/apt git
RUN /install/tool/apt git-lfs
RUN /install/tool/apt zip
RUN /install/tool/apt unzip
RUN /install/tool/apt xz-utils
RUN /install/tool/apt tar

# -----------------------------------------------------------------------------
# download_libraries:
# Developer headers and libraries.
# -----------------------------------------------------------------------------
FROM base as download_libraries

# Packages:
RUN /install/tool/apt libgee-0.8-dev
RUN /install/tool/apt libgirepository1.0-dev
RUN /install/tool/apt libgtk-3-dev
RUN /install/tool/apt libgranite-dev

# -----------------------------------------------------------------------------
# install:
# Install everything.
# -----------------------------------------------------------------------------
FROM base as install

COPY --from=download_compilers    /etc/apt/sources.list.d/*  /etc/apt/sources.list.d/
COPY --from=download_compilers    /etc/apt/trusted.gpg.d/*   /etc/apt/trusted.gpg.d/
COPY --from=download_compilers    /var/cache/apt/archives/*  /var/cache/apt/archives/
COPY --from=download_compilers    /var/cache/pip3/archives/* /var/cache/pip3/archives/
COPY --from=download_compilers    /install/list/*            /install/list/

COPY --from=download_buildsystems /etc/apt/sources.list.d/*  /etc/apt/sources.list.d/
COPY --from=download_buildsystems /etc/apt/trusted.gpg.d/*   /etc/apt/trusted.gpg.d/
COPY --from=download_buildsystems /var/cache/apt/archives/*  /var/cache/apt/archives/
COPY --from=download_buildsystems /var/cache/pip3/archives/* /var/cache/pip3/archives/
COPY --from=download_buildsystems /install/list/*            /install/list/

COPY --from=download_devtools     /etc/apt/sources.list.d/*  /etc/apt/sources.list.d/
COPY --from=download_devtools     /etc/apt/trusted.gpg.d/*   /etc/apt/trusted.gpg.d/
COPY --from=download_devtools     /var/cache/apt/archives/*  /var/cache/apt/archives/
COPY --from=download_devtools     /var/cache/pip3/archives/* /var/cache/apt/archives/
COPY --from=download_devtools     /install/list/*            /install/list/

COPY --from=download_libraries    /etc/apt/sources.list.d/*  /etc/apt/sources.list.d/
COPY --from=download_libraries    /etc/apt/trusted.gpg.d/*   /etc/apt/trusted.gpg.d/
COPY --from=download_libraries    /var/cache/apt/archives/*  /var/cache/apt/archives/
COPY --from=download_libraries    /var/cache/pip3/archives/* /var/cache/apt/archives/
COPY --from=download_libraries    /install/list/*            /install/list/

# Refresh:
RUN mv /var/cache/apt/archives /var/cache/apt/archives.backup
RUN apt-get -y update
RUN mv /var/cache/apt/archives.backup /var/cache/apt/archives

# Install:
COPY tools/apt-install /install/tool/
RUN /install/tool/apt-install

COPY tools/pip3-install /install/tool/
RUN /install/tool/pip3-install

# Update:
RUN apt-get -y upgrade

# Cleanup:
RUN apt-get -y autoremove
RUN apt-get -y clean
RUN rm -rf /tmp/*
RUN rm -rf /var/cache/apt/archives/*
RUN rm -rf /var/cache/pip3/archives/*
RUN rm -rf /install

# -----------------------------------------------------------------------------
# final:
# The final image.
# -----------------------------------------------------------------------------
FROM scratch
COPY --from=install / /

LABEL maintainer="eth-p+docker@hidden.email"
LABEL distro="elementary"
LABEL distro_codename="juno"

