inputs @ {
  self,
  infrastructure,
  nixos-generators,
  ...
}: final: prev: let
  mkEnarxImage = format: modules:
    nixos-generators.nixosGenerate {
      inherit format;
      pkgs = final;
      modules =
        [
          infrastructure.nixosModules.common
          ({pkgs, ...}: {
            environment.systemPackages = with pkgs; [enarx];

            networking.firewall.allowedTCPPorts = [
              80
              443
            ];

            nixpkgs.overlays = [infrastructure.overlays.service];

            services.enarx.enable = true;
          })
        ]
        ++ modules;
    };

  mkEnarxSevImage = format: modules:
    mkEnarxImage format ([
        {
          boot.kernelModules = [
            "kvm-amd"
          ];
          boot.kernelPackages = final.linuxPackages_enarx;

          hardware.cpu.amd.sev.enable = true;
          hardware.cpu.amd.sev.mode = "0777";

          hardware.cpu.amd.updateMicrocode = true;

          services.enarx.backend = "sev";
        }
      ]
      ++ modules);

  enarx-sev-amazon = final.mkEnarxSevImage "amazon" [self.nixosModules.amazon];
  enarx-sev-azure = final.mkEnarxSevImage "azure" [];
  enarx-sev-docker = final.mkEnarxSevImage "docker" [self.nixosModules.docker];
  enarx-sev-hyperv = final.mkEnarxSevImage "hyperv" [];
  enarx-sev-install-iso = final.mkEnarxSevImage "install-iso" [self.nixosModules.iso];
  enarx-sev-install-iso-hyperv = final.mkEnarxSevImage "install-iso-hyperv" [self.nixosModules.iso];
  enarx-sev-kubevirt = final.mkEnarxSevImage "kubevirt" [];
  enarx-sev-lxc = final.mkEnarxSevImage "lxc" [];
  enarx-sev-lxc-metadata = final.mkEnarxSevImage "lxc-metadata" [];
  enarx-sev-openstack = final.mkEnarxSevImage "openstack" [];
  enarx-sev-proxmox = final.mkEnarxSevImage "proxmox" [];
  enarx-sev-proxmox-lxc = final.mkEnarxSevImage "proxmox-lxc" [];
  enarx-sev-qcow2 = final.mkEnarxSevImage "qcow" [];

  mkEnarxSgxImage = format: modules:
    mkEnarxImage format ([
        {
          boot.kernelModules = [
            "kvm-intel"
          ];
          boot.kernelPackages = final.linuxPackages_enarx;

          hardware.cpu.intel.sgx.provision.enable = true;

          hardware.cpu.intel.updateMicrocode = true;

          services.aesmd.enable = true;

          services.enarx.backend = "sgx";
        }
      ]
      ++ modules);

  enarx-sgx-amazon = final.mkEnarxSgxImage "amazon" [self.nixosModules.amazon];
  enarx-sgx-azure = final.mkEnarxSgxImage "azure" [];
  enarx-sgx-docker = final.mkEnarxSgxImage "docker" [self.nixosModules.docker];
  enarx-sgx-hyperv = final.mkEnarxSgxImage "hyperv" [];
  enarx-sgx-install-iso = final.mkEnarxSgxImage "install-iso" [self.nixosModules.iso];
  enarx-sgx-install-iso-hyperv = final.mkEnarxSgxImage "install-iso-hyperv" [self.nixosModules.iso];
  enarx-sgx-kubevirt = final.mkEnarxSgxImage "kubevirt" [];
  enarx-sgx-lxc = final.mkEnarxSgxImage "lxc" [];
  enarx-sgx-lxc-metadata = final.mkEnarxSgxImage "lxc-metadata" [];
  enarx-sgx-openstack = final.mkEnarxSgxImage "openstack" [];
  enarx-sgx-proxmox = final.mkEnarxSgxImage "proxmox" [];
  enarx-sgx-proxmox-lxc = final.mkEnarxSgxImage "proxmox-lxc" [];
  enarx-sgx-qcow2 = final.mkEnarxSgxImage "qcow" [];
in {
  inherit
    mkEnarxImage
    mkEnarxSevImage
    mkEnarxSgxImage
    enarx-sev-amazon
    enarx-sev-azure
    enarx-sev-docker
    enarx-sev-hyperv
    enarx-sev-install-iso
    enarx-sev-install-iso-hyperv
    enarx-sev-kubevirt
    enarx-sev-lxc
    enarx-sev-lxc-metadata
    enarx-sev-openstack
    enarx-sev-proxmox
    enarx-sev-proxmox-lxc
    enarx-sev-qcow2
    enarx-sgx-amazon
    enarx-sgx-azure
    enarx-sgx-docker
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
}
