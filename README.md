# Pre-commit container

[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://stand-with-ukraine.pp.ua)
![GitHub release](https://img.shields.io/github/v/release/fabasoad/pre-commit-container?include_prereleases)
![security](https://github.com/fabasoad/pre-commit-container/actions/workflows/security.yml/badge.svg)
![linting](https://github.com/fabasoad/pre-commit-container/actions/workflows/linting.yml/badge.svg)

Docker container that contains all the tools needed for correct work of pre-commit
hooks in <https://github.com/fabasoad/> repositories.

## This is not a pre-commit hook repo

This repository cannot be used as a `repo:` in `.pre-commit-config.yaml`.
It has no `.pre-commit-hooks.yaml`, so adding it there will fail:

```yaml
# Do not do this - it will not work
repos:
  - repo: https://github.com/fabasoad/pre-commit-container
```

This repo only builds and publishes the shared Docker image
`ghcr.io/fabasoad/pre-commit-container`. That image provides the tools
the hook repos below need, for example as the CI container in which
pre-commit runs. To run a hook, use one of those hook repos in your
`.pre-commit-config.yaml` instead:

| Hook repo                                                                  | Hooks for  |
| -------------------------------------------------------------------------- | ---------- |
| [pre-commit-bearer](https://github.com/fabasoad/pre-commit-bearer)         | Bearer     |
| [pre-commit-checkstyle](https://github.com/fabasoad/pre-commit-checkstyle) | Checkstyle |
| [pre-commit-grype](https://github.com/fabasoad/pre-commit-grype)           | Grype      |
| [pre-commit-snyk](https://github.com/fabasoad/pre-commit-snyk)             | Snyk       |
| [pre-commit-vulncheck](https://github.com/fabasoad/pre-commit-vulncheck)   | VulnCheck  |

## Contributions

![Alt](https://repobeats.axiom.co/api/embed/4a5d0a359b6a2e87c1ac778a5eab2abc82440695.svg "Repobeats analytics image")
