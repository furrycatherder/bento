{ lib }:

pkg:

pkg.overrideAttrs (super: {
  NIX_CFLAGS_COMPILE = lib.concatStringsSep " " [
    (super.NIX_CFLAGS_COMPILE or "")
    "-fPIC" "-O3" "-march=native"
  ];
})
