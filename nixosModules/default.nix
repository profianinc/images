{...}: {
  amazon = {...}: {
    amazonImage.sizeMB = 12 * 1024; # TODO: Figure out how much we actually need
    ec2.ena = false;
  };

  docker = {lib, ...}: {
    networking.firewall.enable = lib.mkForce false;

    services.openssh.startWhenNeeded = lib.mkForce false;
  };

  iso = {lib, ...}: {
    boot.supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];
  };
}
