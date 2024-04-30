# renovate: datasource=docker depName=ghcr.io/containerbase/base
ARG CONTAINERBASE_VERSION=10.3.18

FROM ghcr.io/containerbase/base:${CONTAINERBASE_VERSION} as containerbase

FROM ubuntu:22.04@sha256:6d7b5d3317a71adb5e175640150e44b8b9a9401a7dd394f44840626aff9fa94d

ARG CONTAINERBASE_VERSION
ARG APT_HTTP_PROXY

LABEL org.opencontainers.image.source="https://github.com/containerbase/devcontainer" \
      org.opencontainers.image.version="${CONTAINERBASE_VERSION}"

# Compatibillity
LABEL org.label-schema.vcs-url="https://github.com/containerbase/devcontainer" \
      org.label-schema.version="${CONTAINERBASE_VERSION}"

ARG USER_NAME=vscode
ARG USER_ID=1000
ARG PRIMARY_GROUP_ID=1000

# Set env and shell
ENV BASH_ENV=/usr/local/etc/env ENV=/usr/local/etc/env PATH=/home/$USER_NAME/bin:$PATH
SHELL ["/bin/bash" , "-c"]

# This entry point ensures that dumb-init is run
ENTRYPOINT [ "docker-entrypoint.sh" ]

# Set up containerbase
COPY --from=containerbase /usr/local/bin/ /usr/local/bin/
COPY --from=containerbase /usr/local/containerbase/ /usr/local/containerbase/
RUN install-containerbase

# add required devcontainer and other system packages
RUN set -ex; \
  install-apt \
    g++ \
    locales \
    make \
    shellcheck \
    sudo \
    ; \
  locale-gen en_US.UTF-8; \
  true

# allow sudo without password
RUN set e; \
  echo "$USER_NAME ALL = NOPASSWD: ALL" > /etc/sudoers.d/$USER_NAME; \
  chmod 0440 /etc/sudoers.d/$USERNAME; \
  sudo id; \
  true

# renovate: datasource=github-tags packageName=git/git
RUN install-tool git v2.44.0

# mark all directories as safe
RUN git config --system --add safe.directory '*'

# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v26.1.0

# renovate: datasource=github-releases packageName=containerbase/node-prebuild versioning=node
RUN install-tool node 20.12.2

# enable buildin corepack
RUN corepack enable

# renovate: datasource=github-releases packageName=containerbase/python-prebuild
RUN install-tool python 3.12.3

# prepare some tools for devcontainer
#RUN prepare-tool python

USER $USER_NAME
