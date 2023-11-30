# containerbase gitpod

[![Build status](https://github.com/containerbase/gitpod/actions/workflows/build.yml/badge.svg)](https://github.com/containerbase/gitpod/actions/workflows/build.yml?query=branch%3Amain)
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/containerbase/gitpod)
![License: MIT](https://img.shields.io/github/license/containerbase/gitpod)

A docker base image for Gitpod usage.

This repository is the source for the Github container registry image [`ghcr.io/containerbase/gitpod`](https://github.com/containerbase/gitpod/pkgs/container/gitpod).
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
