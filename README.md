<!-- omit in toc -->
# `citools`

Tools for crafting good CI pipelines.

<!-- omit in toc -->
## Contents

* [Nix + Docker](#nix--docker)
  * [Build and upload a Nix-based Docker image](#build-and-upload-a-nix-based-docker-image)

## Nix + Docker

### Build and upload a Nix-based Docker image

Usage: `nix run github:LightAndLight/citools#uploadDockerImage -- URI FILE`

Example: `nix run github:LightAndLight/citools#uploadDockerImage -- docker.io image.nix`

Arguments:

* `URI` - Docker registry URI
* `FILE` - A Nix file containing a
  [`dockerTools`](https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-dockerTools) Docker image derivation