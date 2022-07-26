# Description

This repository contains derivations for various OS images, e.g. AWS AMIs with custom kernel and Enarx pre-installed and pre-configured.

# Dependencies

[Nix](https://nixos.org/download.html#download-nix) is the only dependency of this project.

Use `nix develop` (from a local checkout) or `nix develop github:profianinc/images` (directly from GitHub) to start a development shell with all commands and possible dependencies in scope.

# AWS AMI

## Bootstrapping

This is a one-time procedure, commands assume empty AWS account.

See https://docs.aws.amazon.com/vm-import/latest/userguide/vmie_prereqs.html#vmimport-role for more details.

### From a `nix develop` shell

```sh
$ aws-create-vmimport-role
$ aws-put-vmimport-role-policy
```

### From a local checkout

```sh
$ nix run '.#aws-create-vmimport-role'
$ nix run '.#aws-put-vmimport-role-policy'
```

### Directly from GitHub without cloning this repository

```sh
$ nix run 'github:profianinc/images#aws-create-vmimport-role'
$ nix run 'github:profianinc/images#aws-put-vmimport-role-policy'
```

## Build and Publish

### From a local checkout

```sh
$ nix build '.#enarx-sev-amazon'
$ nix run '.#aws-create-ami' ./result
```

### From a `nix develop` shell

```sh
$ nix build '.#enarx-sev-amazon'
$ aws-create-ami ./result
```

### Directly from GitHub without cloning this repository

```sh
$ nix build 'github:profianinc/images#enarx-sev-amazon'
$ nix run 'github:profianinc/images#aws-create-ami' ./result
```
