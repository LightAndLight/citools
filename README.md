<!-- omit in toc -->
# `citools`

Tools for crafting good CI pipelines.

<!-- omit in toc -->
## Contents

* [Nix + Docker](#nix--docker)
  * [Build and upload a Nix-based Docker image](#build-and-upload-a-nix-based-docker-image)
* [Testing](#testing)

## Nix + Docker

### Build and upload a Nix-based Docker image

Usage: `nix run github:LightAndLight/citools#uploadDockerImage -- URI FILE`

Example: `nix run github:LightAndLight/citools#uploadDockerImage -- docker.io image.nix`

Arguments:

* `URI` - Docker registry URI
* `FILE` - A Nix file containing a
  [`dockerTools`](https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-dockerTools) Docker image derivation

## Testing

* `nix build github:LightAndLight/citools#testPackage`

  A derivation with few dependencies that's easy to build. Good for testing Nix flake
  compatibility, and debugging
  [post-build hooks](https://nixos.org/manual/nix/stable/advanced-topics/post-build-hook).