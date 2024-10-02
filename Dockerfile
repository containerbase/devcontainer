# renovate: datasource=docker depName=ghcr.io/containerbase/base
ARG CONTAINERBASE_VERSION=12.0.0

FROM ghcr.io/containerbase/base:${CONTAINERBASE_VERSION} as containerbase

FROM ghcr.io/containerbase/ubuntu:24.04@sha256:b359f1067efa76f37863778f7b6d0e8d911e3ee8efa807ad01fbf5dc1ef9006b

ARG CONTAINERBASE_VERSION
ARG APT_HTTP_PROXY

LABEL org.opencontainers.image.source="https://github.com/containerbase/devcontainer" \
      org.opencontainers.image.version="${CONTAINERBASE_VERSION}"

ARG USER_NAME=vscode
ARG USER_ID=1000
ARG PRIMARY_GROUP_ID=1000

# Set env and shell
ENV BASH_ENV=/usr/local/etc/env ENV=/usr/local/etc/env
SHELL ["/bin/bash" , "-c"]

# This entry point ensures that dumb-init is run
ENTRYPOINT [ "docker-entrypoint.sh" ]

# Set up containerbase
COPY --from=containerbase /usr/local/sbin/ /usr/local/sbin/
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
RUN install-tool git v2.46.2

# mark all directories as safe
RUN git config --system --add safe.directory '*'

# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v27.3.1

# renovate: datasource=github-releases packageName=containerbase/node-prebuild versioning=node
RUN install-tool node 20.17.0

# enable buildin corepack
RUN corepack enable

# renovate: datasource=github-releases packageName=containerbase/python-prebuild
RUN install-tool python 3.12.7

# prepare some tools for devcontainer
#RUN prepare-tool python

USER $USER_NAME

# disable anoying download promt
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

