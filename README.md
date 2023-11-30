# containerbase devcontainer

[![Build status](https://github.com/containerbase/devcontainer/actions/workflows/build.yml/badge.svg)](https://github.com/containerbase/devcontainer/actions/workflows/build.yml?query=branch%3Amain)
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/containerbase/devcontainer)
![License: MIT](https://img.shields.io/github/license/containerbase/devcontainer)

A Docker base image for Visual Studio Code Dev Containers usage.

This repository is the source for the Github container registry image [`ghcr.io/containerbase/devcontainer`](https://github.com/containerbase/devcontainer/pkgs/container/devcontainer).
Commits to `main` branch are automatically build and published.

This image allows `sudo` without password.
It's setting all directiories as safe for git.

Additional installed packages:

- docker
- git
- g++
- make
- nodejs (corepack enabled)
- locales
- python
- shellcheck
- sudo
