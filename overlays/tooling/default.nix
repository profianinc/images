inputs @ {nixlib, ...}:
nixlib.lib.composeManyExtensions [
  (import ./aws.nix inputs)
]
