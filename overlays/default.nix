inputs @ {nixlib, ...}: rec {
  images = import ./images.nix inputs;
  tooling = import ./tooling inputs;

  default = nixlib.lib.composeManyExtensions [
    images
    tooling
  ];
}
