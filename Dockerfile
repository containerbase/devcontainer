# renovate: datasource=docker depName=ghcr.io/containerbase/base
ARG CONTAINERBASE_VERSION=13.8.56

FROM ghcr.io/containerbase/base:${CONTAINERBASE_VERSION} as containerbase

FROM ghcr.io/containerbase/ubuntu:24.04@sha256:440dcf6a5640b2ae5c77724e68787a906afb8ddee98bf86db94eea8528c2c076

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
RUN install-tool git v2.50.1

# mark all directories as safe
RUN git config --system --add safe.directory '*'

# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v28.3.2

# renovate: datasource=github-releases packageName=containerbase/node-prebuild versioning=node
RUN install-tool node 22.17.0

# renovate: datasource=npm
RUN install-tool pnpm 10.13.1

# renovate: datasource=github-releases packageName=containerbase/python-prebuild
RUN install-tool python 3.13.5


USER $USER_NAME
