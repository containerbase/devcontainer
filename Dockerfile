# renovate: datasource=docker depName=ghcr.io/containerbase/base
ARG CONTAINERBASE_VERSION=9.26.0

FROM ghcr.io/containerbase/base:${CONTAINERBASE_VERSION} as containerbase

FROM ubuntu:22.04@sha256:2b7412e6465c3c7fc5bb21d3e6f1917c167358449fecac8176c6e496e5c1f05f

ARG CONTAINERBASE_VERSION
ARG APT_HTTP_PROXY

LABEL org.opencontainers.image.source="https://github.com/containerbase/gitpod" \
      org.opencontainers.image.version="${CONTAINERBASE_VERSION}"

# Compatibillity
LABEL org.label-schema.vcs-url="https://github.com/containerbase/gitpod" \
      org.label-schema.version="${CONTAINERBASE_VERSION}"

ARG USER_NAME=gitpod
ARG USER_ID=33333
ARG PRIMARY_GROUP_ID=33333

# Set env and shell
ENV BASH_ENV=/usr/local/etc/env ENV=/usr/local/etc/env PATH=/home/$USER_NAME/bin:$PATH
SHELL ["/bin/bash" , "-c"]

# This entry point ensures that dumb-init is run
ENTRYPOINT [ "docker-entrypoint.sh" ]

# Set up containerbase
COPY --from=containerbase /usr/local/bin/ /usr/local/bin/
COPY --from=containerbase /usr/local/containerbase/ /usr/local/containerbase/
RUN install-containerbase

# add required gitpod packages
RUN set -ex; \
  install-apt make shellcheck sudo locales; \
  locale-gen en_US.UTF-8; \
  true

# allow sudo without password
RUN echo "gitpod ALL=NOPASSWD:ALL" > /etc/sudoers.d/gitpod; sudo id

# renovate: datasource=github-tags packageName=git/git
RUN install-tool git v2.43.0

# mark all directories as safe
RUN git config --system --add safe.directory '*'

# renovate: datasource=github-releases lookupName=moby/moby
RUN install-tool docker v24.0.7

# renovate: datasource=node-version
RUN install-tool node 20.10.0

# renovate: datasource=npm
RUN install-tool corepack 0.23.0

# prepare some tools for gitpod
RUN prepare-tool python

USER gitpod
