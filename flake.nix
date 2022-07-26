{
  description = "Profian Inc images";

  inputs.flake-compat.flake = false;
  inputs.flake-compat.url = github:edolstra/flake-compat;
  inputs.flake-utils.url = github:numtide/flake-utils;
  inputs.infrastructure.inputs.nixpkgs.follows = "nixpkgs";
  inputs.infrastructure.url = github:profianinc/infrastructure;
  inputs.nixlib.url = github:nix-community/nixpkgs.lib;
  inputs.nixos-generators.inputs.nixlib.follows = "nixlib";
  inputs.nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixos-generators.url = github:nix-community/nixos-generators;
  inputs.nixpkgs.url = github:profianinc/nixpkgs;

  outputs = inputs @ {
    self,
    flake-utils,
    infrastructure,
    nixos-generators,
    nixpkgs,
    ...
  }:
    {
      nixosModules = import ./nixosModules inputs;
      overlays = import ./overlays inputs;
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
        with flake-utils.lib.system; let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              infrastructure.overlays.service
              self.overlays.default
            ];
          };

          is64BitLinux = system == x86_64-linux || system == aarch64-linux;

          packages = with pkgs;
            {
              inherit
                aws-create-ami
                aws-create-vmimport-role
                aws-put-vmimport-role-policy
                ;
            }
            // lib.optionalAttrs is64BitLinux {
              inherit
                enarx-sev-amazon
                enarx-sev-docker
                enarx-sev-hyperv
                enarx-sev-gce
                enarx-sev-kubevirt
                enarx-sev-lxc
                enarx-sev-lxc-metadata
                enarx-sev-openstack
                enarx-sev-proxmox
                enarx-sev-proxmox-lxc
                enarx-sev-qcow2
                ;
            }
            // lib.optionalAttrs (system == x86_64-linux) {
              inherit
                enarx-sev-azure
                enarx-sev-install-iso
                enarx-sev-install-iso-hyperv
                enarx-sgx-amazon
                enarx-sgx-azure
                enarx-sgx-docker
                enarx-sgx-gce
                enarx-sgx-hyperv
                enarx-sgx-install-iso
                enarx-sgx-install-iso-hyperv
                enarx-sgx-kubevirt
                enarx-sgx-lxc
                enarx-sgx-lxc-metadata
                enarx-sgx-openstack
                enarx-sgx-proxmox
                enarx-sgx-proxmox-lxc
                enarx-sgx-qcow2
                ;
            };
        in {
          inherit packages;

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nixUnstable

              aws-create-ami
              aws-create-vmimport-role
              aws-put-vmimport-role-policy
            ];
          };
          formatter = pkgs.alejandra;
        }
    );
}
