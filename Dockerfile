# renovate: datasource=docker depName=ghcr.io/containerbase/base
ARG CONTAINERBASE_VERSION=14.49.0

FROM ghcr.io/containerbase/base:${CONTAINERBASE_VERSION} AS containerbase

FROM ghcr.io/containerbase/ubuntu:24.04@sha256:68ee22004a9109b44973313b02ff7b1de250f1de0f5ecb628d73f579aaff33ac

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
RUN install-tool git v2.56.0

# mark all directories as safe
RUN git config --system --add safe.directory '*'

# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v28.5.2

# renovate: datasource=github-releases packageName=docker/buildx
RUN install-tool buildx v0.38.1

# renovate: datasource=github-releases packageName=docker/compose
RUN install-tool docker-compose v5.6.1

# renovate: datasource=github-releases packageName=containerbase/node-prebuild versioning=node
RUN install-tool node 24.22.1

# renovate: datasource=npm
RUN install-tool pnpm 12.14.0

# renovate: datasource=github-releases packageName=containerbase/python-prebuild
RUN install-tool python 3.15.1

# renovate: datasource=github-releases packageName=felipecrs/fixdockergid
ARG FIXDOCKERGID_VERSION=0.8.1
ARG USERNAME=$USER_NAME
RUN curl -fsSL "https://github.com/felipecrs/fixdockergid/raw/v${FIXDOCKERGID_VERSION}/install.sh" | sh -

# This entry point ensures that dumb-init and fixdockergid is run
ENTRYPOINT [ "docker-entrypoint.sh", "fixdockergid" ]
CMD [ "sleep", "infinity" ]

USER $USER_NAME
